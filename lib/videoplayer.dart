

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key}) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController assetController;
  bool isMute= false;

  @override
  void initState() {
    super.initState();
    assetController = VideoPlayerController.asset("assets/1.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown
        // after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Video Player App"),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        // body: Container(),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("From Asset" ,style: TextStyle(fontSize: 30),),
            ),
            buildVideoPlayer(assetController),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            setState(() {
              assetController.setVolume(isMute?1:0);
              isMute =!isMute;
            });
          },
          child: Icon(
            isMute? Icons.volume_off_rounded : Icons.volume_up,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop);

  }
  buildVideoPlayer(VideoPlayerController controller)
  {
    return Column(
      children: [
        Center(
          child: controller.value.isInitialized?
          AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller),)
              : Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: ()async{
                  Duration? value =  await controller.position;
                  var d = value! - const Duration(seconds: 10);
                  controller.seekTo(Duration(seconds: d.inSeconds));
                }, child: const Text("<<")),
            ElevatedButton(
              child: const Icon(Icons.play_arrow_rounded),
              onPressed: (){
                controller.play();
              },),
            ElevatedButton(
              child: const Icon(Icons.pause_outlined),
              onPressed: (){
                controller.pause();
              }, ),
            ElevatedButton(onPressed:  ()async {
              Duration? value =  await controller.position;
              var d = const Duration(seconds: 10)+value!;
              controller.seekTo(Duration(seconds: d.inSeconds));
            }, child: const Text(">>")),

          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    assetController.dispose();
  }
}