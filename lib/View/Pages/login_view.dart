import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/neomorphic/theme_provider.dart';
import 'package:medvantage_patient/app_manager/theme/theme_provider.dart';
import 'package:medvantage_patient/app_manager/web_view.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/custom_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:provider/provider.dart';
import '../../Localization/app_localization.dart';
import '../../ViewModal/login_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/neomorphic/hex.dart';
import '../../app_manager/neomorphic/neomorphic.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/buttons/primary_button.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/tab_responsive.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {
  get(){
    LoginViewModal loginVM = Provider.of<LoginViewModal>(context, listen: false);
    loginVM.clearData();
  }

@override
  void initState() {WidgetsBinding.instance
    .addPostFrameCallback((_) async {
      get();
    });
    // TODO: implement initState
    super.initState();
  }

  String dropdownValue='+91';

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    LoginViewModal loginVM =
        Provider.of<LoginViewModal>(context, listen: true);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return  ColoredSafeArea(
      color:AppColor.green,
      child: SafeArea(
          child: Scaffold(
        body: Container(
          height: Get.height ,
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
               colors: [
                 themeChange.darkTheme==true?AppColor.bgDark:AppColor.neoBGWhite1,
                 themeChange.darkTheme==true?AppColor.bgDark:AppColor.neoBGWhite2,
                 themeChange.darkTheme==true?AppColor.bgDark:AppColor.neoBGWhite2,
               ]
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // IconButton(
                          //     onPressed: () {
                          //        Get.back();
                          //     },
                          //     icon: Icon(
                          //       Icons.arrow_back_outlined,
                          //       color: AppColor.grey,
                          //       size: 28,
                          //     )),

                          InkWell(
                              onTap: ()async {

                                themeChange.darkTheme=!themeChange.darkTheme;
                                themeChange.darkTheme = await themeChange.getTheme();
                              },child: Image.asset(themeChange.darkTheme==true? 'assets/login/colorSswitchDark.png':'assets/login/colorSwitchLight.png',height: 30,)),
                          //            CustomInkWell(
               //              onTap: () async {
               // themeChange.darkTheme=!themeChange.darkTheme;
               //     themeChange.darkTheme = await themeChange.getTheme();
               //              },
               //              child: Container(
               //                padding: const EdgeInsets.all(10),
               //                child: CustomInkWell(onTap:(){
               //                  MyNavigator.push(context,  WebViewPage(title: localization.getLocaleData.help.toString(),
               //                    url: 'https://medvantage_patient.in/Home/AboutUs',));
               //                } ,
               //                  child: Text(
               //                      "${localization.getLocaleData.help} ?",
               //                      style: MyTextTheme.mediumGCB.copyWith(
               //                          color:themeChange.darkTheme? Colors.white:Colors.grey
               //                      )
               //                  ),
               //                ),
               //              ),
               //            ),
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const SizedBox(height: 35),
                          Visibility(
                            visible: themeChange.darkTheme==true,
                            replacement:Image.asset(
                              'assets/login/drLight.png',
                              fit: BoxFit.contain,
                            ),
                            child: Image.asset(
                              'assets/login/drDark.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(localization.getLocaleData.empowerYourHealthWith.toString(),style: MyTextTheme.mediumBCN.copyWith(color: themeChange.darkTheme?Colors.white:Colors.black),),
                          Text(localization.getLocaleData.ourSmartApp.toString(),style: MyTextTheme.mediumBCB.copyWith(color: themeChange.darkTheme?Colors.white:Colors.black),),

                          const SizedBox(height: 101),
                          TabResponsive(
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(localization.getLocaleData.heyThere.toString(),
                                    style: MyTextTheme.largeBCB.copyWith( color: hexToColor('#1BD15D'),),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(localization.getLocaleData.loginToExploreAllFeatures.toString(),
                                    style: MyTextTheme.mediumBCN.copyWith(color:themeChange.darkTheme==true ?Colors.white70:Colors.black87),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(

                                    decoration: BoxDecoration(

                                        // border: Border.all(
                                        //   color: AppColor.grey,
                                        // ),
                                      boxShadow:  [
                                        BoxShadow(
                                        color:themeChange.darkTheme==true? Colors.black26:Colors.grey.shade500,
                                          offset: const Offset(5,5),
                                          blurRadius: 5
                                      )],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                      //     DropdownButton(elevation: 0,
                                      //       underline: SizedBox(),
                                      //
                                      //       // Initial Value
                                      //       value: dropdownValue,
                                      //
                                      //       // Down Arrow Icon
                                      //       icon: const Icon(Icons.keyboard_arrow_down, ),
                                      //
                                      //
                                      //       // Array list of items
                                      //       items: loginVM.countryCode.map(( items) {
                                      //         return DropdownMenuItem(
                                      //           value: items['code'],
                                      //           child: Text(items['code'],style: MyTextTheme.mediumGCN,),
                                      //         );
                                      //       }).toList(),
                                      //       // After selecting the desired option,it will
                                      //       // change button value to selected value
                                      //       onChanged: ( value) {
                                      //         print(value.toString());
                                      //         setState(() {
                                      //           dropdownValue = value.toString();
                                      //         });
                                      //       },
                                      //     ),
                                      //
                                      //
                                      // VerticalDivider(
                                      //   width: 2,
                                      //   indent: 8,
                                      //   endIndent: 8,
                                      //   color: AppColor.lightBlack,
                                      // ),
                                          Expanded(
                                              child: PrimaryTextField(
                                                style: themeChange.darkTheme==false?MyTextTheme.mediumGCB:MyTextTheme.mediumWCN,
                                                backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                                                controller: loginVM.mobileNoC,
                                                hintText:localization.getLocaleData.enterYourUHID.toString(),
                                                onChanged: (val){
                                                  loginVM.notifyListeners();
                                                },
                                                borderColor: Colors.transparent,
                                                hintTextColor: Colors.grey,
                                                // hintStyle: MyTextTheme.mediumGCN
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: !loginVM.getLoginWithOtp,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      decoration: BoxDecoration(

                                          border: Border.all(
                                              color: AppColor.grey),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: PrimaryTextField(
                                                style: MyTextTheme.mediumGCN,
                                                controller: loginVM.passwordC,
                                                hintText: localization.getLocaleData.enterPassword.toString(),
                                                borderColor: Colors.transparent,
                                                // hintStyle: MyTextTheme.mediumGCN,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),

                                  // RichText(
                                  //     text: TextSpan(children: [
                                  //       TextSpan(
                                  //           text: "${localization.getLocaleData.agrrementTermsCondition} ",
                                  //           style:
                                  //          MyTextTheme.smallGCN),
                                  //       TextSpan(
                                  //           text:localization.getLocaleData.termsNdCondition.toString(),
                                  //           style:
                                  //          MyTextTheme.smallGCB),
                                  //     ])),
                                  // const SizedBox(
                                  //   height: 29,
                                  // ),

                                  PrimaryButton(onPressed: () async {
                                    await loginVM.onPressedLogin(context);
                                  },title: localization.getLocaleData.continueText.toString(),),
                                  // InkWell(
                                  //   onTap: () async {
                                  //     await loginVM.onPressedLogin(context);
                                  //   },
                                  //     child:
                                  //     Stack(
                                  //       children: [
                                  //         Center(
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.only(bottom: 15.0),
                                  //             child: Image.asset(themeChange.darkTheme ?'assets/BtnDark.png':'assets/BtnLight.png'  ,
                                  //
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Center(child: Padding(
                                  //           padding: const EdgeInsets.only(top: 25.0),
                                  //           child: Text(localization.getLocaleData.continueText.toString(),
                                  //             style: MyTextTheme.mediumWCB.copyWith(
                                  //                 color: themeChange.darkTheme ?Colors.white70:AppColor.greyDark),),
                                  //
                                  //         )),
                                  //
                                  //       ],
                                  //     ),),

                                  // const Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     // Expanded(
                                  //     //   child: NeoButton(height: 50,title: 'Login', func: () async {
                                  //     //     await loginVM.onPressedLogin(context);
                                  //     //   },),
                                  //     // ),
                                  //     // Expanded(
                                  //     //   child: PrimaryButton(
                                  //     //     width: 200,
                                  //     //     onPressed: () async {
                                  //     //       await loginVM.onPressedLogin(context);
                                  //     //     },
                                  //     //     title:"Login",
                                  //     //     color: AppColor.primaryColor,
                                  //     //   ),
                                  //     // ),
                                  //   ],
                                  // ),


                                  // Center(
                                  //   child: Text(
                                  //     localization.getLocaleData.or.toString(),
                                  //     style: TextStyle(color: AppColor.grey),
                                  //   ),
                                  // ),

                                  // Center(child: Text("Login with mobile number",style: TextStyle(color: AppColor.primaryColor,
                                  // fontWeight: FontWeight.w500),)),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     TextButton(
                                  //         onPressed: () {
                                  //           loginVM.updateLoginWithOtp = !loginVM.getLoginWithOtp;
                                  //         },
                                  //         child: Text(
                                  //           !loginVM.getLoginWithOtp
                                  //               ? localization.getLocaleData.loginOtp.toString()
                                  //               : localization.getLocaleData.loginWithMobile.toString(),
                                  //           style: TextStyle(
                                  //               color: AppColor.primaryColor,
                                  //               fontWeight: FontWeight.w500),
                                  //         )),
                                  //   ],
                                  // ),


                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                      // Center(
                      //   child: Text(
                      //     localization.getLocaleData.agrrementTermsCondition.toString(),
                      //     style: MyTextTheme.smallGCN,
                      //   ),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     CustomInkWell(
                      //       onTap: () {
                      //         MyNavigator.push(context,  WebViewPage(
                      //           url: 'https://medvantage_patient.in/Home/TermsCondition',
                      //           title: localization.getLocaleData.termsNdCondition.toString(),));
                      //       },
                      //       child: Text(
                      //         localization.getLocaleData.termsNdCondition.toString(),
                      //         style: MyTextTheme.smallGCB,
                      //       ),
                      //     ),
                      //     Text(
                      //       localization.getLocaleData.and.toString(),
                      //       style: MyTextTheme.smallGCN,
                      //     ),
                      //     CustomInkWell(
                      //         onTap: () {
                      //           MyNavigator.push(context,  WebViewPage(url:
                      //           'https://criteriontech.in/privacy-policy.html',
                      //             title: localization.getLocaleData.privacyPolicy.toString(),));
                      //         },
                      //         child: Text(
                      //           localization.getLocaleData.privacyPolicy.toString(),
                      //           style: MyTextTheme.smallGCB,
                      //         )),
                      //   ],
                      // ),
                      // const SizedBox(height: 5,),
                      // Center(child: Text(localization.getLocaleData.criterionTech.toString(),style: MyTextTheme.mediumGCN,textAlign: TextAlign.center,)),

                      const SizedBox(
                        height: 45,
                      ),
                    ]),
              ),
            ),
          ),
        )
      )),
    );
  }
}
