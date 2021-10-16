import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fcm_chat/controller/chatController.dart';
import 'package:flutter_fcm_chat/model/chatModel.dart';
import 'package:flutter_fcm_chat/widgets/chatTile.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("💬"),
        onPressed: (){
          makePushNotification();
        },
      ),
      body: Container(
        child: Obx(()=> ListView.builder(
          // controller: scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: controller.chatList.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatTile(controller.chatList[index]);
          },
        ))
      ),
    );
  }

  void makePushNotification() async{
    var url = Uri.parse("https://userserver.bighornapi.com/lambda/pushNotification");

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body:  jsonEncode(
          <String, String>{
            'code': "1",
            "content":"{\"chatUUID\":\"1\",\"uid\":\"G-123\",\"createAt\":\"2021-10-17\",\"description\":\"hello, friend!\"}",
          }
      ),
    );

    List<dynamic> list = json.decode(response.body);

  }

}

