import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/candidates_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/job_listings_screen.dart';
import 'package:flutter_application_1/screens/createPostScreen.dart';
import 'package:flutter_application_1/screens/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  UserData userData = UserData(prefs: prefs);
  await userData.loadDataFromSharedPreferences();
  runApp(MyApp(userData: userData));
}

class MyApp extends StatelessWidget {
  final UserData userData;

  const MyApp({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Job Portal',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner

      home: BottomNavScreen(userData: userData),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  final UserData userData;

  const BottomNavScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Candidates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Job List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Post Jobs',
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
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  List<Widget> get _widgetOptions {
    return [
      HomeScreen(userData: widget.userData),
      CandidatesScreen(userData: widget.userData),
      JobListingsScreen(
        jobListings: widget.userData.jobListings,
        userData: widget.userData,
      ),
      CreatePostScreen(userData: widget.userData),
    ];
  }
}
