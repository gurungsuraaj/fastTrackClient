import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FacebookScreen extends StatefulWidget {
  const FacebookScreen({Key key}) : super(key: key);

  @override
  _FacebookScreenState createState() => _FacebookScreenState();
}

class _FacebookScreenState extends State<FacebookScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: 'https://www.facebook.com/fasttrackemarat/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
        // javascriptChannels: <JavascriptChannel>{
        //   _toasterJavascriptChannel(context),
        // },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.instagram.com/fasttrackemarat/')) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
