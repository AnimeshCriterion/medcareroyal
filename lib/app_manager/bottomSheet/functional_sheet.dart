


import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/theme/theme.dart';

import '../neomorphic/theme_provider.dart';
import 'package:get/get.dart';



class FunctionalSheet extends StatelessWidget {

  final String message;
  final String buttonName;
  final Function onPressButton;
  final bool showCancelButton;
  final TextAlign? textAlign;
  final String?  cancelBtn;

  const FunctionalSheet({Key? key,
    required this.message,
    required this.buttonName,
    required this.onPressButton,
    this.showCancelButton=true,
    this.textAlign, this.cancelBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.white,
              ]
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20,40,20,20),
            child: Text(message.toString(),
              textAlign: textAlign??TextAlign.center,
              style: MyTextTheme.mediumBCB.copyWith(color: themeChange.darkTheme==true?Colors.white:Colors.black),),
          ),
          Divider(color: Colors.grey.shade300,indent: 20,endIndent: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,20,20,20),
            child: Row(
              children: [
                showCancelButton? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,20,0),
                    child: PrimaryButton(
                      borderColor: Colors.transparent,
                      elevation:0.0,
                        color: themeChange.darkTheme==true?Colors.grey.shade700:
                        Colors.grey.shade400,
                        onPressed: (){
                           Get.back();
                        },
                        title: cancelBtn?? localization.getLocaleData.cancel.toString()),
                  ),
                ):const SizedBox(),
                Expanded(
                  child: PrimaryButton(
                    color: AppColor.neoGreen,
                      onPressed: (){
                     Get.back();
                    onPressButton();
                  },
                      title: buttonName.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
