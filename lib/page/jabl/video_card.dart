import 'package:ehentai_browser/model/video_gallery_model.dart';
import 'package:ehentai_browser/widget/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

import '../../controller/theme_controller.dart';
import '../../util/color.dart';
import '../../widget/full_screen_photo.dart';

class VideoCard extends StatefulWidget {
  VideoGalleryModel videoMo;

  @override
  State<VideoCard> createState() => _VideoCardState();

  VideoCard(this.videoMo);
}

class _VideoCardState extends State<VideoCard> {
  late final VideoGalleryModel videoMo;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoMo = widget.videoMo;
    print(videoMo.mp4!);
    _controller = VideoPlayerController.network(
      videoMo.mp4!,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 200,
        child: Card(
          margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_itemImage(context), _infoText()],
              // children: [_itemImage(context)],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [

        FadeInImage.memoryNetwork(
          height: 120,
          width: size.width / 2,
          placeholder: kTransparentImage,
          image: videoMo.imgUrl!,
          fit: BoxFit.cover,
        ),

        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            var child = null;
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => TapablePhoto(videoMo.imgUrl!),
                  );
                },
                onTap: () {
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      // If the video is paused, play it.
                      _controller.play();
                    }
                  });
                },
                child: AnimatedOpacity(
                  opacity: _controller.value.isPlaying ? 1 : 0,
                  duration: Duration.zero,
                  child:Container(
                    height: 120,
                    child: VideoPlayer(_controller),
                  ),
                ),
              );
            } else {
              child = Container(
              );
            }

            return child;
          },
        ),
      ],
    );
  }

  _iconText(IconData? iconData, String count) {
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  _infoText() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                videoMo.title!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: galleryTitleColor(ThemeController.isLightTheme),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.ondemand_video, videoMo.watch!),
                _iconText(Icons.favorite_border, videoMo.like_count!),
                _iconText(null, videoMo.duration!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
