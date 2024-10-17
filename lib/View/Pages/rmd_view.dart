

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/View/Pages/dose.dart';
import 'package:medvantage_patient/View/Pages/pills_reminder_view.dart';
import 'package:medvantage_patient/View/Pages/water_intake_view.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/theme/theme_provider.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Localization/app_localization.dart';
import '../../Modal/medicine_intake_data_model.dart';
import '../../ViewModal/MasterDashoboardViewModal.dart';
import '../../ViewModal/addvital_view_modal.dart';
import '../../ViewModal/dashboard_view_modal.dart';
import '../../ViewModal/prescription_checklist_viewmodel.dart';
import '../../ViewModal/rmd_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/services/check_for_update.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../assets.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import '../../main.dart';
import '../../theme/theme.dart';
import '../../voice_assistant.dart';
import 'addvital_view.dart';
import 'drawer_view.dart';
import '../../theme/style.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'nnn.dart';

class RMDView extends StatefulWidget {
  const RMDView({super.key});

  @override
  State<RMDView> createState() => _RMDViewState();
}

class _RMDViewState extends State<RMDView> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();

  }

  get() async {

    RMDViewModal rmdViewModal =
    Provider.of<RMDViewModal>(context, listen: false);

    MedicineViewCheckListDataMOdel controller =
    Provider.of<MedicineViewCheckListDataMOdel>(context, listen: false);
    await controller.apiCall(context);
    rmdViewModal. updateCurrentIndex=0;

    try{
      Updater().checkVersion(context);
    }
  catch(e){

  }
    try{
      WidgetsBinding.instance
          .addPostFrameCallback((_) async {


            await rmdViewModal.bannerImg(context);
        await rmdViewModal.GetClient(context);
        await rmdViewModal.hitVitalHistory(context);
        rmdViewModal.getVitalsValue();
        await rmdViewModal.manualFoodAssign(context);
        await rmdViewModal.pillsReminderApi(context);
        if (Platform.isAndroid) {
          PermissionStatus status =
              await Permission.activityRecognition.request();
          if (status.isGranted) {
            print("nnvnnnnnvnnnnvnnnnvn isGranted");
            await rmdViewModal.startStepCounter();
          } else {
            print("nnvnnnnnvnnnnvnnnnvn  ");
            // Permission denied, handle appropriately
          }
        }else{
          await rmdViewModal.startStepCounter();
        }
      });
    }
    catch(e){

    }
  }

  List temp=[
    {
      'img':'assets/resp.png'
    },
    {
      'img':'assets/temp.png'
    },
    {
      'img':'assets/spo.png'
    },
    {
      'img':'assets/spo.png'
    },
    {
      'img':'assets/hr.png'
    },
  ];




  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String toCamelCase(String input) {
    if (input.isEmpty) return input;

    // Split the string by spaces or underscores, and remove any empty strings
    var data=  input.split('')[0].toString().toUpperCase()+ input.substring(1);

    return data;
  }

  @override
  Widget build(BuildContext context) {

    final BuildContext? _context=NavigationService.navigatorKey.currentContext;
    MasterDashboardViewModal masterDashboardViewModal = Provider.of<MasterDashboardViewModal>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChange.darkTheme, context);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: true);
    RMDViewModal rmdViewModal = Provider.of<RMDViewModal>(context, listen: true);

    UserRepository userRepository = Provider.of<UserRepository>(context, listen: true);
    List upperList = [
      {'title': localization.getLocaleData.symptomTracker, 'img': 'chills.svg', 'navigation': 'Symptoms Tracker'},
      {'title': localization.getLocaleData.VitalManagement, 'img': 'vitals.svg', 'navigation': 'Vital Management'},
      {'title': localization.getLocaleData.FluidManagement, 'img': 'fluidmanagement.svg', 'navigation': 'Fluid Management'},
      {'title': localization.getLocaleData.PrescriptionChecklist, 'img': 'pills.svg', 'navigation': 'Prescription Checklist'},
      // {'title': localization.getLocaleData.dietChecklist, 'img': 'dietchecklist.svg', 'navigation': 'Diet Checklist'},
      {'title': localization.getLocaleData.SupplementChecklist, 'img': 'suppliment.svg', 'navigation': 'Supplement Checklist'},
    ];
    List other = [
      {'title': localization.getLocaleData.UploadReport, 'img': 'uploadReport.svg', 'navigation': 'Upload Report'},
      {'title': localization.getLocaleData.LifestyleInterventions, 'img': 'lifestyle.svg', 'navigation': 'Lifestyle Interventions'},
    ];
    var dark = themeChange.darkTheme;
    var bgColor = dark ? VitalioColors.bgDark : Colors.white;
    var bgColor2 = dark ? VitalioColors.bgDark2 : VitalioColors.primaryBlueLight;

    return Container(
      color: bgColor,
      height: Get.height,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          drawer: const MyDrawer(),
          body: WillPopScope(
            onWillPop: () async {
              print("nnvnnnnnvnnnnvnnnnvnnnvnnnnnvnnnnvnnnnvnnnvnnnnnvnnnnvnnnnvn  ");
              // changeQtyAlert2();
              await CustomBottomSheet.open(_context,
                  child: FunctionalSheet(
                      message: localization
                          .getLocaleData.exit.toString()  ,
                      buttonName:  localization.getLocaleData.yes.toString(),
                      onPressButton: () async {
                        exit(0);

                      }));

              return Future.value(false);
            },
            child: RefreshIndicator(
              onRefresh: () async {
                try{
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) async {

                    await rmdViewModal.hitVitalHistory(context);
                    await rmdViewModal.manualFoodAssign(context);
                    await rmdViewModal.pillsReminderApi(context);

                  });
                }
                catch(e){

                }
              },
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh is always possible
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      decoration: BoxDecoration(color: bgColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(

                              color:  bgColor,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        scaffoldKey.currentState!.openDrawer();
                                        // MyNavigator.push(context, EditProfile());
                                        // // MyNavigator.push(context, const Menu());
                                        // masterDashboardViewModal.updateSelectedPage = 'Edit Profile';
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: themeChange.darkTheme == true ? Colors.grey.shade400 : Colors.grey.shade400,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: CachedNetworkImage(
                                                          imageUrl: userRepository.getUser.patientName.toString(),
                                                          placeholder: (context, url) => const Center(child: Icon(Icons.person, size: 35, color: Colors.grey)),
                                                          errorWidget: (context, url, error) => const Icon(Icons.person, size: 35, color: Colors.grey),
                                                          height: 50,
                                                          width: 50,
                                                          fit: BoxFit.fill)))),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text( rmdViewModal.currentWise(context).toUpperCase(), style: MyTextTheme.mediumBCN.copyWith(color: dark ? Colors.white : null)),
                                                Text(userRepository.getUser.patientName.toString().toUpperCase(),
                                                    style: MyTextTheme.largeBCB.copyWith(color: dark ? Colors.white : null, fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      selectEmergencyType(context);

                                      // String morningTime='';
                                      //           morningTime= await dashboardVM.callTiming();
                                      //           print('nnnnnnnvnnnv'+morningTime.toString());
                                      //
                                      //           if(int.parse(morningTime.toString())>=0 && int.parse(morningTime.toString())<=960){
                                      //
                                      //             UrlLauncher.launch('tel: 8652445262');
                                      //           }else{
                                      //
                                      //             UrlLauncher.launch('tel: ${userRepository.getAppDetails.eraEmergencyContactNumber.toString()}');
                                      //           }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor2),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                        child: Column(
                                          children: [
                                            Image.asset(themeChange.darkTheme ? 'assets/darkm_patient/sos.png' : "assets/lightm_patient/sos.png", height: 25),
                                            const SizedBox(height: 5),
                                            Text(localization.getLocaleData.SOS.toString(), style: MyTextTheme.smallGCN.copyWith(color: themeChange.darkTheme ? Colors.grey.shade400 : AppColor.greyDark)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            rmdViewModal.getMediconeCount().isEmpty?SizedBox(): Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(localization.getLocaleData.toTake.toString(), style: MyTextTheme.largeBCB.copyWith(color: dark ? Colors.white : null, fontWeight: FontWeight.w600)),
                            ),


                            ...List.generate(rmdViewModal.getMediconeCount().length, (index) {
                              var data=rmdViewModal.getMediconeCount()[index];
                              return   Padding(
                                padding: const EdgeInsets.fromLTRB(0,8,0,8),
                                child: Container(
                                  height: 95,
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: bgColor2),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Image.asset('assets/A Vitalio/Pill.png', height: 30, width: 30),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  color: dark?VitalioColors.greyBlue:Colors.white,
                                                ),
                                                child: Text(toCamelCase(data['dosageForm'].toString()).toString(),
                                                    style: MyTextTheme.mediumBCN.copyWith(
                                                      color: dark ? Colors.white : null,
                                                    ))),
                                            Text(toCamelCase(data['drugName'].toString()).toString(), style: MyTextTheme.mediumBCB.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                                            Text(toCamelCase(data['remark'].toString()).toString(), style: MyTextTheme.mediumGCN.copyWith(color: dark ? Colors.white : VitalioColors.greyText))
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {

                                          // Get.to(()=> Dose());

                                          await CustomBottomSheet.open(context,
                                            child: FunctionalSheet(
                                              message: localization
                                                  .getLocaleData.areYouSureYouHaveTakenThisMedicine
                                                  .toString(),
                                              buttonName:  localization.getLocaleData.yes.toString(),
                                              onPressButton: () async {
                                          rmdViewModal.insertMedication(context,
                                              data['pmId'].toString(),
                                              data['prescriptionRowID'],  DateFormat('HH:mm')
                                                  .format(
                                                  DateFormat('hh:mm a')
                                                      .parse( data['time'].toString(),
                                                  ))
                                                  .toString());
                                          }));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              // Icon(
                                              //   Icons.check_box_outline_blank,
                                              //   color: VitalioColors.greyLight,
                                              // ),
                                              Icon(
                                                Icons.more_vert,
                                                color: VitalioColors.greyLight,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ) ;
                            }),


                            const SizedBox(height: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const Vitals()));
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>  ECGGraph()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(localization.getLocaleData.vitals.toString(), style: MyTextTheme.largeBCN.copyWith(fontWeight: FontWeight.w600, color: dark ? Colors.white : null)),
                                  ),
                                ),
                                // InkWell(
                                //     onTap: () {
                                //       Navigator.push(context, MaterialPageRoute(builder: (context) => const MyMedicineBox()));
                                //     },
                                //     child: const Text("My Medicine "))
                              ],
                            ),

                      const SizedBox(height: 10),
                            Container(
                              height: 73,
                              width: double.infinity,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: bgColor2),
                              child: Row(
                                children: [
                                  rmdViewModal.vitalVitalImg.toString()==''?
                                  SizedBox():Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Image.asset( rmdViewModal.vitalVitalImg.toString(), height: 30, width: 30),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(rmdViewModal.vitalVitalName.toString(), style: MyTextTheme.largeBCB.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                                        Text(rmdViewModal.vitalVitalTime.toString() +' '+localization.getLocaleData.ago.toString(),  style: MyTextTheme.mediumGCN.copyWith(color: VitalioColors.greyLight))
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Row(
                                        children: [
                                          Text(rmdViewModal.vitalValue!.toString(), style: MyTextTheme.largeBCB.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w600, fontSize: 26)),
                                          Text(rmdViewModal.vitalUnit.toString(), style: MyTextTheme.mediumGCN.copyWith(color: dark ? Colors.white : Colors.black, )),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await rmdViewModal.hitVitalHistory(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0,0,8,8),
                                          child: Row(
                                            children: [Text(localization.getLocaleData.update.toString()+' ', style: MyTextTheme.mediumGCN.copyWith(color: VitalioColors.greyLight)), Image.asset('assets/A Vitalio/arrow-repeat.png',color: VitalioColors.greyLight,)],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(localization.getLocaleData.primaryActions.toString(),
                                    style: MyTextTheme.largeBCN.copyWith(fontWeight: FontWeight.w600, color: dark?Colors.white:Colors.black,),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            SizedBox(
                              height: 274,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StaggeredGrid.extent(
                                  maxCrossAxisExtent: 150,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  children: List.generate(
                                      upperList.length,
                                          (index) => InkWell(
                                          onTap: () async {

                                            Get.until(  (route) =>  route.settings.name=='/RMDView');
                                            masterDashboardViewModal.updateSelectedPage =upperList[index]
                                            ['navigation']
                                                .toString();
                                            await  masterDashboardViewModal.onSelectPage();
                                          },
                                          child: customContainerWidget(
                                            height: 115.0,
                                            width: 115.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  themeChange.darkTheme ? "assets/A Vitalio/${upperList[index]['img']}" : "assets/A Vitalio/${upperList[index]['img']}",
                                                  height: 50,
                                                  // color: themeChange.darkTheme?AppColor.white.withOpacity(.7):AppColor.grey,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  upperList[index]['title'].toString().replaceAll('\n', '').replaceAll(' ', '\n'),
                                                  textAlign: TextAlign.center,
                                                  style: MyTextTheme.mediumWCN.copyWith(color: dark ? Colors.white : Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ))),
                                ),
                              ),
                            ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      child: Text(
                                        localization.getLocaleData.other.toString(),
                                        style: MyTextTheme.largeBCN.copyWith(fontWeight: FontWeight.w600, color: dark?Colors.white:null,),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 141.0,
                                  child: StaggeredGrid.extent(
                                    maxCrossAxisExtent: 201,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    children:  List.generate(
                                        other.length,
                                            (index) => Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: InkWell(
                                              onTap: () async {

                                                Get.until(  (route) =>  route.settings.name=='/RMDView');
                                                masterDashboardViewModal.updateSelectedPage =other[index]
                                                ['navigation']
                                                    .toString();
                                                await  masterDashboardViewModal.onSelectPage();

                                              },
                                              child: customContainerWidget(
                                                height: 138.0,width: 150.0,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/A Vitalio/${other[index]['img']}",
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                          const SizedBox(width: 15),
                                                          Text(other[index]['title'].toString(), style: MyTextTheme.mediumGCN.copyWith(fontSize: 13, color:dark?Colors.white:Colors.black))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                            )),
                                  ),
                                ),




                            const SizedBox(height: 50,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),






          floatingActionButton: InkWell(
              onTap: () {
                aiCommandSheet(context);
              },
              child: SvgPicture.asset('assets/A Vitalio/mic.svg')),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   ApplicationLocalizations localization =
  //   Provider.of<ApplicationLocalizations>(context, listen: true);
  //   final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
  //   UserRepository userRepository =
  //   Provider.of<UserRepository>(context, listen: false);
  //
  //   MasterDashboardViewModal masterDashboardViewModal =
  //   Provider.of<MasterDashboardViewModal>(context, listen: true);
  //   RMDViewModal rmdViewModal =
  //   Provider.of<RMDViewModal>(context, listen: true);
  //   var dark= themeChange.darkTheme;
  //   return SafeArea(child: Scaffold(
  //     backgroundColor: dark?  Colors.black:AppColor.bgWhite,
  //     key: scaffoldKey,
  //     drawer: const MyDrawer(),
  //     body:  WillPopScope(
  //     onWillPop: () async {
  //       print('dr;ighldfjklg');
  //   // changeQtyAlert2();
  //         await CustomBottomSheet.open(context,
  //           child: FunctionalSheet(
  //             message: localization
  //                 .getLocaleData.exit.toString()  ,
  //             buttonName:  localization.getLocaleData.yes.toString(),
  //             onPressButton: () async {
  //               exit(0);
  //
  //         }));
  //
  //         return Future.value(false);
  //     },
  //       child: RefreshIndicator(
  //         onRefresh: () async {
  //           try{
  //             WidgetsBinding.instance
  //                 .addPostFrameCallback((_) async {
  //
  //               await rmdViewModal.hitVitalHistory(context);
  //               await rmdViewModal.manualFoodAssign(context);
  //               await rmdViewModal.pillsReminderApi(context);
  //
  //             });
  //           }
  //           catch(e){
  //
  //           }
  //         },
  //         child: CustomScrollView(
  //           physics: AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh is always possible
  //           slivers: [
  //             SliverFillRemaining(
  //               hasScrollBody: false,
  //               child: Column(
  //                 children: [
  //
  //                   Row(
  //                     children: [
  //                       InkWell(
  //                           onTap: (){
  //
  //                             scaffoldKey.currentState!.openDrawer();
  //                           },
  //                           child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Text( rmdViewModal.getClintDetails.clientName.toString(),
  //                                     style: MyTextTheme.mediumGCN.copyWith(
  //                                         fontSize: 16,
  //                                         color: themeChange.darkTheme
  //                                             ? AppColor.white.withOpacity(.6)
  //                                             : AppColor.greyDark,
  //                                         fontWeight: FontWeight.w700
  //                                       // color: color.primaryTextTheme.headline1!.color
  //                                     ),
  //                                   ),
  //                                 ),],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //
  //
  //   Expanded(
  //               child: SingleChildScrollView(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(height: 15),
  //                       // myContainer(child:Row(
  //                       //   children: [
  //                       //     Expanded(
  //                       //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                       //         children: [
  //                       //           Row(
  //                       //             children: [
  //                       //               Image.asset('assets/footstep.png'),
  //                       //               const SizedBox(width: 10),
  //                       //               Text(localization.getLocaleData.steps.toString(),style:  MyTextTheme.smallWCN.copyWith(
  //                       //                 color:  dark?   Colors.white:AppColor.black
  //                       //               ),
  //                       //               ),
  //                       //             ],
  //                       //           ),
  //                       //           Row(
  //                       //             children: [
  //                       //               Text(rmdViewModal.todaysStep .toString(),style:  MyTextTheme.largeWCB.copyWith(
  //                       //                   color:  dark?   Colors.white:AppColor.black,
  //                       //                 fontSize: 31
  //                       //               ),),
  //                       //               Text('/8000 ${localization.getLocaleData.steps}',style: MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //                       //             ],
  //                       //           ),
  //                       //
  //                       //           Text("${localization.getLocaleData.distance}  ${rmdViewModal.distance.toStringAsFixed(2)} ${localization.getLocaleData.km}",
  //                       //             style: themeChange.darkTheme? MyTextTheme.mediumWCB: MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //                       //
  //                       //         ],
  //                       //       ),
  //                       //     ),
  //                       //     CircularPercentIndicator(
  //                       //       circularStrokeCap: CircularStrokeCap.round,
  //                       //       radius: 53.0,
  //                       //       lineWidth: 15.0,
  //                       //       percent:(rmdViewModal.todaysStep>8000? 8000:rmdViewModal.todaysStep)/8000  ,
  //                       //
  //                       //       center: Padding(
  //                       //         padding: const EdgeInsets.all(8.0),
  //                       //         child: Text('${(rmdViewModal.todaysStep/40  ).toStringAsFixed(1)}%', style:MyTextTheme.mediumWCB.copyWith(color:  dark?   Colors.white:AppColor.black)),
  //                       //       ),
  //                       //       progressColor: Colors.deepPurpleAccent,
  //                       //     ),
  //                       //   ],
  //                       // )),
  //                       // Container(
  //                       //   child: CarouselSlider(
  //                       //     options: CarouselOptions(
  //                       //         autoPlay: true,
  //                       //         autoPlayAnimationDuration: const Duration(seconds: 1),
  //                       //         aspectRatio: 16 / 11,
  //                       //         height: 153.0,
  //                       //         enlargeCenterPage: true),
  //                       //     items: ( rmdViewModal.getNewBannerList ?? []).map((snapShot) {
  //                       //       return Builder(
  //                       //         builder: (BuildContext context) {
  //                       //           return Container(
  //                       //             height: MediaQuery.of(context).size.height,
  //                       //             width: MediaQuery.of(context).size.width,
  //                       //             decoration: BoxDecoration(
  //                       //               borderRadius: BorderRadius.circular(15),
  //                       //             ),
  //                       //             child: CachedNetworkImage(
  //                       //               // imageUrl:snapShot.photoReference.toString(),
  //                       //               imageUrl:snapShot['path'].toString(),
  //                       //               imageBuilder: (context, imageProvider) => Container(
  //                       //                 decoration: BoxDecoration(
  //                       //                   borderRadius: BorderRadius.circular(10),
  //                       //                   image: DecorationImage(
  //                       //                     image: imageProvider,
  //                       //                     fit: BoxFit.cover,
  //                       //                   ),
  //                       //                 ),
  //                       //               ),
  //                       //               placeholder: (context, url) => Container(
  //                       //                 decoration: BoxDecoration(
  //                       //                   borderRadius: BorderRadius.circular(10),
  //                       //                 ),
  //                       //                 child: Icon(Icons.image_not_supported,color: Colors.green,) ,
  //                       //               ),
  //                       //               errorWidget: (context, url, error) => Container(
  //                       //                   decoration: BoxDecoration(
  //                       //                     borderRadius: BorderRadius.circular(10),
  //                       //                   ),
  //                       //                   child: Icon(Icons.image_not_supported,color: Colors.green)),
  //                       //             ),
  //                       //           );
  //                       //         },
  //                       //       );
  //                       //     }).toList(),
  //                       //   ),
  //                       // ),
  //                       const SizedBox(height: 15,),
  //                       Text("${localization.getLocaleData.todaysVitals} ",style:  MyTextTheme.largeWCB.copyWith( color:  dark?   Colors.white:AppColor.black)),
  //                       const SizedBox(height: 10,),
  //                       Row(
  //                         children: [
  //                           Expanded(child:  myContainer(child:   VitalWidget(img: 'assets/spo.svg',
  //                               title: localization.getLocaleData.spo2.toString(),unit: '%',value: rmdViewModal.getValue( 56),
  //                           vitalDateTime: rmdViewModal.getVitalTime( 56),),),),
  //                           const SizedBox(width: 10,),
  //                           Expanded(child:  myContainer(child:   VitalWidget(img: 'assets/hr.svg',
  //                               title: localization.getLocaleData.heartRate.toString(),unit: 'BPM',value: rmdViewModal.getValue( 74),
  //   vitalDateTime: rmdViewModal.getVitalTime( 56),),),)
  //                         ],
  //                       ),
  //                       const SizedBox(height: 10,),
  //
  //                       Row(
  //                         children: [
  //                           Expanded(child:  myContainer(child:   VitalWidget(img: 'assets/temp.svg',
  //                               title: localization.getLocaleData.temp.toString(),unit: 'F',value: rmdViewModal.getValue( 5),
  //                         vitalDateTime: rmdViewModal.getVitalTime( 56),
  //                           ),),),
  //                           const SizedBox(width: 10,),
  //                           Expanded(child:  myContainer(child:   VitalWidget(img:'assets/resp.svg',
  //                               title: localization.getLocaleData.respiratory.toString(),unit: 'min',value: rmdViewModal.getValue( 7),
  //   vitalDateTime: rmdViewModal.getVitalTime( 56),),),)
  //                         ],
  //                       ),
  //                       const SizedBox(height: 10,),
  //
  //                   InkWell(
  //                     onTap: () async {
  //
  //                       Get.until(  (route) =>  route.settings.name=='/RMDView');
  //
  //                       masterDashboardViewModal.updateSelectedPage = 'Vital Management';
  //
  //                       await  masterDashboardViewModal.onSelectPage();
  //                       // Get.to(()=>const AddVitalView());
  //                     },   child: myContainer(child:Row(
  //                         children: [
  //                           Expanded(flex: 6,
  //                             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     SvgPicture.asset('assets/bp.svg'),
  //                                     const SizedBox(width: 10,),
  //                                     Text(localization.getLocaleData.bloodPressure.toString(),style: MyTextTheme.smallWCN.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //                                   ],
  //                                 ),
  //
  //                                 Row(
  //                                   children: [
  //                                     Text( rmdViewModal.getValue( 4)+'/'+rmdViewModal.getValue( 6),style: MyTextTheme.largeWCB.copyWith(
  //                                         fontSize: 31, color:  dark?   Colors.white:AppColor.black
  //                                     ),),
  //                                     Text(' mm/Hg',style:  MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black)),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text(localization.getLocaleData.sysDys.toString(),style: MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //                                     SizedBox(width: 15,),
  //                                     Text(getTimediff(rmdViewModal.getVitalTime( 4)).toString()+' ago' ,style: MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //                                   ],
  //                                 ),
  //
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(width: 10,),
  //
  //                           Expanded(flex: 4,
  //                             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(' ',style: MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black)),
  //
  //                                 Row(
  //                                   children: [
  //                                     Text( rmdViewModal.getValue(3).toString(),style: MyTextTheme.largeWCB.copyWith(
  //                                         fontSize: 31, color:  dark?   Colors.white:AppColor.black
  //                                     ),),
  //                                     Expanded(
  //                                       child: Row(
  //                                         children: [
  //                                           Expanded(child: Text('/min',style:  MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black),)),
  //                                           Text(getTimediff(rmdViewModal.getVitalTime( 3)).toString()+' ago',style:  MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 Text(localization.getLocaleData.pulse.toString(),style: MyTextTheme.mediumWCB.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //
  //                               ],
  //                             ),
  //                           ),
  //
  //                         ],
  //                       )
  //                       ),),
  //
  //                       const SizedBox(height: 15,),
  //                       Text("${localization.getLocaleData.todaysWaterPillsIntake}  ",style: MyTextTheme.largeWCB.copyWith( color:  dark?   Colors.white:AppColor.black),),
  //
  //                       const SizedBox(height: 10,),
  //                       Row(
  //                         children: [
  //
  //
  //                           Expanded(child:  InkWell(
  //                             onTap: () async {
  //
  //                               Get.until(  (route) =>  route.settings.name=='/RMDView');
  //
  //                               masterDashboardViewModal.updateSelectedPage = 'Fluid Management';
  //
  //                               await  masterDashboardViewModal.onSelectPage();
  //                               // Get.to(()=>const SliderVerticalWidget());
  //                             }, child:myContainer(child:Container(
  //                             height: 174,
  //                             child: Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           SvgPicture.asset('assets/waters.svg'),
  //                                           const SizedBox(width: 10,),
  //                                           Text(localization.getLocaleData.water.toString(),style:  MyTextTheme.smallWCN.copyWith(color:  dark?   Colors.white:AppColor.black),),
  //                                         ],
  //                                       ),
  //                                       const SizedBox(height: 15,),
  //
  //                                       Image.asset('assets/waters.png'),
  //                                       const SizedBox(height: 35,),
  //
  //                                       Text( rmdViewModal.getWaterIntake().toString()+'   ${localization.getLocaleData.liters}',style:themeChange.darkTheme?
  //                                       MyTextTheme.largeWCB:MyTextTheme.largeBCB
  //                                         ,),
  //                                       // Text(localization.getLocaleData.goals.toString()  +' 5 '+localization.getLocaleData.liters.toString(),style:MyTextTheme.mediumWCB.copyWith(color:  dark?   Colors.white:AppColor.black),),
  //
  //                                     ],
  //                                   ),
  //                                 ),
  //
  //
  //
  //                               ],
  //                             ),
  //                           )
  //                           ),
  //                           ),),
  //
  //                           const SizedBox(width: 15,),
  //
  //
  //                           Expanded(child:  InkWell(
  //                               onTap: () async {
  //
  //
  //                                 Get.until(  (route) =>  route.settings.name=='/RMDView');
  //
  //                                 masterDashboardViewModal.updateSelectedPage = 'Prescription Checklist';
  //
  //                                 await  masterDashboardViewModal.onSelectPage();
  //                                 // Get.to(()=>const PillsReminderView());
  //                               },   child: myContainer(child:Container(
  //                             height: 174,
  //                             child: Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           SvgPicture.asset('assets/pills.svg'),
  //                                           const SizedBox(width: 10,),
  //                                           Expanded(child: Text(localization.getLocaleData.pillsReminder.toString(),style: MyTextTheme.smallWCN.copyWith(color:  dark?   Colors.white:AppColor.black),)),
  //                                         ],
  //                                       ),
  //                                       const SizedBox(height: 5,),
  //                                       Text(localization.getLocaleData.taken.toString()+" "+'${rmdViewModal.getMediconecheck()}/ ${rmdViewModal.getMedNamesandDates.length}'+" "+localization.getLocaleData.missed.toString()+" "+'${rmdViewModal.getMediconeCount()}',style: MyTextTheme.smallWCB.copyWith(color:  dark?   Colors.white:AppColor.black),),
  //
  //                                       const SizedBox(height: 10,),
  //                                       Row(
  //                                         children: [
  //                                           Expanded(child: Text(rmdViewModal.getMedNamesandDates.isEmpty? '':rmdViewModal.getMedNamesandDates[rmdViewModal.currentIndex ].drugName.toString(),style: MyTextTheme.smallWCB.copyWith(color:  dark?   Colors.white:AppColor.black),)),
  //                                             ],
  //                                       ),
  //                                       //
  //                                       // Text(rmdViewModal.getMedNamesandDates.isEmpty? '':
  //                                       // rmdViewModal.getMedNamesandDates[rmdViewModal.currentIndex ].dosageForm??''.toString(),
  //                                       //   style:  MyTextTheme.smallBCN.copyWith(color: AppColor.green),),
  //                                       const SizedBox(height: 15,),
  //
  //                                       Row(
  //                                         children: [
  //                                           Expanded(
  //                                             child: Text(rmdViewModal.getMedNamesandDates.isEmpty? '':
  //                                             rmdViewModal.getMedNamesandDates[rmdViewModal.currentIndex ].dosageForm??''.toString(),
  //                                               style:  MyTextTheme.smallBCN.copyWith(color: AppColor.green),),
  //                                           ),
  //                                           // Expanded(child: Text(rmdViewModal.getMedNamesandDates.isEmpty? '':
  //                                           // rmdViewModal.getMedNamesandDates[rmdViewModal.currentIndex ].doseFrequency.toString()
  //                                           //     =='null'?'': (rmdViewModal.getMedNamesandDates[rmdViewModal.currentIndex ].
  //                                           // doseFrequency??'').toString(),style:  MyTextTheme.smallBCN.copyWith(color: AppColor.green),)),
  //
  //                                           InkWell(
  //                                             onTap: (){
  //                                               if(rmdViewModal.currentIndex >0){
  //                                                   rmdViewModal.updateCurrentIndex =
  //                                                       rmdViewModal.currentIndex - 1;
  //                                                 }
  //                                               },
  //                                             child: CircleAvatar(
  //                                               radius: 15,foregroundColor:(0==rmdViewModal.currentIndex)?
  //                                             AppColor.greyVeryVeryLight :AppColor.black,
  //                                               backgroundColor: (0==rmdViewModal.currentIndex)?
  //                                               AppColor.greyVeryVeryLight :AppColor.black,
  //                                               child:   Icon(Icons.arrow_back_ios,color: (0==rmdViewModal.currentIndex)?
  //                                               AppColor.black12:AppColor.white ,),
  //                                             ),
  //                                           ),
  //                                           const SizedBox(width: 15,),
  //
  //                                           InkWell(
  //                                             onTap: (){
  //                                               if((rmdViewModal.getMedNamesandDates.length-1)>rmdViewModal.currentIndex ){
  //                                                   rmdViewModal.updateCurrentIndex =
  //                                                       rmdViewModal.currentIndex + 1;
  //                                                 }
  //                                               },
  //                                             child: CircleAvatar(
  //                                               radius: 15,foregroundColor:((rmdViewModal.getMedNamesandDates.length-1)==rmdViewModal.currentIndex)?
  //                                             AppColor.greyVeryVeryLight :AppColor.black,
  //                                               backgroundColor: ((rmdViewModal.getMedNamesandDates.length-1)==rmdViewModal.currentIndex)?
  //                                                   AppColor.greyVeryVeryLight :AppColor.black,
  //                                               child:   Icon(Icons.arrow_forward_ios_sharp,color: ((rmdViewModal.getMedNamesandDates.length-1)==rmdViewModal.currentIndex)?
  //                                               AppColor.black12:AppColor.white ,),
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //
  //                                     ],
  //                                   ),
  //                                 ),
  //
  //
  //
  //                               ],
  //                             ),
  //                           ))
  //                           ),),
  //                         ],
  //                       )
  //
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //   ),
  //                   Container(
  //                     decoration: BoxDecoration(
  //
  //                       // color: color.indicatorColor,
  //                       // gradient:LinearGradient(
  //                       //   colors: [
  //                       //     color.shadowColor,
  //                       //     color.indicatorColor
  //                       //   ],
  //                       //   begin: Alignment.topCenter,
  //                       //   end: Alignment.bottomCenter,
  //                       // ),
  //                       //   boxShadow: [
  //                       //     BoxShadow(
  //                       //         color: themeChange.darkTheme
  //                       //             ? AppColor.neoBGGrey2
  //                       //             : AppColor.white,
  //                       //         blurRadius: 21,
  //                       //         offset: const Offset(10, 0),
  //                       //         spreadRadius: 10)
  //                       //   ]
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         InkWell(
  //                           onTap: () async {
  //                             selectEmergencyType(context);
  //
  //                             // String morningTime='';
  //                             //           morningTime= await dashboardVM.callTiming();
  //                             //           print('nnnnnnnvnnnv'+morningTime.toString());
  //                             //
  //                             //           if(int.parse(morningTime.toString())>=0 && int.parse(morningTime.toString())<=960){
  //                             //
  //                             //             UrlLauncher.launch('tel: 8652445262');
  //                             //           }else{
  //                             //
  //                             //             UrlLauncher.launch('tel: ${userRepository.getAppDetails.eraEmergencyContactNumber.toString()}');
  //                             //           }
  //                           },
  //                           child: Column(
  //                             children: [
  //                               Image.asset(themeChange.darkTheme
  //                                   ? 'assets/darkm_patient/sos.png'
  //                                   : "assets/lightm_patient/sos.png"),
  //                               const SizedBox(
  //                                 height: 5,
  //                               ),
  //                               Text(localization.getLocaleData.SOS.toString(),
  //                                   style: MyTextTheme.mediumGCN.copyWith(
  //                                       color: themeChange.darkTheme
  //                                           ? Colors.grey.shade400
  //                                           : AppColor.greyDark))
  //                             ],
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             aiCommandSheet(context);
  //                           },
  //                           child: customContainerButton2(),
  //                         ),
  //                         InkWell(
  //                           onTap: () async {
  //                             // Get.offAll(RMDView());
  //
  //                             Get.until(  (route) =>  route.settings.name=='/RMDView');
  //                             masterDashboardViewModal.updateSelectedPage =
  //                             'Chat';
  //                             await  masterDashboardViewModal.onSelectPage();
  //                           },
  //                           child: Column(
  //                             children: [
  //                               SvgPicture.asset('assets/colorful2/chatdashboard.svg',height: 35,),
  //                               const SizedBox(
  //                                 height: 5,
  //                               ),
  //                               Text(localization.getLocaleData.chat.toString(),
  //                                   style: MyTextTheme.mediumGCN.copyWith(
  //                                       color: themeChange.darkTheme
  //                                           ? Colors.grey.shade400
  //                                           : AppColor.greyDark)),
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ));
  // }



  customContainerWidget({height, width, child}) {
    // final color=style.themeData(themeChange.darkTheme, context);
    return Consumer<ThemeProviderLd>(builder: (BuildContext context, themeChange, _) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: themeChange .darkTheme ? VitalioColors.bgDark2 : VitalioColors.primaryBlueLight,
          borderRadius: BorderRadius.circular(10),
        ),
        height: height,
        width: width,
        child: child,
      );
    });
  }
  customContainerButton2() {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Consumer<ThemeProviderLd>(builder: (BuildContext context, value, _) {
      return Container(
          // decoration:  BoxDecoration(
          //     boxShadow: [
          //       BoxShadow(color: themeChange.darkTheme == true
          //           ?AppColor.darkshadowColor1:AppColor.lightshadowColor2,blurRadius: 30,offset: const Offset(0,10))
          //     ]
          // ),

          height:120,
          width: 120,
          child: Image.asset(themeChange.darkTheme == true
              ?'assets/micdark2.png':'assets/miclight2.png',height: 74,));
    });
  }


  aiCommandSheet(context, { String? isFrom}) {

    AddVitalViewModal addvitalVM =
    Provider.of<AddVitalViewModal>(context, listen: false);
    addvitalVM.pauseFunc=false;

    showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      barrierColor: Colors.black54,
      //background color for modal bottom screen
      backgroundColor: Colors.transparent,
      //elevates modal bottom screen
      elevation: 10,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      builder: (BuildContext context) {
        return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(height: 350, child: VoiceAssistant(isFrom:isFrom)),
        );
      },
    );
  }

  // medtype({title}){
  //   if(checkDurationType(duration) == false){
  //     return const Center(child: Text("--",textAlign: TextAlign.center,));
  //   }
  //   else{
  //     if(title.toString()=='check' ){
  //       updateCheckIcon='check';
  //     }
  //     else  if(title.toString()=='exclamation'){
  //       updateMissedIcon='missed';
  //     }
  //     else if(title.toString()=='late'){
  //       lateIcon='late';
  //     }
  //     else if(title.toString()=='SOS'){
  //       UpdateSOSicon='SOS';
  //     }
  //     else{
  //       setUpcomingIcon='upcoming';
  //     }
  //
  //   }

  selectEmergencyType(
      context,
      ) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

    RMDViewModal rmdViewModal =
    Provider.of<RMDViewModal>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    final color = style.themeData(themeChange.darkTheme, context);
    return CustomBottomSheet.open(context,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    themeChange.darkTheme == true
                        ? AppColor.neoBGGrey2
                        : AppColor.neoBGWhite1,
                    themeChange.darkTheme == true
                        ? AppColor.neoBGGrey2
                        : AppColor.neoBGWhite2,
                    themeChange.darkTheme == true
                        ? AppColor.neoBGGrey2
                        : AppColor.neoBGWhite1,
                    themeChange.darkTheme == true
                        ? AppColor.neoBGGrey1
                        : AppColor.neoBGWhite1,
                    themeChange.darkTheme == true
                        ? AppColor.neoBGGrey1
                        : AppColor.neoBGWhite1,
                  ])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      localization.getLocaleData.selectEmergencyNumber.toString(),
                      style: MyTextTheme.largeGCN.copyWith(
                          color: themeChange.darkTheme == true
                              ? Colors.white70
                              : Colors.grey.shade700),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColor.darkshadowColor1,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: AppColor.lightshadowColor2,
                height: 2,
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  String morningTime = '';
                  morningTime = rmdViewModal.callTiming();
                  print('nnnnnnnvnnnv$morningTime');

                  if (int.parse(morningTime.toString()) >= 0 &&
                      int.parse(morningTime.toString()) <= 960) {
                    UrlLauncher.launch('tel: 8652445262');
                  } else {
                    // UrlLauncher.launch(
                    //     'tel: ${userRepository.getAppDetails.eraEmergencyContactNumber.toString()}');
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: themeChange.darkTheme == true
                            ? Colors.grey.shade800
                            : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          themeChange.darkTheme
                              ? AppColor.neoBGGrey1
                              : Colors.white,
                          themeChange.darkTheme
                              ? AppColor.neoBGGrey1
                              : Colors.white,
                          themeChange.darkTheme
                              ? AppColor.neoBGGrey2
                              : Colors.grey.shade300,
                          // themeChange.darkTheme? AppColor.neoBGGrey2:Colors.white,
                          // style.themeData(value.darkTheme, context).focusColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: themeChange.darkTheme == true
                                ? Colors.transparent
                                : Colors.grey.shade300,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                            spreadRadius: 2),
                      ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localization.getLocaleData.callTollFreeNo.toString()
                          ,
                          style: MyTextTheme.largeGCB.copyWith(
                              color: themeChange.darkTheme
                                  ? Colors.grey.shade400
                                  : AppColor.greyDark,
                              fontSize: 16),
                        ),
                        Text("1800XX2XX25",
                            style: MyTextTheme.largeGCB
                                .copyWith(color: AppColor.darkgreen))
                      ]),
                ),
              ),
              SizedBox(
                height: 2,
              ),

              // InkWell(
              //   onTap: () {
              //     Get.back();
              //     ambulanceBottomSheet(context);
              //     Future.delayed(Duration(seconds: 3)).then((value) =>
              //         MyNavigator.pushReplacement(
              //             context, CallForAmbulanceView()));
              //   },
              //   child: Container(
              //     height: 50,
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //           color: themeChange.darkTheme == true
              //               ? Colors.grey.shade800
              //               : Colors.grey.shade400,
              //         ),
              //         borderRadius: BorderRadius.circular(10),
              //         gradient: LinearGradient(
              //           colors: [
              //             themeChange.darkTheme
              //                 ? AppColor.neoBGGrey1
              //                 : Colors.white,
              //             themeChange.darkTheme
              //                 ? AppColor.neoBGGrey1
              //                 : Colors.white,
              //             themeChange.darkTheme
              //                 ? AppColor.neoBGGrey2
              //                 : Colors.grey.shade300,
              //             // themeChange.darkTheme? AppColor.neoBGGrey2:Colors.white,
              //             // style.themeData(value.darkTheme, context).focusColor,
              //           ],
              //           begin: Alignment.topCenter,
              //           end: Alignment.bottomCenter,
              //         ),
              //         boxShadow: [
              //           BoxShadow(
              //               color: themeChange.darkTheme == true
              //                   ? Colors.transparent
              //                   : Colors.grey.shade300,
              //               blurRadius: 5,
              //               offset: const Offset(0, 5),
              //               spreadRadius: 2),
              //         ]),
              //     child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             "Call For Ambulance",
              //             style: MyTextTheme.largeGCB.copyWith(
              //                 color: themeChange.darkTheme
              //                     ? Colors.grey.shade400
              //                     : AppColor.greyDark,
              //                 fontSize: 16),
              //           ),
              //           // Text(userRepository.getAppDetails.eraEmergencyContactNumber.toString())
              //         ]),
              //   ),
              // )
            ]),
          ),
        ));
  }


  customContainerButton() {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Consumer<ThemeProviderLd>(builder: (BuildContext context, value, _) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: style.themeData(value.darkTheme, context).primaryColor,
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(101),
            gradient: LinearGradient(
              colors: [
                themeChange.darkTheme ? AppColor.neoBGGrey2 : AppColor.white,
                themeChange.darkTheme
                    ? AppColor.neoBGGrey2
                    : AppColor.neoBGWhite2,
                themeChange.darkTheme
                    ? AppColor.neoBGGrey2
                    : AppColor.neoBGWhite2,
                themeChange.darkTheme
                    ? AppColor.neoBGGrey2
                    : Colors.grey.shade700,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                  color: themeChange.darkTheme
                      ? Colors.black87
                      : Colors.grey.shade400,
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                  spreadRadius: 7)
            ]),
        height: 101,
        width: 101,
        child: Container(
          decoration: BoxDecoration(
            // color:style.themeData(value.darkTheme, context).backgroundColor,
            // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(101),
              gradient: LinearGradient(
                colors: [
                  themeChange.darkTheme
                      ? AppColor.neoBGGrey1
                      : AppColor.neoBGWhite1,
                  themeChange.darkTheme
                      ? AppColor.neoBGGrey2
                      : AppColor.neoBGWhite2,
                  themeChange.darkTheme
                      ? AppColor.neoBGGrey2
                      : Colors.grey.shade500,
                  themeChange.darkTheme
                      ? AppColor.neoBGGrey2
                      : Colors.grey.shade700,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                    color: themeChange.darkTheme == false
                        ? Colors.grey.shade600
                        : style.themeData(value.darkTheme, context).focusColor,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                    spreadRadius: 2)
              ]),
          height: 81,
          width: 81,
          alignment: Alignment.center,
          child: Image.asset(
            themeChange.darkTheme
                ? "assets/darkm_patient/mic.png"
                : 'assets/lightm_patient/mic.png',
            width: 40,
            height: 40,
          ),
        ),
      );
    });
  }

