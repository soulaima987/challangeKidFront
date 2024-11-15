import 'dart:io';

import 'package:challange_kide/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'chapter.dart';

File? selectImage;

class ChallengeScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeScreen({super.key, required this.challenge});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          selectImage = File(pickedImage.path);
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _resetForm() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      selectImage = null;
    });
    _formKey.currentState?.reset(); // Reset the form state
  }

  void _showEnrollBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Add padding for keyboard
            left: 16.0,
            right: 16.0,
          ),
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 40.0
                    : 0.0), // Add top padding when keyboard is open
            height: MediaQuery.of(context).size.height *
                0.75, // Adjust the height as needed
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enroll in ${widget.challenge.title}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please provide the following details to complete your enrollment:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: selectImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                selectImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                "Please select an image",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      pickImageFromGallery();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: const Text('Upload Image'),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter the title',
                          ),
                          controller: titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Add Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _resetForm(); // Reset form fields and image
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  backgroundColor:
                                      Colors.grey[200], // Light gray background
                                  minimumSize: Size(double.infinity,
                                      48), // Width of the Cancel button
                                ),
                                child: const Text('Restart'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                width: double
                                    .infinity, // Ensure the button takes the full width
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      if (selectImage == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Image is required.')),
                                        );
                                        return;
                                      }

                                      upload(
                                        widget.challenge.id,
                                        titleController.text,
                                        descriptionController.text,
                                        selectImage!.path,
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(double.infinity,
                                        60), // Larger button height
                                  ),
                                  child: const Text('Enroll Now'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'http://192.168.1.12:8000/uploads/images/${widget.challenge.imageFileName}'),
                ),
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 30,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // Back icon
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
          ),
          // Main Content
          Positioned(
            top: 200, // Position below the background image
            left: 0,
            right: 0,
            bottom: 0, // Extend to the bottom of the screen
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.challenge.title,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.challenge.description,
                            style: const TextStyle(fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 20),
                          // Center the time and number info
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 4),
                              Text(
                                "Chapters",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.challenge.chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = widget.challenge.chapters[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 16.0),
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(61, 143, 239, 1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        size: 30,
                                        Icons.play_lesson_outlined,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Handle icon button tap
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        chapter.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => chapterScreen(chapter: chapter, challenge: widget.challenge,),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            61, 143, 239, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.play_circle_rounded,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 70.0,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(61, 143, 239, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () => _showEnrollBottomSheet(context),
                    child: const Text(
                      'Enroll Now',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
