import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/Screen/chat.dart';
import 'package:whatsap/model/user.dart';

final  contectrepositryprovider = Provider((ref) => contectrepositry(firestore: FirebaseFirestore.instance));


class contectrepositry{

  final FirebaseFirestore firestore;

  contectrepositry({required this.firestore});

  Future<List<Contact>>  getusercontact() async{
    List<Contact> contacts = [];

    try{
      if(await  FlutterContacts.requestPermission()){
        contacts = await FlutterContacts.getContacts(withProperties: true)as List<Contact>;

      }
    }catch(err){
      print('contect--------------------------------------------------$err');


    }
    return contacts;

  }
  void slectcontect(Contact slectcontect , BuildContext context) async{
   try {
     var usercolllect = await firestore.collection('User').get();
     bool isfount = false;
     for (var document in usercolllect.docs) {
       final userdate = usermodle.usermodleFromJson(document.data());

       String slectphoneNum = slectcontect.phones[0].number.replaceAll('', '');
       if (slectphoneNum == userdate!.phonenumber) {
         isfount = true;
         print(
             'this is an exist++++++++++++++++++++++++++++++++++++++++++++++++++');
         Navigator.of(context).pushNamed(Chat.routname,arguments: {'Name' : userdate.name,'uid' : userdate.uid});
       }
       if (!isfount) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This number is not exist')));
       }
     }

   } catch(error){
     print('slect +++++++++++++++++++++++++++++++++++++++++++++++$error');

   }

    }


  }


