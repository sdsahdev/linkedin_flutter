import 'dart:io';

import 'package:flutter/material.dart';
import 'user_data.dart';
import 'job_detail_screen.dart';

class JobListingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> jobListings;
  final UserData userData;

  const JobListingsScreen({
    super.key,
    required this.jobListings,
    required this.userData,
  });
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
        title: const Text('Job Listings'),
      ),
      body: ListView.builder(
        itemCount: jobListings.length,
        itemBuilder: (context, index) {
          final job = jobListings[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 24, // Specify the radius of the CircleAvatar
              child: buildImageWidget(job['companyLogo']),
            ),
            title: Text(job['position']),
            subtitle: Text(job['company']),
            onTap: () {
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
