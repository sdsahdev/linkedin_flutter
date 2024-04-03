import 'dart:io';
import 'package:flutter/material.dart';
import 'user_data.dart';
import 'candidate_detail_screen.dart';

class CandidatesScreen extends StatelessWidget {
  final UserData userData;
  final Function(List<String>) onUpdatePosts;

  const CandidatesScreen(
      {super.key, required this.userData, required this.onUpdatePosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates Screen'),
      ),
      body: ListView.builder(
        itemCount: userData.candidates.length,
        itemBuilder: (context, index) {
          final candidate = userData.candidates[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(candidate['profileImage']),
            ),
            title: Text(candidate['name']),
            subtitle: Text(candidate['position']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CandidateDetailScreen(
                    candidate: candidate,
                    userData: userData,
                    onUpdatePosts: onUpdatePosts,
                    index: index,
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
