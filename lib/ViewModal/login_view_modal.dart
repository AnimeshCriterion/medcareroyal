
import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/Pages/login_view.dart';
import 'package:medvantage_patient/View/Pages/otp_view.dart';
import 'package:medvantage_patient/View/Pages/startup_view.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/ViewModal/dashboard_view_modal.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/local_storage/local_storage.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/neomorphic/theme_provider.dart';
import 'package:medvantage_patient/app_manager/progress_dialogue.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/services/firebase_service/fireBaseService.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import '../Localization/app_localization.dart';
import '../View/Pages/dashboard_view.dart';
import '../View/Pages/master_dashboard_view.dart';
import '../View/Pages/rmd_view.dart';
import '../all_api.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/navigator.dart';
import '../app_manager/widgets/buttons/primary_button.dart';
import '../authenticaton/user.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';
import '../encyption.dart';

class LoginViewModal extends ChangeNotifier {
  final Api _api = Api();
  LocalStorage localStorage = LocalStorage();
  TextEditingController mobileNoC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController otpC = TextEditingController();

  List countryCode = [
    {'code': '+91'},
    {'code': '+92'},
    {'code': '+93'}
  ];

  Map otpResponse = {};

  // GlobalKey formKey = GlobalKey<FormState>().obs;

  bool loginWithOtp = true;

  bool get getLoginWithOtp => loginWithOtp;

  set updateLoginWithOtp(bool value) {
    loginWithOtp = value;
    dPrint('LoginWithOtp :$getLoginWithOtp');
    notifyListeners();
  }

  // clearVariable

  clearData() {
    updateIsResend = false;
    mobileNoC.clear();
    passwordC.clear();
    otpC.clear();
  }

  onPressedContinue(context) async {
    dPrint("nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnvnnnn $logindetail");
    var uhid = logindetail.isNotEmpty ? logindetail[0]['uhId'] : '';

    var token = await FireBaseService().getToken();

    if (otpC.text.isNotEmpty) {
      UserRepository userRepository =
          Provider.of<UserRepository>(context, listen: false);

      var data = await _api.callMedvanatagePatient7082(context,
          // newBaseUrl: 'https://apishfc.medvantage.tech:7082/',
          url:
              "api/LogInForSHFCApp/VerifyLogInOTPForSHFCApp?UHID=${uhid}&otp=${otpC.value.text.toString()}&deviceToken=${token}&ifLoggedOutFromAllDevices=0",
          // "api/Users/VerifyOtp?userName=${userMobile.toString()}&otp=${otpC.value.text.toString()}",
          apiCallType: ApiCallType.get(),
        loginHeader:  {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer '+ logindetail[0]['token'].toString()
        },);
      dPrint('${logindetail[0]}');

      if (data['status'] == 1) {

        // logindetail[0].addAll({'token':token});
        // Alert.show("Otp Verified");

        await userRepository
            .updateUserData(User.fromJson(logindetail[0]))
            .then((value) async {
        //       DashboardViewModal dashboardVM =
        // Provider.of<DashboardViewModal>(context, listen: false);
        // await dashboardVM.appDetails(context) ;
          dPrint("Aniemsh $value");
          Get.offAll(RMDView());
          // MyNavigator.pushAndRemoveUntil(context, const RMDView());
        });

      } else {
        Alert.show("Incorrect Otp");
      }
    } else {
      Alert.show('Please Enter Otp');
    }
  }

  onPressedLogin(context) async {

    if (mobileNoC.text=="") {
      Alert.show("Please enter UHID");
    } else {
      loginWithUHID(context);
    }
  }

  bool isResend = false;

  get getIsResend => isResend;

  set updateIsResend(bool val) {
    isResend = val;
    notifyListeners();
  }

