import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:whatsap/controller/Authcontroller.dart';

class  userinformation extends ConsumerStatefulWidget {
  static const routname = '/userinfo';

  @override
 ConsumerState<userinformation> createState() => _userinformationState();
}

class _userinformationState extends ConsumerState<userinformation> {
  final namecontroller = TextEditingController();
  File? image;

  void pickimage() async{
     var imaage = ImagePicker().pickImage(source: ImageSource.gallery);
     setState(() {
       image = imaage as File;
     });



     }
  void savedata()async{
    final name = namecontroller.text.trim();
    if(name.isNotEmpty){

      ref.read(Authcontrolerprovider).savedatatofirebase(name, image, context);

    }

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Colors.black87,

      body: Padding(

        padding: const EdgeInsets.only(left:40 ),
        child: Column(


          children: [
            SizedBox(height: 100,),
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
            SizedBox(height: 40,),
            Row(
              children: [
                SizedBox(
                  width: size.width*0.7,
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: 'enter your name'
                    ),
                  ),
                ),
                IconButton(onPressed: savedata, icon: Icon(Icons.done))
              ],
            )



          ],
        ),
      )
    ) ;
  }
}
