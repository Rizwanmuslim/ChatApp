import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/Screen/Statuscreen.dart';
import 'package:whatsap/controller/Status_repostry_controller.dart';
import 'package:whatsap/model/status_user.dart';

class statusscreencontect extends ConsumerWidget {
  const statusscreencontect({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return FutureBuilder<List<Status>>(future: ref.read(statusrepostrycontrollerprovider).getstatus(context),
        builder: (context, snapshot) {
      if(snapshot.connectionState==ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(),);
      }
      return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder:(context, index) {
            final stacontact = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Statusscreen.routname,arguments: stacontact);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(stacontact.profilePic),
                    ),
                    title: Text(stacontact.username),

                  ),
                ),
                Divider()
              ],
            );
          }, );
        },

    );
  }
}
