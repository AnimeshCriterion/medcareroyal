
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import '../Localization/app_localization.dart';
import '../Localization/language_change_widget.dart';
import '../ViewModal/MasterDashoboardViewModal.dart';
import '../assets.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';
import '../theme/theme.dart';
import 'Pages/drawer_view.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    MasterDashboardViewModal masterDashboardViewModal =
    Provider.of<MasterDashboardViewModal>(context, listen: true);

    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: true);
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    var local=localization.getLocaleData;

    return ColoredSafeArea(
      color: AppColor.bgDark,
        child: Scaffold(
          key: scaffoldKey,
          drawer: const MyDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeChange.darkTheme
                      ? AppColor.neoBGGrey1
                      : AppColor.white,
                  themeChange.darkTheme
                      ? AppColor.neoBGGrey2
                      : AppColor.neoBGWhite2,
                ]),),
        child:  Column(
          children: [
            Row(children: [
              InkWell(
                  onTap: (){
                    scaffoldKey.currentState!.openDrawer();
                  },
                  child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
              Text(localization.getLocaleData.setting.toString().capitalizeFirst.toString(),style: themeChange.darkTheme?MyTextTheme.largeWCB:MyTextTheme.largeBCB,),
            ],),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                // MyNavigator.push(context, EditProfile());
                masterDashboardViewModal.updateSelectedPage =
                '${local.edit} ${local.profile}';
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color:
                  themeChange.darkTheme == false
                      ? AppColor.greyLight
                      : AppColor.greyLight),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        themeChange.darkTheme
                            ? AppColor.neoBGGrey1
                            : AppColor.white,
                        themeChange.darkTheme
                            ? AppColor.neoBGGrey2
                            : AppColor.neoBGWhite2,
                      ]),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
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
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                            height: 70,
                            width: 70,
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
                                .toString(),
                            style: MyTextTheme.largeBCN.copyWith(
                              color:
                              themeChange.darkTheme == false
                                  ? Colors.black87
                                  : AppColor.white,)
                          ),
                          Text(
                            userRepository.getUser.mobileNo
                                .toString(),
                            style: MyTextTheme.smallGCN.copyWith(
                                color:
                                themeChange.darkTheme == false
                                    ? Colors.black87
                                    : AppColor.white,),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color:

                themeChange.darkTheme == false
                    ? AppColor.greyLight
                    : AppColor.greyLight),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themeChange.darkTheme
                        ? AppColor.neoBGGrey1
                        : AppColor.white,
                    themeChange.darkTheme
                        ? AppColor.neoBGGrey2
                        : AppColor.neoBGWhite2,
                  ]),

            ),child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(local.application.toString(),style:  MyTextTheme.largeBCN.copyWith(
                  color:
                  themeChange.darkTheme == false
                      ? Colors.black87
                      : AppColor.white,),),
                const SizedBox(height: 10,),
                InkWell(

                    onTap: () async {
                      themeChange.darkTheme = !themeChange.darkTheme;
                      themeChange.darkTheme =
                          await themeChange.getTheme();
                    },

                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Image.asset(   themeChange.darkTheme?'assets/lighttheme.png':'assets/darkTheme.png'),

                        const SizedBox(width: 10),
                         Expanded(
                           child: Text(local.darkMode.toString(),style:  MyTextTheme.mediumGCN.copyWith(
                            color:
                            themeChange.darkTheme == false
                                ? Colors.black87
                                : AppColor.white,),),
                         ),
                        Image.asset(themeChange.darkTheme==false?'assets/SwitchOff.png':'assets/SwitchOn.png'),

                      ],
                    ),
                  ),
                ),
                SizedBox(child: Divider(color:
                themeChange.darkTheme == false
                    ? AppColor.greyLight
                    : AppColor.greyLight,indent: 0,endIndent: 0)),

                InkWell(
                  onTap: (){

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
                                          child: const Icon(Icons.close, color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      );

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Image.asset(   themeChange.darkTheme == false?'assets/langDark.png':'assets/langLight.png'),
                        const SizedBox(width: 10),
                        Text(local.language.toString(),
                          style:  MyTextTheme.mediumGCN.copyWith(
                          color:
                          themeChange.darkTheme == false
                              ? Colors.black87
                              : AppColor.white),

                        ),

                         const SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),

              ],
                        ),
            ),),
            const SizedBox(height: 10),

          ],
        ),
      ),
    ));
  }
}
