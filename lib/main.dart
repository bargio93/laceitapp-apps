import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:laceitapp/firebase.dart' as Firebase;
import 'package:laceitapp/firebase_options.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:laceitapp/Permissions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laceitapp/navbar.dart';
import 'package:application_icon/application_icon.dart';

/*import 'package:flutter_webview_pro/platform_interface.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
*/
void main() async {
  //Firebase.inizializeFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //firebaseFunction();
    var status = Permissions.checkServiceStatus(context);
    print(status);

    //SystemChrome.setEnabledSystemUIOverlays ([]);
    return MaterialApp(
        themeMode: ThemeMode.light,
        title: 'LaceItApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: EasyLoading.init(),
        home: Scaffold(
          body: SafeArea(child: MyHomePage()),
        ));
  }

  void firebaseFunction() async {
    Firebase.getToken();
    Firebase.listenForegroundMessage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _controller;
  final String baseUrl = 'https://appprod.ddbvjes0hdtuq.amplifyapp.com';
  String uri = "/app/maps";
  String home = 'https://appprod.ddbvjes0hdtuq.amplifyapp.com/app/home';
  DateTime pre_backpress = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  /*void changeUrl(String newUri) {
    print(newUri);
    setState(() {
      uri = newUri;
    });
    _controller.loadUrl(baseUrl + uri);
  }
  */


  /*
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
   */

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [
          SystemUiOverlay.top, // Shows Status bar and hides Navigation bar
        ],
      );
      */

    /*EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.dark
        ..progressColor = Color(0xff9B2335)
        ..maskColor = Colors.blue.withOpacity(0.5);

       */

    //print(baseUrl + uri);
    return Scaffold(
        body: WillPopScope(
            onWillPop: () => _exitApp(context),
            child: Stack(
              children: <Widget>[
                WebView(
                    //geolocationEnabled: true,
                    zoomEnabled: false,
                    initialUrl: Uri.encodeFull('https://appprod.ddbvjes0hdtuq.amplifyapp.com'),
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                    },
                    onPageFinished: (url) {
                      setState(() {
                        isLoading = false;
                      });
                      _controller.evaluateJavascript("console.log('Hello')");
                    },
                    gestureNavigationEnabled: true,
                    onProgress: (int progress) {
                      print('WebView is loading (progress : $progress%)');
                    },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    },
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.startsWith(
                          'https://appprod.ddbvjes0hdtuq.amplifyapp.com')) {
                        print('blocking navigation to $request}');
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    }),
                isLoading
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Image.asset('images/logo_red.webp',width: 150,),
                            SizedBox(height: 50),
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Color(0xff9B2335),
                            )
                          ],
                        ),
                      )
                    : Stack(),
              ],
            )),
        //bottomNavigationBar: MyNavBarWidget(callBackFuntion: changeUrl)
    );
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
    } else if (await _controller.canGoBack() == false) {
      final timegap = DateTime.now().difference(pre_backpress);
      final cantExit = timegap >= Duration(seconds: 2);
      pre_backpress = DateTime.now();
      if (cantExit) {
        //show snackbar
        final snack = SnackBar(
          content: Text('Press Back button again to Exit'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
        return Future.value(false);
      }
      return Future.value(true);
    }
    return Future.value(false);
  }
}
