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
}