import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/firestoragerepositry.dart';
import 'package:whatsap/Screen/Tabbarscreen.dart';
import 'package:whatsap/Screen/otp.dart';
import 'package:whatsap/Screen/userinformation.dart';
import 'package:whatsap/model/user.dart';

final authRepostry = Provider((ref) => Repositryauth(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class Repositryauth {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Repositryauth({required this.firestore, required this.auth});

  void signWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(
              'Verification failed --------------------------------------------------$e');
        },
        codeSent: ((String verificationId, int? resantToken) async {}),
        codeAutoRetrievalTimeout: (verificationId) {
          Navigator.of(context).pushNamed(OTP.routname,
              arguments: {'verificationId': verificationId});
        },
      );
    } on FirebaseAuthException catch (e) {
      print("Firebase auth error: $e");
    }
  }

  void verifyOTP(
      BuildContext context, String verificationId, String userOTP) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushNamed(userinformation.routname);
    } on FirebaseAuthException catch (e) {
      print('Error verifying OTP: $e');

      String errorMessage = "Error verifying OTP. Please try again.";

      if (e.code == 'invalid-verification-code') {
        errorMessage = "Invalid OTP. Please enter the correct code.";
      } else if (e.code == 'invalid-verification-id') {
        errorMessage = "Invalid verification ID. Please restart the process.";
      }

      // Show the error to the user (you may want to use a different UI feedback mechanism)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging purposes
      print('Unexpected error: $e');
      print('StackTrace: $stackTrace');
    }
  }


  Future<usermodle?> getCurrentUser() async {
    var currentUser = auth.currentUser;
    if (currentUser != null) {
      var userData =
          await firestore.collection('User').doc(currentUser.uid).get();
      if (userData.data() != null) {
        return usermodle.usermodleFromJson(userData.data()!);
      }
    }
    return null;
  }

  void saveUserDataToFirebase(BuildContext context, String name,
      ProviderRef ref, File? profilePic) async {
    try {
      final uid = auth.currentUser!.uid;
      String photoUrl =
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';
      if (profilePic != null) {
        photoUrl = await ref
            .read(firestoragecontrollerprovider)
            .storefiletofirebase('profilepic/$uid', profilePic);
      }

      var user = usermodle(
        name: name,
        phonenumber: auth.currentUser!.phoneNumber!,
        uid: uid,
        groupid: [],
        isonline: true,
        profilepick: photoUrl,
      );
      await firestore.collection('User').doc(uid).set(user.usermodleToJson());
      Navigator.of(context).pushNamed(ContectList.routname);
    } on FirebaseAuthException catch (err) {
      print('Error saving user data: $err');
    }
  }

  Stream<usermodle> userdata(String userid) {
    return firestore
        .collection('User')
        .doc('userid')
        .snapshots()
        .map((event) => usermodle.usermodleFromJson(event.data()!));
  }
  void getonline(bool online)async{
    await firestore.collection('User').doc(auth.currentUser!.uid).update({
      'isonline': online,
    });

  }
}
