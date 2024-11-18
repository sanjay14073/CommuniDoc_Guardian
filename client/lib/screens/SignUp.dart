import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dbms_vehiclemanagement/Colors.dart';
import 'package:http/http.dart' as http;
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.teal,
    //     title: Text("Sign Up for DashFury",style: TextStyle(color:background )),
    //     centerTitle: true,
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         TextField(controller: t1,),
    //         SizedBox(height: 20,),
    //         TextField(controller: t2,),
    //         SizedBox(height: 20,),
    //         TextField(controller: t2,),
    //         SizedBox(height: 20,),
    //         MaterialButton(onPressed: (){},child: Text("Sign Up"),),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text("Hey\nSign Up\nNow",style: TextStyle(fontSize: 70,fontWeight: FontWeight.bold,color: Colors.white),),
              SizedBox(height: 30,),
              TextField(style: TextStyle(color: background),controller: t1,decoration: InputDecoration(hintText: "Enter email",hintStyle: TextStyle(color: Colors.white),icon: Icon(Icons.account_circle_rounded,color: Colors.white,),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),border: InputBorder.none)),
              SizedBox(height: 30,),
              TextField(style: TextStyle(color: background),controller: t2,decoration: InputDecoration(hintText: "Enter Your Password",hintStyle: TextStyle(color: Colors.white),icon: Icon(Icons.password,color:Colors.white,),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),border: InputBorder.none)),
              SizedBox(height: 30,),
              TextField(style: TextStyle(color: background),controller: t3,decoration: InputDecoration(hintText: "Confirm Your Password",hintStyle: TextStyle(color: Colors.white),icon: Icon(Icons.password,color:Colors.white,),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),border: InputBorder.none)),
              SizedBox(height: 30,),
              MaterialButton(onPressed: ()async{
                var enteredemail=t1.text;
                var userpass="";
                var user_id="";
                if((t2.text!=t3.text)||t2.text==""||t2.text.length<6){
                  //print("entered here");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a valid password of more than 6 chars"),backgroundColor: error,),);
                  t2.clear();
                  t3.clear();
                  return;
                }
                var body={
                  "email":enteredemail,
                  "userpass":t2.text,
                  "user_id":user_id
                };
                final url=Uri.parse("http://${url2}/users/signup");
                //print(url);
                var pay=jsonEncode(body);
                var response=await http.post(url,body: pay);
                print(response);
                if(response.statusCode==401){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Already exits"),backgroundColor: error,));
                  return;
                }
                else if(response.statusCode==201){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Created.Please Login."),backgroundColor:success,));
                  Navigator.popAndPushNamed(context, '/');

                }
                else{
                  print(response.statusCode);
                }
              },child: Text("Sign Up",style: TextStyle(color: Colors.teal),),color: Colors.white,minWidth: double.infinity,height: 50,hoverElevation: 2.5,hoverColor: Colors.amberAccent,focusColor: Colors.amberAccent,focusElevation: 2.5,),
              SizedBox(height: 5,),
              Center(
                child: MaterialButton(onPressed: (){
                  Navigator.popAndPushNamed(context, '/');
                },child: Text("Already Have an account? Login Now",style: TextStyle(color: Colors.white),),),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
