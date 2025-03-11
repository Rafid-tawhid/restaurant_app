import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../river_pod_class/menu_category_provider.dart';

class MenuCategoryScreen extends ConsumerWidget {
  const MenuCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Save Menu Categories')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final saveCategories = ref.read(saveCategoriesProvider);
            await saveCategories();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Categories saved to Firebase!')),
            );
          },
          child: const Text('Save Categories to Firebase'),
        ),
      ),
    );
  }
}

