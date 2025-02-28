import 'package:flutter/material.dart';

void showSwipeableStockDialog(
  BuildContext context, {
  required String stockName,
  required double shares,
  required int level,
  required Function() onBuy,
  required Function() onSell,
  required Function() onMove,
  required Function() onRemove,
}) {
  final pageController = PageController(initialPage: 0);
  int currentPage = 0;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            content: Container(
              width: 300,
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (page) {
                        setDialogState(() {
                          currentPage = page;
                        });
                      },
                      children: [
                        // First page
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Building Info",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text("Stock: $stockName"),
                            Text("Level: $level"),
                            Text("Shares: ${shares.toStringAsFixed(1)}"),
                            SizedBox(height: 20),
                            Text("Swipe for more →"),
                          ],
                        ),

                        // Second page
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Stock Info",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text("Stock: $stockName"),
                            Text("Shares: ${shares.toStringAsFixed(1)}"),
                            SizedBox(height: 20),
                            Text("← Swipe back"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == 0 ? Colors.blue : Colors.grey,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == 1 ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onBuy();
                  Navigator.of(context).pop();
                },
                child: Text("Buy"),
              ),
              TextButton(
                onPressed: () {
                  onSell();
                  Navigator.of(context).pop();
                },
                child: Text("Sell"),
              ),
              TextButton(
                onPressed: () {
                  onMove();
                  Navigator.of(context).pop();
                },
                child: Text("Move"),
              ),
              TextButton(
                onPressed: () {
                  onRemove();
                  Navigator.of(context).pop();
                },
                child: Text("Remove"),
              ),
            ],
          );
        },
      );
    },
  );
}
