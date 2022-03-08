import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/pages/list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference friends = FirebaseFirestore.instance.collection('users').doc('friends');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: signInWithGoogle,
              child: const Text('구글 로그인'),
            ),
            ElevatedButton(
              onPressed: (){
                Get.to(()=>ListPage());
              },
              child: Text('데이터베이스에 데이터 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
