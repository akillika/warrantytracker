// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailspage extends StatefulWidget {
  const ProductDetailspage({Key? key}) : super(key: key);

  @override
  _ProductDetailspageState createState() => _ProductDetailspageState();
}

class _ProductDetailspageState extends State<ProductDetailspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Headphones",
          style: TextStyle(color: Colors.black87, fontSize: 15),
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
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ]),
                  child: Image.network(
                    "https://cms.cloudinary.vpsvc.com//image/fetch/q_auto:best,w_700,f_auto,dpr_auto/https://s3-eu-west-1.amazonaws.com/sitecore-media-bucket/prod%2Fen-IN%2F%7B29558972-FE75-46B7-9A16-7A7A49B9864C%7D%3Fv%3D1d87d9d063b8aebffd9b68c77adc6ed1",
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
                        "25/11/2022",
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
                        "25/11/2022",
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
                        "11",
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
                        "Electronics",
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
                "This is bought for my birthday",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
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
              SizedBox(
                height: 20,
              ),
              Row(
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
