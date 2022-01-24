// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, must_call_super, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? downloadURL;
  Future<String?> uploadImage() async {
    String postId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser!.uid}/Invoice")
        .child(postId);
    await ref.putFile(_image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

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
                "Upload Invoice (Optional)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40,
              ),
              _image != null
                  ? Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(color: Colors.red[200]),
                        child: Image.file(
                          _image,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        children: [
                          Text(
                            "Upload the invoice of the product. So that you'll have it handy everywhere you go!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40),
                          Text(
                            "No Image selected",
                            textAlign: TextAlign.center,
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
              Center(
                child: ElevatedButton(
                  child: Text("Select Invoice"),
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
              SizedBox(height: 20),
              Text(
                "Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Name",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.name,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.category,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date Purchased",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.datePurchased
                            .toLocal()
                            .toString()
                            .substring(0, 10),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date Expires",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.datePurchased
                            .toLocal()
                            .toString()
                            .substring(0, 10),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Notes",
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
              SizedBox(
                height: 3,
              ),
              widget.notes == ""
                  ? Text(
                      "No notes has been entered",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    )
                  : Text(
                      widget.notes,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  child: Text("Save to my account"),
                  onPressed: () async {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Saving....'),
                          content: Center(child: CircularProgressIndicator()),
                        );
                      },
                    );
                    if (_image != null) {
                      await uploadImage();
                    }
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
                          "category": widget.category,
                          "invoiceLink":
                              downloadURL != null ? downloadURL : "null",
                          "id":
                              "${FirebaseAuth.instance.currentUser!.uid}_${DateTime.now().microsecondsSinceEpoch}"
                        })
                        .then((value) => print("Data Added"))
                        .catchError(
                            (error) => print("Failed to add Data: $error"));
                    Navigator.of(context, rootNavigator: true).pop();
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
