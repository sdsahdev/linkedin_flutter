import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CandidateDetailScreen extends StatefulWidget {
  final Map<String, dynamic> candidate;

  const CandidateDetailScreen({
    Key? key,
    required this.candidate,
  }) : super(key: key);

  @override
  _CandidateDetailScreenState createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen> {
  late DatabaseReference _candidateRef;
  late List<String> _connectedUsers =
      []; // Initialize _connectedUsers as empty list
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Database reference
    _candidateRef = FirebaseDatabase.instance
        .reference()
        .child('candidates')
        .child(widget.candidate['id']);

    // Fetch the initial value of _connectedUsers from the database
    _fetchConnectedUsers();
  }

  // Fetch the initial value of _connectedUsers from the database
  void _fetchConnectedUsers() {
    _candidateRef.child('isConnected').once().then((snapshot) {
      final isConnected =
          snapshot.snapshot.value; // Access value from snapshot.snapshot
      if (isConnected is List) {
        setState(() {
          _connectedUsers = List<String>.from(isConnected);
          _isConnected =
              _connectedUsers.contains(FirebaseAuth.instance.currentUser!.uid);
        });
      }
    }).catchError((error) {
      print('Error fetching connected users: $error');
    });
  }

  void _connectDisconnectUser() {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      _isConnected = !_isConnected;
      if (_isConnected) {
        _connectedUsers.add(userId);
      } else {
        _connectedUsers.remove(userId);
      }
    });

    _candidateRef.update({
      'isConnected': _connectedUsers,
    }).then((_) {
      print('User connection status updated successfully');
    }).catchError((error) {
      print('Failed to update user connection status: $error');
      setState(() {
        _isConnected = !_isConnected;
        if (_isConnected) {
          _connectedUsers.add(userId);
        } else {
          _connectedUsers.remove(userId);
        }
      });
    });
  }

  Widget buildImageWidget(String imagePath) {
    if (imagePath.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20), // Apply border radius here
        child: Image.network(
          imagePath,
          width: 300,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(); // Placeholder or default widget when imagePath is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.candidate['posts'];
    final postList = posts is Map ? posts.values.toList() : [];

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
                backgroundImage: NetworkImage(widget.candidate['profileImage']),
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
                    widget.candidate['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.candidate['position'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Age: ${widget.candidate['age']}'),
                  Text('Date of Birth: ${widget.candidate['dob']}'),
                  Text('Education: ${widget.candidate['education']}'),
                  Text('Mobile: ${widget.candidate['mobile']}'),
                  Text('Email: ${widget.candidate['email']}'),
                  const SizedBox(height: 20),
                  const Text(
                    'Posts:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Apply border radius to the button
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        _isConnected
                            ? Color.fromARGB(255, 105, 104, 104)
                            : Color.fromRGBO(161, 161, 161, 1),
                      ),
                    ),
                    onPressed: _connectDisconnectUser,
                    child: Text(
                      _isConnected ? 'Disconnect' : 'Connect',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      final post = postList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildImageWidget(post['postImage']),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                post['description'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
