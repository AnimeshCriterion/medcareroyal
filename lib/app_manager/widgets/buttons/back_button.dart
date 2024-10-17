



import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';


class PrimaryBackButton extends StatelessWidget {
  final Color? color;
  const PrimaryBackButton({Key? key,
  this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
       Get.back();
    }, icon:  Icon(Icons.keyboard_backspace_outlined,
    size: 30,
    color: color??AppColor.black,));
  }
}