  generateOTPForPatient(context, {ifLoggedOutFromAllDevices = 0}) async {

    dPrint('nnnnnnnnnnnnnnnnnnnnnnvnnnvnnnn $logindetail');
    var uhid = logindetail.isNotEmpty ? logindetail[0]['uhId'].toString() : '';
    var pmid= logindetail[0]['pmId'];
    final box = GetStorage();
    box.write('pmid',pmid);
    dPrint(box.read('pmid').toString()+'sdxfcgvhbjnkml');
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var incr=await EncryptDecrypt.encryptString('UHID=${uhid.toString()}&ifLoggedOutFromAllDevices=${ifLoggedOutFromAllDevices}',EncryptDecrypt.key);
    var data = await _api.callMedvanatagePatient7082(context,
        // newBaseUrl: 'https://apishfc.medvantage.tech:7082/',
        url:
            "api/LogInForSHFCApp/SentLogInOTPForSHFCApp?UHID=${uhid.toString()}&ifLoggedOutFromAllDevices=${ifLoggedOutFromAllDevices}" ,
        // "api/Users/SendOtp?userName=${userMobile.toString()}&isPatient=true",
       loginHeader:  {
         'Content-Type': 'application/json',
         'Authorization': 'Bearer '+ logindetail[0]['token'].toString()
       },
          apiCallType: ApiCallType.get( ));
     Get.back();
    dPrint('nnnnvv ${data['status']}');
    if (data['status'] == 1) {
      Alert.show(data['message']);
      WidgetsBinding.instance
        .addPostFrameCallback((_) async {
        Get.to(()=>LoginWithOtp());
       // MyNavigator.push(context, const LoginWithOtp());

    });


      // await userRepository.updateUserData(User.fromJson(data['responseValue'][0])).then((value) async {
      //   dPring("Aniemsh"+value.toString());
      //   MyNavigator.push(context, const LoginWithOtp());
      // });
      dPrint("Aniemsh${userRepository.getUser.mobileNo}");
    } else if (data['responseValue'] == 'Already LoggedIn On 2 Devices') {
      vitalDialog(context);
    } else {
      Alert.show(data['message']);
    }
  }

