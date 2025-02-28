import 'package:flutter/material.dart';
import 'stock_details_screen.dart'; // Import the new StockDetailsScreen
import 'portfolio_screen.dart'; // Import the Portfolio Screen
import 'base_screen.dart'; // Import the Base Screen
import '../models/base.dart'; // Import the Base and Building models

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Mock stock data
  final List<Map<String, dynamic>> stocks = [
    {'symbol': 'AAPL', 'price': 150.0, 'favorite': false},
    {'symbol': 'GOOGL', 'price': 2800.0, 'favorite': false},
    {'symbol': 'AMZN', 'price': 3400.0, 'favorite': false},
    {'symbol': 'TSLA', 'price': 800.0, 'favorite': false},
    {'symbol': 'MSFT', 'price': 299.0, 'favorite': false},
  ];

  void toggleFavorite(String symbol) {
    setState(() {
      // Find the stock and toggle its favorite status
      final stock = stocks.firstWhere((stock) => stock['symbol'] == symbol);
      stock['favorite'] = !stock['favorite'];
    });
  }

  // Map portfolio to buildings
  List<Building> mapPortfolioToBuildings(List<Map<String, dynamic>> portfolio) {
    final List<Building> buildings = [];
    for (final stock in portfolio) {
      buildings.add(Building(
        name: stock['symbol'], // Example: Stock symbol as building name
        symbol: stock['symbol'],
        icon: Icons.business, // Generic icon
      ));
    }
    return buildings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/crown.png', // Make sure to add this to your assets
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 48),

              // Username field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the main dashboard
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardScreen(userId: widget.userId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Create a new DashboardScreen that contains the original home screen content
class DashboardScreen extends StatelessWidget {
  final String userId;

  const DashboardScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreen(userId: userId);
  }
}
