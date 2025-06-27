import 'dart:async';  // <-- for Timer
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaPreview extends StatefulWidget {
  final String url;

  const MediaPreview({super.key, required this.url});

  @override
  State<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  VideoPlayerController? _videoController;
  bool isVideo = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();

    isVideo = widget.url.toLowerCase().endsWith('.mp4') ||
        widget.url.toLowerCase().endsWith('.mov') ||
        widget.url.toLowerCase().endsWith('.webm') ||
        widget.url.toLowerCase().endsWith('.mkv');

    if (isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          setState(() {}); // Refresh after initialization
          _videoController!.play();

          // Listen for video end event
          _videoController!.addListener(() {
            if (_videoController!.value.position >= _videoController!.value.duration &&
                !_videoController!.value.isPlaying) {
              // Video finished playing, wait 1 minute then replay
              _delayTimer?.cancel(); // Cancel any existing timers
              _delayTimer = Timer(const Duration(seconds: 10), () {
                if (mounted) {
                  _videoController!.seekTo(Duration.zero);
                  _videoController!.play();
                }
              });
            }
          });
        });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isVideo
            ? (_videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : const Center(child: CircularProgressIndicator()))
            : Image.network(
                widget.url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
      ),
    );
  }
}
