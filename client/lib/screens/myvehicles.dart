import 'dart:convert';

import 'package:dbms_vehiclemanagement/screens/updateVehicle.dart';
import 'package:flutter/material.dart';
import 'package:dbms_vehiclemanagement/Colors.dart';
import 'package:provider/provider.dart';
import 'package:dbms_vehiclemanagement/models/models.dart';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<Vehicle> prev = [];
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController t6 = TextEditingController();
  String? selectedMake;
  int? selectedYear;
  String? selectedState;
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      //  throw Exception('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't Process the Request Now"),backgroundColor: Colors.redAccent,));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "View and Register",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: false).u] != null
              ? ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.teal[50],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: true).u]![index].vehicleIdentificationNumber),
                      SizedBox(width: 5,),
                      Text(Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: true).u]![index].make),
                      SizedBox(width: 5,),
                      Text(Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: true).u]![index].model),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => VehicleUpdateAndDelete(index:index),
                      ));
                    },
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    iconSize: 20,
                  ),
                ),
              );
            },
            itemCount: Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: true).u]!.length,
          )
              : Text("No Items to be displayed", style: TextStyle(color: textSecondary)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
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
                              child: Column(
                                children: [
                                  Text("Register a new vehicle", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                  TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: t1,
                                    decoration: InputDecoration(
                                      hintText: "Enter Owner name",
                                      hintStyle: TextStyle(color: Colors.black),
                                      icon: Icon(Icons.account_circle_rounded, color: Colors.black),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  SizedBox(height: 10,),

                                  // Make Dropdown
                                  TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: t2,
                                    decoration: InputDecoration(
                                      hintText: "Enter Model",
                                      hintStyle: TextStyle(color: Colors.black),
                                      icon: Icon(Icons.model_training, color: Colors.black),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  SizedBox(height: 10,),

                                  TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: t3,
                                    decoration: InputDecoration(
                                      hintText: "Enter Registration Number",
                                      hintStyle: TextStyle(color: Colors.black),
                                      icon: Icon(Icons.confirmation_num, color: Colors.black),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  // Make Dropdown

                                  SizedBox(height: 10,),
                                  DropdownButton<String>(
                                    hint: Text("Select Make"),
                                    isExpanded: true,
                                    value: selectedMake,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedMake = value;
                                      });
                                    },
                                    items: ["Honda", "Suzuki", "Toyota","Kia","Hero","Bajaj"].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,

                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),

                                  SizedBox(height: 10,),

                                  // TextField(
                                  //   style: TextStyle(color: Colors.black),
                                  //   controller: t4,
                                  //   decoration: InputDecoration(
                                  //     hintText: "Enter License number",
                                  //     hintStyle: TextStyle(color: Colors.black),
                                  //     icon: Icon(Icons.numbers, color: Colors.black),
                                  //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                  //     border: InputBorder.none,
                                  //   ),
                                  // ),
                                  SizedBox(height: 10,),

                                  // Year Dropdown
                                  DropdownButton<int>(
                                    hint: Text("Select Make Year"),
                                    value: selectedYear,
                                    isExpanded: true,
                                    onTap: () {
                                      FocusManager.instance.primaryFocus?.unfocus(); // Close keyboard
                                    },
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedYear = value;
                                      });
                                    },
                                    items: [2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023 ].map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,

                                        onTap: () {
                                          FocusManager.instance.primaryFocus?.unfocus(); // Close keyboard
                                        },
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 10,),
                                  DropdownButton<String>(

                                    hint: Text("Select the State "),
                                    value: selectedState,
                                    isExpanded: true,
                                    onTap: () {
                                      FocusManager.instance.primaryFocus?.unfocus(); // Close keyboard
                                    },
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedState = value;
                                      });
                                    },
                                    items: ["KA","TN","KL","TS","AP","PY","GJ","MH"].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        onTap: () {
                                          FocusManager.instance.primaryFocus?.unfocus(); // Close keyboard
                                        },
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      onPressed: ()async {
                                        final url=Uri.parse("http://${url2}/vehicles");
                                        var body={
                                          "user_id":Provider.of<Manager>(context,listen: false).u.uid!,
                                          "owner_name":t1.text,
                                          "vehicle_id":Uuid().v4(),
                                          "make":selectedMake??"",
                                          "model":t2.text,
                                          "make_year":(selectedYear??0),
                                          "vehicle_identification_number":t3.text,
                                          "licence_number":selectedState ?? "",
                                        };
                                        var pay=jsonEncode(body);
                                        var response=await http.post(url,body: pay);
                                        if(response.statusCode==201) {
                                          Vehicle v=Vehicle();
                                          v.userId=Provider.of<Manager>(context,listen: false).u.uid!;
                                          v.vehicleIdentificationNumber=t3.text;
                                          v.ownerName=t1.text;
                                          v.make=selectedMake??"";
                                          v.model=t2.text;
                                          v.vehicleId="";
                                          v.licenceNumber=selectedState??"";
                                          v.makeYear=(selectedYear??0) as int;
                                          t1.clear();
                                          t2.clear();
                                          t3.clear();
                                          selectedYear=null;
                                          selectedState="";
                                          await Provider.of<Manager>(context,listen:false).updateVehicles();
                                          Navigator.of(context).pop();

                                        }
                                        else{
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Try again after some time"),backgroundColor: Colors.redAccent,));
                                        }

                                      },
                                      child: Text("Register Now", style: TextStyle(color: Colors.white)),
                                      color: Colors.teal,
                                      minWidth: double.infinity,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      Text("Add a Vehicle", style: TextStyle(color: textPrimary)),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


