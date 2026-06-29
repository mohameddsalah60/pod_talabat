import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/models/transfer_invoice_item.dart';

class WareFlowState extends Equatable {
  const WareFlowState({
    required this.batchId,
    required this.store,
    required this.submittedBy,
    required this.shipDate,
    required this.shipTime,
    required this.items,
    required this.nextItemId,
    required this.isCatalogLoading,
    required this.isCatalogReady,
    this.catalogLoadError,
    this.highlightedItemId,
    this.isSaving = false,
    this.savingAction,
  });

  factory WareFlowState.initial() {
    final now = DateTime.now();
    return WareFlowState(
      batchId: '',
      store: 'DS32',
      submittedBy: 'MO SALAH',
      shipDate: now,
      shipTime: TimeOfDay(hour: now.hour, minute: now.minute),
      items: [const TransferInvoiceItem(id: '1')],
      nextItemId: 2,
      isCatalogLoading: true,
      isCatalogReady: false,
    );
  }

  final String batchId;
  final String store;
  final String submittedBy;
  final DateTime shipDate;
  final TimeOfDay shipTime;
  final List<TransferInvoiceItem> items;
  final int nextItemId;
  final bool isCatalogLoading;
  final bool isCatalogReady;
  final String? catalogLoadError;
  final String? highlightedItemId;
  final bool isSaving;
  final WareFlowSaveAction? savingAction;

  int get totalItems => items.length;

  int get totalReceivedQuantity =>
      items.fold(0, (sum, item) => sum + item.receivedQuantity);

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  bool get hasInvalidItems =>
      items.any((item) => !item.isValidForSubmission);

  WareFlowState copyWith({
    String? batchId,
    String? store,
    String? submittedBy,
    DateTime? shipDate,
    TimeOfDay? shipTime,
    List<TransferInvoiceItem>? items,
    int? nextItemId,
    bool? isCatalogLoading,
    bool? isCatalogReady,
    String? catalogLoadError,
    bool clearCatalogLoadError = false,
    String? highlightedItemId,
    bool clearHighlightedItemId = false,
    bool? isSaving,
    WareFlowSaveAction? savingAction,
    bool clearSavingAction = false,
  }) {
    return WareFlowState(
      batchId: batchId ?? this.batchId,
      store: store ?? this.store,
      submittedBy: submittedBy ?? this.submittedBy,
      shipDate: shipDate ?? this.shipDate,
      shipTime: shipTime ?? this.shipTime,
      items: items ?? this.items,
      nextItemId: nextItemId ?? this.nextItemId,
      isCatalogLoading: isCatalogLoading ?? this.isCatalogLoading,
      isCatalogReady: isCatalogReady ?? this.isCatalogReady,
      catalogLoadError: clearCatalogLoadError
          ? null
          : (catalogLoadError ?? this.catalogLoadError),
      highlightedItemId: clearHighlightedItemId
          ? null
          : (highlightedItemId ?? this.highlightedItemId),
      isSaving: isSaving ?? this.isSaving,
      savingAction: clearSavingAction
          ? null
          : (savingAction ?? this.savingAction),
    );
  }

  @override
  List<Object?> get props => [
    batchId,
    store,
    submittedBy,
    shipDate,
    shipTime,
    items,
    nextItemId,
    isCatalogLoading,
    isCatalogReady,
    catalogLoadError,
    highlightedItemId,
    isSaving,
    savingAction,
  ];
}

enum WareFlowSaveAction { draft, print }
