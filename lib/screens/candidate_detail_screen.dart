import 'dart:io';

import 'package:flutter/material.dart';
import 'user_data.dart';

class CandidateDetailScreen extends StatelessWidget {
  final Map<String, dynamic> candidate;
  final UserData userData;
  // final Function(List<String>) onUpdatePosts;
  final int index;

  const CandidateDetailScreen({
    Key? key,
    required this.candidate,
    required this.userData,
    // required this.onUpdatePosts,
    required this.index,
  }) : super(key: key);

  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.contain,
        height: 200,
      );
    } else {
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
    final bool isConnected = candidate[
        'isConnected']; // Get connection status directly from the candidate object
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Detail Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      userData.connectDisconnectUser(index);
                      // onUpdatePosts(userData.candidates
                      //     .where((candidate) => candidate['isConnected'])
                      //     .map<String>((candidate) => candidate['name'])
                      //     .toList());
                      Navigator.pop(context);
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: candidate['posts'].map<Widget>((post) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildImageWidget(post['post']),
                            SizedBox(height: 5),
                            Center(
                              // Wrap the Text widget with Center widget
                              child: Text(
                                post['description'],
                                textAlign: TextAlign
                                    .center, // Set text alignment to center
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
