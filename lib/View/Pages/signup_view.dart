import 'package:medvantage_patient/View/Pages/siginup_verify_view.dart';
import 'package:medvantage_patient/View/Pages/startup_view.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Localization/app_localization.dart';
import '../../ViewModal/signup_view_modal.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/web_view.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../common_libs.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  get() {
    SignUpViewModal signupVM =
        Provider.of<SignUpViewModal>(context, listen: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    SignUpViewModal signupVM =
        Provider.of<SignUpViewModal>(context, listen: true);
    return ColoredSafeArea(
        child: SafeArea(
      child: Scaffold(
          backgroundColor: AppColor.white,
          appBar: CustomAppBar(actions: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: InkWell(onTap: (){
                MyNavigator.push(context,  WebViewPage(title: localization.getLocaleData.help.toString(),
                  url: 'https://medvantage_patient.in/Home/AboutUs',));
              },
                  child: Text(
                    localization.getLocaleData.help.toString(),
                style: MyTextTheme.smallPCB,
              )),
            )
          ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Form(key: signupVM.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      style: MyTextTheme.veryLargeBCN
                          .copyWith(fontSize: 20, color: AppColor.greyDark),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      localization.getLocaleData.enterName.toString(),
                      style: MyTextTheme.largeWCB
                          .copyWith(fontSize: 16, color: AppColor.black12),
                    ),
                    Text(
                     localization.getLocaleData.enterNameForAccount.toString(),
                      style: MyTextTheme.largeBCN
                          .copyWith(fontSize: 16, color: AppColor.greyDark),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    PrimaryTextField(
                      validator: (value) {
                        if(value!.isEmpty){
                          return localization.getLocaleData.pleaseFillName.toString() ;
                        }
                      },
                      hintText: localization.getLocaleData.enterName.toString(),
                      hintTextColor: AppColor.grey,
                      controller: signupVM.nameC,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(localization.getLocaleData.enterUserEmailAddress.toString(),
                      style: MyTextTheme.largeWCB
                          .copyWith(fontSize: 16, color: AppColor.black12),
                    ),
                    Text(localization.getLocaleData.usedForAccountRecovery.toString(),
                      style: MyTextTheme.mediumBCN
                          .copyWith(color: AppColor.greyDark),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    PrimaryTextField(validator: (value) {
                      if(value!.isEmpty){
                        return localization.getLocaleData.pleaseEnterEmail.toString();
                      }
                     else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!)){
                        return localization.getLocaleData.enterValidEmail.toString();


                      }
                    },
                      hintText: localization.getLocaleData.enterEmail.toString(),
                      hintTextColor: AppColor.grey,
                      controller: signupVM.emailC,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Text(localization.getLocaleData.enterMobileNo.toString(),
                      style: MyTextTheme.largeWCB
                          .copyWith(fontSize: 16, color: AppColor.black12),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    PrimaryTextField(
                      enabled: false,
                      hintText: localization.getLocaleData.enterMobileNo.toString(),
                      hintTextColor: AppColor.grey,
                      controller: signupVM.mobileNoC,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(localization.getLocaleData.enterPassword.toString(),
                      style: MyTextTheme.largeWCB
                          .copyWith(fontSize: 16, color: AppColor.black12),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    PrimaryTextField(
                      validator: (value) {
                      if(value!.isEmpty){
                        return localization.getLocaleData.pleaseEnterThePassword.toString();
                      }
                    },
                      hintText: localization.getLocaleData.enterPassword.toString(),
                      hintTextColor: AppColor.grey,
                      controller: signupVM.passwordC,
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    PrimaryButton(
                      onPressed: () async {

                      await  signupVM.onPressedSignUp(context);
                      },
                      title:localization.getLocaleData.signUp.toString(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                      localization.getLocaleData.or.toString(),
                      style: MyTextTheme.largeBCN.copyWith(
                        color: AppColor.black12,
                      ),
                    )),
                    Center(
                        child: InkWell(
                      onTap: () {
                        MyNavigator.pushReplacement(context, LoginView());
                      },
                      child: Text(
                        localization.getLocaleData.loginWithMobile.toString(),
                        style: MyTextTheme.largePCB.copyWith(fontSize: 16),
                      ),
                    )),

                    SizedBox(height: MediaQuery.of(context).size.height/20,),

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
                                MyNavigator.push(context,
                                WebViewPage(url: 'https://medvantage_patient.in/Home/TermsCondition',title: localization.getLocaleData.termsNdCondition.toString(),));


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
                                  MyNavigator.push(context,  WebViewPage(url: 'https://criteriontech.in/privacy-policy.html',title: localization.getLocaleData.privacyPolicy.toString(),));

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
            ),
          )),
    ));
  }
}
