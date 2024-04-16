import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({
    Key? key,
    required this.job,
  }) : super(key: key);

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late bool hasApplied;
  late DatabaseReference _candidateRef;
  late List<String> _connectedUsers =
      []; // Initialize _connectedUsers as empty list

  @override
  void initState() {
    super.initState();
    _candidateRef = FirebaseDatabase.instance
        .reference()
        .child('jobListings')
        .child(widget.job['key']);
    hasApplied = false; // Initialize hasApplied flag
    fetchHasApplied(); // Fetch the hasApplied status
  }

  // Method to fetch whether the user has applied for the job
  void fetchHasApplied() {
    _candidateRef.child('Applied').once().then((snapshot) {
      final fetchapply =
          snapshot.snapshot.value; // Access value from snapshot.snapshot
      if (fetchapply is List) {
        setState(() {
          _connectedUsers = List<String>.from(fetchapply);
          hasApplied =
              _connectedUsers.contains(FirebaseAuth.instance.currentUser!.uid);
        });
      }
    }).catchError((error) {
      print('Error fetching connected users: $error');
    });
  }

  // Method to apply for or withdraw application from the job
  void _connectDisconnectUser() {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      hasApplied = !hasApplied;
      if (hasApplied) {
        _connectedUsers.add(userId);
      } else {
        _connectedUsers.remove(userId);
      }
    });

    _candidateRef.update({
      'Applied': _connectedUsers,
    }).then((_) {
      print('User connection status updated successfully');
    }).catchError((error) {
      print('Failed to update user connection status: $error');
      setState(() {
        hasApplied = !hasApplied;
        if (hasApplied) {
          _connectedUsers.add(userId);
        } else {
          _connectedUsers.remove(userId);
        }
      });
    });
  }

  // Method to build image widget based on imageUrl
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job['position']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display company logo
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: buildImageWidget(widget.job['companyLogo']),
              ),
            ),
            const SizedBox(height: 16),
            // Button to apply for the job
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  hasApplied
                      ? Color.fromARGB(255, 105, 104, 104)
                      : Color.fromRGBO(161, 161, 161, 1),
                ),
              ),
              onPressed: _connectDisconnectUser,
              child: Text(
                hasApplied ? 'Applied' : 'Apply Now',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            // Details of the job
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    icon: Icons.business,
                    label: 'Company',
                    value: widget.job['company'],
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.work,
                    label: 'Location',
                    value: widget.job['location'],
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.location_on,
                    label: 'Description',
                    value: widget.job['description'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each detail row (e.g., Company, Location, Description)
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    TextOverflow? overflow,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Color.fromARGB(255, 0, 20, 37),
          size: 20,
        ),
        SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
                overflow: overflow,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
