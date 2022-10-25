import 'package:fatwa/Views/VideoPlayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class NetworkPlayerWidget extends StatefulWidget {
  NetworkPlayerWidget({Key? key, required this.video}) : super(key: key);

  final String video;

  @override
  State<NetworkPlayerWidget> createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {
  

  late VideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = VideoPlayerController.network(widget.video)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.play);

    setLandscape();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    setAllOrientations();
    super.dispose();
  }

  Future setLandscape() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Wakelock.enable();
  }

  Future setAllOrientations() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    await Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;

    return Scaffold(
        body: Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: VideoPlayerWidget(controller: controller),
    ));
  }
}
