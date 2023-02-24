import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ServicesWebView extends StatefulWidget {
  const ServicesWebView({Key? key}) : super(key: key);

  static const routeName = '/services-web-view';

  @override
  ServicesWebViewState createState() => ServicesWebViewState();
}

class ServicesWebViewState extends State<ServicesWebView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prenotazioni"),
      ),
      body: const WebView(
        initialUrl: 'https://prenota.farmaciestilo.com/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
