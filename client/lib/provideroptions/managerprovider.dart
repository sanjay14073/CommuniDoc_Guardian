import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dbms_vehiclemanagement/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Manager with ChangeNotifier {
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  Users u = Users();
  Map<Users, List<Vehicle>>m1 = {};
  Map<Vehicle, List<RegistrationDocuments>>m2 = {};
  Map<Vehicle, List<InspectionDocuments>>m3 = {};
  Map<Vehicle, List<EmissionDocuments>>m4 = {};
  Map<Vehicle, List<InsuranceDocuments>>m5 = {};
  List<InsuranceDocuments>l1 = [];
  List<RegistrationDocuments>l2 = [];
  List<EmissionDocuments>l3 = [];
  List<InspectionDocuments>l4 = [];
  List<ComplaintRegistration>l5 = [];
  List<Vehicle>l6 = [];

  void currUser(String email, String uid) async {
    // u=Users();
    u.email = email;
    u.uid = uid;
    m1[u] = [];
    notifyListeners();
  }

  Future<void> getVehicles() async {
    final url = Uri.parse("http://${url2}/vehicles/${u.uid}");

    final response = await http.get(url);

    List<dynamic> jsonList = json.decode(response.body)['vehicles'];
    List<Vehicle> vehicleList = List<Map<String, dynamic>>.from(jsonList).map((
        json) => Vehicle.fromJson(json)).toList();

    // Print the resulting list of Vehicle objects
    for (var vehicle in vehicleList) {
      m1[u]!.add(vehicle);
    }
    print(m1[u]!.length);
  }

  Future<void> updateVehicles() async {
    final url = Uri.parse("http://${url2}/vehicles/${u.uid}");

    final response = await http.get(url);
    List<dynamic> jsonList = json.decode(response.body)['vehicles'];
    List<Vehicle> vehicleList = List<Map<String, dynamic>>.from(jsonList).map((
        json) => Vehicle.fromJson(json)).toList();

    // Print the resulting list of Vehicle objects
    m1[u]!.clear();
    // l1.clear();
    for (var vehicle in vehicleList) {
      m1[u]!.add(vehicle);

      m2[vehicle] = [];
      m3[vehicle] = [];
      m4[vehicle] = [];
      m5[vehicle] = [];
    }
    print(m1[u]!.length);
    notifyListeners();
  }

Future<void>getAllVehicles()async{
    final url=Uri.parse('http://${url2}/vehicles/all');
    final response=await http.get(url);
    List<dynamic> jsonList = json.decode(response.body)['vehicles'];
    List<Vehicle> vehicleList = List<Map<String, dynamic>>.from(jsonList).map((json) => Vehicle.fromJson(json)).toList();

    // Print the resulting list of Vehicle objects
    //m1[u]!.clear();
    // l1.clear();
    l6.clear();
    for (var vehicle in vehicleList) {
      l6.add(vehicle);
    }
    //print(m1[u]!.length);
    notifyListeners();

}
  Future<void> getVehicleRelated() async {
    if (m1[u] != null) {
      for (var vehicle in m1[u]!) {
        //m5[vehicle]=[];
        final insuranceUrl =
        Uri.parse("http://${url2}/insurance/${u.uid}/${vehicle.vehicleId}");

        final insuranceResponse = await http.get(insuranceUrl);
        if (insuranceResponse.statusCode == 201) {
          List<dynamic> jsonList = json.decode(insuranceResponse.body)['insurance_documents'];
          List<InsuranceDocuments> insuranceList = jsonList
              .map((json) => InsuranceDocuments.fromJson(json))
              .toList();

          //m5[vehicle]!.clear();
          l1.clear();
          for (var insurance in insuranceList) {
            l1.add(insurance);
            //m5[vehicle]!.add(insurance);
          }
        } else {
          print("Insurance Error: ${insuranceResponse.statusCode}");
        }

        final emissionUrl =
        Uri.parse("http://${url2}/emission/${u.uid}/${vehicle.vehicleId}");

        final emissionResponse = await http.get(emissionUrl);
        if (emissionResponse.statusCode == 201) {
          List<dynamic> jsonList = json.decode(emissionResponse.body)['emission_documents'];
          List<EmissionDocuments> emissionList = jsonList
              .map((json) => EmissionDocuments.fromJson(json))
              .toList();

          //m4[vehicle]!.clear();
          l3.clear();
          for (var emission in emissionList) {
            //m4[vehicle]!.add(emission);
            l3.add(emission);
          }
        } else {
          print("Emission Error: ${emissionResponse.statusCode}");
        }

        final registrationUrl =
        Uri.parse("http://${url2}/registration/${u.uid}/${vehicle.vehicleId}");

        final registrationResponse = await http.get(registrationUrl);
        if (registrationResponse.statusCode == 201) {
          List<dynamic> jsonList = json.decode(registrationResponse.body)['registration_documents'];
          List<RegistrationDocuments> registrationList = jsonList
              .map((json) => RegistrationDocuments.fromJson(json))
              .toList();
          l2.clear();
         // m2[vehicle]!.clear();
          for (var registration in registrationList) {
           // m2[vehicle]!.add(registration);
            l2.add(registration);
          }
        } else {
          print("Registration Error: ${registrationResponse.statusCode}");
        }
        final complaintUrl =
        Uri.parse("http://${url2}/get_resolved_complaints/${vehicle.vehicleId}");

        final complaintResponse = await http.get(complaintUrl);
        if (complaintResponse.statusCode == 201) {
          List<dynamic> jsonList = json.decode(registrationResponse.body)['complaints'];
          List<ComplaintRegistration> ComplanintList = jsonList
              .map((json) => ComplaintRegistration.fromJson(json))
              .toList();
          l5.clear();
          // m2[vehicle]!.clear();
          for (var registration in ComplanintList) {
            // m2[vehicle]!.add(registration);
            l5.add(registration);
          }
        } else {
          print("Registration Error: ${registrationResponse.statusCode}");
        }
      }
    }
    
    notifyListeners();
  }
}
