import 'dart:html' as html;
import 'dart:typed_data';

Future<void> previewAndPrintPdf(Uint8List bytes, String filename) async {
  final pdfBlob = html.Blob([bytes], 'application/pdf');
  final pdfUrl = html.Url.createObjectUrlFromBlob(pdfBlob);

  final printHtml =
      '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>$filename</title>
  <style>
    html, body { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; }
    embed { position: fixed; top: 0; left: 0; width: 100%; height: 100%; border: 0; }
  </style>
</head>
<body>
  <embed src="$pdfUrl" type="application/pdf" />
  <script>
    window.addEventListener('load', function () {
      setTimeout(function () { window.print(); }, 700);
    });
  </script>
</body>
</html>
''';

  final htmlBlob = html.Blob([printHtml], 'text/html');
  final htmlUrl = html.Url.createObjectUrlFromBlob(htmlBlob);
  html.window.open(htmlUrl, '_blank');
}
