import 'package:cloud_firestore/cloud_firestore.dart';

class MenuCategory {
  String id;
  String name;
  String description;
  String image;
  int time; // in minutes

  MenuCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.time,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'time': time,
    };
  }

  // Create object from JSON
  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      time: json['time'],
    );
  }
}
