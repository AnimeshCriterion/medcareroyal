import 'dart:convert';


import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/Modal/menu_details_modal.dart';

import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_response.dart';

import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../View/Pages/edit_profile_view.dart';

import '../View/Pages/home_isolation_view.dart';

import '../View/Pages/medicine_reminder_view.dart';
import '../View/Pages/startup_view.dart';
import '../View/Pages/symptom_tracker_view.dart';
import '../app_manager/api/api_call.dart';
import '../app_manager/bottomSheet/bottom_sheet.dart';
import '../app_manager/bottomSheet/functional_sheet.dart';
import '../app_manager/pdf_viewer.dart';
import '../app_manager/web_view.dart';
import '../assets.dart';
import '../authenticaton/user.dart';
import '../medcare_utill.dart';

class DrawerViewModals extends ChangeNotifier {
  final Api _api = Api();



  List drawerList=[
    {
      'title':'Symptoms Tracker',
      'light_img':ImagePaths.symptomTrackerLight.toString(),
      'dark_img':  ImagePaths.symptomTrackerLight.toString(),
    },
    {
      'title':'Add Vital',
      'light_img':ImagePaths.addVitalsLight.toString(),
      'dark_img':  ImagePaths.addVitalsDark.toString(),
    },
    {
      'title':'Fluid Intake/Output',
      'light_img':ImagePaths.fluidLight.toString(),
      'dark_img':  ImagePaths.fluidDark.toString(),
    },
    {
      'title':'Urine Output',
      'light_img':ImagePaths.fluidLight.toString(),
      'dark_img':  ImagePaths.fluidDark.toString(),
    },
    {
      'title':'Prescription Checklist',
      'light_img':ImagePaths.prescriptionLight.toString(),
      'dark_img':  ImagePaths.prescriptionDark.toString(),
    },
    {
      'title':'Diet Checklist',
      'light_img':ImagePaths.dietChecklistLight.toString(),
      'dark_img':  ImagePaths.dietChecklistDark.toString(),
    },
    {
      'title':'Pills Reminder',
      'light_img':ImagePaths.dietChecklistLight.toString(),
      'dark_img':  ImagePaths.dietChecklistDark.toString(),
    },
    {
      'title':'Supplement Checklist',
      'light_img':ImagePaths.supplementLight.toString(),
      'dark_img':  ImagePaths.supplementDark.toString(),
    },
    {
      'title':'Exercise Tracker',
      'light_img':ImagePaths.exerciseLight.toString(),
      'dark_img':  ImagePaths.exerciseDark.toString(),
    },
    {
      'title':'Activities Chronicle',
      'light_img':ImagePaths.exerciseLight.toString(),
      'dark_img':  ImagePaths.exerciseDark.toString(),
    },
    {
      'title':'Upload Report',
      'light_img':ImagePaths.uploadReportLight.toString(),
      'dark_img':  ImagePaths.uploadReportDark.toString(),
    },
    {
      'title':'FAQs',
      'light_img':ImagePaths.faqLight.toString(),
      'dark_img':  ImagePaths.faqDark.toString(),
    },
  ];



  List<MenuDetailsModal> get getMenuList => getMenuResponse.data ?? [];
  ApiResponse menuResponse = ApiResponse.initial("initial");

  ApiResponse get getMenuResponse => menuResponse;

  set _updateMenuResponse(ApiResponse val) {

    menuResponse = val;
    notifyListeners();
  }

  Future<void> getMenuForApp(context) async {
    _updateMenuResponse = ApiResponse.loading("Fetching Menu");
    try {
      var data = await _api.call(context,
          url: AllApi.getMenuForApp,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {}));
      if (data['responseCode'] == 1) {
        menuResponse.data = (List<MenuDetailsModal>.from(((data['responseValue'] ?? []) as List).map((e)
        => MenuDetailsModal.fromJson(e))));

        _updateMenuResponse = ApiResponse<List<MenuDetailsModal>>.completed(
            getMenuResponse.data ?? []);
 
        if (data['responseValue'].isEmpty) {
          _updateMenuResponse = ApiResponse.empty("Address not available");
        }
        else {}
      }
      else {
        _updateMenuResponse = ApiResponse.empty("Address not available");
        Alert.show(data['message']);
      }
    }
    catch (e) {
      _updateMenuResponse = ApiResponse.error(e.toString());
    }
  }
  onPressLogOutButton(context) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository = Provider.of<UserRepository>( context, listen: false);

    await CustomBottomSheet.open(context,
        child:  FunctionalSheet(
          message: localization.getLocaleData.areuSureYouWantToLogOut.toString(),
          buttonName: localization.getLocaleData.yes.toString(),
          onPressButton: () async {
            dPrint('nnnnnnnvvvv');


            await userRepository.updateUserData(User());
            await userRepository.logOutUser(context);
            MyNavigator.pushAndRemoveUntil(context, const StartupPage());
            dPrint('nnnnnnnvvvv');
          },
        ));


  }}
