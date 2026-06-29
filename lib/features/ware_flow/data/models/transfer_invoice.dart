import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TransferInvoiceLineItem extends Equatable {
  const TransferInvoiceLineItem({
    required this.sku,
    required this.productName,
    required this.receivedQuantity,
    required this.quantity,
    required this.barcode,
    this.comment,
  });

  final String sku;
  final String productName;
  final int receivedQuantity;
  final int quantity;
  final String barcode;
  final String? comment;

  @override
  List<Object?> get props => [
    sku,
    productName,
    receivedQuantity,
    quantity,
    barcode,
    comment,
  ];
}

class TransferInvoice extends Equatable {
  const TransferInvoice({
    required this.id,
    required this.batchId,
    required this.store,
    required this.createdBy,
    required this.createdDate,
    required this.createdTime,
    required this.items,
    required this.savedAt,
  });

  final String id;
  final String batchId;
  final String store;
  final String createdBy;
  final DateTime createdDate;
  final TimeOfDay createdTime;
  final List<TransferInvoiceLineItem> items;
  final DateTime savedAt;

  int get totalProducts => items.length;

  int get totalReceivedQuantity =>
      items.fold(0, (sum, item) => sum + item.receivedQuantity);

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  String get formattedDate =>
      '${createdDate.year}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}';

  String get formattedTime =>
      '${createdTime.hour.toString().padLeft(2, '0')}:${createdTime.minute.toString().padLeft(2, '0')}';

  String get pdfFileName => '$batchId.pdf';

  @override
  List<Object?> get props => [
    id,
    batchId,
    store,
    createdBy,
    createdDate,
    createdTime,
    items,
    savedAt,
  ];
}
