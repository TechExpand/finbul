import 'package:finbul/Utils/utils.dart';


class UserChat {
  String id;
  final String userid;
  final String name;
  bool read;
  var block;
  var status;
  final String urlAvatar;
  final String project_owner_user_id;
  final String bid_id;
  final String job_id;
  final String service_id;
  final String docid;
  var lastMessageTime;
  final String lastMessage;
  final String userMobile;

  UserChat({
    this.id,
    this.name,
    this.userid,
    this.block,
    this.read,
    this.status,
    this.urlAvatar,
    this.docid,
    this.lastMessage,
    this.bid_id,
    this.job_id,
    this.project_owner_user_id,
    this.service_id,
    this.userMobile,
    this.lastMessageTime,
  });

  UserChat.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        bid_id = snapshot['bid_id'] ?? '',
        job_id = snapshot['project_id'] ?? '',
        service_id = snapshot['service_id'] ?? '',
        read = snapshot['read'] ?? '',
        lastMessage = snapshot['lastMessage'] ?? '',
        lastMessageTime = Utils.toDateTime(snapshot['lastMessageTime']),
        block = snapshot['block'] ?? '',
        userid = snapshot['userid'] ?? '',
        docid = snapshot['docid'] ?? '',
        project_owner_user_id = snapshot['project_owner_user_id'] ?? '',
        urlAvatar = snapshot['urlAvatar'] ?? '',
        userMobile = snapshot['userMobile'] ?? '',
        status = snapshot['status'] ?? '';

  toJson() {
    return {
      "name": name,
      'project_owner_user_id': project_owner_user_id,
      "read": read,
      'bid_id': bid_id,
      'project_id': job_id,
      'service_bid': service_id,
      'id': id,
      'lastMessage': lastMessage,
      'lastMessageTime': Utils.toDateTime(lastMessageTime),
      'block': block,
      'userid': userid,
      'docid': docid,
      'urlAvatar': urlAvatar,
      'userMobile': userMobile,
      'status': status,
    };
  }
}
