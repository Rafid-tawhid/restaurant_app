
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu/models/restaurant_food_model.dart';
import '../models/category_model.dart';
import '../service_class/menu_category_service.dart';

// Firestore Service Provider
final menuCategoryServiceProvider = Provider((ref) => FirebaseFirestore.instance);

// Fetch categories from Firestore
final getCategoriesProvider = FutureProvider<List<MenuCategory>>((ref) async {
  final firestore = ref.read(menuCategoryServiceProvider);
  final snapshot = await firestore.collection('menu_categories').get();

  return snapshot.docs
      .map((doc) => MenuCategory.fromJson(doc.data()))
      .toList();
});

final categoryProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, foodId) async {
  final doc = await FirebaseFirestore.instance.collection('menu_categories').doc(foodId).get();
  return doc.exists ? doc.data() : null;
});


final foodProvider = FutureProvider.family<List<RestaurantFood>, String>((ref, categoryId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('foods')
      .where('categoryId', isEqualTo: categoryId)
      .get();

  return snapshot.docs.map((doc) => RestaurantFood.fromJson(doc.data())).toList();
});