


import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/Localization/language_class.dart';
import 'package:medvantage_patient/ViewModal/addvital_view_modal.dart';


import 'package:medvantage_patient/ViewModal/consultdoctor_view_modal.dart';
import 'package:medvantage_patient/ViewModal/dashboard_view_modal.dart';
import 'package:medvantage_patient/ViewModal/editprofile_view_modal.dart';
import 'package:medvantage_patient/ViewModal/login_view_modal.dart';
import 'package:medvantage_patient/ViewModal/medicine_reminder_view_moda.dart';
import 'package:medvantage_patient/ViewModal/opt_view_modal.dart';
import 'package:medvantage_patient/ViewModal/prescription_viewmodal.dart';
import 'package:medvantage_patient/ViewModal/signup_view_modal.dart';
import 'package:medvantage_patient/ViewModal/supplement_intake_view_modal.dart';
import 'package:medvantage_patient/authenticaton/user.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:medvantage_patient/services/firebase_service/fireBaseService.dart';
import 'package:medvantage_patient/services/local_notification_services.dart';
import 'package:medvantage_patient/splash_screen.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'LiveVital/Wellue/wellue_view_modal.dart';
import 'ViewModal/MasterDashoboardViewModal.dart';
import 'ViewModal/activities_chronicle_view_modal.dart';
import 'ViewModal/bed_care_view_modal.dart';
import 'ViewModal/chat_view_modal.dart';
import 'ViewModal/exercise_view_model.dart';
import 'ViewModal/faq_view_modal.dart';
import 'ViewModal/feedback_view_modal.dart';
import 'ViewModal/food_intake_viewmodel.dart';
import 'ViewModal/fullbody_checkup_viewmodal.dart';
import 'ViewModal/home_isolation_request_view_modal.dart';
import 'ViewModal/homeisolation_view_modal.dart';
import 'ViewModal/pills_reminder_view_modal.dart';
import 'ViewModal/prescription_checklist_viewmodel.dart';
import 'ViewModal/report_tracking_view_modal.dart';
import 'ViewModal/rmd_view_modal.dart';
import 'ViewModal/symptoms_tracker_view_modal.dart';
import 'ViewModal/vitals_trend_view_modal.dart';
import 'authenticaton/user_repository.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyBFZMASaP9K4HV-8vpb2jrEoY4v43OKDow", appId: "874216638219", messagingSenderId: "874216638219", projectId: "smartheartfailureclini"));
  await Firebase.initializeApp(

  );




  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FireBaseService().connect();
  NotificationService().initNotification();
  /// temp
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print('Firebase Token: $token');  /// temp

  User user=await UserRepository().fetchUserData();





  // Invoke AddUser with ClientId and UserId


  print('nnnnnnnvnnnnnvnvnvnn '+user.patientName.toString());
  // AppDetailsDataModal appData=await UserRepository.fetchAppData();
  Language language=await ApplicationLocalizations.fetchLanguage();
  Lang localeData=await ApplicationLocalizations().load(language);
  final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang',"1");

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<LoginViewModal>(create: (_) => LoginViewModal(),),
            ChangeNotifierProvider<UserRepository>(create: (_) => UserRepository(currentUser: user, ),),
            ChangeNotifierProvider<MasterDashboardViewModal>(create: (_)=>MasterDashboardViewModal(),),
            ChangeNotifierProvider<DashboardViewModal>(create: (_)=>DashboardViewModal(),),
            ChangeNotifierProvider<ConsultDoctorViewModal>(create: (_)=>ConsultDoctorViewModal(),),
            ChangeNotifierProvider<HomeIsolationViewModal>(create: (_)=>HomeIsolationViewModal(),),
            ChangeNotifierProvider<SupplementIntakeViewModal>(create: (_)=>SupplementIntakeViewModal(),),
            ChangeNotifierProvider<EditProfileViewModal>(create: (_)=>EditProfileViewModal(),),
            ChangeNotifierProvider<SignUpViewModal>(create: (_)=>SignUpViewModal(),),
            ChangeNotifierProvider<OtpViewModal>(create: (_)=>OtpViewModal(),),
            ChangeNotifierProvider<ApplicationLocalizations>(create: (_) => ApplicationLocalizations(localeData: localeData,language: language,),),
            ChangeNotifierProvider<FullBodyCheckupDataModal>(create: (_)=>FullBodyCheckupDataModal(),),
            ChangeNotifierProvider<AddVitalViewModal>(create: (_)=>AddVitalViewModal(),),
            ChangeNotifierProvider<PrescriptionViewModal>(create: (_)=>PrescriptionViewModal(),),
            ChangeNotifierProvider<SymptomsTrackerViewModal>(create: (_)=>SymptomsTrackerViewModal(),),
            ChangeNotifierProvider<VitalsTrendsViewModal>(create: (_)=>VitalsTrendsViewModal(),),
            ChangeNotifierProvider<HomeIsolationRequestListViewModal>(create: (_)=>HomeIsolationRequestListViewModal(),),
            ChangeNotifierProvider<MedicineReminderViewModal>(create: (_)=>MedicineReminderViewModal(),),
            ChangeNotifierProvider<MedicineViewCheckListDataMOdel>(create: (_)=>MedicineViewCheckListDataMOdel(),),
            ChangeNotifierProvider<FoodIntakeViewModel>(create: (_)=>FoodIntakeViewModel(),),
            ChangeNotifierProvider<ChatViewModal>(create: (_)=>ChatViewModal(),),
            ChangeNotifierProvider<ReportTrackingViewModal>(create: (_)=>ReportTrackingViewModal(),),
            ChangeNotifierProvider<ExerciseViewModel>(create: (_)=>ExerciseViewModel(),),
            ChangeNotifierProvider<WellueViewModal>(create: (_)=>WellueViewModal(),),
            ChangeNotifierProvider<ActivitiesChronicleViewModal>(create: (_)=>ActivitiesChronicleViewModal(),),
            ChangeNotifierProvider<ThemeProviderLd>(create: (_)=>ThemeProviderLd(),),
            // ChangeNotifierProvider<AppThemeProvider>(create: (_)=>AppThemeProvider(),),
            ChangeNotifierProvider<PillsReminderViewModal>(create: (_)=>PillsReminderViewModal(),),
            ChangeNotifierProvider<FeedbackViewModal>(create: (_)=>FeedbackViewModal(),),
            ChangeNotifierProvider<FAQViewModal>(create: (_)=>FAQViewModal(),),
            ChangeNotifierProvider<BedCareConnectViewModal>(create: (_)=>BedCareConnectViewModal(),),


            ChangeNotifierProvider<RMDViewModal>(create: (_)=>RMDViewModal(),),
            // ChangeNotifierProvider<AddDeviceViewModal>(create: (_)=>AddDeviceViewModal(),),
          ],child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  ThemeProviderLd themeChangeProvider = ThemeProviderLd();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.getTheme();
    // DashboardViewModal dashboardVM =
    // Provider.of<DashboardViewModal>(context, listen: false);
    // await dashboardVM.appDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    LoginViewModal loginVM = Provider.of<LoginViewModal>(context, listen: false);
    loginVM.connectServer();
    return GetMaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      textDirection: localization.getLanguage.toString()=="Language.arabic" ||
          localization.getLanguage.toString()=="Language.urdu" ?
      TextDirection.rtl:
      TextDirection.ltr,
      debugShowCheckedModeBanner: false,

     // theme:style.themeData(themeChangeProvider.darkTheme, context),
      // theme: Provider.of<ThemeProviderLd>(context).getThemeData,
      // ThemeData(
      //
      //   primarySwatch: Colors.blue,
      // ),
      // home: const DashboardView (),
      home: const SplashScreen (),
    );
  }
}
class NavigationService{
  static GlobalKey<NavigatorState>navigatorKey = GlobalKey<NavigatorState>();
}

