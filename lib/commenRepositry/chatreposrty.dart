import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/firestoragerepositry.dart';
import 'package:whatsap/model/chat.dart';
import 'package:whatsap/model/group.dart';
import 'package:whatsap/model/massege.dart';
import 'package:whatsap/model/user.dart';
import 'package:uuid/uuid.dart';
import 'commenRepositry.dart';
import '../model/chatcontect.dart';

import '../enume/enum.dart';
final chatrepositryprovider = Provider((ref) =>
    chatrepositry(firestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance)
);

class chatrepositry {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  chatrepositry({required this.firestore, required this.firebaseAuth});
  Stream<List<ChatContact>> getcontect(){
   return
     firestore
        .collection('User')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
         List<ChatContact> contect = [];
         for(var ducoment  in event.docs){
           final usercontactdata = await ChatContact.fromMap(ducoment.data()!);
           final userdata = await firestore.collection('User').doc(usercontactdata.contactId).get();
           final user = await usermodle.usermodleFromJson(userdata.data()!);
           contect.add(ChatContact(name: user.name, profilePic: user.profilepick, contactId:usercontactdata.contactId, timeSent:usercontactdata.timeSent , lastMessage: usercontactdata.lastMessage));

         }
         return contect;

     }

     );
  }
  Stream<List<Groupmodle>> groupchat(){
   return
     firestore
        .collection('group')
         .snapshots()
        .asyncMap((event)  {
         List<Groupmodle> groups = [];
         for(var ducoment  in event.docs){
           var groupdata =  Groupmodle.fromMap(ducoment.data()!);
          if(groupdata.membersUid.contains(firebaseAuth.currentUser!.uid)){
            groups.add(groupdata);

          }
         }
         return groups;

     }

     );
  }

  void saveddatausersubcollection(
      usermodle sanduserdata,
      usermodle resiveruserdata,
      String text,
      DateTime timesant,
      String resiveruid,
      bool isgroup
      ) async {
    if(isgroup){
      await firestore.collection('group').doc(resiveruid).update({
      'lastMessage' : text,
        'timeSent' : DateTime.now().millisecondsSinceEpoch

      });
    }else {
    final reciverchatuserdata = chatmodel(
        contectid: resiveruid,
        name: sanduserdata.name,
        profilepic: sanduserdata.profilepick,
        timesant: timesant,
        lastmassege: text);

           await firestore
               .collection('User')
               .doc(firebaseAuth.currentUser!.uid)
               .collection('chats')
               .doc(resiveruid)
               .set(
             reciverchatuserdata.chatmodelToJson(),
           );

           final sanderuserdata = chatmodel(
               contectid: resiveruid,
               name: resiveruserdata.name,
               profilepic: resiveruserdata.profilepick,
               timesant: timesant,
               lastmassege: text);
           await firestore
               .collection('User')
               .doc(resiveruid)
               .collection('chats')
               .doc(firebaseAuth.currentUser!.uid)
               .set(
             sanderuserdata.chatmodelToJson(),
           );
         }
  }

  Stream<List<massegemodle>> getmassege(String receveruid){
    return   firestore.collection('User').
    doc(firebaseAuth.currentUser!.uid).
    collection('chats').
    doc(receveruid).
    collection('massages').
    orderBy('timesand').
    snapshots().
    asyncMap((event) async{
      List<massegemodle> maseges = [];
      for(var ducoment in event.docs){
        final masege = massegemodle.massegemodleFromJson(ducoment.data()!);
        maseges.add(masege);
      }
      return maseges;


    });

  }
  Stream<List<massegemodle>> getgroupmassege(String groupid){
    return   firestore.collection('group').
    doc(groupid).
    collection('chats').
    orderBy('timesand').
    snapshots().
    asyncMap((event) async{
      List<massegemodle> maseges = [];
      for(var ducoment in event.docs){
        final masege = massegemodle.massegemodleFromJson(ducoment.data()!);
        maseges.add(masege);
      }
      return maseges;
    });

  }

  void masegetomassagesubcollection(
      String taxt,
      DateTime timesant,
      String massegid,
      MessageEnum massegetype,
      String reciveruid,
      String username,
      MessageReply? messageReply,
      String senderUsername,
      String? recieverUserName,
      bool isgroup
      ) async {
      final massegedataforrec = massegemodle(
          sanderid:firebaseAuth.currentUser!.uid,
          receiverid: reciveruid,
          type: massegetype,
          masssegid: massegid,
          timesand: timesant,
          isSeen: false,
          txt: taxt,
          messagereply: messageReply==null?'':messageReply.message,
          messagereplaytype: messageReply==null? MessageEnum.text : messageReply.messageEnum,
         replayto:  messageReply==null ? '': messageReply.isMe?senderUsername:recieverUserName??''
      );
      if(isgroup){
        await firestore.collection('group').doc(reciveruid).collection('chats').doc(massegid).set(massegedataforrec.massegemodleToJson());

      }

      await firestore.collection('User').doc(firebaseAuth.currentUser!.uid).collection('chats').doc(reciveruid).collection('message').doc(massegid).set(massegedataforrec.massegemodleToJson());
      await firestore.collection('User').doc(reciveruid).collection('chats').doc(firebaseAuth.currentUser!.uid).collection('message').doc(massegid).set(massegedataforrec.massegemodleToJson());



  }

  void sandmassege(String text, String reciveruid,
      usermodle sanderus, BuildContext context,MessageReply? messageReply,bool isgroup) async {
    try {
      final timesant = DateTime.now();
      usermodle? receiveruserdata;

      if(!isgroup) {
        final userdatamap = await firestore.collection('User')
            .doc(reciveruid)
            .get();
        receiveruserdata = usermodle.usermodleFromJson(userdatamap.data()!);
      }
      final massegid = const Uuid().v1();
      saveddatausersubcollection(
          sanderus, receiveruserdata!, text, timesant, reciveruid,isgroup);
      masegetomassagesubcollection(text, timesant, massegid, MessageEnum.text,
          reciveruid, receiveruserdata.name,messageReply,receiveruserdata.name,sanderus.name,isgroup);
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('your data not sant')));
    }
  }
  void  sandfille(
      BuildContext context,
      File file,
      String reciverid,
      usermodle Sanderuser,
      ProviderRef ref,
      MessageEnum masegeenum,
      MessageReply? messageReply,
      bool isgroup
      )async{
    try {
      var timesand = DateTime.now();
      var massageid = Uuid().v1();
    final imageurl = await  ref.read(firestoragecontrollerprovider).storefiletofirebase(
          'chats/${masegeenum.type}/${Sanderuser
              .uid}/${reciverid}/${massageid}', file);
      usermodle? reciveruserdata;
      if(!isgroup) {
        final userdata = await firestore.collection('User')
            .doc(reciverid)
            .get();
        reciveruserdata = usermodle.usermodleFromJson(userdata.data()!);
      }
      String contactmas;
      switch(masegeenum){
        case MessageEnum.image:
          contactmas = '/📷image';
          break;
        case MessageEnum.video:
          contactmas = '/📸vidio';
          break;
        case MessageEnum.audio:
          contactmas = '/';
        case MessageEnum.gif:
          contactmas = 'GIF';
          break;
        default:
          contactmas = 'GIF';
      }

      saveddatausersubcollection(Sanderuser, reciveruserdata!,contactmas , timesand, reciverid,isgroup);
      masegetomassagesubcollection(imageurl, timesand, massageid, masegeenum, reciverid, messageReply as String, Sanderuser.name as MessageReply?, reciveruserdata!.name,Sanderuser.name,isgroup);

    }catch (error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('your fille nit sand')));
      
    } 
    
  }

  void sandGifmassage(String gifurl, String reciveruid,
      usermodle sanderus, BuildContext context,MessageReply? messageReply, bool isgroup) async {
    try {
      final timesant = DateTime.now();
      usermodle? receiveruserdata;
      if(!isgroup) {
        final userdatamap = await firestore.collection('User')
            .doc(reciveruid)
            .get();
        receiveruserdata = usermodle.usermodleFromJson(userdatamap.data()!);
      }
      final massegid = const Uuid().v1();
      saveddatausersubcollection(
          sanderus, receiveruserdata!, 'Gif', timesant, reciveruid,isgroup);
      masegetomassagesubcollection(gifurl, timesant, massegid, MessageEnum.gif,
          reciveruid, receiveruserdata.name, sanderus.name as MessageReply?,messageReply as String,sanderus.name,isgroup);
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('your data not sant')));
    }
  }
  void setchatmessagseen(BuildContext context , String receiveduid, String messageid)async{
   try{
     await firestore.collection('User').
     doc(firebaseAuth.currentUser!.uid).
     collection('chats').
     doc(receiveduid).
     collection('message').
    doc(messageid).
    update({'isSeen' : true});
await firestore.collection('User').
     doc(receiveduid).
     collection('chats').
     doc(firebaseAuth.currentUser!.uid).
     collection('message').
    doc(messageid).
    update({'isSeen' : true});




   }catch(err) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('this message are not seend')));

   }

   }

  }



