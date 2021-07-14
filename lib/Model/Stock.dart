import 'package:flutter/material.dart';


class Symbol2 {
  final String symbol;
  final String instrument_name;

  Symbol2({
    @required this.symbol,
    this.instrument_name,
  });

  static Symbol2 fromJson(Map<String, dynamic> json) => Symbol2(
      symbol: json['symbol'],
      instrument_name: json['name']
  );

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name':instrument_name,
  };
}

class Symbol {
  final String symbol;

  const Symbol({
    @required this.symbol,
  });

  static Symbol fromJson(Map<String, dynamic> json) => Symbol(
        symbol: json['symbol'],
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
      };
}


class Sqoute {
  final String symbol;
  final String name;
  final String exchange;
  final String datetime;
  final String open;
  final String high;
  final String low;
  final String close;
  final String volume;
  final String previous_close;
  final String change;
  final String percent_change;
  final String average_volume;
  final String currency;

  const Sqoute({
    @required this.symbol,
    @required this.name,
    @required this.exchange,
    @required this.datetime,
    @required this.open,
    @required this.high,
    @required this.average_volume,
    @required this.change,
    @required this.percent_change,
    @required this.close,
    @required this.low,
    @required this.previous_close,
    @required this.volume,
    @required this.currency,
  });

  static Sqoute fromJson(Map<String, dynamic> json) => Sqoute(
        symbol: json['symbol'],
        name: json['name'],
        high: json['high'],
        low: json['low'],
        average_volume: json['average_volume'],
        change: json['change'],
        percent_change: json['percent_change'],
        open: json['open'],
        close: json['close'],
        currency: json['currency'],
        volume: json['volume'],
        previous_close: json['previous_close'],
        datetime: json['datetime'],
        exchange: json['exchange'],
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'name': name,
        'high': high,
        'low': low,
        'average_volume': average_volume,
        'change': change,
        'percent_change': percent_change,
        'open': open,
        'close': close,
        'currency': currency,
        'volume': volume,
        'previous_close': previous_close,
        'datetime': datetime,
        'exchange': exchange,
      };
}





class trendingSqoute {
  final String symbol;
  final String companyName;
  final String changesPercentage;
  final String price;
  final double changes;


  const trendingSqoute({
    @required this.companyName,
    @required this.price,
    @required this.symbol,
    @required this.changes,
    @required this.changesPercentage,
  });

  static trendingSqoute fromJson(Map<String, dynamic> json) => trendingSqoute(
    changes: json['changes'],
    companyName: json['companyName'],
    changesPercentage: json['changesPercentage'],
    symbol: json['ticker'],
    price: json['price'],
  );

  Map<String, dynamic> toJson() => {
    'price': price,
    'companyName': companyName,
    'ticker': symbol,
    'changesPercentage': changesPercentage,
    'changes': changes,
  };
}



class SqouteDetail {
  final String symbol;
  final String name;
  final String exchange;
  final int datetime;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;
  final double previous_close;
  final double change;
  final double percent_change;
  final int average_volume;

  const SqouteDetail({
    @required this.symbol,
    @required this.name,
    @required this.exchange,
    @required this.datetime,
    @required this.open,
    @required this.high,
    @required this.average_volume,
    @required this.change,
    @required this.percent_change,
    @required this.close,
    @required this.low,
    @required this.previous_close,
    @required this.volume,

  });


  static SqouteDetail fromJson(Map<String, dynamic> json) => SqouteDetail(
    symbol: json['symbol'],
    name: json['name'],
    high: json['dayHigh'],
    low: json['dayLow'],
    average_volume: json['avgVolume'],
    change: json['change'],
    percent_change: json['changesPercentage'],
    open: json['open'],
    close: json['price'],
    volume: json['volume'],
    previous_close: json['previousClose'],
    datetime: json['timestamp'],
    exchange: json['exchange'],
  );

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'dayHigh': high,
    'dayLow': low,
    'avgVolume': average_volume,
    'change': change,
    'changesPercentage': percent_change,
    'open': open,
    'price': close,
    'volume': volume,
    'previousClose': previous_close,
    'timestamp': datetime,
    'exchange': exchange,
  };
}
