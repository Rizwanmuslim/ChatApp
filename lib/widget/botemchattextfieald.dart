import 'dart:io';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsap/commenRepositry/commenRepositry.dart';
import 'package:whatsap/controller/chatcontroller.dart';
import 'package:whatsap/utils/utilsfnction.dart';
import 'package:whatsap/widget/MessageReply_prewio.dart';
import '../color.dart';

import '../enume/enum.dart';
class Botemtextfield extends ConsumerStatefulWidget {
  final String uid;
  final bool isgroup;
  const Botemtextfield({Key? key,required this.uid,required this.isgroup}) : super(key: key);

  @override
  ConsumerState<Botemtextfield> createState() => _BotemtextfieldState();
}

class _BotemtextfieldState extends ConsumerState<Botemtextfield> {
  final txtmassegecontroller = TextEditingController();
  final focusenode = FocusNode();
  bool isshowemoji = false;
  FlutterSoundRecorder? soundRecorder;
  bool _isrecorder = false;
  bool _isrecoderinit = true;

  @override
  void initState() {
    soundRecorder = FlutterSoundRecorder();
    openAudio();

    super.initState();
  }
  void showemojicontainer(){
    setState(() {
       isshowemoji = true;

    });
  }
  void hidemoji(){
    setState(() {
      isshowemoji = false;

    });
  }
  void showkeyboard()=>focusenode.requestFocus();
  void hidekeybord()=>focusenode.unfocus();

  void toggllemojishow(){
    if(isshowemoji){
      showkeyboard();
      hidemoji();
    }else{
      hidekeybord();
      showemojicontainer();

    }

  }




  @override
  void dispose() {
    txtmassegecontroller.dispose();
    soundRecorder!.closeRecorder();
    _isrecorder = false;
    super.dispose();
  }

  var _isShowButton = false;

  void textmasseg() async{
    final txt = txtmassegecontroller.text.toString();
    if(_isShowButton){
      ref.read(chatcontrollerprovider).sandtextmasseg(context, txt, widget.uid,widget.isgroup);
      txtmassegecontroller.clear();

    } else{
      final tempdir = await getTemporaryDirectory();
      final path = '${tempdir.path}';
      if(!_isrecoderinit){
        return;
      }
      if(_isrecorder){
         await soundRecorder!.isStopped;
      }else{
        await soundRecorder!.startRecorder(
          toFile: path
        );
      }
      setState(() {
        _isrecorder = !_isrecorder;
      });


    }


  }
  void sandfile(File file, MessageEnum massegenum ){
    ref.read(chatcontrollerprovider).sandfile(context, file, widget.uid, massegenum ,widget.isgroup);
  }
  void imageslect()async{
    File? image = await pickimagegallery(context);
     if(image != null ){
       sandfile(image , MessageEnum.image );
     }
  }
  void vedioslect()async{
    File? vedio = await pickvideogallery(context);
    if(vedio != null){
      sandfile(vedio, MessageEnum.video);
    }
  }
  void gifslect()async{
    GiphyGif? gif = await pickgif(context);
    if(gif != null){
      ref.read(chatcontrollerprovider).snadgifmassege(context, gif as String , widget.uid,widget.isgroup);
    }
  }

  void openAudio()async{
    final status = await Permission.microphone.request();
    if(status!= PermissionStatus.granted){
      throw Exception('you recorder not open');
    }
    await soundRecorder!.isRecording;
    _isrecorder = true;


  }

  @override
  Widget build(BuildContext context) {
    final messagereply = ref.watch(messageReplyProvider);
    final isshowmessagereply = messagereply != null;
    return Column(

      children: [
        isshowmessagereply ? MessageReplyprewio():SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: TextEditingController(),

                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      _isShowButton = true;
                    });
                  } else {
                    setState(() {
                      _isShowButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggllemojishow,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed:gifslect,
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: imageslect,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: vedioslect,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  child: Icon(
                    _isShowButton
                        ? Icons.send :_isrecorder?Icons.close: Icons.mic,
                    color: Colors.white,
                  ),
                  onTap:textmasseg,
                ),
              ),
            ),


          ],
        ),
        // isshowemoli ?   SizedBox(height: 310,
        //   child: EmojiPicker(
        //     onEmojiSelected: (category, emoji) {
        //       setState(() {
        //         txtmassegecontroller == txtmassegecontroller.text+emoji.emoji;
        //         if(!_isShowButton){
        //           setState(() {
        //             _isShowButton = true;
        //           });
        //
        //         }
        //
        //       });
        //     },
        //   ),
        // ):
    const SizedBox()

      ],
    );
  }}
