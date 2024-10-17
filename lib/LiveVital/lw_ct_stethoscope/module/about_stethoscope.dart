
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_manager/alert_dialogue.dart';
import '../../../app_manager/alert_toast.dart';
import '../../../app_manager/app_color.dart';
import '../../../app_manager/theme/text_theme.dart';

class AboutStethoScopeView extends StatefulWidget {
  const AboutStethoScopeView({super.key});

  @override
  State<AboutStethoScopeView> createState() => _AboutStethoScopeViewState();
}

class _AboutStethoScopeViewState extends State<AboutStethoScopeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue.shade100,
          appBar: AppBar(
            title: Text('Stethoscope'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('About Stethoscope',style: MyTextTheme.mediumBCB.copyWith(color: AppColor.primaryColor),),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Expanded(child: Image.asset('assets/stethoImg/stethoImg.png',fit: BoxFit.fill,)),

                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){

                          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Coming Soon'));
                          // alertToast(context, 'Coming Soon');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('How to connect?',style: MyTextTheme.mediumBCN.copyWith(color: AppColor.primaryColor,decoration: TextDecoration.underline,),),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
