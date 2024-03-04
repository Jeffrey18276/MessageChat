import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_redo/helper/helper_function.dart';
import 'package:flashchat_redo/screens/login_screen.dart';
import 'package:flashchat_redo/screens/profile_page.dart';
import 'package:flashchat_redo/screens/search_page.dart';
import 'package:flashchat_redo/service/auth_service.dart';
import 'package:flashchat_redo/service/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart ';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  String username = '';
  String email = '';

  Stream? groups;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettinguserData();
  }

  gettinguserData() async {
    await HelperFunctions.getUserEmailSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        username = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: const Icon(Icons.search),
          )
        ],
        backgroundColor: Color(0xFFee7b64),
        title: const Text(
          'Groups',
          style: TextStyle(
              color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[70],
            ),
            const SizedBox(height: 15.0),
            Text(
              username,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Divider(
              height: 2,
              indent: 20.0,
              endIndent: 20.0,
              color: Colors.blueGrey.shade200,
            ),
            const ListTile(
              selected: true,
              selectedColor: Color(0xFFee7b64),
              leading: Icon(Icons.group),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black38),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(userName: username, email: email)));
              },
              selectedColor: Color(0xFFee7b64),
              leading: const Icon(Icons.person_2_rounded),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.black38),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel_rounded,
                                color: Colors.red,
                              )),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut().whenComplete(() =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginScreen())));
                            },
                            icon: Icon(Icons.done_rounded),
                            color: Colors.green,
                          )
                        ],
                      );
                    });
              },
              selectedColor: const Color(0xFFee7b64),
              leading: const Icon(Icons.exit_to_app),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black38),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.grey.shade400,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Color(0xFFee7b64),
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {}
  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return Text('Hello');
              } else
                return noGroupWidget();

            }

            else {
              return noGroupWidget();
            }

          } else {
            return Center(
                child: CircularProgressIndicator(
              color: const Color(0xFFee7b64),
            ));
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_circle,
            color: Colors.grey,
            size: 75,
          ),
        ],
      ),
    );
  }
}
