import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsap/color.dart';
import 'package:whatsap/enume/enum.dart';
import 'package:whatsap/widget/Displyfillemasage.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageEnum, required this.username, required this.replytex, required this.replaymassegetype, required this.righttswipe
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum messageEnum;
  final String username;
  final String replytex;
  final VoidCallback righttswipe;
  final MessageEnum replaymassegetype;


  @override
  Widget build(BuildContext context) {
    final isreply = replytex.isNotEmpty;
    return SwipeTo(
      onRightSwipe: (details) => righttswipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 25,
                  ),
                  child: Column(
                    children: [
                      if(isreply)...[
                        Text(username,style: TextStyle(fontWeight: FontWeight.bold),),
                        displyfillemassage(massage: replytex, massegeEnum: replaymassegetype)
                      ],
                      displyfillemassage(massage: message, massegeEnum: messageEnum),
                    ],
                  )
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}