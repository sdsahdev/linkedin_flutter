import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/screens/candidate_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CandidatesScreen extends StatefulWidget {
  @override
  _CandidatesScreenState createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  final DatabaseReference _candidatesRef =
      FirebaseDatabase.instance.reference().child('candidates');

  List<Map<String, dynamic>> candidates = []; // List to store candidates data
  bool isLoading = true; // Indicator for loading state

  @override
  void initState() {
    super.initState();
    fetchCandidates(); // Call function to fetch candidates data
  }

  void fetchCandidates() async {
    try {
      print('Fetching candidates...');
      DatabaseEvent event =
          await _candidatesRef.once(); // Fetch candidates data
      print('Candidates fetched successfully.');

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        // Convert the snapshot value to a List<Map<String, dynamic>> by iterating over the entries
        List<Map<String, dynamic>> candidateDataList = [];
        (snapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            // Exclude the current user's data
            if (key != FirebaseAuth.instance.currentUser?.uid) {
              // Add each candidate map to the list
              candidateDataList
                  .add({...value, 'id': key}); // Include the candidate ID
            }
          }
        });

        print(
            'Snapshot value is not null and is of type Map<dynamic, dynamic>.');
        print('Converted candidate data: $candidateDataList');

        setState(() {
          candidates = candidateDataList; // Update the candidates list
          isLoading = false; // Set loading indicator to false
        });
      } else {
        print('No candidates available or data format is incorrect.');
      }
    } catch (error) {
      print('Error fetching candidates: $error');
      // Handle error or show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidates Screen'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : candidates.isEmpty
              ? Center(
                  child: Text(
                      'No candidates available')) // Show message if no candidates available
              : ListView.builder(
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = candidates[index];
                    final String name = candidate['name'] as String? ?? '';
                    final String position =
                        candidate['position'] as String? ?? '';
                    return ListTile(
                      leading: CircleAvatar(
                        // Use a fallback image if profileImage is null
                        backgroundImage: NetworkImage(
                          candidate['profileImage'] as String? ??
                              'assets/images/default_profile_image.png',
                        ),
                      ),
                      title: Text(name),
                      subtitle: Text(position),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CandidateDetailScreen(
                              candidate: candidate,
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