  vitalDialog(context) {

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
        return AlertDialog(
            title:  Text(localization.getLocaleData.alreadyLoggedIn.toString(),style:themeChange.darkTheme==true? MyTextTheme.largeWCN:MyTextTheme.largeGCB),
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor:  themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
            content: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SizedBox(
                height: 135,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 215,
                      child: NeoButton(

                          func: () async {
                            await generateOTPForPatient(context,  ifLoggedOutFromAllDevices: 1);
                          },
                          title: localization.getLocaleData.logoutAllDevices.toString(),
                      textStyle: themeChange.darkTheme? MyTextTheme.mediumBCB:MyTextTheme.mediumWCB),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 215,
                      child: NeoButton(
                          func: () async {
                             Get.back();
                          },
                          textStyle:  themeChange.darkTheme? MyTextTheme.mediumBCB:MyTextTheme.mediumWCB,
                          title: localization.getLocaleData.cancel.toString()),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  checkLogin(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ProgressDialogue().show(context, loadingText: 'Loading');
    var data = await _api.call(context,
        url: AllApi.checkLogin,
        apiCallType: ApiCallType.rawPost(
            body: getLoginWithOtp
                ? {
                    "mobileNo": mobileNoC.text,
                    "serviceProviderTypeId": "6",
                    "deviceToken":
                        (await FireBaseService().getToken()).toString(),
                    "deviceType": "4",
                    "appType": "DD",
                    "otp": otpC.text.toString()
                  }
                : {
                    "mobileNo": mobileNoC.text,
                    "password": passwordC.text,
                    // "accessToken": "string",
                    "serviceProviderTypeId": "6",
                    "deviceToken":
                        (await FireBaseService().getToken()).toString(),
                    "deviceType": "4",
                    "appType": "DD",
                    // "uniqueNos": "string",
                    //"otp": otpC.text
                  }));
    ProgressDialogue().hide();
    if (data['responseCode'] == 1) {
      data['responseValue'][0].addAll({'token': data['token']});

      if (data['responseValue'][0]['isExists'] == 1) {}

      await userRepository
          .updateUserData(User.fromJson(data['responseValue'][0]))
          .then((value) async {
        Get.offAll(RMDView());
        // MyNavigator.pushAndRemoveUntil(context, const RMDView());
      });

      notifyListeners();
    } else {
      Alert.show(data['responseMessage'].toString());
    }
  }

  List logindetail = [];

  set updateLoginDetails(List val) {
    logindetail = val;
    notifyListeners();
  }

  loginWithUHID(context) async {
    updateLoginDetails = [];
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var incr=await EncryptDecrypt.encryptString('userName=${mobileNoC.value.text.toString()}',EncryptDecrypt.key);
    // var incr= encryption('userName=${mobileNoC.value.text.toString()}');

    var data = await _api.callMedvanatagePatient7084(context,
        // var data = await _api.callMedvanatagePatient7082(context,
        // newBaseUrl: 'https://apishfc.medvantage.tech:7082/',
        url:
            // "api/PatientPersonalDashboard/GetPatientDetailsByUHID?UHID=${mobileNoC.value.text.toString()}",
        "api/Users/PatientLoginByKey?userName=${mobileNoC.value.text.toString()}",
        // "api/Users/PatientLoginByKey?"+incr.toString() ,
        apiCallType: ApiCallType.post(body: {
          // "userName":incr.toString()
        },  ),
        loginHeader: {});
    log("nnnnnnnnnnnn ${data }");
     Get.back();

    if (data['status'] == 1) {
      // Alert.show(data['message']);
      // dPrint("nnnnnnnnnnnn ${data['responseValue']}");
      if(Map.from(data).keys.toList().contains('token')){
        data['responseValue'][0]['token']=data['token'];
        updateLoginDetails = data['responseValue'];
        dPrint("nnnnnnnnnnnnnnvnn ${ data['responseValue'][0]['token'] }");
      }


      int isNotificationRequired=0;

      final prefs = await SharedPreferences.getInstance();
      if(data['responseValue'].isNotEmpty){
        isNotificationRequired=   int.parse((data['responseValue'][0]['isNotificationRequired']??0).toString());
        prefs.setInt('isNotificationRequired', isNotificationRequired);
      }

      generateOTPForPatient(context);
      dPrint("Aniemsh${userRepository.getUser.mobileNo}");

      await prefs.setString('isActive', (data['responseValue'][0]['isActive']??'0').toString());
      // var value=(data['responseValue'][0]['isActive'].toString());
      // dPring(value+ ' ertyuio');
      // final box = GetStorage();
      // box.write('isActive', value);
      // dPring(box.read('isActive').toString()+'asdfghjkrtyuiofghj');


    } else {
      Alert.show("Please enter valid UHID");
    }
  }

  saveDeviceToken(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);

    var token = await FireBaseService().getToken();
    try {
      var data = await _api.callMedvanatagePatient7084(context,
          url:
              "api/Users/SaveDeviceToken?userId=${userRepository.getUser.uhID.toString()}&deviceToken=${token.toString()}&isPatient=true",
          apiCallType: ApiCallType.get());

      dPrint('nnnnnnnnnnnnn$data');
      if (data['status'] == 1) {

      } else {
        Alert.show(data['message']);
      }
    } catch (e) {
      dPrint('nnnn$e');
    }
  }

  logOut(context) async {

     UserRepository userRepository =
            Provider.of<UserRepository>(context, listen: false);
    var uhid = userRepository.getUser.uhID.toString();
     ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var token =await FireBaseService().getToken();

    var data = await _api.callMedvanatagePatient7082(context,
        url:
            "api/LogInForSHFCApp/LogOutOTPForSHFCApp?UHID=${userRepository.getUser.uhID.toString()}&deviceToken=${token}",
        // "api/Users/VerifyOtp?userName=${userMobile.toString()}&otp=${otpC.value.text.toString()}",
        apiCallType: ApiCallType.get());
     ProgressDialogue().hide();
    dPrint(data.toString());
    // if (data['status'] == 1) {
      await userRepository.updateUserData(User());
      Get.offAll(() => LoginView());
      // MyNavigator.pushAndRemoveUntil(context, const LoginView());

    // } else {}
  }


  final serverUrl = "http://172.16.61.31:7101/Notification";

  connectServer() async {
    final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    dPrint(hubConnection.state.toString());
    await hubConnection.start();
    dPrint('nnnnnnn${hubConnection.connectionId}');

    // var clientId = UserData().getUserData.clientId.toString();
    // var id = UserData().getUserData.id.toString();

    //hubConnection.on("PatientAdded", PatientAdded([id,clientId]));

    // dPring("clientId:$clientId");
    dPrint(hubConnection.state.toString());
    dynamic data =  await hubConnection.invoke("logOut", args: <Object>[0, 0]);
    dPrint('nnnnnnnnnnn$data');

    // if(data['status']==1){

    // }
    //
  }


}
