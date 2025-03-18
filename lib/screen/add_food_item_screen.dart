import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu/models/restaurant_food_model.dart';

import '../models/category_model.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../river_pod_class/menu_category_provider.dart';

class AddFoodScreen extends ConsumerStatefulWidget {
  final MenuCategory category;

  AddFoodScreen({required this.category});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController preparationTimeController = TextEditingController();

  bool isAvailable = true;
  File? selectedImage;

  @override
  void initState() {
    super.initState();

  }

  void _fetchFoodData() {
    ref.read(categoryProvider(widget.category.id).future).then((data) {
      if (data != null) {
        setState(() {
          nameController.text = data["name"] ?? "";
          descriptionController.text = data["description"] ?? "";
          priceController.text = data["price"].toString();
          preparationTimeController.text = data["time"].toString();
         // isAvailable = data["isAvailable"] ?? true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   // final foodData = widget.foodId != null ? ref.watch(foodProvider(widget.foodId!)) : null;
    final foodList = ref.watch(foodProvider(widget.category.id));
    return Scaffold(
      appBar: AppBar(title: const Text("Food List")),
      body: foodList.when(
        data: (foods) =>foods.isEmpty?const Center(child: Text('No Food Found'),): ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    food.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  food.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                subtitle: Text(
                  "\$${food.price}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                onTap: () {
                  // Add navigation or actions here
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Food Name"),
              validator: (value) => value!.isEmpty ? "Enter food name" : null,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
              validator: (value) => value!.isEmpty ? "Enter description" : null,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Enter price" : null,
            ),
            TextFormField(
              controller: preparationTimeController,
              decoration: const InputDecoration(labelText: "Preparation Time (min)"),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Enter preparation time" : null,
            ),
            SwitchListTile(
              title: const Text("Available"),
              value: isAvailable,
              onChanged: (value) => setState(() => isAvailable = value),
            ),
            ElevatedButton(
              onPressed: () {}, // Implement save logic
              child: const Text("Save Food Item"),
            ),
          ],
        ),
      ),
    );
  }
}

