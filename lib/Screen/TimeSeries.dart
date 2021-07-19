import 'dart:async';
import 'dart:convert';
import 'package:finbul/Service/Network.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as dd;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// JSON format
// {"Response":"Success","Type":100,"Aggregated":false,"Data":
// [{"time":1279324800,"close":0.04951,"high":0.04951,"low":0.04951,"open":0.04951,"volumefrom":20,"volumeto":0.9902},
class TimeSeriesPrice {
  final DateTime time;
  final double price;
  final double low;
  final double open;
  final double high;


  TimeSeriesPrice({this.time, this.price, this.high, this.open, this.low});

  static TimeSeriesPrice fromJson(Map<String, dynamic> json) => TimeSeriesPrice(
    time: DateTime.parse(json['date']),
    price: json['close'],
    open: json['open'],
    low: json['low'],
    high: json['high'],

  );

  Map<String, dynamic> toJson() => {
    'time': time,
    'price':price,
    'open': open,
    'low': low,
    'high': high,
  };
}

class ItemDetailsPage extends StatefulWidget {

  final symbol;
  ItemDetailsPage({this.symbol});


  @override
  _ItemDetailsPageState createState() => new _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {

  bool _enableSolidCandle;
  bool _toggleVisibility;
  TrackballBehavior _trackballBehavior;
   List data;

  int selectedIndex = 0;
  String selectedValue = 'Day';


  @override
  void initState() {
    var url = "https://financialmodelingprep.com/api/v3/historical-price-full/${widget.symbol}?apikey=345f1441101ef0e024d8cf2d3fad387b";
    _enableSolidCandle = true;
    _toggleVisibility = true;
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    WebServices network = Provider.of<WebServices>(context, listen: false);
    network.getCoinsTimeSeries(widget.symbol,url,).then((value){
      setState(() {
        data = value;
      });
    });
    super.initState();
  }


  updateFilter(url){
    setState(() {
      data = null;
    });

    WebServices network = Provider.of<WebServices>(context, listen: false);
    network.getCoinsTimeSeries(widget.symbol,url).then((value){
      setState(() {
        data = value;
      });
  });
        }



  List<TimeSeriesPrice> testdata = [
    TimeSeriesPrice(time: DateTime(12,10,12),open: 5.0, price:33.0, high:22.0, low:22.0),
  ];

  @override
  Widget build(BuildContext context) {
    List date = [
      'Day',
      'Week',
      'Month',
      'Year',
    ];

    SelectedValue(value) {
      if (value == 'Day') {
        return 'https://financialmodelingprep.com/api/v3/historical-price-full/${widget.symbol}?apikey=345f1441101ef0e024d8cf2d3fad387b';
      } else if (value == 'Week') {
        return 'https://financialmodelingprep.com/api/v3/historical-price-full/${widget.symbol}?timeseries=10&apikey=345f1441101ef0e024d8cf2d3fad387b';
      } else if (value == 'Month') {
        return 'https://financialmodelingprep.com/api/v3/historical-price-full/${widget.symbol}?timeseries=31&apikey=345f1441101ef0e024d8cf2d3fad387b';
      } else if (value == 'Year') {
        return 'https://financialmodelingprep.com/api/v3/historical-price-full/${widget.symbol}?timeseries=365&apikey=345f1441101ef0e024d8cf2d3fad387b';
      }
    }



    return  Column(
      children: [

        StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: EdgeInsets.only(top: 15, left: 5),
              height: 30,
              child: ListView.builder(
                itemCount: date.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState((){
                        selectedIndex = index;
                        selectedValue = date[index];
                      });
                        updateFilter(SelectedValue(selectedValue));
                    },
                    child: Container(
                      margin:
                      EdgeInsets.only(right: 8),
                      height: 30,
                      child: Center(
                          child: Text(
                            '${date[index]}',
                            style: TextStyle(
                                color: selectedIndex ==
                                    index
                                    ? Color(0xFF403477)
                                    : Colors.white),
                          )),
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white),
                        borderRadius:
                        BorderRadius.circular(15),
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        ),
        Container(
          height: 300,
          child:  data!=null
                          ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    //Initialize the spark charts widget
                    child: Container(
                      height: 200,
                      child: SfCartesianChart(
                        // indicators: <TechnicalIndicators<TimeSeriesPrice, dynamic>>[
                        //     BollingerBandIndicator<TimeSeriesPrice, dynamic>(
                        //       seriesName: 'App',
                        //       period: 3,
                        //     )
                        //   ],
                        plotAreaBorderWidth: 0,
                        primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat.MMM(),
                            // interval: 3,
                            // intervalType: DateTimeIntervalType.months,
                            // minimum: DateTime(2016, 01, 01),
                            // maximum: DateTime(2016, 10, 01),
                            majorGridLines:  MajorGridLines(width: 0)),
                        primaryYAxis: NumericAxis(
                          // minimum: 140,
                          // maximum: 60,
                          // interval: 20,
                            labelFormat: r'${value}',
                            axisLine:  AxisLine(width: 0)),
                        series:  <CandleSeries<TimeSeriesPrice, DateTime>>[
                        CandleSeries<TimeSeriesPrice, DateTime>(
                            enableSolidCandles: _enableSolidCandle,
                            name: 'App',
                                 dataSource: data ==null || data.length==0?testdata:data,
                            showIndicationForSameValues:true,
                            xValueMapper: (TimeSeriesPrice sales, _) => sales.time as DateTime,

                            /// High, low, open and close values used to render the candle series.
                            lowValueMapper: (TimeSeriesPrice sales, _) => sales.low,
                            highValueMapper: (TimeSeriesPrice sales, _) => sales.high,
                            openValueMapper: (TimeSeriesPrice sales, _) => sales.open,
                            closeValueMapper: (TimeSeriesPrice sales, _) => sales.price)
                      ],
                        trackballBehavior: _trackballBehavior,
                      ),

                      // SfCartesianChart(
                      //   primaryXAxis: DateTimeAxis(),
                      //   primaryYAxis: NumericAxis(
                      //     numberFormat: NumberFormat.currency(
                      //         locale: 'en_US',
                      //         symbol: '\$'
                      //     ) ,
                      //     // minimum: 700,
                      //     // maximum: 1300,
                      //   ),
                      //   // indicators: <TechnicalIndicators<TimeSeriesPrice, dynamic>>[
                      //   //   BollingerBandIndicator<TimeSeriesPrice, dynamic>(
                      //   //     seriesName: 'App',
                      //   //     period: 3,
                      //   //   )
                      //   // ],
                      //   series: <ChartSeries>[
                      //     HiloOpenCloseSeries<TimeSeriesPrice, dynamic>(
                      //       name: 'App',
                      //       dataSource: snapshot.data ==null || snapshot.data.length==0?testdata:snapshot.data,
                      //       xValueMapper: (TimeSeriesPrice sales, _) => sales.time,
                      //       highValueMapper: (TimeSeriesPrice sales, _) => sales.high,
                      //       lowValueMapper: (TimeSeriesPrice sales, _) => sales.low,
                      //       openValueMapper: (TimeSeriesPrice sales, _) => sales.open,
                      //       closeValueMapper: (TimeSeriesPrice sales, _) => sales.price,
                      //     )
                      //   ],
                      //   // Chart title
                      //   // Enable legend
                      //   // legend: Legend(isVisible: true),
                      //   // // Enable tooltip
                      //   // tooltipBehavior: TooltipBehavior(enable: true),
                      //   // series: <ChartSeries<_SalesData, String>>[
                      //   //   LineSeries<_SalesData, String>(
                      //   //       dataSource: data,
                      //   //       xValueMapper: (_SalesData sales, _) => sales.year,
                      //   //       yValueMapper: (_SalesData sales, _) => sales.sales,
                      //   //       name: 'Sales',
                      //   //       // Enable data label
                      //   //       dataLabelSettings: DataLabelSettings(isVisible: true))
                      // ),
                    ),
                  ) :data==null ?Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
        ),
        SizedBox(
        height: 10,
        ),
        Text('Loading Stocks',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500)),
        ],
        ),
        )): Padding(
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
        ),
      ],
    );
  }
}
