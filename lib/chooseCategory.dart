// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warrantytracker/addInvoice.dart';
import 'package:warrantytracker/homepage.dart';

class ChooseCategoryPage extends StatefulWidget {
  final String name;
  final DateTime datePurchased;
  final String warrantyMonths;
  final String notes;

  const ChooseCategoryPage(
      {Key? key,
      required this.name,
      required this.datePurchased,
      required this.warrantyMonths,
      required this.notes})
      : super(key: key);

  @override
  _ChooseCategoryPageState createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context1) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Database')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Categories")
        .snapshots();

    CollectionReference category = FirebaseFirestore.instance
        .collection('Database')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Categories");

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        return showDialog<void>(
                          context: context1,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Add Category'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Enter the name of the category.'),
                                    TextField(
                                      controller: categoryController,
                                      decoration: InputDecoration(
                                          hintText: "Category name"),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Create'),
                                  onPressed: () async {
                                    await category
                                        .add({'name': categoryController.text})
                                        .then((value) =>
                                            Navigator.of(context).pop())
                                        .catchError((error) => print(
                                            "Failed to add categ: $error"));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("New Category"))
                ],
              ),
              SizedBox(
                height: 40,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Add a category to get started');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return GridView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddInvoice(
                                          name: widget.name,
                                          datePurchased: widget.datePurchased,
                                          warrantyMonths: widget.warrantyMonths,
                                          notes: widget.notes,
                                          category: data["name"],
                                        )));
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width / 2.5,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                                color: getColors(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: Center(
                              child: Text(
                                data['name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              // GridView.builder(
              //     shrinkWrap: true,
              //     physics: BouncingScrollPhysics(),
              //     scrollDirection: Axis.vertical,
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //     ),
              //     itemCount: 5,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Container(
              //           height: MediaQuery.of(context).size.width / 2.5,
              //           width: MediaQuery.of(context).size.width / 2.5,
              //           decoration: BoxDecoration(
              //               color: getColors(index),
              //               borderRadius: BorderRadius.all(Radius.circular(5)),
              //               boxShadow: [
              //                 BoxShadow(color: Colors.black12, blurRadius: 5)
              //               ]),
              //           child: Center(
              //             child: Text(
              //               "Electronics",
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 16),
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
