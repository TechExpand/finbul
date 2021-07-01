import 'dart:async';
import 'dart:convert';
import 'package:fin_bul/Service/Network.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as dd;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// JSON format
// {"Response":"Success","Type":100,"Aggregated":false,"Data":
// [{"time":1279324800,"close":0.04951,"high":0.04951,"low":0.04951,"open":0.04951,"volumefrom":20,"volumeto":0.9902},

/// Time-series data type.
class TimeSeriesPrice {
  final DateTime time;
  final double price;
  final double low;
  final double open;
  final double high;
  final String volume;

  TimeSeriesPrice({this.time, this.price, this.high, this.open, this.low, this.volume});

  static TimeSeriesPrice fromJson(Map<String, dynamic> json) => TimeSeriesPrice(
      time: DateTime.parse(json['datetime']),
      price: double.parse(json['close']),
      open: double.parse(json['open']),
      low: double.parse(json['low']),
      high: double.parse(json['high']),
    volume: json['volume'],

  );

Map<String, dynamic> toJson() => {
  'time': time,
  'price':price,
  'open': open,
  'low': low,
  'high': high
};
}

class ItemDetailsPage extends StatefulWidget {
  final data;
  final symbol;
  ItemDetailsPage({this.data, this.symbol});


  @override
  _ItemDetailsPageState createState() => new _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {

  // List dataJSON;

  // @override
  // void initState() {
  //   getCoinsTimeSeries();
  //   super.initState();
  // }

  List<TimeSeriesPrice> testdata = [
    TimeSeriesPrice(time: DateTime(12,10,12),open: 5.0, price:33.0, high:22.0, low:22.0),
  ];

  @override
  Widget build(BuildContext context) {
    WebServices network = Provider.of<WebServices>(context, listen: false);




    return  Container(
      height: 300,
      child: FutureBuilder(
            future: network.getCoinsTimeSeries(widget.data, widget.symbol),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done?
               !snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Loading Stocks',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ))
                  : snapshot.hasData && !snapshot.data.isEmpty
                      ? Padding(
                padding: const EdgeInsets.all(8.0),
                //Initialize the spark charts widget
                child: Container(
                  height: 200,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.currency(
                          locale: 'en_US',
                          symbol: '\$'
                      ) ,
                      // minimum: 700,
                      // maximum: 1300,
                    ),
                    // indicators: <TechnicalIndicators<TimeSeriesPrice, dynamic>>[
                    //   BollingerBandIndicator<TimeSeriesPrice, dynamic>(
                    //     seriesName: 'App',
                    //     period: 3,
                    //   )
                    // ],
                    series: <ChartSeries>[
                      HiloOpenCloseSeries<TimeSeriesPrice, dynamic>(
                        name: 'App',
                        dataSource: snapshot.data ==null || snapshot.data.length==0?testdata:snapshot.data,
                        xValueMapper: (TimeSeriesPrice sales, _) => sales.time,
                        highValueMapper: (TimeSeriesPrice sales, _) => sales.high,
                        lowValueMapper: (TimeSeriesPrice sales, _) => sales.low,
                        openValueMapper: (TimeSeriesPrice sales, _) => sales.open,
                        closeValueMapper: (TimeSeriesPrice sales, _) => sales.price,
                      )
                    ],
                    // Chart title
                    // Enable legend
                    // legend: Legend(isVisible: true),
                    // // Enable tooltip
                    // tooltipBehavior: TooltipBehavior(enable: true),
                    // series: <ChartSeries<_SalesData, String>>[
                    //   LineSeries<_SalesData, String>(
                    //       dataSource: data,
                    //       xValueMapper: (_SalesData sales, _) => sales.year,
                    //       yValueMapper: (_SalesData sales, _) => sales.sales,
                    //       name: 'Sales',
                    //       // Enable data label
                    //       dataLabelSettings: DataLabelSettings(isVisible: true))
                  ),
                ),
              ) : snapshot.data.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                color: Color(0xFFBBBBBB),
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  'No Stocks Available',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : Container():Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Loading Stocks',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ));
            }),
    );
  }
}
