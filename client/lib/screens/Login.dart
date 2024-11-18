import 'dart:convert';
import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:flutter/material.dart';
import 'package:dbms_vehiclemanagement/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  final url1="192.168.1.40:3300";
  final url2="10.0.2.2:3300";
  @override
  void initState(){
    // TODO: implement initState
    isal();
  }
  Future<void>isal()async{
    final SharedPreferences s=await SharedPreferences.getInstance();
    if(s.getString("uid")!=""){
      print(s.getString("uid"));
      Provider.of<Manager>(context,listen: false).currUser(s.getString("user")!,s.getString("uid")!);
      Navigator.popAndPushNamed(context, '/dashboard');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80,),
              Text("Welcome Back",style: TextStyle(fontSize: 70,fontWeight: FontWeight.bold,color: Colors.white),),
              SizedBox(height: 30,),
              TextField(style: TextStyle(color: background),controller: t1,decoration: InputDecoration(hintText: "Enter User name",hintStyle: TextStyle(color: Colors.white),icon: Icon(Icons.account_circle_rounded,color: Colors.white,),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),border: InputBorder.none)),
              SizedBox(height: 30,),
              TextField(style: TextStyle(color: background),controller: t2,decoration: InputDecoration(hintText: "Enter Your Password",hintStyle: TextStyle(color: Colors.white),icon: Icon(Icons.password,color:Colors.white,),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),border: InputBorder.none)),
              SizedBox(height: 30,),
              MaterialButton(onPressed: ()async{
                final prefs=await SharedPreferences.getInstance();
                final uri=Uri.parse("http://${url2}/users/signin");
                var ins={
                  "email":t1.text,
                  "userpass":t2.text,
                };
                var pay=jsonEncode(ins);
                final http.Response response=await http.post(uri,body:pay);
                //print(response);
                var data=response.body;
                Map<String, dynamic> jsonMap = json.decode(data);

                if(response.statusCode==201) {
                  prefs.setString("user", t1.text);
                  prefs.setString("uid", jsonMap['uid']);
                  Provider.of<Manager>(context,listen: false).currUser(prefs.getString("user")!,prefs.getString("uid")!);
                  Navigator.popAndPushNamed(context, '/dashboard');
                }
                else{
                  if(response.statusCode==403) {
                    prefs.setString("", t1.text);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Wrong Crendentials"),
                      backgroundColor: error,));
                  }
                  else if(response.statusCode==401){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please sign Up"),
                      backgroundColor: error,));
                  }
                }
              },child: Text("Sign In",style: TextStyle(color: Colors.teal),),color: Colors.white,minWidth: double.infinity,height: 50,hoverElevation: 2.5,hoverColor: Colors.amberAccent,focusColor: Colors.amberAccent,focusElevation: 2.5,),
              SizedBox(height: 5,),
              Center(
                child: MaterialButton(onPressed: (){
                  Navigator.popAndPushNamed(context, '/signup');
                },child: Text("Don't Have an account? SignUp Now",style: TextStyle(color: Colors.white),),),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
