
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:medvantage_patient/LiveVital/pmd/my_text_theme.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../ViewModal/report_tracking_view_modal.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/camera_and images/image_picker.dart';
import '../../app_manager/imageViewer/ImageView.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../assets.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';

import 'package:get/get.dart';

class ReportTrackingView extends StatefulWidget {
  const ReportTrackingView({super.key});

  @override
  State<ReportTrackingView> createState() => _ReportTrackingViewState();
}

class _ReportTrackingViewState extends State<ReportTrackingView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      get();
    });
  }


  get() async {
    ReportTrackingViewModal reportTrackingVM =
        Provider.of<ReportTrackingViewModal>(context, listen: false);
    await reportTrackingVM.getPatientMediaData(context);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    ReportTrackingViewModal reportTrackingVM =
        Provider.of<ReportTrackingViewModal>(context, listen: true);
    var dark = themeChange.darkTheme;
    return ColoredSafeArea(
      child: SafeArea(
        child:Scaffold(
          backgroundColor:dark?VitalioColors.bgDark: VitalioColors.greyBG,
          key: scaffoldKey,
          drawer: const MyDrawer(),
          // appBar: CustomAppBar(
          //     title: localization.getLocaleData.uploadReport.toString(),
          //     color: AppColor.primaryColor,
          //     titleColor: AppColor.white,
          //     primaryBackColor: AppColor.white),
          body: Column(
            children: [

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // InkWell(
              //       //   onTap: (){
              //       //      Get.back();
              //       //   },
              //       //   child: Padding(
              //       //     padding: const EdgeInsets.all(8.0),
              //       //     child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? Colors.white:Colors.grey,),
              //       //   ),
              //       // ),
              //       InkWell(
              //           onTap: (){
              //             scaffoldKey.currentState!.openDrawer();
              //
              //
              //           },
              //           child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:
              //           ImagePaths.menulight,height: 40)),
              //       Text(localization.getLocaleData.uploadReport.toString(),
              //         style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,
              //             color: themeChange.darkTheme==true?Colors.white70:null),),
              //       Text('Repoert',
              //         style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,
              //             color: themeChange.darkTheme==true?Colors.white70:null),),
              //     ],
              //   ),
              // ),



              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // InkWell(
              //       //   onTap: (){
              //       //      Get.back();
              //       //   },
              //       //   child: Padding(
              //       //     padding: const EdgeInsets.all(8.0),
              //       //     child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? Colors.white:Colors.grey,),
              //       //   ),
              //       // ),
              //       InkWell(
              //           onTap: (){
              //             // scaffoldKey.currentState!.openDrawer();
              //
              //             Get.to(()=>Menu());
              //           },
              //           child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
              //
              //       Column(crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(localization.getLocaleData.uploadReport.toString(),
              //             style: MyTextTheme().largeGCB.copyWith(fontSize: 21,height: 0,color: themeChange.darkTheme==true?Colors.white70:null),),
              //               ],
              //       ),
              //
              //       ],
              //     ),
              //   ),

              Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // InkWell(
                  //   onTap: (){
                  //      Get.back();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? Colors.white:Colors.grey,),
                  //   ),
                  // ),
                  InkWell(
                      onTap: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                      child: Image.asset(
                          themeChange.darkTheme == true
                              ? ImagePaths.menuDark
                              : ImagePaths.menulight,
                          height: 40)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Upload Report',
                          style: MyTextTheme().largeBCB.copyWith(
                              fontSize: 21,
                              height: 0,
                              color: themeChange.darkTheme == true
                                  ? Colors.white70
                                  : null),
                        ),

                      ],
                    ),
                  ),


                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text( 'History',
                                  style: MyTextTheme().mediumBCB.copyWith( height: 0,color: themeChange.darkTheme==true?Colors.white70:Colors.black),),
                              ),

                              InkWell(
                                onTap: () async {
                                  // Get.to(AddLabResultsView());

                                 await picImageWidget(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                          'assets/A Vitalio/plus.png',
                                          color: dark ? Colors.blue : VitalioColors.primaryBlue,
                                          height: 12,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Add Report",
                                          style: MyTextTheme().mediumPCN.copyWith(color: dark ? VitalioColors.primaryBlue : VitalioColors.primaryBlue, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Text(localization.getLocaleData.symptomsTracker.toString(),style:MyTextTheme.largeBCB.copyWith(fontSize: 25,height: 1,color: themeChange.darkTheme==true?Colors.white:Colors.black),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

                // SizedBox(
                //   height: 81,
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Row(
                //       children: List.generate(reportTrackingVM.upperList.length, (index) => Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: InkWell(
                //           onTap: (){
                //             reportTrackingVM.updateSelectedInvestigation= reportTrackingVM.upperList[index]['title'].toString();
                //
                //             Alert.show("Coming Soon ");
                //           },
                //           child: Container(
                //             padding: const EdgeInsets.all(8.0),
                //             width: 150,
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(10),
                //               border: Border.all(color:reportTrackingVM.getSelectedInvestion==reportTrackingVM.upperList[index]['title'].toString()?
                //               VitalioColors.primaryBlue:Colors.white)
                //             ),
                //             child: Row(
                //               children: [
                //                 Image.asset(reportTrackingVM.upperList[index]['img'].toString(),color:  reportTrackingVM.getSelectedInvestion==reportTrackingVM.upperList[index]['title'].toString()?
                //                 VitalioColors.primaryBlue:Colors.grey,),
                //                 SizedBox(width: 15,),
                //                 Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Text(reportTrackingVM.upperList[index]['title'].toString(),style:
                //                     reportTrackingVM.getSelectedInvestion==reportTrackingVM.upperList[index]['title'].toString()?
                //                     MyTextTheme().mediumBCB.copyWith(color: VitalioColors.primaryBlue):MyTextTheme().mediumGCB),
                //                     Text(reportTrackingVM.upperList.length.toString()+' Record',style:
                //                     reportTrackingVM.getSelectedInvestion==reportTrackingVM.upperList[index]['title'].toString()?
                //                     MyTextTheme().smallBCN.copyWith(color: VitalioColors.primaryBlue):MyTextTheme().smallGCN  ),
                //                   ],
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       )),
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Expanded(
                      //     child: Text( 'Results',
                      //   style:themeChange.darkTheme? MyTextTheme().mediumWCB:MyTextTheme().largeBCB,
                      // )),
                      // PrimaryButton(
                      //   color: AppColor.neoGreen,
                      //     borderColor: Colors.transparent,
                      //     textStyle: TextStyle(color: Colors.white,fontSize: 15),
                      //
                      //     onPressed: () {
                      //       picImageWidget(context);
                      //     },
                      //     width: 80,
                      //     title: localization.getLocaleData.upload.toString()),
                      const SizedBox(width: 20,)
                    ],
                  ),
                ),
                Expanded(
                    child: Center(
                  child: reportTrackingVM.getPatientReportList.isEmpty
                      ? Text(localization.getLocaleData.noDataFound.toString())
                      : ListView.builder(
                          itemCount: reportTrackingVM.getPatientReportList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = reportTrackingVM.getPatientReportList[index];
                            return Container(
                              margin: const EdgeInsets.all(8),
                              decoration:  BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),

                              ),
                              child: InkWell(
                                onTap: () async {

                                  Get.to(()=>MyImageView(url: data['url'].toString()) );
                                 // await reportTrackingVM.labReportExtraction(context, 'https://cdn.flabs.in/webassets/33806e7015fbfcaff211.png'.toString());
                                 // await reportTrackingVM.labReportExtraction(context, data['url'].toString());

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IntrinsicHeight(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data['category']
                                                    .toString().toUpperCase(),
                                                style:themeChange.darkTheme?  MyTextTheme().largeWCB: MyTextTheme().largeBCB,
                                              ),
                                              Text(
                                                DateFormat('dd-MM-yyyy hh:mm a')
                                                    .format(  DateTime.parse(
                                                        data['dateTime'].toString()))
                                                    .toString(),
                                                style: themeChange.darkTheme? MyTextTheme().smallWCN: MyTextTheme().smallGCN,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: AppColor.greyVeryVeryLight),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child:
                                            CachedNetworkImage(
                                              imageUrl:data['url'].toString(),
                                              height: 74,
                                              width: 74,
                                              fit:  BoxFit.cover,
                                              placeholder: (context, url) => const Center(
                                                  child: Icon(Icons.file_present,color: Colors.grey,)),
                                              errorWidget: (context, url, error) =>
                                                  Image.asset('assets/noProfileImage.png'),
                                            ),
                                            // Image.network(data['url'].toString(),
                                            //   height: 35,
                                            //   width: 35,
                                            //   fit: BoxFit.cover,
                                            // )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                )),
              ],
            ),
          ),
        ),
      );

  }


 picImageWidget(context) async {
   // ReportTrackingViewModal reportTrackingVM =
   // Provider.of<ReportTrackingViewModal>(context, listen: false);

   UserRepository userRepository =
   Provider.of<UserRepository>(context, listen: false);
   ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);

   await CustomBottomSheet.open(context,
       child:Consumer<ThemeProviderLd>(
           builder: (__context, themeChange, _){
           return Consumer<ReportTrackingViewModal>(
               builder:  (BuildContext _context, reportTrackingVM,_) {
               return Container(
                 height: 221,
                 padding: EdgeInsets.all(15),
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     gradient: LinearGradient(
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                         colors: [
                           themeChange.darkTheme?AppColor.neoBGGrey1:AppColor.white,
                           themeChange.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                         ]
                     )),
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(localization.getLocaleData.uploadReport.toString(),style: themeChange.darkTheme? MyTextTheme().mediumGCB:MyTextTheme().mediumBCB,),
                         InkWell(
                           onTap: () {
                              Get.back();
                           },
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Icon(Icons.close,color: themeChange.darkTheme? Colors.white:AppColor.greyDark,),
                           ),
                         )
                       ],
                     ),
                     SizedBox(height: 5,),
                     Container(
                       height: 1,color: AppColor.grey,child: Row(
                       children: [],
                     ),
                     ),

                     SizedBox(height: 15,),

                     InkWell(
                       onTap: () async {
                          Get.back();
                         var data = await MyImagePicker.pickImageFromCamera();
                         print(data.path.toString());
                       var path=  await  MyImagePicker.cropImage(data!.path.toString());
                          // var  compressedFile = await FlutterImageCompress.compressAndGetFile(
                          //   data.path,
                          //   "${data.path.toString().replaceAll('.jpg', '')}_compressed.jpg", // Output file path
                          //   quality: 18 // Quality level (0-100), where 100 is the original quality
                          // );

                         reportTrackingVM.updateImgPath =path.toString();

                          print("mdkgmg"+path.toString());
                         await reportTrackingVM
                             .insertPatientMediaData(context,admitDoctorId:userRepository.getUser.admitDoctorId,
                         uhId: userRepository.getUser.uhID.toString());
                       },
                       child: Container(
                         padding: const EdgeInsets.all(8),
                         decoration:  BoxDecoration(
                             borderRadius: BorderRadius.circular(15),
                             border: Border.all(color:  themeChange.darkTheme?Colors.grey.shade700:Colors.transparent ),
                             gradient: LinearGradient(
                                 begin: Alignment.topCenter,
                                 end: Alignment.bottomCenter,
                                 colors: [
                                   themeChange.darkTheme?AppColor.neoBGGrey1:AppColor.white,
                                   themeChange.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                                 ]
                             )
                         ),
                         child: Row(mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.camera_alt,color:themeChange.darkTheme? Colors.white:AppColor.greyDark,),
                             SizedBox(width: 5,),
                             Text(localization.getLocaleData.takePhoto.toString(),style: themeChange.darkTheme? MyTextTheme().smallWCB:MyTextTheme().smallBCB,),
                           ],
                         ),
                       ),
                     ),
                     SizedBox(height: 15,),
                     InkWell(
                       onTap: () async {
                          Get.back();
                         var data = await MyImagePicker.pickImageFromGallery();
                          var path=  await  MyImagePicker.cropImage(data!.path.toString());
                         reportTrackingVM.updateImgPath = path;
                         // await reportTrackingVM
                         //     .insertPatientMediaData(context); reportTrackingVM.updateImgPath = data.path.toString();

                          await reportTrackingVM
                              .insertPatientMediaData(context,admitDoctorId:userRepository.getUser.admitDoctorId,
                              uhId: userRepository.getUser.uhID.toString());
                       },
                       child: Container(
                         padding: const EdgeInsets.all(8),
                         decoration:  BoxDecoration(
                             borderRadius: BorderRadius.circular(15),
                             border: Border.all(color:  themeChange.darkTheme?Colors.grey.shade700:Colors.transparent ),
                             gradient: LinearGradient(
                                 begin: Alignment.topCenter,
                                 end: Alignment.bottomCenter,
                                 colors: [
                                   themeChange.darkTheme?AppColor.neoBGGrey1:AppColor.white,
                                   themeChange.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                                 ]
                             )
                         ),
                         child: Row(mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.image,color: themeChange.darkTheme? Colors.white:AppColor.greyDark,),
                             const SizedBox(width: 5),
                             Text(localization.getLocaleData.chooseFromGallery.toString(),style: themeChange.darkTheme? MyTextTheme().smallWCB:MyTextTheme().smallBCB,),
                           ],
                         ),
                       ),
                     )



                   ],
                 ),
               );
             }
           );
         }
       ));
 }

  pickImg() {
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ApplicationLocalizations localization =
    // Provider.of<ApplicationLocalizations>(context, listen: false);

    // ReportTrackingViewModal reportTrackingVM =
    //     Provider.of<ReportTrackingViewModal>(context, listen: false);
    CustomBottomSheet.open(
      context,
      child: Consumer<ReportTrackingViewModal>(
          builder:  (BuildContext context, reportTrackingVM,_) {
          return Consumer<ApplicationLocalizations>(
              builder:  (BuildContext context, localization,_) {
              return Container(
                height: 250,
                color: AppColor.white,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                   Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back_sharp,
                                  color: AppColor.white,
                                  size: 25,
                                ),
                              ),
                              Text(
                                localization.getLocaleData.addPicture.toString(),
                                style: MyTextTheme().mediumWCB,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: 45,
                            left: 15,
                            right: 15,
                            child: Column(
                              children: [
                                CustomInkWell(
                                  onTap: () async {
                                     Get.back();
                                    var data =
                                        await MyImagePicker.pickImageFromCamera();
                                    print(data.path.toString());
                                    reportTrackingVM.updateImgPath =
                                        data.path.toString();
                                    await reportTrackingVM
                                        .insertPatientMediaData(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: AppColor.orange),
                                      child: Wrap(children: [
                                        Icon(
                                          Icons.camera_alt_sharp,
                                          size: 25,
                                          color: AppColor.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                         localization.getLocaleData.useCamera.toString(),
                                          style: MyTextTheme().largeWCN,
                                        )
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Or',
                      style: MyTextTheme().largeBCN,
                    ),
                    CustomInkWell(
                      onTap: () async {
                         Get.back();
                        var data = await MyImagePicker.pickImageFromGallery();
                        reportTrackingVM.updateImgPath = data.path;
                        await reportTrackingVM
                            .insertPatientMediaData(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(children: [
                            Icon(
                              Icons.image,
                              size: 25,
                              color: AppColor.primaryColor,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              localization.getLocaleData.selectImageFromGallery.toString(),
                              style: MyTextTheme().largePCN,
                            )
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }
}
