// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:warrantytracker/homepage.dart';

class SignInpage extends StatefulWidget {
  const SignInpage({Key? key}) : super(key: key);

  @override
  _SignInpageState createState() => _SignInpageState();
}

class _SignInpageState extends State<SignInpage> {
  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential authResult =

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(credential);
    return authResult.additionalUserInfo!.isNewUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await signInWithGoogle();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isSignedIn", true);
              print(prefs.getBool("isSignedIn"));
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TestPage()));
            } catch (e) {
              print("error");
            }
          },
          child: Text("Sign in"),
        ),
      ),
    );
  }
}
