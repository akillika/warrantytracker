// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warrantytracker/homepage.dart';
import 'package:warrantytracker/notification.dart';
import 'package:warrantytracker/signinPage.dart';
import 'package:workmanager/workmanager.dart';

const myTask = "syncWithTheBackEnd";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    int id = 0;
    FirebaseFirestore.instance
        .collection('Database')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Products")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        DateTime temp = doc["dateExpires"].toDate();
        if (DateTime.now().difference(temp).inDays == 0 ||
            DateTime.now().difference(temp).inDays == 30) {
          id++;
          NotificationApi.showScheduledNotification(
              id: id,
              title: doc["name"],
              body: "Your Product ${doc["name"]} is expiring soon!",
              payload: doc["id"],
              scheduledDate: DateTime.now().add(Duration(seconds: 5)));
        }
      });
    });
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "2",
    "simplePeriodicTask",
    frequency: Duration(days: 1),
  );
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
