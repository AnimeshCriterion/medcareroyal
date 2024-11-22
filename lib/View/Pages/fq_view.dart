

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/faq_data_modal.dart';
import '../../ViewModal/MasterDashoboardViewModal.dart';
import '../../ViewModal/faq_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'drawer_view.dart';

class FAndQView extends StatefulWidget {
  const FAndQView({super.key});

  @override
  State<FAndQView> createState() => _FAndQViewState();
}

class _FAndQViewState extends State<FAndQView> {
  ThemeProviderLd themeChangeProvider = new ThemeProviderLd();
  @override
  void initState() {
    super.initState();
    get();
  }
  get() async {
    FAQViewModal faqVM =
    Provider.of<FAQViewModal>(context, listen: false);
    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
    faqVM.questionid=[];
    faqVM.notifyListeners();
    await faqVM.getFAQListData(context);

  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    FAQViewModal faqVM =
    Provider.of<FAQViewModal>(context, listen: true);
    MasterDashboardViewModal masterVM =
    Provider.of<MasterDashboardViewModal>(context, listen: true);
      var themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          drawer: MyDrawer(),
          key: scaffoldKey,
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
           child: Padding(
             padding: const EdgeInsets.all(10.0),
             child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       InkWell(
                           onTap: () {
                             // scaffoldKey.currentState!.openDrawer();
                             Get.back();
                             masterVM.updateSelectedPage="";
                           },
                           child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme?AppColor.lightshadowColor1:Colors.grey,)

                       ),
                       Text(
                         localization.getLocaleData.faq.toString(),
                         style: MyTextTheme().largePCN.copyWith(
                             fontSize: 21,
                             height: 0,
                             color: themeChange.darkTheme == true
                                 ? AppColor.lightshadowColor1
                                 : Colors.grey.shade800,
                         fontWeight: FontWeight.w800
                         ),
                       ),

                     ],
                   ),
                   SizedBox(height: 10,),
                   PrimaryTextField(
                     controller: faqVM.searchC,
                     // controller:feedbackVm.emailC ,
                      borderColor: themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white,
                     onChanged: (val) async {
                       setState(() {});
                     },
                     suffixIcon: Icon(
                       Icons.search_rounded,
                       color: AppColor.grey,
                       size: 25,
                     ),
                     hintText: localization.getLocaleData.search.toString(),
                     hintTextColor: themeChange.darkTheme == true ?
                     Colors.grey.shade500 : Colors.grey.shade700,
                    backgroundColor:  themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.white,
                   ),
             SizedBox(height: 10,),
                   Expanded(
               child: ListView.builder(
                   itemCount: faqVM.getFaqList.length,
                   itemBuilder: (context, index) {
                     Answer faqdata=faqVM.getFaqList[index];
                     return
                          Container(
                           margin: const EdgeInsets.all(6),
                           decoration:  BoxDecoration(
                             color: themeChange.darkTheme?Colors.grey.shade300.withOpacity(0.6):Colors.grey.shade100.withOpacity(0.2),
                               borderRadius: BorderRadius.circular(20),
                               border: Border.all(color:  themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.grey.shade500.withOpacity(.5) ),
                               // gradient: LinearGradient(
                               //     begin: Alignment.topCenter,
                               //     end: Alignment.bottomCenter,
                               //     colors: [
                               //       themeChange.darkTheme?AppColor.neoBGGrey1:AppColor.white,
                               //       themeChange.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                               //     ]
                               // )
                           ),
                           child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.all(Radius.circular(20))) ,
                               collapsedShape: const RoundedRectangleBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(20))),
                             onExpansionChanged: (bool expanded){
                                 setState(() {
                                   faqVM.isExpanded = expanded;
                                 });
                               dPrint(val);
                                       faqVM.updateQuestionId=faqdata.questionID.toString();
                                       dPrint(int.parse(faqdata.questionID.toString()) );
                             },
                             backgroundColor:themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.grey.shade300.withOpacity(0.6),

                             collapsedBackgroundColor:themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.grey.shade300.withOpacity(0.6),
                             // backgroundColor:  themeChange.darkTheme?AppColor.black12.withOpacity(.9):Colors.grey,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(faqdata.optionText.toString(),style: MyTextTheme().smallBCN.copyWith(color:  themeChange.darkTheme == true
                                     ? AppColor.lightshadowColor1
                                     : Colors.grey.shade800,
                                 fontWeight: FontWeight.w600
                                 ),),
                               )
                             ],
                             trailing: Icon(
                               faqVM.getQuestionId.contains
                                 (faqdata.questionID.toString())?Icons.minimize_outlined:Icons.add,color:
                             themeChange.darkTheme == true
                                       ? AppColor.lightgreen13
                                       :   Colors.green,),
                             // trailing: Icon(
                             //  faqVM.getQuestionId.toString()==faqdata.questionID.toString()?Icons.minimize_outlined:Icons.add,
                             //   color:  themeChange.darkTheme == true
                             //       ? AppColor.lightgreen13
                             //       :   Colors.green,
                             //
                             // ),
                             title: Text("${index+1}. ${faqdata.questionName.toString()}",
                               style: MyTextTheme().mediumGCB.copyWith(color:  themeChange.darkTheme == true
                                   ? AppColor.lightshadowColor1
                                   : Colors.grey.shade600,),),
                           ),
                         );

                   },
               ),
             )

                 ]),
           ),
         ),
        ),
      ),
    );
  }
}
