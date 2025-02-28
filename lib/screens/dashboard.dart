import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/base.dart'; // Import Base model
import '../widgets/xp_progress_bar.dart';
import '../services/stock_api.dart'; // Import Stock API
import 'base_screen.dart'; // Import BaseScreen

class DashboardScreen extends StatefulWidget {
  final String userId; // Pass the userId to the dashboard

  const DashboardScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserProfile? user; // Nullable user profile
  Base? userBase; // Nullable user base
  List<Map<String, dynamic>> stocks = []; // Stock list
  bool isLoading = true; // Tracks loading state

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Mock user profile data
      user = UserProfile(id: widget.userId, xp: 100, level: 2);

      // Mock base data with buildings
      userBase = Base(
        userId: widget.userId, // Added userId to Base
        name: "My Base",
        buildings: [
          Building(name: "Apple Store", symbol: "AAPL", icon: Icons.store),
          Building(name: "Google HQ", symbol: "GOOGL", icon: Icons.apartment),
        ],
      );

      // Fetch mock stocks
      await fetchStocks();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> fetchStocks() async {
    try {
      final stockData = await StockAPI.fetchHistoricalData('AAPL');
      setState(() {
        stocks = stockData.map((data) {
          return {
            'symbol': 'AAPL',
            'price': data['close'],
            'date': data['date'],
          };
        }).toList();
      });
    } catch (e) {
      print('❌ Error fetching stock data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Stock Dashboard')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Stock Dashboard')),
      body: Column(
        children: [
          // XP Progress Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: XPProgressBar(
              xp: user!.xp,
              level: user!.level,
              nextLevelXP: 300,
            ),
          ),
          // Stocks List
          Expanded(
            child: ListView(
              children: stocks.map((stock) {
                return ListTile(
                  title: Text(stock['symbol']),
                  subtitle: Text('Price: \$${stock['price']}'),
                );
              }).toList(),
            ),
          ),
          // View Base Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BaseScreen(
                      userBase: userBase!, // Pass the userBase to BaseScreen
                    ),
                  ),
                );
              },
              child: Text('View Base'),
            ),
          ),
        ],
      ),
    );
  }
}
