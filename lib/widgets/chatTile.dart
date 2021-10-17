
import 'package:flutter/material.dart';
import 'package:flutter_fcm_chat/model/chatModel.dart';

class ChatTile extends StatelessWidget {
  ChatTile(this._chat);

  final Chat _chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_chat.description),
      subtitle: Text("${_chat.createAt}"),
    );
  }
}
