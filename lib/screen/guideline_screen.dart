import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class GuidelineScreen extends StatefulWidget {
  final String path;
  final int? init_page;

  GuidelineScreen({
    Key? key,
    required this.path,
    this.init_page = 0
  }) : super(key: key);

  _GuidelineScreenState createState() => _GuidelineScreenState();
}

class _GuidelineScreenState extends State<GuidelineScreen>
    with WidgetsBindingObserver {

  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();

  int? pages = 0;
  int? currentPage;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    currentPage = widget.init_page;
    return Scaffold(
      appBar: AppBar(
        title: Text("모집요강")
      ),
      backgroundColor: Colors.blue,
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            defaultPage: currentPage!,
            pageFling: false,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
            false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
            ),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      )
    );
  }
}