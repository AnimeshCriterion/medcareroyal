import 'package:flutter/material.dart';

import '../LiveVital/pmd/app_color.dart';
import '../LiveVital/pmd/app_color.dart';
import '../LiveVital/pmd/app_color.dart';
import '../app_manager/app_color.dart';

class style {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        shadowColor: isDarkTheme ?Colors.grey.shade800:Colors.white ,
        // scaffoldBackgroundColor: isDarkTheme ? Colors.black87 : Colors.white,
        scaffoldBackgroundColor: isDarkTheme ?AppColor.darkshadowColor1 : AppColor.lightshadowColor2,
        highlightColor: isDarkTheme ?AppColor.darkshadowColor1 : AppColor.lightshadowColor1,
        // primaryTextTheme: TextTheme(
        //     headline1: TextStyle(
        //         color: isDarkTheme ? Colors.grey.shade400 : AppColor.greyDark)),
        // textTheme: TextTheme(
        //   bodyText1: isDarkTheme ? TextStyle(color: Colors.white) : TextStyle(color: Colors.black),
        // ),
        // primaryColor: isDarkTheme ? Colors.black : Colors.grey.shade200,
        primaryColor: isDarkTheme ?AppColor.darkshadowColor2: AppColor.lightshadowColor1,
        // backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white70,
        focusColor: isDarkTheme ?Colors.black87 :AppColor.lightshadowColor2,
        hintColor: isDarkTheme ? Colors.black87: Colors.white,
        hoverColor: isDarkTheme ?AppColor.darkshadowColor1 : AppColor.greyLight,
        // indicatorColor: isDarkTheme ?AppColor.lightshadowColor1 :AppColor.lightshadowColor2,
        // primaryColor: isDarkTheme ? Colors.black : Colors.grey.shade200,
        // backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
        // shadowColor:isDarkTheme ? Colors.grey.shade900: Colors.grey.shade400 ,
        // hintColor: isDarkTheme ? Colors.grey.shade400: Colors.grey.shade700,

         indicatorColor:  isDarkTheme ? Colors.grey.shade900 : Colors.white,
        // // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
        //
        // hintColor: isDarkTheme ? Colors.red : Colors.red,
        //
       // highlightColor: isDarkTheme ?  Colors.grey.shade100: Colors.grey.shade700,
        // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
        //
        // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
        // disabledColor: Colors.grey,
        // // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
        // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
        // canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
        // brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme:
                isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: isDarkTheme ? Colors.white : Colors.black));
  }
}
