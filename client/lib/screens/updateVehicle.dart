import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dbms_vehiclemanagement/models/models.dart';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:provider/provider.dart';

import '../Colors.dart';

class VehicleUpdateAndDelete extends StatefulWidget {
  int index;

  VehicleUpdateAndDelete({Key? key, required this.index});

  @override
  State<VehicleUpdateAndDelete> createState() => _VehicleUpdateAndDeleteState();
}

class _VehicleUpdateAndDeleteState extends State<VehicleUpdateAndDelete> {
  List<String> fieldNames = [
    "userId",
    "ownerName",
    "vehicleId",
    "make",
    "model",
    "makeYear",
    "vehicleIdentificationNumber",
    "licenceNumber",
  ];
  TextEditingController t1 = TextEditingController(); // Owner Name
  TextEditingController t2 = TextEditingController(); // Model
  TextEditingController t3 = TextEditingController(); // Registration Number
  TextEditingController t4 = TextEditingController(); // License Number

  // Other variables for dropdowns and selected values
  String selectedMake = "";
  int selectedYear = 2001;
  String selectedState = "";
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () async {
              // Assuming you have a list of vehicles and a current index
              int currentIndex = widget.index;
              Vehicle currentVehicle = Provider.of<Manager>(context, listen: false)
                  .m1[Provider.of<Manager>(context, listen: false).u]![currentIndex];

              // Set initial values for the text controllers and dropdowns
              t1.text = currentVehicle.ownerName;
              t2.text = currentVehicle.model;
              t3.text = currentVehicle.vehicleIdentificationNumber;
              t4.text = currentVehicle.licenceNumber;
              selectedMake = currentVehicle.make;
              selectedYear = currentVehicle.makeYear;

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
                          child: Column(
                            children: [
                              Text("Edit Vehicle Details",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: t1,
                                decoration: InputDecoration(
                                  hintText: "Enter Owner name",
                                  hintStyle: TextStyle(color: Colors.black),
                                  icon: Icon(
                                      Icons.account_circle_rounded,
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
                                  hintText: "Enter Model",
                                  hintStyle: TextStyle(color: Colors.black),
                                  icon: Icon(Icons.model_training,
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
                                controller: t3,
                                decoration: InputDecoration(
                                  hintText: "Enter Registration Number",
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

                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: t4,
                                decoration: InputDecoration(
                                  hintText: "Enter License Number",
                                  hintStyle: TextStyle(color: Colors.black),
                                  icon: Icon(Icons.numbers,
                                      color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.teal)),
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Note the details entered are to be verified with DigiLocker.By Regestering You might have Verification emails sent.We ensure that no data of yours will be used without prior consent.",style: TextStyle(color: textSecondary),),
                              SizedBox(height: 10,),


                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  onPressed: () async {
                                    final url = Uri.parse(
                                        "http://${url2}/vehicles/update/${currentVehicle.vehicleId}");
                                    var body = {
                                      "owner_name": t1.text,
                                      "model": t2.text,
                                      "vehicle_identification_number": t3.text,
                                      "licence_number":t4.text,
                                    };
                                    var pay = jsonEncode(body);
                                    var response =
                                    await http.put(url, body: pay);
                                    if (response.statusCode == 200) {
                                      // Handle success
                                      // Close the bottom sheet
                                       await Provider.of<Manager>(context,
                                           listen: false)
                                           .updateVehicles();
                                     // Navigator.of(context).pop();
                                       Navigator.pop(context);
                                       Navigator.pop(context);
                                    } else {
                                      // Handle error
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Try again after some time"),
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
              Center(child: Text("Vehicle Details",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("userID",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].userId}")
                ],
              ),

              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("vehicleID",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].vehicleId}")
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Vehicle Identification Number",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].vehicleIdentificationNumber}")
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Model",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].model}")
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Make",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].make}")
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("State of Origin",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].licenceNumber}")
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Year",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].makeYear.toString()}")
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
                          'Note deleting this vehicle will consequently delete all the documents related to it.'),
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
                          "http://${url2}/vehicles/delete/${Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]![widget.index].vehicleId}");
                      var response = await http.delete(url);
                      if (response.statusCode == 200) {
                        await Provider.of<Manager>(context, listen: false)
                            .updateVehicles();
                        //Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]!.removeAt(widget.index);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error Occured While deleting"),
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

