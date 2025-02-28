import 'package:flutter/material.dart';

class SimpleSwipeableDialog extends StatefulWidget {
  final String stockName;
  final String ticker;
  final String logoPath;
  final double stockPrice;
  final double change;
  final bool isPositiveChange;
  final double sharesOwned;
  final double positionValue;
  final String marketCap;
  final int buildingLevel;
  final String currentBuildingImage;
  final int nextLevel;
  final String nextBuildingImage;
  final double progressToNext;
  final double sharesNeeded;
  final String companyDescription;
  final double currentBalance;
  final VoidCallback onBuy;
  final VoidCallback onSell;
  final VoidCallback onMove;
  final VoidCallback onRemove;

  const SimpleSwipeableDialog({
    Key? key,
    required this.stockName,
    required this.ticker,
    required this.logoPath,
    required this.stockPrice,
    required this.change,
    required this.isPositiveChange,
    required this.sharesOwned,
    required this.positionValue,
    required this.marketCap,
    required this.buildingLevel,
    required this.currentBuildingImage,
    required this.nextLevel,
    required this.nextBuildingImage,
    required this.progressToNext,
    required this.sharesNeeded,
    required this.companyDescription,
    required this.currentBalance,
    required this.onBuy,
    required this.onSell,
    required this.onMove,
    required this.onRemove,
  }) : super(key: key);

  @override
  _SimpleSwipeableDialogState createState() => _SimpleSwipeableDialogState();
}

class _SimpleSwipeableDialogState extends State<SimpleSwipeableDialog> {
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 320,
        height: 500,
        child: Column(
          children: [
            // Main content with PageView for swiping
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  // First card - Building Evolution
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Building Evolution",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Current Building Level: ${widget.buildingLevel}"),
                        SizedBox(height: 8),
                        Text(
                            "Shares Owned: ${widget.sharesOwned.toStringAsFixed(2)}"),
                        SizedBox(height: 8),
                        Text(
                            "Progress to Next Level: ${widget.progressToNext.toStringAsFixed(1)}%"),
                        SizedBox(height: 8),
                        Text(
                            "Shares Needed: ${widget.sharesNeeded.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),

                  // Second card - Company Information
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Company Information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Stock: ${widget.ticker}"),
                        SizedBox(height: 8),
                        Text(
                            "Price: \$${widget.stockPrice.toStringAsFixed(2)}"),
                        SizedBox(height: 8),
                        Text("Change: ${widget.change.toStringAsFixed(2)}%"),
                        SizedBox(height: 16),
                        Text("About:"),
                        SizedBox(height: 8),
                        Text(widget.companyDescription),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Page indicator dots
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _currentPage == 0 ? 10 : 8,
                    height: _currentPage == 0 ? 10 : 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == 0 ? Colors.blue : Colors.grey,
                    ),
                  ),
                  Container(
                    width: _currentPage == 1 ? 10 : 8,
                    height: _currentPage == 1 ? 10 : 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == 1 ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Buy & Sell Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onBuy,
                          child: Text("Buy"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onSell,
                          child: Text("Sell"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Move & Remove Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onMove,
                          child: Text("Move"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onRemove,
                          child: Text("Remove"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
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
