
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_color.dart';

class AlertDialogue2 {

  show(context,alert,msg,
      {
        String? firstButtonName,
        Function? firstButtonPressEvent,
        String?  secondButtonName,
        Function? secondButtonPressEvent,
        bool? showCancelButton,
        bool? showOkButton,
        bool? disableDuration,
        bool? checkIcon,
        bool? hideIcon,
        bool? centerTitle,
        Widget? newWidget
      }
      )  {
    var canPressOk=true;
    return WidgetsBinding.instance.addPostFrameCallback((_){
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            return StatefulBuilder(
                builder: (context,setState)
                {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: WillPopScope(
                        onWillPop: (){
                           Get.back();
                          return Future.value(false);
                        },
                        child: SafeArea(
                          child: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColor.black,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(color: AppColor.grey)
                                ),
                                child: newWidget??Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(40,20,40,20),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColor.primaryColor,
                                                        borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(10),
                                                          topRight: Radius.circular(10),
                                                        )
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        children: [
                                                          Visibility(
                                                            visible: !(hideIcon?? false),
                                                            child: Icon(
                                                              checkIcon?? false? Icons.check:Icons.info_outline,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 5,),
                                                          Expanded(
                                                            child: Text(alert.toString(),
                                                              textAlign: (centerTitle?? false)?
                                                              TextAlign.center
                                                                  :TextAlign.start,
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 15
                                                              ),),
                                                          ),
                                                          const SizedBox(width: 5,),
                                                        ],
                                                      ),
                                                    )),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0,10,0,10),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(msg.toString(),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold
                                                          ),),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(8,0,8,0,),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Visibility(
                                                              visible: showCancelButton?? false,
                                                              child: TextButton(
                                                                style: TextButton.styleFrom(
                                                                  foregroundColor: Colors.black, padding: const EdgeInsets.all(8),
                                                                ),
                                                                onPressed: () {
                                                                  if(canPressOk)
                                                                  {
                                                                    canPressOk=false;
                                                                     Get.back();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(color: AppColor.primaryColor,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: secondButtonName!=null,
                                                              child: TextButton(
                                                                style: TextButton.styleFrom(
                                                                  foregroundColor: Colors.black, padding: const EdgeInsets.all(8),
                                                                ),
                                                                onPressed: () {
                                                                  if(canPressOk)
                                                                  {
                                                                    canPressOk=false;
                                                                    secondButtonPressEvent!();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  secondButtonName.toString(),
                                                                  style: TextStyle(color: AppColor.primaryColor,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: firstButtonName!=null,
                                                              child: TextButton(
                                                                style: TextButton.styleFrom(
                                                                  foregroundColor: Colors.black, padding: const EdgeInsets.all(8),
                                                                ),
                                                                onPressed: () {
                                                                  if(canPressOk)
                                                                  {
                                                                    canPressOk=false;
                                                                    firstButtonPressEvent!();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  firstButtonName.toString(),
                                                                  style: TextStyle(color: AppColor.primaryColor,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: showOkButton?? true,
                                                              child: TextButton(
                                                                style: TextButton.styleFrom(
                                                                  foregroundColor: Colors.black, padding: const EdgeInsets.all(8),
                                                                ),
                                                                onPressed: () {
                                                                  if(canPressOk)
                                                                  {
                                                                    canPressOk=false;
                                                                     Get.back();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Ok',
                                                                  style: TextStyle(color: AppColor.primaryColor,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return Container();
          }).then((val){
        canPressOk=false;
      });

    });
  }



}