
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../service_class/menu_category_service.dart';

// Firebase Service Provider
final menuCategoryServiceProvider = Provider<MenuCategoryService>((ref) {
  return MenuCategoryService();
});

// Function to save menu categories
final saveCategoriesProvider = Provider.autoDispose((ref) {
  final service = ref.read(menuCategoryServiceProvider);

  Future<void> saveCategories() async {
    List<MenuCategory> categories = [
      MenuCategory(
        id: '',
        name: 'Appetizers',
        description: 'Start your meal with delicious appetizers.',
        image: 'https://via.placeholder.com/150',
        time: 10,
      ),
      MenuCategory(
        id: '',
        name: 'Main Course',
        description: 'Satisfying meals for lunch and dinner.',
        image: 'https://via.placeholder.com/150',
        time: 30,
      ),
      MenuCategory(
        id: '',
        name: 'Desserts',
        description: 'Sweet treats to end your meal.',
        image: 'https://via.placeholder.com/150',
        time: 15,
      ),
      MenuCategory(
        id: '',
        name: 'Beverages',
        description: 'Refreshing drinks for every occasion.',
        image: 'https://via.placeholder.com/150',
        time: 5,
      ),
    ];

    for (var category in categories) {
      await service.addMenuCategory(category);
    }
  }

  return saveCategories;
});
