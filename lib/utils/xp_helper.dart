import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

Future<void> addXP(UserProfile user, int earnedXP) async {
  int newXP = user.xp + earnedXP;
  int newLevel = calculateLevel(newXP);
  user.xp = newXP;
  user.level = newLevel;

  // Update Firebase
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .update(user.toFirestore());
}

int calculateLevel(int totalXP) {
  List<int> thresholds = [0, 100, 300, 600, 1000, 1500];
  int level = 1;
  for (int i = 0; i < thresholds.length; i++) {
    if (totalXP >= thresholds[i]) {
      level = i + 1;
    }
  }
  return level;
}

int calculateNextLevelXP(int level) {
  List<int> thresholds = [0, 100, 300, 600, 1000, 1500];
  if (level < thresholds.length) {
    return thresholds[level];
  }
  return thresholds.last; // Default for max level
}
