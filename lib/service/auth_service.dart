import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_redo/service/database_service.dart';

class AuthService{
  final _auth=FirebaseAuth.instance;

  //login



  //register
Future registeruserwithemailandpassword(String fullname,String email,String password) async{
  try{
    User user=(await _auth.createUserWithEmailAndPassword(email: email, password: password))
        .user!;
    if(user!=null){
      //call our database service
      await DatabaseService(uid:user.uid).updateUserData(fullname, email);
      return true;
    }

  }on FirebaseAuthException catch(e){
    return e.message;
  }
}



//signout
}