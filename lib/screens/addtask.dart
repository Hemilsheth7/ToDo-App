import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTask() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    var time = DateTime.now();
    await Firestore.instance.collection('tasks').document(uid).collection('mytask').document(time.toString())
        .setData({
      'title':titleController.text,
      'description':descriptionController.text,
      'time':time.toString(),
      'timestamp':time,
    });
    Fluttertoast.showToast(msg: "Task Added Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New To-Do"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width, height: 10.0,),
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Title'),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width, height: 10.0,),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Description'),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width, height: 20.0,),
            Container(
              width: 120.0,
                height: 45.0,
                child: ElevatedButton(
                  onPressed: () {
                    addTask();
                    Navigator.pop(context);
                  },
                  child: Text("ADD TASK",style: TextStyle(fontSize: 16.0),),
                )
            ),
          ],
        ),
      ),
    );
  }
}
