import 'package:flashchat_redo/screens/home_page.dart';
import 'package:flashchat_redo/service/auth_service.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ProfilePage extends StatefulWidget {
  String userName='';
  String email='';
   ProfilePage({super.key,required this.userName,required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFee7b64),
        title: Text(
                  'Profile',
                  style: const TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 27.0),

                ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: [
            Icon(
              Icons.account_circle_sharp,
              size: 150,
              color: Colors.grey[70],
            ),
            const SizedBox(height: 15.0),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Divider(
              height: 2,
              indent: 20.0,
              endIndent: 20.0,
              color: Colors.blueGrey.shade200,
            ),
             ListTile(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
              },

              selectedColor: Color(0xFFee7b64),
              leading: Icon(Icons.group),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black38),
              ),
            ),
            ListTile(
              selected: true,
              onTap: () {

              },
              selectedColor: Color(0xFFee7b64),
              leading: Icon(Icons.person_2_rounded),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.black38),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel_rounded,
                                color: Colors.red,
                              )),
                          IconButton(
                            onPressed: () async{
                              await authService.signOut().whenComplete(() => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen())));
                            },
                            icon: Icon(Icons.done_rounded),
                            color: Colors.green,
                          )
                        ],
                      );
                    });

              },
              selectedColor: const Color(0xFFee7b64),
              leading: const Icon(Icons.exit_to_app),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black38),
              ),
            )
          ],
        ),
      ),
      body:Container(
        padding:const EdgeInsets.symmetric(horizontal: 40,vertical: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,size: 200,
            color: Colors.grey[700]),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               const Text('Full Name',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600) ),
                Text(widget.userName,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),)
              ],
            ),
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.grey.shade200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email',style: TextStyle(fontSize: 17,
                fontWeight: FontWeight.w600),),
                Text(widget.email,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),)
              ],
            ),

          ],
        ),
      )
    );
  }
}
