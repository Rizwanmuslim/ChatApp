


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/status_repostry.dart';
import 'package:whatsap/controller/Authcontroller.dart';
import 'package:whatsap/model/status_user.dart';
final statusrepostrycontrollerprovider = Provider((ref){
  final statusRepostr = ref.read(satutsrpositryprovider);
  return Statusrepostrycontroler(Statusrepostry: statusRepostr, ref: ref);

});

class Statusrepostrycontroler{
  final statusrepostry Statusrepostry;
  final ProviderRef ref;

  Statusrepostrycontroler({required this.Statusrepostry, required this.ref});

  void addstatus(BuildContext context , File file){

    ref.watch(userdataprovider).whenData((value) => Statusrepostry.uploadstatus(username: value!.name, profilpic: value!.profilepick,
        statusimage: file,
        phonenumber: value!.phonenumber, context: context));

  }

Future<List<Status>> getstatus(BuildContext context)async{
    List<Status> Statusdata = await Statusrepostry.getstatus(context);
return Statusdata;
}


}