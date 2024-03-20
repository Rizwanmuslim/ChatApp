import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/controller/Authcontroller.dart';
import 'package:whatsap/info.dart';
import 'package:whatsap/model/contect.dart';
import 'package:whatsap/widget/botemchattextfieald.dart';
import 'package:whatsap/widget/chat.dart';

import '../color.dart';

class Chat extends ConsumerWidget {
  static const routname = '/chat';

  String name = '';

  final textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final data = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
       name = data['Name'] ?? '';
    final String uid = data['uid']??'';
    final  bool  isgroup = data['isgroup'] as bool;

    return Scaffold(



      appBar: AppBar(
        title: isgroup ? Text(name) : StreamBuilder(
          stream:ref.read(Authcontrolerprovider).usardata(uid),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
             return  Center(child: CircularProgressIndicator(),);

            }
            return  Column(
              children: [
                Text(name),
                Text(snapshot.data!.isonline?'isonline':'offline')
              ],
            );
          }),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {

          }, icon: Icon(Icons.phone))
        ],
        backgroundColor: appBarColor,
      ),
      body: Container(
           decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage('asset/1.png'), // Replace 'background_image.jpg' with your asset image path
          fit: BoxFit.cover,
          ),
           ),
        child: Column(
          children: [
            Expanded(child: ChatList(uid: uid,isgroup:isgroup ,)),
            Botemtextfield(uid: uid,isgroup: isgroup,)
          ],
        ),
      ),
    );
  }
}
