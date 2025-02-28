import 'package:flutter/material.dart';

class XPProgressBar extends StatelessWidget {
  final int xp;
  final int level;
  final int nextLevelXP;

  const XPProgressBar(
      {required this.xp, required this.level, required this.nextLevelXP});

  @override
  Widget build(BuildContext context) {
    double progress = xp / nextLevelXP;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Level $level',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        LinearProgressIndicator(value: progress, minHeight: 10),
        SizedBox(height: 5),
        Text('$xp / $nextLevelXP XP'),
      ],
    );
  }
}
