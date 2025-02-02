import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat_redo/helper/helper_function.dart';
import 'package:flashchat_redo/screens/home_page.dart';
import 'package:flashchat_redo/screens/welcome_screen.dart';
import 'package:flashchat_redo/screens/login_screen.dart';
import 'package:flashchat_redo/screens/registration_screen.dart';
import 'firebase_options.dart';  // ✅ Secure Firebase configuration

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // ✅ No hardcoded API keys
  );

  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  Future<bool?> _getUserLoggedInStatus() async {
    return await HelperFunctions.getUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData.light(),
      home: FutureBuilder<bool?>(
        future: _getUserLoggedInStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // ✅ Loading indicator
          }
          return snapshot.data == true ? const HomePage() : WelcomeScreen();
        },
      ),
      routes: {
        WelcomeScreen.routeName: (context) =>  WelcomeScreen(),
        LoginScreen.routeName: (context) =>  LoginScreen(),
        RegistrationScreen.routeName: (context) => RegistrationScreen(),
        HomePage.routeName: (context) =>  HomePage(),
      },
    );
  }
}
