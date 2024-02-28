import 'package:flashchat_redo/helper/helper_function.dart';
import 'package:flashchat_redo/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helper/helper_function.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: FirebaseOptions(apiKey:'AIzaSyCyaIP4ngNk2SIOrP4CEh6Mbg8cavk79OE' , appId:'1:263863136044:web:0aced88c29afff371f4689' , messagingSenderId: '263863136044', projectId: 'flashchat-redo1'
   ));


  runApp(FlashChat());
}

class FlashChat extends StatefulWidget {


  @override


  State<FlashChat> createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  bool _isSignedIn=false;
  @override
  void initState() {
    super.initState();

    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if(value!=null){
        setState(() {
          _isSignedIn=value;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: _isSignedIn ? const HomePage() : WelcomeScreen(),
      // home: const HomePage(),

    );
  }
}
