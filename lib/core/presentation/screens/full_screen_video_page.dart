import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../utils/app_colors.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoPath; // Now the URL of the video

  const FullScreenVideoPage({required this.videoPath, super.key});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Use network controller for network video playback
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: AppColors.primaryColor,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_controller.value.position),
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                  Text(
                    _formatDuration(
                      _controller.value.duration - _controller.value.position,
                    ),
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.primaryColor,
              ),
              backgroundColor: Colors.white,
            ),
          ],
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
