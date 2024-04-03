import 'dart:io';

import 'package:flutter/material.dart';
import 'user_data.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final UserData userData;
  final int index;
  const JobDetailScreen(
      {Key? key,
      required this.job,
      required this.userData,
      required this.index})
      : super(key: key);

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late bool hasApplied;

  @override
  void initState() {
    super.initState();
    hasApplied = widget.userData.jobListings[widget.index]["applyed"];
    print(widget.userData.jobListings[widget.index]["applyed"]);
  }

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
        title: Text(widget.job['position']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImageWidget(widget.job['companyLogo']),
            const SizedBox(height: 16),
            Text(
              'Company: ${widget.job['company']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: ${widget.job['location']}',
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.job['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  hasApplied = widget.userData.applyJobsUser(widget.index);
                });
              },
              child: Text(hasApplied ? 'You have applied' : 'Apply Now'),
            ),
          ],
        ),
      ),
    );
  }
}
