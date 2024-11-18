import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:provider/provider.dart';
import 'package:dbms_vehiclemanagement/Colors.dart';
import '../models/models.dart';

class RegistrationUpdateAndDelete extends StatefulWidget {
  int index;

  RegistrationUpdateAndDelete({Key? key, required this.index});

  @override
  State<RegistrationUpdateAndDelete> createState() =>
      _RegistrationUpdateAndDeleteState();
}

class _RegistrationUpdateAndDeleteState
    extends State<RegistrationUpdateAndDelete> {
  TextEditingController t1 = TextEditingController(); // Document Name
  TextEditingController t2 = TextEditingController(); // Document Number
  TextEditingController t3 = TextEditingController(); // Expiration Date
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  DateTime selectedExpirationDate=DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration Documents",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () async {
              int currentIndex = widget.index;
              RegistrationDocuments currentDocument =
              Provider.of<Manager>(context, listen: false)
                  .l2[widget.index];

              t1.text = currentDocument.documentName;
              t2.text = currentDocument.documentNumber;
              t3.text = currentDocument.expirationDate.toLocal().toString();

              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text("Edit Registration Document",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: t1,
                                decoration: InputDecoration(
                                  hintText: "Enter Document Name",
                                  hintStyle: TextStyle(color: Colors.black),
                                  icon: Icon(Icons.text_fields,
                                      color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.teal)),
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(height: 10),

                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: t2,
                                decoration: InputDecoration(
                                  hintText: "Enter Document Number",
                                  hintStyle: TextStyle(color: Colors.black),
                                  icon: Icon(Icons.confirmation_num,
                                      color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.teal)),
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(child: Text("Enter Expiration Date",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:textSecondary),),alignment: Alignment.topLeft,),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedExpirationDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      selectedExpirationDate = pickedDate;
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: TextEditingController(
                                        text: selectedExpirationDate.toLocal().toString().split(' ')[0]),
                                    decoration: InputDecoration(
                                      hintText: "Select Expiration Date",
                                      hintStyle: TextStyle(color: Colors.black),
                                      icon: Icon(Icons.calendar_today, color: Colors.black),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Note the details entered are to be verified with DigiLocker.By Regestering You might have Verification emails sent\n\n.We ensure that no data of yours will be used without prior consent.QR Code is under development stages and might not be fully functional",style: TextStyle(color: textSecondary)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  onPressed: () async {
                                    final url = Uri.parse(
                                        "http://${url2}/registration/update/${Provider.of<Manager>(context,listen: false).l2[widget.index].vehicleId}");
                                    print(url);
                                    var body = {
                                      "document_name": t1.text,
                                      "document_number": t2.text,
                                      "expiration_date": selectedExpirationDate.toIso8601String(),
                                    };
                                    var pay = jsonEncode(body);
                                    var response =
                                    await http.put(url, body: pay);
                                    if (response.statusCode == 200) {
                                      await Provider.of<Manager>(context,
                                          listen: false)
                                          .getVehicleRelated();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Try again after some time"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  },
                                  child: Text("Update Details",
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.teal,
                                  minWidth: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  child: Image.network("https://play-lh.googleusercontent.com/lomBq_jOClZ5skh0ELcMx4HMHAMW802kp9Z02_A84JevajkqD87P48--is1rEVPfzGVf"),
                  height: 200,
                  width: 200,
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: Text("Registration Document Details",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Document Name",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("${Provider.of<Manager>(context, listen: false).l2[widget.index].documentName}")
                ],
              ),

              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Document Number",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("${Provider.of<Manager>(context, listen: false).l2[widget.index].documentNumber}")
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Expiration Date",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("${Provider.of<Manager>(context, listen: false).l2[widget.index].expirationDate.toLocal().toString()}")
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.delete, color: Colors.white),
        onPressed: () async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you Sure you want to delete this.'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'Note deleting this registration document will consequently delete all the associated data.'),
                      Text('Would you like to approve deletion?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('No', style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Yes', style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      final url = Uri.parse(
                          "http://${url2}/registration/delete/${Provider.of<Manager>(context, listen: false).l2[widget.index].vehicleId}");
                      var response = await http.delete(url);
                      if (response.statusCode == 200) {
                        await Provider.of<Manager>(context, listen: false)
                            .getVehicleRelated();
                        Provider.of<Manager>(context,listen: false).l2.removeAt(widget.index);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error Occurred While deleting"),
                          backgroundColor: Colors.redAccent,
                        ));
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
