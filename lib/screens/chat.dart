import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fcm_chat/controller/chatController.dart';
import 'package:flutter_fcm_chat/controller/chatRoomController.dart';
import 'package:flutter_fcm_chat/model/DB.dart';
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
  var roomController = Get.put(ChatRoomController());
  var chatController = Get.put(ChatController());
  @override
  void initState() {
    // TODO: implement initState
    readChatLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("💬"),
        onPressed: (){
          makePushNotification();
          readDB(roomController.chatRoom.value);
        },
      ),
      body: Container(
        child:
        Obx(()=> ListView.builder(
          // controller: scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: chatController.chatList.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatTile(chatController.chatList[index]);
          },
        ))


      ),
    );
  }

  void readChatLog() async{
    print("initState() : ");
    print(await readDB(roomController.chatRoom.value));

    chatController.chatList.value = (await readDB(roomController.chatRoom.value));
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
            'code': "${roomController.chatRoom}",
            "content":"{\"chatUUID\":\"${roomController.chatRoom}\",\"uid\":\"G-123\",\"createAt\":\"${DateTime.now()}\",\"description\":\"hello\"}",
          }
      ),
    );


  }

}

