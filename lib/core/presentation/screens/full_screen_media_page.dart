import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

import '../../utils/app_colors.dart';

class FullScreenMediaPage extends StatefulWidget {
  final List<File> mediaFiles;
  final int initialIndex;
  final bool isVideo;

  FullScreenMediaPage({
    required this.mediaFiles,
    required this.initialIndex,
    this.isVideo = false,
    super.key,
  });

  @override
  _FullScreenMediaPageState createState() => _FullScreenMediaPageState();
}

class _FullScreenMediaPageState extends State<FullScreenMediaPage> {
  late PageController _pageController;
  late VideoPlayerController _videoController;
  int _currentIndex = 0;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _isVideo = widget.isVideo;
    _pageController = PageController(initialPage: widget.initialIndex);
    if (_isVideo) {
      _initializeVideoPlayer(widget.mediaFiles[_currentIndex]);
    }
  }

  void _initializeVideoPlayer(File videoFile) {
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    if (_isVideo) {
      _videoController.dispose();
    }
    super.dispose();
  }

  Future<Uint8List?> _generateVideoThumbnail(File videoFile) async {
    return await VideoThumbnail.thumbnailData(
      video: videoFile.path,
      maxWidth: 128,
      quality: 25,
    );
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaFiles.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _isVideo = widget.mediaFiles[_currentIndex].path.endsWith('.mp4');
                  if (_isVideo) {
                    _initializeVideoPlayer(widget.mediaFiles[_currentIndex]);
                  } else if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  }
                });
              },
              itemBuilder: (context, index) {
                if (widget.mediaFiles[index].path.endsWith('.mp4')) {
                  return _isVideo && _currentIndex == index
                      ? _buildVideoPlayer()
                      : FutureBuilder<Uint8List?>(
                    future: _generateVideoThumbnail(widget.mediaFiles[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                } else {
                  return Center(
                    child: Hero(
                      tag: widget.mediaFiles[index].path,
                      child: Image.file(widget.mediaFiles[index], fit: BoxFit.contain),
                    ),
                  );
                }
              },
            ),
          ),
          _buildMediaThumbnails(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
        VideoProgressIndicator(
          _videoController,
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
                _formatDuration(_videoController.value.position),
                style: TextStyle(color: AppColors.primaryColor),
              ),
              Text(
                _formatDuration(_videoController.value.duration - _videoController.value.position),
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
            });
          },
          child: Icon(
            _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.primaryColor,
          ),
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildMediaThumbnails() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.black54,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.mediaFiles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.jumpToPage(index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _currentIndex == index ? Colors.white : Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: widget.mediaFiles[index].path.endsWith('.mp4')
                    ? FutureBuilder<Uint8List?>(
                  future: _generateVideoThumbnail(widget.mediaFiles[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                      return Image.memory(snapshot.data!, fit: BoxFit.cover, width: 60, height: 60);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
                    : Image.file(
                  widget.mediaFiles[index],
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}