import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //late String selectedVehicle;
  late String complaint;
  late String fileDocumentPath;
  late String fileType;
  late int fileSize;
  late bool resolved;
  Vehicle? selectedVehicle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Complaint',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  ...Provider.of<Manager>(context, listen: false).l6
                      .map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
                    return DropdownMenuItem<Vehicle>(
                      value: vehicle,
                      child: Text(vehicle.vehicleIdentificationNumber),
                    );
                  }).toList(),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Complaint',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a complaint';
                  }
                  return null;
                },
                onSaved: (value) {
                  complaint = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'File Document Path',
                ),
                onSaved: (value) {
                  fileDocumentPath = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'File Type',
                ),
                onSaved: (value) {
                  fileType = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'File Size',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter file size';
                  }
                  return null;
                },
                onSaved: (value) {
                  fileSize = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    sendComplaintRegistrationRequest();
                  }
                },
                child: Text('Register Complaint'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendComplaintRegistrationRequest() async {
    final apiUrl = Uri.parse("http://${url2}/complaints/register");

    final response = await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'vehicle_id': selectedVehicle==null?"":selectedVehicle?.vehicleId,
        'complaint': complaint,
        'file_document_path': fileDocumentPath,
        'file_type': fileType,
        'file_size': fileSize,
        'resolved': false,
        'complaint_date':DateTime.now().toIso8601String(),
        'upload_date':DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      await Provider.of<Manager>(context,listen: false).getVehicleRelated();
      print('Complaint registered successfully');
      Navigator.popAndPushNamed(context, '/');
    } else {
      print('Error registering complaint: ${response.statusCode}');
    }
  }
}
