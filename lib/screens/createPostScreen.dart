// Importing necessary packages and files
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart'; // Importing material package
import 'package:image_picker/image_picker.dart'; // Importing image picker package
import 'dart:io'; // Importing file handling package

class CreatePostScreen extends StatefulWidget {
  // Constructor for CreatePostScreen
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _postType = 'Post'; // Initial post type
  bool _isLoading = false; // Variable to track loading state

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
                        setState(() {
                          _isLoading = true; // Set loading state to true
                        });
                        _submitPost(); // Submit post/job listing
                      }
                    },
                    child: _isLoading // Conditional rendering based on loading state
                        ? CircularProgressIndicator() // Show loader if loading
                        : Text('Submit'), // Show 'Submit' text if not loading
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
    // Get the UID of the authenticated user
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      // User is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }
    String description = _descriptionController.text;
    if (_image == null) {
      // Check if an image has been selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }
    Reference storageReference =
        FirebaseStorage.instance.ref().child('posts/${DateTime.now()}.png');

    // Upload the file to Firebase Storage
    UploadTask uploadTask = storageReference.putFile(_image!);

    // Wait for the upload to complete
    await uploadTask;

    // Get the download URL of the uploaded image
    String imageUrl = await storageReference.getDownloadURL();

    print('Image uploaded successfully. Download URL: $imageUrl');

    // Update post data with image URL
    Map<String, dynamic> newPost = {
      'description': description,
      'postImage': imageUrl,
    };

    // Update 'posts' list of 'lemona' candidate
    DatabaseReference postsRef = FirebaseDatabase.instance
        .reference()
        .child('candidates')
        .child(uid)
        .child('posts');

    // Push the new post data to generate a unique key
    postsRef.push().set(newPost);

    _descriptionController.clear(); // Clear description field
    setState(() {
      _image = null; // Reset image
    });

    setState(() {
      _isLoading = false; // Reset loading state
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
        SnackBar(content: Text('Please select a company logo')),
      );
      return;
    }

    try {
      // Upload company logo to Firebase Storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('companylogo/${DateTime.now()}.png');
      UploadTask uploadTask = storageReference.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get download URL of the uploaded logo
      String logoUrl = await taskSnapshot.ref.getDownloadURL();

      // Create a new job listing object with logo URL
      Map<String, dynamic> newJobListing = {
        'company': company,
        'position': position,
        'companyLogo': logoUrl,
        'location': location,
        'description': description,
        'applied': false,
      };

      // Save the job listing to Firebase Realtime Database
      DatabaseReference jobListingsRef =
          FirebaseDatabase.instance.reference().child('jobListings');
      jobListingsRef.push().set(newJobListing);

      // Clear text fields and reset image
      _companyController.clear();
      _positionController.clear();
      _locationController.clear();
      _descriptionController.clear();
      setState(() {
        _image = null;
      });

      setState(() {
        _isLoading = false; // Reset loading state
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job listing submitted successfully')),
      );
    } catch (error) {
      print('Error submitting job listing: $error');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to submit job listing. Please try again later.')),
      );
    }
  }
}
