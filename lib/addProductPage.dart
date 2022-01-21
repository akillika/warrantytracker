// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:warrantytracker/chooseCategory.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  DateTime selectedDate = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController months = TextEditingController();
  TextEditingController notes = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    nameController.clear();
    months.clear();
    notes.clear();
    super.initState();
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
                "Add a Product",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name of the product"),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Date of Purchase",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueGrey)),
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: months,
                keyboardType: TextInputType.datetime,
                decoration:
                    InputDecoration(hintText: "Warranty period in months"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: notes,
                decoration: InputDecoration(hintText: "Notes"),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text != "" && months.text != "") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseCategoryPage(
                                      name: nameController.text,
                                      datePurchased: selectedDate,
                                      warrantyMonths: months.text,
                                      notes: notes.text)));
                        } else {
                          const snackBar = SnackBar(
                            content: Text('Enter Name and Warranty in months'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text("Next")))
            ],
          ),
        ),
      ),
    );
  }
}
