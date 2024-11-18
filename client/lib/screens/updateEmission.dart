import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import 'package:dbms_vehiclemanagement/Colors.dart';
class EmissionUpdateAndDelete extends StatefulWidget {
  int index;

  EmissionUpdateAndDelete({Key? key, required this.index});

  @override
  State<EmissionUpdateAndDelete> createState() =>
      _EmissionUpdateAndDeleteState();
}

class _EmissionUpdateAndDeleteState
    extends State<EmissionUpdateAndDelete> {
  TextEditingController t1 = TextEditingController(); // Certificate Number
  TextEditingController t2 = TextEditingController(); // Issue Date
  TextEditingController t3 = TextEditingController(); // Expiration Date
  DateTime selectedIssueDate =DateTime.now();
  DateTime selectedExpirationDate = DateTime.now();
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Emission Certificate",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () async {
              int currentIndex = widget.index;
              EmissionDocuments currentEmission =
              Provider.of<Manager>(context, listen: false)
                  .l3[widget.index];

              t1.text = currentEmission.certificateNumber;
              t2.text = currentEmission.issueDate.toLocal().toString();
              t3.text = currentEmission.expirationDate.toLocal().toString();

              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text("Edit Emission Certificate",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextField(
                                  style: TextStyle(color: Colors.black),
                                  controller: t1,
                                  decoration: InputDecoration(
                                    hintText: "Enter Certificate Number",
                                    hintStyle: TextStyle(color: Colors.black),
                                    icon: Icon(Icons.format_list_numbered,
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
                                    hintText: "Enter Issue Date",
                                    hintStyle: TextStyle(color: Colors.black),
                                    icon: Icon(Icons.calendar_today,
                                        color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.teal)),
                                    border: InputBorder.none,
                                  ),
                                ),
                                // SizedBox(height: 10),
                                //
                                // TextField(
                                //   style: TextStyle(color: Colors.black),
                                //   controller: t3,
                                //   decoration: InputDecoration(
                                //     hintText: "Enter Expiration Date",
                                //     hintStyle: TextStyle(color: Colors.black),
                                //     icon: Icon(Icons.calendar_today,
                                //         color: Colors.black),
                                //     focusedBorder: OutlineInputBorder(
                                //         borderSide:
                                //         BorderSide(color: Colors.teal)),
                                //     border: InputBorder.none,
                                //   ),
                                // ),
                                SizedBox(height: 10,),
                                Align(child: Text("Enter Expiry Date",style: TextStyle(color: textSecondary,fontWeight: FontWeight.bold,fontSize: 12),),alignment: Alignment.topLeft,),
                                SizedBox(height: 10),
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
                                        focusedBorder:
                                        OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height:10),
                                Align(child: Text("Enter Issue Date",style: TextStyle(color: textSecondary,fontWeight: FontWeight.bold,fontSize: 12),),alignment: Alignment.topLeft,),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedIssueDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        selectedIssueDate = pickedDate;
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextField(
                                      style: TextStyle(color: Colors.black),
                                      controller: TextEditingController(
                                          text: selectedIssueDate.toLocal().toString().split(' ')[0]),
                                      decoration: InputDecoration(
                                        hintText: "Select Issue Date",
                                        hintStyle: TextStyle(color: Colors.black),
                                        icon: Icon(Icons.calendar_today, color: Colors.black),
                                        focusedBorder:
                                        OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      //print(currentEmission.certificateNumber);
                                      //print(currentEmission.emissionId);
                                      final url = Uri.parse(
                                          "http://$url2/emission/update/${Provider.of<Manager>(context,listen: false).l3[widget.index].vehicleId}");
                                     // print(url);
                                      var body = {
                                        "certificate_number": t1.text,
                                        "issue_date": selectedIssueDate.toIso8601String(),
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
                  child: Text("Emission Certificate Details",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Certificate Number",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("${Provider.of<Manager>(context, listen: false).l3[widget.index].certificateNumber}")
                ],
              ),

              SizedBox(height: 20),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("Issue Date",
              //         style: TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.bold)),
              //     SizedBox(height: 10),
              //     Text("${Provider.of<Manager>(context, listen: false).l3[widget.index].issueDate.toLocal().toString()}")
              //   ],
              // ),
              // SizedBox(height: 20),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("Expiration Date",
              //         style: TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.bold)),
              //     SizedBox(height: 10),
              //     Text("${Provider.of<Manager>(context, listen: false).l3[widget.index].expirationDate.toLocal().toString()}")
              //   ],
              // ),
              Align(child: Text("Enter Issue Date",style: TextStyle(color: textSecondary,fontWeight: FontWeight.bold,fontSize: 12),),alignment: Alignment.topLeft,),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedIssueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedIssueDate = pickedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: TextEditingController(
                        text: selectedIssueDate.toLocal().toString().split(' ')[0]),
                    decoration: InputDecoration(
                      hintText: "Select Issue Date",
                      hintStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Align(child: Text("Enter Expiry Date",style: TextStyle(color: textSecondary,fontWeight: FontWeight.bold,fontSize: 12),),alignment: Alignment.topLeft,),
              SizedBox(height: 10),
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
                      focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text("Note the details entered are to be verified with DigiLocker.By Regestering You might have Verification emails sent.We ensure that no data of yours will be used without prior consent.",style: TextStyle(color: textSecondary),),
              SizedBox(height: 10,),
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
                          'Note deleting this emission certificate will consequently delete all the associated data.'),
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
                          "http://${url2}/emission/delete/${Provider.of<Manager>(context, listen: false).l3[widget.index].vehicleId}");
                      //print(url);
                      var response = await http.delete(url);
                      if (response.statusCode == 200) {
                        await Provider.of<Manager>(context, listen: false)
                            .getVehicleRelated();
                        Provider.of<Manager>(context,listen: false).l3.removeAt(widget.index);
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
