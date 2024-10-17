import 'package:medvantage_patient/View/Pages/otp_view.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/progress_dialogue.dart';
import 'package:flutter/cupertino.dart';

import '../Localization/app_localization.dart';
import '../common_libs.dart';

class OtpViewModal extends ChangeNotifier{
  final Api _api = Api();

  String userMobileNo='';
  String get getUserMobileNo => userMobileNo;
  set updateUserMobileNo(String val) {
    userMobileNo= val ;
    notifyListeners();
  }



  bool isTimer=false;
  bool get getIsTimer=>isTimer;
  set updateIsTimer(bool val){
    isTimer=val;
    notifyListeners();
  }


  getGenerateOTPForPatient(context, ) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    Progress.show(context, message: localization.getLocaleData.Loading.toString());
    var data = await _api.call(context,
        url: AllApi.generateOTPForPatient,
        localStorage: true,
        apiCallType: ApiCallType.rawPost(
            body: {
              "mobileNo":getUserMobileNo.toString()
            }));
    Progress.hide();
    if (data['responseCode'] == 1) {
      // otpResponse=data['responseValue'].isEmpty? {}:data['responseValue'][0] ;

      MyNavigator.pushReplacement(context, const LoginWithOtp());

    }
  }
}