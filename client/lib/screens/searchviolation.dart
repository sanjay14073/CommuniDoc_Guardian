import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:dbms_vehiclemanagement/models/models.dart';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'dart:convert';
import 'package:dbms_vehiclemanagement/Colors.dart';
class Complaints extends StatefulWidget {
  const Complaints({Key? key}) : super(key: key);

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Existing Complaints",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body:Provider.of<Manager>(context,listen: false).l5.isNotEmpty?
      ListView.builder(
          itemCount: Provider.of<Manager>(context,listen: true).l5.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              tileColor: Colors.teal[50],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Text(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u.uid]!.firstWhere(() => Provider.of<Manager>(context,listen: true).l1[index].vehicleId==vehicleId).vehicleIdentificationNumber),
                  Text("Complaint Details\n"),
                  SizedBox(width: 5),
                  Wrap(
                    children: [
                      Text(
                        Provider.of<Manager>(context, listen: false).l5[index].complaint,
                        style: TextStyle(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                ],
              ),
              subtitle:Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Text(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u.uid]!.firstWhere(() => Provider.of<Manager>(context,listen: true).l1[index].vehicleId==vehicleId).vehicleIdentificationNumber),
                      Text("Complaint Date"),
                      SizedBox(width: 5),
                      Text(Provider.of<Manager>(context,listen: false).l5[index].complaintDate.toString()),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            );
          })
          :Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(child: Text("Good Work\nYou are a Safe Driver\nYou will live longer",style: TextStyle(color:textSecondary,fontWeight: FontWeight.bold,fontSize: 36),),),
          ),
    );
  }
}
