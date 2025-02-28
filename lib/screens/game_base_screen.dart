import 'package:flutter/material.dart';
import 'bottom_panel.dart'; // Import the new panel
import '../models/mock_data.dart';
import '../models/mock_historical_data.dart';
import 'package:fl_chart/fl_chart.dart';

// 🔹 ADDED: Defines the missing GameBaseScreen class
class GameBaseScreen extends StatefulWidget {
  const GameBaseScreen({Key? key}) : super(key: key);

  @override
  _GameBaseScreenState createState() => _GameBaseScreenState();
}

class _GameBaseScreenState extends State<GameBaseScreen> {
  List<Map<String, dynamic>?> grid = List.generate(36, (_) => null);
  int currentRotation = 0;
  Map<String, dynamic> investments = {
    "AAPL": {"shares": 0, "xp": 0},
    "TSLA": {"shares": 0, "xp": 0},
    "GOOGL": {"shares": 0, "xp": 0},
    "AMZN": {"shares": 0, "xp": 0},
  };

  // ✅ XP Required for Each Level
  Map<int, int> levelThresholds = {
    1: 100,
    2: 300,
    3: 600,
    4: 1000,
  };

  int? selectedTileForMove;
  double cashBalance = 10000.0; // ✅ Ensure it's explicitly a double

  String getBuildingImage(String ticker, int level) {
    return MockStockData.getStockImage(ticker, level) ??
        "assets/images/default_building.png";
  }

  final Map<String, List<String>> buildingUpgrades = {
    "AAPL": [
      "assets/images/apple_small.png",
      "assets/images/apple_.png",
      "assets/images/apple_hq.png"
    ],
    "TSLA": [
      "assets/images/tesla_factory.png",
      "assets/images/tesla_gigafactory.png"
    ],
  };

