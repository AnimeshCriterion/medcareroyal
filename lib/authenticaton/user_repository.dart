

import 'dart:convert';
import 'package:medvantage_patient/app_manager/constant/constant.dart';
import 'package:medvantage_patient/authenticaton/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../Modal/app_details_data_modal.dart';

class UserRepository  extends ChangeNotifier {


  User? currentUser;
  // AppDetailsDataModal? appDetails;
  UserRepository({this.currentUser,
    // this.appDetails
  });


  User get getUser=>currentUser??User();
  // AppDetailsDataModal get getAppDetails=>appDetails??AppDetailsDataModal();
  // bool get getGoneThrowFP=>goneThrowFP??false;

  Future updateUserData(User userData) async{
    print("Aniemshssssss${userData.toJson()}");
    String user=jsonEncode(userData.toJson());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constant.userStore,user);
    currentUser=await fetchUserData();
    var abc=await fetchUserData();
    print('nnnnnnnnnnnnnn${abc.patientName}');
    notifyListeners();
  }

  // appData(AppDetailsDataModal data) async {
  //   String user=jsonEncode(data.toJson());
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(Constant.appName,user);
  //   appDetails=await fetchAppData();
  //
  // }
  // static Future<AppDetailsDataModal>  fetchAppData() async {
  //
  //   final prefs = await SharedPreferences.getInstance();
  //   return AppDetailsDataModal.fromJson(jsonDecode(prefs.getString(Constant.appName)??"{}"));
  // }

    Future<User> fetchUserData() async{

    final prefs = await SharedPreferences.getInstance();
    currentUser = User.fromJson(jsonDecode(prefs.getString(Constant.userStore)??"{}"));
    print('nnnnnnnvnnn '+User.fromJson(jsonDecode(prefs.getString(Constant.userStore)??"{}")).patientName.toString());
    notifyListeners();
    return User.fromJson(jsonDecode(prefs.getString(Constant.userStore)??"{}"));
  }

  Future updateGoneThrowFP(bool val) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constant.userGoneThrowFPStore,val);
    // goneThrowFP=await fetchGoneThrowFP();
    notifyListeners();
  }


  static Future<bool> fetchGoneThrowFP() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constant.userGoneThrowFPStore)??false;
  }

  Future logOutUser(BuildContext context) async{
    // DashboardViewModel  dashboardVM=Provider.of<DashboardViewModel>(context,listen: false);
    // await updateGoneThrowFP(false);
    await updateUserData(User());
    // await dashboardVM.updateSelectedApp(CategoryData());
    notifyListeners();
  }


}
