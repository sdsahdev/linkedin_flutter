import 'package:flutter/material.dart'; // Importing necessary packages
import 'package:flutter_application_1/screens/candidates_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/job_listings_screen.dart';
import 'package:flutter_application_1/screens/createPostScreen.dart';
import 'package:flutter_application_1/screens/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter bindings are initialized
  SharedPreferences prefs = await SharedPreferences
      .getInstance(); // Get an instance of SharedPreferences
  UserData userData =
      UserData(prefs: prefs); // Create a UserData object with SharedPreferences
  await userData
      .loadDataFromSharedPreferences(); // Load data from SharedPreferences
  runApp(MyApp(userData: userData)); // Run the app with the provided UserData
}

class MyApp extends StatelessWidget {
  final UserData userData; // UserData object to hold user data

  const MyApp({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Job Portal', // App title
      theme: ThemeData(
        primarySwatch: Colors.brown, // Theme color
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner

      home: BottomNavScreen(
          userData: userData), // Set BottomNavScreen as the home screen
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  final UserData userData; // UserData object to hold user data

  const BottomNavScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0; // Index of the selected bottom navigation bar item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), // Show selected widget
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Home navigation item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Candidates', // Candidates navigation item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Job List', // Job List navigation item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Post Jobs', // Post Jobs navigation item
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            Color.fromARGB(255, 0, 20, 37), // Change the color of selected item
        unselectedItemColor:
            Colors.grey, // Change the color of unselected items
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
    );
  }

  List<Widget> get _widgetOptions {
    // Define the widgets for each navigation item
    return [
      HomeScreen(userData: widget.userData), // Home screen widget
      CandidatesScreen(userData: widget.userData), // Candidates screen widget
      JobListingsScreen(
        jobListings: widget.userData.jobListings, // Job Listings screen widget
        userData: widget.userData,
      ),
      CreatePostScreen(userData: widget.userData), // Create Post screen widget
    ];
  }
}
