import 'package:finbul/Utils/utils.dart';
import 'package:meta/meta.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class MyUser {
  final String idUser;
  final String name;
  final bool read;
  final bool block;
  final bool status;
  final String urlAvatar;
  final String docid;
  final DateTime lastMessageTime;
  final String lastMessage;
  final String userMobile;

  const MyUser({
    this.idUser,
    this.read,
    this.userMobile,
    this.block,
    this.docid,
    this.status,
    @required this.name,
    @required this.lastMessage,
    @required this.urlAvatar,
    @required this.lastMessageTime,
  });

  MyUser copyWith({
    String idUser,
    String docid,
    String userMobile,
    String name,
    bool block,
    bool read,
    bool status,
    String urlAvatar,
    String lastMessage,
    String lastMessageTime,
  }) =>
      MyUser(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        docid: docid ?? this.docid,
        block: block?? this.block,
        read: read ?? this.read,
        userMobile: userMobile?? this.userMobile,
        status: status ?? this.status,
        lastMessage: lastMessage ?? this.lastMessage,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static MyUser fromJson([Map<String, dynamic> json, id]) => MyUser(
    idUser: json['idUser'],
    read: json['read'],
    name: json['name'],
    block: json['block'],
    status: json['[status'],
    userMobile: json['userMobile'],
    docid: id ?? '',
    lastMessage: json['lastMessage'],
    urlAvatar: json['urlAvatar'],
    lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
  );



  Map<String, dynamic> toJson() => {
    'idUser': idUser,
    'read': read,
    'docid': docid,
    'userMobile': userMobile,
    'name': name,
    'status': status,
    'block': block,
    'lastMessage': lastMessage,
    'urlAvatar': urlAvatar,
    'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
  };
}
