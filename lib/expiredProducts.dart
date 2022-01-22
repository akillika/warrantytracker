// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warrantytracker/homepage.dart';
import 'package:warrantytracker/productDeatilspage.dart';
import 'package:warrantytracker/profilePage.dart';

class ExpiredproductsPage extends StatefulWidget {
  const ExpiredproductsPage({Key? key}) : super(key: key);

  @override
  _ExpiredproductsPageState createState() => _ExpiredproductsPageState();
}

class _ExpiredproductsPageState extends State<ExpiredproductsPage> {
  String greetings = "";
  String getgreetings() {
    var now;
    now = DateTime.now().hour;
    if (now < 5) {
      return 'Good night,';
    } else if (now < 12) {
      return 'Good morning,';
    } else if (now < 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  @override
  void initState() {
    greetings = getgreetings();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Database')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Products")
        .orderBy("dateExpires")
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Expired Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailspage(
                                        productID: data["id"])),
                              );
                            },
                            child: data["dateExpires"]
                                        .toDate()
                                        .compareTo(DateTime.now()) <
                                    0
                                ? Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: getColors(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                data["name"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                "Expired on ${DateTime.parse(data["dateExpires"].toDate().toString()).toString().substring(0, 10)}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateTime.now()
                                                    .difference(DateTime.parse(
                                                        data["dateExpires"]
                                                            .toDate()
                                                            .toString()))
                                                    .inDays
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                "days ago",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container()),
                      );
                    }).toList(),
                  );
                },
              ),
              // ListView.builder(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.vertical,
              //     physics: BouncingScrollPhysics(),
              //     padding: const EdgeInsets.all(8),
              //     itemCount: 1,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 8.0),
              //         child: GestureDetector(
              //           onTap: () {
              //             CollectionReference users =
              //                 FirebaseFirestore.instance.collection('Database');
              //             FirebaseFirestore.instance
              //                 .collection('Database')
              //                 .doc("0KrLR1g50bCQcosfml9c")
              //                 .collection("Products")
              //                 .get()
              //                 .then((QuerySnapshot querySnapshot) {
              //               querySnapshot.docs.forEach((doc) {
              //                 print(doc["name"]);
              //               });
              //             });
              //             // Navigator.push(
              //             //   context,
              //             //   MaterialPageRoute(
              //             //       builder: (context) =>
              //             //           const ProductDetailspage()),
              //             // );
              //           },
              //           child: Container(
              //             height: 100,
              //             decoration: BoxDecoration(
              //                 color: getColors(index),
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(5)),
              //                 boxShadow: [
              //                   BoxShadow(color: Colors.black12, blurRadius: 5)
              //                 ]),
              //             child: Padding(
              //               padding: const EdgeInsets.all(25.0),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         "Boat Headphones",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 16),
              //                       ),
              //                       SizedBox(
              //                         height: 6,
              //                       ),
              //                       Text(
              //                         "Expires on 24/11/2022",
              //                         style: TextStyle(
              //                             color: Colors.white, fontSize: 12),
              //                       ),
              //                     ],
              //                   ),
              //                   Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         "320",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 25),
              //                       ),
              //                       Text(
              //                         "days left",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 12),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
