import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PdfViewerScreen extends StatelessWidget {
  final Uint8List pdfData;
  const PdfViewerScreen({Key? key, required this.pdfData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,),
      body: Stack(
        children: [
            PDFView(
              pdfData: pdfData,
              enableSwipe: false,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
            ),
        ],
      ),
    );
  }
}
