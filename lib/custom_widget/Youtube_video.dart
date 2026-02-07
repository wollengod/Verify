import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String fallbackImageUrl;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.fallbackImageUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  YoutubePlayerController? _controller;
  bool _isPlayerVisible = false;

  String? get _videoId {
    if (widget.videoUrl.trim().isEmpty) return null;
    return YoutubePlayer.convertUrlToId(widget.videoUrl);
  }

  void _initializePlayer() {
    if (_videoId == null || _controller != null) return;

    _controller = YoutubePlayerController(
      initialVideoId: _videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        hideControls: false,
        hideThumbnail: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,

        // 🔴 IMPORTANT
        forceHD: false,
      ),
    );

    setState(() => _isPlayerVisible = true);
  }

  Future<void> _openInYoutube() async {
    final uri = Uri.parse(widget.videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = _videoId != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: hasVideo
                ? (_isPlayerVisible
                ? YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.redAccent,

              // 🔴 FULLSCREEN DISABLED
              topActions: const [],
              bottomActions: const [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
              ],
            )
                : GestureDetector(
              onTap: _initializePlayer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    YoutubePlayer.getThumbnail(
                      videoId: _videoId!,
                      quality: ThumbnailQuality.high,
                    ),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                  Container(color: Colors.black45),
                  const Icon(
                    Icons.play_circle_fill,
                    size: 64,
                    color: Colors.white,
                  ),
                ],
              ),
            ))
                : Image.network(
              widget.fallbackImageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),

          // 🔹 Open in YouTube (explicit action)
          if (hasVideo && _isPlayerVisible)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _openInYoutube,
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text("Open in YouTube"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
