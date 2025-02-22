import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

class ChatbotInAppWebView extends StatefulWidget {
  final String chatbotUrl;

  const ChatbotInAppWebView({super.key, required this.chatbotUrl});

  @override
  _ChatbotInAppWebViewState createState() => _ChatbotInAppWebViewState();
}

class _ChatbotInAppWebViewState extends State<ChatbotInAppWebView> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.chatbotUrl)),
        initialSettings: InAppWebViewSettings(
          mediaPlaybackRequiresUserGesture: false, // Allow autoplay of audio
          javaScriptEnabled: true, // Ensure JavaScript is enabled for web app functionality
          allowContentAccess: true, // Ensure web content access
          domStorageEnabled: true,
          useShouldInterceptRequest: true,
          allowFileAccessFromFileURLs: true, // Enable DOM storage
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;

          // Register JavaScript handlers for audio events
          controller.addJavaScriptHandler(
            handlerName: 'onAudioReady',
            callback: (args) async {
              // Request audio focus when audio system is ready
              await _requestAudioFocus();
            },
          );
          controller.addJavaScriptHandler(
            handlerName: 'onPlaybackStart',
            callback: (args) async {
              // Handle playback start
              print('Audio playback started');
            },
          );
          controller.addJavaScriptHandler(
            handlerName: 'onPlaybackEnd',
            callback: (args) async {
              // Handle playback end
              print('Audio playback ended');
            },
          );
          controller.addJavaScriptHandler(
            handlerName: 'onPlaybackStop',
            callback: (args) async {
              // Handle playback stop
              print('Audio playback stopped');
            },
          );
        },
        onLoadStop: (controller, url) async {
          // Initialize audio system after page loads
          await controller.evaluateJavascript(source: 'window.initializeAudio()');
          // Handle user interaction to start audio (optional)
          await controller.evaluateJavascript(source: 'window.handleUserInteraction()');
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint("Console Message: ${consoleMessage.message}");
        },
      ),
    );
  }

  Future<void> _requestAudioFocus() async {
    const platform = MethodChannel('your_app/audio');
    try {
      final result = await platform.invokeMethod('requestAudioFocus');
      if (result == true) {
        // Audio focus granted, ready to play audio
      } else {
        print('Audio focus not granted');
      }
    } catch (e) {
      print('Failed to request audio focus: $e');
    }
  }

}
