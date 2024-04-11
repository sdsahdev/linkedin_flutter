// Import necessary packages and files
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'user_data.dart'; // Import the UserData class to access the jobListings list

class CreatePostScreen extends StatefulWidget {
  final UserData userData;

  const CreatePostScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _postType = 'Post';
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _locationController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Create $_postType'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _postType,
                  onChanged: (newValue) {
                    setState(() {
                      _postType = newValue!;
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
                Center(
                  child: ElevatedButton(
                    onPressed: _showImagePicker,
                    child: Text('Select Image'),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: _image != null
                      ? Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(), // You might want to display a placeholder if _image is null
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitPost();
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

  void _showImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _submitPost() async {
    // Check the post type and collect relevant data
    if (_postType == 'Post') {
      _submitRegularPost();
    } else if (_postType == 'Job Listing') {
      _submitJobListing();
    }
  }

  void _submitRegularPost() async {
    String description = _descriptionController.text;

    // Check if an image has been selected
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Create a new post map with String values
    Map<String, String> newPost = {
      'description': description,
      'post': _image!.path,
    };

    // Update the 'posts' list of the 'lemona' candidate
    int lemonaIndex = widget.userData.candidates
        .indexWhere((candidate) => candidate['name'] == 'lemona');
    if (lemonaIndex != -1) {
      widget.userData.candidates[lemonaIndex]['posts'].add(newPost);

      await _savepostToSharedPreferences(widget.userData.candidates);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Candidate "lemona" not found')),
      );
      return; // Exit the method if candidate 'lemona' is not found
    }

    // Clear the description field
    _descriptionController.clear();
    setState(() {
      _image = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post submitted successfully')),
    );
  }

  void _submitJobListing() async {
    String company = _companyController.text;
    String description = _descriptionController.text;
    String position = _positionController.text;
    String location = _locationController.text;

    // Check if any fields are empty
    if (company.isEmpty ||
        position.isEmpty ||
        location.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return; // Exit the method if any field is empty
    }

    // Check if an image has been selected
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Create a new job listing map
    Map<String, dynamic> newJobListing = {
      'company': company,
      'position': position,
      'companyLogo': _image!.path,
      'location': location,
      'description': description,
      'applyed': false,
    };

    // Add the new job listing to the jobListings list
    widget.userData.jobListings.add(newJobListing);
    await _saveJobListingsToSharedPreferences(widget.userData.jobListings);

    // Clear the text fields and reset the image
    _companyController.clear();
    _positionController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _image = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Job listing submitted successfully')),
    );
  }

// Method to save job listings data to SharedPreferences
  Future<void> _saveJobListingsToSharedPreferences(
      List<Map<String, dynamic>> jobListings) async {
    // Serialize the job listings data to JSON
    String jobListingsJson = jsonEncode(jobListings);

    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the serialized job listings data to SharedPreferences
    await prefs.setString('jobListings', jobListingsJson);
  }

  Future<void> _savepostToSharedPreferences(
      List<Map<String, dynamic>> candidates) async {
    // Serialize the job listings data to JSON
    String candidatesJson = jsonEncode(candidates);

    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the serialized job listings data to SharedPreferences
    await prefs.setString('candidates', candidatesJson);
  }
}
