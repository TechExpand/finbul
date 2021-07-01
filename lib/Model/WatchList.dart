import 'package:fin_bul/Utils/utils.dart';

class WatchListModel {
  final String id;
  final userid;
  final symbol;
  final DateTime createdAt;

  const WatchListModel({
    this.id,
  this.symbol,
    this.userid,
    this.createdAt,
  });

  WatchListModel.fromMap(Map snapshot, String id)
      : id = id ?? '',
        symbol = snapshot['symbol'] ?? '',
        userid = snapshot['userid'] ?? '',
        createdAt = Utils.toDateTime(snapshot['createdAt']);

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'userid': userid,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}
