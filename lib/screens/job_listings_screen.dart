import 'dart:io'; // Importing necessary package for handling files
import 'package:flutter/material.dart'; // Importing material package
import 'user_data.dart'; // Importing UserData class
import 'job_detail_screen.dart'; // Importing JobDetailScreen class

class JobListingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> jobListings; // List of job listings
  final UserData userData; // UserData object

  // Constructor for JobListingsScreen
  const JobListingsScreen({
    super.key,
    required this.jobListings,
    required this.userData,
  });

  // Method to build image widget based on image path
  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // Use AssetImage for asset images
      return CircleAvatar(
        backgroundImage: AssetImage(imagePath),
        radius: 24, // Adjust the radius as needed
      );
    } else {
      // Use FileImage for file images
      return CircleAvatar(
        backgroundImage: FileImage(File(imagePath)),
        radius: 24, // Adjust the radius as needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'), // App bar title
      ),
      body: ListView.builder(
        itemCount: jobListings.length,
        itemBuilder: (context, index) {
          final job = jobListings[index]; // Get job details for current index
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 24, // Specify the radius of the CircleAvatar
              child: buildImageWidget(
                  job['companyLogo']), // Build image widget for company logo
            ),
            title: Text(job['position']), // Display job position
            subtitle: Text(job['company']), // Display company name as subtitle
            onTap: () {
              // Navigate to JobDetailScreen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailScreen(
                    job: job,
                    userData: userData,
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
