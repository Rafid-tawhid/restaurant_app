import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant_food_model.dart';

final foodItemsProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance.collection('foods').snapshots().map(
        (snapshot) => snapshot.docs
        .map((doc) => RestaurantFood.fromFirestore(doc))
        .toList(),
  );
});

class FoodItemListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodItemsStream = ref.watch(foodItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Food Items")),
      body: foodItemsStream.when(
        data: (foodItems) {
          if (foodItems.isEmpty) {
            return const Center(child: Text("No food items available."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final foodItem = foodItems[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: Image.network(
                        foodItem.image,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodItem.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            foodItem.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text("Price: \$${foodItem.price.toStringAsFixed(2)}"),
                          const SizedBox(height: 4),
                          Text("Preparation Time: ${foodItem.preparationTime} mins"),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text(
                                  foodItem.isAvailable ? "Available" : "Not Available",
                                  style: TextStyle(
                                    color: foodItem.isAvailable ? Colors.green : Colors.red,
                                  ),
                                ),
                                backgroundColor: foodItem.isAvailable
                                    ? Colors.green[50]
                                    : Colors.red[50],
                              ),
                              Text(
                                foodItem.categoryName,
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
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
