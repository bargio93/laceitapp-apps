import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laceitapp/firebase.dart' as Firebase;
import 'package:laceitapp/firebase_options.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:laceitapp/Permissions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() async {
  Firebase.inizializeFirebase();
  runApp(const MyApp());

}


class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //firebaseFunction();
    var status = Permissions.checkServiceStatus(context);
    print(status);
    return  OverlaySupport.global(child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    ));
  }

  void firebaseFunction() async {
    Firebase.getToken();
    Firebase.listenForegroundMessage();


  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late WebViewController _controller;
  DateTime pre_backpress = DateTime.now();

    void initState() {

      super.initState();
      // Enable virtual display.
      try{
        if(Platform.isAndroid) {
          WebView.platform = AndroidWebView();
        }
        else if(Platform.isIOS) {

        } else {

        }
      } catch(e){
      }
    }

    @override
    Widget build(BuildContext context) {

      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [
          SystemUiOverlay.bottom, // Shows Status bar and hides Navigation bar
        ],
      );

      return Scaffold(
          body:WillPopScope(
          onWillPop: () => _exitApp(context),
      child:WebView(

        initialUrl: 'https://laceitapp.it/app/home',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        gestureNavigationEnabled: true,
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://laceitapp.it/')) {
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
      )));
    }
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.canGoBack()) {
      print("onwill goback");
      _controller.goBack();
      return Future.value(false);
    } else if (await _controller.canGoBack()==false){
      final timegap = DateTime.now().difference(pre_backpress);
      final cantExit = timegap >= Duration(seconds: 2);
      pre_backpress = DateTime.now();
      if(cantExit){
        //show snackbar
        final snack = SnackBar(content: Text('Press Back button again to Exit'),duration: Duration(seconds: 2),);
        ScaffoldMessenger.of(context).showSnackBar(snack);
        return Future.value(false);
      }
      return Future.value(true);
    }
    return Future.value(false);
  }
}
