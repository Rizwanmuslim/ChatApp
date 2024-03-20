import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:whatsap/enume/enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whatsap/widget/videoplyer.dart';
class displyfillemassage extends StatelessWidget {
final String massage;
final MessageEnum massegeEnum;

displyfillemassage({super.key, required this.massage, required this.massegeEnum});
  @override
  Widget build(BuildContext context) {
    bool isplay = true;
    final AudioPlayer audioPlayer = AudioPlayer();
    return massegeEnum == MessageEnum.text?
    Text(massage,style: TextStyle(fontSize: 12)):
     massegeEnum == MessageEnum.audio?
     StatefulBuilder(
       builder:(context, setState) =>IconButton(
           constraints: BoxConstraints(
             minWidth: 100
           ),
           onPressed:() async{
             if(isplay){
               await audioPlayer.play(UrlSource(massage));
               setState((){
                 isplay = true;
               });
             }
              await audioPlayer.pause();
             setState((){
               isplay = false;

             });
           }, icon: Icon(isplay?Icons.pause :Icons.play_circle_sharp)),
     )
    : massegeEnum == MessageEnum.video?
    videoplyer(videourl: massage):
    massegeEnum == MessageEnum.gif?
    CachedNetworkImage(imageUrl: massage)
    :CachedNetworkImage(imageUrl: massage,);
  }
}
