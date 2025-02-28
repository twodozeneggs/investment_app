import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockDetailsScreen extends StatefulWidget {
  final String symbol;

  StockDetailsScreen({required this.symbol});

  @override
  _StockDetailsScreenState createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  bool isFavorited = false; // Track favorite status

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorited = prefs.getBool(widget.symbol) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorited = !isFavorited;
      prefs.setBool(widget.symbol, isFavorited);
    });
  }

  // Mock historical data
  final List<Map<String, dynamic>> historicalData = [
    {'date': '2023-01-01', 'close': 145.0},
    {'date': '2023-01-02', 'close': 147.0},
    {'date': '2023-01-03', 'close': 150.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details: ${widget.symbol}'),
        actions: [
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.red : Colors.black,
              ),
              onPressed: _toggleFavorite,
            ),
          ),
        ],
      ),
      body: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Closing Prices for ${widget.symbol}'),
        series: <LineSeries<Map<String, dynamic>, String>>[
          LineSeries<Map<String, dynamic>, String>(
            dataSource: historicalData,
            xValueMapper: (data, _) => data['date'],
            yValueMapper: (data, _) => data['close'],
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
