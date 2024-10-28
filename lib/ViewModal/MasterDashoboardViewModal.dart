


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/Modal/investigation_model.dart';
import 'package:medvantage_patient/View/Pages/activities_chronicle_view.dart';
import 'package:medvantage_patient/View/Pages/edit_profile_view.dart';
import 'package:medvantage_patient/View/Pages/exercise_tracking_view.dart';
import 'package:medvantage_patient/View/Pages/food_intake.dart';
import 'package:medvantage_patient/View/Pages/lifestyle_interventions_view.dart';
import 'package:medvantage_patient/View/Pages/pills_reminder_view.dart';
import 'package:medvantage_patient/View/Pages/prescription_checklist.dart';
import 'package:medvantage_patient/View/Pages/rmd_view.dart';
import 'package:medvantage_patient/View/Pages/upload_report_view.dart';
import 'package:medvantage_patient/View/Pages/supplement_intake_view.dart';
import 'package:medvantage_patient/View/Pages/symptom_tracker_view.dart';
import 'package:medvantage_patient/View/Pages/urin_output.dart';
import 'package:medvantage_patient/View/Pages/water_intake_view.dart';
import 'package:medvantage_patient/assets.dart';

import '../Localization/app_localization.dart';
import '../View/Pages/addvital_view.dart';
import '../View/Pages/bed_care_connect_view.dart';
import '../View/Pages/chat_view.dart';
import '../View/Pages/dashboard_view.dart';

import '../View/Pages/feedback_view.dart';
import '../View/Pages/fq_view.dart';
import '../View/Pages/home_care_training_view.dart';
import '../View/Pages/investigation_page.dart';
import '../View/Pages/nnn.dart';
import '../View/Pages/pills_remind_intake_analytics.dart';
import '../View/Pages/pills_reminder_scheduled_prescription.dart';
import '../View/Pages/plan_of_care_view.dart';
import '../View/Pages/setting.dart';
import '../View/Pages/sysmptoms_tracker_view.dart';
import '../remote_dashboard/remote_dashboard_view.dart';
import '../common_libs.dart';

class MasterDashboardViewModal extends ChangeNotifier{


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  onPressOpenDrawer(){
    // updateIsSelectedDrawer=true;
    // scaffoldKey.currentState!.openDrawer();
  }

  List drawerList=[
    {
      'title':'Home',
      'light_img':'assets/colorful/drawer1.png',
      'dark_img':  ImagePaths.home.toString(),
    },
    {
      'title':'Symptoms Tracker',
      'light_img':'assets/colorful/drawer2.png',
      'dark_img':  ImagePaths.symptomTrackerDark.toString(),
    },
    {
      'title':'Vital Management',
      'light_img':'assets/colorful/drawer3.png',
      'dark_img':  ImagePaths.addVitalsDark.toString(),
    },
    {
      'title':'Fluid Management',
      'light_img':'assets/colorful/drawer5.png',
      'dark_img':  ImagePaths.fluidDark.toString(),
    },
    // {
    //   'title':'Urine Output',
    //   'light_img':ImagePaths.fluidLight.toString(),
    //   'dark_img':  ImagePaths.fluidDark.toString(),
    // },
    {
      'title':'Prescription Checklist',
      'light_img':'assets/colorful/drawer6.png',
      'dark_img':  ImagePaths.prescriptionDark.toString(),
    },
    {
      'title':'Diet Checklist',
      'light_img':'assets/colorful/drawer8.png',
      'dark_img':  ImagePaths.dietChecklistDark.toString(),
    },
    // {
    //   'title':'Pills Reminder',
    //   'light_img':ImagePaths.dietChecklistLight.toString(),
    //   'dark_img':  ImagePaths.dietChecklistDark.toString(),
    // },
    {
      'title':'Supplement Checklist',
      'light_img':'assets/colorful/drawer9.png',
      'dark_img':  ImagePaths.supplementDark.toString(),
    },
    {
      'title':'Exercise Tracker',
      'light_img':'assets/colorful/drawer11.png',
      'dark_img':  ImagePaths.excerciseTrackerDark.toString(),
    },


    {
      'title':'Upload Report',
      'light_img':'assets/colorful/drawer12.png',
      'dark_img':  ImagePaths.uploadReportDark.toString(),
    },

    {
      'title':'RMD',
      'light_img':'assets/colorful/drawer12.png',
      'dark_img':  ImagePaths.uploadReportDark.toString(),
    },
      {
      'title':'Feedback',
      'light_img':'assets/colorful/drawer14.png',
      'dark_img':  ImagePaths.feedback_dark.toString(),
    },


    {
      'title':'FAQs',
      'light_img':'assets/colorful/drawer13.png',
      'dark_img':  ImagePaths.faq_dark.toString(),
    },
    {
      'title':'Chat',
      'light_img':'assets/colorful/drawer16.png',
      'dark_img': 'assets/lightm_patient/chat.png',
    }, {
      'title':'BedCareConnect',
      'light_img':'assets/colorful/drawer10.png',
      'dark_img': 'assets/lightm_patient/chat.png',
    },
    {
      'title':'SmartHeart Failure Revival Training',
      'light_img':'assets/colorful/drawer10.png',
      'dark_img':  ImagePaths.home_care_trainning_dark.toString(),
    },

    {
      'title':'Activities Chronicle',
      'light_img':'assets/colorful/drawer4.png',
      'dark_img':  ImagePaths.activityChronicleDark.toString(),
    },
    {
      'title':'Setting',
      'light_img':'assets/colorful/drawer4.png',
      'dark_img':  ImagePaths.activityChronicleDark.toString(),
    },
    // {
    //     'title':'Pills Reminder Intake Analytics',
    //   'light_img':ImagePaths.dietChecklistLight.toString(),
    //   'dark_img':  ImagePaths.dietChecklistLight.toString(),
    // },
    // {
    //   'title':'FAQs',
    //   'light_img':ImagePaths.faqLight.toString(),
    //   'dark_img':  ImagePaths.faqDark.toString(),
    // },
  ];

