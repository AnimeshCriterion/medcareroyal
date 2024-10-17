



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import 'app_color.dart';

class Alert {

  static void show(message,){
    Fluttertoast.showToast(backgroundColor: AppColor.green,
     // backgroundColor: AppColor.gr,
      msg: message,
    );
  }
}

String toCamelCase(String input) {
  if (input.isEmpty) return input;

  // Split the string by spaces or underscores, and remove any empty strings
  var data=  input.split('')[0].toString().toUpperCase()+ input.substring(1);

  return data;
}
class  MySnackbar{
  static GetSnackBar SuccessSnackBar({String title = 'Alert', required String message}) {
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge?.merge(const TextStyle(color: Colors.white))),
      messageText: Text(toCamelCase(message.toString()), style: Get.textTheme.bodySmall?.merge(const TextStyle(color:  Colors.white))),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.green,
      icon: Icon(Icons.check_circle_outline, size: 32, color: AppColor.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 5),
    );
  }

  // ignore: non_constant_identifier_names
  static GetSnackBar ErrorSnackBar({String title = 'Warning', required String message}) {
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge?.merge(const TextStyle(color: Colors.white))),
      messageText: Text(toCamelCase(message.toString()), style: Get.textTheme.bodyMedium?.merge(const TextStyle(color:  Colors.white))),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error, size: 40, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 10,
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 2),
    );
  }
}