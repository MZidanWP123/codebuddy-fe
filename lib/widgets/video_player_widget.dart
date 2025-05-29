import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    // In a real app, you would use a video player package like video_player or chewie
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      child: const Center(
        child: Icon(
          Icons.play_circle_fill,
          size: 64,
          color: Colors.white54,
        ),
      ),
    );
  }
}
