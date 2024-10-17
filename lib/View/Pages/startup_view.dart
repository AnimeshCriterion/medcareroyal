import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/Localization/language_change_widget.dart';
import 'package:medvantage_patient/View/Pages/login_view.dart';
import 'package:medvantage_patient/View/Pages/siginup_verify_view.dart';
import 'package:medvantage_patient/View/Pages/signup_view.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/web_view.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../app_manager/widgets/buttons/primary_button.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../authenticaton/user_repository.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  get(){
    UserRepository userRepository = Provider.of<UserRepository>( context, listen: false);
  }
  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>( context, listen: true);
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          body: MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
            children: [
              // startUpScreen(context),
              Expanded(
                flex: 6,
                child: startUpScreen(context),
              ),

              Expanded(
                flex: 4,
                child: loginSignUpButton(context),
              ),

            ],
          )
              : Column(
            children: [
              // startUpScreen(context),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: startUpScreen(context),
              ),
              SizedBox(
                child: loginSignUpButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  changeLanguage(context) {
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
                      Navigator.of(context).pop();
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

  myList(context){


    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    return [
      {
        'img': 'assets/dashboard_image/doctor_lottie.json',
        'title':  localization.getLocaleData.consultWithDoctorCallChat
      },
      // {
      //   'img': 'assets/dashboard_image/doctor_checkup.json',
      //   'title':    localization.getLocaleData.findBookAppointment.toString(),
      // }
    ];
  }

  int currentIndex=0;

  startUpScreen(context){
    return  Container(
      color: AppColor.primaryColor,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (val){
                    setState(() {

                    });
                    currentIndex=val;
                  },
                  itemCount: myList(context).length,
                  itemBuilder: (BuildContext context, int index) {
                    var startUpData=myList(context)[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Lottie.asset(startUpData['img'].toString(),
                            fit: BoxFit.fitWidth,
                            width:MediaQuery.of(context).orientation==Orientation.landscape?200:320,
                            alignment: Alignment.center,
                          ),
                          Expanded(
                            child: Text(startUpData['title'].toString(),
                              style: MyTextTheme.mediumWCB.copyWith(fontSize: 16),
                            ),
                          ),

                        ],
                      ),
                    );
                  },),
              ),

              Container(
                height: 30,
                child: ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: myList(context).length,
                  itemBuilder: (BuildContext context, int index) {
                    var startUpData=myList(context)[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 6,
                        width: currentIndex==index? 30: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color:   AppColor.white,
                        ),
                      ),
                    );
                  },),
              ),
            ],
          ),
          // Positioned(top: 10,
          //   right: 10,
          //   child: InkWell(
          //     onTap: () {
          //       changeLanguage(context);
          //
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Icon(
          //         Icons.language,
          //         size: 28,
          //         color: AppColor.greyVeryLight,
          //       ),
          //     ),
          //   ),)
        ],
      ),
    );
  }

  // startUpScreen(context) {
  //   ApplicationLocalizations localization =
  //   Provider.of<ApplicationLocalizations>(context, listen: false);
  //   return Stack(children: [
  //     Row(
  //       children: [
  //         Expanded(
  //           child: Container(
  //             color: AppColor.transparent,
  //             child: IntroductionScreen(
  //               pages: [
  //                 PageViewModel(
  //                   useScrollView: false,
  //                   title: '',
  //                   useRowInLandscape: true,
  //                   bodyWidget: Column(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Text(
  //                         localization.getLocaleData.consultWithDoctorCallChat.toString(),
  //                         style: MyTextTheme.mediumWCB.copyWith(fontSize: 16),
  //                       ),
  //                     ],
  //                   ),
  //                   image: Lottie.asset(
  //                     'assets/dashboard_image/doctor_lottie.json',
  //                     fit: BoxFit.cover,
  //                     height: double.infinity,
  //                     width: double.infinity,
  //                     alignment: Alignment.center,
  //                   ),
  //                   decoration: getPageDecoration(),
  //                 ),
  //                 PageViewModel(
  //                   useRowInLandscape: true,
  //                   title: '',
  //                   useScrollView: false,
  //                   bodyWidget: Column(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Text(
  //                         localization.getLocaleData.findBookAppointment.toString(),
  //                         style: MyTextTheme.mediumWCB.copyWith(fontSize: 16),
  //                       ),
  //                     ],
  //                   ),
  //                   image: Lottie.asset(
  //                     'assets/dashboard_image/doctor_checkup.json',
  //                     fit: BoxFit.cover,
  //                     height: double.infinity,
  //                     width: double.infinity,
  //                     alignment: Alignment.center,
  //                   ),
  //                   decoration: getPageDecoration(),
  //                 ),
  //               ],
  //               showDoneButton: false,
  //               showSkipButton: false,
  //               showNextButton: false,
  //               isBottomSafeArea: true,controlsMargin:EdgeInsets.fromLTRB(10, 10, 10, 10) ,
  //               nextFlex: 0,
  //               dotsFlex: 0, controlsPadding: EdgeInsets.all(0),
  //               dotsDecorator: getDotDecoration(),
  //               animationDuration: 700,
  //               globalBackgroundColor: AppColor.primaryColor,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     Positioned(top: 10,
  //       right: 10,
  //       child: InkWell(
  //       onTap: () {
  //         changeLanguage(context);
  //
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Icon(
  //           Icons.language,
  //           size: 28,
  //           color: AppColor.greyVeryLight,
  //         ),
  //       ),
  //     ),)
  //   ],
  //
  //   );
  // }

  loginSignUpButton(context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Text(
        //       localization.getLocaleData.getStarted.toString(),
        //       style: TextStyle(color: AppColor.black),
        //     ),
        //   ],
        // ),
        SizedBox(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? 15
              : MediaQuery.of(context).size.height / 5.0,
        ),
        PrimaryButton(
          onPressed: () {
            MyNavigator.push(context, LoginView());
          },
          title: localization.getLocaleData.getStarted.toString(),
          textStyle: MyTextTheme.mediumWCB,
          color: AppColor.primaryColor,
        ),
        const SizedBox(
          height: 15,
        ),
        // PrimaryButton(
        //   onPressed: () {
        //     MyNavigator.push(context, SignUpVerifyView());
        //   },
        //   title: localization.localeData!.signUp.toString(),
        //   textStyle:
        //   MyTextTheme.mediumPCB.copyWith(color: AppColor.primaryColor),
        //   color: AppColor.white,
        //   borderColor: AppColor.primaryColor,
        // ),


        SizedBox(height: MediaQuery.of(context).size.height/13,),

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
                    MyNavigator.push(context,  WebViewPage(url: 'https://medvantage_patient.in/Home/TermsCondition',title: localization.getLocaleData.termsNdCondition.toString(),));


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
      ]),
    );
  }

  // void goToHome(context)=> Cus.replaceNavigate(context, const LogIn());
  DotsDecorator getDotDecoration() => DotsDecorator(
      color: const Color(0xFFBDBDBD),
      size: const Size(10, 10),
      activeSize: const Size(18, 10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ));

  PageDecoration getPageDecoration() => PageDecoration(
    footerPadding: EdgeInsets.all(0),imageFlex: 4, bodyFlex: 3,
    bodyAlignment: Alignment.bottomLeft,


    titleTextStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
    bodyTextStyle: const TextStyle(fontSize: 16),
    // descriptionPadding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0),
    imagePadding: const EdgeInsets.only(top:0),
    pageColor: AppColor.primaryColor,
  );
}
