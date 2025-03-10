import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelperClass {


  static Future<bool> isAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // No user is logged in
      return false;
    }

    try {
      // Check if the logged-in user's email exists in the admin collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: user.email) // Match the user's email
          .get();

      // If the snapshot is not empty, the user is an admin
      if (snapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

}