import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/Screen/otp.dart';
import '../controller/Authcontroller.dart';

import '../color.dart';

class Login extends ConsumerStatefulWidget {
  static const routname = '/login';

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final phonecontroller = TextEditingController();
  Country? country;
  FirebaseAuth  _auth = FirebaseAuth.instance;
  var _islogin = true;
@override
  void dispose() {
  phonecontroller.dispose();
    super.dispose();
  }

  void pikercode(){
    showCountryPicker(
      showPhoneCode: true,
      context: context, onSelect: (Country?  _country) {
      setState(() {
        country = _country ;
      });
    },);


  }
  void sandnumber() async {
    final phoneNumber = phonecontroller.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
         ref.read(Authcontrolerprovider).singnwithphone(context, '+${country!.phoneCode}${phoneNumber}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(46,145 , 14, 100),
        title: Text('Enter your Phone Number',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Column(
            children: [
              SizedBox(height: 70,),
                Text('whatsapp need to vrify your phone number',style: TextStyle(color: Colors.white),),
                TextButton(onPressed: pikercode
                  , child: Text('Pick Country code')),
                 SizedBox(height: 12,),
                  Row(
                     children: [
                       if(country != null)
                         Text('+${country!.phoneCode}',style: TextStyle(color: Colors.white),),
                       SizedBox(width: 10,),
                       SizedBox(
                         width:size.width*0.7,
                         child: TextField(
                           controller: phonecontroller,
                           decoration: InputDecoration(
                             labelText: 'enter phone number',
        
                           ),
                         ),
                       )
                     ],
                   ),
              SizedBox(height: 450,),
        
              InkWell(
                onTap: sandnumber,
                child: Container(
                  color:Color.fromRGBO(50, 155, 15, 100) ,
                  height: 40,
                  width: 70,
                  child: Center(child: Text('Next'),),
                ),
              )
        
        
            ],
          ),
        ),
      ),
    );
  }
}