  // 🔹 This function handles tile taps for interaction
  void handleTileTap(int index) {
    if (grid[index] != null) {
      showStockMenu(index);
    } else if (selectedTileForMove != null) {
      setState(() {
        grid[index] = grid[selectedTileForMove!];
        grid[selectedTileForMove!] = null;
        selectedTileForMove = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/grass_texture.png"),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: 36,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      handleTileTap(index), // ✅ Now this function exists!
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: selectedTileForMove == index
                          ? Colors.orangeAccent.withOpacity(0.6)
                          : grid[index] != null
                              ? Colors.green[300]
                              : Colors.greenAccent[100],
                      border: Border.all(color: Colors.brown, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        if (grid[index] != null)
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                      ],
                    ),
                    child: grid[index] != null
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child:
                                Image.asset(grid[index]!["image"], width: 50),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          // 🔽 Lowered Bottom Panel to 50% of screen height
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.5, // ⬇ Lowered from 60% to 50%
              child: BottomPanel(
                onInvest: invest,
                cashBalance: cashBalance, // ✅ Passes the cash balance
              ),
            ),
          ),
        ],
      ),
    );
  }

  void invest(String stock, double amount) {
    setState(() {
      print("🔹 INVEST FUNCTION CALLED: Stock: $stock | Amount: $amount");

      double stockPrice = MockStockData.getStockData(stock)?["price"] ?? 0;

      // ⭐ FIXED: Convert investment amount to actual shares
      // Here's the issue - we need to ensure we're properly calculating how many shares are bought

      // Original calculation (likely causing the issue)
      // double sharesBought = (amount / stockPrice);

      // ⭐ FIXED: Make shares calculation more meaningful
      // If amount is $50, and price is $100, this should buy 0.5 shares
      // If we're investing a fixed dollar amount (e.g. $50), calculate shares correctly
      double sharesBought = amount / stockPrice;

      // Debug: Print exactly how many shares are being bought
      print(
          "💡 SHARES DEBUG: Buying $sharesBought shares of $stock (Amount: \$$amount, Price: \$$stockPrice)");

      // ✅ Ensure investments[stock] exists
      if (investments[stock] == null ||
          investments[stock] is! Map<String, dynamic>) {
        investments[stock] = {"shares": 0.0, "xp": 0};
        print("✅ Initialized investments[$stock]: ${investments[stock]}");
      }

      // ✅ Extract current values safely
      double shareAmount = 0.0;
      if (investments[stock]["shares"] != null) {
        if (investments[stock]["shares"] is int) {
          shareAmount = (investments[stock]["shares"] as int).toDouble();
        } else if (investments[stock]["shares"] is double) {
          shareAmount = (investments[stock]["shares"] as double);
        }
      }

      // ⭐ FIXED: Multiply shares by a scaling factor if needed (e.g. 10x)
      // This makes progression faster for testing
      double scalingFactor = 1.0; // Adjust if needed for faster progression
      double newSharesValue = shareAmount + (sharesBought * scalingFactor);

      // Debug: Current share count
      print(
          "💡 SHARES DEBUG: Previous: $shareAmount, New Total: $newSharesValue");

      int newXP = (newSharesValue * 100).toInt();

      // Create a new map to avoid type errors
      Map<String, dynamic> updatedStock = {
        "shares": newSharesValue, // Double
        "xp": newXP // Integer
      };

      // Replace the entire map
      investments[stock] = updatedStock;

      print("📊 Updated shares for $stock: $newSharesValue");
      print("✅ XP updated for $stock: $newXP (based on shares owned)");

      // ✅ Define level thresholds based on shares
      Map<int, int> shareThresholds = {
        1: 0, // Level 1: 0+ shares (starting level)
        2: 2, // Level 2: 2+ shares
        3: 5, // Level 3: 5+ shares
        4: 9, // Level 4: 9+ shares
        5: 14, // Level 5: 14+ shares
      };

      // Debug: Print all thresholds
      print("🔍 LEVEL THRESHOLDS: $shareThresholds");

      // Calculate current and next level
      int currentLevel = 1;
      int nextLevel = 2;

      // Sort thresholds for proper progression
      List<int> sortedLevels = shareThresholds.keys.toList()..sort();

      // Find the current level based on shares
      for (int i = 0; i < sortedLevels.length; i++) {
        int level = sortedLevels[i];
        if (newSharesValue >= shareThresholds[level]!) {
          currentLevel = level;
          // Set next level if not at max
          if (i < sortedLevels.length - 1) {
            nextLevel = sortedLevels[i + 1];
          } else {
            nextLevel = currentLevel + 1; // Beyond our defined levels
          }
        } else {
          break;
        }

        // Debug: Print share count and determined level
        print(
            "💡 LEVEL DEBUG: $newSharesValue shares = Level $currentLevel (Next: $nextLevel)");

        // Get the thresholds for current and next level
        int currentThreshold = shareThresholds[currentLevel]!;
        int nextThreshold =
            shareThresholds[nextLevel] ?? (currentThreshold + 5);

        // Calculate progress
        double progressToNext = 0.0;
        if (nextThreshold > currentThreshold) {
          progressToNext = (newSharesValue - currentThreshold) /
              (nextThreshold - currentThreshold);
          progressToNext = progressToNext.clamp(0.0, 1.0);
        }

        print(
            "📊 Level: $currentLevel → $nextLevel | Progress: $progressToNext");
        print(
            "📊 Thresholds: Current ($currentThreshold) → Next ($nextThreshold)");

        // ✅ If the stock isn't placed, find an empty tile and add it
        int tileIndex = grid.indexWhere((b) => b?["type"] == stock);
        print("🛠️ Checking grid for $stock: Found at tile index $tileIndex");

        if (tileIndex == -1) {
          int? emptyTile = findEmptyTile();
          print("🔍 findEmptyTile() returned: $emptyTile");

          if (emptyTile != null) {
            grid[emptyTile] = {
              "type": stock,
              "level": currentLevel,
              "image": getBuildingImage(stock, currentLevel),
              "progress": progressToNext,
              "shares": newSharesValue,
            };
            tileIndex = emptyTile;
            print(
                "🏗️ Placed new $stock building at Level $currentLevel on tile $emptyTile");
          } else {
            print("❌ No empty tile available for $stock!");
          }
        } else if (grid[tileIndex] != null) {
          // Store the previous level for comparison
          int previousLevel = grid[tileIndex]!["level"] ?? 1;

          // ⭐ FIXED: Make a completely new map to avoid type errors
          Map<String, dynamic> updatedTile =
              Map<String, dynamic>.from(grid[tileIndex]!);
          updatedTile["level"] = currentLevel;
          updatedTile["image"] = getBuildingImage(stock, currentLevel);
          updatedTile["progress"] = progressToNext;
          updatedTile["shares"] = newSharesValue;

          // Replace the entire grid tile
          grid[tileIndex] = updatedTile;

          if (previousLevel != currentLevel) {
            print(
                "🔼 LEVEL UP! $stock upgraded from Level $previousLevel to Level $currentLevel");
          } else {
            print(
                "📈 Progress updated for $stock: $progressToNext towards Level $nextLevel");
          }
        }

        print(
            "📊 Transaction Summary: Stock: $stock | Shares: $newSharesValue | Level: $currentLevel | Progress: ${(progressToNext * 100).toInt()}%");
      }
    });
  }

  int? findEmptyTile() {
    for (int i = 0; i < grid.length; i++) {
      if (grid[i] == null) {
        print("✅ Found empty tile at index $i");
        return i;
      }
    }
    print("⚠️ No empty tile found!");
    return null;
  }

  // To fix the progress bar in the stock menu without removing other elements,
