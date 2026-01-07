import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pecon_app/src/app_config/styles.dart';

class InAppPdfViewer extends StatefulWidget {
  final String pdfUrl;
  const InAppPdfViewer({super.key, required this.pdfUrl});

  @override
  State<InAppPdfViewer> createState() => _InAppPdfViewerState();
}

class _InAppPdfViewerState extends State<InAppPdfViewer> {
  InAppWebViewController? webViewController;
  double progress = 0; // Track loading progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("https://docs.google.com/gview?embedded=true&url=${widget.pdfUrl}"),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onProgressChanged: (controller, progressValue) {
                setState(() {
                  progress = progressValue / 100; // Convert progress to 0.0 - 1.0
                });
              },
            ),
        
            // Show LinearProgressIndicator when loading
            if (progress < 1.0)
              LinearProgressIndicator(value: progress, minHeight: 4, color: primary,),
          ],
        ),
      ),
    );
  }
}
