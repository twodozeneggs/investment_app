class StockAPI {
  static Future<List<Map<String, dynamic>>> fetchHistoricalData(
      String symbol) async {
    print('⚠️ Using mock data for fetchHistoricalData.');

    // Mock data for stock history
    return [
      {'date': '2023-01-01', 'close': 150.00},
      {'date': '2023-01-02', 'close': 155.00},
      {'date': '2023-01-03', 'close': 160.00},
      {'date': '2023-01-04', 'close': 165.00},
      {'date': '2023-01-05', 'close': 170.00},
    ];
  }
}
