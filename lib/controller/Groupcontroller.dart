
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/grouprepostry.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
final groupcontrollerprovider = Provider((ref){
  final Grouprepostry = ref.read(grouprepositryprovider);
  return groupcontrollerrepositry(Grouprepositry: Grouprepostry, ref: ref);

});

class groupcontrollerrepositry{
  final grouprepositry Grouprepositry;
  final ProviderRef ref ;

  groupcontrollerrepositry({required this.Grouprepositry, required this.ref});
  void creatgroup(String groupname , grouppickpro , BuildContext context , List<Contact> groupslectcontect){
    Grouprepositry.creatGroup(groupname, grouppickpro, groupslectcontect, context);

  }


}