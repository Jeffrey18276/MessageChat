import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_redo/screens/home_page.dart';
import 'package:flashchat_redo/service/database_service.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class GroupInfo extends StatefulWidget {
  String groupId = '';
  String groupName = '';
  String adminName = '';
  GroupInfo(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    // TODO: implement initState

    getMembers();
    super.initState();
  }

  String getAdminName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  //String manipulation to get the admin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFee7b64),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Group Info',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text("Exit"),
                          content: const Text(
                              "Are you sure you want to exit the group"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel_rounded,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                DatabaseService(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .toggleGroupJoin(
                                        widget.groupName,
                                        widget.groupId,
                                        getAdminName(widget.adminName))
                                    .whenComplete(() =>
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage())));
                              },
                              icon: const Icon(Icons.done_rounded),
                              color: Colors.green,
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.grey.shade200,
              ))
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFee7b64).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFee7b64),
                      child: Text(
                        widget.groupName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group: ${widget.groupName}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Admin: ${getAdminName(widget.adminName)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              memberList(),
            ],
          )),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'] != 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data['members'].length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 5.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFFee7b64),
                          child: Text(
                            getAdminName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        title:
                            Text(getAdminName(snapshot.data['members'][index])),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("No members in the group"));
            }
          } else {
            return const Center(child: Text("No members in the group"));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFee7b64),
            ),
          );
        }
      },
    );
  }
}
