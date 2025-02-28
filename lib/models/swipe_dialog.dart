import 'package:flutter/material.dart';
import 'package:investment_app/swipe_dialog.dart'; // Replace with your actual app name

void showSwipeDialog(
  BuildContext context, {
  required String stockName,
  required double shares,
  required int level,
  required VoidCallback onBuy,
  required VoidCallback onSell,
  required VoidCallback onMove,
  required VoidCallback onRemove,
}) {
  int currentPage = 0;
  final pageController = PageController(initialPage: 0);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Container(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  // Swipeable content
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (page) {
                        setState(() {
                          currentPage = page;
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Text("Stock: $stockName"),
                                Text("Level: $level"),
                                Text("Shares: ${shares.toStringAsFixed(2)}"),
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Text("Stock: $stockName"),
                                Text("Shares: ${shares.toStringAsFixed(2)}"),
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
                        width: currentPage == 0 ? 10 : 8,
                        height: currentPage == 0 ? 10 : 8,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == 0 ? Colors.blue : Colors.grey,
                        ),
                      ),
                      Container(
                        width: currentPage == 1 ? 10 : 8,
                        height: currentPage == 1 ? 10 : 8,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == 1 ? Colors.blue : Colors.grey,
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
                          onPressed: () {
                            onBuy();
                            Navigator.pop(context);
                          },
                          child: Text("Buy"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onSell();
                            Navigator.pop(context);
                          },
                          child: Text("Sell"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onMove();
                            Navigator.pop(context);
                          },
                          child: Text("Move"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onRemove();
                            Navigator.pop(context);
                          },
                          child: Text("Remove"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
