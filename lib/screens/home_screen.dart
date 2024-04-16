import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> _candidateIds = [];
  bool _isLoading = true; // Added to track loading state

  @override
  void initState() {
    super.initState();
    _loadCandidateIds();
  }

  Future<void> _loadCandidateIds() async {
    try {
      String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

      DataSnapshot candidatesSnapshot = (await FirebaseDatabase.instance
              .reference()
              .child('candidates')
              .once())
          .snapshot;
      if (candidatesSnapshot.value != null &&
          candidatesSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> candidatesData =
            candidatesSnapshot.value as Map<dynamic, dynamic>;

        // Add current user's ID to the list if not already included
        if (currentUserID != null && !_candidateIds.contains(currentUserID)) {
          _candidateIds.add(currentUserID);
        }

        setState(() {
          _candidateIds.addAll(candidatesData.entries.where((entry) {
            List<dynamic>? isConnected = entry.value['isConnected'];
            return isConnected != null && isConnected.contains(currentUserID);
          }).map((entry) => entry.key.toString()) // Convert keys to strings
              );
          _isLoading = false; // Data loaded, set loading state to false
        });
        print("================================================");
        print(_candidateIds);
      } else {
        print('Candidates data is null or not of type Map<dynamic, dynamic>.');
      }
    } catch (error) {
      print('Error loading candidates: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _candidateIds.map((String candidateId) {
                  return FutureBuilder<DataSnapshot>(
                    future: FirebaseDatabase.instance
                        .reference()
                        .child('candidates')
                        .child(candidateId)
                        .once()
                        .then((snapshot) => snapshot.snapshot),
                    builder: (BuildContext context,
                        AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (snapshot.hasData && snapshot.data!.value != null) {
                        dynamic candidateData = snapshot.data!.value;
                        if (candidateData is Map<dynamic, dynamic>) {
                          String profileImage =
                              candidateData['profileImage'] ?? '';
                          String name = candidateData['name'] ?? '';
                          dynamic postsData = candidateData['posts'];
                          if (postsData is Map<dynamic, dynamic>) {
                            List<String> postKeys =
                                postsData.keys.cast<String>().toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: postKeys.map((String postKey) {
                                dynamic postData = postsData[postKey];
                                if (postData is Map<dynamic, dynamic>) {
                                  return _buildPostWidget(
                                    postData['postImage'] ?? '',
                                    profileImage,
                                    name,
                                    postData['description'] ?? '',
                                  );
                                } else {
                                  print('Invalid post data for key $postKey');
                                  return Container();
                                }
                              }).toList(),
                            );
                          } else {
                            print('Invalid posts data');
                            return Container();
                          }
                        } else {
                          print('Invalid candidate data');
                          return Container();
                        }
                      } else {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildPostWidget(
    String postImagePath,
    String profileImagePath,
    String name,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImagePath),
              ),
              SizedBox(width: 10),
              Text(name),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio:
              16 / 9, // Set aspect ratio for consistent post image size
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(postImagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
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

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                try {
                  await FirebaseAuth.instance.signOut();
                  // Navigate to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } catch (e) {
                  print('Error signing out: $e');
                  // Handle sign out errors
                }
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
