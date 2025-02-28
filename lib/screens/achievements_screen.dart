import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  final Map<String, bool> achievements;

  AchievementsScreen({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final achievementTitles = {
      'first_stock': '🎉 Welcome to Investing!',
      'portfolio_10k': '🚀 Investor Pro!',
      'single_stock_50_percent': '💡 Stock Guru!',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: ListView(
        children: achievements.entries.map((entry) {
          final key = entry.key;
          final unlocked = entry.value;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(achievementTitles[key]!),
              trailing: Icon(
                unlocked ? Icons.check_circle : Icons.lock,
                color: unlocked ? Colors.green : Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
