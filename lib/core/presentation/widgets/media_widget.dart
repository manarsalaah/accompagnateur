import 'dart:typed_data';
import 'package:accompagnateur/core/presentation/widgets/attachment_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../utils/app_strings.dart';
import '../screens/full_screen_video_page.dart';
import '../screens/full_screen_image_page.dart';

class MediaWidget extends StatefulWidget {
  final String path;
  final String id;
  final Uint8List? imageData;
  final DateTime uploadDate;
  final String? comment;
  final int likesNumber;
  final String? filePath;
  final bool isVideo;
  final List<String> images;
  final int index;

  MediaWidget({
    required this.path,
    required this.id,
    required this.likesNumber,
    required this.comment,
    this.imageData,
    required this.uploadDate,
    required this.filePath,
    required this.isVideo,
    required this.images,
    required this.index,
    super.key,
  });

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.path));
      _initializeVideoPlayerFuture = _videoController.initialize();
      _videoController.setLooping(true);
    }
  }

  @override
  void dispose() {
    if (widget.isVideo) {
      _videoController.dispose();
    }
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.isVideo) {
      if (info.visibleFraction > 0.5 && !_isPlaying) {
        _videoController.play();
        setState(() {
          _isPlaying = true;
        });
      } else if (info.visibleFraction <= 0.5 && _isPlaying) {
        _videoController.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.id),
      onVisibilityChanged: _onVisibilityChanged,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (widget.isVideo) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenVideoPage(videoPath: widget.path),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          images: widget.images,
                          initialIndex: widget.index,
                        ),
                      ),
                    );
                  }
                },
                child: Hero(
                  tag: widget.path,
                  child: widget.isVideo
                      ? FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return VideoPlayer(_videoController);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                      : Image.network(
                    widget.path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            if (widget.comment != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: Text(
                    widget.comment!,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppStrings.fontName,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Positioned(
              top: 4,
              right: 10,
              child: AttachmentToolTip(id: widget.id),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.favorite,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
