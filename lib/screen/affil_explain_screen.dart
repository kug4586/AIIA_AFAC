import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class AffilExplainScreen extends StatefulWidget {
  final String path;

  const AffilExplainScreen({Key? key, required this.path}) : super(key: key);

  @override
  State<AffilExplainScreen> createState() => _AffilExplainScreenState();
}

class _AffilExplainScreenState extends State<AffilExplainScreen>
    with WidgetsBindingObserver {

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("학과 설명")),
        backgroundColor: Colors.blue,
        body: Stack(
          children: <Widget>[
            PDFView(
              filePath: widget.path,
              defaultPage: currentPage!,
              pageFling: false,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              // if set to true the link is handled in flutter
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
        ));
  }
}
