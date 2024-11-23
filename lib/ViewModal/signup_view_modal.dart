import 'package:medvantage_patient/View/Pages/dashboard_view.dart';
import 'package:medvantage_patient/View/Pages/siginup_verify_view.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/local_storage/local_storage.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/progress_dialogue.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:medvantage_patient/services/firebase_service/fireBaseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Localization/app_localization.dart';
import '../View/Pages/master_dashboard_view.dart';
import '../View/Pages/rmd_view.dart';
import '../View/Pages/signup_view.dart';
import '../View/widget/common_method/show_progress_dialog.dart';
import '../app_manager/bottomSheet/bottom_sheet.dart';
import '../app_manager/bottomSheet/functional_sheet.dart';
import '../authenticaton/user.dart';
import '../authenticaton/user_repository.dart';

class SignUpViewModal extends ChangeNotifier{

  final formKey=GlobalKey<FormState>();
  Api _api=Api();
  List countryCode=[
    {
      'code':'+91'},
    { 'code':'+92'},
    { 'code':'+93'}
  ];

  LocalStorage localStorage=LocalStorage();

  TextEditingController emailC= TextEditingController();
  TextEditingController nameC=TextEditingController();
  TextEditingController mobileNoC=TextEditingController();
  TextEditingController dobC=TextEditingController();
  TextEditingController addressC=TextEditingController();
  TextEditingController genderC=TextEditingController();

  TextEditingController passwordC=TextEditingController();


  TextEditingController otpC=TextEditingController();

  clearData(){
    emailC.clear();
    nameC.clear();
    mobileNoC.clear();
    passwordC.clear();

    notifyListeners();
  }

  Map otpResponse={};

  bool  isMobileField=false;
  bool get getMobileNo => isMobileField;
  set updateMobileNo( bool value){
    isMobileField=value;
    notifyListeners();
  }
  ////////resendotp\\\\\\\\\
  bool isResendOtp=false;
  bool get getResendOtp=>isResendOtp;
  set updateResendOtp(bool value){
    isResendOtp=value;
  }   // await addvitalVM.onPressedData(context);
  // addvitalVM.clearData();

  onPressedVerifyAndOTP(context) async {

    if(mobileNoC.text.isEmpty){
      Alert.show("Please Enter Number");
    }
    else if(mobileNoC.text.length<10){
      Alert.show("Please enter valid number");
    }

else {
      if (!getMobileNo) {
        await generateOTPForPatient(context);
        otpC.clear();
        updateMobileNo = true;
        dPrint('nnnnnnnnnnnnnnn' + getMobileNo.toString());
      } else {
        await checkLogin(context);
      }
    }
  }


  checkLogin(context) async {
    ProgressDialogue().show(context, loadingText:'Loading');
    var data = await _api.call(context,
        url: AllApi.checkLogin,
        apiCallType: ApiCallType.rawPost(
            body: {
              "mobileNo": mobileNoC.text,
              "serviceProviderTypeId": "6",
              "deviceToken": (await FireBaseService().getToken()).toString(),
              "deviceType": "4",
              "appType": "DD",
              "otp": otpC.text.toString()
            }));
    ProgressDialogue().hide();
    if(data['responseCode']==1){
      data['responseValue'][0].addAll({'token':data['token']});


      if(data['responseValue'][0]['isExists']==1){
        Alert.show('Number Already Registered');
      }
      else{
        MyNavigator.push(context, SignUpView());
      }
    }
    else{
      Alert.show(data['responseMessage']);

    }
  }

  generateOTPForPatient(context) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    Progress.show(context, message: localization.getLocaleData.Loading.toString(),);
    var data = await _api.call(context,
        url: AllApi.generateOTPForPatient,
        localStorage: true,
        apiCallType: ApiCallType.rawPost(
            body: {
              "mobileNo": mobileNoC.text
            }));
    Progress.hide();

    if (data['responseCode'] == 1) {
      otpResponse=data['responseValue'].isEmpty? {}:data['responseValue'][0] ;
      // MyNavigator.push(context, SignUpVerifyView());
      // notifyListeners();
    }

  }

  onPressedSignUp(context) async {


    if(formKey.currentState!.validate()) {
      await CustomBottomSheet.open(context,
          child: FunctionalSheet(
              message: 'Are you sure you want to submit?',
              buttonName: 'Submit',
              onPressButton: () async {
                await getPatientRegistration(context);
              }

          ));
    }
  }



  getPatientRegistration(context)async{
    Progress.show(context, message: '',image: 'assets/thankyou_signup.json');

    try{
      var data =await _api.call(context,
          url: AllApi.getPatientRegistration,
          apiCallType: ApiCallType.rawPost(body: {
            'name':nameC.text,
            'callingCodeId': '91'.toString(),
            'mobileNo':mobileNoC.text,
            'dob':'',

            // DateFormat('yyyy-mm-dd')
            //     .format(DateFormat("yyyy-mm-dd")
            //     .parse(dobC.text.toString(),))
            //     .toString(),
            'address':'' ,
            'emailId':emailC.text,
            'gender':'1',
            'deviceType': '3'.toString(),
            'appType': 'DD'.toString(),
            'otp': otpC.text.toString(),
            'profilePhotoPath': "",
            'password': passwordC.text.toString(),
            'deviceToken': (await FireBaseService().getToken()).toString(),
            "isFromDevice":2,
            "height":"",
            "weight":"",
            "isPrivate":""

          }));

      if (data['responseCode'] == 1) {
       MyNavigator.push(context, RMDView());
        // notifyListeners();
      }

    }
    catch(e){

      dPrint(e);
    }
  }


}
