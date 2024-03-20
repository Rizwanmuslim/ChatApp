import 'package:flutter/material.dart';
import 'package:whatsap/Screen/login.dart';
import 'package:whatsap/color.dart';

class splashscreen extends StatelessWidget {
 elavatedbotton(String text,VoidCallback onpress){
  return ElevatedButton(onPressed: onpress, child: Text(text,style: TextStyle(color: Colors.white),
  ),
    style: ElevatedButton.styleFrom(
      backgroundColor: tabColor
    ),

  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: messageColor,
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.only(left: 20),
          child: Column(
        
            children: [
              SizedBox(height: 60,),
              Text('Welcome to whatsapp',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),),
              SizedBox(height: 80,),
              Container(
        
                child: ClipRRect(child: Image.asset('asset/bg.png',color: tabColor,width: 350,height: 350,)),
              ),
              SizedBox(height:100),
              Text('Read our private policy.tap to "agree and continue"\n to accept the terms of services',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
               SizedBox(height: 20,),
             Container(
               height: 50,
               width: 300,
               color: tabColor,
               child: elavatedbotton('agree and continoue', () { Navigator.of(context).pushNamed(Login.routname); }),
             ),
        
            ],
          ),
        ),
      ),
      
    );
  }
}
