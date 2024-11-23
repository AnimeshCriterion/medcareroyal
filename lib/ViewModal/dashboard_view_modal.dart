import 'dart:core';

import '../../theme/style.dart';
import 'package:medvantage_patient/Modal/app_details_data_modal.dart';
import 'package:get/get.dart';

import '../../theme/style.dart';
import 'package:medvantage_patient/Modal/app_details_data_modal.dart';
import 'package:medvantage_patient/Modal/banner_detail_modal.dart';
import 'package:medvantage_patient/Modal/blog_details_modal.dart';
import 'package:medvantage_patient/Modal/count_details_modal.dart';
import 'package:medvantage_patient/Modal/doctor_details_modal.dart';
import 'package:medvantage_patient/Modal/health_product_details_modal.dart';
import 'package:medvantage_patient/Modal/menu_details_modal.dart';
import 'package:medvantage_patient/Modal/myappointment_data_modal.dart';
import 'package:medvantage_patient/Modal/top_clinics_modal.dart';
import 'package:medvantage_patient/View/Pages/addvital_view.dart';
import 'package:medvantage_patient/View/Pages/food_intake.dart';
import 'package:medvantage_patient/View/Pages/supplement_intake_view.dart';

import 'package:medvantage_patient/View/Pages/symptom_tracker_view.dart';
import 'package:medvantage_patient/View/Pages/urin_output.dart';
import 'package:medvantage_patient/View/Pages/water_intake_view.dart';
import 'package:medvantage_patient/ViewModal/login_view_modal.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/api/api_response.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/assets.dart';
import 'package:medvantage_patient/services/firebase_service/fireBaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uni_links/uni_links.dart';

import '../LiveVital/google_fit/google_fit_view.dart';
import '../Localization/app_localization.dart';
import '../Modal/client_details_data_modal.dart';
import '../Modal/top_image_modal.dart';
import '../View/Pages/home_isolation_patient_list_view.dart';

