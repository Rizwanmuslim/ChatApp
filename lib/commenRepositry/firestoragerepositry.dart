import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final firestoragecontrollerprovider = Provider((ref) => comonfirestorage(FirebaseStorage.instance));

class comonfirestorage{

  final FirebaseStorage firebaseStorage;
  comonfirestorage (this.firebaseStorage);

  Future<String> storefiletofirebase( String ref , File file )async {
    final uploadtask = firebaseStorage.ref().child(ref).putFile(file);
    final snap  = await uploadtask;
     final downloadurl = await snap.ref.getDownloadURL();
     return downloadurl;

  }
}