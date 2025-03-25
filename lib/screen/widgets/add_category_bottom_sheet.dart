import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final imagePickerProvider = Provider((ref) => ImagePicker());


class AddCategoryBottomSheet extends ConsumerStatefulWidget {
  @override
  _AddCategoryBottomSheetState createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends ConsumerState<AddCategoryBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ref.read(imagePickerProvider);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveCategory() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required!")));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
   //   Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Reference storageRef = FirebaseStorage.instance.ref().child('category_images/$fileName.jpg');
      CollectionReference categoriesRef = firestore.collection('menu_categories');
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Save category data in Firestore
      await FirebaseFirestore.instance.collection('menu_categories').add({
        'id':categoriesRef.doc().id,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'image': imageUrl,
        'time': 15, // Default preparation time
      }).then((v){
        debugPrint('SAVED $v');
      });

      Navigator.pop(context); // Close the bottom sheet
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Category Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            _selectedImage == null
                ? const Text("No Image Selected", style: TextStyle(color: Colors.grey))
                : Image.file(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Image"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _saveCategory,
                  icon: _isUploading ? CircularProgressIndicator() : Icon(Icons.save),
                  label: Text(_isUploading ? "Saving..." : "Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
