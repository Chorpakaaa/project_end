import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/util/util.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class Pdfpage extends StatefulWidget {
  const Pdfpage({super.key});

  @override
  State<Pdfpage> createState() => _PdfpageState();
}

class _PdfpageState extends State<Pdfpage> {
  PrintingInfo? printingInfo;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = [
      if (!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showShareToast,
        build: generatePdf,
      ),
    );
  }
}
