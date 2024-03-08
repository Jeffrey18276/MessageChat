import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({required this.uid});

  final CollectionReference usercollection=FirebaseFirestore.instance.collection('users');
  final CollectionReference groupcollection=FirebaseFirestore.instance.collection('groups');

  Future savingUserData(String fullName,String email)async{
    return await usercollection.doc(uid).set({
      "fullName":fullName,
      "email":email,
      "groups":[],
      "profilePic":"",
      "uid":uid
    });
  }

  Future gettingUserData(String email)async{
    QuerySnapshot snapshot=await usercollection.where("email",isEqualTo:email ).get();
    return snapshot;
  }

  //get user groups

  getUserGroups()async{
    return usercollection.doc(uid).snapshots();
}
Future createGroup(String username,String id,String groupName)async{
    DocumentReference groupdocumentReference=await groupcollection.add({
      "groupName":groupName,
      "groupIcon":"",
      "admin" : "${id}_$username",
      "members":"[]",
      "groupId":"",
      "recentMessage":"",
      "recentMessageSender":"",

    });
  //update the members
    await groupdocumentReference.update({
      "members":FieldValue.arrayUnion(["${uid}_$username"]),
      "groupId":groupdocumentReference.id,
    });

    //update groups in user

    DocumentReference userDocumentReference=usercollection.doc(uid);
    return await userDocumentReference.update({
      "groups":FieldValue.arrayUnion(["${groupdocumentReference.id}_${groupName}"])
    });
}

}