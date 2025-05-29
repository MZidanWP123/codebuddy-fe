import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String youtubeUrl;

  const CustomVideoPlayer({super.key, required this.youtubeUrl});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late YoutubePlayerController _controller;
  late String _videoId;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        enableCaption: true,
        hideControls: false,
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
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen.
        // This overrides the behavior.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFF1D2A44),
        progressColors: const ProgressBarColors(
          playedColor: Color(0xFF1D2A44),
          handleColor: Color(0xFF1D2A44),
        ),
        onReady: () {
          // Do something when player is ready
        },
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 10.0),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
              playedColor: Color(0xFF1D2A44),
              handleColor: Color(0xFF1D2A44),
            ),
          ),
          const SizedBox(width: 10.0),
          RemainingDuration(),
          IconButton(
            icon: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFullScreen = !_isFullScreen;
              });
            },
          ),
        ],
      ),
      builder: (context, player) {
        return Column(
          children: [
            // Player
            player,
          ],
        );
      },
    );
  }
}
