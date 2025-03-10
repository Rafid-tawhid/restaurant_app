import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryItemScreen extends StatefulWidget {
  @override
  _AddCategoryItemScreenState createState() => _AddCategoryItemScreenState();
}

class _AddCategoryItemScreenState extends State<AddCategoryItemScreen> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();

  String? categoryId;
  XFile? imageFile;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
    });
  }

  // Function to save Category to Firestore
  Future<void> _saveCategory() async {
    if (categoryController.text.isEmpty) return;

    try {
      DocumentReference categoryRef = await _firestore.collection('categories').add({
        'name': categoryController.text,
      });

      setState(() {
        categoryId = categoryRef.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category Added!")),
      );
    } catch (e) {
      print("Error saving category: $e");
    }
  }

  // Function to save Item to Firestore under a Category
  Future<void> _saveItem() async {
    if (categoryId == null ||
        itemNameController.text.isEmpty ||
        itemPriceController.text.isEmpty) return;

    try {
      String? imageUrl;
      if (imageFile != null) {
        // Upload image to Firebase Storage
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('item_images/${imageFile!.name}');
        await storageRef.putFile(imageFile!.path);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Add item under the category
      await _firestore.collection('categories').doc(categoryId).collection('items').add({
        'name': itemNameController.text,
        'description': itemDescController.text,
        'price': double.parse(itemPriceController.text),
        'imageUrl': imageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item Added!")),
      );
      itemNameController.clear();
      itemDescController.clear();
      itemPriceController.clear();
      setState(() {
        imageFile = null;
      });
    } catch (e) {
      print("Error saving item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category and Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            ElevatedButton(
              onPressed: _saveCategory,
              child: Text("Add Category"),
            ),
            if (categoryId != null) ...[
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: "Item Name"),
              ),
              TextField(
                controller: itemDescController,
                decoration: InputDecoration(labelText: "Item Description"),
              ),
              TextField(
                controller: itemPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Item Price"),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text(imageFile == null ? "Pick Image" : "Change Image"),
              ),
              if (imageFile != null) ...[
                Image.file(File(imageFile!.path)),
              ],
              ElevatedButton(
                onPressed: _saveItem,
                child: Text("Add Item to Category"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
