import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';


late BuildContext currentContext;


class Progress{
  

  static show(context, {
    required String message,
      String? image,



  }) async{

    // factsC.updateFactCount();
    // pressController.changeValue(true);
    _showProgressDialogue(context,message,image,);
  }



  static bool hide() {
    try{
      Navigator.pop(currentContext);
      return true;
    }
    catch (e){
      return false;
    }
  }


}





_showProgressDialogue(context,message,image) async{
  return    showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext dialogContext) {
      currentContext= dialogContext;
      return WillPopScope(
        onWillPop: (){
          Progress.hide();
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              color: Colors.black54,
              child:     Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                                child: Lottie.asset(
                                    image??'assets/loadingAnimation.json',
                                height: 90)),
                          ),
                          Text(message?? 'Please add a text',
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumWCB),
                          // factsDialogue(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      );
    },
  );
}
