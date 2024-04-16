import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'job_detail_screen.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({Key? key}) : super(key: key);

  @override
  _JobListingsScreenState createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  List<Map<String, dynamic>> jobListings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobListings();
  }

  Future<void> fetchJobListings() async {
    try {
      final response = await http.get(Uri.parse(
          'https://fir-projectactivity-default-rtdb.firebaseio.com/jobListings.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<Map<String, dynamic>> fetchedListings = [];
        data.forEach((key, value) {
          fetchedListings.add({
            'key': key,
            'company': value['company'],
            'companyLogo': value['companyLogo'],
            'description': value['description'],
            'location': value['location'],
            'position': value['position'],
          });
        });
        setState(() {
          jobListings = fetchedListings;
          isLoading = false; // Set isLoading to false when data is fetched
        });
      } else {
        throw Exception('Failed to load job listings');
      }
    } catch (error) {
      print('Error fetching job listings: $error');
      // Handle error or show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loader in the center
            )
          : ListView.builder(
              itemCount: jobListings.length,
              itemBuilder: (context, index) {
                final job = jobListings[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 24,
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
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget buildImageWidget(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        child: Icon(Icons.business),
        backgroundColor: Colors.grey, // Placeholder color
      );
    }
    return ClipOval(
      child: Image.network(
        imageUrl,
        width: 48, // Adjust the width and height as needed
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return CircleAvatar(
            child: Icon(Icons.error),
            backgroundColor: Colors.red, // Placeholder color
          );
        },
      ),
    );
  }
}
