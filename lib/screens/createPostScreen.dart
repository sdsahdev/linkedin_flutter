// Importing necessary packages and files
import 'dart:convert'; // Importing package for encoding and decoding JSON
import 'package:flutter/material.dart'; // Importing material package
import 'package:image_picker/image_picker.dart'; // Importing image picker package
import 'package:shared_preferences/shared_preferences.dart'; // Importing shared_preferences package
import 'dart:io'; // Importing file handling package
import 'user_data.dart'; // Import the UserData class to access the jobListings list

class CreatePostScreen extends StatefulWidget {
  final UserData userData; // UserData object

  // Constructor for CreatePostScreen
  const CreatePostScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _postType = 'Post'; // Initial post type
  final _formKey = GlobalKey<FormState>(); // Form key
  final _descriptionController =
      TextEditingController(); // Controller for description field
  final _companyController =
      TextEditingController(); // Controller for company field
  final _positionController =
      TextEditingController(); // Controller for position field
  final _locationController =
      TextEditingController(); // Controller for location field
  File? _image; // Variable to hold selected image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Avoid resizing on keyboard appearance
      appBar: AppBar(
        title:
            Text('Create $_postType'), // App bar title with dynamic post type
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown for selecting post type
                DropdownButtonFormField<String>(
                  value: _postType,
                  onChanged: (newValue) {
                    setState(() {
                      _postType = newValue!; // Update selected post type
                    });
                  },
                  items: ['Post', 'Job Listing']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                // Text form field for description (visible only for Post type)
                if (_postType == 'Post')
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                // Text form fields for Job Listing details (visible only for Job Listing type)
                if (_postType == 'Job Listing')
                  Column(
                    children: [
                      TextFormField(
                        controller: _companyController,
                        decoration: InputDecoration(labelText: 'Company Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Company Name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Description';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _positionController,
                        decoration: InputDecoration(labelText: 'Position'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a position';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(labelText: 'Location'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 16),
                // Button to select image
                Center(
                  child: ElevatedButton(
                    onPressed: _showImagePicker,
                    child: Text('Select Image'),
                  ),
                ),
                SizedBox(height: 16),
                // Display selected image
                Center(
                  child: _image != null
                      ? Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(), // Placeholder if image is null
                ),
                SizedBox(height: 16),
                // Button to submit post/job listing
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitPost(); // Submit post/job listing
                      }
                    },
                    child: Text('Submit'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to show image picker
  void _showImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path); // Set selected image
      } else {
        print('No image selected.');
      }
    });
  }

  // Method to submit post/job listing based on selected type
  void _submitPost() async {
    if (_postType == 'Post') {
      _submitRegularPost(); // Submit regular post
    } else if (_postType == 'Job Listing') {
      _submitJobListing(); // Submit job listing
    }
  }

  // Method to submit regular post
  void _submitRegularPost() async {
    String description = _descriptionController.text;

    if (_image == null) {
      // Check if an image has been selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    Map<String, String> newPost = {
      'description': description,
      'post': _image!.path,
    };

    // Update 'posts' list of 'lemona' candidate
    int lemonaIndex = widget.userData.candidates
        .indexWhere((candidate) => candidate['name'] == 'lemona');
    if (lemonaIndex != -1) {
      widget.userData.candidates[lemonaIndex]['posts'].add(newPost);

      await _savepostToSharedPreferences(
          widget.userData.candidates); // Save to SharedPreferences
    } else {
      // Show error if candidate 'lemona' is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Candidate "lemona" not found')),
      );
      return;
    }

    _descriptionController.clear(); // Clear description field
    setState(() {
      _image = null; // Reset image
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post submitted successfully')),
    );
  }

  // Method to submit job listing
  void _submitJobListing() async {
    String company = _companyController.text;
    String description = _descriptionController.text;
    String position = _positionController.text;
    String location = _locationController.text;

    if (company.isEmpty ||
        position.isEmpty ||
        location.isEmpty ||
        description.isEmpty) {
      // Check if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_image == null) {
      // Check if an image has been selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    Map<String, dynamic> newJobListing = {
      'company': company,
      'position': position,
      'companyLogo': _image!.path,
      'location': location,
      'description': description,
      'applyed': false,
    };

    // Add new job listing to jobListings list
    widget.userData.jobListings.add(newJobListing);
    await _saveJobListingsToSharedPreferences(
        widget.userData.jobListings); // Save to SharedPreferences

    // Clear text fields and reset image
    _companyController.clear();
    _positionController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _image = null;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Job listing submitted successfully')),
    );
  }

  // Method to save job listings data to SharedPreferences
  Future<void> _saveJobListingsToSharedPreferences(
      List<Map<String, dynamic>> jobListings) async {
    String jobListingsJson =
        jsonEncode(jobListings); // Serialize job listings data to JSON

    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance

    // Save serialized job listings data to SharedPreferences
    await prefs.setString('jobListings', jobListingsJson);
  }

  // Method to save post data to SharedPreferences
  Future<void> _savepostToSharedPreferences(
      List<Map<String, dynamic>> candidates) async {
    String candidatesJson =
        jsonEncode(candidates); // Serialize candidates data to JSON

    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance

    // Save serialized candidates data to SharedPreferences
    await prefs.setString('candidates', candidatesJson);
  }
}
