
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../service_class/menu_category_service.dart';

// Firestore Service Provider
final menuCategoryServiceProvider = Provider((ref) => FirebaseFirestore.instance);

// Fetch categories from Firestore
final getCategoriesProvider = FutureProvider<List<MenuCategory>>((ref) async {
  final firestore = ref.read(menuCategoryServiceProvider);
  final snapshot = await firestore.collection('menuCategories').get();

  return snapshot.docs
      .map((doc) => MenuCategory.fromJson(doc.data()))
      .toList();
});
//