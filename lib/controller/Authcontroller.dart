import 'dart:io';
import 'package:whatsap/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/Repostryauth.dart';

final Authcontrolerprovider = Provider((ref) {
  final authcontroller = ref.watch(authRepostry);
  return Authcontroller(authcontroler: authcontroller,ref: ref);
}

);
final userdataprovider = FutureProvider((ref){
  final authconntroller = ref.watch(Authcontrolerprovider);
  return authconntroller.getusercurrunt();
}

);

class Authcontroller{
  final Repositryauth authcontroler;
  final ProviderRef ref;

  Authcontroller({required this.authcontroler,required this.ref });

  void singnwithphone(BuildContext context, String phoneNumber){
    authcontroler.signWithPhone(context, phoneNumber);
  }
  void veriopt(BuildContext context , String verificationid , String useropt){

    authcontroler.verifyOTP(context, verificationid, useropt);

  }
  void savedatatofirebase(String name , File? pickimage,BuildContext context){
    authcontroler.saveUserDataToFirebase(context, name, ref, pickimage);

  }
  Future<usermodle?> getusercurrunt() async{
    usermodle? user = await  authcontroler.getCurrentUser();
    return user;
  }
  Stream<usermodle> usardata(String userid){
    return  authcontroler.userdata(userid);
  }
  void getonline(bool online){
    return authcontroler.getonline(online);

  }

}