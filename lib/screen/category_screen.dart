import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu/screen/widgets/add_category_bottom_sheet.dart';
import 'package:menu/screen/widgets/category_card.dart';
import '../models/category_model.dart';
import '../river_pod_class/menu_category_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  List<MenuCategory> menuCategories = [
    MenuCategory(id: 'appetizers', name: 'Appetizers', description: 'Tasty starters to begin your meal.', image: 'https://via.placeholder.com/150', time: 10),
    MenuCategory(id: 'soups', name: 'Soups', description: 'Hot and delicious soups.', image: 'https://via.placeholder.com/150', time: 15),
    MenuCategory(id: 'salads', name: 'Salads', description: 'Fresh and healthy salads.', image: 'https://via.placeholder.com/150', time: 12),
    MenuCategory(id: 'pasta', name: 'Pasta', description: 'Authentic Italian pasta dishes.', image: 'https://via.placeholder.com/150', time: 20),
    MenuCategory(id: 'pizza', name: 'Pizza', description: 'Handmade pizzas with fresh toppings.', image: 'https://via.placeholder.com/150', time: 25),
    MenuCategory(id: 'burgers', name: 'Burgers', description: 'Juicy and delicious burgers.', image: 'https://via.placeholder.com/150', time: 18),
    MenuCategory(id: 'sandwiches', name: 'Sandwiches', description: 'Freshly made sandwiches.', image: 'https://via.placeholder.com/150', time: 10),
    MenuCategory(id: 'grilled_items', name: 'Grilled Items', description: 'Smoky grilled meats and veggies.', image: 'https://via.placeholder.com/150', time: 22),
    MenuCategory(id: 'seafood', name: 'Seafood', description: 'Freshly caught seafood dishes.', image: 'https://via.placeholder.com/150', time: 30),
    MenuCategory(id: 'desserts', name: 'Desserts', description: 'Sweet and delicious desserts.', image: 'https://via.placeholder.com/150', time: 15),
    MenuCategory(id: 'beverages', name: 'Beverages', description: 'Refreshing drinks and juices.', image: 'https://via.placeholder.com/150', time: 5),
    MenuCategory(id: 'steaks', name: 'Steaks', description: 'Premium cuts of steak.', image: 'https://via.placeholder.com/150', time: 35),
    MenuCategory(id: 'vegan', name: 'Vegan', description: 'Plant-based meals.', image: 'https://via.placeholder.com/150', time: 20),
    MenuCategory(id: 'breakfast', name: 'Breakfast', description: 'Healthy breakfast options.', image: 'https://via.placeholder.com/150', time: 10),
    MenuCategory(id: 'sushi', name: 'Sushi', description: 'Fresh sushi rolls.', image: 'https://via.placeholder.com/150', time: 25),
    MenuCategory(id: 'noodles', name: 'Noodles', description: 'Asian-style noodle dishes.', image: 'https://via.placeholder.com/150', time: 15),
    MenuCategory(id: 'bbq', name: 'BBQ', description: 'Smoky barbecue dishes.', image: 'https://via.placeholder.com/150', time: 30),
    MenuCategory(id: 'mexican', name: 'Mexican', description: 'Tacos, burritos, and more.', image: 'https://via.placeholder.com/150', time: 20),
    MenuCategory(id: 'indian', name: 'Indian', description: 'Traditional Indian curries and spices.', image: 'https://via.placeholder.com/150', time: 25),
    MenuCategory(id: 'thai', name: 'Thai', description: 'Spicy and flavorful Thai dishes.', image: 'https://via.placeholder.com/150', time: 20),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(getCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Categories'),
        backgroundColor: Colors.teal,
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No Categories Found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(category: category);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await uploadMenuCategories(menuCategories);
          print("Upload completed!");
          // showModalBottomSheet(
          //   context: context,
          //   isScrollControlled: true,
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          //   ),
          //   builder: (context) => AddCategoryBottomSheet(),
          // );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }


  Future<void> uploadMenuCategories(List<MenuCategory> menuCategories) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference categoriesRef = firestore.collection('menu_categories');

    for (var category in menuCategories) {
      String docId = categoriesRef.doc().id; // Generate a unique Firestore document ID
      category.id = docId; // Set the document ID as the category ID

      await categoriesRef.doc(docId).set(category.toJson());
    }

    print("All menu categories uploaded successfully!");
  }

}
