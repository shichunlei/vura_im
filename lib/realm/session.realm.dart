// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Session extends _Session with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Session(
    String _id, {
    int? userId,
    String type = "group",
    int? id,
    String? name,
    int? ownerId,
    String? headImage,
    String? headImageThumb,
    String? notice,
    String? remarkNickName,
    String? showNickName,
    String? showGroupName,
    String? remarkGroupName,
    bool deleted = false,
    bool quit = false,
    String? lastMessage,
    int lastMessageTime = 0,
    bool moveTop = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Session>({
        'type': "group",
        'deleted': false,
        'quit': false,
        'lastMessageTime': 0,
        'moveTop': false,
      });
    }
    RealmObjectBase.set(this, '_id', _id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'ownerId', ownerId);
    RealmObjectBase.set(this, 'headImage', headImage);
    RealmObjectBase.set(this, 'headImageThumb', headImageThumb);
    RealmObjectBase.set(this, 'notice', notice);
    RealmObjectBase.set(this, 'remarkNickName', remarkNickName);
    RealmObjectBase.set(this, 'showNickName', showNickName);
    RealmObjectBase.set(this, 'showGroupName', showGroupName);
    RealmObjectBase.set(this, 'remarkGroupName', remarkGroupName);
    RealmObjectBase.set(this, 'deleted', deleted);
    RealmObjectBase.set(this, 'quit', quit);
    RealmObjectBase.set(this, 'lastMessage', lastMessage);
    RealmObjectBase.set(this, 'lastMessageTime', lastMessageTime);
    RealmObjectBase.set(this, 'moveTop', moveTop);
  }

  Session._();

  @override
  String get _id => RealmObjectBase.get<String>(this, '_id') as String;
  @override
  set _id(String value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get ownerId => RealmObjectBase.get<int>(this, 'ownerId') as int?;
  @override
  set ownerId(int? value) => RealmObjectBase.set(this, 'ownerId', value);

  @override
  String? get headImage =>
      RealmObjectBase.get<String>(this, 'headImage') as String?;
  @override
  set headImage(String? value) => RealmObjectBase.set(this, 'headImage', value);

  @override
  String? get headImageThumb =>
      RealmObjectBase.get<String>(this, 'headImageThumb') as String?;
  @override
  set headImageThumb(String? value) =>
      RealmObjectBase.set(this, 'headImageThumb', value);

  @override
  String? get notice => RealmObjectBase.get<String>(this, 'notice') as String?;
  @override
  set notice(String? value) => RealmObjectBase.set(this, 'notice', value);

  @override
  String? get remarkNickName =>
      RealmObjectBase.get<String>(this, 'remarkNickName') as String?;
  @override
  set remarkNickName(String? value) =>
      RealmObjectBase.set(this, 'remarkNickName', value);

  @override
  String? get showNickName =>
      RealmObjectBase.get<String>(this, 'showNickName') as String?;
  @override
  set showNickName(String? value) =>
      RealmObjectBase.set(this, 'showNickName', value);

  @override
  String? get showGroupName =>
      RealmObjectBase.get<String>(this, 'showGroupName') as String?;
  @override
  set showGroupName(String? value) =>
      RealmObjectBase.set(this, 'showGroupName', value);

  @override
  String? get remarkGroupName =>
      RealmObjectBase.get<String>(this, 'remarkGroupName') as String?;
  @override
  set remarkGroupName(String? value) =>
      RealmObjectBase.set(this, 'remarkGroupName', value);

  @override
  bool get deleted => RealmObjectBase.get<bool>(this, 'deleted') as bool;
  @override
  set deleted(bool value) => RealmObjectBase.set(this, 'deleted', value);

  @override
  bool get quit => RealmObjectBase.get<bool>(this, 'quit') as bool;
  @override
  set quit(bool value) => RealmObjectBase.set(this, 'quit', value);

  @override
  String? get lastMessage =>
      RealmObjectBase.get<String>(this, 'lastMessage') as String?;
  @override
  set lastMessage(String? value) =>
      RealmObjectBase.set(this, 'lastMessage', value);

  @override
  int get lastMessageTime =>
      RealmObjectBase.get<int>(this, 'lastMessageTime') as int;
  @override
  set lastMessageTime(int value) =>
      RealmObjectBase.set(this, 'lastMessageTime', value);

  @override
  bool get moveTop => RealmObjectBase.get<bool>(this, 'moveTop') as bool;
  @override
  set moveTop(bool value) => RealmObjectBase.set(this, 'moveTop', value);

  @override
  Stream<RealmObjectChanges<Session>> get changes =>
      RealmObjectBase.getChanges<Session>(this);

  @override
  Stream<RealmObjectChanges<Session>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Session>(this, keyPaths);

  @override
  Session freeze() => RealmObjectBase.freezeObject<Session>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': _id.toEJson(),
      'userId': userId.toEJson(),
      'type': type.toEJson(),
      'id': id.toEJson(),
      'name': name.toEJson(),
      'ownerId': ownerId.toEJson(),
      'headImage': headImage.toEJson(),
      'headImageThumb': headImageThumb.toEJson(),
      'notice': notice.toEJson(),
      'remarkNickName': remarkNickName.toEJson(),
      'showNickName': showNickName.toEJson(),
      'showGroupName': showGroupName.toEJson(),
      'remarkGroupName': remarkGroupName.toEJson(),
      'deleted': deleted.toEJson(),
      'quit': quit.toEJson(),
      'lastMessage': lastMessage.toEJson(),
      'lastMessageTime': lastMessageTime.toEJson(),
      'moveTop': moveTop.toEJson(),
    };
  }

  static EJsonValue _toEJson(Session value) => value.toEJson();
  static Session _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue _id,
      } =>
        Session(
          fromEJson(_id),
          userId: fromEJson(ejson['userId']),
          type: fromEJson(ejson['type'], defaultValue: "group"),
          id: fromEJson(ejson['id']),
          name: fromEJson(ejson['name']),
          ownerId: fromEJson(ejson['ownerId']),
          headImage: fromEJson(ejson['headImage']),
          headImageThumb: fromEJson(ejson['headImageThumb']),
          notice: fromEJson(ejson['notice']),
          remarkNickName: fromEJson(ejson['remarkNickName']),
          showNickName: fromEJson(ejson['showNickName']),
          showGroupName: fromEJson(ejson['showGroupName']),
          remarkGroupName: fromEJson(ejson['remarkGroupName']),
          deleted: fromEJson(ejson['deleted'], defaultValue: false),
          quit: fromEJson(ejson['quit'], defaultValue: false),
          lastMessage: fromEJson(ejson['lastMessage']),
          lastMessageTime: fromEJson(ejson['lastMessageTime'], defaultValue: 0),
          moveTop: fromEJson(ejson['moveTop'], defaultValue: false),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Session._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Session, 'Session', [
      SchemaProperty('_id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.int, optional: true),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('ownerId', RealmPropertyType.int, optional: true),
      SchemaProperty('headImage', RealmPropertyType.string, optional: true),
      SchemaProperty('headImageThumb', RealmPropertyType.string,
          optional: true),
      SchemaProperty('notice', RealmPropertyType.string, optional: true),
      SchemaProperty('remarkNickName', RealmPropertyType.string,
          optional: true),
      SchemaProperty('showNickName', RealmPropertyType.string, optional: true),
      SchemaProperty('showGroupName', RealmPropertyType.string, optional: true),
      SchemaProperty('remarkGroupName', RealmPropertyType.string,
          optional: true),
      SchemaProperty('deleted', RealmPropertyType.bool),
      SchemaProperty('quit', RealmPropertyType.bool),
      SchemaProperty('lastMessage', RealmPropertyType.string, optional: true),
      SchemaProperty('lastMessageTime', RealmPropertyType.int),
      SchemaProperty('moveTop', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
