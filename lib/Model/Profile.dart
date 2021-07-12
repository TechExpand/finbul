import 'package:finbul/Utils/utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Profile {
  final String id;
  final userid;
  final coverImage;
  final username;
  final String name;
  final picture;
  final number;
  final DateTime createdAt;

  const Profile({
    this.id,
   this.username,
    this.userid,
    this.name,
    this.picture,
    this.coverImage,
    this.number,
    this.createdAt,
  });

  Profile.fromMap(Map snapshot, String id)
      : id = id ?? '',
        username = snapshot['username'] ?? '',
        number = snapshot['number']??'',
        name = snapshot['name'] ?? '',
        coverImage = snapshot['coverImage']??'',
        picture = snapshot['picture'] ?? '',
        userid = snapshot['userid'] ?? '',
        createdAt = Utils.toDateTime(snapshot['createdAt']);

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'number': number,
    'coverImage': coverImage,
    'picture': picture,
    'userid': userid,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}
