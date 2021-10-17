import 'package:flutter_fcm_chat/model/chatModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



void writeDB (Chat _chat) async{
  final database = openDatabase(
    // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
    // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
    join(await getDatabasesPath(), 'chat_database.db'),
    // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE chat(id INTEGER PRIMARY KEY AUTOINCREMENT , chatUUID TEXT, uid TEXT, createAt TEXT, description TEXT)",
      );
    },
    // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
    // 수행하기 위한 경로를 제공합니다.
    version: 1,
  );

  final Database db = await database;

  // Dog를 올바른 테이블에 추가합니다. 동일한 dog가 두번 추가되는 경우를 처리하기 위해
  // `conflictAlgorithm`을 명시할 수 있습니다.
  //
  // 본 예제에서는, 이전 데이터를 갱신하도록 하겠습니다.
  await db.insert(
    'chat',
    _chat.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Chat>> readDB (String chatUUID) async{
  final database = openDatabase(
    // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
    // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
    join(await getDatabasesPath(), 'chat_database.db'),
    // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE chat(id INTEGER PRIMARY KEY AUTOINCREMENT , chatUUID TEXT, uid TEXT, createAt TEXT, description TEXT)",
      );
    },
    // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
    // 수행하기 위한 경로를 제공합니다.
    version: 1,
  );

  final Database db = await database;

  // Dog를 올바른 테이블에 추가합니다. 동일한 dog가 두번 추가되는 경우를 처리하기 위해
  // `conflictAlgorithm`을 명시할 수 있습니다.
  //
  // 본 예제에서는, 이전 데이터를 갱신하도록 하겠습니다.
  List<Map<String,dynamic>> maps = await  db.rawQuery('SELECT * FROM chat WHERE chatUUID=?', ['$chatUUID']);

  List<Chat> _chatList = [];
  for(int i=0; i< maps.length; i++){
    _chatList.add(Chat(maps[i]['chatUUID'],maps[i]['uid'],maps[i]['createAt'],maps[i]['description'],));
  }

  return _chatList;
}