VitalWidget({img,title, value,unit, vitalDateTime}){
   var differenceInMinutes=getTimediff(vitalDateTime);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return  InkWell(
      onTap: (){

        Get.to(()=>const AddVitalView());
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(img),
              const SizedBox(width: 10,),
              Text(title.toString(),style:MyTextTheme.smallWCN.copyWith(color:  themeChange.darkTheme?   Colors.white:AppColor.black),),
            ],
          ),

          Row(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value.toString(), style: MyTextTheme.largeWCB.copyWith(
                  fontSize: 31,color:themeChange.darkTheme?
                  Colors.white:AppColor.black
              ),),
              Expanded(child: Text(unit.toString(),style:  MyTextTheme.mediumWCB.copyWith(color:  themeChange.darkTheme?   Colors.white:AppColor.black),)),
              Text(differenceInMinutes.toString()+' ago',style: MyTextTheme.mediumWCB.copyWith( color:themeChange.darkTheme?   Colors.white:AppColor.black),),
            ],
          ),

        ],
      ),
    );
}
getTimediff(vitalDateTime){
  String differenceInMinutes='';
  if(vitalDateTime!=''){
    DateTime targetDateTime = DateTime.parse(vitalDateTime);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the difference between the current time and the specific datetime
    Duration difference = now.difference(targetDateTime);
setState(() {

});
    // Convert the difference to minutes
    int data = (difference.inMinutes) ;
    if(data<60){
      differenceInMinutes='$data Min';
    }
    else if(data>=60){
      int data2 = (difference.inHours) ;
      differenceInMinutes='$data2 Hr';
    }
  }
  return differenceInMinutes;
}

  myContainer({child, vitalDateTime }){
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);


    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: themeChange.darkTheme ? AppColor.black12:Colors.white,
        borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: themeChange.darkTheme ?Colors.transparent :Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 0),
                spreadRadius: 5)
          ]
      ),
      child: child,
    );
  }
}
