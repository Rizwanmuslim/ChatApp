import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/color.dart';
import 'package:whatsap/controller/Status_repostry_controller.dart';
class confirmstatusscreen extends ConsumerWidget {
static const routname = '/confirmscreen';
File? file;
   void addsatus(BuildContext context,WidgetRef ref){
     ref.read(statusrepostrycontrollerprovider).addstatus(context, file!);
     Navigator.pop(context);
   }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
     file =  ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      body: Center(
        child: AspectRatio(
            aspectRatio: 9/16,
            child: Image.file(file!)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done,size: 30,),
        onPressed: () =>addsatus(context,ref),
        backgroundColor: tabColor,
      ),
    );
  }
}
