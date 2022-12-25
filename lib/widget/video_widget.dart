import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayWidget extends StatefulWidget {
  String m3u8;

  VideoPlayWidget(this.m3u8);

  @override
  State<VideoPlayWidget> createState() => _State();
}

class _State extends State<VideoPlayWidget> {
  late VideoPlayerController _controller;
  late final chewieController;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.m3u8,
    );
  }

  @override
  void dispose() {
    chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          chewieController = ChewieController(
            aspectRatio: _controller.value.aspectRatio,
            videoPlayerController: _controller,
            autoPlay: false,
            looping: false,
          );

          return Chewie(
            controller: chewieController,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
