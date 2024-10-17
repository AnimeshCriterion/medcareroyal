



import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';

class Constant {

  static const String appName = "CT bot";

  static const String errorText='Field must not be empty';
  static const String notFilled='Some required fields are not filled';


  static const String userStore = "medCareuser";
  static const String userGoneThrowFPStore = "userFirstPage";
  static const String userDetails = "appDetails";

  static LinearGradient getGradient(gradientColor){
    return  LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        gradientColor!.withOpacity(0.7),
        gradientColor!.withOpacity(0.8),
        gradientColor!,
        gradientColor!,

      ],
    );
  }
  static Widget imageErrorWidget= Padding(padding: const EdgeInsets.all(5),
  child: Icon(Icons.photo_library,
  color: AppColor.grey,),
  );
  static Widget imageErrorIconWidget=   Icon(Icons.error,
  color: AppColor.white,);
  static Widget placeHolder= const Center(child: CircularProgressIndicator());
  static const double globalRadius= 10.0;
  static const int botId= 0;
  static const int botMessageId= 0;
  static const int receiverId= 2;


}