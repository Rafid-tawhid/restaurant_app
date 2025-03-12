import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final foodItemsProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance.collection('foods').snapshots();
});

class FoodItemListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodItemsStream = ref.watch(foodItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Food Items")),
      body: foodItemsStream.when(
        data: (snapshot) {
          final foodItems = snapshot.docs;
          if (foodItems.isEmpty) {
            return const Center(child: Text("No food items available."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final foodItem = foodItems[index].data();

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
                        foodItem['image'] ?? 'https://via.placeholder.com/150',
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
                            foodItem['name'] ?? "Unnamed",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            foodItem['description'] ?? "No description",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text("Price: \$${foodItem['price']?.toStringAsFixed(2) ?? "N/A"}"),
                          const SizedBox(height: 4),
                          Text("Preparation Time: ${foodItem['preparationTime'] ?? "N/A"} mins"),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text(
                                  foodItem['isAvailable'] == true ? "Available" : "Not Available",
                                  style: TextStyle(
                                    color: foodItem['isAvailable'] == true ? Colors.green : Colors.red,
                                  ),
                                ),
                                backgroundColor: foodItem['isAvailable'] == true
                                    ? Colors.green[50]
                                    : Colors.red[50],
                              ),
                              Text(
                                foodItem['categoryName'] ?? "Unknown Category",
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
