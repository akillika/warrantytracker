// ignore_for_file: unrelated_type_equality_checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warrantytracker/homepage.dart';
import 'package:warrantytracker/signinPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool?> getSignedInData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSignedIn');
  }

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const SignInpage()
          : const TestPage(),
    );
  }
}
