import 'package:flutter/material.dart';

class StockDialog extends StatefulWidget {
  final String stockName;
  final double shares;
  final int level;
  final VoidCallback onBuy;
  final VoidCallback onSell;
  final VoidCallback onMove;
  final VoidCallback onRemove;

  const StockDialog({
    Key? key,
    required this.stockName,
    required this.shares,
    required this.level,
    required this.onBuy,
    required this.onSell,
    required this.onMove,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<StockDialog> createState() => _StockDialogState();
}

class _StockDialogState extends State<StockDialog> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 400,
        child: Column(
          children: [
            // Swipeable content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  // First page
                  Container(
                    color: Colors.blue[50],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Building Info",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text("Stock: ${widget.stockName}"),
                          Text("Level: ${widget.level}"),
                          Text("Shares: ${widget.shares.toStringAsFixed(2)}"),
                          SizedBox(height: 20),
                          Text("Swipe left for stock info →"),
                        ],
                      ),
                    ),
                  ),

                  // Second page
                  Container(
                    color: Colors.green[50],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Stock Info",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text("Stock: ${widget.stockName}"),
                          Text("Shares: ${widget.shares.toStringAsFixed(2)}"),
                          SizedBox(height: 20),
                          Text("← Swipe right for building info"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _currentPage == 0 ? 10 : 8,
                  height: _currentPage == 0 ? 10 : 8,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == 0 ? Colors.blue : Colors.grey,
                  ),
                ),
                Container(
                  width: _currentPage == 1 ? 10 : 8,
                  height: _currentPage == 1 ? 10 : 8,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == 1 ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),

            // Buttons
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: widget.onBuy,
                    child: Text("Buy"),
                  ),
                  ElevatedButton(
                    onPressed: widget.onSell,
                    child: Text("Sell"),
                  ),
                  ElevatedButton(
                    onPressed: widget.onMove,
                    child: Text("Move"),
                  ),
                  ElevatedButton(
                    onPressed: widget.onRemove,
                    child: Text("Remove"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
