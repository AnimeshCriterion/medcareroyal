




import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/extentions/hex_color_extention.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;
  ThemeProvider({this.isLightTheme=true});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;
  ThemeData get getDarkTheme => darkTheme;

  bool get getSystemIsLight=>SchedulerBinding.instance.window.platformBrightness == Brightness.light;

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    _storeTheme(isLightTheme);
    notifyListeners();
  }

  void _storeTheme(bool value) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightTheme', value);
  }

  Future<bool> retrieveStoredTheme() async{
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLightTheme')??true;
        //getSystemIsLight;
  }




}


final lightTheme = ThemeData(
  fontFamily: "Roboto",
  primarySwatch: AppColor.primarySwatchColorLight,
  primaryColor: AppColor.primaryColorLight,
  secondaryHeaderColor: AppColor.secondaryColorLight,
  brightness: Brightness.light,
  // backgroundColor: AppColor.bgColor,
  textTheme:  TextTheme(
    labelMedium: MyTextTheme.mediumPCB,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.bgColor,
    elevation: 0,
    centerTitle: true,
    iconTheme:  IconThemeData(
      color: AppColor.black,

    ),
    titleTextStyle: MyTextTheme.largeWCN
  ),

  dividerColor: Colors.white54,
    scaffoldBackgroundColor: AppColor.white,
);

final darkTheme = ThemeData(
  fontFamily: "Roboto",
  primarySwatch: Colors.grey,
  primaryColor: ("#8b24e7").toColor(),
  secondaryHeaderColor: ("#f76e37").toColor(),
  brightness: Brightness.dark,
  // backgroundColor: ("#eff3f4").toColor(),
  // textTheme: const TextTheme(
  //   headline1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
  //   headline6: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
  //   bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Hind'),
  // ),
  dividerColor: ("#eff3f4").toColor(),
);
