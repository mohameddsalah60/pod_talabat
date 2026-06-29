import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/transfer_invoice.dart';

class TransferInvoicePdfGenerator {
  static const _firstPageRowLimit = 10;
  static const _nextPageRowLimit = 14;

  pw.Font? _regular;
  pw.Font? _semiBold;
  pw.Font? _bold;
  pw.Font? _arabicRegular;
  pw.Font? _mono;

  Future<Uint8List> generate(TransferInvoice invoice) async {
    await _loadFonts();

    final doc = pw.Document(
      title: 'Transfer Invoice - ${invoice.batchId}',
      author: invoice.createdBy,
      creator: 'WareFlow',
    );

    final pages = _paginateItems(invoice.items);

    for (var pageIndex = 0; pageIndex < pages.length; pageIndex++) {
      final isFirstPage = pageIndex == 0;
      final isLastPage = pageIndex == pages.length - 1;
      final pageRows = pages[pageIndex];

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
          theme: pw.ThemeData.withFont(base: _regular!, bold: _bold!),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                if (isFirstPage) ...[
                  _buildHeader(invoice),
                  pw.SizedBox(height: 14),
                  _buildDivider(),
                  pw.SizedBox(height: 18),
                  _buildInfoCard(invoice),
                  pw.SizedBox(height: 20),
                ] else ...[
                  _buildContinuedHeader(invoice, pageIndex + 1, pages.length),
                  pw.SizedBox(height: 16),
                ],
                _buildTableHeader(),
                pw.SizedBox(height: 0),
                if (pageRows.isEmpty)
                  _buildEmptyTableBody()
                else
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: _PdfColors.greyBorder,
                        width: 0.5,
                      ),
                      borderRadius: isLastPage
                          ? const pw.BorderRadius.only(
                              bottomLeft: pw.Radius.circular(8),
                              bottomRight: pw.Radius.circular(8),
                            )
                          : pw.BorderRadius.zero,
                    ),
                    child: pw.Column(
                      children: pageRows.asMap().entries.map((entry) {
                        final isLastRowOnPage =
                            entry.key == pageRows.length - 1;
                        return _buildTableRow(
                          entry.value,
                          entry.key.isEven,
                          isLastRow: isLastPage && isLastRowOnPage,
                        );
                      }).toList(),
                    ),
                  ),
                pw.Spacer(),
                if (isLastPage) ...[
                  pw.SizedBox(height: 20),
                  // pw.Align(
                  //   alignment: pw.Alignment.centerRight,
                  //   child: _buildSummaryCard(invoice),
                  // ),
                ],
              ],
            );
          },
        ),
      );
    }

    return doc.save();
  }

  Future<void> _loadFonts() async {
    if (_regular != null) return;

    final regularData = await rootBundle.load(
      'assets/fonts/Montserrat-Regular.ttf',
    );
    final semiBoldData = await rootBundle.load(
      'assets/fonts/Montserrat-SemiBold.ttf',
    );
    final boldData = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');
    final arabicData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final monoData = await rootBundle.load(
      'assets/fonts/RobotoMono-Regular.ttf',
    );

    _regular = pw.Font.ttf(regularData);
    _semiBold = pw.Font.ttf(semiBoldData);
    _bold = pw.Font.ttf(boldData);
    _arabicRegular = pw.Font.ttf(arabicData);
    _mono = pw.Font.ttf(monoData);
  }

  List<List<TransferInvoiceLineItem>> _paginateItems(
    List<TransferInvoiceLineItem> items,
  ) {
    if (items.isEmpty) return [[]];

    final pages = <List<TransferInvoiceLineItem>>[];
    pages.add(items.take(_firstPageRowLimit).toList());

    var remaining = items.skip(_firstPageRowLimit).toList();
    while (remaining.isNotEmpty) {
      pages.add(remaining.take(_nextPageRowLimit).toList());
      remaining = remaining.skip(_nextPageRowLimit).toList();
    }

    return pages;
  }

  pw.Widget _buildHeader(TransferInvoice invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 4,
          child: pw.Center(
            child: _text(
              'Transfer Invoice',
              size: 28,
              weight: _PdfFontWeight.bold,
              color: _PdfColors.textDark,
            ),
          ),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _metaLine('Batch ID', invoice.batchId),
              pw.SizedBox(height: 6),
              _metaLine('Store', invoice.store),
              pw.SizedBox(height: 6),
              _metaLine('Date', invoice.formattedDate),
              pw.SizedBox(height: 6),
              _metaLine('Time', invoice.formattedTime),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildContinuedHeader(
    TransferInvoice invoice,
    int pageNumber,
    int totalPages,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        _buildLogo(size: 28),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _text(
            'Transfer Invoice — ${invoice.batchId}',
            size: 13,
            weight: _PdfFontWeight.semiBold,
            color: _PdfColors.textDark,
          ),
        ),
        _text(
          'Page $pageNumber of $totalPages',
          size: 10,
          color: _PdfColors.textMuted,
        ),
      ],
    );
  }

  pw.Widget _buildLogo({double size = 36}) {
    return pw.Container(
      width: size,
      height: size,
      decoration: pw.BoxDecoration(
        color: _PdfColors.orange,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      alignment: pw.Alignment.center,
      child: _text(
        'W',
        size: size * 0.45,
        weight: _PdfFontWeight.bold,
        color: PdfColors.white,
      ),
    );
  }

  pw.Widget _buildDivider() {
    return pw.Container(
      height: 2,
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [_PdfColors.orangeMid, _PdfColors.orange],
        ),
        borderRadius: pw.BorderRadius.circular(1),
      ),
    );
  }

  pw.Widget _buildInfoCard(TransferInvoice invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: pw.BoxDecoration(
        color: _PdfColors.rowAlt,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _PdfColors.greyBorder),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Expanded(child: _infoField('ST Number', invoice.batchId)),
              pw.Expanded(child: _infoField('Store', invoice.store)),
              pw.Expanded(child: _infoField('Received By', invoice.createdBy)),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              pw.Expanded(child: _infoField('Date', invoice.formattedDate)),
              pw.Expanded(child: _infoField('Time', invoice.formattedTime)),
              pw.Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _infoField(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _text(
          label,
          size: 9,
          weight: _PdfFontWeight.semiBold,
          color: _PdfColors.textMuted,
        ),
        pw.SizedBox(height: 4),
        _text(
          value,
          size: 11,
          weight: _PdfFontWeight.semiBold,
          color: _PdfColors.textDark,
        ),
      ],
    );
  }

  pw.Widget _metaLine(String label, String value) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: _textStyle(
              size: 9,
              weight: _PdfFontWeight.semiBold,
              color: _PdfColors.textMuted,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: _textStyle(
              size: 10,
              weight: _PdfFontWeight.semiBold,
              color: _PdfColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableHeader() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [_PdfColors.orangeMid, _PdfColors.orange],
        ),
        borderRadius: const pw.BorderRadius.only(
          topLeft: pw.Radius.circular(8),
          topRight: pw.Radius.circular(8),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: pw.Row(
        children: [
          _headerCell('SKU', 2),
          _headerCell('Product Name', 3),
          _headerCell('Received Quantity', 2, align: pw.TextAlign.center),
          _headerCell('Quantity', 2, align: pw.TextAlign.center),
          _headerCell('Barcode', 2),
          _headerCell('Comment', 2),
        ],
      ),
    );
  }

  pw.Widget _headerCell(
    String label,
    int flex, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Expanded(
      flex: flex,
      child: _text(
        label,
        size: 9,
        weight: _PdfFontWeight.bold,
        color: PdfColors.white,
        align: align,
      ),
    );
  }

  pw.Widget _buildEmptyTableBody() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 28),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: _PdfColors.greyBorder, width: 0.5),
        borderRadius: const pw.BorderRadius.only(
          bottomLeft: pw.Radius.circular(8),
          bottomRight: pw.Radius.circular(8),
        ),
      ),
      child: pw.Center(
        child: _text('No items added', size: 11, color: _PdfColors.textMuted),
      ),
    );
  }

  pw.Widget _buildTableRow(
    TransferInvoiceLineItem item,
    bool isEven, {
    bool isLastRow = false,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: isEven ? PdfColors.white : _PdfColors.rowAlt,
        border: isLastRow
            ? null
            : pw.Border(
                bottom: pw.BorderSide(color: _PdfColors.greyBorder, width: 0.5),
              ),
        borderRadius: isLastRow
            ? const pw.BorderRadius.only(
                bottomLeft: pw.Radius.circular(8),
                bottomRight: pw.Radius.circular(8),
              )
            : null,
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _bodyCell(item.sku, 2, mono: true),
          _bodyCell(item.productName, 3),
          _bodyCell(
            item.receivedQuantity.toString(),
            2,
            align: pw.TextAlign.center,
            weight: _PdfFontWeight.semiBold,
          ),
          _bodyCell(
            item.quantity.toString(),
            2,
            align: pw.TextAlign.center,
            weight: _PdfFontWeight.semiBold,
          ),
          _bodyCell(item.barcode, 2, mono: true),
          _bodyCell(item.comment ?? '—', 2, muted: item.comment == null),
        ],
      ),
    );
  }

  pw.Widget _bodyCell(
    String value,
    int flex, {
    pw.TextAlign align = pw.TextAlign.left,
    bool mono = false,
    bool muted = false,
    _PdfFontWeight weight = _PdfFontWeight.regular,
  }) {
    return pw.Expanded(
      flex: flex,
      child: _text(
        value,
        size: 9,
        weight: weight,
        color: muted ? _PdfColors.textMuted : _PdfColors.textDark,
        align: align,
        mono: mono,
        maxLines: 3,
      ),
    );
  }

  pw.Widget _buildSummaryCard(TransferInvoice invoice) {
    return pw.Container(
      width: 240,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _PdfColors.greyBorder),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 14,
                height: 14,
                decoration: pw.BoxDecoration(
                  color: _PdfColors.orangeLight,
                  borderRadius: pw.BorderRadius.circular(3),
                ),
              ),
              pw.SizedBox(width: 6),
              _text(
                'Invoice Summary',
                size: 11,
                weight: _PdfFontWeight.bold,
                color: _PdfColors.textDark,
              ),
            ],
          ),
          pw.SizedBox(height: 14),
          _summaryRow('Total Products', invoice.totalProducts.toString()),
          pw.SizedBox(height: 10),
          _summaryRow(
            'Total Received Quantity',
            invoice.totalReceivedQuantity.toString(),
          ),
          pw.SizedBox(height: 10),
          _summaryRow(
            'Total Quantity',
            invoice.totalQuantity.toString(),
            highlight: true,
          ),
        ],
      ),
    );
  }

  pw.Widget _summaryRow(String label, String value, {bool highlight = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _text(
          label,
          size: 10,
          color: _PdfColors.textMuted,
          weight: _PdfFontWeight.semiBold,
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: pw.BoxDecoration(
            color: highlight ? _PdfColors.orangeLight : _PdfColors.rowAlt,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: _text(
            value,
            size: 11,
            weight: _PdfFontWeight.bold,
            color: highlight ? _PdfColors.orange : _PdfColors.textDark,
          ),
        ),
      ],
    );
  }

  pw.Widget _text(
    String value, {
    required double size,
    _PdfFontWeight weight = _PdfFontWeight.regular,
    PdfColor? color,
    pw.TextAlign align = pw.TextAlign.left,
    bool mono = false,
    int maxLines = 1,
  }) {
    return pw.Text(
      value,
      maxLines: maxLines,
      textAlign: align,
      style: _textStyle(
        size: size,
        weight: weight,
        color: color ?? _PdfColors.textDark,
        mono: mono,
      ),
    );
  }

  pw.TextStyle _textStyle({
    required double size,
    _PdfFontWeight weight = _PdfFontWeight.regular,
    PdfColor? color,
    bool mono = false,
  }) {
    if (mono) {
      return pw.TextStyle(
        fontSize: size,
        font: _mono!,
        fontFallback: [_arabicRegular!],
        color: color ?? _PdfColors.textDark,
        lineSpacing: 1.2,
      );
    }

    final font = switch (weight) {
      _PdfFontWeight.bold => _bold!,
      _PdfFontWeight.semiBold => _semiBold!,
      _PdfFontWeight.regular => _regular!,
    };

    return pw.TextStyle(
      fontSize: size,
      font: font,
      fontFallback: [_arabicRegular!],
      color: color ?? _PdfColors.textDark,
      lineSpacing: 1.2,
    );
  }
}

enum _PdfFontWeight { regular, semiBold, bold }

class _PdfColors {
  static final orange = PdfColor.fromHex('#FF6B00');
  static final orangeMid = PdfColor.fromHex('#FF8A1F');
  static final orangeLight = PdfColor.fromHex('#FFF0E6');
  static final textDark = PdfColor.fromHex('#1E1E24');
  static final textMuted = PdfColor.fromHex('#6B7280');
  static final greyBorder = PdfColor.fromHex('#EDEDED');
  static final rowAlt = PdfColor.fromHex('#F5F5F5');
}
