

import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/Repostryauth.dart';
import 'package:whatsap/commenRepositry/firestoragerepositry.dart';
import 'package:whatsap/commenRepositry/chatreposrty.dart';
import 'package:whatsap/commenRepositry/commenRepositry.dart';
import 'package:whatsap/controller/Authcontroller.dart';
import 'package:whatsap/model/chatcontect.dart';
import 'package:whatsap/model/group.dart';
import 'package:whatsap/model/massege.dart';

import '../enume/enum.dart';

final chatcontrollerprovider = Provider((ref) {
  final chatcontrollerr = ref.watch(chatrepositryprovider);
  return chatcontroller(Chatrepositry: chatcontrollerr, ref: ref);

});

class chatcontroller{

  final chatrepositry Chatrepositry;
  final  ProviderRef ref;

  chatcontroller({required this.Chatrepositry, required this.ref});
  Stream<List<massegemodle>> getmassege(String receiverid){
    return Chatrepositry.getmassege(receiverid);
  }Stream<List<massegemodle>> getgroupmassege(String grouid){
    return Chatrepositry.getgroupmassege(grouid);
  }

  Stream<List<ChatContact>> getchatcontect(){
   return Chatrepositry.getcontect();
  }Stream<List<Groupmodle>> groupchat(){
   return Chatrepositry.groupchat();
  }

  void sandtextmasseg(BuildContext context ,String txt , String receiverid ,bool isgroup)
  {
    final messagereply = ref.read(messageReplyProvider);
ref.read(userdataprovider).
whenData((value)=>Chatrepositry.
sandmassege(txt, receiverid, value!, context,messagereply,isgroup)
);
    ref.read(messageReplyProvider.state).update((state) => null);

  }
  void sandfile(BuildContext context,File file , String reciverid,MessageEnum massegenum,bool isgroup )
  {
    final messagereply = ref.read(messageReplyProvider);

    ref.read(userdataprovider).
    whenData((value) => Chatrepositry.sandfille(context, file, reciverid, value!, ref,massegenum,messagereply,isgroup));
    ref.read(messageReplyProvider.state).update((state) => null);


  }

  void snadgifmassege(BuildContext context,String gif , String recivedid ,bool isgroup){

    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gif.lastIndexOf('-') + 1;
    String gifUrlPart = gif.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ref.read(userdataprovider).whenData((value) => Chatrepositry.sandGifmassage(newgifUrl , recivedid, value!, context, messageReply,isgroup));
    ref.read(messageReplyProvider.state).update((state) => null);

  }
  void setmessageseen(BuildContext context , String receiverid, String messageid){
    Chatrepositry.setchatmessagseen(context, receiverid, messageid);
  }



}