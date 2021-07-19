// https://financialmodelingprep.com/api/v3/stock/list?apikey=345f1441101ef0e024d8cf2d3fad387b

import 'package:finbul/Model/Stock.dart';
import 'package:finbul/Screen/TimeSeries.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WebServices extends ChangeNotifier {

  Future<dynamic> getStocks() async {
    var response = await http.get(
        //https://financialmodelingprep.com/api/v3/quote/AAPL,FB,GOOG?apikey=0e5e944a887c896c34d7e5c76e0c2cbf
        // Uri.parse('https://api.twelvedata.com/stocks?country=USA'),
      Uri.parse('https://financialmodelingprep.com/api/v3/stock/list?apikey=0e5e944a887c896c34d7e5c76e0c2cbf'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
        //  'Authorization': 'Bearer $bearer',
        });
    List body1 = json.decode(response.body);
    // List body = body1['data'];
    List finalList = [];
    List<Symbol> symbol = body1
        .map((data) {
      return Symbol.fromJson(data);
    })
        .toSet()
        .toList();


    for(var value in symbol){
      finalList.add(value.symbol);
    }

    List v = finalList.sublist(0, 40);
    var newData = v.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
    var response2 = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/quote/$newData?apikey=0e5e944a887c896c34d7e5c76e0c2cbf'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });


    // List finalconstList= [];
    // for(var value in v){
      List finalBody1 = json.decode(response2.body);
    //   var finalBody2 = finalBody1[value.toString()];
    //   finalconstList.add(finalBody2);
    // }

    List<SqouteDetail> squote = finalBody1
        .map((data) {
      return SqouteDetail.fromJson(data);
    })
        .toSet()
        .toList();

    if (response.statusCode == 500) {
    } else {
print(squote);
      return squote;
    }
  }



  Future<dynamic> getMostWatchStocks() async {
    List finalList = [
      'DOW','NDAQ','SPX'
    ];

    var response2 = await http.get(
        Uri.parse('https://api.twelvedata.com/quote?symbol=DOW,NDAQ,SPX&apikey=38afea301d2f4e328cde9f8287c1ebc1'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });
    List finalconstList= [];
    for(var value in finalList){
      var finalBody1 = json.decode(response2.body);
      var finalBody2 = finalBody1[value.toString()];
      finalconstList.add(finalBody2);
    }

    List<Sqoute> squote = finalconstList
        .map((data) {
      return Sqoute.fromJson(data);
    })
        .toSet()
        .toList();

    if (response2.statusCode == 500) {
    } else {

      return squote;
    }
  }










  Future<dynamic> getWatchListStocks(symbol) async {
    List finalList = [];

    for(var value in symbol){

      finalList.add(value.symbol);
    }

    var newData = finalList.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');

    var response2 = await http.get(
        Uri.parse('https://api.twelvedata.com/quote?symbol=$newData&apikey=38afea301d2f4e328cde9f8287c1ebc1'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });

    if(finalList.length > 1) {
      List finalconstList = [];
      for (var value in finalList) {
        var finalBody1 = json.decode(response2.body);
        var finalBody2 = finalBody1[value.toString()];
        finalconstList.add(finalBody2);
      }

      List<Sqoute> squote = finalconstList
          .map((data) {
        return Sqoute.fromJson(data);
      })
          .toSet()
          .toList();


      if (response2.statusCode == 500) {
      } else {

        return squote;
      }
    }else{

     List  finalList = [];

      var finalBody1 = json.decode(response2.body);
     finalList.add(finalBody1);
      List<Sqoute> squote = finalList.map((data) {
        return Sqoute.fromJson(data);
      })
          .toSet()
          .toList();
      print(squote);

      if (response2.statusCode == 500) {
      } else {

        return squote;
      }
    }




  }









  Future<dynamic> getTrendingStocks() async {
    var response = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/actives?apikey=0e5e944a887c896c34d7e5c76e0c2cbf'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });
    var body1 = json.decode(response.body);
    List body = body1;
    List<trendingSqoute> trending = body
        .map((data) {
      return trendingSqoute.fromJson(data);
    })
        .toSet()
        .toList();
    if (response.statusCode == 500) {
    } else {

      return trending;
    }
  }








  Future<dynamic> getStockNews(newData) async {
    var response = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/stock_news?tickers=${newData}&limit=50&apikey=345f1441101ef0e024d8cf2d3fad387b'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });

    var body1 = json.decode(response.body);
    if (response.statusCode == 500) {
    } else {

      return body1;
    }
  }




  Future<dynamic> search(word) async {
    var response = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/search?query=$word&limit=40&exchange=NASDAQ&apikey=345f1441101ef0e024d8cf2d3fad387b'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });
    List body1 = json.decode(response.body);
    // List body = body1['data'];
    List<Symbol2> search = body1
        .map((data) {
      return Symbol2.fromJson(data);
    })
        .toSet()
        .toList();

    if (response.statusCode == 500) {
    } else {
      return search;
    }
  }


  Future<dynamic> getCoinsTimeSeries(String symbol, url) async {
    //https://financialmodelingprep.com/api/v3/historical-price-full/AAPL?from=2018-03-12&to=2019-03-12&apikey=345f1441101ef0e024d8cf2d3fad387b
    //https://api.twelvedata.com/time_series?symbol=$symbol&interval=$filter&outputsize=40&apikey=38afea301d2f4e328cde9f8287c1ebc1
      var response = await http.get(
          Uri.parse(
              '$url'),
          headers: {
            "Content-type": "application/x-www-form-urlencoded",
            //  'Authorization': 'Bearer $bearer',
          });
      //
      final extractdata =  await json.decode(response.body);
      List body =  extractdata['historical'];
      // print("${response.statusCode} $filter $symbol");
      // print("$body ${response.statusCode} $filter $symbol");
      List<TimeSeriesPrice> search = body.map((data) {
        return TimeSeriesPrice.fromJson(data);
      }).toSet().toList();
      if (response.statusCode == 500) {} else {
        print(search);
        return search;
      }
  }


  Future<dynamic> getStockDetail2(newData) async {
    var response = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/quote/$newData?apikey=0e5e944a887c896c34d7e5c76e0c2cbf'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });
    var body1 = json.decode(response.body);
    if (response.statusCode == 500) {
    } else {
      return body1[0];
    }
  }




  Future<dynamic> getStockDetail(newData) async {
    var response = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/quote/$newData?apikey=0e5e944a887c896c34d7e5c76e0c2cbf'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });
    var body1 = json.decode(response.body);
    if (response.statusCode == 500) {
    } else {

      return body1[0];
    }
  }



  Future<dynamic> getStockSearchDetail(newData) async {
    var response = await http.get(
        Uri.parse('https://api.twelvedata.com/quote?symbol=$newData&apikey=38afea301d2f4e328cde9f8287c1ebc1'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });

    var body1 = json.decode(response.body);


    if (response.statusCode == 500) {
    } else {

      return body1;
    }
  }










  Future<dynamic> getToplosers() async {
    var response = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/losers?apikey=0e5e944a887c896c34d7e5c76e0c2cbf'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });
    var body1 = json.decode(response.body);
    List body = body1;
    List<trendingSqoute> trending = body
        .map((data) {
      return trendingSqoute.fromJson(data);
    })
        .toSet()
        .toList();

    if (response.statusCode == 500) {
    } else {

      return trending;
    }
  }







  Future<dynamic> getTopGainers() async {
    var response = await http.get(
        Uri.parse('https://financialmodelingprep.com/api/v3/gainers?apikey=0e5e944a887c896c34d7e5c76e0c2cbf'),
        headers: {
          "Content-type": "application/x-www-form-urlencoded",
          //  'Authorization': 'Bearer $bearer',
        });
    var body1 = json.decode(response.body);
    List body = body1;
    List<trendingSqoute> trending = body
        .map((data) {
      return trendingSqoute.fromJson(data);
    })
        .toSet()
        .toList();

    if (response.statusCode == 500) {
    } else {

      return trending;
    }
  }


}



