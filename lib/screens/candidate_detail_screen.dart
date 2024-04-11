import 'dart:io'; // Importing necessary package for handling files
import 'package:flutter/material.dart';
import 'user_data.dart'; // Importing UserData class

class CandidateDetailScreen extends StatelessWidget {
  final Map<String, dynamic> candidate; // Candidate data
  final UserData userData; // UserData object
  final int index; // Index of the candidate

  const CandidateDetailScreen({
    Key? key,
    required this.candidate,
    required this.userData,
    required this.index,
  }) : super(key: key);

  // Method to build image widget based on image path
  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // If image is from assets
      return Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.contain,
        height: 200,
      );
    } else {
      // If image is from file system
      return Image.file(
        File(imagePath),
        width: double.infinity,
        fit: BoxFit.contain,
        height: 200,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isConnected = candidate['isConnected']; // Connection status

    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Detail Screen'), // App bar title
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display candidate profile image
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(candidate['profileImage']),
                radius: 50,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display candidate information
                  Text(
                    candidate['name'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    candidate['position'],
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Text('Age: ${candidate['age']}'),
                  Text('Date of Birth: ${candidate['dob']}'),
                  Text('Education: ${candidate['education']}'),
                  Text('Mobile: ${candidate['mobile']}'),
                  Text('Email: ${candidate['email']}'),
                  const SizedBox(height: 20),
                  const Text(
                    'Posts:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    // Button to connect/disconnect user
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isConnected
                            ? Color.fromARGB(255, 105, 104, 104)
                            : Color.fromRGBO(161, 161, 161, 1),
                      ),
                    ),
                    onPressed: () {
                      // Action to connect/disconnect user
                      userData.connectDisconnectUser(index);
                      Navigator.pop(context); // Close this screen
                    },
                    child: Text(
                      isConnected ? 'Disconnect' : 'Connect',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView(
                    // List of candidate's posts
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: candidate['posts'].map<Widget>((post) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Display post image
                            buildImageWidget(post['post']),
                            SizedBox(height: 5),
                            Center(
                              // Display post description
                              child: Text(
                                post['description'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
