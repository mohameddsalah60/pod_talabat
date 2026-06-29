import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/transfer_invoice_item.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/services/invoice_pdf_launcher.dart';
import '../../data/services/transfer_invoice_pdf_generator.dart';
import '../mappers/transfer_invoice_mapper.dart';
import 'ware_flow_state.dart';

class WareFlowCubit extends Cubit<WareFlowState> {
  WareFlowCubit({
    ProductRepository? productRepository,
    InvoiceRepository? invoiceRepository,
    TransferInvoicePdfGenerator? pdfGenerator,
  }) : _productRepository = productRepository ?? ProductRepository(),
       _invoiceRepository = invoiceRepository ?? InvoiceRepository(),
       _pdfGenerator = pdfGenerator ?? TransferInvoicePdfGenerator(),
       super(WareFlowState.initial()) {
    loadProductCatalog();
  }

  final ProductRepository _productRepository;
  final InvoiceRepository _invoiceRepository;
  final TransferInvoicePdfGenerator _pdfGenerator;
  final Map<String, Timer> _lookupTimers = {};
  static const _lookupDebounce = Duration(milliseconds: 400);

  static const _duplicateMessage = 'Product has already been added.';
  static const _notFoundMessage = 'Product not found.';

  Future<void> loadProductCatalog() async {
    emit(state.copyWith(isCatalogLoading: true, clearCatalogLoadError: true));
    try {
      await _productRepository.loadProducts();
      emit(state.copyWith(isCatalogLoading: false, isCatalogReady: true));
    } catch (error) {
      emit(
        state.copyWith(
          isCatalogLoading: false,
          isCatalogReady: false,
          catalogLoadError: 'Failed to load product catalog.',
        ),
      );
      debugPrint('Product catalog load error: $error');
    }
  }

  void updateBatchId(String value) {
    emit(state.copyWith(batchId: value));
  }

  void updateStore(String value) {
    emit(state.copyWith(store: value));
  }

  void updateSubmittedBy(String value) {
    emit(state.copyWith(submittedBy: value));
  }

  void updateShipDate(DateTime date) {
    emit(state.copyWith(shipDate: date));
  }

  void updateShipTime(TimeOfDay time) {
    emit(state.copyWith(shipTime: time));
  }

  void onItemCodeChanged(String itemId, String value) {
    final trimmed = value.trim();
    final items = state.items.map((item) {
      if (item.id != itemId) return item;
      return item.copyWith(
        itemCode: value,
        clearProductData: true,
        clearLookupError: true,
        lookupStatus: trimmed.isEmpty
            ? ItemLookupStatus.idle
            : ItemLookupStatus.loading,
      );
    }).toList();

    emit(
      state.copyWith(
        items: items,
        clearHighlightedItemId: state.highlightedItemId != null,
      ),
    );
    _scheduleLookup(itemId, trimmed);
  }

  void onItemCodeSubmitted(String itemId, String value) {
    _lookupTimers[itemId]?.cancel();
    lookupProduct(itemId, value.trim());
  }

  void updateProductName(String itemId, String value) {
    _updateItem(itemId, (item) => item.copyWith(productName: value));
  }

  void updateBarcode(String itemId, String value) {
    _updateItem(itemId, (item) => item.copyWith(barcode: value));
  }

  void updateItemQuantity(String itemId, int quantity) {
    _updateItem(
      itemId,
      (item) => item.copyWith(quantity: quantity.clamp(1, 999999)),
    );
  }

  void updateReceivedQuantity(String itemId, String value) {
    final parsed = int.tryParse(value.trim()) ?? 0;
    _updateItem(
      itemId,
      (item) => item.copyWith(receivedQuantity: parsed.clamp(0, 999999)),
    );
  }

  void updateItemComment(String itemId, String? comment) {
    _updateItem(itemId, (item) {
      if (comment == null) {
        return item.copyWith(clearComment: true, clearCustomComment: true);
      }
      if (comment != ItemCommentOptions.other) {
        return item.copyWith(comment: comment, clearCustomComment: true);
      }
      return item.copyWith(comment: comment);
    });
  }

  void updateCustomComment(String itemId, String value) {
    _updateItem(itemId, (item) => item.copyWith(customComment: value));
  }

  void removeItem(String itemId) {
    _lookupTimers[itemId]?.cancel();
    _lookupTimers.remove(itemId);
    final items = state.items.where((item) => item.id != itemId).toList();
    emit(
      state.copyWith(
        items: items,
        clearHighlightedItemId: state.highlightedItemId == itemId,
      ),
    );
  }

