import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'achievements_screen.dart'; // Import the Achievements Screen
import 'base_screen.dart'; // Import the BaseScreen
import '../models/base.dart'; // Import the Base and Building models

class PortfolioScreen extends StatefulWidget {
  final String userId; // Add userId as a required parameter

  const PortfolioScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final String apiKey = 'TZFJSFHUJ8GS4W2Q'; // Replace with your API key

  Map<String, dynamic> portfolio = {
    'AAPL': {'shares': 10, 'purchasePrice': 150.0},
    'GOOGL': {'shares': 5, 'purchasePrice': 2800.0},
    'AMZN': {'shares': 3, 'purchasePrice': 3400.0},
    'TSLA': {'shares': 8, 'purchasePrice': 700.0},
  }; // Mock portfolio data
  Map<String, double> livePrices = {}; // Store live prices
  bool isLoading = true;

  int totalXP = 0; // Track total XP
  int currentLevel = 1; // Track user level
  int xpForNextLevel = 500; // XP needed for next level

  List<String> favoriteStocks = []; // Store favorite stocks

  // Track achievements
  final Map<String, bool> achievements = {
    'first_stock': false,
    'portfolio_10k': false,
    'single_stock_50_percent': false,
  };

  @override
  void initState() {
    super.initState();
    fetchLivePrices(); // Fetch mock live prices when screen loads
    _loadFavorites(); // Load favorites from SharedPreferences
  }

