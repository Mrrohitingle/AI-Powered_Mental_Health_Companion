import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

class WebAppPage extends StatefulWidget {
  @override
  _WebAppPageState createState() => _WebAppPageState();
}

class _WebAppPageState extends State<WebAppPage> {
  late InAppWebViewController webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mental Health Companion"),
        backgroundColor: Colors.blueAccent,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(
            "http://10.0.2.2:8080/index.html",
          ),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          mediaPlaybackRequiresUserGesture: false,
          useHybridComposition: Platform.isAndroid,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          print("WebView loaded: $url");
        },
      ),
    );
  }
}
