import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  static const String apiKey = 'YOUR_API_KEY';

  Future<List<Map<String, dynamic>>> fetchHistoricalData(String symbol) async {
    // Construct the Alpha Vantage URL
    final String url =
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$symbol&apikey=$apiKey';

    try {
      // Make the HTTP request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Validate and transform the data
        if (data.containsKey('Time Series (Daily)')) {
          final timeSeries = data['Time Series (Daily)'];
          return timeSeries.entries
              .map((entry) => {
                    'date': entry.key,
                    'close': double.tryParse(entry.value['4. close']) ?? 0.0,
                  })
              .toList()
              .reversed
              .toList(); // Reverse to get chronological order
        } else {
          throw Exception('Invalid data structure from Alpha Vantage');
        }
      } else {
        throw Exception(
            'Failed to fetch data. HTTP status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle and propagate the error
      throw Exception('Error fetching historical data: $e');
    }
  }
}
