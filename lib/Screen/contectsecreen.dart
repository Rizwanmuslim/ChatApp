import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/controller/chatcontroller.dart';
import 'package:whatsap/model/chatcontect.dart';
import 'package:whatsap/model/group.dart';
import 'chat.dart';
import 'package:intl/intl.dart';


class contectscreeen  extends   ConsumerWidget {
void _navigateToChat(BuildContext context, String name,String uid, bool isgroup) {
Navigator.of(context).pushNamed(Chat.routname, arguments: {'Name': name,'uid' : uid, 'isgroup' : isgroup});
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatcontrollerprovider).getchatcontect(),
          builder:(context, snapshot) => ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
          final chcontact = snapshot.data![index];
          return Column(
          children: [
          InkWell(
          onTap: () {
          _navigateToChat(context,chcontact.name,chcontact.contactId,false);
          },
          child: ListTile(
          leading: CircleAvatar(
          backgroundImage: NetworkImage(chcontact.profilePic),
          ),
          title: Text(chcontact.name),
          subtitle: Text(chcontact.lastMessage),
          trailing: Text(DateFormat.Hm().format(chcontact.timeSent)),
          ),
          ),
          Divider()
          ],
          );
          },
          ),
          ),
          StreamBuilder<List<Groupmodle>>(
          stream: ref.watch(chatcontrollerprovider).groupchat(),
          builder:(context, snapshot) => ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
          final Groupchat = snapshot.data![index];
          return Column(
          children: [
          InkWell(
          onTap: () {
          _navigateToChat(context,Groupchat.name,Groupchat.groupId,true);
          },
          child: ListTile(
          leading: CircleAvatar(
          backgroundImage: NetworkImage(Groupchat.groupPic),
          ),
          title: Text(Groupchat.name),
          subtitle: Text(Groupchat.lastMessage),
          trailing: Text(DateFormat.Hm().format(Groupchat.timeSent)),
          ),
          ),
          Divider()
          ],
          );
          },
          ),
          ),
        ],
      ),
    );
  }
}
