import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import 'register_screen.dart';
import 'bottom_nav_screen.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      // User is logged in
      return BottomNavScreen(user: user);
    } else {
      // User is not logged in
      return LoginScreen(); // Navigate to the login screen if not logged in
    }
  }
}
