import 'dart:io'; // Importing necessary package for handling files
import 'package:flutter/material.dart';
import 'user_data.dart'; // Importing UserData class
import 'candidate_detail_screen.dart'; // Importing CandidateDetailScreen class

class CandidatesScreen extends StatelessWidget {
  final UserData userData; // UserData object
  // final Function(List<String>) onUpdatePosts; // Function to update posts

  // Constructor to initialize CandidatesScreen
  const CandidatesScreen({
    Key? key,
    required this.userData,
    // required this.onUpdatePosts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates Screen'), // App bar title
      ),
      body: ListView.builder(
        itemCount: userData.candidates.length, // Number of candidates
        itemBuilder: (context, index) {
          final candidate =
              userData.candidates[index]; // Current candidate data
          return ListTile(
            leading: CircleAvatar(
              // Candidate profile image
              backgroundImage: AssetImage(candidate['profileImage']),
            ),
            title: Text(candidate['name']), // Candidate name
            subtitle: Text(candidate['position']), // Candidate position
            onTap: () {
              // Navigate to candidate detail screen on tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CandidateDetailScreen(
                    candidate: candidate, // Candidate data
                    userData: userData, // UserData object
                    // onUpdatePosts: onUpdatePosts,
                    index: index, // Index of the candidate
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
