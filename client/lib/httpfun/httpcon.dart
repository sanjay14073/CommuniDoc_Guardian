import 'package:http/http.dart' as http;
import 'dart:convert';
class HttpFun{
  Future<void> Post1()async{
    var url=Uri.parse("http://localhost:3000/api");
    var response=await http.post(url);
    print(response.statusCode);
    print(response.body);
  }
}