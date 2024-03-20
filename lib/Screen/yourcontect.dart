import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/controller/contectcontroller.dart';


class contect extends ConsumerWidget {
  static const routname = '/contectrepositry';
  void slectnum (BuildContext context , Contact slectcontant,WidgetRef ref){
    ref.read(slectcontactcontrollerprovider).slectNub(slectcontant, context);
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your Contect',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black26,
      ),
      body: ref.read(contectrepositrycontrollerprovider).when(data: (contectlist) =>ListView.builder(
        itemCount: contectlist.length,
        itemBuilder: (context, index) {
          final contact = contectlist[index];
          return InkWell(
            onTap: () => slectnum(context,contact,ref),
            child: ListTile(
              title: Text(contact.displayName),
              leading: contact.photo == null ? null:CircleAvatar(
                backgroundImage: MemoryImage(contact.photo!),
                radius: 30,
              ),
            ),
          );
        },

      ), error: (error, stackTrace) {
        print('tarce-------------------------_$error');
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      },),


    );
  }
}
