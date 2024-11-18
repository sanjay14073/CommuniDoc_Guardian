import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:provider/provider.dart';
import 'package:dbms_vehiclemanagement/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:dbms_vehiclemanagement/Colors.dart';
import 'package:dbms_vehiclemanagement/screens/updateRegestration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
class RegistrationDocument extends StatefulWidget {
  const RegistrationDocument({Key? key}) : super(key: key);

  @override
  State<RegistrationDocument> createState() => _RegistrationDocumentState();
}

class _RegistrationDocumentState extends State<RegistrationDocument> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  String? selectedMake;
  int? selectedYear;
  String? selectedState;
  Vehicle? selectedVehicle;
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
    var userVehicles =
    Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: false).u.uid];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "View and Add Other Documents",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (Provider.of<Manager>(context, listen: true).l2.isNotEmpty)
            ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.teal[50],
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Document Name:"),
                        SizedBox(width: 5),
                        Text(Provider.of<Manager>(context, listen: false).l2[index].documentName),
                        SizedBox(width: 5),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Document Number"),
                        SizedBox(width: 5),
                        Text(Provider.of<Manager>(context, listen: false).l2[index].documentNumber),
                        SizedBox(width: 5),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationUpdateAndDelete(index:index),
                            ));
                      },
                      icon: Icon(Icons.arrow_forward_ios_outlined),
                      iconSize: 20,
                    ),
                  ),
                );
              },
              itemCount: Provider.of<Manager>(context, listen: true).l2.length,
            )
          else
            Text("No Items to be displayed", style: TextStyle(color: textSecondary)),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
        child: BottomNavigationBar(
          selectedItemColor: Colors.teal,
          backgroundColor: Colors.teal[50],
          unselectedItemColor: Colors.teal,
          iconSize: 24,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        DateTime selectedExpirationDate = DateTime.now();

                        return Container(
                          height: MediaQuery.of(context).size.height * 0.85,
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text("Register a new document", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                TextField(
                                  style: TextStyle(color: Colors.black),
                                  controller: t1,
                                  decoration: InputDecoration(
                                    hintText: "Enter Document Name",
                                    hintStyle: TextStyle(color: Colors.black),
                                    icon: Icon(Icons.assignment, color: Colors.black),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
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
                                    icon: Icon(Icons.confirmation_number, color: Colors.black),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                    border: InputBorder.none,
                                  ),
                                ),
                                SizedBox(height: 10),
                                DropdownButtonFormField<Vehicle?>(
                                  hint: Text("Select a Vehicle"),
                                  value: selectedVehicle,
                                  onChanged: (Vehicle? value) {
                                    setState(() {
                                      selectedVehicle = value;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<Vehicle?>(
                                      value: null,
                                      child: Text("None"),
                                    ),
                                    ...Provider.of<Manager>(context, listen: false)
                                        .m1[Provider.of<Manager>(context, listen: false).u]!
                                        .map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
                                      return DropdownMenuItem<Vehicle>(
                                        value: vehicle,
                                        child: Text(vehicle.vehicleIdentificationNumber),
                                      );
                                    }).toList(),
                                  ],
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
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text("Note the details entered are to be verified with DigiLocker.By Regestering You might have Verification emails sent\n.We ensure that no data of yours will be used without prior consent.",style: TextStyle(color: textSecondary),),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      final url = Uri.parse("http://${url2}/documents/register");
                                      var body = {
                                        "vehicle_id": selectedVehicle?.vehicleId,
                                        "document_name": t1.text,
                                        "document_number": t2.text,
                                        "expiration_date": selectedExpirationDate.toIso8601String(),
                                      };
                                      var pay = jsonEncode(body);
                                      var response = await http.post(url, body: pay);
                                      if (response.statusCode == 201) {
                                        await Provider.of<Manager>(context, listen: false).getVehicleRelated();
                                        Navigator.of(context).pop();
                                      } else {
                                        print(response.statusCode);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Try again after some time"),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text("Register Document", style: TextStyle(color: Colors.white)),
                                    color: Colors.teal,
                                    minWidth: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: Icon(Icons.add, color: Colors.teal),
              ),
              backgroundColor: Colors.white,
              label: "Add New Document",
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () async{
                  await _launchInBrowser(Uri.parse("https://parivahan.gov.in/parivahan/"));
                },
                icon: Icon(Icons.search_sharp, color: Colors.teal),
              ),
              label: "Key Documents",
            ),
          ],
        ),
      ),
    );
  }
}
