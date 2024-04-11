import 'dart:io'; // Importing necessary package for handling files
import 'package:flutter/material.dart'; // Importing material package
import 'user_data.dart'; // Import the UserData class to access candidate data
import 'candidates_screen.dart'; // Importing CandidatesScreen class

class HomeScreen extends StatefulWidget {
  final UserData userData; // UserData object

  // Constructor for HomeScreen
  const HomeScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data from SharedPreferences when the screen initializes
    widget.userData.loadDataFromSharedPreferences().then((_) {
      // Update UI after loading data
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if userData is not null and candidates list is not empty
    if (widget.userData.candidates.isNotEmpty) {
      return buildHomeScreen(); // Build home screen with candidate data
    } else {
      // Show a loading indicator or empty screen while data is loading
      return Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Show circular progress indicator
        ),
      );
    }
  }

  // Build home screen with candidate data
  Widget buildHomeScreen() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: ListView.builder(
              cacheExtent: double.maxFinite,
              itemCount: widget.userData.candidates.length,
              itemBuilder: (context, index) {
                final candidate = widget.userData.candidates[index];

                // Check if the candidate is connected
                if (candidate['isConnected']) {
                  // Display posts if connected
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: candidate['posts'].length,
                        itemBuilder: (context, postIndex) {
                          final post = candidate['posts'][postIndex];
                          final isLastItem =
                              index == widget.userData.candidates.length - 1 &&
                                  postIndex == candidate['posts'].length - 1;
                          // Build post widget
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPostWidget(
                                post['post'],
                                candidate['profileImage'],
                                post['description'],
                                candidate['name'],
                                isLastItem: isLastItem,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Container(); // Return empty container if not connected
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // Method to build image widget based on image path
  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // Load image from assets
      return Image.asset(
        imagePath,
        width: 300,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      // Load image from file
      return Image.file(
        File(imagePath),
        width: 300,
        height: 200,
        fit: BoxFit.contain,
      );
    }
  }

  // Method to build post widget
  Widget _buildPostWidget(
    String postImagePath,
    String profileImagePath,
    String description,
    String userName, {
    required bool isLastItem,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ListTile for user details
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(profileImagePath),
          ),
          title: Text(userName),
        ),
        // Description of the post
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            description,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // Image of the post
        Center(
          child: buildImageWidget(postImagePath),
        ),
        if (isLastItem)
          SizedBox(height: 40), // Add margin only for the last post
      ],
    );
  }

  // Method to update candidates data
  void updateCandidates(List<Map<String, dynamic>> updatedCandidates) {
    setState(() {
      widget.userData.candidates = updatedCandidates;
    });
  }
}
