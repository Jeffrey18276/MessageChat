import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_redo/constants.dart';
import 'package:flashchat_redo/helper/helper_function.dart';
import 'package:flashchat_redo/screens/chat_screen.dart';
import 'package:flashchat_redo/service/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  bool _isJoined = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String username = '';
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserName();
  }

  getAdmin(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  getCurrentUserName() async {
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        username = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFee7b64),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: const Color(0xFFee7b64),
            child: Align(
              alignment: Alignment.centerRight, // Align to the right
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align items to the end
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Type the group name',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearchMethod();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20), // Add margin to separate from TextField
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: const Color(0xFFee7b64),
                ))
              : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .searchByName(_controller.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  username,
                  searchSnapshot!.docs[index]['groupId'],
                  searchSnapshot!.docs[index]['groupName'],
                  searchSnapshot!.docs[index]['admin']);
            })
        : Container();
  }

  joinedOrNot(
      String username, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, username)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(
      String username, String groupId, String groupName, String admin) {
    joinedOrNot(username, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Color(0xFFee7b64),
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text('Admin: ${getAdmin(admin)}'),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupName, groupId, username);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackBar(
                context, Colors.green, "Successfully joined  $groupName");
            await Future.delayed(Duration(milliseconds: 500), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            groupId: groupId,
                            groupName: groupName,
                            userName: username,
                          )));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackBar(context, Colors.red, "Left  $groupName");
          }
        },
        child: _isJoined
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
                child: const Text(
                  'Joined',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFee7b64),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'Join',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}
