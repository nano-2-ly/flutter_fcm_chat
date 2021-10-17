class Chat {
  String chatUUID;
  String uid;
  String createAt;
  String description;


  Chat(this.chatUUID, this.uid, this.createAt, this.description);

  Chat.fromJson(Map<String, dynamic> json)
      : chatUUID = json['chatUUID'],
        uid = json['uid'],
        createAt = json['createAt'],
        description = json['description'];


  Map<String, dynamic> toJson() =>
      {
        'chatUUID' : chatUUID,
        'uid': uid,
        'createAt': createAt,
        'description': description,
      };

  Map<String, dynamic> toMap() {
    return {
      'chatUUID': chatUUID,
      'uid': uid,
      'createAt': createAt,
      'description': description,
    };
  }
}