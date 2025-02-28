import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Building {
  final String name;
  final String symbol;
  final IconData icon;
  final String? animation;

  Building({
    required this.name,
    required this.symbol,
    required this.icon,
    this.animation,
  });

  factory Building.fromFirestore(Map<String, dynamic> data) {
    return Building(
      name: data['name'] ?? '',
      symbol: data['symbol'] ?? '',
      icon: IconData(data['icon'] ?? 0, fontFamily: 'MaterialIcons'),
      animation: data['animation'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'symbol': symbol,
      'icon': icon.codePoint,
      'animation': animation,
    };
  }
}

class Base {
  final String userId;
  final String name;
  final List<Building> buildings;
  List<String?> grid;
  Map<String, dynamic> portfolio;

  Base({
    required this.userId,
    required this.name,
    required this.buildings,
    this.portfolio = const {},
    int gridSize = 25,
  }) : grid = List.generate(gridSize, (index) => null);

  /// Factory to create Base from Firestore DocumentSnapshot
  factory Base.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Base(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      buildings: (data['buildings'] as List<dynamic>? ?? [])
          .map((building) =>
              Building.fromFirestore(building as Map<String, dynamic>))
          .toList(),
      portfolio: data['portfolio'] ?? {},
      gridSize: (data['grid'] as List<dynamic>? ?? []).length,
    )..grid = (data['grid'] as List<dynamic>? ?? [])
        .map((item) => item as String?)
        .toList();
  }

  /// Converts Base to Firestore-compatible Map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'buildings': buildings.map((building) => building.toFirestore()).toList(),
      'portfolio': portfolio,
      'grid': grid,
    };
  }
}
