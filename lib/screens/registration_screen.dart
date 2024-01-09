import 'package:flashchat_redo/constants.dart';
import 'package:flashchat_redo/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat_redo/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  final _auth=FirebaseAuth.instance;

  String email='';
  String password='';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center ,
                style: TextStyle(
                  color: Colors.black,
                ),

                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscuringCharacter:'*',
                textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password')),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Register', colour: Colors.blueAccent,

                  onPressed: ()async {
                    setState(() {
                      showSpinner=true;
                    });
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      if(newUser!=null){
                        Navigator.pushNamed(context,ChatScreen.id);
                      }
                      setState(() {
                        showSpinner=false;
                      });
                    }

                    catch(e){
                      print(e);
                    }

                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
