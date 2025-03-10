import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(LucideIcons.utensils, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Foodies Hub",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.shoppingCart, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(LucideIcons.bell, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, Food Lover! 🍽️",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "What would you like to eat today?",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),

            /// 🔹 Categories Section
            Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildCategoryItem(LucideIcons.pizza, "Pizza"),
                _buildCategoryItem(LucideIcons.cake, "Burger"),
                _buildCategoryItem(LucideIcons.fish, "Seafood"),
                _buildCategoryItem(LucideIcons.coffee, "Coffee"),
                _buildCategoryItem(LucideIcons.coffee, "Dessert"),
                _buildCategoryItem(LucideIcons.wine, "Drinks"),
                _buildCategoryItem(LucideIcons.cake, "Bakery"),
                _buildCategoryItem(LucideIcons.salad, "Salads"),
              ],
            ),
            SizedBox(height: 20),

            /// 🔹 Popular Items Section
            const Text(
              "Popular Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPopularItem(LucideIcons.pizza, "Pepperoni Pizza", "\$12.99"),
                  _buildPopularItem(LucideIcons.cake, "Cheese Burger", "\$9.99"),
                  _buildPopularItem(LucideIcons.coffee, "Chocolate Sundae", "\$5.99"),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔹 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.airplay), label: "Home"),
          BottomNavigationBarItem(icon: Icon(LucideIcons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(LucideIcons.heart), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
        ],
      ),
    );
  }

  /// 🔹 Category Item Widget
  Widget _buildCategoryItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withOpacity(0.1),
          ),
          child: Icon(icon, size: 28, color: Colors.redAccent),
        ),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  /// 🔹 Popular Item Widget
  Widget _buildPopularItem(IconData icon, String title, String price) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.redAccent),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(price, style: TextStyle(fontSize: 14, color: Colors.redAccent)),
        ],
      ),
    );
  }
}
