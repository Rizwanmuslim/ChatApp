import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/Screen/Creat_groupscreen.dart';
import 'package:whatsap/Screen/con_status_screen.dart';
import 'package:whatsap/Screen/contectsecreen.dart';
import 'package:whatsap/Screen/status_contect_screen.dart';
import 'package:whatsap/Screen/yourcontect.dart';
import 'package:whatsap/controller/Authcontroller.dart';
import 'package:whatsap/utils/utilsfnction.dart';

import '../color.dart';

class ContectList extends ConsumerStatefulWidget {
 static const routname= '/contect';

  @override
  ConsumerState<ContectList> createState() => _ContectListState();
}

class _ContectListState extends ConsumerState<ContectList> with WidgetsBindingObserver,TickerProviderStateMixin {
 late TabController tabController;
 @override
  void initState() {
   tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
      ref.read(Authcontrolerprovider).getonline(true);
      break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(Authcontrolerprovider).getonline(false);
        break;
        // TODO: Handle this case.
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Whatsapp'),
          backgroundColor: Colors.grey,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            PopupMenuButton(itemBuilder: (context) => [
              PopupMenuItem(child: Text('Creat Group')),
            ],
              onSelected: (value) => Future(() => Navigator.of(context).pushNamed(creatgroupscreen.routname)),
            )
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.black87,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller:tabController ,
          children: [
            contectscreeen(),
            statusscreencontect(),
            Text('STATUS'),
            // Tab view for CALLS
            Container(color: Colors.white),
            // Tab view for STATUS
            // Tab view for CALLS
          ],

        ),
        floatingActionButton: FloatingActionButton(
         onPressed: ()  async{
           if(tabController.length == 0) {
             Navigator.of(context).pushNamed(contect.routname);
           }else{
             File? pickfileimage = await pickimagegallery(context);
             if(pickfileimage != null){
             Navigator.of(context).pushNamed(confirmstatusscreen.routname,arguments: pickfileimage);
             }

           }
         },
        backgroundColor: tabColor,
        child: const Icon(
           Icons.comment,
            color: Colors.white,
         ),
      ),
      )
    );
  }
}
