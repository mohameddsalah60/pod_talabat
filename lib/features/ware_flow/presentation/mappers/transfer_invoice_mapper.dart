import '../../data/models/transfer_invoice.dart';
import '../../data/models/transfer_invoice_item.dart';
import '../cubits/ware_flow_state.dart';

class TransferInvoiceMapper {
  TransferInvoiceMapper._();

  static TransferInvoice fromState(WareFlowState state) {
    final printableItems = state.items
        .where(
          (item) =>
              item.itemCode.trim().isNotEmpty &&
              item.lookupStatus == ItemLookupStatus.found,
        )
        .map(
          (item) => TransferInvoiceLineItem(
            sku: item.itemCode.trim(),
            productName: item.productName,
            receivedQuantity: item.receivedQuantity,
            quantity: item.quantity,
            barcode: item.barcode,
            comment: _resolveComment(item),
          ),
        )
        .toList();

    return TransferInvoice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      batchId: state.batchId.trim().isNotEmpty
          ? state.batchId.trim()
          : 'INV-${DateTime.now().millisecondsSinceEpoch}',
      store: state.store.trim().isNotEmpty ? state.store.trim() : 'DS32',
      createdBy: state.submittedBy,
      createdDate: state.shipDate,
      createdTime: state.shipTime,
      items: printableItems,
      savedAt: DateTime.now(),
    );
  }

  static String? _resolveComment(TransferInvoiceItem item) {
    final comment = item.comment;
    if (comment == null) return null;
    if (comment == ItemCommentOptions.other) {
      final custom = item.customComment?.trim();
      return custom?.isNotEmpty == true ? custom : null;
    }
    return comment;
  }
}
