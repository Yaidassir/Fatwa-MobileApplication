import 'package:fatwa/Views/basicOverlayWidget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

  Widget buildVideo() => OrientationBuilder(
    builder: (context, orientation) {
      final isPortait = orientation == Orientation.portrait;
    final isMuted = controller.value.volume == 0;

    return Stack(
      fit: isPortait ? StackFit.loose : StackFit.expand,
      children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(
            child: BasicOverlayWidget(controller: controller),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: IconButton(
                onPressed: () => controller.setVolume(isMuted ? 1 : 0),
                icon: Icon(
                  isMuted ? Icons.volume_mute : Icons.volume_up,
                  color: Colors.white,
                )),
          ),),

          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back,
                  color: Colors.white,
                )),)
        ]);
    }
  );

  Widget buildVideoPlayer() => BuildFullScreen(
      child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller)));

  Widget BuildFullScreen({required AspectRatio child}) {
    final size = controller.value.size;
    final width = size.width-30;
    final height = size.height-60;

    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
