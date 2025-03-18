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
  final String? foodId; // This will be used for editing

  AddFoodScreen({required this.category, this.foodId});

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
    if (widget.foodId != null) {
      _fetchFoodData();
    }
  }

  void _fetchFoodData() {
    ref.read(foodProvider(widget.foodId!).future).then((data) {
      if (data != null) {
        setState(() {
          nameController.text = data["name"] ?? "";
          descriptionController.text = data["description"] ?? "";
          priceController.text = data["price"].toString();
          preparationTimeController.text = data["preparationTime"].toString();
          isAvailable = data["isAvailable"] ?? true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodData = widget.foodId != null ? ref.watch(foodProvider(widget.foodId!)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food Item"),
        actions: [
          if (widget.foodId != null) // Show edit button only if editing
            IconButton(
              onPressed: () => _fetchFoodData(),
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: foodData?.when(
        data: (data) => _buildForm(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading food item")),
      ) ?? _buildForm(),
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

