import 'package:flutter/material.dart';

class MockHistoricalData {
  // Historical price data for stocks (monthly closing prices for the past year)
  static final Map<String, List<Map<String, dynamic>>> historicalPrices = {
    "AAPL": [
      {"date": "Feb 2024", "price": 154.75, "volume": 123450000},
      {"date": "Jan 2024", "price": 149.22, "volume": 118720000},
      {"date": "Dec 2023", "price": 152.53, "volume": 134560000},
      {"date": "Nov 2023", "price": 145.96, "volume": 127890000},
      {"date": "Oct 2023", "price": 138.42, "volume": 142670000},
      {"date": "Sep 2023", "price": 140.35, "volume": 119830000},
      {"date": "Aug 2023", "price": 145.87, "volume": 98760000},
      {"date": "Jul 2023", "price": 150.56, "volume": 109870000},
      {"date": "Jun 2023", "price": 155.12, "volume": 125430000},
      {"date": "May 2023", "price": 146.78, "volume": 132560000},
      {"date": "Apr 2023", "price": 139.65, "volume": 128790000},
      {"date": "Mar 2023", "price": 142.87, "volume": 117650000},
    ],
    "TSLA": [
      {"date": "Feb 2024", "price": 720.50, "volume": 87650000},
      {"date": "Jan 2024", "price": 695.62, "volume": 92340000},
      {"date": "Dec 2023", "price": 715.23, "volume": 85670000},
      {"date": "Nov 2023", "price": 650.75, "volume": 79540000},
      {"date": "Oct 2023", "price": 625.38, "volume": 83420000},
      {"date": "Sep 2023", "price": 595.45, "volume": 81250000},
      {"date": "Aug 2023", "price": 620.18, "volume": 76540000},
      {"date": "Jul 2023", "price": 685.75, "volume": 85670000},
      {"date": "Jun 2023", "price": 710.25, "volume": 91230000},
      {"date": "May 2023", "price": 650.32, "volume": 87650000},
      {"date": "Apr 2023", "price": 625.85, "volume": 82340000},
      {"date": "Mar 2023", "price": 590.23, "volume": 78920000},
    ],
    "GOOGL": [
      {"date": "Feb 2024", "price": 2875.40, "volume": 42350000},
      {"date": "Jan 2024", "price": 2750.15, "volume": 38760000},
      {"date": "Dec 2023", "price": 2810.35, "volume": 41250000},
      {"date": "Nov 2023", "price": 2680.75, "volume": 37890000},
      {"date": "Oct 2023", "price": 2550.42, "volume": 39670000},
      {"date": "Sep 2023", "price": 2625.60, "volume": 36540000},
      {"date": "Aug 2023", "price": 2720.15, "volume": 34980000},
      {"date": "Jul 2023", "price": 2780.30, "volume": 38760000},
      {"date": "Jun 2023", "price": 2820.45, "volume": 42350000},
      {"date": "May 2023", "price": 2720.80, "volume": 39870000},
      {"date": "Apr 2023", "price": 2650.25, "volume": 37540000},
      {"date": "Mar 2023", "price": 2580.75, "volume": 35980000},
    ],
    "AMZN": [
      {"date": "Feb 2024", "price": 3510.25, "volume": 56780000},
      {"date": "Jan 2024", "price": 3420.60, "volume": 52340000},
      {"date": "Dec 2023", "price": 3480.35, "volume": 58920000},
      {"date": "Nov 2023", "price": 3350.75, "volume": 54760000},
      {"date": "Oct 2023", "price": 3280.42, "volume": 56230000},
      {"date": "Sep 2023", "price": 3150.80, "volume": 51890000},
      {"date": "Aug 2023", "price": 3220.35, "volume": 49670000},
      {"date": "Jul 2023", "price": 3340.15, "volume": 53420000},
      {"date": "Jun 2023", "price": 3420.75, "volume": 57680000},
      {"date": "May 2023", "price": 3350.20, "volume": 54320000},
      {"date": "Apr 2023", "price": 3250.45, "volume": 52180000},
      {"date": "Mar 2023", "price": 3180.60, "volume": 50940000},
    ],
    "NVDA": [
      {"date": "Feb 2024", "price": 480.75, "volume": 62340000},
      {"date": "Jan 2024", "price": 450.30, "volume": 58760000},
      {"date": "Dec 2023", "price": 465.55, "volume": 64320000},
      {"date": "Nov 2023", "price": 430.25, "volume": 59870000},
      {"date": "Oct 2023", "price": 410.60, "volume": 61250000},
      {"date": "Sep 2023", "price": 385.75, "volume": 57680000},
      {"date": "Aug 2023", "price": 420.30, "volume": 55430000},
      {"date": "Jul 2023", "price": 440.55, "volume": 59870000},
      {"date": "Jun 2023", "price": 460.80, "volume": 63540000},
      {"date": "May 2023", "price": 425.35, "volume": 60980000},
      {"date": "Apr 2023", "price": 405.60, "volume": 58760000},
      {"date": "Mar 2023", "price": 380.25, "volume": 56430000},
    ],
  };

  // Financial metrics and key stats for each stock
  static final Map<String, Map<String, dynamic>> financialMetrics = {
    "AAPL": {
      "pe_ratio": 28.5,
      "dividend_yield": 0.65,
      "52w_high": 157.85,
      "52w_low": 138.42,
      "avg_volume": 125000000,
      "beta": 1.2,
      "eps": 5.43,
      "sector": "Technology",
      "industry": "Consumer Electronics",
    },
    "TSLA": {
      "pe_ratio": 120.3,
      "dividend_yield": 0.0,
      "52w_high": 725.75,
      "52w_low": 590.23,
      "avg_volume": 85000000,
      "beta": 2.1,
      "eps": 5.99,
      "sector": "Automotive",
      "industry": "Electric Vehicles",
    },
    "GOOGL": {
      "pe_ratio": 25.8,
      "dividend_yield": 0.0,
      "52w_high": 2880.50,
      "52w_low": 2550.42,
      "avg_volume": 39000000,
      "beta": 1.1,
      "eps": 111.45,
      "sector": "Technology",
      "industry": "Internet Content & Information",
    },
    "AMZN": {
      "pe_ratio": 65.2,
      "dividend_yield": 0.0,
      "52w_high": 3520.30,
      "52w_low": 3150.80,
      "avg_volume": 54000000,
      "beta": 1.3,
      "eps": 53.85,
      "sector": "Consumer Cyclical",
      "industry": "Internet Retail",
    },
    "NVDA": {
      "pe_ratio": 72.6,
      "dividend_yield": 0.12,
      "52w_high": 485.50,
      "52w_low": 380.25,
      "avg_volume": 60000000,
      "beta": 1.75,
      "eps": 6.62,
      "sector": "Technology",
      "industry": "Semiconductors",
    },
  };

  // Get historical data for a specific stock
  static List<Map<String, dynamic>> getHistoricalData(String ticker) {
    return historicalPrices[ticker] ?? [];
  }

  // Get financial metrics for a specific stock
  static Map<String, dynamic> getFinancialMetrics(String ticker) {
    return financialMetrics[ticker] ?? {};
  }
}
