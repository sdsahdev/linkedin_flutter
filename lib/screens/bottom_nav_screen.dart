import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/createPostScreen.dart';

import 'home_screen.dart';
import 'candidates_screen.dart';
import 'job_listings_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final User user;

  const BottomNavScreen({Key? key, required this.user}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  late DateTime _lastPressedTime;

  @override
  void initState() {
    super.initState();
    _lastPressedTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
            now.difference(_lastPressedTime) > Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
          _lastPressedTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
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
              icon: Icon(Icons.person),
              label: 'Post Jobs',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  List<Widget> get _widgetOptions {
    return [
      HomeScreen(),
      CandidatesScreen(),
      JobListingsScreen(),
      CreatePostScreen(),
    ];
  }
}
