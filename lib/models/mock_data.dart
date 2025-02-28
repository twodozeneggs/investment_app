class MockStockData {
  static final Map<String, dynamic> stockInfo = {
    "AAPL": {
      "ticker": "AAPL",
      "price": 154.75,
      "change": -0.78,
      "sharesOwned": 20,
      "marketCap": "2.5T",
      "images": {
        1: "assets/images/stocks/apple_small.png",
        2: "assets/images/stocks/apple_medium.png",
        3: "assets/images/stocks/apple_large.png",
        4: "assets/images/stocks/apple_megabuilding.png",
        5: "assets/images/stocks/apple_skyscraper.png",
      }
    },
    "TSLA": {
      "ticker": "TSLA",
      "price": 720.50,
      "change": 2.14,
      "sharesOwned": 5,
      "marketCap": "720B",
      "images": {
        1: "assets/images/stocks/tesla_small.png",
        2: "assets/images/stocks/tesla_medium.png",
        3: "assets/images/stocks/tesla_large.png",
        4: "assets/images/stocks/tesla_gigafactory.png",
      }
    }
  };

  // Retrieve stock data by building name
  static Map<String, dynamic>? getStockData(String buildingName) {
    return stockInfo[buildingName]; // Ensure `buildingName` matches keys
  }

  // Retrieve stock image based on name and level
  static String? getStockImage(String ticker, int level) {
    return stockInfo[ticker]?["images"]?[level];
  }
}