// locate the part of your showStockMenu method that handles the progress bar calculation
// and replace only that section with this code:

  void showStockMenu(int index) {
    String stockName = grid[index]!["type"];

    final Map<String, String> stockKeyMapping = {
      "Apple": "AAPL",
      "Tesla": "TSLA",
      "Google": "GOOGL",
      "Amazon": "AMZN",
      "Nvidia": "NVDA",
    };

    if (stockKeyMapping.containsKey(stockName)) {
      stockName = stockKeyMapping[stockName]!;
    }

    Map<String, dynamic>? stockData = MockStockData.getStockData(stockName);

    if (stockData == null) {
      print("❌ ERROR: No stock data found for $stockName");
      return;
    }

    double stockPrice = (stockData["price"] as num?)?.toDouble() ?? 0.0;
    String ticker = stockData["ticker"];
    double change = stockData["change"];
    String marketCap = stockData["marketCap"];
    bool isPositiveChange = change >= 0;
    String logoPath = "assets/logos/${ticker.toLowerCase()}.png";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Calculate shares and levels
            double getUpdatedShares() {
              double shares = 0.0;
              if (investments[stockName]?["shares"] is double) {
                shares = investments[stockName]?["shares"] as double;
              } else if (investments[stockName]?["shares"] is int) {
                shares = (investments[stockName]?["shares"] as int).toDouble();
              }
              return shares;
            }

            double sharesOwned = getUpdatedShares();
            double currentBalance =
                cashBalance; // Track current balance for display

            // Calculate value of current position
            double positionValue = sharesOwned * stockPrice;

            // Define level thresholds
            Map<int, int> shareThresholds = {
              1: 0, // Level 1: 0+ shares (starting level)
              2: 2, // Level 2: 2+ shares
              3: 5, // Level 3: 5+ shares
              4: 9, // Level 4: 9+ shares
              5: 14, // Level 5: 14+ shares
            };

            // Calculate current and next level
            int currentLevel = 1;
            int nextLevel = 2;

            List<int> sortedLevels = shareThresholds.keys.toList()..sort();
            for (int i = 0; i < sortedLevels.length; i++) {
              int level = sortedLevels[i];
              if (sharesOwned >= shareThresholds[level]!) {
                currentLevel = level;
                if (i < sortedLevels.length - 1) {
                  nextLevel = sortedLevels[i + 1];
                } else {
                  nextLevel = currentLevel + 1;
                }
              } else {
                break;
              }
            }

            // Calculate progress
            int currentThreshold = shareThresholds[currentLevel]!;
            int nextThreshold =
                shareThresholds[nextLevel] ?? (currentThreshold + 5);

            double progress = 0.0;
            if (nextThreshold > currentThreshold) {
              progress = (sharesOwned - currentThreshold) /
                  (nextThreshold - currentThreshold);
              progress = progress.clamp(0.0, 1.0);
            }

            // Get current and next building images
            String currentBuildingImage =
                getBuildingImage(stockName, currentLevel) ??
                    "assets/images/default_building.png";
            String nextBuildingImage = currentLevel < 5
                ? getBuildingImage(stockName, currentLevel + 1) ??
                    currentBuildingImage
                : currentBuildingImage;

            int maxLevel = 5;

            // Calculate how many shares can be bought with current balance
            double maxSharesToBuy = currentBalance / stockPrice;

            // Function to handle buying shares
            void handleBuy() {
              double amountToInvest = 100; // Default amount

              // Check if player has enough money
              if (currentBalance >= amountToInvest) {
                // ⭐ FIXED: Update cash balance before calling invest
                setState(() {
                  cashBalance -= amountToInvest;
                });

                invest(stockName, amountToInvest);

                setDialogState(() {
                  // Update shares and balance after investing
                  sharesOwned = getUpdatedShares();
                  currentBalance = cashBalance;
                });

                print(
                    "💰 BALANCE UPDATE: Spent \$$amountToInvest, New Balance: \$$cashBalance");
              } else {
                // Show insufficient funds message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Insufficient funds! You need \$${amountToInvest.toStringAsFixed(2)}'),
                    backgroundColor: Colors.red[700],
                  ),
                );
              }
            }

            // Function to handle selling shares
            void handleSell() {
              double amountToSell = 100; // Default amount
              double sharesToSell = amountToSell / stockPrice;

              // Check if player has enough shares to sell
              if (sharesOwned >= sharesToSell) {
                // ⭐ FIXED: Update cash balance before calling invest
                setState(() {
                  cashBalance += amountToSell;
                });

                invest(stockName, -amountToSell);

                setDialogState(() {
                  // Update shares and balance after selling
                  sharesOwned = getUpdatedShares();
                  currentBalance = cashBalance;
                });

                print(
                    "💰 BALANCE UPDATE: Received \$$amountToSell, New Balance: \$$cashBalance");
              } else {
                // Show insufficient shares message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Not enough shares to sell \$100 worth!'),
                    backgroundColor: Colors.red[700],
                  ),
                );
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.transparent,
              child: Container(
                width: 320,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🏦 Stock Header (Logo + Name)
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              // Replace your GestureDetector code with this:
                              GestureDetector(
                                onTap: () => showStockInfo(stockName),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 246, 100, 224),
                                        width: 2),
                                  ),
                                  padding: const EdgeInsets.all(
                                      10), // Add padding to ensure the logo isn't crowded
                                  child: ClipOval(
                                    child: Image.asset(
                                      logoPath,
                                      fit: BoxFit
                                          .contain, // Using contain ensures the whole logo is visible
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "$stockName ($ticker)",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      // NEW: Info button
                                    ],
                                  ),
                                  Text(
                                    "Market Cap: $marketCap",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.black87, size: 26),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),

                    // 💰 Cash Balance Display - Changed to Green
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.account_balance_wallet,
                                  color: Colors.green[700], size: 20),
                              SizedBox(width: 6),
                              Text(
                                "Cash Balance:",
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "\$${currentBalance.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // 🏢 Building Preview Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Building Evolution",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Current Building
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.grey[400]!),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      currentBuildingImage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Level $currentLevel",
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                  ),
                                ],
                              ),

                              // Arrow
                              Icon(
                                Icons.arrow_forward,
                                color: currentLevel < maxLevel
                                    ? Colors.green
                                    : Colors.grey[400],
                                size: 24,
                              ),

                              // Next Building (if not at max level)
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: currentLevel < maxLevel
                                            ? Colors.green
                                            : Colors.grey[300]!,
                                        width: currentLevel < maxLevel ? 2 : 1,
                                      ),
                                      boxShadow: currentLevel < maxLevel
                                          ? [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: currentLevel < maxLevel
                                        ? Image.asset(
                                            nextBuildingImage,
                                            fit: BoxFit.contain,
                                          )
                                        : Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.asset(
                                                currentBuildingImage,
                                                fit: BoxFit.contain,
                                                color: Colors.grey[400],
                                                colorBlendMode:
                                                    BlendMode.srcATop,
                                              ),
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 36,
                                              ),
                                            ],
                                          ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    currentLevel < maxLevel
                                        ? "Level ${currentLevel + 1}"
                                        : "MAX LEVEL",
                                    style: TextStyle(
                                      color: currentLevel < maxLevel
                                          ? Colors.green
                                          : Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: currentLevel < maxLevel
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // 🔄 Investment Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upgrade Progress: ${currentLevel < maxLevel ? "${(progress * 100).toInt()}%" : "MAX LEVEL"}",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                          minHeight: 8,
                        ),
                        if (currentLevel < maxLevel)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "${(nextThreshold - sharesOwned).toStringAsFixed(2)} more shares needed",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          )
                      ],
                    ),

                    SizedBox(height: 12),

                    // 📊 Shares & Price Section
                    Row(
                      children: [
                        // Shares owned container
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Shares Owned:",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text(
                                  sharesOwned.toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Value: \$${positionValue.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Stock price container
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isPositiveChange
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isPositiveChange
                                    ? Colors.green[300]!
                                    : Colors.red[300]!,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Current Price:",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      isPositiveChange
                                          ? Icons.trending_up
                                          : Icons.trending_down,
                                      color: isPositiveChange
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text("\$${stockPrice.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "${isPositiveChange ? "+" : ""}${change.toStringAsFixed(2)}%",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isPositiveChange
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    // 🚀 Buy & Sell Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton("Buy \$100", Icons.add_shopping_cart,
                            Colors.green[600]!, handleBuy),
                        _buildActionButton("Sell \$100", Icons.sell,
                            Colors.red[600]!, handleSell),
                      ],
                    ),

                    SizedBox(height: 10),

                    // 🏗️ Move & Remove Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                            "Move", Icons.open_with, Colors.orange[700]!, () {
                          setState(() {
                            selectedTileForMove = index;
                          });
                          Navigator.pop(context);
                        }),
                        _buildActionButton(
                            "Remove", Icons.delete, Colors.grey[700]!, () {
                          setState(() {
                            grid[index] = null;
                          });
                          Navigator.pop(context);
                        }),
                      ],
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

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 140,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  // Fix for too many positional arguments
// Fix for too many positional arguments
// Fix for too many positional arguments
  void showStockInfo(String stockName) {
    // Stock info descriptions
    final Map<String, Map<String, String>> stockInfo = {
      "AAPL": {
        "founded": "April 1, 1976",
        "founder": "Steve Jobs, Steve Wozniak, Ronald Wayne",
        "headquarters": "Cupertino, California",
        "description":
            "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. The company offers iPhone, iPad, Mac, Apple Watch, and services like Apple Music, iCloud, and Apple Pay.",
        "factoid":
            "Apple became the first publicly traded U.S. company to be valued at over \$1 trillion in August 2018, and later surpassed \$2 trillion in August 2020."
      },
      "TSLA": {
        "founded": "July 1, 2003",
        "founder":
            "Elon Musk, JB Straubel, Martin Eberhard, Marc Tarpenning, Ian Wright",
        "headquarters": "Austin, Texas",
        "description":
            "Tesla, Inc. designs, develops, manufactures, and sells electric vehicles, energy generation and storage systems. The company produces and sells the Model 3, Model Y, Model S, and Model X, as well as solar energy products.",
        "factoid":
            "Tesla became the most valuable automaker in July 2020, surpassing Toyota, despite producing a fraction of the vehicles of legacy automakers."
      },
      "GOOGL": {
        "founded": "September 4, 1998",
        "founder": "Larry Page, Sergey Brin",
        "headquarters": "Mountain View, California",
        "description":
            "Alphabet Inc. (Google) provides online advertising services, cloud computing, software, and hardware. The company's products include Search, Maps, YouTube, Chrome, and Android, as well as technical infrastructure.",
        "factoid":
            "Google's famous 'Don't be evil' motto was part of the company's code of conduct from its early days, though it was removed in 2018."
      },
      "AMZN": {
        "founded": "July 5, 1994",
        "founder": "Jeff Bezos",
        "headquarters": "Seattle, Washington & Arlington, Virginia",
        "description":
            "Amazon.com, Inc. is an online retailer, manufacturer of electronic devices, and cloud computing provider. The company operates marketplaces, physical stores, and offers subscription services like Amazon Prime.",
        "factoid":
            "Amazon started as an online bookstore operating out of Jeff Bezos's garage before expanding to become one of the world's largest retailers."
      },
      "NVDA": {
        "founded": "April 5, 1993",
        "founder": "Jensen Huang, Chris Malachowsky, Curtis Priem",
        "headquarters": "Santa Clara, California",
        "description":
            "NVIDIA Corporation designs and manufactures graphics processing units (GPUs) and system on chip units (SoCs) for gaming, professional visualization, data center, and automotive markets.",
        "factoid":
            "NVIDIA was originally focused on PC graphics but has become a leader in AI and machine learning technologies, powering many recent advances in artificial intelligence."
      },
    };

    final Map<String, String> info = stockInfo[stockName] ??
        {"description": "No additional information available for this stock."};

    // Get stock data for the logo
    final Map<String, dynamic>? stockData =
        MockStockData.getStockData(stockName);
    final String ticker = stockData?["ticker"] ?? stockName;
    final String logoPath = "assets/logos/${ticker.toLowerCase()}.png";
    final double stockPrice = (stockData?["price"] as num?)?.toDouble() ?? 0.0;
    final double change = stockData?["change"] ?? 0.0;
    final bool isPositiveChange = change >= 0;

    // Get historical data and metrics
    final List<Map<String, dynamic>> historicalData =
        MockHistoricalData.getHistoricalData(stockName);
    final Map<String, dynamic> metrics =
        MockHistoricalData.getFinancialMetrics(stockName);

    // Extract safe metrics values
    final String peRatio = metrics["pe_ratio"]?.toString() ?? "N/A";
    final String eps = metrics["eps"]?.toString() ?? "N/A";
    final String dividendYield =
        ((metrics["dividend_yield"] ?? 0.0) * 100).toStringAsFixed(2);
    final String betaValue = metrics["beta"]?.toString() ?? "N/A";

    // Extract price range data
    final double lowPrice = (metrics["52w_low"] ?? 0.0).toDouble();
    final double highPrice = (metrics["52w_high"] ?? 100.0).toDouble();
    final double currentPrice =
        (metrics["price"] ?? ((lowPrice + highPrice) / 2)).toDouble();

    // Extract other metrics
    final double avgVolume = (metrics["avg_volume"] ?? 0.0).toDouble();
    final String volumeText = avgVolume / 1000000 > 0
        ? (avgVolume / 1000000).toStringAsFixed(1) + 'M'
        : 'N/A';
    final String marketCapValue = metrics["market_cap"] ?? "N/A";
    final String industryValue = metrics["industry"] ?? "N/A";
    final String exchangeValue = metrics["exchange"] ?? "NASDAQ";

    // Safely handle historical data
    final Map<String, dynamic> firstDataPoint = historicalData.isNotEmpty
        ? historicalData.first
        : {"price": 0.0, "date": "N/A"};
    final Map<String, dynamic> lastDataPoint = historicalData.isNotEmpty
        ? historicalData.last
        : {"price": 0.0, "date": "N/A"};

    // Find highest and lowest prices safely
    double highestPrice = 0.0;
    double lowestPrice = double.infinity;

    if (historicalData.isNotEmpty) {
      for (var data in historicalData) {
        final double price = (data["price"] as num).toDouble();
        if (price > highestPrice) highestPrice = price;
        if (price < lowestPrice) lowestPrice = price;
      }
    } else {
      lowestPrice = 0.0;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior:
                Clip.antiAlias, // Ensures the gradient doesn't overflow
            child: Stack(
              children: [
                // Enhanced, more visible back button at top left
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.arrow_back,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 4),
                              Text(
                                "Back",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Close button at top right
                Positioned(
                  right: 8,
                  top: 8,
                  child: Material(
                    color: Colors.black.withOpacity(0.3),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 24),
                      onPressed: () => Navigator.pop(context),
                      tooltip: "Close",
                    ),
                  ),
                ),

                // Main content
                Column(
                  children: [
                    // Header with gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue[800]!,
                            Colors.blue[600]!,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Stock header with price
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo in a container
                                Container(
                                  width: 70, // Increased size
                                  height: 70, // Increased size
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(
                                      6), // Increased padding
                                  child: ClipOval(
                                    child: Image.asset(
                                      logoPath,
                                      fit: BoxFit
                                          .contain, // Changed to contain for better logo display
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Stock name and sector
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stockName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        ticker,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        metrics["sector"] ?? "Technology",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Price and change
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$${stockPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPositiveChange
                                            ? Colors.green[400]
                                            : Colors.red[400],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isPositiveChange
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          Text(
                                            "${isPositiveChange ? '+' : ''}${change.toStringAsFixed(2)}%",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Quick Metrics Cards
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            child: Row(
                              children: [
                                _buildQuickMetricCard(
                                    "P/E Ratio", peRatio, Icons.assessment),
                                _buildQuickMetricCard("Div Yield",
                                    "${dividendYield}%", Icons.attach_money),
                                _buildQuickMetricCard(
                                    "52W High",
                                    "\$${highPrice.toString()}",
                                    Icons.trending_up),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tabbed content
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TabBar(
                                labelColor: Colors.blue[700],
                                unselectedLabelColor: Colors.grey[600],
                                indicatorColor: Colors.blue[700],
                                indicatorWeight: 3,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                tabs: const [
                                  Tab(text: "Overview"),
                                  Tab(text: "Charts"),
                                  Tab(text: "Financials"),
                                ],
                              ),
                            ),

                            // Tab content
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // OVERVIEW TAB
                                  _buildOverviewTab(info),

                                  // CHARTS TAB (formerly Historical)
                                  _buildChartsTab(
                                      historicalData,
                                      firstDataPoint,
                                      lastDataPoint,
                                      highestPrice,
                                      lowestPrice),

                                  // FINANCIALS TAB
                                  _buildFinancialsTab(
                                      peRatio,
                                      eps,
                                      dividendYield,
                                      betaValue,
                                      lowPrice,
                                      highPrice,
                                      currentPrice,
                                      volumeText,
                                      marketCapValue,
                                      industryValue,
                                      exchangeValue),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper widget for header quick metrics
  Widget _buildQuickMetricCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.15),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// OVERVIEW TAB
  Widget _buildOverviewTab(Map<String, String> info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Info Card
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Company Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (info.containsKey("founded"))
                    _buildInfoRow("Founded", info["founded"]!),
                  if (info.containsKey("founder"))
                    _buildInfoRow("Founder", info["founder"]!),
                  if (info.containsKey("headquarters"))
                    _buildInfoRow("Headquarters", info["headquarters"]!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Description Card
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Business Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    info["description"]!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Factoid Card
          if (info.containsKey("factoid"))
            Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        const Text(
                          "Did You Know?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      info["factoid"]!,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue[900],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

// CHARTS TAB
  Widget _buildChartsTab(
      List<Map<String, dynamic>> historicalData,
      Map<String, dynamic> firstDataPoint,
      Map<String, dynamic> lastDataPoint,
      double highestPrice,
      double lowestPrice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Card
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Price History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // Chart period toggle buttons - could be implemented as a segmented control
                      Row(
                        children: [
                          _buildPeriodButton("1M", true),
                          _buildPeriodButton("3M", false),
                          _buildPeriodButton("1Y", false),
                          _buildPeriodButton("All", false),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey[300],
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "\$${value.toInt()}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < historicalData.length &&
                                    value.toInt() % 4 == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      historicalData[value.toInt()]["date"]
                                          .toString()
                                          .substring(5), // Show only MM-DD
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              reservedSize: 30,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              historicalData.length,
                              (index) => FlSpot(
                                index.toDouble(),
                                historicalData[index]["price"].toDouble(),
                              ),
                            ),
                            isCurved: true,
                            color: Colors.blue[600],
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue[200]!.withOpacity(0.3),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.blue[400]!.withOpacity(0.4),
                                  Colors.blue[200]!.withOpacity(0.1),
                                  Colors.blue[100]!.withOpacity(0),
                                ],
                                stops: [0, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.blue[700]!,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((LineBarSpot spot) {
                                return LineTooltipItem(
                                  '\$${spot.y.toStringAsFixed(2)}\n${historicalData[spot.x.toInt()]["date"]}',
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Chart summary card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildChartSummaryItem(
                          "Open",
                          "\$${firstDataPoint["price"].toStringAsFixed(2)}",
                        ),
                        _buildChartSummaryItem(
                          "Close",
                          "\$${lastDataPoint["price"].toStringAsFixed(2)}",
                        ),
                        _buildChartSummaryItem(
                          "High",
                          "\$${highestPrice.toStringAsFixed(2)}",
                        ),
                        _buildChartSummaryItem(
                          "Low",
                          "\$${lowestPrice.toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recent Price Data Card - Make sure width is consistent
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Ensure this card has same width as the chart card
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Price Data",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) => Colors.grey[100]!,
                          ),
                          dataRowHeight: 42,
                          headingRowHeight: 45,
                          horizontalMargin: 16,
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(
                              label: Text(
                                "Date",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Price",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Volume",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: historicalData.take(7).map((data) {
                            final previousIndex =
                                historicalData.indexOf(data) > 0
                                    ? historicalData.indexOf(data) - 1
                                    : 0;
                            final previousPrice =
                                historicalData[previousIndex]["price"] as num;
                            final currentPrice = data["price"] as num;

                            return DataRow(
                              cells: [
                                DataCell(Text(data["date"].toString())),
                                DataCell(Text(
                                  "\$${currentPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: currentPrice > previousPrice
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                                DataCell(Text(
                                  "${(data["volume"] / 1000).toStringAsFixed(0)}K",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// FINANCIALS TAB
  Widget _buildFinancialsTab(
      String peRatio,
      String eps,
      String dividendYield,
      String betaValue,
      double lowPrice,
      double highPrice,
      double currentPrice,
      String volumeText,
      String marketCapValue,
      String industryValue,
      String exchangeValue) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial Highlights Card
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Financial Highlights",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Simplified layout to avoid overflow - using rows instead of grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          "P/E Ratio",
                          peRatio,
                          Icons.assessment,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricCard(
                          "EPS",
                          "\${eps}",
                          Icons.attach_money,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          "Dividend Yield",
                          "${dividendYield}%",
                          Icons.show_chart,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricCard(
                          "Beta",
                          betaValue,
                          Icons.stacked_line_chart,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Price Range Card
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "52-Week Price Range",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price range slider
                  Row(
                    children: [
                      Text(
                        "\$${lowPrice.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 8,
                                activeTrackColor: Colors.blue[200],
                                inactiveTrackColor: Colors.grey[200],
                                thumbColor: Colors.blue[600],
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                              ),
                              child: Slider(
                                min: lowPrice,
                                max: highPrice,
                                value: currentPrice,
                                onChanged: null,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Current: \$${currentPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\$${highPrice.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Trading Information Card
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Trading Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow("Average Volume", volumeText),
                  _buildInfoRow("Market Cap", marketCapValue),
                  _buildInfoRow("Industry", industryValue),
                  _buildInfoRow("Exchange", exchangeValue),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Data shown is for educational purposes only. Always do your own research before investing.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Fix for missing identifier and unexpected text
  Widget _buildPeriodButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[700],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

// Helper for chart summary items
  Widget _buildChartSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

// Fix for undefined name 'eps' and other variables
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label + ":",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for financial metrics card
  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[700] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPageDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue[700] : Colors.grey[300],
      ),
    );
  }

  int currentPage = 0;

  // Add this method to your _GameBaseScreenState class to show a swipeable dialog
  void _showDialog(int index) {
    if (index < 0 || index >= grid.length || grid[index] == null) return;

    final building = grid[index]!;
    final stockType = building["type"] ?? "";
    final level = building["level"] ?? 1;
    final shares = building["shares"] ?? 0.0;

    int currentPage = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 200, // Adjust height as needed
                    width: double.maxFinite,
                    child: PageView(
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      children: [
                        // First page - Building info
                        Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  building["image"] ?? "",
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.business, size: 40),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$stockType Building",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text("Level $level"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Shares"),
                                Text("$shares"),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Income"),
                                Text(
                                    "\$${(shares * 0.5).toStringAsFixed(2)}/day"),
                              ],
                            ),
                          ],
                        ),

                        // Second page - Company info
                        Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  building["image"] ?? "",
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.business, size: 40),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${building["symbol"] ?? stockType}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                        "Market Cap: ${building["marketCap"] ?? "N/A"}"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Current Price"),
                                Text("\$${building["price"] ?? "0.00"}"),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Change"),
                                Text(
                                  "${building["priceChange"] ?? "0.00"}%",
                                  style: TextStyle(
                                    color: (building["priceChange"] ?? 0) >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Upgrade logic
                          Navigator.of(context).pop();
                        },
                        child: Text("Upgrade"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == 0 ? Colors.blue : Colors.grey,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == 1 ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Helper method to handle swipe detection
Widget buildSwipeDetector(
    {required Widget child,
    required Function() onSwipeLeft,
    required Function() onSwipeRight}) {
  return GestureDetector(
    onHorizontalDragEnd: (details) {
      if (details.primaryVelocity! > 0) {
        // Swiped right
        onSwipeRight();
      } else if (details.primaryVelocity! < 0) {
        // Swiped left
        onSwipeLeft();
      }
    },
    child: child,
  );
}
