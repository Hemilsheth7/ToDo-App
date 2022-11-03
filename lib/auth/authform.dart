import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoggedIn = false;

  startAuthentication() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    AuthResult authResult; //AuthResult changed to UserCredential
    try {
      if (isLoggedIn) {
        authResult =
        await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user.uid;
        await Firestore.instance.collection('users')
            .document(uid)
            .setData({'username':username, 'email':email});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!isLoggedIn)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Invalid Username";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Enter Username",
                      ),
                    ),
                  SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width, height: 30.0,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide()),
                      labelText: "Enter Email",
                    ),
                  ),
                  SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width, height: 30.0,),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return "Invalid Password";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide()),
                      labelText: "Enter Password",
                    ),
                  ),
                  SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width, height: 30.0,),
                  Container(
                      margin: EdgeInsets.all(5.0),
                      height: 50.0,
                      width: 120.0,
                      child: RaisedButton(
                        child: isLoggedIn ? Text("LOGIN", style: TextStyle(
                            color: Colors.white, fontSize: 20.0),) : Text(
                          "SIGN UP", style: TextStyle(
                            color: Colors.white, fontSize: 20.0),),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.blue,
                        onPressed: () {
                          startAuthentication();
                        },
                      )
                  ),
                  SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width, height: 5.0,),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoggedIn = !isLoggedIn;
                        });
                      },
                      child: isLoggedIn ? Text("Sign Up ?", style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          decoration: TextDecoration.underline))
                          : Text("Already a User ?", style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
