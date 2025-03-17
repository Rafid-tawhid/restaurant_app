
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
//


// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Function to get a document by its ID
final documentProvider = FutureProvider.family<DocumentSnapshot?, String>((ref, docId) async {
  final firestore = ref.watch(firestoreProvider);
  try {
    final doc = await firestore.collection('menu_categories').doc(docId).get();
    debugPrint('documentState doc${doc.data()}');
    return doc.exists ? doc : null;
  } catch (e) {
    throw Exception("Error fetching document: $e");
  }
});

