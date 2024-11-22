import 'dart:async';

import 'package:get/get.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/assets.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workmanager/workmanager.dart';

import 'View/Pages/dashboard_view.dart';
import 'View/Pages/login_view.dart';
import 'View/Pages/master_dashboard_view.dart';
import 'View/Pages/rmd_view.dart';
import 'View/Pages/startup_view.dart';
import 'View/Pages/storage_data.dart';
import 'ViewModal/dashboard_view_modal.dart';
import 'ViewModal/login_view_modal.dart';
import 'app_manager/api/api_util.dart';
import 'app_manager/app_color.dart';
import 'app_manager/local_storage/local_storage.dart';
import 'app_manager/navigator.dart';
import 'app_manager/widgets/coloured_safe_area.dart';
import 'authenticaton/user_repository.dart';
import 'common_libs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  {
  LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    // get();
    super.initState();
    // get();
    _navigateToNextPage();

  }



  get() async {
    await Permission.storage.request();

    bool isStorage=await Permission.manageExternalStorage.isDenied;
    try{
      if (isStorage) {
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        await InternalStorage().insertStoredData(context);
      } else {
        await InternalStorage().insertStoredData(context);
      }
    }
    catch(e){}

    // Timer.periodic(Duration(seconds: 10), (timer) async {
    //
    //   bool isStorage=await Permission.manageExternalStorage.isDenied;
    //   if(isStorage){
    //     await Permission.storage.request();
    //     await Permission.manageExternalStorage.request();
    //   }else{
    //     await InternalStorage().insertStoredData(context);
    //   }
    //
    // });



    // WidgetsFlutterBinding.ensureInitialized();
    // await Workmanager().initialize(
    //     callbackDispatcher, // The top level function, aka callbackDispatcher
    //     isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    // );
    //
    // Workmanager().registerPeriodicTask(
    //   "periodic-task-identifier",
    //   "simplePeriodicTask",
    //   constraints: Constraints(
    //     networkType: NetworkType.connected,
    //
    //     // requiresBatteryNotLow: true,
    //     // requiresCharging: true,
    //     // requiresDeviceIdle: true,
    //     // requiresStorageNotLow: true
    //   ),
    //
    //   // When no frequency is provided the default 15 minutes is set.
    //   // Minimum frequency is 15 min. Android will automatically change
    //   // your frequency to 15 min if you have configured a lower frequency.
    //   frequency: Duration(minutes: 15),
    // );


    // DashboardViewModal dashboardVM =
    // Provider.of<DashboardViewModal>(context, listen: false);
    // await dashboardVM.appDetails(context);

  }

  void _navigateToNextPage() async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    await  checkForAppStoreVersion();

    dPrint('userLoginId ${userRepository.getUser.uhID}');

    await Future.delayed(const Duration(seconds: 4), () async {
      if (userRepository.getUser.uhID != null) {
       // Get.offAll(   DashboardView());
       Get.offAll(   RMDView());
      }  else {
        Get.offAll(     LoginView());
      }
    });
  }
String currentVersion='';


  Future<void> checkForAppStoreVersion() async {
    // Get the installed version of the app
    try{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        currentVersion = packageInfo.version;

      });

      dPrint('nnnnvnnvnnvnnnnnvnnnvnn  ' + currentVersion.toString());
    }
    catch(e){

    }
  }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   WidgetsBinding.instance.removeObserver(this);
  // }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =  Provider.of<UserRepository>(context, listen: true);
    dPrint("object");
    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(
        backgroundColor: AppColor.white,
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                // Image.asset(ImagePaths.medvantage_patientlogo),
                // userRepository.getAppDetails.appLogo.toString()==''?
                // Image.asset(ImagePaths.medvantage_patientlogo),
                 // Image.network('http://182.156.200.178:7083/'+userRepository.getAppDetails.appLogo.toString()),
                Spacer(),

                Text('Version : '+currentVersion.toString(),style: MyTextTheme.mediumBCN,),
                SizedBox(height: 15,)

              ]),
        ),
      )),
    );
  }
}


// callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//
//
//     return await InternalStorage().insertStoredData();
//   });
// }
