import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantFood {
  String id;
  String name;
  String description;
  String image;
  double price;
  String categoryId; // Reference to MenuCategory
  String categoryName; // Category Name
  int preparationTime; // in minutes
  bool isAvailable; // Food availability status

  RestaurantFood({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.preparationTime,
    required this.isAvailable,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'preparationTime': preparationTime,
      'isAvailable': isAvailable,
    };
  }

  // Create object from JSON
  factory RestaurantFood.fromJson(Map<String, dynamic> json) {
    return RestaurantFood(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      preparationTime: json['preparationTime'],
      isAvailable: json['isAvailable'],
    );
  }

  factory RestaurantFood.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RestaurantFood(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? 'https://via.placeholder.com/150',
      price: (data['price'] ?? 0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      preparationTime: data['preparationTime'] ?? 0,
      isAvailable: data['isAvailable'] ?? false,
    );
  }
}
