import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers_class/helper_function.dart';
import '../home/home_screen.dart';
import '../screen/category_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  void _submitAuthForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    setState(() => _isLoading = true);
    try {
      UserCredential authResult;
      if (_isLogin) {
        authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if(await HelperClass.isAdmin()){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddCategoryItemScreen()),
          );
        }
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }


      } else {
        authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if(authResult!=null){
          saveAdminData(_emailController.text.trim(),_passwordController.text.trim(),_username.text.trim());
        }
      }

      if (authResult.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred.";
      if (e.code == 'email-already-in-use') message = "Email is already in use.";
      if (e.code == 'weak-password') message = "Weak password, use at least 6 characters.";
      if (e.code == 'user-not-found') message = "No user found with this email.";
      if (e.code == 'wrong-password') message = "Incorrect password.";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? "Login" : "Sign Up",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if(!_isLogin)TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: "Username"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length<4) {
                      return "Enter a valid name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains("@")) {
                      return "Enter a valid email!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitAuthForm,
                  child: Text(_isLogin ? "Login" : "Sign Up"),
                ),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? "Create an account" : "Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> saveAdminData(String email, String password, String username) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference
    DocumentReference docRef = await firestore.collection("admin").add({
      "email": email,
      "password": password, // Ideally, store a **hashed** password
      "time": FieldValue.serverTimestamp(),
      "username": username,
    });

    // After document is created, update the document with its own id
    await docRef.update({
      "id": docRef.id,  // Reference to the document's own ID
    }).then((_) {
      print("Admin data saved with ID: ${docRef.id}");
    }).catchError((error) {
      print("Error saving admin data: $error");
    });
  }


}
