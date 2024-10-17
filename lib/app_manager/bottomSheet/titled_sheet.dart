



import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';

import 'package:get/get.dart';


class TitledSheet extends StatelessWidget {

  final String title;
  final String? subTitle;
  final Widget child;

  const TitledSheet({Key? key,
  required this.title,
  this.subTitle,
  required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20,10,20,0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title.toString(),
                  style: MyTextTheme.largeBCB,),
                  subTitle==null? Container():Text(subTitle.toString(),
                    style: MyTextTheme.smallBCB,),
                ],
              )),
              IconButton(onPressed: (){
                 Get.back();
              }, icon: Icon(Icons.clear,
              color: AppColor.black,))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20,10,20,20),
          child: child,
        )
      ],
    );
  }
}
