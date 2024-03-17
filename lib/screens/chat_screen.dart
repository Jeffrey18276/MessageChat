import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flashchat_redo/screens/group_info.dart';
import 'package:flashchat_redo/service/database_service.dart';
import 'package:flutter/widgets.dart';
import 'message_tile.dart';

class ChatScreen extends StatefulWidget {
  String groupId = '';
  String groupName = '';
  String userName = '';
  String senderid = '';

  ChatScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.senderid,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FocusNode focusNode=FocusNode();
  String admin = '';
  Stream<QuerySnapshot>? chats;
  TextEditingController _controller = TextEditingController();
  bool _showEmoji = false;

  @override
  void initState() {
    super.initState();
    getChatandAdmin();
    focusNode.addListener(() {
      if(focusNode.hasFocus){
        setState(() {

          _showEmoji=false;
        });
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
    // Dispose of resources here
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
        backgroundColor: const Color(0xFFee7b64),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: admin,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.blueGrey.shade600,
            ),
          )
        ],
      ),
      body: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: WillPopScope(
                child: Stack(
                  children: [
                    if (!_showEmoji) Positioned.fill(child: chatMessages()),
                
                    if (_showEmoji)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: EmojiPicker(
                          textEditingController: _controller,
                          config: Config(
                            height: 256,
                            checkPlatformCompatibility: true,
                            emojiViewConfig: EmojiViewConfig(
                              backgroundColor: Colors.white,
                              emojiSizeMax: 28 *
                                  (Platform.isAndroid ? 1.0 : 1.20),
                
                            ),
                            swapCategoryAndBottomBar: false,
                            categoryViewConfig: CategoryViewConfig(
                              iconColorSelected: Colors.red.shade200,
                              backspaceColor: Colors.grey
                            ),
                            bottomActionBarConfig: BottomActionBarConfig(
                
                
                            ),
                
                            searchViewConfig: const SearchViewConfig(
                
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onWillPop: (){
                  if(_showEmoji){
                    setState(() {
                      _showEmoji=false;
                    });
                  }
                  else{
                    Navigator.pop(context);
                  }
                  return Future.value(false);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        focusNode: focusNode,
                        controller: _controller,
                        decoration: InputDecoration(
                          prefixIcon:  IconButton(
                            onPressed: () {
                              focusNode.unfocus();
                              focusNode.canRequestFocus=false;
                              setState(() {
                                _showEmoji = !_showEmoji;
                              });
                            },
                            icon: Icon(Icons.emoji_emotions),
                          ),
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: sendMessages,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            int reverseIndex = snapshot.data!.docs.length - index - 1;
            return MessageTile(
              message: snapshot.data!.docs[reverseIndex]['message'],
              sender: snapshot.data!.docs[reverseIndex]['sender'],
              sentByMe: widget.senderid ==
                  snapshot.data!.docs[reverseIndex]['senderid'],
              senderid: FirebaseAuth.instance.currentUser!.uid,
            );
          },
        )
            : Container();
      },
    );
  }

  void sendMessages() {
    if (_controller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'message': _controller.text,
        'sender': widget.userName,
        'senderid': FirebaseAuth.instance.currentUser!.uid,
        'time': FieldValue.serverTimestamp(),
      };
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        _controller.clear();
      });
    }
  }
}
