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
              onPressed: () {
                setState(() {
                  hasApplied = widget.userData.applyJobsUser(widget.index);
                });
              },
              child: Text(
                hasApplied ? 'You have applied' : 'Apply Now',
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
