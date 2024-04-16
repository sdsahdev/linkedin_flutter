import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authentication_wrapper.dart';
import 'package:flutter_application_1/screens/candidates_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/job_listings_screen.dart';
import 'package:flutter_application_1/screens/createPostScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  // await userData.loadDataFromFirebase(); // Load data from Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Job Portal',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: WillPopScope(
        // Wrap your home widget with WillPopScope
        onWillPop: () async {
          // Handle back button press manually
          return _onBackPressed(context);
        },
        child: SplashScreen(),
      ),
    );
  }

  // Define a function to handle back button press
  Future<bool> _onBackPressed(BuildContext context) {
    // Check if the current route is the first route (i.e., splash screen)
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return Future.value(false); // Prevent app from exiting
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        ),
      ).then((value) => value ?? false);
    }
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate the splash screen
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the AuthenticationWrapper after the delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x0F0F1F),
      body: Center(
        child: Image.asset('assets/images/exodus.gif'), // Your GIF path
      ),
    );
  }
}
