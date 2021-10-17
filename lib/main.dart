import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_fcm_chat/controller/chatController.dart';
import 'package:flutter_fcm_chat/model/chatModel.dart';
import 'package:flutter_fcm_chat/screens/chat.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'controller/chatRoomController.dart';
import 'model/DB.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('FCM'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fcm_ready();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _initNotiSetting();
  }

  @override

  Widget build(BuildContext context) {
    final controller = Get.put(ChatRoomController());
    return Container(
        child: ListView(
      children: [
        RaisedButton(
            child: Text("room 1"),
            onPressed: () {
              controller.chatRoom.value = "room1";
              Get.to(ChatScreen());
            }),
        RaisedButton(
            child: Text("room 2"),
            onPressed: () {
              controller.chatRoom.value = "room2";
              Get.to(ChatScreen());
            }),
      ],
    ));
  }
}



void fcm_ready() async {
  final FirebaseApp _initialization = await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final controller = Get.put(ChatController());
// use the returned token to send messages to users from your custom server

  print('FlutterFire Messaging Example: Subscribing to topic "1".');
  await FirebaseMessaging.instance.subscribeToTopic("room1");
  print('FlutterFire Messaging Example: Subscribing to topic "1" successful.');

  print('FlutterFire Messaging Example: Subscribing to topic "2".');
  await FirebaseMessaging.instance.subscribeToTopic("room2");
  print('FlutterFire Messaging Example: Subscribing to topic "2" successful.');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${jsonDecode(message.notification!.body!)["description"]}');

      Chat _chat = Chat.fromJson(jsonDecode(message.notification!.body!));
      print(_chat);

      controller.addChat(_chat);
      writeDB(_chat);
    }

    _showNotification(message);
  });
}



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  Chat _chat = Chat.fromJson(jsonDecode(message.notification!.body!));
  writeDB(_chat);
}

void _initNotiSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  final initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );
}

Future<void> _showNotification(RemoteMessage message) async {
  var _flutterLocalNotificationsPlugin;

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  var initializationSettingsIOS = IOSInitializationSettings();

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  _flutterLocalNotificationsPlugin.initialize(initializationSettings);

  var android = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.max, priority: Priority.high);

  var ios = IOSNotificationDetails();
  var detail = NotificationDetails(android: android, iOS: ios);
  print(message);
  await _flutterLocalNotificationsPlugin.show(
    0,
    'notification',
    message.notification!.body.toString(),
    detail,
    payload: 'Hello Flutter',
  );
}
