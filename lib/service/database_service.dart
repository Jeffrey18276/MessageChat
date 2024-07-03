import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/encrypt_data.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});

  final CollectionReference usercollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupcollection =
      FirebaseFirestore.instance.collection('groups');

  Future savingUserData(String fullName, String email) async {
    return await usercollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await usercollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups

  getUserGroups() async {
    return usercollection.doc(uid).snapshots();
  }

  Future createGroup(String username, String id, String groupName) async {
    DocumentReference groupdocumentReference = await groupcollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$username",
      "members": "[]",
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime":"",
      "recentMessageID":""
    });
    //update the members
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$username"]),
      "groupId": groupdocumentReference.id,
    });

    //update groups in user

    DocumentReference userDocumentReference = usercollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_${groupName}"])
    });
  }

  gettingChats(String groupId) async {
    return groupcollection
        .doc(groupId)
        .collection('messages')
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId)async{
    DocumentReference documentReference=groupcollection.doc(groupId);
    DocumentSnapshot ds= await documentReference.get();
    return ds['admin'];

  }
  getGroupMembers(String groupId)async{
    return groupcollection.doc(groupId).snapshots();
  }

  searchByName(String groupName){
    return groupcollection.where('groupName',isEqualTo: groupName).get();

  }

  Future <bool> isUserJoined(String groupName,String groupId,String userName)async{
    DocumentReference documentReference=usercollection.doc(uid);
    DocumentSnapshot ds=await documentReference.get();

    List<dynamic> groups= await ds['groups'];
    return groups.contains("${groupId}_${groupName}") ? true : false;
  }



  Future toggleGroupJoin(String groupName,String groupId,String userName)async{
    DocumentReference userDocumentReference=usercollection.doc(uid);
    DocumentReference groupDocumentReference=groupcollection.doc(groupId);

    DocumentSnapshot documentSnapshot=await userDocumentReference.get();
    List<dynamic> groups= await documentSnapshot['groups'];
    
    if(groups.contains("${groupId}_${groupName}")){
      await userDocumentReference.update({
        'groups':FieldValue.arrayRemove(["${groupId}_${groupName}"])
      });
      await groupDocumentReference.update({
        'members':FieldValue.arrayRemove(["${groupId}_${userName}"])
      });

    }
    else{
      await userDocumentReference.update({
        'groups':FieldValue.arrayUnion(["${groupId}_${groupName}"])
      });
      await groupDocumentReference.update({
        'members':FieldValue.arrayUnion(["${groupId}_${userName}"])
      });

    }
  }
  sendMessage(String groupId, Map<String, dynamic> chatMessageMap) async {
    // Extract the message text from the chatMessageMap
    String message = chatMessageMap['message'];

    // Encrypt the message
    String encryptedMessage = EncryptionService.encryptWithAESKey(message);

    // Update the chat message map with the encrypted message
    chatMessageMap['encryptedMessage'] = encryptedMessage;
    chatMessageMap.remove(message);


    // Add the chat message to Firestore
    await groupcollection.doc(groupId).collection("messages").add(chatMessageMap);

    // Update the recent message in the group collection
    groupcollection.doc(groupId).update({
      "recentMessage": message, // Store the original, unencrypted message
      "recentMessageSender": chatMessageMap['sender'],
      "recentMessageId": chatMessageMap['senderid'],
      "recentMessageTime": chatMessageMap['time'].toString(),
    });
  }


  deleteGroup(String groupId) async{
    try {
      await FirebaseFirestore.instance.collection('groups')
          .doc(groupId)
          .delete();
    }
    catch (e){
      print("Error deleting the group: $e");
    }
  }
}
