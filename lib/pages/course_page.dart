import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    const videoUrl = "https://youtu.be/87SH2Cn0s9A?si=-8veSnBaX7Ppdnl1";
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        isLive: false,
        forceHD: true,
        disableDragSeek: false,
        controlsVisibleAtStart: true,
        hideThumbnail: false,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Course"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Introduction to C Programming",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.account_circle, size: 20),
                    SizedBox(width: 8),
                    Text("Bro Code"),
                    SizedBox(width: 16),
                    Icon(Icons.timer, size: 20),
                    SizedBox(width: 8),
                    Text("4:05:00"),
                    SizedBox(width: 16),
                    Icon(Icons.bar_chart, size: 20),
                    SizedBox(width: 8),
                    Text("Beginner"),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Course Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Dalam kursus ini, kamu akan belajar dasar-dasar bahasa pemrograman C, termasuk variabel, kontrol alur, fungsi, dan pointer.",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
