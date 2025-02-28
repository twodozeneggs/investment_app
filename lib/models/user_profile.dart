class UserProfile {
  String id;
  int xp;
  int level;

  UserProfile({required this.id, required this.xp, required this.level});

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      id: data['id'] ?? '',
      xp: int.tryParse(data['xp'].toString()) ?? 0, // Parse XP to int
      level: int.tryParse(data['level'].toString()) ?? 1, // Parse level to int
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'xp': xp,
      'level': level,
    };
  }
}
