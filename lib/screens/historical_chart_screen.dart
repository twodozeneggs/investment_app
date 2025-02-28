import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoricalChartScreen extends StatelessWidget {
  final String symbol;
  final List<Map<String, dynamic>> dataPoints;

  HistoricalChartScreen({required this.symbol, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historical Data: $symbol'),
      ),
      body: dataPoints.isEmpty
          ? Center(
              child: Text('No historical data available for $symbol'),
            )
          : SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Closing Prices for $symbol'),
              series: <LineSeries<Map<String, dynamic>, String>>[
                LineSeries<Map<String, dynamic>, String>(
                  dataSource: dataPoints,
                  xValueMapper: (data, _) => data['date'],
                  yValueMapper: (data, _) => data['close'],
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                )
              ],
            ),
    );
  }
}
