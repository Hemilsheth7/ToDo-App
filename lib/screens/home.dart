import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/addtask.dart';
import 'package:todo_app/screens/detailedview.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';

  @override
  void initState() {
    getUid();
    super.initState();
  }

  getUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
        actions: [
          IconButton(

            icon: Icon(Icons.logout),
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Fluttertoast.showToast(msg: "Logged out");
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('tasks')
              .document(uid)
              .collection('mytask')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              final docs = snapshot.data!.documents;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var date = docs[index]['timestamp'].toDate();
                  return InkWell(
                    onTap: (){
                      //detailed view of task
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context)=>DetailedView(title: docs[index]['title'],description: docs[index]['description'], date: DateFormat.yMd().add_jm().format(date),))
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 90.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                  padding: EdgeInsets.all(5),
                                  child: Text(docs[index]['title'],
                                    style: TextStyle(
                                      fontSize: 24.0,
                                  ),
                                  ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  DateFormat.yMd().add_jm().format(date),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            //color: Colors.lightBlueAccent,
                            alignment: Alignment.centerRight,
                            //margin: EdgeInsets.only(right: 15, top: 10),
                            padding: EdgeInsets.all(5),
                            child: IconButton(
                              icon: Icon(Icons.delete,color: Colors.black,),
                              onPressed: () async {
                                await Firestore.instance.collection('tasks').document(uid)
                                    .collection('mytask')
                                    .document(docs[index]['time'])
                                    .delete();
                                Fluttertoast.showToast(msg: "Deleted");
                                },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
