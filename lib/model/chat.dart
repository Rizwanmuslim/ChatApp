import 'package:json_annotation/json_annotation.dart';

class chatmodel{
 final  String contectid;
 final String name;
 final  String profilepic;
 final DateTime timesant;
 final String lastmassege;

  chatmodel({required this.contectid, required this.name, required this.profilepic, required this.timesant, required this.lastmassege});


 static chatmodel chatmodelFromJson(Map<String, dynamic> json) => chatmodel(
  contectid: json['contectid'] as String,
  name: json['name'] as String,
  profilepic: json['profilepic'] as String,
  timesant: DateTime.parse(json['timesant'] as String),
  lastmassege: json['lastmassege'] as String,
 );

 Map<String,dynamic> chatmodelToJson() =><String, dynamic>{
  'contectid':contectid,
  'name': name,
  'profilepic': profilepic,
  'timesant': timesant.toIso8601String(),
  'lastmassege': lastmassege,
 };



}