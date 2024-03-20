import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/commenRepositry/commenRepositry.dart';
import 'package:whatsap/widget/Displyfillemasage.dart';

class MessageReplyprewio extends ConsumerWidget {
  const MessageReplyprewio({super.key});
  void cancelreply(WidgetRef ref){
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final messagereply = ref.watch(messageReplyProvider);
    return  Container(
      width: 310,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(
                messagereply!.isMe?'me':'opposite',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              IconButton(onPressed:() =>cancelreply(ref), icon: Icon(Icons.close))
            ],
          ),
          SizedBox(height: 10,),
          displyfillemassage(massage: messagereply.message,
              massegeEnum:messagereply.messageEnum )
        ],
        
      ),
    );
  }
}