  bool isSelectedDrawer=false;
  bool get getIsSelectedDrawer=>isSelectedDrawer;
  set updateIsSelectedDrawer(bool val){
    isSelectedDrawer=val;
    notifyListeners();
  }


  String selectedPage='Home';
  String get getSelectedPage=>selectedPage;
  set updateSelectedPage(String val){
    selectedPage=val;
       notifyListeners();
  }

  onSelectPage(){
    switch(getSelectedPage){
      case 'Home':
        Get.to(()=>const RMDView());
        // return  DashboardView();
    case 'Symptoms Tracker':
      Get.to(()=>const SymptomTracker());
      // return  SymptomTracker();

      case 'Edit Profile':
        Get.to(()=>EditProfile());
        // return  EditProfile();
      case 'Prescribed Investigation':
        Get.to(()=>InvestigationPage());
        // return  EditProfile();
break;
    case 'Vital Management' :
      Get.to(()=>const AddVitalView());
      // return AddVitalView();
      case 'Vital Management' :
        Get.to(()=>const AddVitalView());
        // return AddVitalView();
    break;
    case 'Fluid Management':
      Get.to(()=>const SliderVerticalWidget());
      // return  SliderVerticalWidget();


      case 'Fluid Management':
        Get.to(()=>const SliderVerticalWidget());
        // return  SliderVerticalWidget();
    break;
    case 'Urine Output':
      Get.to(()=>const UrinOutputView());
      // return  UrinOutputView();
    break;
    case 'Prescription Checklist':
      Get.to(()=>const PillsReminderView());
      // return  PillsReminderView();
        // PrescriptionCheckListView();
    break;
    case 'Diet Checklist':
      Get.to(()=>const FoodIntakeView());
      // return  FoodIntakeView();
    break;
    case 'Pills Reminder':
      Get.to(()=>const PillsReminderView());
      // return  PillsReminderView();
    break;
    case 'Supplement Checklist':
      Get.to(()=>const SupplementIntakeView());
      // return
      //   // PrescriptionCheckListView();
      //     SupplementIntakeView();
    break;

    case 'Exercise Tracker':
      Get.to(()=>const ExerciseTrackingView());
      // return ExerciseTrackingView();
    break;
    case 'Activities Chronicle':
      Get.to(()=>const ActivitiesChronicleView());
      // return ActivitiesChronicleView();
    break;
    case 'Upload Report':
      Get.to(()=>const ReportTrackingView());
      // return ReportTrackingView();
    break;
      case 'Plan of care':
        Get.to(()=>const PlanOfCareView());
    // return
    case 'SmartHeart Failure Revival Training':
      Get.to(()=>const HomeCareTrainingView());
      // return HomeCareTrainingView();
    break;
    case 'PR Scheduled Prescription':
      Get.to(()=>const PillsReminderScheduledPrescription());
      // return PillsReminderScheduledPrescription();
    break;
      // case 'Pills Reminder Intake Analytics':
      //   return PillsReminderIntakeAnaytics();
        break;
        case 'Lifestyle Interventions':
          Get.to(()=>const LifeStyleInterventions());
          // return LifeStyleInterventions();
      break;
      case 'Feedback':
        Get.to(()=>const FeedbackView());
           // return FeedbackView();
      break;
      case 'RMD':
        Get.to(()=>RMDView());
        // return FeedbackView();
        break;
    case 'FAQs':
      Get.to(()=>const FAndQView());
      // return FAndQView();
      break;

      case 'RMD':
        Get.to(()=>const RemoteDashboardView());
        // return SymptomTrackerView();
        break;
      case 'Update Symptoms':
        Get.to(()=>const SymptomTrackerView());
        // return SymptomTrackerView();
        break;
      case 'Chat':
        Get.to(()=>const ChatView());
        // return  ChatView();
   break;
      case 'BedCareConnect':
        Get.to(()=>const BedCareConnectView());
        // return  BedCareConnectView();
        break;
      case 'Setting':
        Get.to(()=>const Setting());
        // return  ChatView();
        break;
      case 'nnn':
        // Get.to(()=>  CustomSearchableDropDown());
        // return  BedCareConnectView();
        break;

        default:
          Get.off(()=>const RMDView());
        // return  DashboardView();
    }
// notifyListeners();
  }


}