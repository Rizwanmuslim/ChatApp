import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsap/commenRepositry/firestoragerepositry.dart';
import '../model/group.dart';
final grouprepositryprovider = Provider((ref) => grouprepositry(firestore: FirebaseFirestore.instance, firebaseAuth:FirebaseAuth.instance, ref: ref));

class grouprepositry{
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  grouprepositry({required this.firestore, required this.firebaseAuth, required this.ref});
  void creatGroup(String Groupname , File Grouppickprofile , List<Contact> groupSlectcontect , BuildContext context) async{


    try{
      List<String> uids = [];
      for(int i = 0 ;i< groupSlectcontect.length; i++ ){
        final usercollection = await firestore.collection('User').where('phonenumber',
            isEqualTo: groupSlectcontect[i].phones[0].number.replaceAll('', '')).get();
        if(usercollection.docs.isNotEmpty && usercollection.docs[0].exists){
         uids.add(usercollection.docs[0].data()['uid']);
           
        }

      }
      var Groupid = const Uuid().v1();
      String grouppickurl = await ref.read(firestoragecontrollerprovider).storefiletofirebase('group/$Groupid', Grouppickprofile);
       Groupmodle groupmodle = Groupmodle(senderId: firebaseAuth.currentUser!.uid, name: Groupname, groupId: Groupid, lastMessage: '', groupPic: grouppickurl, membersUid: [firebaseAuth.currentUser!.uid,...uids], timeSent: DateTime.now());
       await firestore.collection('Group').doc(Groupid).set(groupmodle.toMap());

    }catch(err){}


  }

}