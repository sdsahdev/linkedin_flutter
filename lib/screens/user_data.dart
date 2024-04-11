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

  Future<void> saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    String candidatesJson = jsonEncode(candidates);
    await prefs.setString('candidates', candidatesJson);

    String jobListingsJson = jsonEncode(jobListings);
    await prefs.setString('jobListings', jobListingsJson);
  }

  Future<void> loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    String? candidatesJson = prefs.getString('candidates');
    if (candidatesJson != null && candidatesJson.isNotEmpty) {
      candidates = List<Map<String, dynamic>>.from(jsonDecode(candidatesJson));
    } else {
      candidates = candidates;
    }

    String? jobListingsJson = prefs.getString('jobListings');
    if (jobListingsJson != null && jobListingsJson.isNotEmpty) {
      jobListings =
          List<Map<String, dynamic>>.from(jsonDecode(jobListingsJson));
    } else {
      jobListings = jobListings;
    }
  }

  void connectDisconnectUser(int index) {
    candidates[index]['isConnected'] = !candidates[index]['isConnected'];
    saveDataToSharedPreferences();
  }

  bool applyJobsUser(int index) {
    bool isApplied = jobListings[index]['applyed'];
    if (isApplied) {
      jobListings[index]['applyed'] = false;
    } else {
      jobListings[index]['applyed'] = true;
    }

    saveDataToSharedPreferences();

    return !isApplied;
  }
}
