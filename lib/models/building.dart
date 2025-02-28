import 'mock_data.dart'; // Ensure this imports the stock data with image mapping

class Building {
  final String name; // Name of the building
  final int level; // Level of the building

  Building({required this.name, required this.level});

  // Factory method to create a Building object from Firestore data
  factory Building.fromFirestore(Map<String, dynamic> data) {
    return Building(
      name: data['name'] ?? 'Unnamed Building',
      level: data['level'] ?? 1, // Default level is 1
    );
  }

  // Method to convert Building object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'level': level,
    };
  }

  // Fetch the correct image for this building based on stock level
  String get imagePath {
    return MockStockData.getStockImage(name, level) ??
        "assets/images/default_building.png";
  }

  // Optional: Upgrade method increases building level
  Building upgrade() {
    return Building(name: name, level: level + 1);
  }

  @override
  String toString() {
    return 'Building(name: $name, level: $level, imagePath: $imagePath)';
  }
}
