
import 'package:animate_do/animate_do.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/LiveVital/pmd/app_color.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/View/Pages/exercise_tracking_view.dart';
import 'package:medvantage_patient/View/Pages/upload_report_view.dart';
import 'package:medvantage_patient/View/Pages/settingPopup.dart';
import 'package:medvantage_patient/View/Pages/supplement_intake_view.dart';
import 'package:medvantage_patient/View/Pages/urin_output.dart';
import 'package:medvantage_patient/View/widget/dashboard_grid_list.dart';
import 'package:medvantage_patient/ViewModal/dashboard_view_modal.dart';
import 'package:medvantage_patient/ViewModal/drawer_view_modal.dart';
import 'package:medvantage_patient/ViewModal/login_view_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/neomorphic/theme_provider.dart';
import 'package:medvantage_patient/theme/theme.dart';
import '../../Localization/app_localization.dart';
import '../../Localization/language_change_widget.dart';
import '../../ViewModal/MasterDashoboardViewModal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/navigator.dart';
import '../../app_manager/services/check_for_update.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/common_libs.dart';
import '../../assets.dart';
import '../../authenticaton/user_repository.dart';
import '../../voice_assistant.dart';
import 'call_ambulance_view.dart';
import 'chat_view.dart';
import 'lifestyle_interventions_view.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../../theme/style.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var callTime = 0;

  get(context) async {
    MasterDashboardViewModal drawermenulistVm =
        Provider.of<MasterDashboardViewModal>(context, listen: false);

    DashboardViewModal dashboardVM =
        Provider.of<DashboardViewModal>(context, listen: false);

    LoginViewModal loginViewModal =
        Provider.of<LoginViewModal>(context, listen: false);
    await dashboardVM.GetClient(context);
    await loginViewModal.saveDeviceToken(context);

    // await drawermenulistVm.getMenuForApp(context);

    await dashboardVM.patientDashboard(context);
    await dashboardVM.bannerImg(context);


    var myData = await dashboardVM.callTiming();
    setState(() {
      callTime = int.parse(myData.toString());
    });

    print('nnnnnn $callTime');

    if (int.parse(callTime.toString()) >= 0 &&
        int.parse(callTime.toString()) <= 960) {
      dashboardVM.updateIsMorningTime = true;
    }
  }

  late ScrollController controller;
  bool fabIsVisible = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      get(context);

      Updater().checkVersion(context);
    });

    print('nnnnnnnnnnnnvnnnv');
    super.initState();
  }

  String dropdownValue = 'Lucknow';

  @override
  void dispose() {
    super.dispose();
  }

  final options = const LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 1),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 500),

    // Animation duration (default 250)
    showItemDuration: Duration(seconds: 1),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );



  bool shadowLight=false;

  @override
  Widget build(BuildContext context) {

    MasterDashboardViewModal masterDashboardViewModal =
        Provider.of<MasterDashboardViewModal>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChange.darkTheme, context);
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);
    DashboardViewModal dashboardVM =
        Provider.of<DashboardViewModal>(context, listen: true);

    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: true);
    List upperList = [
      {'title': localization.getLocaleData.symptomTracker, 'img': 'symptomstracker.svg', 'navigation':'Symptoms Tracker'},
      {'title': localization.getLocaleData.VitalManagement, 'img': 'vitalmanagemnt.svg' ,  'navigation':'Vital Management'},
      {'title': localization.getLocaleData.FluidManagement, 'img': 'fluidmanagement.svg', 'navigation':'Fluid Management'},
      {'title': localization.getLocaleData.PrescriptionChecklist, 'img': 'prescriptionchecklist.svg', 'navigation':'Prescription Checklist'},
      // {'title': localization.getLocaleData.dietChecklist, 'img': 'grid5.png', 'navigation':'Diet Checklist'},
      {'title': localization.getLocaleData.SupplementChecklist, 'img': 'supplimentchecklist.svg', 'navigation':'Supplement Checklist'},
    ];

    List other = [
    {'title': localization.getLocaleData.UploadReport, 'img': 'uploadreport.svg','navigation':'Upload Report'},
    {
    'title':localization.getLocaleData.LifestyleInterventions,
    'img': 'lifestyle.svg',
      'navigation':'Lifestyle Interventions'
    },
    ];


    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          drawer: const MyDrawer(),
          body:  WillPopScope(
            onWillPop: () async {
              // changeQtyAlert2();
              return Future.value(false);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                    themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                    themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                    themeChange.darkTheme ? AppColor.bgDark : AppColor.neoBGWhite2,
                    themeChange.darkTheme ? AppColor.bgDark : AppColor.neoBGWhite2,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                scaffoldKey.currentState!.openDrawer();
                                // masterDashboardViewModal.onPressOpenDrawer();
                              },
                              child: themeChange.darkTheme
                                  ? Image.asset(
                                'assets/lightm_patient/drawer.png',
                              )
                                  : Image.asset(
                                'assets/darkm_patient/drawer.png',
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text( dashboardVM.getClintDetails.clientName.toString(),
                              style: MyTextTheme.mediumGCN.copyWith(
                                  fontSize: 16,
                                  color: themeChange.darkTheme
                                      ? AppColor.white.withOpacity(.6)
                                      : AppColor.greyDark,
                                  fontWeight: FontWeight.w700
                                // color: color.primaryTextTheme.headline1!.color
                              ),
                            ),
                          ),
                          // InkWell(
                          //     onTap: () {
                          //       changeLanguage();
                          //     },
                          //     child: themeChange.darkTheme
                          //         ? Image.asset(
                          //             'assets/lightm_patient/noti.png',
                          //           )
                          //         : Image.asset(
                          //             'assets/darkm_patient/noti.png',
                          //           ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
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
                                          masterDashboardViewModal.updateSelectedPage =
                                              upperList[index]['navigation']
                                                  .toString()
                                                  .replaceAll('\n', '');
                                          await  masterDashboardViewModal.onSelectPage();
                                          // masterDashboardViewModal.updateSelectedPage =
                                          //     upperList[index]['title']
                                          //         .toString()
                                          //         .replaceAll('\n', '');
                                        },
                                        child: customContainerWidget(
                                          height: 115.0,
                                          width: 150.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                themeChange.darkTheme
                                                    ? "assets/colorful2/${upperList[index]['img']}"
                                                    : "assets/colorful2/${upperList[index]['img']}",
                                                height: 50,
                                                // color: themeChange.darkTheme?AppColor.white.withOpacity(.7):AppColor.grey,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                upperList[index]['title'].toString(),
                                                textAlign: TextAlign.center,
                                                style: MyTextTheme.mediumWCN.copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeChange.darkTheme
                                                        ? AppColor.grey
                                                        : AppColor.greyDark
                                                            .withOpacity(.7)),
                                              )
                                            ],
                                          ),
                                        ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Text(
                               localization.getLocaleData.other.toString()
                                ,
                                style: MyTextTheme.mediumBCN.copyWith(
                                    fontWeight: FontWeight.w700, color: AppColor.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StaggeredGrid.extent(
                                maxCrossAxisExtent: 301,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                children: List.generate(
                                    other.length,
                                    (index) => InkWell(
                                        onTap: () async {
                                          Get.until(  (route) =>  route.settings.name=='/RMDView');
                                          masterDashboardViewModal.updateSelectedPage =
                                              other[index]['navigation']
                                                  .toString()
                                                  .replaceAll('\n', '');
                                          await  masterDashboardViewModal.onSelectPage();
                                        },
                                        child: customContainerWidget(
                                          width: 150.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset("assets/colorful2/${other[index]['img']}",height: 40,width: 40,),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Text(
                                                    other[index]['title'].toString(),
                                                    style: MyTextTheme.mediumGCN.copyWith(
                                                        fontSize: 13,
                                                        color: AppColor.grey)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))),
                              ),
                            ),
                            SizedBox(height: 15,),
                            // (dashboardVM.getNewBannerList??[]).isEmpty?SizedBox():
                            // Container(
                            //   child: CarouselSlider(
                            //     options: CarouselOptions(
                            //         autoPlay: true,
                            //         autoPlayAnimationDuration: const Duration(seconds: 1),
                            //         aspectRatio: 16 / 11,
                            //         height: 153.0,
                            //         enlargeCenterPage: true),
                            //     items: ( dashboardVM.getNewBannerList ?? []).map((snapShot) {
                            //       return Builder(
                            //         builder: (BuildContext context) {
                            //           return Container(
                            //             height: MediaQuery.of(context).size.height,
                            //             width: MediaQuery.of(context).size.width,
                            //             decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.circular(15),
                            //             ),
                            //             child: CachedNetworkImage(
                            //               // imageUrl:snapShot.photoReference.toString(),
                            //               imageUrl:snapShot['path'].toString(),
                            //               imageBuilder: (context, imageProvider) => Container(
                            //                 decoration: BoxDecoration(
                            //                   borderRadius: BorderRadius.circular(10),
                            //                   image: DecorationImage(
                            //                     image: imageProvider,
                            //                     fit: BoxFit.cover,
                            //                   ),
                            //                 ),
                            //               ),
                            //               placeholder: (context, url) => Container(
                            //                 decoration: BoxDecoration(
                            //                   borderRadius: BorderRadius.circular(10),
                            //                 ),
                            //                 child: Icon(Icons.image_not_supported,color: Colors.green,) ,
                            //               ),
                            //               errorWidget: (context, url, error) => Container(
                            //                   decoration: BoxDecoration(
                            //                     borderRadius: BorderRadius.circular(10),
                            //                   ),
                            //                   child: Icon(Icons.image_not_supported,color: Colors.green)),
                            //             ),
                            //           );
                            //         },
                            //       );
                            //     }).toList(),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ), 
                    // ImageSlider(
                    //     sliderImagesList: dashboardVM.getNewBannerList,
                    //     keyName: 'path',
                    //     onImageChanged: dashboardVM.onImageChanged),
                    // Container(
                    //   height: 60,
                    //   decoration: BoxDecoration(
                    //       // color: AppColor.greyLight,
                    //       // gradient:LinearGradient(
                    //       //   colors: [
                    //       //     Colors.white,
                    //       //     Colors.grey.shade300,
                    //       //   ],
                    //       //   begin: Alignment.topCenter,
                    //       //   end: Alignment.bottomCenter,
                    //       // ),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             color: AppColor.greyLight,
                    //             blurRadius: 60,offset: Offset(0,-35),
                    //             spreadRadius: 35
                    //         )
                    //       ]
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(

                       // color: color.indicatorColor,
                        // gradient:LinearGradient(
                        //   colors: [
                        //     color.shadowColor,
                        //     color.indicatorColor
                        //   ],
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        // ),
                        boxShadow: [
                          BoxShadow(
                              color: themeChange.darkTheme
                                  ? AppColor.neoBGGrey2
                                  : AppColor.white,
                              blurRadius: 21,
                              offset: const Offset(10, 0),
                              spreadRadius: 10)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                          child: Column(
                            children: [
                              Image.asset(themeChange.darkTheme
                                  ? 'assets/darkm_patient/sos.png'
                                  : "assets/lightm_patient/sos.png"),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(localization.getLocaleData.SOS.toString(),
                                  style: MyTextTheme.mediumGCN.copyWith(
                                      color: themeChange.darkTheme
                                          ? Colors.grey.shade400
                                          : AppColor.greyDark))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            aiCommandSheet(context);
                          },
                          child: customContainerButton2(),
                        ),
                        InkWell(
                          onTap: () async {
                             Get.offAll(DashboardView());
                            masterDashboardViewModal.updateSelectedPage =
                            'Chat';
                            await  masterDashboardViewModal.onSelectPage();
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset('assets/colorful2/chatdashboard.svg'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(localization.getLocaleData.chat.toString(),
                                  style: MyTextTheme.mediumGCN.copyWith(
                                      color: themeChange.darkTheme
                                          ? Colors.grey.shade400
                                          : AppColor.greyDark)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // )
                ],
                              ),
              ),
          ),
        ),
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
  customContainerButton2() {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Consumer<ThemeProviderLd>(builder: (BuildContext context, value, _) {
      return Container(
        decoration:  BoxDecoration(
          boxShadow: [
            BoxShadow(color: themeChange.darkTheme == true
                ?AppColor.darkshadowColor1:AppColor.lightshadowColor2,blurRadius: 30,offset: const Offset(0,10))
          ]
        ),

        height:120,
          width: 120,
          child: Image.asset(themeChange.darkTheme == true
              ?'assets/micdark.png':'assets/micLight.png'));
    });
  }

  customContainerWidget({height, width, child}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // final color=style.themeData(themeChange.darkTheme, context);
    return Consumer<ThemeProviderLd>(builder: (BuildContext context, value, _) {
      return Container(
        decoration: BoxDecoration(
            color: themeChange.darkTheme == true
                ?AppColor.cardDark:Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: themeChange.darkTheme == true
                      ? Colors.transparent
                      : Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                  spreadRadius: 2),
            ]),
        height: height,
        width: width,
        child: child,
      );
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     ApplicationLocalizations localization =
//     Provider.of<ApplicationLocalizations>(context, listen: false);
//     DashboardViewModal dashboardVM =
//         Provider.of<DashboardViewModal>(context, listen: true);
//
//     UserRepository userRepository =
//     Provider.of<UserRepository>(context, listen: true);
//
//     final themeProvider = Provider.of<ThemeProviderLd>(context, listen: true);
//     return ColoredSafeArea(
//       child: Scaffold(
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: SizedBox(
//           height: 80,
//           width: 70,
//           child: FloatingActionButton(
//             backgroundColor: Colors.blue.shade800,
//             onPressed: () {
//               aiCommandSheet(context);
//             },
//             child: const Icon(
//               Icons.mic_none_rounded,
//               size: 45,
//             ),
//           ),
//         ),
//         backgroundColor: AppColor.white,
//         key: scaffoldKey,
//         drawer: const MyDrawer(),
//         body: Container(
//           color: AppColor.white,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   IconButton(
//                     splashRadius: 30,
//                     onPressed: () {
//                       scaffoldKey.currentState!.openDrawer();
//                     },
//                     icon: Icon(
//                       Icons.menu,
//                       color: AppColor.grey,
//                     ),
//                   ),
//                   const Expanded(
//                     child: SizedBox(
//                       width: 10,
//                     ),
//                   ),
//                   // InkWell(
//                   //   onTap: () {
//                   //  //   aler
//                   //  //    MyNavigator.push(context, PatientCounsellingView());
//                   //     UrlLauncher.launch('tel: 9651965186');
//                   //   },
//                   //   child: const Padding(
//                   //     padding: EdgeInsets.only(right: 8.0),
//                   //     child: Icon(Icons.call)
//                   //   ),
//                   // ),
//
//                   InkWell(
//                     onTap: () {
//                       changeLanguage();
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.language,
//                         size: 28,
//                         color: AppColor.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
// // ---------------  Start  Upper Dashboard ------------------
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 localization.getLocaleData.smartHeartFailureClinic.toString(),
//                                 style: MyTextTheme.mediumGCB.copyWith(
//                                     fontSize: 20,
//                                     color: AppColor.primaryColor),
//                               ),
//                               //SizedBox(
//                               // const Text(
//                               //     "Experience the power of Healing Us."),
//                               // Container(
//                               //    padding: const EdgeInsets.only(top: 12),
//                               //   child:
//                               //     Image.asset("assets/new_dashboard_images/Infographic.png")
//                               // ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               // ImageSlider(
//                               //     sliderImagesList: dashboardVM.getNewBannerList,
//                               //     keyName: 'path',
//                               //     onImageChanged: dashboardVM.onImageChanged),
//                               SizedBox(
//                                 height: 5,
//                               ),
//
//                             ],
//                           ),
//                         ),
//                         Column(
//                           children: [
// // --------------- Start Dashboard Grid List  -----------------------
//                             Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                                 child: DashboardGridList(
//                                   gridList:
//                                       dashboardVM.dashboardGrid(context),
//                                   onTapEvent: dashboardVM.onPressedGridOpt,
//                                 )),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         // supplimentWidget(),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         LifetyleAndCallWidget(),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         LifetyleAndCallWidget2(),
//                         const SizedBox(height: 10,),
//
//                         Visibility(
//                           visible:(int.parse(callTime.toString())>=0 && int.parse(callTime.toString())<=960) ||
//                               userRepository.getAppDetails.emergencyContactNumber!='',
//                           child: Center(
//                             child: SizedBox(
//                               width: 250,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//                                 decoration: BoxDecoration(
//                                   color: AppColor.secondaryColor,
//                                   borderRadius: BorderRadius.circular(35)
//                                 ),
//                                 child: InkWell(
//                                   onTap: () async {
//                                     String morningTime='';
//                                     morningTime= await dashboardVM.callTiming();
//                                     print('nnnnnnnvnnnv'+morningTime.toString());
//
//                                     if(int.parse(morningTime.toString())>=0 && int.parse(morningTime.toString())<=960){
//
//                                       UrlLauncher.launch('tel: 8652445262');
//                                     }else{
//
//                                       UrlLauncher.launch('tel: ${userRepository.getAppDetails.eraEmergencyContactNumber.toString()}');
//                                     }
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//
//                                       Icon(Icons.phone,color: AppColor.white,),
//                                       const SizedBox(width: 15,),
//                                       Text(localization.getLocaleData.emergencyCall.toString(),style: MyTextTheme.mediumWCB,)
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         Visibility(
//                           visible:!(int.parse(callTime.toString())>=0 && int.parse(callTime.toString())<=960) &&
//                               userRepository.getAppDetails.eraEmergencyContactNumber!='',
//                           child: Center(
//                             child: SizedBox(
//                               width: 250,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//                                 decoration: BoxDecoration(
//                                     color: AppColor.secondaryColor,
//                                     borderRadius: BorderRadius.circular(35)
//                                 ),
//                                 child: InkWell(
//                                   onTap: () async {
//                                     String morningTime='';
//                                     morningTime= await dashboardVM.callTiming();
//                                     print('nnnnnnnvnnnv'+morningTime.toString());
//
//                                     if(int.parse(morningTime.toString())>=0 && int.parse(morningTime.toString())<=960){
//
//                                       UrlLauncher.launch('tel: 8652445262');
//                                     }else{
//
//                                       UrlLauncher.launch('tel: ${userRepository.getAppDetails.eraEmergencyContactNumber.toString()}');
//                                     }
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//
//                                       Icon(Icons.phone,color: AppColor.white,),
//                                       const SizedBox(width: 15,),
//                                       Text('Emergency Call 24*7',style: MyTextTheme.mediumWCB,)
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 150,),
//                       ]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   supplimentWidget() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: InkWell(
//               onTap: () {
//                 MyNavigator.push(context, SupplementIntakeView());
//               },
//               child: Container(
//                 height: 65,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: AppColor.lightskyblue,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         color: AppColor.white,
//                         child: Image.asset(
//                           ImagePaths.suppleChecklist.toString(),
//                           height: 38,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                           child: Text(
//                             "Supplement Checklist",
//                             style: MyTextTheme.mediumGCB,
//                           ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () {
//                 MyNavigator.push(context, ExerciseTrackingView());
//                //Alert.show('Coming soon');
//               },
//               child: Container(
//                 height: 65,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: AppColor.verylightPink,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         color: AppColor.white,
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           color: AppColor.white,
//                           child: Image.asset(
//                             "assets/new_dashboard_images/lifestyle_interventaions.png",
//                             height: 38,
//                             fit: BoxFit.fitHeight,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                           child: Text(
//                             "Exercise Tracker",
//                             style: MyTextTheme.mediumGCB,
//                           ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   LifetyleAndCallWidget() {
//     ApplicationLocalizations localization =
//     Provider.of<ApplicationLocalizations>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//       child: Row(
//         children: [
//
//           Expanded(
//             child: InkWell(
//               onTap: () {
//               //  Alert.show('Coming Soon');
//                MyNavigator.push(context, ReportTrackingView());
//               },
//               child: Container(
//                 height: 65,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: AppColor.verylightPink,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         color: AppColor.white,
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           color: AppColor.white,
//                           child: Image.asset(
//                             "assets/new_dashboard_images/lifestyle_interventaions.png",
//                             height: 38,
//                             fit: BoxFit.fitHeight,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                           child: Text(
//                             localization.getLocaleData.uploadReport.toString(),
//                             style: MyTextTheme.mediumGCB,
//                           ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () {
//                 MyNavigator.push(context, LifeStyleInterventions());
//               },
//               child: Container(
//                 height: 65,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: AppColor.lightskyblue,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         color: AppColor.white,
//                         child: Image.asset(
//                           "assets/new_dashboard_images/lifestyle_interventaions.png",
//                           height: 38,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                           child: Text(
//                         localization.getLocaleData.lifestyleInterventions.toString(),
//                         style: MyTextTheme.mediumGCB,
//                       ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   LifetyleAndCallWidget2() {
//     ApplicationLocalizations localization =
//     Provider.of<ApplicationLocalizations>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: InkWell(
//               onTap: () {
//                 Alert.show(localization.getLocaleData.comingSoon.toString());
//               },
//               child: Container(
//                 height: 65,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: AppColor.lightskyblue,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         color: AppColor.white,
//                         child: Image.asset(
//                           "assets/FAQs.png",
//                           height: 38,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                           child: Text(
//                         localization.getLocaleData.fAndQ.toString(),
//                         style: MyTextTheme.mediumGCB,
//                       ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () {
//                 MyNavigator.push(context, const ChatView());
//               },
//               child: Container(
//                 height: 65,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: AppColor.verylightPink,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Row(
//                     children: [
//
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         color: AppColor.white,
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           color: AppColor.white,
//                           child: Image.asset(
//                             "assets/chat.png",
//                             height: 38,
//                             fit: BoxFit.fitHeight,
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(
//                         width: 15,
//                       ),
//
//                       Expanded(
//                           child: Text(
//                         localization.getLocaleData.chat.toString(),
//                         style: MyTextTheme.mediumGCB,
//                       ))
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
  changeLanguage() {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(localization.getLocaleData.changeLanguage.toString()),
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LanguageChangeWidget(),
                  ],
                ),
                Positioned(
                  top: -70,
                  right: -15,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 18.0,
                        backgroundColor: AppColor.white,
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  selectEmergencyType(
    context,
  ) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    MasterDashboardViewModal masterDashboardViewModal =
        Provider.of<MasterDashboardViewModal>(context, listen: false);
    DashboardViewModal dashboardVM =
        Provider.of<DashboardViewModal>(context, listen: false);
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
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
                  morningTime = dashboardVM.callTiming();
                  print('nnnnnnnvnnnv' + morningTime.toString());

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

  ambulanceBottomSheet(context) {
    return (CustomBottomSheet.open(context,
        isZeroPadding: true,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 60),
          child: Stack(clipBehavior: Clip.none, children: [
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                color: Colors.grey.shade200,
                height: 180.0,
              ),
            ),
            Positioned(
              top: -50,
              right: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Image.asset(
                        "assets/ambulance.gif",
                        height: 80,
                      ),
                    ),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColor.green12,
                            AppColor.darkgreen,
                            AppColor.darkgreen
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.darkgreen,
                            offset: const Offset(
                              2.0,
                              2.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 1,
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sending alerts to associated Hospitals for",
                    style: MyTextTheme.mediumGCB
                        .copyWith(fontSize: 16, color: AppColor.grey),
                  ),
                  Text(
                    "Ambulance...",
                    style: MyTextTheme.mediumGCN.copyWith(
                      fontSize: 26,
                      color: AppColor.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Cancel",
                    style: MyTextTheme.mediumGCB
                        .copyWith(fontSize: 16, color: AppColor.grey),
                  ),
                ],
              ),
            ),
          ]),
        )));
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double curveHeight = 40.0;
    Offset controlPoint = Offset(size.width / 2, -curveHeight);
    Offset endPoint = Offset(size.width, curveHeight);

    Path path = Path()
      ..lineTo(0, curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
