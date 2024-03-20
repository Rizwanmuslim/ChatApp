import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class videoplyer extends StatefulWidget {
  final String videourl;
  const videoplyer({super.key,required this.videourl});

  @override
  State<videoplyer> createState() => _videoplyerState();
}

class _videoplyerState extends State<videoplyer> {
 late CachedVideoPlayerController videoPlayerController;
 @override
  void initState() {
   videoPlayerController = CachedVideoPlayerController.network(widget.videourl)..initialize().then((value){
     videoPlayerController.setVolume(1);

   });
    super.initState();
  }
  bool isplay = true;

  @override
  Widget build(BuildContext context) {
    return  AspectRatio(
      aspectRatio: 16/9,
    child: Stack(
      children: [
        CachedVideoPlayer(videoPlayerController),
        Align(
          alignment: Alignment.center,
          child: IconButton(onPressed: () {
          if(isplay){
            videoPlayerController.pause();
          }else{
            videoPlayerController.play();
          }
          setState(() {
            isplay = !isplay;
          });

          }, icon: Icon(isplay? Icons.pause :Icons.play_circle)),
        )
        
      ],
    ),
    );
  }
}
