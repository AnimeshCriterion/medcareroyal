

import 'package:medvantage_patient/app_manager/shadow_container.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class CustomBottomSheet {


  static dynamic open(context,{
    Widget? child,bool? isZeroPadding
  }) async{
    var data= await showBarModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Scrollbar(
        trackVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: (isZeroPadding??false)  ?EdgeInsets.all(0.0): EdgeInsets.all(20.0),
              child: child??ShadowContainer(
                color: AppColor.primaryColorLight,
              ),
            ),
          ),
        ),
      ),
    );
    return data;
  }
}