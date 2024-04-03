import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'user_data.dart';
import 'candidates_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserData userData;

  const HomeScreen({super.key, required this.userData});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: ListView.builder(
        cacheExtent: double.maxFinite, // Set cacheExtent to maximum
        itemCount: widget.userData.connectedUserPosts.length,
        itemBuilder: (context, index) {
          final connectedUserName = widget.userData.connectedUserPosts[index];
          final connectedCandidate = widget.userData.candidates.firstWhere(
            (candidate) =>
                candidate['name'] ==
                connectedUserName, // Return null if candidate is not found
          );

          // Check if the candidate is connected
          if (connectedCandidate != null && connectedCandidate['isConnected']) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5), // Add some spacing
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: connectedCandidate['posts'].length,
                  itemBuilder: (context, postIndex) {
                    final post = connectedCandidate['posts'][postIndex];
                    return _buildPostWidget(
                      post['post'], // Get the post image path
                      connectedCandidate['profileImage'],
                      post['description'], // Get the post description
                      connectedUserName,
                    );
                  },
                ),
              ],
            );
          } else {
            // If candidate is not connected, return an empty container
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CandidatesScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CandidatesScreen(
                userData: widget.userData,
                onUpdatePosts: _updatePosts,
              ),
            ),
          );
        },
        child: const Icon(Icons.people),
      ),
    );
  }

  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // Use Image.asset for asset images
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      // Use Image.file for file images
      return Image.file(File(imagePath));
    }
  }

  Widget _buildPostWidget(String postImagePath, String profileImagePath,
      String description, String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(profileImagePath),
          ),
          title: Text(userName),
        ),
        buildImageWidget(postImagePath),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            description,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _updatePosts(List<String> updatedPosts) {
    setState(() {
      widget.userData.connectedUserPosts = updatedPosts;
    });
  }
}
