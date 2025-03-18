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

class AddFoodScreen extends StatefulWidget {
  final MenuCategory category;

  AddFoodScreen({required this.category});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController preparationTimeController = TextEditingController();

  bool isAvailable = true;
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('food_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> saveFoodItem() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields and select a category!")),
      );
      return;
    }
    String imageUrl = "https://via.placeholder.com/150";
    if (selectedImage != null) {
      String? uploadedImageUrl = await uploadImage(selectedImage!);
      if (uploadedImageUrl != null) {
        imageUrl = uploadedImageUrl;
      }
    }

    String docId = FirebaseFirestore.instance.collection('foods').doc().id;

    Map<String, dynamic> foodData = {
      "id": docId,
      "name": nameController.text,
      "description": descriptionController.text,
      "image": imageUrl,
      "price": double.parse(priceController.text),
      "categoryId": widget.category.id,
      "categoryName": widget.category.name,
      "preparationTime": int.parse(preparationTimeController.text),
      "isAvailable": isAvailable,
    };

    await FirebaseFirestore.instance
        .collection('foods')
        .doc(docId)
        .set(foodData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Food item added successfully!")),
    );

    // Clear fields after saving
    setState(() {
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      preparationTimeController.clear();
      selectedImage = null;
      isAvailable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food Item"),
        actions: [
          IconButton(
              onPressed: () async {

              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Add a food item in ${widget.category.name} category',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Food Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter food name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: selectedImage != null
                        ? Image.file(selectedImage!, fit: BoxFit.cover)
                        : const Center(child: Text("Tap to pick an image")),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter price" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: preparationTimeController,
                  decoration: const InputDecoration(
                      labelText: "Preparation Time (min)"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter preparation time" : null,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text("Available"),
                  value: isAvailable,
                  onChanged: (value) {
                    setState(() {
                      isAvailable = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: saveFoodItem,
                    child: const Text("Save Food Item"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
