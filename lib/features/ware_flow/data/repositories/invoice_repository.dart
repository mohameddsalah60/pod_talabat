import '../models/transfer_invoice.dart';

class InvoiceRepository {
  final List<TransferInvoice> _savedInvoices = [];

  List<TransferInvoice> get savedInvoices => List.unmodifiable(_savedInvoices);

  Future<TransferInvoice> save(TransferInvoice invoice) async {
    await Future<void>.delayed(Duration.zero);
    _savedInvoices.add(invoice);
    return invoice;
  }
}
