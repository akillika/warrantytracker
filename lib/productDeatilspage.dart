// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class ProductDetailspage extends StatefulWidget {
  final String productID;
  const ProductDetailspage({Key? key, required this.productID})
      : super(key: key);

  @override
  _ProductDetailspageState createState() => _ProductDetailspageState();
}

class _ProductDetailspageState extends State<ProductDetailspage> {
  String? productName, invoiceURL, warrantinMonths, category, notes, docId;

  DateTime? purchasedDate, expiryDate;

  getData() async {
    var collection = FirebaseFirestore.instance
        .collection('Database')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Products");
    var docSnapshot = await collection
        .where("id", isEqualTo: widget.productID)
        .get()
        .then((value) {
      setState(() {
        productName = value.docs[0]["name"];
        invoiceURL = value.docs[0]["invoiceLink"];
        purchasedDate = value.docs[0]["datePurchased"].toDate();
        expiryDate = value.docs[0]["dateExpires"].toDate();
        warrantinMonths = value.docs[0]["months"];
        category = value.docs[0]["category"];
        notes = value.docs[0]["notes"];
        docId = value.docs[0].reference.id;
      });
      print(invoiceURL);
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productName ?? "Loading",
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
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
              SizedBox(
                height: 20,
              ),
              Center(
                child: invoiceURL == null || invoiceURL == "null"
                    ? Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(child: Text("No Invoice available")),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: Image.network(
                          invoiceURL!,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Purchased Date",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        purchasedDate == null
                            ? "Loading"
                            : purchasedDate!
                                .toLocal()
                                .toString()
                                .substring(0, 10),
                        style: TextStyle(color: Colors.black, fontSize: 16),
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
                        "Warranty Expires on",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        expiryDate == null
                            ? "Loading"
                            : expiryDate!.toLocal().toString().substring(0, 10),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Warranty in months",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        warrantinMonths ?? "Loading",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Catergory",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        category ?? "Loading",
                        style: TextStyle(color: Colors.black, fontSize: 16),
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
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                notes == null || notes == "" ? "No Notes" : notes!,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 40,
              ),
              invoiceURL == null || invoiceURL == "null"
                  ? Container()
                  : GestureDetector(
                      onTap: () async {
                        try {
                          var imageId =
                              await ImageDownloader.downloadImage(invoiceURL!);
                          if (imageId == null) {
                            return;
                          }
                          var path = await ImageDownloader.findPath(imageId);
                        } on PlatformException catch (error) {
                          print(error);
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cloud_download,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Download Reciept",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('Database')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Products")
                      .doc(docId)
                      .delete()
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.delete,
                      color: Colors.black87,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Delete Item",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
