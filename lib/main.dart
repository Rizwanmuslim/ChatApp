import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/Screen/Creat_groupscreen.dart';
import 'package:whatsap/Screen/Statuscreen.dart';
import 'package:whatsap/Screen/chat.dart';
import 'package:whatsap/Screen/Tabbarscreen.dart';
import 'package:whatsap/Screen/con_status_screen.dart';
import 'package:whatsap/Screen/firstscreen.dart';
import 'package:whatsap/Screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsap/Screen/otp.dart';
import 'package:whatsap/Screen/userinformation.dart';
import 'package:whatsap/Screen/yourcontect.dart';
import 'firebase_options.dart';
import 'package:whatsap/controller/Authcontroller.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true); // For debug mode

   runApp( const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home:ref.watch(userdataprovider).when(data:(data) {
        if(data == null){
           return splashscreen();
        }
        return ContectList();
      }, error: (error, stackTrace) {
        print('er---------------------------------$error');
      }, loading:  () {
       return Center(
          child: CircularProgressIndicator(),
        );
      },),
        routes: {
        Chat.routname:(context) =>Chat(),
          Login.routname: (context) => Login(),
          OTP.routname: (context) => OTP(),
          userinformation.routname:(context) => userinformation(),
          ContectList.routname:(context) => ContectList(),
          contect.routname:(context) => contect(),
          Statusscreen.routname:(context) => Statusscreen(),
          confirmstatusscreen.routname:(context) => confirmstatusscreen(),
          creatgroupscreen.routname:(context) =>  creatgroupscreen()

    },
    );
  }
}
