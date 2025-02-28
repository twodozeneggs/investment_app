import 'package:flutter/material.dart';

class StockDialog extends StatefulWidget {
  final String logoPath;
  final String stockName;
  final String ticker;
  final double stockPrice;
  final double change;
  final bool isPositiveChange;
  final String marketCap;
  final double sharesOwned;
  final double positionValue;
  final double currentBalance;
  final String companyDescription;
  final int buildingLevel;
  final int nextLevel;
  final double progressToNext;
  final double sharesNeeded;
  final String currentBuildingImage;
  final String nextBuildingImage;
  final Function(double) onBuy;
  final Function(double) onSell;
  final VoidCallback onMove;
  final VoidCallback onRemove;

  const StockDialog({
    Key? key,
    required this.logoPath,
    required this.stockName,
    required this.ticker,
    required this.stockPrice,
    required this.change,
    required this.isPositiveChange,
    required this.marketCap,
    required this.sharesOwned,
    required this.positionValue,
    required this.currentBalance,
    required this.companyDescription,
    required this.buildingLevel,
    required this.nextLevel,
    required this.progressToNext,
    required this.sharesNeeded,
    required this.currentBuildingImage,
    required this.nextBuildingImage,
    required this.onBuy,
    required this.onSell,
    required this.onMove,
    required this.onRemove,
  }) : super(key: key);

  @override
  _StockDialogState createState() => _StockDialogState();
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
                  _buildBuildingEvolutionCard(),

                  // Second card - Company Information
                  _buildCompanyInfoCard(),
                ],
              ),
            ),

            // Page indicator dots
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPageIndicator(0),
                  SizedBox(width: 8),
                  _buildPageIndicator(1),
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
                        child: ElevatedButton.icon(
                          onPressed: () => widget.onBuy(100),
                          icon: Icon(Icons.add_shopping_cart,
                              color: Colors.white, size: 16),
                          label: Text("Buy \$100",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => widget.onSell(100),
                          icon: Icon(Icons.sell, color: Colors.white, size: 16),
                          label: Text("Sell \$100",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                        child: ElevatedButton.icon(
                          onPressed: widget.onMove,
                          icon: Icon(Icons.open_with,
                              color: Colors.white, size: 16),
                          label: Text("Move",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onRemove,
                          icon:
                              Icon(Icons.delete, color: Colors.white, size: 16),
                          label: Text("Remove",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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

  Widget _buildPageIndicator(int pageIndex) {
    return Container(
      width: _currentPage == pageIndex ? 10 : 8,
      height: _currentPage == pageIndex ? 10 : 8,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == pageIndex ? Colors.blue[700] : Colors.grey[400],
      ),
    );
  }

  Widget _buildBuildingEvolutionCard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo and title
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(widget.logoPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stockName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.ticker,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Building evolution title
          Text(
            "Building Evolution",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16),

          // Current building
          Text(
            "Current Building (Level ${widget.buildingLevel})",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(widget.currentBuildingImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Next building level
          widget.buildingLevel < 5
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Next Building (Level ${widget.nextLevel})",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(widget.nextBuildingImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Progress bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Progress to Level ${widget.nextLevel}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.progressToNext.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: widget.progressToNext / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 10,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Shares needed
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.sharesNeeded > 0
                                  ? "You need ${widget.sharesNeeded.toStringAsFixed(2)} more shares to reach Level ${widget.nextLevel}."
                                  : "You have enough shares to upgrade to Level ${widget.nextLevel}!",
                              style: TextStyle(
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Maximum building level reached!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoCard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo and title
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(widget.logoPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stockName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.ticker,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Company information title
          Text(
            "Company Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16),

          // Stock price and change
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Stock Price",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "\$${widget.stockPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Change",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          widget.isPositiveChange
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: widget.isPositiveChange
                              ? Colors.green[700]
                              : Colors.red[700],
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${widget.isPositiveChange ? '+' : ''}${widget.change.toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: widget.isPositiveChange
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Company description
          Text(
            "About",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.companyDescription,
            style: TextStyle(
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),

          SizedBox(height: 16),

          // Company stats
          Text(
            "Stats",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Market Cap",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      widget.marketCap,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Position",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      "${widget.sharesOwned.toStringAsFixed(2)} shares",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Position Value",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      "\$${widget.positionValue.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Your balance
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Balance",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${widget.currentBalance.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
