import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dbms_vehiclemanagement/models/models.dart';
import 'package:provider/provider.dart';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'dart:convert';
import 'package:dbms_vehiclemanagement/Colors.dart';
import 'package:dbms_vehiclemanagement/screens/updateEmission.dart';
import 'package:url_launcher/url_launcher.dart';
class Emission extends StatefulWidget {
  const Emission({Key? key}) : super(key: key);

  @override
  State<Emission> createState() => _EmissionState();
}

class _EmissionState extends State<Emission> {
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  DateTime selectedIssueDate =DateTime.now();
  DateTime selectedExpirationDate = DateTime.now();
  Vehicle? selectedVehicle;
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
          "View and Add Details",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Provider.of<Manager>(context, listen: true).l3.isNotEmpty
              ? ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.teal[50],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Text(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u.uid]!.firstWhere(() => Provider.of<Manager>(context,listen: true).l1[index].vehicleId==vehicleId).vehicleIdentificationNumber),
                      Text("Certificate Number:"),
                      SizedBox(width: 5),
                      Text(Provider.of<Manager>(context,listen: false).l3[index].certificateNumber),
                      SizedBox(width: 5),
                    ],
                  ),
                  subtitle:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Text(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u.uid]!.firstWhere(() => Provider.of<Manager>(context,listen: true).l1[index].vehicleId==vehicleId).vehicleIdentificationNumber),
                          Text("Expiry Date"),
                          SizedBox(width: 5),
                          Text(Provider.of<Manager>(context,listen: false).l3[index].expirationDate.toString()),
                          SizedBox(width: 5),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Text(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u.uid]!.firstWhere(() => Provider.of<Manager>(context,listen: true).l1[index].vehicleId==vehicleId).vehicleIdentificationNumber),
                          Text("Issue Date"),
                          SizedBox(width: 5),
                          Text(Provider.of<Manager>(context,listen: false).l3[index].issueDate.toString()),
                          SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmissionUpdateAndDelete(index:index),
                          ));
                    },
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    iconSize: 20,
                  ),
                ),
              );
            },
            itemCount: Provider.of<Manager>(context, listen: true).l3.length,
          )
              : Text("No Items to be displayed", style: TextStyle(color: textSecondary)),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
        child: BottomNavigationBar(
          selectedItemColor: Colors.teal,
          backgroundColor: Colors.blue[50],
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
                            // Vehicle? selectedVehicle;

                            return Container(
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text("Register a new emission document",
                                        style:
                                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    TextField(
                                      style: TextStyle(color: Colors.black),
                                      controller: t1,
                                      decoration: InputDecoration(
                                        hintText: "Enter Certificate Number",
                                        hintStyle: TextStyle(color: Colors.black),
                                        icon: Icon(Icons.assignment, color: Colors.black),
                                        focusedBorder:
                                        OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
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
                                        print(selectedVehicle);
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
                                    SizedBox(height: 10),
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          final url = Uri.parse("http://${url2}/emission/register");
                                          var body = {
                                            "vehicle_id": selectedVehicle == null ? 1 : selectedVehicle?.vehicleId,
                                            "certificate_number": t1.text,
                                            "issue_date": selectedIssueDate.toIso8601String(),
                                            "expiration_date": selectedExpirationDate.toIso8601String(),
                                          };
                                          var pay = jsonEncode(body);
                                          var response = await http.post(url, body: pay);
                                          if (response.statusCode == 201) {
                                            await Provider.of<Manager>(context, listen: false).getVehicleRelated();
                                            Navigator.of(context).pop();
                                          } else {
                                            print(response.statusCode);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("Try again after some time"),
                                              backgroundColor: Colors.redAccent,
                                            ));
                                          }
                                        },
                                        child: Text("Register Emission Document",
                                            style: TextStyle(color: Colors.white)),
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
                    icon: Icon(Icons.add, color: Colors.teal)),
                backgroundColor: Colors.white,
                label: "Add New Emission"),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () async{
                      await _launchInBrowser(Uri.parse("https://www.justdial.com/Mysore/Emission-Testing-Centres/nct-10931993"));
                    }, icon: Icon(Icons.location_on, color: Colors.teal)),
                label: "Locate Near me"),
          ],
        ),
      ),
    );
  }
}
