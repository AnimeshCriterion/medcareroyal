import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../alert_toast.dart';
class GetApiService{

  static getApiCall({required String endUrl,String? newBaseUrl}) async {
    String baseUrl="http://aws.edumation.in:5001/sthethoapi/";
    if(newBaseUrl!=null){
      baseUrl = newBaseUrl??"";
    }
    try {
      var url = Uri.parse(baseUrl+endUrl);
      print(url);
      var response = await http.get(url);
      print("############${response.body}");
      return jsonDecode(response.body);
    }
    on SocketException{
      //print("abe internet to On kr pehle");
      Alert.show("please check your internet connection");
      // CommonWidgets.showBottomAlert(message: "please check your internet connection");
    }
    on TimeoutException catch (e){
      print(e);
      //print("time out");
      Alert.show("Time out");
      // CommonWidgets.showBottomAlert(message: "Time out");
    }
    on HttpException{
      print("no service found");
      Alert.show("No service found");
      // CommonWidgets.showBottomAlert(message: "No service found");
    }
    on FormatException{
      Alert.show("Invalid data format");
      print("invalid data format");
      // CommonWidgets.showBottomAlert(message: "invalid data format");
    }
    catch (e) {
      //log("eeeeeeeeeeeeeeeeeeeeeeeee"+e.toString());
      Alert.show(e.toString());
      // CommonWidgets.showBottomAlert(message: e.toString());
    }
  }

}