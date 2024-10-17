import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../services/tab_responsive.dart';
import '../app_color.dart';
import '../theme/text_theme.dart';

class AlertDialogue {


  show(context,
      {
        String? msg,
        String? firstButtonName,
        Function? firstButtonPressEvent,
        String?  secondButtonName,
        String?  cancelButtonName,
        Function? secondButtonPressEvent,
        bool? showCancelButton,
        bool? showOkButton,
        bool? disableDuration,
        bool? checkIcon,
        List<Widget>? newWidget,
        String? title,
        String? subTitle,
      }
      ){
    var canPressOk=true;
    return WidgetsBinding.instance.addPostFrameCallback((_){

      showCupertinoModalBottomSheet(
        shadow: BoxShadow(blurRadius: 0, color: newWidget==null? Colors.transparent:Colors.black12, spreadRadius: 0),
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body:     TabResponsive().wrapInTab(
            context: context,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: newWidget!=null? ListView(
                shrinkWrap: true,
                //  physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Container(
                      width: 200,
                      height: 5,
                      margin: const EdgeInsets.fromLTRB(0,10,0,10),
                      decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                  Container(
                    decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                        ),
                        border: Border.all(color: AppColor.grey)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(TabResponsive().isTab(context)? 20:10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: title!=null,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title.toString(),
                                        style: MyTextTheme.largeBCB,),
                                      Visibility(
                                          visible: subTitle!=null,
                                          child: Text(subTitle.toString(),
                                            style: MyTextTheme.mediumGCB,)
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  if(canPressOk)
                                  {
                                    canPressOk=false;
                                     Get.back();
                                  }
                                }, icon: const Icon(Icons.clear,
                                  color: Colors.black,))
                              ],
                            ),
                          ),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: newWidget,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ):ListView(
                shrinkWrap: true,
                children: [
                  Container(
                      decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                          ),
                          border: Border.all(color: AppColor.grey)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,10,0,0),
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(20,20,20,20),
                                    child: Text(msg.toString(),
                                        textAlign: TextAlign.center,
                                        style: MyTextTheme.mediumGCB)
                                ),
                                Visibility(
                                  visible: showCancelButton?? false,
                                  child:   Padding(
                                    padding: const EdgeInsets.fromLTRB(20,8,20,8),
                                    child: PrimaryButton(
                                      color: AppColor.grey,
                                      title: cancelButtonName??'Cancel',
                                      onPressed: (){
                                        if(canPressOk)
                                        {
                                          canPressOk=false;
                                           Get.back();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: showOkButton?? false,
                                  child:   Padding(
                                    padding: const EdgeInsets.fromLTRB(20,8,20,8),
                                    child: PrimaryButton(
                                      color: AppColor.primaryColor,
                                      title: 'Ok',
                                      onPressed: (){
                                        if(canPressOk)
                                        {
                                          canPressOk=false;
                                           Get.back();
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: firstButtonName!=null,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20,8,20,8),
                                    child: PrimaryButton(
                                      color: AppColor.primaryColor,
                                      title: firstButtonName.toString(),
                                      onPressed: (){
                                        if(canPressOk)
                                        {
                                          canPressOk=false;
                                          firstButtonPressEvent!();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: secondButtonName!=null,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20,8,20,8),
                                    child: PrimaryButton(
                                      color: AppColor.primaryColor,
                                      title: secondButtonName.toString(),
                                      onPressed: (){
                                        if(canPressOk)
                                        {
                                          canPressOk=false;
                                          secondButtonPressEvent!();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8,),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      );

    });


  }

  void actionBottomSheet(
      {String? title,
      required String subTitle,
      required Function okPressEvent,
      String? cancelButtonName,
      String? okButtonName}) {
    Get.bottomSheet(
        isDismissible: true,
        elevation: 20.0,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        )),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
//Divider(thickness: 4,indent: 150,endIndent: 150,height:25 ),
              if (title != null)
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(
                height: 18,
              ),
              Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      letterSpacing: 1, fontSize: 16, color: Colors.black),
                  subTitle),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(160, 42),
                        elevation: 0,
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                        backgroundColor: Colors.grey.shade100,
//padding:EdgeInsets.symmetric(horizontal: 50,vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: Text(
                        cancelButtonName ?? "Cancel",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        okPressEvent();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(160, 42),
                        elevation: 0,
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
//padding:EdgeInsets.symmetric(horizontal: 50,vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: Text(okButtonName ?? "Ok"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }


}
