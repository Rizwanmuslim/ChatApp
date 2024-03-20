import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/controller/Authcontroller.dart';

class OTP extends ConsumerWidget {
  static const routname = '/otp';
  String extractveriid = '';
 void verifiop(BuildContext context , WidgetRef ref,String useropt ){

   ref.read(Authcontrolerprovider).veriopt(context, extractveriid, useropt);


 }


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final veriid = ModalRoute.of(context)!.settings.arguments as Map<String , String>;
    extractveriid = veriid['verificationId']??"";
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify your number'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text('we have a sand sms on number'),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '------',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if(value.length == 6)
                  verifiop(context, ref, value.toString());
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
}
