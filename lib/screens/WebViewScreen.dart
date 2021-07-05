import 'dart:async';
import 'dart:io';

import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("${WebViewState.finishLoad}");
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(ExtraColors.darkBlueAccent));
    return SafeArea(
        child: Scaffold(
      body: WebviewScaffold(
        url: 'https://www.fasttrackemarat.com/',
        withLocalStorage: true,
        withZoom: true,
        initialChild: Center(child: Text("Loading...")),
      ),
    ));
  }
}
