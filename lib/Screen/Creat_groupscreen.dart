import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/controller/Groupcontroller.dart';
import 'package:whatsap/utils/utilsfnction.dart';
import 'package:whatsap/widget/slectcontactgroup.dart';


class creatgroupscreen extends ConsumerStatefulWidget {
  static const routname = '/creatagroup';
  const creatgroupscreen({super.key});

  @override
  ConsumerState<creatgroupscreen> createState() => _creatgroupscreenState();
}

class _creatgroupscreenState extends ConsumerState<creatgroupscreen> {
  final groupnametextcontroller = TextEditingController();
  void creatgroup(){
    if(groupnametextcontroller.text.trim().isNotEmpty && image != null){
      ref.read(groupcontrollerprovider).creatgroup(groupnametextcontroller.text, image!, context,
          ref.read(slectcontectgrp as ProviderListenable<List<Contact>>));
      ref.read(slectcontectgrp.state).update((state) => []);
      Navigator.pop(context);
    }


  }

  File? image;
  void pickimage()async{
    final pickimage = await pickimagegallery(context);
    setState(() {
      image = pickimage;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creat Group'),
        backgroundColor: Colors.grey,
      ),
      body:Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              image != null ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(image! as String),

              ):CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),

              ),
              Positioned(
                  top: 50,
                  left: 55,
                  child: IconButton(onPressed:pickimage, icon: Icon(Icons.camera_alt_outlined)))

            ],
          ),
             Padding(

               padding: const EdgeInsets.all(10.0),
               child: TextField(
                 controller: groupnametextcontroller,
                 decoration: InputDecoration(
                   labelText: 'enter the name group',

                 ),
               ),
             ),
          Container(
            alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10.0),
              child: Text('Slect contect')),
          slectcontectgroup()
            ],
            
          ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: creatgroup,
        backgroundColor: Colors.green,
      ),
          

        
      );
  }
}


