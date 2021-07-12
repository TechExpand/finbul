
import 'package:finbul/Utils/utils.dart';
import 'package:flutter/material.dart';


class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idUser;
  final String urlAvatar;
  final String username;
  final String message;
  final chatId;
  final DateTime createdAt;

  const Message({
    @required this.idUser,
    this.chatId,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    @required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    chatId: json['chatId'],
    idUser: json['idUser'],
    urlAvatar: json['urlAvatar'],
    username: json['username'],
    message: json['message'],
    createdAt: Utils.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'idUser': idUser,
    'chatId': chatId,
    'urlAvatar': urlAvatar,
    'username': username,
    'message': message,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}
