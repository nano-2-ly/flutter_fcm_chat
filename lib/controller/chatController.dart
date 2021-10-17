import 'package:flutter_fcm_chat/model/chatModel.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatController extends GetxController{

  RxList<dynamic> chatList = <dynamic>[].obs;


  void addChat(chatItem){

    chatList.add(chatItem);
    print(chatList);
  }
}