import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: FirebaseOptions(apiKey:'AIzaSyAyDP-GBYeRvSkljPsA2JHaNtNA2h5Kfec' , appId:'1:263863136044:android:617bc2a9e091f2c11f4689' , messagingSenderId: '263863136044', projectId: 'flashchat-redo1')
   );
    

  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black54),
          ),
        ),
        initialRoute: WelcomeScreen.id,
        routes:{
          WelcomeScreen.id:(context)=>WelcomeScreen(),
          LoginScreen.id:(context)=>LoginScreen(),
          RegistrationScreen.id:(context)=>RegistrationScreen(),
          ChatScreen.id:(context)=>ChatScreen(),


        }
    );
  }
}
