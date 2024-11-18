import 'package:dbms_vehiclemanagement/provideroptions/managerprovider.dart';
import 'package:flutter/material.dart';
import 'package:dbms_vehiclemanagement/Colors.dart';
import 'package:dbms_vehiclemanagement/httpfun/httpcon.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController s=TextEditingController();
  late String? uname="";
  @override
  void initState() {
    // TODO: implement initState
    shared();
    addprev();
  }
  void addprev()async{
    await Provider.of<Manager>(context,listen: false).getVehicles();
    await Provider.of<Manager>(context,listen: false).getVehicleRelated();
    await Provider.of<Manager>(context,listen: false).getAllVehicles();
    print(Provider.of<Manager>(context,listen: false).m1[Provider.of<Manager>(context,listen: false).u]!.length);
    //print(prev.length);
  }
  Future<void>shared()async{
    final share=await SharedPreferences.getInstance();
    print(share.getString("user"));
    uname=share.getString("user");

   // return share.getString("user");
  }
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
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle_rounded,color: Colors.white,size: 70,),
                  SizedBox(height: 10,),
                  Text(Provider.of<Manager>(context,listen: false).u.email!,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            ListTile(
              title: const Text('Update Profile'),
              //selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
               // _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Feature Comming Soon!",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
              },
            ),
            ListTile(
              title: const Text('Help & Feedback'),
              //selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
               // _onItemTapped(1);
                // Then close the drawer
                Navigator.popAndPushNamed(context, '/help');
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
             // selected: _selectedIndex == 2,
              onTap: () async{
                // Update the state of the app
              //  _onItemTapped(2);
                // Then close the drawer

                final shared=await SharedPreferences.getInstance();
                shared.setString("uid", "");
                shared.setString("user", "");
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Vehicle Manangement System",style: TextStyle(color:Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.teal,
        bottom:PreferredSize(child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(controller: s,decoration:InputDecoration(hintText:"Enter someting that you want to search",icon: Icon(Icons.search,color:accentColor),border: InputBorder.none,hintStyle:TextStyle(color:Colors.black26)),style:TextStyle(color: Colors.black26,),),
          ),decoration:BoxDecoration(color: background,borderRadius: BorderRadius.circular(10.0),)),
        ), preferredSize: Size.fromHeight(60)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: 290,
              child: GridView.count(

                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Card(
                      color: cardBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.add,
                              color: accentColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Register a new vehicle"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Card(
                      color: cardBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.notes,
                              color: accentColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Insurance Documents"),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context,'/insurance');
                    },
                  ),


                  GestureDetector(
                    child: Card(
                      color: cardBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.view_agenda,
                              color: accentColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Registration Documents"),
                          ],
                        ),
                      ),

                    ),
                    onTap: (){
                      Navigator.pushNamed(context,'/regdocs');
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      color: cardBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.dangerous_sharp,
                              color: accentColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Search For an violation"),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context,'/searchcomp');
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      color: cardBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.app_registration,
                              color: accentColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Register a new violation"),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context,'/addcomp');
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      color: cardBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.energy_savings_leaf,
                              color: accentColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Emission Details"),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      //await HttpFun().Post1();
                      Navigator.pushNamed(context,'/emission');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),

          Text("Here Are Some good articles",style: TextStyle(color:textSecondary,fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: 10,),
            // Container(
            //   height: 550,
            //   child: ListView.builder(itemBuilder: (BuildContext context,int index){
            //   return Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: ListTile(
            //       tileColor: Colors.teal[50],
            //       title: Text("Violation ${index+1}"),
            //     ),
            //   );
            //   },itemCount: 4,),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(color:Colors.grey[100],borderRadius: BorderRadius.circular(15.0)),
                child:Column(
                  children: [
                    Container(height: 190,width: double.infinity,child: Image.network("https://images.newindianexpress.com/uploads/user/imagelibrary/2022/8/29/w900X450/makeovedr.jpg?w=400&dpr=2.6"),
                      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(15.0)),
                    ),
                    Container(
                      width: double.infinity,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Act,Rules and Policies",style: TextStyle(fontWeight:FontWeight.bold,color: textSecondary,fontSize:18),),
                            ElevatedButton(onPressed: ()async{
                              await _launchInBrowser(Uri.parse("https://parivahan.gov.in/parivahan//en/content/act-rules-and-policies"));
                            }, child: Text("Read Now")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 260,
                decoration: BoxDecoration(color:Colors.grey[100],borderRadius: BorderRadius.circular(15.0)),
                child:Column(
                  children: [
                    Container(height: 190,width: double.infinity,child: Image.network("https://images.newindianexpress.com/uploads/user/ckeditor_images/article/2021/10/5/Underage_driving.jpg"),
                      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(15.0)),
                    ),
                    Container(
                      width: double.infinity,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("UnderAge Styling",style: TextStyle(fontWeight:FontWeight.bold,color: textSecondary,fontSize:18,fontStyle: FontStyle.italic),),
                            ElevatedButton(onPressed: ()async{
                              await _launchInBrowser(Uri.parse("https://newstrailindia.com/inner.php?id=15769"));
                            }, child: Text("Read Now")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 260,
                decoration: BoxDecoration(color: Colors.grey[50],borderRadius: BorderRadius.circular(15.0)),
                child:Column(
                  children: [
                    Container(height: 190,width: double.infinity,child: Image.network("https://images.newindianexpress.com/uploads/user/imagelibrary/2022/1/2/w1200X800/drunk_Driving.JPG"),
                      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(15.0)),
                    ),
                    Container(
                      width: double.infinity,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Drink and Die",style: TextStyle(fontWeight:FontWeight.bold,color: textSecondary,fontSize:18),),
                            ElevatedButton(onPressed: ()async{
                              await _launchInBrowser(Uri.parse("https://economictimes.indiatimes.com/topic/drunk-driving-accident"));
                            }, child: Text("Read Now")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 10,),
            Text("That's it for the Day!! ;)",style: TextStyle(fontWeight: FontWeight.bold,color:textSecondary,fontSize: 20),),
            SizedBox(height:40,),
          ],
          ),
      ),
      );

  }
}
