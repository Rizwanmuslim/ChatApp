import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsap/commenRepositry/firestoragerepositry.dart';
import 'package:whatsap/model/status_user.dart';
import 'package:whatsap/model/user.dart';
final satutsrpositryprovider = Provider((ref) {
     return  statusrepostry(firebaseAuth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance, ref: ref);

});

class statusrepostry {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  statusrepostry(
      {required this.firebaseAuth, required this.firestore, required this.ref});
  void uploadstatus(
      {required String username,
      required String profilpic,
      required File statusimage,
      required String phonenumber,
      required BuildContext context}) async {
   try{ final statusid = await Uuid().v1();
    String userid = firebaseAuth.currentUser!.uid;
    String imageurl = await  ref.read(firestoragecontrollerprovider)
        .storefiletofirebase('status/$statusid$userid', statusimage);
    List<Contact> contacts = [];

    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true)
      as List<Contact>;
    }
      List<String> whocontectsee = [];
      for (int i = 0; i < contacts.length; i++) {
        final userdatafirbase = await firestore
            .collection('User')
            .where('phonenumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll('', '')).get();
           if(userdatafirbase.docs.isNotEmpty){
             final userdata = usermodle.usermodleFromJson(userdatafirbase.docs[0].data());
             whocontectsee.add(userdata.uid);
           }
      }
      List<String> statusimageurl = [];
      var snapshotstatus = await firestore.collection('Status').where('uid' ,isEqualTo:  firebaseAuth.currentUser!.uid).get();
      if(snapshotstatus.docs.isNotEmpty){
        Status status = Status.fromMap(snapshotstatus.docs[0].data());
        statusimageurl = status.photoUrl;
        statusimageurl.add(imageurl);
        await firestore.collection('Status').doc(snapshotstatus.docs[0].id).update({
          'photoUrl' : statusimageurl

        });
        return;
          }
         statusimageurl = [imageurl];
      final statut = Status(uid: userid, username: username,
    phoneNumber: phonenumber,
    photoUrl:  statusimageurl,
    createdAt: DateTime.now(),
    profilePic: profilpic,
    statusId: statusid,
    whoCanSee: whocontectsee);
     await   firestore.collection('Status').doc(statusid).set(statut.toMap());
   }catch(err){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pleas can be retry satus upload')));
   }
  }
  Future<List<Status>> getstatus(BuildContext context) async{
    List<Status> statusdata = [];
   try {
     List<Contact> contacts = [];

     if (await FlutterContacts.requestPermission()) {
       contacts = await FlutterContacts.getContacts(withProperties: true)
       as List<Contact>;
     }
     for (int i = 0; i < contacts.length; i++) {
       final snapshotdata = await firestore
           .collection('User')
           .where('phonenumber',
           isEqualTo: firebaseAuth.currentUser!.uid.replaceAll('', ''))
           .where(
           'createdAt',
           isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)))
           .get();
       for (var tempdata in snapshotdata.docs) {
         Status tepmstatus = Status.fromMap(tempdata.data());
         if (tepmstatus.whoCanSee.contains(firebaseAuth.currentUser!.uid)){
           
           statusdata.add(tepmstatus);
         }
       }
     }
   }catch(err){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pleas try again')));
   }
   return statusdata;

    }
  }


