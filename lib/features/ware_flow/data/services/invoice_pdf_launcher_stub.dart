import 'dart:typed_data';

import 'package:printing/printing.dart';

Future<void> previewAndPrintPdf(Uint8List bytes, String filename) async {
  await Printing.layoutPdf(onLayout: (_) async => bytes);
}
