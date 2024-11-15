import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:challange_kide/services/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:video_player/video_player.dart';

File? selectImage;

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late CustomVideoPlayerController _customVideoPlayerController;
  late bool isLoading = true;

  late Uri videoUri;

  @override
  void initState() {
    super.initState();

    // Initialize videoUri here where widget is accessible
    videoUri = Uri.parse(
        "http://192.168.1.12:8000/uploads/images/${widget.lesson.post.mediaFileName}");

    initializeVideoPlayer();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: double.infinity,
            child: AppBar(
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(61, 143, 239, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              title: const Align(
                alignment: Alignment.center,
                child: Text(
                  'Lesson',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [Container(width: 48)],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CustomVideoPlayer(
                          customVideoPlayerController:
                              _customVideoPlayerController,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lesson.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.lesson.description,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void initializeVideoPlayer() {
    setState(() {
      isLoading = true;
    });

    // Initialize the VideoPlayerController and CustomVideoPlayerController
    // Create a CachedVideoPlayerController for the network video
    CachedVideoPlayerController videoPlayerController =
        CachedVideoPlayerController.network(
      videoUri.toString(),
    );

// Initialize the CustomVideoPlayerController with the CachedVideoPlayerController
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );

    _customVideoPlayerController.videoPlayerController.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print('Error initializing video: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading video: $error')),
      );
    });
  }
}
