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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo1.png"),
              // Text(
              //   "Smart Warranty",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: 40,
              // ),
              GestureDetector(
                onTap: () async {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logging in..'),
                        content: Center(child: CircularProgressIndicator()),
                      );
                    },
                  );
                  try {
                    await signInWithGoogle();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool("isSignedIn", true);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TestPage()));
                  } catch (e) {
                    print("error");
                  }
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        // BoxShadow(color: Colors.black12, blurRadius: 5)
                      ]),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google.png",
                          height: 20,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Text(
                "Built with ❤️ by The Developer Studio",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     try {
              //       await signInWithGoogle();
              //       SharedPreferences prefs =
              //           await SharedPreferences.getInstance();
              //       prefs.setBool("isSignedIn", true);
              //       print(prefs.getBool("isSignedIn"));
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => TestPage()));
              //     } catch (e) {
              //       print("error");
              //     }
              //   },
              //   child: Text("Sign in"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
