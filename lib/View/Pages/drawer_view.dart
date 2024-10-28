import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:medvantage_patient/ViewModal/login_view_modal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';

import 'package:medvantage_patient/theme/theme.dart';
import '../../Localization/app_localization.dart';
import '../../ViewModal/MasterDashoboardViewModal.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../assets.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import 'edit_profile_view.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);
    List drawerList=[
      {
        'title':localization.getLocaleData.home,
        'light_img':'assets/colorful2/home.svg',
        'dark_img':  ImagePaths.home.toString(),
        'navigation':'Home'

      },
      {
        'title':localization.getLocaleData.symptomTracker,
        'light_img':'assets/colorful2/symptomstracker.svg',
        'dark_img':  ImagePaths.symptomTrackerDark.toString(),
        'navigation':'Symptoms Tracker'
      },
      {
        'title':localization.getLocaleData.addVital,
        'light_img':'assets/colorful2/vitalmanagemnt.svg',
        'dark_img':  ImagePaths.addVitalsDark.toString(),
        'navigation':'Vital Management'
      },
      // {
      //   'title':localization.getLocaleData.activitiesChronicle,
      //   'light_img':'assets/colorful2/activity.svg',
      //   'dark_img':  ImagePaths.activityChronicleDark.toString(),
      //   'navigation':'Activities Chronicle'
      // },
      {
        'title':localization.getLocaleData.fluidManagement,
        'light_img':'assets/colorful2/fluidmanagement.svg',
        'dark_img':  ImagePaths.fluidDark.toString(),
        'navigation':'Fluid Management'
      },
      // {
      //   'title':localization.getLocaleData.presribedMedicine,
      //   'light_img':ImagePaths.fluidLight.toString(),
      //   'dark_img':  ImagePaths.fluidDark.toString(),
      // },
      {
        'title':localization.getLocaleData.prescriptionChecklist,
        'light_img':'assets/colorful2/supplimentchecklist.svg',
        'dark_img':  ImagePaths.prescriptionDark.toString(),
        'navigation':'Prescription Checklist'
      },
      // {
      //   'title':localization.getLocaleData.dietChecklist,
      //   'light_img':'assets/colorful2/dietchecklist.svg',
      //   'dark_img':  ImagePaths.dietChecklistDark.toString(),
      //   'navigation':'Diet Checklist'
      // },
      // {
      //   'title':'Pills Reminder',
      //   'light_img':ImagePaths.dietChecklistLight.toString(),
      //   'dark_img':  ImagePaths.dietChecklistDark.toString(),
      // },
      // {
      //   'title':localization.getLocaleData.supplementChecklist,
      //   'light_img':'assets/colorful2/supplimentchecklist.svg',
      //   'dark_img':  ImagePaths.supplementDark.toString(),
      //   'navigation':'Supplement Checklist'
      // },
      // {
      //   'title':localization.getLocaleData.medcareRoyalTraining,
      //   'light_img':'assets/colorful2/homecaretraining.svg',
      //   'dark_img':  ImagePaths.home_care_trainning_dark.toString(),
      //   'navigation':'SmartHeart Failure Revival Training'
      // },
      // {
      //   'title':localization.getLocaleData.exerciseTracker,
      //   'light_img':'assets/colorful2/exercise.svg',
      //   'dark_img':  ImagePaths.excerciseTrackerDark.toString(),
      //   'navigation':'Exercise Tracker'
      // },


      {
        'title':localization.getLocaleData.uploadReport,
        'light_img':'assets/A Vitalio/uploadReport.svg',
        'dark_img':  'assets/A Vitalio/uploadReport.svg',
        'navigation':'Upload Report'
      },
      {
        'title': 'Plan of Care',
        'light_img':'assets/colorful2/uploadreport.svg',
        'dark_img':  ImagePaths.uploadReportDark.toString(),
        'navigation':'Plan of care',
      },
      // {
      //   'title': localization.getLocaleData.patientDashboard.toString(),
      //   'light_img':'assets/colorful2/feedback.svg',
      //   'dark_img':  ImagePaths.feedback_dark.toString(),
      //   'navigation':'RMD'
      // },
      // {
      //   'title':localization.getLocaleData.feedback,
      //   'light_img':'assets/colorful2/drawer14..svg',
      //   'dark_img':  ImagePaths.feedback_dark.toString(),
      //   'navigation':'Feedback'
      // },


      // {
      //   'title':localization.getLocaleData.fAndQ,
      //   'light_img':'assets/colorful2/drawer13..svg',
      //   'dark_img':  ImagePaths.faq_dark.toString(),
      //   'navigation':'FAQs'
      // },
      {
        'title':localization.getLocaleData.chat,
        'light_img':'assets/colorful2/chat.svg',
        'dark_img': 'assets/lightm_patient/chat.png',
        'navigation':'Chat'
      },
      // {
      //   'title':localization.getLocaleData.bedCareConnect,
      //   'light_img':'assets/colorful2/drawer10..svg',
      //   'dark_img': 'assets/lightm_patient/chat.png',
      //   'navigation':'BedCareConnect'
      // },
      {
        'title':localization.getLocaleData.setting,
        'light_img':'assets/setting.svg',
        'dark_img': 'assets/setting.svg',
        'navigation':'Setting'
      },

      // {
      //     'title':'Pills Reminder Intake Analytics',
      //   'light_img':ImagePaths.dietChecklistLight.toString(),
      //   'dark_img':  ImagePaths.dietChecklistLight.toString(),
      // },
      // {
      //   'title':'F&Q',
      //   'light_img':ImagePaths.faqLight.toString(),
      //   'dark_img':  ImagePaths.faqDark.toString(),
      // },

      // {
      //   'title': 'nnn',
      //   'light_img':'assets/colorful2/drawer12.png',
      //   'dark_img':  ImagePaths.uploadReportDark.toString(),
      //   'navigation':'nnn'
      // },
    ];
    MasterDashboardViewModal masterDashboardViewModal =
        Provider.of<MasterDashboardViewModal>(context, listen: true);
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: true);
    // UserRepository userRepository =
    // Provider.of<UserRepository>(context, listen: true);

    masterDashboardViewModal.onPressOpenDrawer();

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClayContainer(
          color: themeChange.darkTheme == false
              ? AppColor.white
              : AppColor.neoBGGrey1,
          borderRadius: 35,
          // surfaceColor:AppColor.neoBGGrey2,
          curveType: CurveType.convex,
          spread: 10,
          parentColor: themeChange.darkTheme ? Colors.black12 : AppColor.grey,
          child: Drawer(
            width: 280,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       themeChange.darkTheme
                  //           ? AppColor.neoBGGrey1
                  //           : AppColor.white,
                  //       themeChange.darkTheme
                  //           ? AppColor.neoBGGrey2
                  //           : AppColor.neoBGWhite2,
                  //     ]),
                  color: themeChange.darkTheme == false
                      ? AppColor.neoBGWhite1
                      : AppColor.neoBGGrey1,
                  // borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              Get.to(()=>EditProfile());
                              masterDashboardViewModal.updateSelectedPage =
                                  'Edit Profile';
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                        themeChange.darkTheme == true
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade400,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: userRepository
                                            .getUser.patientName
                                            .toString(),
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 75,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          size: 75,
                                          color: Colors.grey,
                                        ),
                                        height: 90,
                                        width: 80,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        userRepository.getUser.patientName
                                            .toString()
                                            .toUpperCase(),
                                        style: MyTextTheme.mediumBCN.copyWith(
                                          color: AppColor.neoGreen,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        userRepository.getUser.uhID
                                            .toString(),
                                        style: MyTextTheme.smallGCN.copyWith(
                                            color:
                                            themeChange.darkTheme == false
                                                ? Colors.black87
                                                : AppColor.white,
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        userRepository.getUser.mobileNo
                                            .toString(),
                                        style: MyTextTheme.smallGCN.copyWith(
                                            color:
                                                themeChange.darkTheme == false
                                                    ? Colors.black87
                                                    : AppColor.white,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     CustomInkWell(
                          //       padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                          //       color: AppColor.primaryColor,
                          //       onTap: () {
                          //         MyNavigator.push(context, EditProfile());
                          //       },
                          //       child: Wrap(
                          //         children: [
                          //           Text(
                          //             localization.getLocaleData.viewProfile
                          //                 .toString(),
                          //             style: MyTextTheme.smallWCB,
                          //           ),
                          //           const SizedBox(
                          //             width: 5,
                          //           ),
                          //           const Icon(
                          //             Icons.edit,
                          //             size: 15,
                          //             color: Colors.white,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     // SizedBox(width: 5,),
                          //     // Expanded(
                          //     //   child: TextButton(
                          //     //       onPressed: () {
                          //     //         MyNavigator.push(context, const AllMemberView());
                          //     //       },
                          //     //       child: Text(
                          //     //         localization.getLocaleData.changeMember.toString(),
                          //     //         style: MyTextTheme.mediumPCN,
                          //     //       )),
                          //     // )
                          //   ],
                          // )
                        ]),
                  ),

                  Divider(
                    height: 5,
                    color: AppColor.neoGreen,
                  ),
                  // const SizedBox(height: 10,),
                  // Text(masterDashboardViewModal.getSelectedPage.toString()),


                  // InkWell(
                  //   onTap: () async {
                  //     themeChange.darkTheme = !themeChange.darkTheme;
                  //     themeChange.darkTheme =
                  //     await themeChange.getTheme();
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //       decoration:  BoxDecoration(
                  //         color: Colors.white,
                  //         gradient: LinearGradient(
                  //         colors: [
                  //           themeChange.darkTheme ? AppColor.bgDark : AppColor.white,
                  //           themeChange.darkTheme ? AppColor.bgDark : AppColor.white,
                  //           themeChange.darkTheme ? AppColor.bgDark : AppColor.white,
                  //           themeChange.darkTheme ? AppColor.bgDark : AppColor.neoBGWhite1,
                  //           themeChange.darkTheme ? AppColor.bgDark : AppColor.neoBGWhite2,
                  //         ],
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //       ),
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8.0),
                  //             child: Icon(
                  //               themeChange.darkTheme
                  //                   ? Icons.dark_mode
                  //                   : Icons.light_mode,
                  //               color: themeChange.darkTheme
                  //                   ? Colors.white
                  //                   : Colors.orangeAccent,
                  //               size: 20,
                  //             ),
                  //           ),
                  //           Expanded(
                  //               child: Text(
                  //             '    Light / Dark Mode',
                  //             style: MyTextTheme.mediumBCB.copyWith(
                  //                 color: themeChange.darkTheme
                  //                     ? Colors.white
                  //                     : Colors.green),
                  //           )),
                  //         ],
                  //       ),
                  //     ),
                  // ),
                  // const SizedBox(height: 5,),
                  Expanded(
                    child: ListView(
                      children: [
                        ...List.generate(drawerList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () async {
                               Get.back();
                               print('nnnvnnnnvnvnnvnvnnnn '+userRepository.getUser.bloodGroupId.toString());
                                print('nnnvnnnnvnvnnvnvnnnn '+Get.currentRoute.toString());
                                Get.until(  (route) =>  route.settings.name=='/RMDView');
                                masterDashboardViewModal.updateSelectedPage =drawerList[index]
                                            ['navigation']
                                        .toString();
                                await  masterDashboardViewModal.onSelectPage();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(drawerList[index]['light_img']
                                            .toString(),
                                    width: 21,
                                    height: 21,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(drawerList[index]
                                            ['title']
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style: MyTextTheme.mediumWCN.copyWith(
                                        fontSize: 14,
                                        color: themeChange.darkTheme == true
                                            ? Colors.white
                                            : AppColor.darkshadowColor1
                                                .withOpacity(0.8),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // ListTile(
                          //     title:
                          //     InkWell(
                          //       onTap: (){
                          //          Get.back();
                          //         masterDashboardViewModal.updateSelectedPage=masterDashboardViewModal.drawerList[index]['title'].toString();
                          //
                          //       },
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         children: [
                          //           Image.asset(
                          //             themeChange.darkTheme?
                          //             masterDashboardViewModal.drawerList[index]['dark_img'].toString():
                          //             masterDashboardViewModal.drawerList[index]['light_img'].toString(),
                          //             width: 21,
                          //             height: 21,
                          //             fit: BoxFit.cover,
                          //           ),
                          //           const SizedBox(
                          //             width: 10,
                          //           ),
                          //           Text( masterDashboardViewModal.drawerList[index]['title'].toString(),
                          //             textAlign: TextAlign.start,
                          //             style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeChange.darkTheme==true? Colors.white:AppColor.greyDark),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     // trailing: const Icon(Icons.arrow_forward_ios_outlined,
                          //     //     size: 15),
                          //     onTap: () { Get.back();
                          //       masterDashboardViewModal.updateSelectedPage=masterDashboardViewModal.drawerList[index]['title'].toString();
                          //
                          //       //  Get.back();
                          //       // masterDashboardViewModal.onSelectPage(masterDashboardViewModal.drawerList[index]['title'].toString(),);
                          //     },
                          //   )
                        ),
                        // ListTile(
                        //   title: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.symptomTrackerDark.toString():
                        //         ImagePaths.symptomTrackerLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.symptomTracker
                        //             .toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(context, const SymptomTracker());
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.addVitalsDark.toString():
                        //         ImagePaths.addVitalsLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.addVital.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(context, const AddVitalView());
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.fluidDark.toString():
                        //         ImagePaths.fluidLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.fluidIntake.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(context, const SliderVerticalWidget());
                        //   },
                        // ),
                        //
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.fluidDark.toString():
                        //         ImagePaths.fluidLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.urineOutput.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(context, const UrinOutputView());
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.prescriptionDark.toString():
                        //         ImagePaths.prescriptionLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.prescriptionChecklist
                        //             .toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(
                        //         context, const PrescriptionCheckListView());
                        //   },
                        // ),
                        //
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //
                        //         ImagePaths.dietChecklistDark.toString():
                        //         ImagePaths.dietChecklistLight.toString(),
                        //         width: 20,
                        //         height: 20,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.dietChecklist.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //
                        //     MyNavigator.push(context, const FoodIntakeView());
                        //   },
                        // ),
                        //
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //
                        //         ImagePaths.dietChecklistDark.toString():
                        //         ImagePaths.dietChecklistLight.toString(),
                        //         width: 20,
                        //         height: 20,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text('Pills Reminder',
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(context, const PillsReminderView());
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.supplementDark.toString():
                        //         ImagePaths.supplementLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.supplementChecklist
                        //             .toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(context, const SupplementIntakeView());
                        //   },
                        // ),
                        //
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.exerciseDark:
                        //         ImagePaths.exerciseLight,
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.exerciseTracker
                        //             .toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     // Alert.show("Coming Soon");
                        //     MyNavigator.push(context, const ExerciseTrackingView());
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //         ImagePaths.exerciseDark:
                        //         ImagePaths.exerciseLight,
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text('Activities Chronicle',
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     // Alert.show("Coming Soon");
                        //     MyNavigator.push(context, const ActivitiesChronicleView());
                        //   },
                        // ),
                        //
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //
                        //         ImagePaths.uploadReportDark:
                        //         ImagePaths.uploadReportLight,
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.uploadReport.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     //  Alert.show("Coming Soon");
                        //     MyNavigator.push(context, const ReportTrackingView());
                        //   },
                        // ),
                        // // ListTile(
                        // //   title: Row(
                        // //     children: [
                        // //
                        // //       Image.asset(  ImagePaths.lifestyleIcon,width: 21,height:21,fit: BoxFit.cover,),
                        // //       const SizedBox(
                        // //         width: 10,
                        // //       ),
                        // //       Text(
                        // //         'Lifestyle Intervention',
                        // //         textAlign: TextAlign.start,
                        // //         style: MyTextTheme.mediumPCB.copyWith(fontSize: 13),
                        // //       ),
                        // //     ],
                        // //   ),
                        // //   trailing:
                        // //   const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        // //   onTap: (){
                        // //      Get.back();
                        // //     MyNavigator.push(context, LifeStyleInterventions());
                        // //   },
                        // // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //
                        //         ImagePaths.faqDark.toString():
                        //         ImagePaths.faqLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.fAndQ.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     Alert.show(
                        //         localization.getLocaleData.comingSoon.toString());
                        //   },
                        // ),
                        //
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Image.asset(
                        //         themeProvider.darkTheme==true?
                        //
                        //         ImagePaths.faqDark.toString():
                        //         ImagePaths.faqLight.toString(),
                        //         width: 21,
                        //         height: 21,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.chat.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //      Get.back();
                        //     MyNavigator.push(context, const ChatView());
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       const Icon(
                        //         Icons.feedback,
                        //         size: 21,
                        //       ),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.feedback.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumWCN.copyWith(fontSize: 13,color:themeProvider.darkTheme==true? Colors.white:AppColor.greyDark),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios_outlined,
                        //       size: 15),
                        //   onTap: () {
                        //     Alert.show(
                        //         localization.getLocaleData.comingSoon.toString());
                        //      Get.back();
                        //   },
                        // ),

                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(20.0),
                        //   child: NeoButton(
                        //     width: 220,
                        //     height: 45,
                        //     title: localization.getLocaleData.logout.toString(), func: () async {
                        //     await onPressLogOutButton(context);
                        //   },),
                        // ),

                        // InkWell(
                        //     onTap: () async {
                        //       await onPressLogOutButton(context);
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Container(
                        //           decoration: BoxDecoration(
                        //               color: AppColor.red,
                        //               borderRadius: BorderRadius.circular(10.0)),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(10.0),
                        //             child: Text(
                        //               localization.getLocaleData.logout.toString(),
                        //               style: TextStyle(color: AppColor.white),
                        //             ),
                        //           )),
                        //     )),

                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //
                        //       Image.asset( "assets/chat.png",width: 40,height:40,fit: BoxFit.cover,),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.chat.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumPCB.copyWith(fontSize: 13),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing:
                        //   const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        //   onTap: (){
                        //      Get.back();
                        //     MyNavigator.push(context, const ChatView());
                        //   },
                        // ),

                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       const Icon(Icons.feedback,size: 40,),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text(
                        //         localization.getLocaleData.feedback.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumPCB.copyWith(fontSize: 13),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing:
                        //   const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        //   onTap: (){
                        //     Alert.show(localization.getLocaleData.comingSoon.toString());
                        //      Get.back();
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //   Icon(Icons.phone_android),
                        //       // Image.asset( "assets/chat.png",width: 40,height:40,fit: BoxFit.cover,),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text("Activities Chronicle",
                        //         // localization.getLocaleData.chat.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumPCB.copyWith(fontSize: 13),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing:
                        //   const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        //   onTap: (){
                        //      Get.back();
                        //     MyNavigator.push(context, const ActivitiesChronicleView());
                        //   },
                        // ),
                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Icon(Icons.phone_android),
                        //       // Image.asset( "assets/chat.png",width: 40,height:40,fit: BoxFit.cover,),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text("Pills Reminder",
                        //         // localization.getLocaleData.chat.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumPCB.copyWith(fontSize: 13),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing:
                        //   const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        //   onTap: (){
                        //      Get.back();
                        //     MyNavigator.push(context, const PillsReminderView()
                        //     );
                        //   },
                        // ),

                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Icon(Icons.phone_android),
                        //       // Image.asset( "assets/chat.png",width: 40,height:40,fit: BoxFit.cover,),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text("nnn",
                        //         // localization.getLocaleData.chat.toString(),
                        //         textAlign: TextAlign.start,
                        //         style: MyTextTheme.mediumPCB.copyWith(fontSize: 13),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing:
                        //   const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        //   onTap: (){
                        //      Get.back();
                        //     MyNavigator.push(context, const nnn());
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: PrimaryButton(onPressed: ()async {
                      await onPressLogOutButton(context);
                      masterDashboardViewModal.updateSelectedPage = '';
                    }, title: localization.getLocaleData.logout.toString(),),
                  ),

                  // InkWell(
                  //   onTap: ()async {
                  //     await onPressLogOutButton(context);
                  //     masterDashboardViewModal.updateSelectedPage = '';
                  //   },
                  //     child: Stack(
                  //       children: [
                  //         Center(
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(bottom: 15.0),
                  //             child: Image.asset(themeChange.darkTheme ?'assets/BtnDark.png':'assets/BtnLight.png'  ,
                  //               width: 220,
                  //               height: 53,
                  //               ),
                  //           ),
                  //         ),
                  //         Center(child: Padding(
                  //           padding: const EdgeInsets.only(top: 18.0),
                  //           child: Text(localization.getLocaleData.logout.toString(),style: MyTextTheme.smallWCN.copyWith(color: themeChange.darkTheme ?Colors.white70:AppColor.bgDark),),
                  //         )),
                  //
                  //       ],
                  //     ),
                  // ),
                  ///
                  // InkWell(
                  //     onTap: () async {
                  //       await onPressLogOutButton(context);
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Container(
                  //           decoration: BoxDecoration(
                  //               color: AppColor.red,
                  //               borderRadius: BorderRadius.circular(10.0)),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Text(
                  //               localization.getLocaleData.logout.toString(),
                  //               style: TextStyle(color: AppColor.white),
                  //             ),
                  //           )),
                  //     )),

                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: drawerMenuListVM.getMenuList.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //
                  //       MenuDetailsModal menuData = drawerMenuListVM.getMenuList[index];
                  //       return ListTile(
                  //         title: Row(
                  //           children: [
                  //             CachedNetworkImage(
                  //               imageUrl: menuData.icon.toString(),
                  //               placeholder: (context, url) =>
                  //                   Image.asset(ImagePaths.gynecologist.toString()),
                  //               errorWidget: (context, url, error) =>
                  //                   Image.asset(ImagePaths.gynecologist.toString()),
                  //               width: 25,
                  //               height: 25,
                  //             ),
                  //
                  //             const SizedBox(
                  //               width: 10,
                  //             ),
                  //             Text(
                  //               menuData.menuName.toString(),
                  //               textAlign: TextAlign.start,
                  //               style: MyTextTheme.mediumPCB.copyWith(fontSize: 13),
                  //             ),
                  //           ],
                  //         ),
                  //         trailing:
                  //         const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                  //         onTap: () {
                  //           //  Get.back();
                  //           drawerMenuListVM.onPressedDrawerMenu(
                  //               context, menuData.menuName.toString());
                  //         },
                  //       );
                  //     },
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onPressLogOutButton(context) async {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);

    LoginViewModal loginVM =
        Provider.of<LoginViewModal>(context, listen: false);

    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message:
              localization.getLocaleData.areuSureYouWantToLogOut.toString(),
          buttonName: localization.getLocaleData.yes.toString(),
          onPressButton: () async {
            print('nnnnnnnvvvv');
            await loginVM.logOut(context);
            // await userRepository.logOutUser(context);
            print('nnnnnnnvvvv');
          },
          cancelBtn: localization.getLocaleData.cancel.toString(),
        ));
  }
}
