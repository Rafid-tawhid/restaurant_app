
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

// Firestore instance
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// StateProvider to store the selected document ID
final documentIdProvider = StateProvider<String?>((ref) => null);

// FutureProvider to fetch document from Firestore by ID
final documentProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  final docId = ref.watch(documentIdProvider); // Get the document ID from state

  if (docId == null || docId.isEmpty) {
    return null; // Return null if no document ID is provided
  }

  try {
    final docSnapshot = await firestore.collection('your_collection').doc(docId).get();

    if (docSnapshot.exists) {
      return docSnapshot.data(); // Return document data
    } else {
      return null; // Document does not exist
    }
  } catch (e) {
    throw Exception('Error fetching document: $e');
  }
});
