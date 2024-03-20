import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsap/commenRepositry/commenRepositry.dart';
import 'package:whatsap/controller/chatcontroller.dart';
import 'package:whatsap/enume/enum.dart';
import 'package:whatsap/model/massege.dart';
import 'package:whatsap/widget/my_chatmassege.dart';
import 'package:whatsap/widget/other_chatmassege.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ChatList extends ConsumerStatefulWidget {
  final String uid;
  final bool  isgroup;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   ChatList({Key? key,required this.uid,required this.isgroup}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController massegcontroller = ScrollController();
  @override
  void dispose() {
    massegcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  void swipmasseg(
      String message,
      bool isMe,
      MessageEnum messageEnum
      ){
   ref.read(messageReplyProvider.state).update((state) => MessageReply(message, isMe, messageEnum));
  }

  @override
  Widget build(BuildContext context ) {
    return StreamBuilder<List<massegemodle>>(
      stream: widget.isgroup ?ref.watch(chatcontrollerprovider).getgroupmassege(widget.uid): ref.watch(chatcontrollerprovider).getmassege(widget.uid),
      builder:(context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          massegcontroller.jumpTo(massegcontroller.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: massegcontroller,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final masege = snapshot.data![index];
            if(!masege.isSeen && masege.receiverid ==  FirebaseAuth.instance.currentUser!.uid ){
              ref.read(chatcontrollerprovider).setmessageseen(context, widget.uid, masege.masssegid);

            }
            if (masege.sanderid == widget.firebaseAuth.currentUser!.uid) {
              return MyMessageCard(
                message: masege.txt,
                date: DateFormat.Hm().format(masege.timesand),
                messageEnum: masege.type,
                replaymassegetype: masege.messagereplaytype,
                replytex: masege.messagereply,
                username: masege.replayto,
                leaftswipe: () => swipmasseg(masege.txt,true,masege.type),
                isSeen: masege.isSeen,
              );
            }
            return SenderMessageCard(
              message: masege.txt,
              date: DateFormat.Hm().format(masege.timesand),
              messageEnum: masege.type,
              replaymassegetype: masege.messagereplaytype,
              replytex: masege.messagereply,
              username: masege.replayto,
              righttswipe: () => swipmasseg(masege.txt,false, masege.type),
            );
          },
        );
      }
    );
  }
}