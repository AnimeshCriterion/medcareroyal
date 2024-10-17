import 'dart:async';
import 'package:medvantage_patient/ViewModal/signup_view_modal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/custom_ink_well.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Localization/app_localization.dart';
import '../../app_manager/appBar/custom_app_bar.dart';
import '../../app_manager/web_view.dart';
import 'login_view.dart';

class SignUpVerifyView extends StatefulWidget {
  const SignUpVerifyView({Key? key}) : super(key: key);

  @override
  State<SignUpVerifyView> createState() => _SignUpVerifyViewState();
}

class _SignUpVerifyViewState extends State<SignUpVerifyView> {
  get() {
    SignUpViewModal signupVM =
        Provider.of<SignUpViewModal>(context, listen: false);
    signupVM.updateMobileNo = false;

    signupVM.clearData();
  }

  int _remainingSeconds = 0;

  late Timer _timer;

  @override
  void initState() {
    get();
    // _remainingSeconds = 30;
    _startTimer();

    // TODO: implement initState
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer.cancel();
            print('Timer is finished');
          }
        });
      },
    );
  }

  void _resetTimer() {
    _timer.cancel();
    print('nnnnnnnnnnnnn');
    setState(() {
      _remainingSeconds = 30;
    });
    _startTimer();
  }

  String dropdownValue = '+91';

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    SignUpViewModal signupVM =
        Provider.of<SignUpViewModal>(context, listen: true);
    return ColoredSafeArea(
        child: SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
              primaryBackColor:AppColor.greyDark ,
              actions: [
            // InkWell(
            //   onTap: () {},
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
            //     child: Text(
            //       localization.getLocaleData.help.toString()+"?",
            //       style: MyTextTheme.smallPCB,
            //     ),
            //   ),
            // )
          ]),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    localization.getLocaleData.signUp.toString(),
                    style: MyTextTheme.largeBCB
                        .copyWith(fontSize: 20, color: AppColor.greyDark),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    localization.getLocaleData.chooseProductAndExplore.toString(),
                    style: MyTextTheme.largeBCN
                        .copyWith(fontSize: 16, color: AppColor.greyDark),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: !signupVM.getMobileNo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Enter mobile number",
                        //   style: MyTextTheme.largeBCB.copyWith(color: AppColor.black12),
                        // ),
                        // PrimaryTextField(controller: signupVM.mobileNoC,
                        //   prefixIcon: Padding(
                        //     padding: const EdgeInsets.only(left: 10),
                        //     child: Text("+91",style: MyTextTheme.mediumGCN,),
                        //   ),)
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.grey,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                DropdownButton(
                                  elevation: 0,
                                  underline: SizedBox(),
                                  value: dropdownValue,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  items: signupVM.countryCode.map((items) {
                                    return DropdownMenuItem(
                                      value: items['code'],
                                      child: Text(
                                        items['code'],
                                        style: MyTextTheme.mediumGCN,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    print(value.toString());
                                    setState(() {
                                      dropdownValue = value.toString();
                                    });
                                  },
                                ),
                                VerticalDivider(
                                  width: 2,
                                  indent: 8,
                                  endIndent: 8,
                                  color: AppColor.lightBlack,
                                ),
                                Expanded(
                                    child: PrimaryTextField(
                                  style: MyTextTheme.mediumGCN,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return localization.getLocaleData.pleaseEnterNo.toString();
                                    } else if (value.length < 10) {
                                      return localization.getLocaleData.enterValidContact.toString();
                                    }
                                    return null;
                                  },
                                  controller: signupVM.mobileNoC,
                                  maxLength: 10,
                                  hintText: localization.getLocaleData.enterMobile.toString(),
                                  borderColor: Colors.transparent,
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                  // hintStyle: MyTextTheme.mediumGCN
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: signupVM.getMobileNo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.getLocaleData.confirmationForYourIdentity.toString(),
                          style: MyTextTheme.largeBCB
                              .copyWith(color: AppColor.black12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                         localization.getLocaleData.notificationMessage.toString(),
                          style: MyTextTheme.largeBCN
                              .copyWith(fontSize: 16, color: AppColor.greyDark),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        InkWell(
                          onTap: () {
                            signupVM.updateMobileNo = false;
                          },
                          child: Row(
                            children: [
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: signupVM.mobileNoC.text,
                                      style: MyTextTheme.mediumBCB
                                          .copyWith(color: AppColor.greyDark),
                                      children: [
                                        TextSpan(
                                            text: "    (",
                                            style: MyTextTheme.mediumWCN
                                                .copyWith(
                                                    color: AppColor.greyDark)),
                                        TextSpan(
                                            text: localization.getLocaleData.notYouText.toString()+"?",
                                            style: MyTextTheme.mediumPCB),
                                        TextSpan(
                                            text: ")",
                                            style: MyTextTheme.mediumWCN
                                                .copyWith(
                                                    color: AppColor.greyDark))
                                      ]))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          localization.getLocaleData.confirmMobileNo.toString(),
                          style: MyTextTheme.largeBCN
                              .copyWith(fontSize: 16, color: AppColor.greyDark),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          localization.getLocaleData.verificationCode.toString(),
                          style: MyTextTheme.largeBCN
                              .copyWith(color: AppColor.greyDark),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        PrimaryTextField(
                          keyboardType: TextInputType.number,
                          controller: signupVM.otpC,
                          hintText: localization.getLocaleData.enterOtp.toString(),
                        ),
                        _remainingSeconds == 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomInkWell(
                                      onTap: () {
                                        _resetTimer();
                                        signupVM.generateOTPForPatient(context);
                                      },
                                      child: Text(
                                        localization.getLocaleData.resendOtp.toString(),
                                        style: MyTextTheme.smallPCB,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      localization.getLocaleData.resendOtpIn.toString(),
                                      style: MyTextTheme.smallPCB,
                                    ),
                                    Icon(
                                      Icons.timer,
                                      size: 18,
                                      color: AppColor.primaryColor,
                                    ),
                                    Text(
                                      '$_remainingSeconds',
                                      style: MyTextTheme.smallPCB,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  Lottie.asset("assets/registration.json"),
                  SizedBox(
                      height: !signupVM.getMobileNo
                          ? MediaQuery.of(context).size.height / 10
                          : MediaQuery.of(context).size.height / 19),
                  PrimaryButton(
                      onPressed: () {
                        // _remainingSeconds = 30;

                        _resetTimer();

                        signupVM.onPressedVerifyAndOTP(context);
                      },
                      title: signupVM.getMobileNo ? localization.getLocaleData.verify.toString() : localization.getLocaleData.sendOtp.toString()),

                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    localization.getLocaleData.or.toString(),
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: AppColor.greyDark,
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: InkWell(
                    onTap: () {
                      MyNavigator.pushReplacement(context, LoginView());
                    },
                    child: Text(
                     localization.getLocaleData.loginWithMobile.toString(),
                      style: MyTextTheme.mediumPCB,
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                      localization.getLocaleData.agrrementTermsCondition.toString(),
                        style: MyTextTheme.smallGCN,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomInkWell(
                            onTap: () {
                              MyNavigator.push(
                                  context,
                                   WebViewPage(
                                    url:
                                        'https://medvantage_patient.in/Home/TermsCondition',
                                    title: localization.getLocaleData.termsNdCondition.toString(),
                                  ));
                            },
                            child: Text(
                             localization.getLocaleData.termsNdCondition.toString(),
                              style: MyTextTheme.smallGCB,
                            ),
                          ),
                          Text(
                            localization.getLocaleData.and.toString(),
                            style: MyTextTheme.smallGCN,
                          ),
                          CustomInkWell(
                              onTap: () {
                                MyNavigator.push(
                                    context,
                                 WebViewPage(
                                      url:
                                          'https://criteriontech.in/privacy-policy.html',
                                      title: localization.getLocaleData.privacyPolicy.toString(),
                                    ));
                              },
                              child: Text(
                                localization.getLocaleData.privacyPolicy.toString(),
                                style: MyTextTheme.smallGCB,
                              )),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    ));
  }
}
