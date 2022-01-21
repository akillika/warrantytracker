// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:warrantytracker/addProductPage.dart';
import 'package:warrantytracker/catergories.dart';
import 'package:warrantytracker/profilePage.dart';
import 'package:warrantytracker/searchPage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);
    List<Widget> _buildScreens() {
      return [
        HomePage(),
        CategoriesPage(),
        AddProductPage(),
        SearchPage(),
        ProfilePage()
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("All Items"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.circle_grid_3x3),
          title: ("Categories"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
          title: ("Add"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.search),
          title: ("Search"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("Profile"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style15,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int temp = 0;
  MaterialColor getColors() {
    if (temp == 0) {
      temp++;
      return Colors.red;
    }
    if (temp == 1) {
      temp++;
      return Colors.green;
    }

    temp = 0;
    return Colors.blue;
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
                "Welcome, Akil S",
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
                            FirebaseFirestore.instance
                                .collection('Database')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("Products")
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              querySnapshot.docs.forEach((doc) {
                                print(doc["name"]);
                              });
                            });
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const ProductDetailspage()),
                            // );
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: getColors(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        "Expires ${DateTime.parse(data["dateExpires"].toDate().toString()).toString().substring(0, 10)}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateTime.parse(data["dateExpires"]
                                                .toDate()
                                                .toString())
                                            .difference(DateTime.now())
                                            .inDays
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "days left",
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
                          ),
                        ),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     CollectionReference users = FirebaseFirestore.instance
      //         .collection('Database')
      //         .doc(FirebaseAuth.instance.currentUser!.uid)
      //         .collection("Products");
      //     await users
      //         .add({'name': "yes", 'expires': "22/22/2222"})
      //         .then((value) => print("User Added"))
      //         .catchError((error) => print("Failed to add user: $error"));
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
