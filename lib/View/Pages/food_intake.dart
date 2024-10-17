import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/ViewModal/food_intake_viewmodel.dart';
import 'package:medvantage_patient/ViewModal/supplement_intake_view_modal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:provider/provider.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/food_intake_data_moel.dart';
import '../../Modal/supplement_intake_modal.dart';
import '../../app_manager/appBar/custom_app_bar.dart';
import '../../app_manager/comman_widget.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/text_field/primary_date_time_field.dart';
import '../../assets.dart';
import '../../authenticaton/user_repository.dart';
import '../../theme/style.dart';
class FoodIntakeView extends StatefulWidget {
  const FoodIntakeView({Key? key}) : super(key: key);

  @override
  State<FoodIntakeView> createState() => _SupplementIntakeViewState();
}

class _SupplementIntakeViewState extends State<FoodIntakeView> {


  List temp=[
    'Mid Morning',
    'Lunch',
    'Evening Time',
    'Early Morning',
    'Dinner',
    'Breakfast',
    'Bed Time',
    'All day meals',
  ];


  get(context) async {
    FoodIntakeViewModel controller =
    Provider.of<FoodIntakeViewModel>(context, listen: false);
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    controller.nameC.text = userRepository.getUser.patientName.toString();
    controller.updateIntakeListResponse =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
       controller.dateC.text=DateTime.now().toString();
      await controller.apiCall(context);
    });
    print('nnnnnnnnnn${controller.getIntakeList.length}');
  }


  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      get(context);
    });
    // TODO: implement initState
    super.initState();
  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    FoodIntakeViewModel controller =
    Provider.of<FoodIntakeViewModel>(context, listen: true);

    return  ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(key: scaffoldKey,
          drawer: MyDrawer(),
          // appBar: CustomAppBar(
          //   title: localization.getLocaleData.dietChecklist.toString(),
          //     color: AppColor.primaryColor,
          //     titleColor: AppColor.white,
          //     primaryBackColor: AppColor.white
          // ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeChange.darkTheme
                      ? AppColor.darkshadowColor1
                      : AppColor.lightshadowColor1,
                  themeChange.darkTheme
                      ? AppColor.darkshadowColor1
                      : AppColor.lightshadowColor1,
                  themeChange.darkTheme ? AppColor.black :
                  AppColor.lightshadowColor2,
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
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
                          onTap: (){
                            scaffoldKey.currentState!.openDrawer();
                            },
                          child: Image.asset(
                              // themeChange.darkTheme==true?ImagePaths.menuDark:
                              themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(localization.getLocaleData.dietChecklist.toString(),
                            style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeChange.darkTheme==true?Colors.white70:null),),
                             ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryDateTimeField(
                   style: TextStyle(color:themeChange.darkTheme ?AppColor.white:AppColor.greyDark ),
                    backgroundColor:  themeChange.darkTheme ? AppColor.greyDark : AppColor.white,
                    controller:controller.dateC,
                    hintText: localization.getLocaleData.selectDate.toString(),
                    onChanged: (val) async {
                      controller.notifyListeners();
                      await controller.apiCall(context);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                controller.getDataList.isEmpty
                    ?  Expanded(child: Center(child: Text(localization.getLocaleData.dietNotAssigned.toString(),style: TextStyle(color: AppColor.green),)))
                    : Expanded(
                      child:CommonWidgets().showNoData(
                        title:localization.getLocaleData.noDataFound.toString(),
                        show: (controller.getShowNoData &&
                            (controller.getDataList
                                .isEmpty)),
                        loaderTitle: localization.getLocaleData.Loading.toString(),
                        showLoader: (!controller.getShowNoData  &&
                            (controller.getDataList
                                .isEmpty)),
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 35.0,
                    headingRowHeight: 40,
                    dataRowMaxHeight: 90,
                    border: TableBorder(
                          bottom: BorderSide(
                              width: 3,
                              color: themeChange.darkTheme
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300),
                          verticalInside: BorderSide(
                              width: 1,
                              color: themeChange.darkTheme
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300),
                          horizontalInside: BorderSide(
                              width: 1,
                              color: themeChange.darkTheme
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300)),
                    headingRowColor: MaterialStateProperty.resolveWith((states) {
                        // If the button is pressed, return green, otherwise blue
                        return themeChange.darkTheme
                            ?Colors.black54
                            : Colors.grey.shade400;
                    }),
                          // Adjust the spacing between columns
                          columns: [
                                  DataColumn(
                                  label: SizedBox(
                                      width: 100,
                                  child: Text(localization.getLocaleData.foodIntake.toString(),
                                      style: TextStyle(color:   themeChange.darkTheme
                                      ? AppColor.lightshadowColor2
                                      : AppColor.darkshadowColor2)))),
                            ...List<DataColumn>.generate(temp.length, (int index1)
                            {
                              var data = temp;
                              return DataColumn(
                                  label: SizedBox(
                                      width:   101,
                                      // index1 == 0 ? 200 : 70
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15,right: 15),
                                        child: Text(data[index1].toString(),style: TextStyle(color:   themeChange.darkTheme
                                        ? AppColor.lightshadowColor2
                                            : AppColor
                                            .darkshadowColor2)),
                                      ) )
                              );
                            })
                          ],
                          rows: List<DataRow>.generate(
                            controller.getDataList.length,
                                (int index2) {
                                  FoodIntakeDataModel data =
                              controller.getDataList[index2];
                              return DataRow(
                                  color:themeChange.darkTheme?
                                  MaterialStateProperty.all(index2/2==0||index2==0? Colors.grey.shade800:Colors.grey.shade700):
                                  MaterialStateProperty.all(index2/2==0||index2==0? Colors.white:AppColor.greyVeryLight),
                                  cells: [
                                    DataCell(
                                        SizedBox(
                                          width: 150, height: 61,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${data.foodName} ',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: themeChange.darkTheme
                                                        ? AppColor.lightshadowColor2
                                                        : AppColor
                                                        .darkshadowColor2)),
                                                  SizedBox(height: 2,),
                                                  Text("${data.foodQty!.toStringAsFixed(0)} ${data.unitName}",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                        color: themeChange.darkTheme
                                                            ? AppColor.lightshadowColor2
                                                            : AppColor
                                                            .darkshadowColor2),)
                                                ],
                                              ),
                                            ),
                                          )
                                    ),
                                    ...List.generate(temp.length , (index3) {
                                      return DataCell(
                                          data.foodGivenAt ==temp[index3]
                                              ? controller.iconAccordingToGivenStatus(context, data.isGiven.toString(),data,index3: index3)
                                              : const Center(
                                              child: Text(
                                                "--",
                                                textAlign: TextAlign.center,
                                              ))
                                      );
                                    })
                                  ]);
                            },
                          ),
                  ),
                ),
                        ),
                      ),
                    ),
                upperContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.orange,
                          size: 25,
                        ),
                        Text(
                          localization.getLocaleData.missed.toString(),
                          style: MyTextTheme.mediumWCB.copyWith(
                              color: themeChange.darkTheme
                                  ? Colors.grey.shade500
                                  : AppColor.darkshadowColor2),
                        ),
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        Text(
                          localization.getLocaleData.given.toString(),
                          style: MyTextTheme.mediumWCB.copyWith(
                              color: themeChange.darkTheme
                                  ? Colors.grey.shade500
                                  : AppColor.darkshadowColor2),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.access_time_filled,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        Text(
                          localization.getLocaleData.upcoming.toString(),
                          style: MyTextTheme.mediumWCB.copyWith(
                              color: themeChange.darkTheme
                                  ? Colors.grey.shade500
                                  : AppColor.darkshadowColor2),
                        ),
                      ],
                    )),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //middle dashboard
  SupplementIntakeTimeTable(){
    // ApplicationLocalizations localization =
    // Provider.of<ApplicationLocalizations>(context, listen: false);

    // SupplementIntakeViewModal supplementIntakeVM =
    // Provider.of<SupplementIntakeViewModal>(context, listen: true);

    return  Consumer<SupplementIntakeViewModal>(
        builder:  (BuildContext context, supplementIntakeVM,_) {
        return Consumer<ApplicationLocalizations>(
            builder:  (BuildContext context, localization,_) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          enabled: false,
                          controller: supplementIntakeVM.nameC,
                          hintText: localization.getLocaleData.name.toString(),
                          hintTextColor: AppColor.greyDark,
                          backgroundColor: AppColor.greyVeryLight,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: PrimaryDateTimeField(
                          hintText: localization.getLocaleData.selectDate.toString(),
                          hintTextColor: AppColor.greyDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: AppColor.green.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          Text(
                            localization.getLocaleData.FoodToBeTakenAsPerTheCircleBoxes.toString(),
                            style: MyTextTheme.mediumBCN
                                .copyWith(color: AppColor.greyDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.greyDark,
                          radius: 11,
                          child: CircleAvatar(
                            backgroundColor: AppColor.white,
                            radius: 10,
                            child: Center(
                                child: Icon(
                                  Icons.cancel,
                                  color: AppColor.red,
                                  size: 18,
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                              localization.getLocaleData.missed.toString(),
                              style: MyTextTheme.smallBCB,
                            )),
                        CircleAvatar(
                          backgroundColor: AppColor.greyDark,
                          radius: 11,
                          child: CircleAvatar(
                            backgroundColor: AppColor.white,
                            radius: 10,
                            child: Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColor.green,
                                  size: 18,
                                )),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(
                              localization.getLocaleData.given.toString(),
                              style:
                              MyTextTheme.smallBCB.copyWith(color: AppColor.greyDark),
                            )),
                        CircleAvatar(
                          backgroundColor: AppColor.greyDark,
                          radius: 11,
                          child: CircleAvatar(
                            backgroundColor: AppColor.white,
                            radius: 10,
                            child: Center(
                                child: Icon(
                                  Icons.watch_later,
                                  color: AppColor.blue,
                                  size: 18,
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          localization.getLocaleData.upcoming.toString(),
                          style:
                          MyTextTheme.smallBCB.copyWith(color: AppColor.greyDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.greyVeryLight,width: 1),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: [
                        Container(
                          color: AppColor.white,
                          height: 65,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                child: SizedBox(
                                    width: 70,
                                    child: Text(
                                      localization.getLocaleData.food.toString(),
                                      style: MyTextTheme.smallGCB,
                                    )),
                              ),
                              Expanded(
                                child: Row(
                                  children: List.generate(
                                      supplementIntakeVM.SupplementDate.length,
                                          (index) => Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                              supplementIntakeVM.SupplementDate[index]
                                              ['time']
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: MyTextTheme.smallGCB),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Text( DateTime.parse(myDate).difference(DateFormat('hh:mma').parse('11:00PM')).inSeconds.toString()),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: supplementIntakeVM.getIntakeList.length,
                          itemBuilder: (BuildContext context, int index) {
                            FoodListDataModel supplements =
                            supplementIntakeVM.getIntakeList[index];
                            return Container(
                              height: 70,
                              color: AppColor.white,
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                  child: SizedBox(
                                      width: 70,
                                      child: Text(
                                        supplements.foodName.toString(),
                                        style: MyTextTheme.smallGCB,
                                      )),
                                ),
                                const Expanded(
                                  child: Row(
                                      // children: List.generate(
                                      //     supplements.intakeDetails!.length, (index) {
                                      //   IntakeDetailModal intakeData =
                                      //   supplements.intakeDetails![index];
                                      //   return Expanded(
                                      //     child: InkWell(
                                      //       onTap: () {
                                      //         // if (intakeData.isExists == 0 &&
                                      //         //     intakeData.isDose == 1 &&
                                      //         //     DateFormat("hh:mma")
                                      //         //         .parse(DateFormat('hh:mma')
                                      //         //         .format(DateTime.now()))
                                      //         //         .difference(
                                      //         //         DateFormat("hh:mma")
                                      //         //             .parse(intakeData
                                      //         //             .intakeTime
                                      //         //             .toString()))
                                      //         //         .inMinutes >
                                      //         //         0) {
                                      //         //   modal.controller.updateFoodId =
                                      //         //       intakeData.foodId.toString();
                                      //         //   modal.controller
                                      //         //       .updateIntakeTimeForApp =
                                      //         //   intakeData.intakeTime as String;
                                      //         //   modal.controller.updateUnitId =
                                      //         //   intakeData.unitId as int;
                                      //         //   modal.controller.updateQuantity =
                                      //         //   intakeData.quantity as int;
                                      //         //   showAlertDialog(context);
                                      //         //   modal.controller.updateIsDose =
                                      //         //   intakeData.isDose as int;
                                      //         // }
                                      //         // modal.controller.updateIsExists=intakeData.isExists as int;
                                      //       },
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           intakeData.isDose == 1
                                      //               ? Column(
                                      //             mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //             children: [
                                      //               Container(
                                      //                 // width: MediaQuery.of(
                                      //                 //     context)
                                      //                 //     .size
                                      //                 //     .width /
                                      //                 //     17.5,
                                      //                   child:
                                      //                   intakeData.isExists == 1
                                      //                       ? customIcon(Icons.check_circle,'Missed'):
                                      //                   DateFormat("hh:mma")
                                      //                       .parse(DateFormat(
                                      //                       'hh:mma')
                                      //                       .format(DateTime
                                      //                       .now()))
                                      //                       .difference(DateFormat(
                                      //                       "hh:mma")
                                      //                       .parse(intakeData
                                      //                       .intakeTime
                                      //                       .toString()))
                                      //                       .inMinutes >
                                      //                       0
                                      //                       ?customIcon(Icons.cancel,'Given'):customIcon(Icons.watch_later,'upcoming')
                                      //
                                      //                 //       :Icon(
                                      //                 // intakeData.isExists == 1
                                      //                 //     ? Icons.check_circle
                                      //                 //     : DateFormat("hh:mma")
                                      //                 //                 .parse(DateFormat(
                                      //                 //                         'hh:mma')
                                      //                 //                     .format(DateTime
                                      //                 //                         .now()))
                                      //                 //                 .difference(DateFormat(
                                      //                 //                         "hh:mma")
                                      //                 //                     .parse(intakeData
                                      //                 //                         .intakeTime
                                      //                 //                         .toString()))
                                      //                 //                 .inMinutes >
                                      //                 //             0
                                      //                 //         ? Icons.circle_outlined
                                      //                 //         : Icons.watch_later,
                                      //                 // color: intakeData.isExists == 0
                                      //                 //     ? DateFormat("hh:mma")
                                      //                 //                 .parse(DateFormat(
                                      //                 //                         'hh:mma')
                                      //                 //                     .format(DateTime
                                      //                 //                         .now()))
                                      //                 //                 .difference(DateFormat(
                                      //                 //                         "hh:mma")
                                      //                 //                     .parse(intakeData
                                      //                 //                         .intakeTime
                                      //                 //                         .toString()))
                                      //                 //                 .inMinutes >
                                      //                 //             0
                                      //                 //         ? AppColor.black
                                      //                 //         : AppColor.primaryColor
                                      //                 //     : AppColor.green,)
                                      //               ),
                                      //               Visibility(
                                      //                 visible: intakeData.isExists == 1,
                                      //                 child: Text(
                                      //                   intakeData.isExists == 1
                                      //                       ? intakeData.unitName.toString()
                                      //                       : '',
                                      //                   overflow: TextOverflow.ellipsis,
                                      //                   style: const TextStyle(
                                      //                     fontSize: 7,
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           )
                                      //               : SizedBox(),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   );
                                      // })),
                                  )
                                )
                              ]),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                            height: 5,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  customIcon(IconData myicons,String iconsType) {
    return CircleAvatar(
      backgroundColor: AppColor.greyDark,
      radius: 11,
      child: CircleAvatar(
        backgroundColor: AppColor.white,
        radius: 10,
        child: Center(
            child: Icon(
              myicons,
              color: iconsType=='Missed'? AppColor.red: iconsType=='Given'? AppColor.red:AppColor.primaryColor,
              size: 19,
            )),
      ),
    );
  }


  upperContainer({required Widget child}) {
    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // final themecolor = style.themeData(themeChange.darkTheme, context);
    return Consumer<ThemeProviderLd>(
        builder:  (BuildContext context, themeChange,_) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  color: style.themeData(themeChange.darkTheme, context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
        // themecolor.hintColor,themecolor.primaryColor, themecolor.focusColor
                      themeChange.darkTheme? AppColor.darkshadowColor1 : AppColor.lightshadowColor1,

                      themeChange.darkTheme? Colors.black87 :AppColor.lightshadowColor2,
                      themeChange.darkTheme? Colors.black87 :AppColor.lightshadowColor2,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,spreadRadius: 1,
                      color: themeChange.darkTheme? AppColor.grey:Colors.grey,
                      offset: const Offset(
                        0,
                        10,
                      ),
        // blurRadius: 10.0,
                    ),
                  ],
                  border: Border.all(
                      color: themeChange.darkTheme
                          ? AppColor.darkshadowColor2
                          : AppColor.lightshadowColor2),
                  borderRadius: BorderRadius.circular(25)),
              child: child),
        );
      }
    );
  }
}
