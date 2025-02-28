import 'package:flutter/material.dart';
import '../models/base.dart';

class BaseScreen extends StatefulWidget {
  final Base userBase;

  const BaseScreen({Key? key, required this.userBase}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  // List of stocks displayed in the grid
  List<Map<String, dynamic>?> favoriteStocks = [
    {"symbol": "AAPL", "name": "Apple", "price": 182.50},
    {"symbol": "DPZ", "name": "Domino's", "price": 412.30},
    {"symbol": "DAL", "name": "Delta", "price": 38.75},
    {}, {}, {}, {}, {}, {}, // Placeholder maps instead of `null`
  ];

  // List of available stocks to add
  List<Map<String, dynamic>> availableStocks = [
    {"symbol": "GOOGL", "name": "Google", "icon": Icons.search},
    {"symbol": "TSLA", "name": "Tesla", "icon": Icons.electric_car},
    {"symbol": "NFLX", "name": "Netflix", "icon": Icons.movie},
    {"symbol": "AMZN", "name": "Amazon", "icon": Icons.shopping_cart},
    {"symbol": "MSFT", "name": "Microsoft", "icon": Icons.desktop_mac},
    {"symbol": "NVDA", "name": "NVIDIA", "icon": Icons.memory},
  ];

  // Controller for the search bar
  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // ----- Full-width Header -----
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24),
              color: Colors.blueGrey[800],
              alignment: Alignment.center,
              child: Text(
                "My Investment Base",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // ----- 3x3 Grid for Stocks -----
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: favoriteStocks.length,
                  itemBuilder: (context, index) {
                    final stock = favoriteStocks[index];

                    return GestureDetector(
                      onTap: () => _handleGridTap(index, stock),
                      child: Container(
                        decoration: BoxDecoration(
                          color: stock == null || stock.isEmpty
                              ? Colors.white
                              : Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Center(
                          child: stock == null || stock.isEmpty
                              ? Icon(Icons.add_circle,
                                  size: 36, color: Colors.grey[500])
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getStockIcon(stock["symbol"] ?? ""),
                                      size: 50,
                                      color: Colors.blueGrey[700],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      stock["name"] ?? "Unknown",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey[900],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ----- Search Bar -----
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stockController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search or Add Stock...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.white, size: 28),
                    onPressed: _addStock,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Handle Grid Tap -----
  void _handleGridTap(int index, Map<String, dynamic>? stock) {
    if (stock == null || stock.isEmpty) {
      _showAddStockDialog(index); // Add a new stock to the grid
    } else {
      _showStockDetails(stock); // Show details for existing stock
    }
  }

  // ----- Show Add Stock Dialog -----
  void _showAddStockDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Company"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableStocks.map((stock) {
              return ListTile(
                leading:
                    Icon(stock["icon"], size: 30, color: Colors.blueGrey[700]),
                title: Text(stock["name"],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() {
                    favoriteStocks[index] = {
                      "symbol": stock["symbol"],
                      "name": stock["name"],
                      "price": 100.00 + (index * 5), // Mocked price
                    };
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ----- Show Stock Details -----
  void _showStockDetails(Map<String, dynamic> stock) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                _getStockIcon(stock["symbol"] ?? ""),
                size: 40,
                color: Colors.blueGrey[700],
              ),
              SizedBox(width: 8),
              Text("${stock["name"] ?? "Unknown"} Details"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Symbol: ${stock["symbol"] ?? "N/A"}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Price: \$${(stock["price"] ?? 0.00).toStringAsFixed(2)}"),
              SizedBox(height: 8),
              Text("Market Cap: \$1.2T (Mocked Data)"),
              Text(
                  "Day High: \$${((stock["price"] ?? 0.00) * 1.05).toStringAsFixed(2)}"),
              Text(
                  "Day Low: \$${((stock["price"] ?? 0.00) * 0.95).toStringAsFixed(2)}"),
              Text("Change: +2.15% (Mocked Data)"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // ----- Add a Stock -----
  void _addStock() {
    String stockName = stockController.text.trim();
    if (stockName.isNotEmpty) {
      setState(() {
        favoriteStocks.add({
          "symbol": stockName.toUpperCase(),
          "name": stockName,
          "price": 100.00 + (favoriteStocks.length * 5), // Mocked price
        });
      });
      stockController.clear();
    }
  }

  // ----- Get Stock Icon -----
  IconData _getStockIcon(String symbol) {
    switch (symbol) {
      case "AAPL":
        return Icons.computer;
      case "DPZ":
        return Icons.local_pizza;
      case "DAL":
        return Icons.airplanemode_active;
      case "GOOGL":
        return Icons.search;
      case "TSLA":
        return Icons.electric_car;
      case "NFLX":
        return Icons.movie;
      case "AMZN":
        return Icons.shopping_cart;
      case "MSFT":
        return Icons.desktop_mac;
      case "NVDA":
        return Icons.memory;
      default:
        return Icons.trending_up;
    }
  }
}
