import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  late SharedPreferences _prefs;

  UserData({required SharedPreferences prefs}) {
    _prefs = prefs;
  }

  List<Map<String, dynamic>> candidates = [
    {
      'name': 'lemona',
      'position': 'Software Engineer',
      'profileImage': 'assets/images/post1.jpeg',
      'age': 35,
      'dob': '2003-01-14',
      'education': 'BSC',
      'mobile': '+12333569999',
      'email': 'lemona.doe@example.com',
      'posts': [
        {
          'description': 'Nature',
          'post': 'assets/images/nature1.jpeg',
        },
      ],
      'isConnected': true,
    },
    {
      'name': 'John Doe',
      'position': 'Software Engineer',
      'profileImage': 'assets/images/post2.jpeg',
      'age': 30,
      'dob': '1994-01-01',
      'education': 'Bachelor\'s in Computer Science',
      'mobile': '+1234567890',
      'email': 'john.doe@example.com',
      'posts': [
        {
          'description': 'butterfly',
          'post': 'assets/images/nature2.jpeg',
        },
        {
          'description': 'mountain blue',
          'post': 'assets/images/nature3.jpg',
        },
      ],
      'isConnected': false,
    },
    {
      'name': 'Lee Coener',
      'position': 'Software Engineer',
      'profileImage': 'assets/images/post3.jpeg',
      'age': 25,
      'dob': '1994-01-14',
      'education': 'B come',
      'mobile': '+1234569999',
      'email': 'lee.doe@example.com',
      'posts': [
        {
          'description': 'yellow butterfly',
          'post': 'assets/images/nature4.jpg',
        },
      ],
      'isConnected': false,
    },
  ];
  List<Map<String, dynamic>> jobListings = [
    {
      'company': 'Volkswagen',
      'position': 'Software Engineer',
      'companyLogo': 'assets/images/job1.jpeg',
      'location': 'New York',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'applyed': false,
    },
    {
      'company': 'Google',
      'position': 'Web Developer',
      'companyLogo': 'assets/images/job2.jpeg',
      'location': 'San Francisco',
      'description':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'applyed': false,
    },
  ];

  // Method to save candidate and job listing data to SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance

    // Convert candidates list to JSON and save to SharedPreferences
    String candidatesJson = jsonEncode(candidates);
    await prefs.setString('candidates', candidatesJson);

    // Convert jobListings list to JSON and save to SharedPreferences
    String jobListingsJson = jsonEncode(jobListings);
    await prefs.setString('jobListings', jobListingsJson);
  }

  // Method to load candidate and job listing data from SharedPreferences
  Future<void> loadDataFromSharedPreferences() async {
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance

    // Load candidates JSON from SharedPreferences and decode
    String? candidatesJson = prefs.getString('candidates');
    if (candidatesJson != null && candidatesJson.isNotEmpty) {
      candidates = List<Map<String, dynamic>>.from(jsonDecode(candidatesJson));
    } else {
      // If no data found in SharedPreferences, use default candidates list
      candidates = candidates;
    }

    // Load jobListings JSON from SharedPreferences and decode
    String? jobListingsJson = prefs.getString('jobListings');
    if (jobListingsJson != null && jobListingsJson.isNotEmpty) {
      jobListings =
          List<Map<String, dynamic>>.from(jsonDecode(jobListingsJson));
    } else {
      // If no data found in SharedPreferences, use default jobListings list
      jobListings = jobListings;
    }
  }

  // Method to connect/disconnect a user at a specific index
  void connectDisconnectUser(int index) {
    // Toggle the 'isConnected' status of the candidate at the given index
    candidates[index]['isConnected'] = !candidates[index]['isConnected'];
    // Save the updated data to SharedPreferences
    saveDataToSharedPreferences();
  }

  // Method to apply/unapply for a job listing at a specific index
  bool applyJobsUser(int index) {
    // Get the current application status
    bool isApplied = jobListings[index]['applyed'];
    // Toggle the application status
    jobListings[index]['applyed'] = !isApplied;
    // Save the updated data to SharedPreferences
    saveDataToSharedPreferences();
    // Return the new application status
    return !isApplied;
  }
}
