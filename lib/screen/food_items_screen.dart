import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_food_model.dart';
import '../river_pod_class/menu_category_provider.dart';

final foodItemsProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance.collection('foods').snapshots().map(
        (snapshot) => snapshot.docs
        .map((doc) => RestaurantFood.fromFirestore(doc))
        .toList(),
  );
});


class FoodItemListScreen extends ConsumerWidget {
  const FoodItemListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodItemsStream = ref.watch(foodItemsProvider);
    final categoriesAsync = ref.read(getCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Food Items"),actions: [
        IconButton(
          onPressed: () {
            categoriesAsync.when(
              data: (categories) {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(50, 100, 0, 0),
                  items: categories.map((category) {
                    return PopupMenuItem(
                      value: category.id, // Assuming `id` is a field in your category model
                      child: Text(category.name),
                      onTap: (){

                      },// Assuming `name` is a field in your category model
                    );
                  }).toList(),
                ).then((selectedValue) {
                  if (selectedValue != null) {
                    // Handle filter logic here
                    print('Selected filter: $selectedValue');
                  }
                });
              },
              loading: () {
                // Show a loading dialog or snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Loading categories...")),
                );
              },
              error: (error, stackTrace) {
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $error")),
                );
              },
            );
          },
          icon: const Icon(Icons.filter_list),
        ),

      ],),
      body: foodItemsStream.when(
        data: (foodItems) {
          if (foodItems.isEmpty) {
            return const Center(child: Text("No food items available."));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75, // Adjust height relative to width
            ),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final foodItem = foodItems[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [

                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          child: Image.network(
                            foodItem.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child:Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(12),bottomLeft:Radius.circular(12) ),
                              color: foodItem.isAvailable
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            child: Text(
                              foodItem.isAvailable ? "Available" : "Not Available",
                              style: TextStyle(
                                color: foodItem.isAvailable ? Colors.white : Colors.white,
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodItem.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   foodItem.description,
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: const TextStyle(fontSize: 12),
                          // ),
                          const SizedBox(height: 4),
                          Text(
                            "Price: \$${foodItem.price.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Prep Time: ${foodItem.preparationTime} mins",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),

                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
