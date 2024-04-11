import 'dart:io'; // Importing necessary package for handling files
import 'package:flutter/material.dart'; // Importing material package
import 'user_data.dart'; // Import the UserData class to access job listing data

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job; // Job details
  final UserData userData; // UserData object
  final int index; // Index of the job listing
  const JobDetailScreen({
    Key? key,
    required this.job,
    required this.userData,
    required this.index,
  }) : super(key: key);

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late bool hasApplied; // Flag to track if user has applied

  @override
  void initState() {
    super.initState();
    hasApplied = widget.userData.jobListings[widget.index]
        ["applyed"]; // Initialize hasApplied flag
    print(widget.userData.jobListings[widget.index]
        ["applyed"]); // Print applyed status for debugging
  }

  // Method to build image widget based on image path
  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // Use Image.asset for asset images
      return Image.asset(imagePath);
    } else {
      // Use Image.file for file images
      return Image.file(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job['position']), // Display job position in app bar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: buildImageWidget(
                    widget.job['companyLogo']), // Display company logo
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  hasApplied
                      ? Color.fromARGB(
                          255, 105, 104, 104) // Change button color if applied
                      : Color.fromRGBO(161, 161, 161, 1),
                ),
              ),
              onPressed: () {
                setState(() {
                  hasApplied = widget.userData
                      .applyJobsUser(widget.index); // Update apply status
                });
              },
              child: Text(
                hasApplied
                    ? 'You have applied'
                    : 'Apply Now', // Change button text based on apply status
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
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
                    label: 'location',
                    value: widget.job['location'],
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.location_on,
                    label: 'Description',
                    value: widget.job['description'],
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
}

// Method to build a row for job details
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
