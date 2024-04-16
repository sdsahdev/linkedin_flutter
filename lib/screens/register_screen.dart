import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/bottom_nav_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  File? _imageFile;

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _register(BuildContext context) async {
    // Validate fields
    print(_nameController.text.trim());
    print(_emailController.text.trim());
    print(_passwordController.text.trim());
    print(_positionController.text.trim());
    print(_dobController.text.trim());
    print(_educationController.text.trim());
    print(_mobileController.text.trim());
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _positionController.text.trim().isEmpty ||
        _dobController.text.trim().isEmpty ||
        _educationController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('All fields are mandatory.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate email length
    if (_emailController.text.trim().length < 6) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Email must be at least 6 characters.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Plase Selecte Profile Pic.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate password length
    if (_passwordController.text.trim().length < 6) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Password must be at least 6 characters.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate mobile number length
    if (_mobileController.text.trim().length < 10) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Mobile number must be at least 10 characters.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    if (_mobileController.text.trim().length < 10) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Mobile number must be at least 10 characters.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    // All fields are valid, proceed with registration
    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the newly created user
      User? user = userCredential.user;

      // Upload profile image to Firebase Storage if image selected
      String profileImageUrl = '';
      if (_imageFile != null) {
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profilePics')
            .child('${user!.uid}.jpg');

        await storageRef.putFile(_imageFile!);

        profileImageUrl = await storageRef.getDownloadURL();
      }

      // Save additional user details to Firebase Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('candidates')
          .child(user!.uid);

      // Save user details to the database
      await userRef.set({
        'name': _nameController.text.trim(),
        'position': _positionController.text.trim(),
        'profileImage': profileImageUrl,
        'dob': _dobController.text.trim(),
        'education': _educationController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'email': user.email,
        'posts': [], // Empty array for posts
        'isConnected': [], // Empty array for connected users
      });

      // Navigate to the BottomNavScreen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavScreen(user: user),
        ),
      );
    } catch (e) {
      print('Error registering user: $e');
      setState(() {
        _isLoading = false;
      });
      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error'),
            content: Text('Failed to register user. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(Icons.account_circle, size: 100)
                        : null,
                  ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  TextField(
                    controller: _positionController,
                    decoration: InputDecoration(
                      labelText: 'Position',
                    ),
                  ),
                  TextField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth (YYYY-MM-DD)',
                    ),
                  ),
                  TextField(
                    controller: _educationController,
                    decoration: InputDecoration(
                      labelText: 'Education',
                    ),
                  ),
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Register'),
                    onPressed: () {
                      _register(context);
                    },
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Already registered? Login'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