  // Fetch mock live prices
  Future<void> fetchLivePrices() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    setState(() {
      livePrices = {
        'AAPL': 150.0,
        'GOOGL': 2800.0,
        'AMZN': 3300.0,
        'TSLA': 12, // Example additional stock
      };

      // Assign default prices for stocks not in the mock data
      portfolio.keys.forEach((symbol) {
        if (!livePrices.containsKey(symbol)) {
          livePrices[symbol] = portfolio[symbol]['purchasePrice'];
        }
      });

      isLoading = false;
    });
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteStocks =
          prefs.getKeys().where((key) => prefs.getBool(key) == true).toList();
    });
  }

  // Remove stock from favorites
  Future<void> _removeFavorite(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove(symbol);
      favoriteStocks.remove(symbol);
    });
  }

  // Add XP and handle level progression
  void addXP(int amount) {
    setState(() {
      totalXP += amount;
      if (totalXP >= xpForNextLevel) {
        currentLevel++;
        xpForNextLevel += 500; // Increase XP needed for next level
        showLevelUpNotification();
      }
    });
  }

  // Show level-up notification
  void showLevelUpNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Level Up! You are now Level $currentLevel!'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  // Unlock achievement and show notification
  void unlockAchievement(String key) {
    if (!achievements[key]!) {
      setState(() {
        achievements[key] = true;
      });
      showAchievementNotification(key);
    }
  }

  void showAchievementNotification(String key) {
    final achievementTitles = {
      'first_stock': '🎉 Welcome to Investing!',
      'portfolio_10k': '🚀 Investor Pro!',
      'single_stock_50_percent': '💡 Stock Guru!',
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(achievementTitles[key]!),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  // Map portfolio to buildings for the base
  List<Building> mapPortfolioToBuildings(Map<String, dynamic> portfolio) {
    final List<Building> mappedBuildings = [];
    portfolio.forEach((symbol, data) {
      if (symbol == 'AAPL' && totalXP >= 100) {
        mappedBuildings.add(Building(
          name: 'Apple Store',
          symbol: symbol,
          icon: Icons.store,
          animation: 'apple_store_animation',
        ));
      } else if (symbol == 'GOOGL' && totalXP >= 200) {
        mappedBuildings.add(Building(
          name: 'Google HQ',
          symbol: symbol,
          icon: Icons.apartment,
          animation: 'google_hq_animation',
        ));
      } else if (symbol == 'AMZN') {
        mappedBuildings.add(Building(
          name: 'Amazon Warehouse',
          symbol: symbol,
          icon: Icons.local_shipping,
          animation: 'amazon_warehouse_animation',
        ));
      } else if (symbol == 'TSLA') {
        mappedBuildings.add(Building(
          name: 'Tesla Showroom',
          symbol: symbol,
          icon: Icons.electric_car,
          animation: 'tesla_showroom_animation',
        ));
      }
    });
    return mappedBuildings;
  }

  // Add stock to the portfolio
  void addStock(String symbol, int shares, double purchasePrice) {
    setState(() {
      portfolio[symbol] = {
        'shares': shares,
        'purchasePrice': purchasePrice,
      };
      addXP(50); // Award XP for adding a stock

      // Unlock "First Stock Added" achievement
      if (portfolio.length == 1) {
        unlockAchievement('first_stock');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalValue = 0;
    double totalProfitLoss = 0;

    portfolio.forEach((symbol, data) {
      final shares = data['shares'];
      final purchasePrice = data['purchasePrice'];
      final currentPrice = livePrices[symbol] ?? purchasePrice;

      final stockValue = shares * currentPrice;
      final profitLoss = stockValue - (shares * purchasePrice);

      totalValue += stockValue;
      totalProfitLoss += profitLoss;

      // Check for single stock > 50% profit achievement
      final profitPercent =
          ((currentPrice - purchasePrice) / purchasePrice) * 100;
      if (profitPercent > 50) {
        unlockAchievement('single_stock_50_percent');
      }
    });

    // Unlock "Portfolio Value > $10,000" achievement
    if (totalValue > 10000) {
      unlockAchievement('portfolio_10k');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Portfolio'),
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_events),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AchievementsScreen(achievements: achievements),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (favoriteStocks.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Favorites',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...favoriteStocks.map((symbol) => ListTile(
                            title: Text(symbol),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () => _removeFavorite(symbol),
                            ),
                          )),
                      const Divider(),
                    ],
                  ),
                // Portfolio summary with XP progress
                Card(
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Total Portfolio Value: \$${totalValue.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          'Overall Profit/Loss: \$${totalProfitLoss.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: totalProfitLoss >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'XP: $totalXP / $xpForNextLevel (Level $currentLevel)',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: totalXP / xpForNextLevel,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                // Portfolio list
                Expanded(
                  child: ListView(
                    children: portfolio.entries.map((entry) {
                      final symbol = entry.key;
                      final data = entry.value;
                      final shares = data['shares'];
                      final purchasePrice = data['purchasePrice'];
                      final currentPrice = livePrices[symbol] ?? purchasePrice;
                      final stockValue = shares * currentPrice;
                      final profitLoss = stockValue - (shares * purchasePrice);

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(symbol),
                          subtitle: Text(
                              'Shares: $shares | Purchase Price: \$${purchasePrice.toStringAsFixed(2)} | Current Price: \$${currentPrice.toStringAsFixed(2)}'),
                          trailing: Text(
                            '\$${profitLoss.toStringAsFixed(2)}',
                            style: TextStyle(
                              color:
                                  profitLoss >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Build Your Base Button
                ElevatedButton(
                  onPressed: () {
                    final userBase = Base(
                      userId: widget.userId, // Pass the required userId here
                      name: 'My Investment Base',
                      buildings: mapPortfolioToBuildings(portfolio),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BaseScreen(userBase: userBase),
                      ),
                    );
                  },
                  child: Text('Build Your Base'),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddStockDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  // Dialog to add new stock
  void showAddStockDialog(BuildContext context) {
    final symbolController = TextEditingController();
    final sharesController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: symbolController,
              decoration: InputDecoration(labelText: 'Symbol'),
            ),
            TextField(
              controller: sharesController,
              decoration: InputDecoration(labelText: 'Shares'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Purchase Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final symbol = symbolController.text.toUpperCase();
              final shares = int.tryParse(sharesController.text) ?? 0;
              final purchasePrice =
                  double.tryParse(priceController.text) ?? 0.0;

              if (symbol.isNotEmpty && shares > 0 && purchasePrice > 0) {
                addStock(symbol, shares, purchasePrice);
              }

              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
