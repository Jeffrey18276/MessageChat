import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat_redo/constants.dart';
import 'package:flashchat_redo/screens/chat_screen.dart';
import 'package:flashchat_redo/screens/registration_screen.dart';
import 'package:flashchat_redo/service/auth_service.dart';
import 'package:flashchat_redo/service/database_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flashchat_redo/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/helper_function.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: const Color(0xFFee7b64)))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Hero(
                        tag: 'log',
                        child: Container(
                          height: 300,
                          child: Image.asset('images/login.png'),
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });

                          //Do something with the user input.
                        },
                        style: TextStyle(
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
                        style: const TextStyle(
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
                          title: 'Log In',
                          colour: const Color(0xFFee7b64),
                          onPressed: () async {
                            if (login()) {
                              setState(() {
                                showSpinner = true;
                              });
                            }
                            try {
                              final newUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                Navigator.pushNamed(context, ChatScreen.id);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: 'Register here',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationScreen()));
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

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(snapshot.docs[0]["fullName"]);

          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );

        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    return false;
  }
}
