// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warrantytracker/addProductPage.dart';
import 'package:warrantytracker/homepage.dart';

class AddInvoice extends StatefulWidget {
  final String name;
  final DateTime datePurchased;
  final String warrantyMonths;
  final String notes;
  final String category;
  const AddInvoice(
      {Key? key,
      required this.name,
      required this.datePurchased,
      required this.warrantyMonths,
      required this.notes,
      required this.category})
      : super(key: key);

  @override
  _AddInvoiceState createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  @override
  void initState() {
    // TODO: implement initState

    print(widget.datePurchased
        .add(Duration(days: 31 * int.parse(widget.warrantyMonths))));
  }

  @override
  Widget build(BuildContext context) {
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
                "Upload Invoice",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 70,
              ),
              Center(
                child: ElevatedButton(
                  child: Text("Save to my account"),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('Database')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Products")
                        .add({
                          'name': widget.name,
                          'datePurchased': widget.datePurchased,
                          'dateExpires': widget.datePurchased.add(Duration(
                              days: 31 * int.parse(widget.warrantyMonths))),
                          'months': widget.warrantyMonths,
                          'notes': widget.notes,
                          "category": widget.category
                        })
                        .then((value) => print("Data Added"))
                        .catchError(
                            (error) => print("Failed to add Data: $error"));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => AddProductPage()),
                        (route) => false);
                    const snackBar = SnackBar(
                      content: Text('Product added successfully!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
