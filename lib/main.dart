import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/auth/authscreen.dart';
import 'package:todo_app/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, usersnapshot){
        if(usersnapshot.hasData){
          return Home();
        }
        else{
          return AuthScreen();
        }
      } ,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