  void addItem() {
    final newItem = TransferInvoiceItem(id: state.nextItemId.toString());
    emit(state.copyWith(
      items: [...state.items, newItem],
      nextItemId: state.nextItemId + 1,
    ));
  }

  Future<bool> saveAndPrint() async {
    if (!_validateItems()) return false;

    final printableCount = state.items.where(
      (item) =>
          item.itemCode.trim().isNotEmpty &&
          item.lookupStatus == ItemLookupStatus.found,
    ).length;

    if (printableCount == 0) return false;

    emit(
      state.copyWith(isSaving: true, savingAction: WareFlowSaveAction.print),
    );

    try {
      final invoice = TransferInvoiceMapper.fromState(state);
      await _invoiceRepository.save(invoice);
      final pdfBytes = await _pdfGenerator.generate(invoice);
      await previewAndPrintPdf(pdfBytes, invoice.pdfFileName);
      return true;
    } catch (error, stackTrace) {
      debugPrint('Save & Print error: $error\n$stackTrace');
      return false;
    } finally {
      emit(state.copyWith(isSaving: false, clearSavingAction: true));
    }
  }

  Future<bool> saveAsDraft() async {
    if (!_validateItems()) return false;

    emit(
      state.copyWith(isSaving: true, savingAction: WareFlowSaveAction.draft),
    );

    try {
      final invoice = TransferInvoiceMapper.fromState(state);
      await _invoiceRepository.save(invoice);
      debugPrint('Save as Draft — Batch: ${state.batchId}');
      return true;
    } catch (error, stackTrace) {
      debugPrint('Save as Draft error: $error\n$stackTrace');
      return false;
    } finally {
      emit(state.copyWith(isSaving: false, clearSavingAction: true));
    }
  }

  Future<void> lookupProduct(String itemId, String sku) async {
    if (sku.isEmpty) {
      _updateItem(
        itemId,
        (item) => item.copyWith(
          clearProductData: true,
          clearLookupError: true,
          lookupStatus: ItemLookupStatus.idle,
        ),
      );
      return;
    }

    if (!state.isCatalogReady) {
      await loadProductCatalog();
      if (!state.isCatalogReady) return;
    }

    final duplicateRowId = _findExistingSkuRowId(sku, itemId);
    if (duplicateRowId != null) {
      final items = state.items.map((item) {
        if (item.id != itemId) return item;
        return item.copyWith(
          itemCode: sku,
          clearProductData: true,
          lookupStatus: ItemLookupStatus.duplicate,
          lookupError: _duplicateMessage,
        );
      }).toList();

      emit(
        state.copyWith(
          items: items,
          highlightedItemId: duplicateRowId,
        ),
      );
      return;
    }

    _updateItem(
      itemId,
      (item) => item.copyWith(
        lookupStatus: ItemLookupStatus.loading,
        clearLookupError: true,
        clearProductData: true,
      ),
    );

    await Future<void>.delayed(Duration.zero);

    final product = _productRepository.findBySku(sku);

    if (product != null) {
      _updateItem(
        itemId,
        (item) => item.copyWith(
          itemCode: sku,
          productName: product.name,
          barcode: product.barcode,
          lookupStatus: ItemLookupStatus.found,
          clearLookupError: true,
        ),
      );
      return;
    }

    _updateItem(
      itemId,
      (item) => item.copyWith(
        itemCode: sku,
        clearProductData: true,
        lookupStatus: ItemLookupStatus.notFound,
        lookupError: _notFoundMessage,
      ),
    );
  }

  String? _findExistingSkuRowId(String sku, String excludeItemId) {
    final normalized = sku.trim();
    if (normalized.isEmpty) return null;

    for (final item in state.items) {
      if (item.id == excludeItemId) continue;
      if (item.lookupStatus != ItemLookupStatus.found) continue;
      if (item.itemCode.trim() == normalized) return item.id;
    }
    return null;
  }

  void _scheduleLookup(String itemId, String sku) {
    _lookupTimers[itemId]?.cancel();
    if (sku.isEmpty) return;

    _lookupTimers[itemId] = Timer(_lookupDebounce, () {
      lookupProduct(itemId, sku);
    });
  }

  bool _validateItems() {
    return !state.hasInvalidItems;
  }

  void _updateItem(
    String itemId,
    TransferInvoiceItem Function(TransferInvoiceItem item) transform,
  ) {
    final items = state.items.map((item) {
      if (item.id != itemId) return item;
      return transform(item);
    }).toList();
    emit(state.copyWith(items: items));
  }

  @override
  Future<void> close() {
    for (final timer in _lookupTimers.values) {
      timer.cancel();
    }
    _lookupTimers.clear();
    return super.close();
  }
}
