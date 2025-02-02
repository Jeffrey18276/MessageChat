import 'package:flashchat_redo/constants.dart';
import 'package:flashchat_redo/helper/helper_function.dart';
import 'package:flashchat_redo/screens/chat_screen.dart';
import 'package:flashchat_redo/screens/home_page.dart';
import 'package:flashchat_redo/screens/login_screen.dart';
import 'package:flashchat_redo/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flashchat_redo/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:validators/validators.dart'; // Added validators package

class RegistrationScreen extends StatefulWidget {
  static const String routeName = '/registration';
  static const String id = 'registration_screen';

  RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: 5,
        ),
      )
          : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "Register",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                      color:Colors.black,
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Create your account now to chat and explore",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Hero(
                  tag: 'log',
                  child: Container(
                    height: 300,
                    child: Image.asset('images/register.png'),
                  ),
                ),
                TextFormField(
                  onChanged: (value) => setState(() => fullname = value),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: ktextInputDecoration.copyWith(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person, color: Color(0xFFee7b64)),
                  ),
                  validator: (value) => value!.isNotEmpty ? null : 'Name cannot be empty',
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress, // Added keyboard type
                  onChanged: (value) => setState(() => email = value),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: ktextInputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFee7b64)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    } else if (!isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  onChanged: (value) => setState(() => password = value),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: ktextInputDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFFee7b64)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                RoundedButton(
                  title: 'Register',
                  colour: const Color(0xFFee7b64),
                  onPressed: () async => register(),
                ),
                const SizedBox(height: 10),
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await authService.registeruserwithemailandpassword(fullname, email, password);

      if (result == true) {
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmail(email);
        await HelperFunctions.saveUserName(fullname);

        // Navigate to HomePage
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        if (mounted) {
          showSnackBar(context, Colors.red, result);
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
