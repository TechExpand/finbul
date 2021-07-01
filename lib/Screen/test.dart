import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';



class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  // _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_SalesData> data = [
    _SalesData(DateTime(12,10,12), 5,33,22,22),
    _SalesData(DateTime(11,11,12), 32,11,12,34),
    _SalesData(DateTime(10,14,15), 35,5,56,76),
    _SalesData(DateTime(21,1,12), 43,87,22,5),
    _SalesData(DateTime(11,1,1), 87,33,43,34),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(
                // numberFormat: NumberFormat.currency(
                //     locale: 'en_US',
                //     symbol: '\$'
                // ) ,
                // minimum: 500,
                // maximum: 1200,
              ),
              indicators: <TechnicalIndicators<_SalesData, dynamic>>[
                BollingerBandIndicator<_SalesData, dynamic>(
                  seriesName: 'App',
                  period: 3,
                )
              ],
              series: <ChartSeries>[
                HiloOpenCloseSeries<_SalesData, dynamic>(
                  name: 'App',
                  dataSource: data,
                  xValueMapper: (_SalesData sales, _) => sales.date,
                  highValueMapper: (_SalesData sales, _) => sales.high,
                  lowValueMapper: (_SalesData sales, _) => sales.low,
                  openValueMapper: (_SalesData sales, _) => sales.open,
                  closeValueMapper: (_SalesData sales, _) => sales.close,
                )
              ],
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //Initialize the spark charts widget
              child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].date,
                yValueMapper: (int index) => data[index].close,
                dataCount: 5,
              ),
            ),
          )
        ]));
  }
}

class _SalesData {
  _SalesData(this.date, this.high, this.open, this.close, this.low);

  final DateTime date;
  final int high;
  final int open;
  final int close;
  final int low;
}