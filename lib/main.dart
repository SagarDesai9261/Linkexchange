import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Key? key;
  const MyApp({this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Link exchange hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  final String initialUrl = 'https://www.app.keybrainstech.com/login';

  @override
  void initState() {
    super.initState();
    /*checkAndRequestLocationPermission();
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      checkAndRequestLocationPermission();
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }


  InAppWebViewController? _webViewController;
  bool _isLoggedIn =
      false; // You can initialize this based on saved login state.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_webViewController!.canGoBack != null &&
                await _webViewController!.canGoBack()) {
              _webViewController!.goBack();
              return false;
            }
            return true;
          },
          child: InAppWebView(

            initialUrlRequest: URLRequest(
                url: Uri.parse('https://www.app.keybrainstech.com/login')),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                supportZoom: false,
                useShouldOverrideUrlLoading: true,
                useOnLoadResource: true,
                javaScriptEnabled: true,
              ),
            ),
            onConsoleMessage: (controller, consoleMessage) {
              print('Console Message: ${consoleMessage.message}');
            },
            onWebViewCreated: (controller) {
              _webViewController = controller;
              // You can add any additional setup code here.
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              if (!_isLoggedIn &&
                  navigationAction.request.url
                      .toString()
                      .contains('successful_login_url')) {
                // Handle the successful login URL, e.g., extract tokens and login information.
                setState(() {
                  _isLoggedIn = true;
                });
                // Save login state using shared_preferences or flutter_secure_storage.
                // Redirect to the main content page or do any other desired actions.
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
        ),
      ),
    );
  }
}
