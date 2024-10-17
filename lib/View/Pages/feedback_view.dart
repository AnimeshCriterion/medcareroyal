import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medvantage_patient/app_manager/theme/theme_provider.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../Localization/app_localization.dart';
import '../../ViewModal/MasterDashoboardViewModal.dart';
import '../../ViewModal/feedback_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/neomorphic/neomorphic.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/text_field/custom_sd.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import '../../theme/style.dart';
import 'drawer_view.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  ThemeProviderLd themeChangeProvider = new ThemeProviderLd();

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    FeedbackViewModal feedbackController =
    Provider.of<FeedbackViewModal>(context, listen: false);
    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();

    feedbackController.clearData();
    await feedbackController.getAllStatus(context);
  }


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    FeedbackViewModal feedbackVm =
    Provider.of<FeedbackViewModal>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChangeProvider.darkTheme, context);
    MasterDashboardViewModal masterDashboardViewModal =
    Provider.of<MasterDashboardViewModal>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(child: Scaffold(
        key: scaffoldKey,
        drawer: MyDrawer(),
        body: Container(
          decoration: BoxDecoration(
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                scaffoldKey.currentState!.openDrawer();
                              },
                              child: Image.asset(
                                  themeChange.darkTheme == true
                                      ? ImagePaths.menuDark
                                      : ImagePaths.menulight,
                                  height: 40)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.getLocaleData.add.toString().capitalizeFirst.toString(),
                                style: MyTextTheme().largePCB.copyWith(
                                    fontSize: 21,
                                    height: 0,
                                    color: themeChange.darkTheme == true
                                        ? Colors.white70
                                        : Colors.grey.shade600),
                              ),
                              Text(
                                localization.getLocaleData.feedback.toString() ,
                                style: MyTextTheme().largeBCB.copyWith(
                                    fontSize: 35,
                                    height: 1,
                                    color: themeChange.darkTheme == true
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(localization.getLocaleData.yourEmailRequired.toString(),
                            style: MyTextTheme().mediumGCN.copyWith(color:
                            themeChange.darkTheme ? Colors.grey : AppColor
                                .greyDark,fontSize: 13,fontWeight: FontWeight.w600

                            ),),
                          SizedBox(height: 10,),
                          PrimaryTextField(
                          backgroundColor:  themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white,
                            controller:feedbackVm.emailC ,
                            borderColor: themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white,
                            onChanged: (val) async {
                              feedbackVm.notifyListeners();
                            },
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: AppColor.grey,
                              size: 25,
                            ),
                            hintText: localization.getLocaleData.enterEmail.toString(),
                            hintTextColor: themeChange.darkTheme == true ?
                            Colors.grey.shade400 : Colors.grey,

                            // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                          ),
                          SizedBox(height: 10,),
                          Text(localization.getLocaleData.yourRating.toString(),
                            style: MyTextTheme().mediumGCN.copyWith(color:
                            themeChange.darkTheme ? Colors.grey : AppColor
                                .greyDark,fontSize: 13,fontWeight: FontWeight.w600),),
                          StaggeredGrid.count(crossAxisCount: 5,
                            children: [
                              ...List.generate(
                                  feedbackVm.EmojiList.length, (index) {
                                var emojiData = feedbackVm.EmojiList[index];
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),

                                      decoration: BoxDecoration(
                                        color: themeChange.darkTheme?AppColor.black12.withOpacity(.9):AppColor.white,
                                        borderRadius: BorderRadius.circular(8),

                                      ),
                                      child: InkWell(
                                          onTap: () {
                                            feedbackVm.updateSelectedId = emojiData["id"];
                                          },
                                          child:
                                          feedbackVm.getSelectedId!=emojiData["id"]?
                                                ColorFiltered(
                                                  colorFilter: ColorFilter.mode(

                                                    themeChange.darkTheme?AppColor.black12.withOpacity(.9):AppColor.white,
                                                    BlendMode.saturation ,
                                                  ),
                                                  child: ClipRRect(
                                                    child: Image.asset(emojiData["emoji"].
                                                    toString(),
                                                    ),
                                                  ) ,
                                                ):
                                          Image.asset(emojiData["emoji"]
                                                ),)),
                                );})

                            ],),
                          SizedBox(height: 15,),
                          Text(localization.getLocaleData.whatCanWeImprove.toString(),
                            style: MyTextTheme().mediumGCN.copyWith(
                                color: themeChange.darkTheme ? Colors.grey : AppColor.greyDark,
                              fontWeight: FontWeight.w600,
                                fontSize: 13
                            ),

                          ),
                          SizedBox(height: 10,),
                          // MyCustomSD(
                          //            listToSearch:[],
                          //            valFrom: 'name',
                          //            hideSearch: true,
                          //            borderColor: AppColor.greyDark,
                          //            label: 'Select Member',
                          //            onChanged: (val){
                          //              if(val!=null){
                          //                // stethoController.updateSelectedMemberId=val['memberId'].toString();
                          //              }
                          //            },),
                          CustomSD(

                            decoration: BoxDecoration(
                              color: themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white
                                  ,borderRadius: BorderRadius.circular(10)
                            ),
                            prefixIcon: Icons.account_tree_rounded,
                            iconColor: Colors.grey,
                            listToSearch: feedbackVm.getAllStatusData,
                            valFrom: 'remark',
                            // hideSearch: true,
                            borderColor: themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white,
                            label: localization.getLocaleData.selectModule.toString(),
                            labelStyle: MyTextTheme().mediumPCB.copyWith(color:themeChange.darkTheme?Colors.white:Colors.grey),
                            onChanged: (val) {
                              print('nnvnnvnnv' + val.toString());
                              if (val != null) {
                                feedbackVm.updateModuleId=val["id"]??0;
                                feedbackVm.notifyListeners();
                                // stethoController.updateSelectedMemberId = val;
                              }
                            },
                          ),
                          const SizedBox(height: 15,),
                          Text(localization.getLocaleData.yourFeedbackRequired.toString(),
                            style: MyTextTheme().mediumGCN.copyWith(color:
                            themeChange.darkTheme ? Colors.grey : AppColor
                                .greyDark,fontWeight: FontWeight.w600,fontSize: 13),),
                          const SizedBox(height: 15),
                          PrimaryTextField(maxLine: 10,
                            backgroundColor:  themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white,
                          controller: feedbackVm.feedbackC,
                            borderColor: themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white,
                            onChanged: (val) async {

                              feedbackVm.notifyListeners();
                            },
                            hintText: localization.getLocaleData.writeYourFeedbackHere.toString(),
                            hintTextColor: themeChange.darkTheme == true?
                            Colors.white : Colors.grey,

                            // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                          ),
                          SizedBox(height: 100,),
                        ],),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NeoButton(
                    width: 80,
                    func: () async {
                    await  feedbackVm.saveFeedbackData(context);
                    // feedbackVm. clearData();
                    },
                    title: localization.getLocaleData.submit.toString(),
                    textStyle: TextStyle(fontSize: 15,
                      color: themeChange.darkTheme?AppColor.green12:Colors.black),
                  ),
                ),
              ]),
        ),)),);}}
