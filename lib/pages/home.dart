import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final User? user;
  const Home(this.user,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      appBar: AppBar(
        title: Text('홈'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: signOut,
              child: Text('로그아웃'),
            ),
            Text(user!.email!),
          ],
        ),
      ),
    );
  }
  void signOut() async{
    await FirebaseAuth.instance.signOut();
  }
  
}
