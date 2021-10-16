import 'package:flutter_fcm_chat/model/chatModel.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  final chatList = <Chat>[].obs;

  void add(chatItem){
    chatList.add(chatItem);
  }
}