import '../View/Pages/medicine_reminder_view.dart';
import '../View/Pages/prescription_checklist.dart';
import '../View/widget/common_method/show_progress_dialog.dart';
import '../app_manager/api/api_util.dart';
import '../app_manager/app_color.dart';
import '../app_manager/ur_launcher.dart';
import '../app_manager/widgets/buttons/primary_button.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';
import '../theme/theme.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class DashboardViewModal extends ChangeNotifier {
  final Api _api = Api();
  List cityName = [
    {'name': 'Lucknow'},
    {'name': 'Patna'},
    {'name': 'Banglore'}
  ];

  List sliderImages = [
    {
      'image': 'assets/dashboard_image/dashboard_doctor.png',

      // 'title': 'Online Consulation with\nan Expert doctor',
      // 'image1': '',
      // 'title2': 'Caugh',
      // 'title3': 'fever',
      // 'title4': 'Other symptoms',
      // 'title5': '',
    },
    {
      'image': 'assets/dashboard_image/dashboard_slider_checkup.png',
      // 'image1': '',
      // 'title': 'Regular Checkup',
      // 'title2': 'Your checkup with our\nmost experienced doctors',
      // 'title3': '',
      // 'title4': '',
      // 'title5': '',
    },
    {
      'image': 'assets/dashboard_image/dashboard_slider_covid.png',
      // 'image1': '',
      // 'title': 'Be prepared ',
      // 'title2': 'Be aware',
      // 'title3': '',
      // 'title4': '',
      // 'title5': '',
    },
    {
      'image': 'assets/dashboard_image/dashboard_slider_man image.png',
      // 'image1': 'assets/dashboard_icons/digi_doctor_icon.png',
      // 'title2': 'Newly launched',
      // 'title3': 'Upated brands',
      // 'title4': 'Online Consult',
      // 'title5': 'Explore new products',
    }
  ];



  dashboardGrid(context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);

    return [
      {
        'title': localization.getLocaleData.symptomTracker,
        'navigateKey': 'symptomTracker',
        'icons': ImagePaths.symptomTracker.toString()
      },
      {
        'title': localization.getLocaleData.addVital,
        'navigateKey': 'addVital',
        'icons': ImagePaths.addvital.toString(),
      },
      {
        'title': localization.getLocaleData.fluidIntake,
        'navigateKey': 'Intake/Output',
        'icons': ImagePaths.intakeoutputImage.toString()
      },
      //
      // {
      //   'title': "Apple Health",
      //   'navigateKey': 'appleHealth',
      //   'icons':ImagePaths.addvital.toString(),
      // },
      {
        'title': localization.getLocaleData.prescriptionChecklist,
        'navigateKey': 'prescriptionCheckList',
        'icons': ImagePaths.prescriptionChecklist.toString()
      },
      {
        'title': localization.getLocaleData.dietChecklist,
        'navigateKey': 'diettracking',
        'icons': ImagePaths.dietTracking.toString()
      },
      {
        'title': localization.getLocaleData.supplementChecklist,
        'navigateKey': 'supplementIntake',
        'icons': ImagePaths.suppleChecklist.toString()
      },
    ];
  }

  List medicine = [
    {'title': 'Medicines', 'image': ImagePaths.medicineImage.toString()},
    {'title': 'Lab Test', 'image': ImagePaths.labTest.toString()},
    {
      'title': 'Supplement intake',
      'image': ImagePaths.supplementIntake.toString()
    },
  ];

  List symptom = [
    {'title': 'Body Ache', 'icons': ImagePaths.backPain.toString()},
    {'title': 'Cough', 'icons': ImagePaths.backPain.toString()},
    {'title': 'Diarrhoea', 'icons': ImagePaths.backPain.toString()},
    {'title': 'Fever', 'icons': ImagePaths.backPain.toString()},
    {'title': 'Vomiting', 'icons': ImagePaths.backPain.toString()},
    {'title': 'Tiredness', 'icons': ImagePaths.backPain.toString()},
    {'title': 'Headache', 'icons': ImagePaths.backPain.toString()},
    {'title': 'Body Ache', 'icons': ImagePaths.backPain.toString()}
  ];
  List moresymptom = [
    {
      'title': 'Abdominal pain',
    },
    {
      'title': 'Fever',
    },
    {
      'title': 'Headache',
    },
    {
      'title': 'Diarrhea',
    },
    {
      'title': 'Muscle Cramp',
    },
    {
      'title': 'chills',
    },
    {
      'title': 'Loss of appetite',
    },
    {
      'title': 'Cold',
    },
    {
      'title': 'Decrease vision',
    },
    {
      'title': 'Bloating',
    },
    {
      'title': 'Heartbun',
    },
    {
      'title': 'Fatique',
    },
  ];

  TextEditingController latC = TextEditingController();
  TextEditingController LngC = TextEditingController();

  TextEditingController searchC = TextEditingController();

  int currentImage = 0;

  clearData(context) {
    searchC.clear();
     Get.back();
    notifyListeners();
  }

  onImageChanged(int index) {
    currentImage = index;
    notifyListeners();
  }

  onPressedGridOpt(context, val) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    switch (val) {
      case "diettracking":
        MyNavigator.push(context, const FoodIntakeView());
        break;
      case 'Intake/Output':
        MyNavigator.push(context, const SliderVerticalWidget());
        break;
      case 'prescriptionCheckList':
        MyNavigator.push(context, const PrescriptionCheckListView());
        break;

      case 'homeIsolation':
        MyNavigator.push(context, const HomeIsolationPatientListView());
        break;

      case 'symptomTracker':
        MyNavigator.push(context, const SymptomTracker());

        break;
        // case 'appleHealth':
        //   MyNavigator.push(context, const GoogleFitView());
        //
        // break;
      case 'addVital':
        MyNavigator.push(context, const AddVitalView());
        break;
      case 'supplementIntake':
        MyNavigator.push(context, const SupplementIntakeView());

        break;
      case 'medicines':
        MyNavigator.push(
            context,
            const MedicineReminderView(
              title: "Medicines",
            ));

        break;
      case 'UrineOutput':
        MyNavigator.push(context, const UrinOutputView());

        break;
      case 'labTest':
        Alert.show(localization.getLocaleData.comingSoon.toString());

        break;
    }
  }

  List<BannerDetailsModal> get getBannerList =>
      List<BannerDetailsModal>.from(getDashboardResponse.data == null
          ? []
          : getDashboardResponse.data['bannerDetails']
              .map((element) => BannerDetailsModal.fromJson(element)));

  List<BlogDetailsModal> get getBlogLisrt =>
      List<BlogDetailsModal>.from(getDashboardResponse.data == null
          ? []
          : getDashboardResponse.data['blogDetails']
              .map((element) => BlogDetailsModal.fromJson(element)));

  List<HealthProductDetailsModal> get getHealthList =>
      List<HealthProductDetailsModal>.from(getDashboardResponse.data == null
          ? []
          : getDashboardResponse.data['healthProductDetails']
              .map((element) => HealthProductDetailsModal.fromJson(element)));

  List<CountDetailModal> get getCountList =>
      List<CountDetailModal>.from(getDashboardResponse.data == null
          ? []
          : getDashboardResponse.data['countDetails']
              .map((element) => CountDetailModal.fromJson(element)));

  List<MenuDetailsModal> get getMenuList =>
      List<MenuDetailsModal>.from(getDashboardResponse.data == null
          ? []
          : getDashboardResponse.data['menuDetails']
              .map((element) => MenuDetailsModal.fromJson(element)));

  List<TopImageModal> get getImageList =>
      List<TopImageModal>.from(getDashboardResponse.data == null
          ? []
          : getDashboardResponse.data['topImage']
              .map((element) => TopImageModal.fromJson(element)));

  List<MyAppointmentDataModal> get getUpcomingAppointments =>
      List<MyAppointmentDataModal>.from(getDashboardResponse.data == null
          ? []
          : (getDashboardResponse.data['upcomingAppoinments'] ?? [])
              .map((element) => MyAppointmentDataModal.fromJson(element)));

  // Doctor List getter
  // List<DoctorDetailsModal> get getDoctorList =>
  //     List<DoctorDetailsModal>.from(getDashboardResponse.data == null
  //         ? []
  //         : getDashboardResponse.data['doctorDetails']
  //         .map((element) => DoctorDetailsModal.fromJson(element)));

  List<DoctorDetailsModal> get getDoctorList =>
      List<DoctorDetailsModal>.from(((searchC.text == ''
              ? getDashboardResponse.data == null
                  ? []
                  : getDashboardResponse.data['doctorDetails']
              : getDashboardResponse.data == null
                  ? []
                  : getDashboardResponse.data['doctorDetails'].where(
                      (element) =>
                          (element['drName'].toString().toLowerCase().trim())
                              .trim()
                              .contains(searchC.text.toLowerCase().trim())))
          .map((element) => DoctorDetailsModal.fromJson(element))));

  // Clinic or Hospital List getter

  List<TopClinicsModal> get getClinicsList =>
      List<TopClinicsModal>.from(((searchC.text == ''
              ? getDashboardResponse.data == null
                  ? []
                  : getDashboardResponse.data['topClinics']
              : getDashboardResponse.data == null
                  ? []
                  : getDashboardResponse.data['topClinics'].where((element) =>
                      (element['name'].toString().toLowerCase().trim())
                          .trim()
                          .contains(searchC.text.toLowerCase().trim())))
          .map((element) => TopClinicsModal.fromJson(element))));

  // Blog List getter

  List<BlogDetailsModal> get getBlogList =>
      List<BlogDetailsModal>.from(((searchC.text == ''
              ? getDashboardResponse.data == null
                  ? []
                  : dashboardResponse.data['blogDetails']
              : dashboardResponse.data == null
                  ? []
                  : getDashboardResponse.data['blogDetails'].where((element) =>
                      (element['title'].toString().toLowerCase().trim())
                          .trim()
                          .contains(searchC.text.toLowerCase().trim())))
          .map((element) => BlogDetailsModal.fromJson(element))));

  ApiResponse dashboardResponse = ApiResponse.initial("initial");

  ApiResponse get getDashboardResponse => dashboardResponse;

  set _updateDashboardResponse(ApiResponse val) {
    dashboardResponse = val;
    if (getDashboardResponse.data != null) {
      dPrint('vvvvvvvvvvvvv' +
          getDashboardResponse.data['doctorDetails'].toString());
    }
    notifyListeners();
  }

  Future<void> patientDashboard(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);

    _updateDashboardResponse = ApiResponse.loading("Fetching Data");
    try {
      var data = await _api.call(context,
          url: AllApi.patientDashboard,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {
            "lat": "37.421998333333335",
            "long": "-122.084",
            "memberId": userRepository.getUser.uhID
          }));
      dPrint(data.toString());
      if (data['responseCode'] == 1) {
        _updateDashboardResponse =
            ApiResponse<Map>.completed(data['responseValue'][0]);

        if (data['responseValue'].isEmpty) {
          _updateDashboardResponse = ApiResponse.empty("Data not Available");
        }
      } else {
        _updateDashboardResponse = ApiResponse.empty("Data not Available");
        // Alert.show(data['message']);
      }
    } catch (e) {
      _updateDashboardResponse = ApiResponse.error(e.toString());
    }
  }

  List bannerList = [];

  List get getNewBannerList => bannerList;

  set updateBannerList(List val) {
    bannerList = val;
    notifyListeners();
  }

  bannerImg(context) async {
    try {
      var data = await _api.callMedvanatagePatient(context,
          url: "api/AppBanner/GetImagesForAppBanner",localStorage: true,
          apiCallType: ApiCallType.get());
      dPrint("nnnnnnnnnnnnnn $data");
      if (data["status"] == 1) {
        updateBannerList = data['responseValue'];
      } else {
        Alert.show("Symptoms Added Successfully !");
      }
    } catch (e) {}
  }

  Map<String, dynamic> ClientDetails={};
  ClientDetailsDataModal get getClintDetails=>ClientDetailsDataModal.fromJson(ClientDetails);
  set updateClintDetails(Map<String, dynamic> val){
    ClientDetails=val;

    notifyListeners();
  }


  GetClient(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    try {
      var data = await _api.callMedvanatagePatient7084(context,
          url: "api/Users/GetClient?id=${userRepository.getUser.clientId.toString()}",localStorage: true,
          apiCallType: ApiCallType.get( ));
      dPrint("nnnnnnnnnnnnnn $data");
      if (data["status"] == 1) {
        updateClintDetails=data["responseValue"].isEmpty? {}:data["responseValue"][0];
      } else {
        Alert.show("Symptoms Added Successfully !");
      }
    } catch (e) {}
  }
  // Map<String, dynamic> appData={};
  // AppDetailsDataModal get getAppData=>AppDetailsDataModal.fromJson(appData);
  // set updateAppData(Map<String, dynamic> val){
  //   appData=val;
  //   notifyListeners();
  // }


  // appDetails(context) async {
  //   UserRepository userRepository =
  //   Provider.of<UserRepository>(context, listen: false);
  //   try {
  //     var data = await _api.callMedvanatagePatient(context,localStorage: true,
  //         url: "api/AppCustomizationForSHFC/GetAppCustomizationForSHFC?id=1&clientID=${userRepository.getUser.clientId.toString()}",newBaseUrl: 'http://182.156.200.178:7083/',
  //         apiCallType: ApiCallType.get());
  //     dPring("nnnnnnnnnnnnnn $data");
  //     if (data["status"] == 1) {
  //       await userRepository.appData(AppDetailsDataModal.fromJson(data['responseValue']));
  //       // updateAppData=data['responseValue'];
  //     } else {
  //     }
  //   } catch (e) {}
  // }


  bool isMorningTime=false;
  bool get getIsMorningTime=>isMorningTime;
  set updateIsMorningTime(bool val){
    isMorningTime=val;
    notifyListeners();
  }


  callTiming(){

    String morningTime='';
    var currentDate=(DateFormat('yyyy-MM-dd').format(DateTime.now())).toString();

    morningTime=(DateTime.parse('${currentDate} 23:00:00').difference(DateTime.now()).inMinutes).toString();
    dPrint('nnnnvnnnvnnnv '+morningTime.toString());
    return morningTime;
  }


}
