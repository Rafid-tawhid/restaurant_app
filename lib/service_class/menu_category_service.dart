import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class MenuCategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _categoryRef => _firestore.collection('menuCategories');

  // Add Category
  Future<void> addMenuCategory(MenuCategory category) async {
    try {
      DocumentReference docRef = _categoryRef.doc(); // Auto-generate ID
      category.id = docRef.id;

      await docRef.set(category.toJson());
    } catch (e) {
      throw Exception("Error adding category: $e");
    }
  }
}