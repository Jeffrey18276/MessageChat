import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final bool sentByMe;
  final String sender;
  final String senderid;

  MessageTile({Key? key, required this.message, required this.sentByMe, required this.sender,required this.senderid})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        left: widget.sentByMe ? 16 : 0,
        right: widget.sentByMe ? 0 : 16,
      ),
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 200)
            : const EdgeInsets.only(right: 200),
        alignment: widget.sentByMe ? Alignment.bottomLeft : Alignment.bottomRight,
        padding: EdgeInsets.only(
          bottom: 17,
          top: 17,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: widget.sentByMe ? const Color(0xFFee7b64) : Colors.grey[700],
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(20),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}


