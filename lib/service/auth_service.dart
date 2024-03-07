import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_redo/helper/helper_function.dart';
import 'package:flashchat_redo/service/database_service.dart';

class AuthService{
  final _auth=FirebaseAuth.instance;

  //login
  Future loginWithUserNameandPassword(String email,String password) async {
    try {
      print("User has been created");
      User user = (await _auth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;
      if (user != null) {
        print("User has been created");
        //call our database service
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }




  //register
Future registeruserwithemailandpassword(String fullname,String email,String password) async{
  try{
    print("Userf has been created");
    User user=(await _auth.createUserWithEmailAndPassword(email: email, password: password))
        .user!;
    if(user!=null){
      print("User has been created");
      //call our database service
      await DatabaseService(uid:user.uid).savingUserData (fullname, email);
      return true;
    }

  }on FirebaseAuthException catch(e){
    print(e);
    return e.message;
  }
}



//signout

Future signOut()async{
  try{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserEmail("");
    await HelperFunctions.saveUserName("");
    await _auth.signOut();
  }catch(e){
    return null;
  }
}
}