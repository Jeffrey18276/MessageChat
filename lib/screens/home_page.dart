import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_redo/components/groups_tile.dart';
import 'package:flashchat_redo/constants.dart';
import 'package:flashchat_redo/helper/helper_function.dart';
import 'package:flashchat_redo/screens/login_screen.dart';
import 'package:flashchat_redo/screens/profile_page.dart';
import 'package:flashchat_redo/screens/search_page.dart';
import 'package:flashchat_redo/service/auth_service.dart';
import 'package:flashchat_redo/service/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  String username = '';
  String email = '';

  Stream? groups;
  bool _isloading = false;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // String manipulation to get group id
  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  // String manipulation to get group name
  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  // Fetch user data from SharedPreferences and Firebase
  gettingUserData() async {
    try {
      var userEmail = await HelperFunctions.getUserEmailSF();
      var userName = await HelperFunctions.getUserNameSF();
      var userGroups = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups();

      setState(() {
        email = userEmail ?? '';
        username = userName ?? '';
        groups = userGroups;
      });
    } catch (e) {
      showSnackBar(context, Colors.red, 'Error fetching user data: $e');
    }
  }

  // Display the UI for the HomePage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: Icon(Icons.search, color: Colors.blue.shade200),
          )
        ],
        backgroundColor: Color(0xFFee7b64),
        title: const Text(
          'Groups',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: [
            Icon(Icons.account_circle, size: 150, color: Colors.grey[70]),
            const SizedBox(height: 15.0),
            Text(
              username,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Divider(height: 2, indent: 20.0, endIndent: 20.0, color: Colors.blueGrey.shade200),
            const ListTile(
              selected: true,
              selectedColor: Color(0xFFee7b64),
              leading: Icon(Icons.group),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text("Groups", style: TextStyle(color: Colors.black38)),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userName: username, email: email),
                  ),
                );
              },
              selectedColor: Color(0xFFee7b64),
              leading: const Icon(Icons.person_2_rounded),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text("Profile", style: TextStyle(color: Colors.black38)),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure you want to logout"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.cancel_rounded, color: Colors.red),
                            ),
                            IconButton(
                              onPressed: () async {
                                await authService.signOut().whenComplete(() {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                        (route) => false,
                                  );
                                });
                              },
                              icon: const Icon(Icons.done_rounded),
                              color: Colors.green,
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              selectedColor: const Color(0xFFee7b64),
              leading: const Icon(Icons.exit_to_app),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text("Logout", style: TextStyle(color: Colors.black38)),
            ),
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
        child: const Icon(Icons.add, size: 30, color: Color(0xFFee7b64)),
      ),
    );
  }

  // Pop-up dialog for group creation
  popUpDialog(BuildContext context) {
    return _openAnimatedDialog();
  }

  // Animated dialog for group creation
  void _openAnimatedDialog() {
    showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: AlertDialog(
            title: const Text("Create a group", textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isloading
                    ? CircularProgressIndicator(color: Theme.of(context).primaryColor)
                    : TextField(
                  onChanged: (val) {
                    setState(() {
                      groupName = val;
                    });
                  },
                  decoration: ktextInputDecoration,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorDark),
              ),
              ElevatedButton(
                onPressed: () {
                  if (groupName != "") {
                    setState(() {
                      _isloading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(username, FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      setState(() {
                        _isloading = false;
                      });
                      Navigator.pop(context);
                      showSnackBar(context, Colors.green, 'Group created successfully');
                    });
                  } else {
                    showSnackBar(context, Colors.red, 'Group name cannot be empty');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFee7b64)),
                child: const Text('Create', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Display group list
  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null && snapshot.data['groups'].length != 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data['groups'].length,
              itemBuilder: (context, index) {
                int reverseIndex = snapshot.data['groups'].length - index - 1;
                return GroupTile(
                  userName: snapshot.data['fullName'],
                  groupId: getId(snapshot.data['groups'][reverseIndex]),
                  groupName: getName(snapshot.data['groups'][reverseIndex]),
                  userid: getId(snapshot.data['groups'][reverseIndex]),
                );
              },
            );
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFee7b64)));
        }
      },
    );
  }

  // Display message when user has no groups
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey.shade700,
                size: 75,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "You have not joined any group. Tap on the icon to create one.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
