// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Message extends _Message with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Message(
    int? id,
    int sendId, {
    String? sendNickName,
    int? receiveId,
    int? sessionId,
    String sessionType = "group",
    int readCount = 0,
    bool receipt = false,
    bool receiptOk = false,
    int type = 0,
    String? content,
    int sendTime = 0,
    int status = 0,
    Iterable<int?> atUserIds = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Message>({
        'sessionType': "group",
        'readCount': 0,
        'receipt': false,
        'receiptOk': false,
        'type': 0,
        'sendTime': 0,
        'status': 0,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'sendNickName', sendNickName);
    RealmObjectBase.set(this, 'sendId', sendId);
    RealmObjectBase.set(this, 'receiveId', receiveId);
    RealmObjectBase.set(this, 'sessionId', sessionId);
    RealmObjectBase.set(this, 'sessionType', sessionType);
    RealmObjectBase.set(this, 'readCount', readCount);
    RealmObjectBase.set(this, 'receipt', receipt);
    RealmObjectBase.set(this, 'receiptOk', receiptOk);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'sendTime', sendTime);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set<RealmList<int?>>(
        this, 'atUserIds', RealmList<int?>(atUserIds));
  }

  Message._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get sendNickName =>
      RealmObjectBase.get<String>(this, 'sendNickName') as String?;
  @override
  set sendNickName(String? value) =>
      RealmObjectBase.set(this, 'sendNickName', value);

  @override
  int get sendId => RealmObjectBase.get<int>(this, 'sendId') as int;
  @override
  set sendId(int value) => RealmObjectBase.set(this, 'sendId', value);

  @override
  int? get receiveId => RealmObjectBase.get<int>(this, 'receiveId') as int?;
  @override
  set receiveId(int? value) => RealmObjectBase.set(this, 'receiveId', value);

  @override
  int? get sessionId => RealmObjectBase.get<int>(this, 'sessionId') as int?;
  @override
  set sessionId(int? value) => RealmObjectBase.set(this, 'sessionId', value);

  @override
  String get sessionType =>
      RealmObjectBase.get<String>(this, 'sessionType') as String;
  @override
  set sessionType(String value) =>
      RealmObjectBase.set(this, 'sessionType', value);

  @override
  int get readCount => RealmObjectBase.get<int>(this, 'readCount') as int;
  @override
  set readCount(int value) => RealmObjectBase.set(this, 'readCount', value);

  @override
  bool get receipt => RealmObjectBase.get<bool>(this, 'receipt') as bool;
  @override
  set receipt(bool value) => RealmObjectBase.set(this, 'receipt', value);

  @override
  bool get receiptOk => RealmObjectBase.get<bool>(this, 'receiptOk') as bool;
  @override
  set receiptOk(bool value) => RealmObjectBase.set(this, 'receiptOk', value);

  @override
  int get type => RealmObjectBase.get<int>(this, 'type') as int;
  @override
  set type(int value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get content =>
      RealmObjectBase.get<String>(this, 'content') as String?;
  @override
  set content(String? value) => RealmObjectBase.set(this, 'content', value);

  @override
  int get sendTime => RealmObjectBase.get<int>(this, 'sendTime') as int;
  @override
  set sendTime(int value) => RealmObjectBase.set(this, 'sendTime', value);

  @override
  int get status => RealmObjectBase.get<int>(this, 'status') as int;
  @override
  set status(int value) => RealmObjectBase.set(this, 'status', value);

  @override
  RealmList<int?> get atUserIds =>
      RealmObjectBase.get<int?>(this, 'atUserIds') as RealmList<int?>;
  @override
  set atUserIds(covariant RealmList<int?> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Message>> get changes =>
      RealmObjectBase.getChanges<Message>(this);

  @override
  Stream<RealmObjectChanges<Message>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Message>(this, keyPaths);

  @override
  Message freeze() => RealmObjectBase.freezeObject<Message>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'sendNickName': sendNickName.toEJson(),
      'sendId': sendId.toEJson(),
      'receiveId': receiveId.toEJson(),
      'sessionId': sessionId.toEJson(),
      'sessionType': sessionType.toEJson(),
      'readCount': readCount.toEJson(),
      'receipt': receipt.toEJson(),
      'receiptOk': receiptOk.toEJson(),
      'type': type.toEJson(),
      'content': content.toEJson(),
      'sendTime': sendTime.toEJson(),
      'status': status.toEJson(),
      'atUserIds': atUserIds.toEJson(),
    };
  }

  static EJsonValue _toEJson(Message value) => value.toEJson();
  static Message _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'sendId': EJsonValue sendId,
      } =>
        Message(
          fromEJson(ejson['id']),
          fromEJson(sendId),
          sendNickName: fromEJson(ejson['sendNickName']),
          receiveId: fromEJson(ejson['receiveId']),
          sessionId: fromEJson(ejson['sessionId']),
          sessionType: fromEJson(ejson['sessionType'], defaultValue: "group"),
          readCount: fromEJson(ejson['readCount'], defaultValue: 0),
          receipt: fromEJson(ejson['receipt'], defaultValue: false),
          receiptOk: fromEJson(ejson['receiptOk'], defaultValue: false),
          type: fromEJson(ejson['type'], defaultValue: 0),
          content: fromEJson(ejson['content']),
          sendTime: fromEJson(ejson['sendTime'], defaultValue: 0),
          status: fromEJson(ejson['status'], defaultValue: 0),
          atUserIds: fromEJson(ejson['atUserIds'], defaultValue: const []),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Message._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Message, 'Message', [
      SchemaProperty('id', RealmPropertyType.int,
          optional: true, primaryKey: true),
      SchemaProperty('sendNickName', RealmPropertyType.string, optional: true),
      SchemaProperty('sendId', RealmPropertyType.int),
      SchemaProperty('receiveId', RealmPropertyType.int, optional: true),
      SchemaProperty('sessionId', RealmPropertyType.int, optional: true),
      SchemaProperty('sessionType', RealmPropertyType.string),
      SchemaProperty('readCount', RealmPropertyType.int),
      SchemaProperty('receipt', RealmPropertyType.bool),
      SchemaProperty('receiptOk', RealmPropertyType.bool),
      SchemaProperty('type', RealmPropertyType.int),
      SchemaProperty('content', RealmPropertyType.string, optional: true),
      SchemaProperty('sendTime', RealmPropertyType.int),
      SchemaProperty('status', RealmPropertyType.int),
      SchemaProperty('atUserIds', RealmPropertyType.int,
          optional: true, collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
