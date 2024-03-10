import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat_redo/screens/group_info.dart';
import 'package:flashchat_redo/service/database_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String groupId = '';
  String groupName = '';
  String userName = '';
  ChatScreen(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String admin = '';
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {
    // TODO: implement initState
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingChats(widget.groupId)
        .then((val) {
      setState(() {
        chats = val;
      });
    });

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupAdmin(widget.groupId)
        .then((value) {
      setState(() {
        admin = value;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.groupName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:const  Color(0xFFee7b64),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupInfo(
                            groupId: widget.groupId,
                            groupName: widget.groupName,
                            adminName: admin)));
              },
              icon: Icon(Icons.info,
              color: Colors.blueGrey.shade600,))
        ],
      ),
      body: Center(child: Text(widget.groupName)),
    );
  }
}
