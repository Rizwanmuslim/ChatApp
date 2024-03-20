import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsap/controller/contectcontroller.dart';
import 'package:flutter_contacts/contact.dart ';
final slectcontectgrp = StateProvider<List<Contact>>((ref) => [],);

class slectcontectgroup extends ConsumerStatefulWidget {
  const slectcontectgroup({super.key});

  @override
  ConsumerState<slectcontectgroup> createState() => _slectcontectgroupState();
}

class _slectcontectgroupState extends ConsumerState<slectcontectgroup> {
  List<int>  slectcontectgroupindex = [];
  void slectcontectgrup (int index ,  Contact contact){
    if(slectcontectgroupindex.contains(index)){
      slectcontectgroupindex.removeAt(index);
    }else{
      slectcontectgroupindex.add(index);

    }
    setState(() {

    });
    ref.read(slectcontectgrp.state).update((state) => [...state,contact]);



  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(contectrepositrycontrollerprovider).when(data: (contectlist) =>ListView.builder(
      itemCount: contectlist.length,
      itemBuilder: (context, index) {
        final  contect =  contectlist[index];
        return InkWell(
          onTap: () =>  slectcontectgrup(index , contect as Contact),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(contect.displayName),
              leading:slectcontectgroupindex.contains(index)? Icon(Icons.done):null ,
            ),
          ),
        );
      },
    ) , error: (error, stackTrace) {
       return Text('er===========$error');
    }, loading:  () {
     return Center(
        child: CircularProgressIndicator(),
      );
    },);
  }
}


