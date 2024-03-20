import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class usermodle{
  final String name;
  final String phonenumber;
  final String uid;
  final List<String> groupid;
  final bool isonline;
  final String profilepick;

  usermodle({required this.name, required this.phonenumber, required this.uid, required this.groupid, required this.isonline, required this.profilepick});
 static  usermodle usermodleFromJson(Map<String, dynamic> json) => usermodle(
    name: json['name'] as String,
    phonenumber: json['phonenumber'] as String,
    uid: json['uid'] as String,
    groupid:
    (json['groupid'] as List<dynamic>).map((e) => e as String).toList(),
    isonline: json['isonline'] as bool,
    profilepick: json['profilepick'] as String,
  );

  Map<String, dynamic> usermodleToJson() => {
    'name':name,
    'phonenumber': phonenumber,
    'uid': uid,
    'groupid': groupid,
    'isonline': isonline,
    'profilepick': profilepick,
  };

 //  Map<String , dynamic> tomap(){
 // return {
 //   'name' : name,
 //   'phonenumber' : phonenumber,
 //   'uid'  : uid,
 //   'groupid' : groupid,
 //   'isonline' : isonline,
 //   'profilepick' : profilepick,
 // };}


//   factory usermodle (Map<String, dynamic>map){
//
// usermodle(
//     name: map['name']??"",
//     phonenumber: map['phonenumber']??'',
//     uid: map['uid']??'',
//     groupid: map['groupid']??'',
//     isonline: map['isonline']??'',
//     profilepick: map['profilepick']);
//
// }
}