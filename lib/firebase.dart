import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:laceitapp/firebase_options.dart';
import 'package:overlay_support/overlay_support.dart';


FirebaseMessaging messaging = FirebaseMessaging.instance;

void inizializeFirebase()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("INITIALIZZO FIREBASE");
  setNotification();
  listBackgroudMessage();
}

void getToken() async {
  messaging = FirebaseMessaging.instance;
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("TOKEN");
  print(fcmToken);
}

void setNotification()async{
  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
  );
  print('User granted permission: ${settings.authorizationStatus}');
}

void listenForegroundMessage(){
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    showSimpleNotification(
        Text('${message.notification?.title}'),
        subtitle: Text('${message.notification?.body}'),
        background: Color(0xff9b2335));
    if (message.notification != null) {
      print(message.notification?.body);
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

void listBackgroudMessage(){
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}