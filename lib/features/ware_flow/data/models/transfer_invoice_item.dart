import 'package:equatable/equatable.dart';

enum ItemLookupStatus { idle, loading, found, notFound, duplicate }

class TransferInvoiceItem extends Equatable {
  const TransferInvoiceItem({
    required this.id,
    this.itemCode = '',
    this.productName = '',
    this.receivedQuantity = 0,
    this.quantity = 1,
    this.barcode = '',
    this.comment,
    this.customComment,
    this.lookupStatus = ItemLookupStatus.idle,
    this.lookupError,
  });

  final String id;
  final String itemCode;
  final String productName;
  final int receivedQuantity;
  final int quantity;
  final String barcode;
  final String? comment;
  final String? customComment;
  final ItemLookupStatus lookupStatus;
  final String? lookupError;

  bool get isCatalogFilled => lookupStatus == ItemLookupStatus.found;

  bool get isValidForSubmission {
    if (itemCode.trim().isEmpty) return true;
    return lookupStatus == ItemLookupStatus.found;
  }

  TransferInvoiceItem copyWith({
    String? id,
    String? itemCode,
    String? productName,
    int? receivedQuantity,
    int? quantity,
    String? barcode,
    String? comment,
    String? customComment,
    ItemLookupStatus? lookupStatus,
    String? lookupError,
    bool clearComment = false,
    bool clearCustomComment = false,
    bool clearProductData = false,
    bool clearLookupError = false,
  }) {
    return TransferInvoiceItem(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      productName: clearProductData ? '' : (productName ?? this.productName),
      receivedQuantity: receivedQuantity ?? this.receivedQuantity,
      quantity: quantity ?? this.quantity,
      barcode: clearProductData ? '' : (barcode ?? this.barcode),
      comment: clearComment ? null : (comment ?? this.comment),
      customComment: clearCustomComment
          ? null
          : (customComment ?? this.customComment),
      lookupStatus: lookupStatus ?? this.lookupStatus,
      lookupError: clearLookupError ? null : (lookupError ?? this.lookupError),
    );
  }

  @override
  List<Object?> get props => [
    id,
    itemCode,
    productName,
    receivedQuantity,
    quantity,
    barcode,
    comment,
    customComment,
    lookupStatus,
    lookupError,
  ];
}

class ItemCommentOptions {
  ItemCommentOptions._();

  static const String other = 'Other';

  static const List<String> values = [
    'Missing',
    'Over',
    'Quality',
    'Near Expired',
    other,
  ];
}
