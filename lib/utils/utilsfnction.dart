



import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?>  pickimagegallery(BuildContext context)async{
  File? image;
  try {
    final imagepick = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (image != null) {
      image = File(imagepick!.path);
    }
  }catch(err){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pleas try agian')));
  }
  return image;

}
Future<File?>  pickvideogallery(BuildContext context)async{
  File? vedio;
  try {
    final pickvedio = await ImagePicker().pickVideo(
        source: ImageSource.gallery);
    if (vedio != null) {
      vedio = File(pickvedio!.path);
    }
  }catch(err){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pleas try agian')));
  }
  return vedio;

}
Future<GiphyGif?> pickgif(BuildContext context) async{
  GiphyGif? gif;
 try {
   gif = await Giphy.getGif(context: context, apiKey: 'zl0ZoqNJnc0VqFk56s8FmXWvPUfoej8v');

 }catch(err){
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pleas try agin')));

 }
 return gif;
}