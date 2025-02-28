import 'package:flutter/material.dart';

class BottomPanel extends StatefulWidget {
  final Function(String, double) onInvest; // Callback function
  final double cashBalance; // 💰 Added cash balance display

  const BottomPanel(
      {Key? key, required this.onInvest, required this.cashBalance})
      : super(key: key);

  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel>
    with SingleTickerProviderStateMixin {
  // Define our money green colors
  final Color darkGreen = const Color(0xFF1B4D3E); // Dark money green
  final Color mediumGreen = const Color(0xFF2E7D32); // Medium money green
  final Color lightGreen = const Color(0xFF4CAF50); // Light money green

  late TabController _tabController;
  int _currentTabIndex = 0;
  String? _selectedStock;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85, // ⬆ Starts at 85% (a little lower)
      minChildSize: 0.5, // ⬇ Can be dragged down to 50%
      maxChildSize: 0.85, // ⬆ Can be dragged up to see more
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle with green color
              Container(
                width: 50,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: mediumGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Balance Section with money green styling
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: darkGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Royal Treasury",
                      style: TextStyle(
                        fontFamily: 'CinzelDecorative',
                        fontSize: 18,
                        color: darkGreen,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance,
                          color: mediumGreen,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "\$${widget.cashBalance.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tabs with money green styling
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: darkGreen.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: TabBar(
                          labelColor: darkGreen,
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: mediumGreen,
                          labelStyle: TextStyle(
                            fontFamily: 'CinzelDecorative',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(text: "Stocks"),
                            Tab(text: "Buildings"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildScrollableStockList(scrollController),
                            _buildScrollableBuildingList(scrollController),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 📈 Scrollable Stocks List
  Widget _buildScrollableStockList(ScrollController scrollController) {
    final List<Map<String, dynamic>> stocks = [
      {"symbol": "AAPL", "name": "Apple Inc.", "price": "\$150.25"},
      {"symbol": "TSLA", "name": "Tesla Motors", "price": "\$750.80"},
      {"symbol": "GOOGL", "name": "Alphabet Inc.", "price": "\$2,850.50"},
      {"symbol": "AMZN", "name": "Amazon.com", "price": "\$3,300.75"},
      {"symbol": "NVDA", "name": "NVIDIA Corp.", "price": "\$220.40"},
      {"symbol": "MSFT", "name": "Microsoft", "price": "\$310.60"},
      {"symbol": "NFLX", "name": "Netflix", "price": "\$590.25"},
      {"symbol": "META", "name": "Meta Platforms", "price": "\$330.90"},
    ];

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: darkGreen.withOpacity(0.2),
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              stock["symbol"]!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            subtitle: Text(
              stock["name"]!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stock["price"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mediumGreen,
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => widget.onInvest(stock["symbol"]!, 50),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Invest",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🏗 Scrollable Buildings List
  Widget _buildScrollableBuildingList(ScrollController scrollController) {
    final List<Map<String, dynamic>> buildings = [
      {"name": "Windmill", "cost": "\$1,000", "income": "+\$10/day"},
      {"name": "Factory", "cost": "\$5,000", "income": "+\$50/day"},
      {"name": "Hospital", "cost": "\$10,000", "income": "+\$100/day"},
      {"name": "Park", "cost": "\$2,000", "income": "+\$20/day"},
      {"name": "Mall", "cost": "\$8,000", "income": "+\$80/day"},
      {"name": "Office", "cost": "\$15,000", "income": "+\$150/day"},
    ];

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: buildings.length,
      itemBuilder: (context, index) {
        final building = buildings[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: darkGreen.withOpacity(0.2),
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              building["name"]!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            subtitle: Text(
              "Cost: ${building["cost"]} • Income: ${building["income"]}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle building placement
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Place",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
