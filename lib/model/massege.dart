import 'package:json_annotation/json_annotation.dart';

import '../enume/enum.dart';

class massegemodle{
  final String sanderid;
  final String receiverid;
  final MessageEnum type;
  final String masssegid;
  final DateTime timesand;
  final bool isSeen;
  final String txt;
  final String messagereply;
  final String replayto;
  final MessageEnum messagereplaytype;

  massegemodle( {required this.sanderid, required this.receiverid, required this.type,
    required this.masssegid, required this.timesand,
    required this.isSeen,required this.txt,
    required this.messagereply,required this.messagereplaytype,
    required this.replayto});
   static massegemodle massegemodleFromJson(Map<String, dynamic> json) => massegemodle(
    sanderid: json['sanderid'] as String,
    receiverid: json['receiverid'] as String,
    type: (json['type'] as String).toEnum(),
    masssegid: json['masssegid'] as String,
    timesand: DateTime.parse(json['timesand'] as String),
     isSeen: json['isseen'] as bool,
     txt: json['txt'] as String,
     messagereplaytype: (json['messagereplytype'] as String).toEnum(),
     messagereply: json['messagereply'] as String,
     replayto: json['replyto'] as String,

  );

     Map<String, dynamic> massegemodleToJson() =>
      <String, dynamic>{
        'sanderid': sanderid,
        'receiverid': receiverid,
        'type': type.type,
        'masssegid': masssegid,
        'timesand': timesand.toIso8601String(),
        'isseen' :  isSeen,
        'txt' : txt,
        '':messagereply,
        'messagereplytype' : messagereplaytype,
        'messagereply' :messagereply,
        'replyto' : replayto
      };



}