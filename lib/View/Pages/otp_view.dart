import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medvantage_patient/View/Pages/startup_view.dart';
import 'package:medvantage_patient/ViewModal/opt_view_modal.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../../Localization/app_localization.dart';
import '../../ViewModal/login_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/neomorphic/hex.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/buttons/primary_button.dart';
import '../../app_manager/widgets/tab_responsive.dart';
import '../../authenticaton/user.dart';
import '../../authenticaton/user_repository.dart';

class LoginWithOtp extends StatefulWidget {
  const LoginWithOtp({Key? key}) : super(key: key);

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  get(){
    LoginViewModal loginVM = Provider.of<LoginViewModal>(context, listen: false);
    OtpViewModal otpVM = Provider.of<OtpViewModal>(context, listen: false);
    otpVM.updateUserMobileNo=loginVM.mobileNoC.text.toString();
  }
  @override
  void initState() {

    // TODO: implement initState
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      get();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    LoginViewModal loginVM = Provider.of<LoginViewModal>(context, listen: true);
    OtpViewModal otpVM = Provider.of<OtpViewModal>(context, listen: true);

    final themeProvider = Provider.of<ThemeProviderLd>(context, listen: true);

    return ColoredSafeArea(
      child: Scaffold(
              body: SingleChildScrollView(
      child: Container(
        height:  Get.height,
        decoration:  BoxDecoration(
          // color:themeProvider.darkTheme==true? AppColor.bgDark:AppColor.bgWhite,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeProvider.darkTheme==true?AppColor.bgDark:AppColor.neoBGWhite1,
                themeProvider.darkTheme==true?AppColor.bgDark:AppColor.neoBGWhite2,
                themeProvider.darkTheme==true?AppColor.bgDark:AppColor.neoBGWhite2,
              ]
          ),
        ),
        child: TabResponsive(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const Expanded(child: SizedBox()),

                    // CustomInkWell(
                    //   onTap: () {},
                    //   child: Container(
                    //     padding: const EdgeInsets.all(10),
                    //     child: CustomInkWell(onTap:(){
                    //       MyNavigator.push(context,  WebViewPage(title: localization.getLocaleData.help.toString(),url: 'https://medvantage_patient.in/Home/AboutUs',));
                    //     } ,
                    //       child: Text(
                    //           "${localization.getLocaleData.help} ?",
                    //           style: MyTextTheme.mediumGCB.copyWith(
                    //               color: themeProvider.darkTheme? Colors.white:Colors.grey,
                    //           ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                        onTap: ()async {

                          themeProvider.darkTheme=!themeProvider.darkTheme;
                          themeProvider.darkTheme = await themeProvider.getTheme();
                        },child: Image.asset(themeProvider.darkTheme==true? 'assets/login/colorSswitchDark.png':'assets/login/colorSwitchLight.png',height: 30,)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 70, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Visibility(
                          visible: themeProvider.darkTheme==true,
                          replacement:Image.asset(
                            'assets/login/drLight.png',
                            height: (Get.height+50)/4,
                            fit: BoxFit.fitHeight,
                          ),
                          child: Image.asset(
                            'assets/login/drDark.png',
                            height: (Get.height+50)/4,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(localization.getLocaleData.empowerYourHealthWith.toString(),style: MyTextTheme.mediumBCN.copyWith(color: themeProvider.darkTheme?Colors.white:Colors.black),),
                      Text(localization.getLocaleData.ourSmartApp.toString(),style: MyTextTheme.mediumBCB.copyWith(color: themeProvider.darkTheme?Colors.white:Colors.black),),



                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                SizedBox(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(localization.getLocaleData.verifyYourUHID.toString(),
                        style: MyTextTheme.mediumWCN.copyWith(
                            color: AppColor.neoGreen, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('${localization.getLocaleData.enterVerificationCode.toString()}'+(loginVM.logindetail.isEmpty? '':
                      loginVM.logindetail[0]['mobileNo'].toString().substring(6))+')',
                          style: MyTextTheme.mediumWCN.copyWith(color:themeProvider.darkTheme==true ?Colors.white70:Colors.black87, )
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20),
                          child: PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: MyTextTheme.smallWCB,
                            length: 6,
                            autoDisposeControllers: false,
                            controller: loginVM.otpC,
                            obscureText: true,
                            textStyle: MyTextTheme.smallWCB,
                            obscuringCharacter: '*',
                            // obscuringWidget: FlutterLogo(
                            //   size: 24,
                            // ),
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            // validator: (v) {
                            //   if (v!.length < 4) {
                            //     return '';
                            //   } else {
                            //     return null;
                            //   }
                            // },
                            pinTheme: PinTheme(
                                inactiveFillColor:  themeProvider.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                                inactiveColor: themeProvider.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                                activeColor: AppColor.neoGreen,
                                selectedColor:  themeProvider.darkTheme==true? AppColor.neoGreyLight:Colors.white70,
                                activeFillColor: AppColor.neoGreen,
                                selectedFillColor: AppColor.neoGreen,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 48,
                                fieldWidth: 37
                            ),
                            cursorColor: Colors.white,
                            animationDuration:
                            const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            // controller: modal.otpController.otpController.value,
                            keyboardType: TextInputType.number,
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {

                            },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {},
                            beforeTextPaste: (text) {
                              return true;
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${localization.getLocaleData.didnotGetCode} "
                              ,
                              style:
                              MyTextTheme.smallWCN.copyWith(color:themeProvider.darkTheme==true ?Colors.white70:Colors.black87, ),
                            ),const SizedBox(width: 2,),
                            !otpVM.getIsTimer? InkWell(
                              onTap: ()async{
                                otpVM.updateIsTimer=true;
                                await loginVM.generateOTPForPatient(context);
                              },
                              child: Text(localization.getLocaleData.resendCode.toString(),
                                style: MyTextTheme.smallPCN.copyWith(
                                    color: AppColor.neoGreen),
                              ),
                            ):
                            countDown()
                          ],
                        ),
                      ),
                      const SizedBox(
                           height: 10
                      ),
                ]),),

                    //
                    // Center(
                    //   child: NeoButton(
                    //     func: () async {
                    //       await loginVM.onPressedContinue(context);
                    //       // Navigator.push(
                    //       //     context,
                    //       //     MaterialPageRoute(
                    //       //         builder: (context) =>
                    //       //             DashboardView()));
                    //     },
                    //     title: localization.getLocaleData.continueText.toString(),
                    //     // side: BorderSide(
                    //     //     color: AppColor.primaryColor),
                    //     // textStyle: TextStyle(color: AppColor.white),
                    //   ),
                    // ),
                PrimaryButton(onPressed: ()async{
                await loginVM.onPressedContinue(context);
                },title: localization.getLocaleData.continueText.toString(),),
                     // Center(
                     //   child: InkWell(
                     //     onTap: ()async{
                     //       await loginVM.onPressedContinue(context);
                     //     },
                     //       child: Stack(
                     //         children: [
                     //           Center(
                     //             child: Padding(
                     //               padding: const EdgeInsets.only(bottom: 15.0),
                     //               child: Image.asset(themeProvider.darkTheme ?'assets/BtnDark.png':'assets/BtnLight.png'  ,
                     //
                     //               ),
                     //             ),
                     //           ),
                     //           Center(child: Padding(
                     //             padding: const EdgeInsets.only(top: 30.0),
                     //             child: Text(localization.getLocaleData.continueText.toString(),style: MyTextTheme.mediumWCB.copyWith(color: themeProvider.darkTheme ?Colors.white70:AppColor.greyDark),),
                     //           )),
                     //         ],
                     //       ),),
                     // ),

                     const SizedBox(height: 10,),
                    Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:"${localization.getLocaleData.agrrementTermsCondition}\n",
                              style: MyTextTheme.smallGCN.copyWith(
                                  color: AppColor.grey)),
                          TextSpan(
                              text: "${localization.getLocaleData.termsNdCondition} ",
                              style: MyTextTheme.smallGCB.copyWith(
                                  color: AppColor.grey)),
                          TextSpan(
                              text: "${localization.getLocaleData.and} ",
                              style: MyTextTheme.smallGCN.copyWith(
                                  color: AppColor.grey)),
                          TextSpan(
                              text: localization.getLocaleData.privacyPolicy.toString(),
                              style: MyTextTheme.smallGCB.copyWith(
                                  color: AppColor.grey))
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                const SizedBox(height: 10,),

              ],
            ),
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

    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message: localization.getLocaleData.areuSureYouWantToLogOut.toString(),
          buttonName: localization.getLocaleData.yes.toString(),
          onPressButton: () async {
            print('nnnnnnnvvvv');

            MyNavigator.pushAndRemoveUntil(context, const StartupPage());
            await userRepository.updateUserData(User());
            // await userRepository.logOutUser(context);
            print('nnnnnnnvvvv');
          },
        ));
  }
  countDown(){
    OtpViewModal otpVM = Provider.of<OtpViewModal>(context, listen: false);
    return   SlideCountdown(
        onDone: () => {
          otpVM.updateIsTimer=false
          // setState(() {
          //   timer = true;
          // }),
        },
        duration:  const Duration(seconds: 30,),
        // fade: false,
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(5)
        ),
        // textStyle: MyTextTheme.mediumBCN.copyWith(
        //     color: Colors.grey[600]
        // )
    );
  }
}
