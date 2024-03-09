import 'package:flashchat_redo/screens/chat_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupTile extends StatefulWidget {
  String userName = '';
  String groupId = '';
  String groupName = '';
  GroupTile(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen(groupId: widget.groupId,groupName: widget.groupName,userName: widget.userName,)));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFee7b64),
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              widget.groupName,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("Join the conversation"),
          ),
        ),
      ),
    );
  }
}
