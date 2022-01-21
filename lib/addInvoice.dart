// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, must_call_super, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warrantytracker/addProductPage.dart';

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
  var _image;
  var imagePicker;
  var type;

  @override
  void initState() {
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
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                        _image,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.red[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
              Center(
                child: ElevatedButton(
                  child: Text("Upload Image"),
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _image = File(image!.path);
                    });
                  },
                ),
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
