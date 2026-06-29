import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pod_talabat/features/ware_flow/data/models/transfer_invoice.dart';
import 'package:pod_talabat/features/ware_flow/data/services/transfer_invoice_pdf_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      if (message == null) return null;
      final key = utf8.decode(message.buffer.asUint8List(
        message.offsetInBytes,
        message.lengthInBytes,
      ));
      final file = File(key);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        return ByteData.sublistView(bytes);
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('TransferInvoicePdfGenerator', () {
    final generator = TransferInvoicePdfGenerator();

    test('generates PDF successfully with Unicode character inputs', () async {
      final invoice = TransferInvoice(
        id: '1',
        batchId: 'BATCH123',
        store: 'DS32',
        createdBy: 'أحمد صلاح Salah', // Unicode / Arabic name
        createdDate: DateTime(2026, 6, 27),
        createdTime: const TimeOfDay(hour: 14, minute: 30),
        savedAt: DateTime(2026, 6, 27),
        items: const [
          TransferInvoiceLineItem(
            sku: 'SKU-عربي-123', // Unicode Arabic SKU
            productName: 'Product 1',
            receivedQuantity: 4,
            quantity: 5,
            barcode: '123456789',
            comment: 'Note: تحديث', // Unicode Arabic Comment
          ),
          TransferInvoiceLineItem(
            sku: 'SKU-456',
            productName: 'منتج ٢', // Unicode Arabic Product Name
            receivedQuantity: 8,
            quantity: 10,
            barcode: '987654321',
            comment: null,
          ),
        ],
      );

      final pdfBytes = await generator.generate(invoice);
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('generates empty PDF body successfully without crashes', () async {
      final invoice = TransferInvoice(
        id: '2',
        batchId: 'BATCH456',
        store: 'DS32',
        createdBy: 'Test User',
        createdDate: DateTime(2026, 6, 27),
        createdTime: const TimeOfDay(hour: 9, minute: 15),
        savedAt: DateTime(2026, 6, 27),
        items: const [], // Empty items list
      );

      final pdfBytes = await generator.generate(invoice);
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(0));
    });
  });
}
