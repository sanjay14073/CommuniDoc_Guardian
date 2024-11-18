import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:provider/provider.dart';
import 'package:dbms_vehiclemanagement/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:dbms_vehiclemanagement/Colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:dbms_vehiclemanagement/screens/updateInsurance.dart';
class Insurance extends StatefulWidget {
  const Insurance({Key? key}) : super(key: key);

  @override
  State<Insurance> createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController t6 = TextEditingController();
  String? selectedMake;
  int? selectedYear;
  String? selectedState;
  Vehicle?selectedVehicle;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Provider.of<Manager>(context,listen: false).l1.length);
  }
  @override
  Widget build(BuildContext context) {
    var userVehicles = Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: false).u.uid];
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
          if (Provider.of<Manager>(context, listen: true).l1.isNotEmpty) ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.teal[50],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Text(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u.uid]!.firstWhere(() => Provider.of<Manager>(context,listen: true).l1[index].vehicleId==vehicleId).vehicleIdentificationNumber),
                      Text("Policy No:"),
                      SizedBox(width: 5),
                      Text(Provider.of<Manager>(context,listen: false).l1[index].policyNumber),
                      SizedBox(width: 5),
                    ],
                  ),
                  subtitle:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Text(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u.uid]!.firstWhere(() => Provider.of<Manager>(context,listen: true).l1[index].vehicleId==vehicleId).vehicleIdentificationNumber),
                      Text("Expiry Date"),
                      SizedBox(width: 5),
                      Text(Provider.of<Manager>(context,listen: false).l1[index].expireDate.toString()),
                      SizedBox(width: 5),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InsuranceUpdateAndDelete(index:index),
                          ));
                    },
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    iconSize: 20,
                  ),
                ),
              );
            },
            itemCount: Provider.of<Manager>(context, listen: true).l1.length,
          ) else Text("No Items to be displayed", style: TextStyle(color: textSecondary)),

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
              BottomNavigationBarItem(icon: IconButton(onPressed: (){

                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      DateTime selectedExpireDate = DateTime.now();
                      //Vehicle? selectedVehicle;

                      return Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text("Register a new insurance", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: t1,
                                decoration: InputDecoration(
                                  hintText: "Enter Policy Number",
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
                                  hintText: "Enter File Document Path",
                                  hintStyle: TextStyle(color: Colors.black),
                                  icon: Icon(Icons.file_copy, color: Colors.black),
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
                                  print(selectedVehicle);
                                },
                                items: [
                                  DropdownMenuItem<Vehicle?>(
                                    value: null,
                                    child: Text("None"),
                                  ),
                                  ...Provider.of<Manager>(context, listen: false).m1[Provider.of<Manager>(context, listen: false).u]!
                                      .map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
                                    return DropdownMenuItem<Vehicle>(
                                      value: vehicle,
                                      child: Text(vehicle.vehicleIdentificationNumber),
                                    );
                                  }).toList(),
                                ],
                              ),
                              SizedBox(height: 10),
                              Align(child: Text("Enter Expiry Date",style: TextStyle(color: textSecondary,fontWeight: FontWeight.bold,fontSize: 12),),alignment: Alignment.topLeft,),
                              SizedBox(height:10),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedExpireDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      selectedExpireDate = pickedDate;
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: TextEditingController(text: selectedExpireDate.toLocal().toString().split(' ')[0]),
                                    decoration: InputDecoration(
                                      hintText: "Select Expire Date",
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

                                    final url = Uri.parse("http://${url2}/insurance/register");
                                    var body = {
                                      "vehicle_id": selectedVehicle==null?1:selectedVehicle?.vehicleId,
                                      "policy_number": t1.text,
                                      "expire_date": selectedExpireDate.toIso8601String(),
                                      "file_document_path": t2.text,
                                      "docs_status": "to be verified",
                                      "upload_date": DateTime.now().toIso8601String(),
                                      "insurance_id":Uuid().v4().toString(),
                                    };
                                    print(body["insurance_id"].toString().length);
                                    var pay = jsonEncode(body);
                                    var response = await http.post(url, body: pay);
                                    if (response.statusCode == 201) {
                                      await Provider.of<Manager>(context, listen: false).getVehicleRelated();
                                      Navigator.of(context).pop();
                                      //Navigator.of(context).pop();
                                    } else {
                                      print(response.statusCode);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text("Try again after some time"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  },
                                  child: Text("Register Insurance", style: TextStyle(color: Colors.white)),
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





              }, icon: Icon(Icons.add,color: Colors.teal,)),backgroundColor: Colors.white,label: "Add New Insurance"),
              BottomNavigationBarItem(icon: IconButton(onPressed: ()async{
                await _launchInBrowser(Uri.parse("https://www.phonepe.com/insurance/"));
              }, icon: Icon(Icons.shopping_cart,color:Colors.teal,)),label: "Buy online"),
        ]),
      ),
    );
  }
}
