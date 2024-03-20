
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/contect_repositry.dart';


 final contectrepositrycontrollerprovider = FutureProvider((ref){
   final contectrepostry = ref.watch(contectrepositryprovider);
   return contectrepostry.getusercontact();

 });
 final slectcontactcontrollerprovider = Provider((ref) {
   final slectcontectrepositry = ref.watch(contectrepositryprovider);
   return slectcontact(sleactnum: slectcontectrepositry, ref: ref);
 });

 class slectcontact{
   final contectrepositry sleactnum;
   final ProviderRef ref;

  slectcontact({required this.sleactnum,required this.ref});

void slectNub(Contact slectNum , BuildContext context){

  sleactnum.slectcontect(slectNum, context);
}

 }