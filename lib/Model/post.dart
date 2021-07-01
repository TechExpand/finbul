import 'package:fin_bul/Utils/utils.dart';

class Post {
  final String id;
  final userid;
  final username;
  final phone;
  final String message;
  final imageSent;
  final comment;
  final status;
  final thumbup;
  final thumbdown;
  final picture;
  final String name;
  final DateTime createdAt;

  const Post({
    this.id,
    this.comment,
    this.thumbdown,
    this.status,
    this.picture,
    this.thumbup,
    this.username,
    this.message,
    this.userid,
    this.phone,
    this.name,
    this.imageSent,
    this.createdAt,
  });

  Post.fromMap(Map snapshot, String id)
      : id = id ?? '',
        message = snapshot['message'] ?? '',
        comment = snapshot['comment'] ?? '',
        status = snapshot['status'] ?? '',
        name = snapshot['name'] ?? '',
        username = snapshot['username'] ?? '',
        thumbup = snapshot['uplike'] ?? '',
        phone = snapshot['phone'] ?? '',
        picture = snapshot['picture'] ?? '',
        imageSent = snapshot['imageSent'] ?? '',
        thumbdown = snapshot['downlike'] ?? '',
        userid = snapshot['userid'] ?? '',
        createdAt = Utils.toDateTime(snapshot['createdAt']);

  Map<String, dynamic> toJson() => {
        'message': message,
        'uplike': thumbup,
        'phone': phone,
        'status': status,
        'downlike': thumbdown,
        'name': name,
        'imageSent': imageSent,
        'picture': picture,
        'username': username,
        'comment': comment,
        'userid': userid,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}
