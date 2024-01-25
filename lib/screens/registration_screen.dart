import 'package:flashchat_redo/constants.dart';
import 'package:flashchat_redo/screens/chat_screen.dart';
import 'package:flashchat_redo/screens/login_screen.dart';
import 'package:flashchat_redo/service/auth_service.dart';
import 'package:flutter/gestures.dart';
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

  RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isLoading=false;
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String fullname='';
  AuthService authService=AuthService();


  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading? Center(child:CircularProgressIndicator(color:Theme.of(context).primaryColor,
      strokeWidth: 5,)):SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                    "Create your account now to chat and explore",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Hero(
                  tag: 'log',
                  child: Container(
                    height: 300,
                    child: Image.asset('images/register.png'),
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      fullname=value;
                    });

                    //Do something with the user input.
                  },
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: ktextInputDecoration.copyWith(
                    labelText: 'Full Name',
                    prefixIcon: const Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFFee7b64),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if(value!.isNotEmpty){
                      return null;
                    }
                    else return 'Name cannot be empty';
                  }
                ),
               const SizedBox(height: 5.0,),

                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });

                    //Do something with the user input.
                  },
                  style:const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: ktextInputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: const Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(
                        Icons.email,
                        color: Color(0xFFee7b64),
                      ),
                    ),
                  ),
                  validator: (value) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });

                    //Do something with the user input.
                  },
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: ktextInputDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: const Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(
                        Icons.lock,
                        color: Color(0xFFee7b64),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Password must be atlease 6 characters in length";
                    }
                  },
                ),
                RoundedButton(
                    title: 'Register',
                    colour: Color(0xFFee7b64),
                    onPressed: () async {
                      register();
                    }),

                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Login now',

                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context,LoginScreen.id);
                                }),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  register() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading=true;

      });
      await authService.registeruserwithemailandpassword(fullname, email, password).then((value) {
          if(value==true){


          }
          else{
            showSnackBar(context, Colors.red, value);
            setState(() {
              _isLoading=false;
            });
          }
      });


    }


  }
}
