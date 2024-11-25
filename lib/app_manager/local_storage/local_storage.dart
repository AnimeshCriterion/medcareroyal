


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {


  void storeData({ required String key, required var data, }) async{

    // String encodeData=jsonEncode(
    //    data
    // );
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(key,encodeData);
  }

  Future<dynamic> fetchData({ required String key, }) async{
    final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(key)==null? null:jsonDecode(prefs.getString(key)??"{}");
    return {};

  }








}