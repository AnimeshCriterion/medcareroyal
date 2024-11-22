
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medvantage_patient/Modal/excercise_tracking_data_modal.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/exercise_video_data_modal.dart';
import '../../ViewModal/exercise_view_model.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import 'WorkoutDetails.dart';
import 'exercise_tracking_history_view.dart';

class ExerciseTrackingView extends StatefulWidget {
  const ExerciseTrackingView({super.key});

  @override
  State<ExerciseTrackingView> createState() => _ExerciseTrackingViewState();
}

class _ExerciseTrackingViewState extends State<ExerciseTrackingView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    ExerciseViewModel reportTrackingVM =
        Provider.of<ExerciseViewModel>(context, listen: false);
    await reportTrackingVM.getPatientMediaData(context);
    await reportTrackingVM.getAllExerciseVidoes(context);
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ExerciseViewModel reportTrackingVM =
        Provider.of<ExerciseViewModel>(context, listen: true);
    ApplicationLocalizations local =
    Provider.of<ApplicationLocalizations>(context, listen: false);
var localization=local.getLocaleData;
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    var dark = themeChange.darkTheme;
    return ColoredSafeArea(
      child: SafeArea(
        child:  Scaffold(
          key: scaffoldKey,
          drawer: const MyDrawer(),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              height: Get.height,
              decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                        dark?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                        dark?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                      ])
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                            child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text( localization.exerciseTracker.toString(),
                            style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 1,color: themeChange.darkTheme==true?Colors.white70:null),),
                        ),
                        const Expanded(child: SizedBox()),
                        InkWell(
                          onTap: (){
                            MyNavigator.push(context, const ExerciseTrackingHistoryView());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: themeChange.darkTheme?Image.asset("assets/exercise_tracker/history_light.png")
                                :Image.asset('assets/history2.png',),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PrimaryTextField(
                            backgroundColor:   dark?Colors.grey.shade800: Colors.grey.shade400.withOpacity(0.9),
                            borderColor: Colors.transparent,
                            hintText: localization.searchExerciseIEWalkingCycling.toString(),  suffixIcon: Icon(Icons.search,size: 25,color:dark?Colors.white70:Colors.grey.shade600,),
                            controller: reportTrackingVM.searchc,
                            hintTextColor:    dark?Colors.white70:Colors.grey.shade600,
                            style: TextStyle(color: dark?Colors.white:Colors.black),
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                      itemCount: reportTrackingVM.getExerciseList.length,
                      itemBuilder: (context, int index) {
                        ExerciseTrackingDataModal data =
                            reportTrackingVM.getExerciseList[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient:  LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                colors: [
                                  dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                                  dark?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                                  dark?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                                ]
                              ),
                                border: Border.all(color:dark?Colors.grey.shade700: Colors.grey.shade400),
                                boxShadow:  [
                                  BoxShadow(color:dark?Colors.transparent:Colors.grey.shade400,offset: const Offset(0,5),spreadRadius: 1,blurRadius: 10),
                                ],
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                              child: Row(
                                children: [Image.asset(themeChange.darkTheme? "assets/exercise_tracker/${data.activityName.toString().toLowerCase()}_dark.png":"assets/exercise_tracker/${data.activityName.toString().toLowerCase()}_light.png"),
                                  SizedBox(width: 5),
                                  Expanded(
                                      child: Text(data.activityName.toString(),style: MyTextTheme.mediumGCB.copyWith(color:   dark?Colors.white70:null),)),
                                  const SizedBox(width: 10),
                                  InkWell(
                                      onTap: () {
                                        showBottomSheetDialog(
                                            context, data, reportTrackingVM,dark);
                                        // reportTrackingVM.insertExercise(context,data.id.toString());
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),
                                        color: Colors.green
                                        ),
                                        child:  Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
                                          child: Text(
                                            localization.add.toString(),style:MyTextTheme.mediumWCB,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),


                  Visibility(
                    visible: reportTrackingVM.getExerciseVideos.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(localization.exerciseVideos.toString(),
                                      style: MyTextTheme.mediumGCN.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.greyDark,fontWeight: FontWeight.w700)
                                      // TextStyle(
                                      //     fontSize: 15, color:   dark?Colors.white:AppColor.black,fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  InkWell(
                                    onTap: (){
                                      MyNavigator.push(context,    AllExercisePage());

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(localization.viewAll.toString(),
                                        style: TextStyle(
                                            fontSize: 15, color:   AppColor.green),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            Visibility(
                              visible: reportTrackingVM.getExerciseVideos.isNotEmpty,
                              child: SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  itemCount: reportTrackingVM.getExerciseVideos.length,
                                  //itemCount: 5,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    ExerciseVideos response =
                                        reportTrackingVM.getExerciseVideos[index];
                                    return InkWell(
                                      onTap: (){
                                        dPrint('nnnnn');
                                    MyNavigator.push(context,    WorkOutDetails(response:response));



                                    // App().navigate(context, WorkOutDetails(response:response));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10.0,left: 8,right: 8),
                                        child: SizedBox(
                                          height: 107,
                                          width: 200,
                                          child: CachedNetworkImage(
                                            imageUrl:"https://nutrianalyser.com:313/FileUpload/Thumbnail/${response.thumbnailURL}",
                                            imageBuilder: (context, imageProvider) => Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.black38,
                                                              borderRadius: BorderRadius.circular(5.0)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  '${response.activityName} ',
                                                                  style: TextStyle(color: AppColor.white),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            placeholder: (context, url) =>Container(
                                              decoration:  BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                color: AppColor.green,
                                              ),
                                              // child: Image.asset(
                                              //   "assets/" + ImageConstant().defaultBlogImage.toString(),
                                              //   fit: BoxFit.cover,
                                              // )
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.black54,
                                                              borderRadius: BorderRadius.circular(5.0)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  response.activityName.toString(),
                                                                  style: TextStyle(color:AppColor.white,),
                                                                ),
                                                                // const SizedBox(height: 5),
                                                                // Text(
                                                                //   response.exerciseName.toString(),
                                                                //   style: TextStyle(color: AppColor.white,),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              decoration:  BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                  color: AppColor.primaryColor,
                                              ),
                                              // child: Image.asset(
                                              //   "assets/" + ImageConstant().defaultBlogImage.toString(),
                                              //   fit: BoxFit.cover,
                                              // )
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.black54,
                                                              borderRadius: BorderRadius.circular(5.0)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  response.activityName.toString(),
                                                                  style: TextStyle(color:AppColor.white,),
                                                                ),
                                                                // const SizedBox(height: 5),
                                                                // Text(
                                                                //   response.exerciseName.toString(),
                                                                //   style: TextStyle(color: AppColor.white,),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );



                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheetDialog(BuildContext context,
      ExerciseTrackingDataModal data, ExerciseViewModel reportTrackingVM,dark) {
    TextEditingController textEditingController = TextEditingController();
    ApplicationLocalizations local =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    var localization=local.getLocaleData;
    CustomBottomSheet.open(context,child: Container(
      decoration: BoxDecoration(
        color:dark? AppColor.neoBGGrey2: AppColor.neoBGWhite2,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "How long did you do ${data.activityName.toString()} exercise?",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:dark?AppColor.white : AppColor.black),
            ),
            const SizedBox(height: 40),
            PrimaryTextField(
              prefixIcon: Icon(Icons.access_time_filled, color: AppColor.grey),
              maxLength: 3,
              backgroundColor: Colors.white,
              borderColor: Colors.transparent,
              keyboardType:TextInputType.number ,
              controller: textEditingController,
              hintText: localization.enterTimeInMin.toString(),
              hintTextColor: Colors.grey,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    color:  AppColor.grey,
                    onPressed: () async {
                      // Handle the text input (save or process it)
                      String text = textEditingController.text;
                      dPrint('You entered: $text');
                      Get.back();
                      await  reportTrackingVM.insertExercise(
                          context, data.id, text.toString());
                      // Navigator.of(context).pop();
                    },
                    title: localization.cancel.toString(),
                  ),
                ), const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    color:  Colors.green,
                    onPressed: () async {
                      // Handle the text input (save or process it)
                      String text = textEditingController.text;
                      dPrint('You entered: $text');
                      Get.back();
                    await  reportTrackingVM.insertExercise(
                          context, data.id, text.toString());
                    },
                    title: localization.save.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    // showModalBottomSheet(
    // //   context: context,
    //   isScrollControlled: true,
      // Allows the sheet to take up the full screen height

    );
  }
}

class AllExercisePage extends StatefulWidget {
  const AllExercisePage({super.key});

  @override
  State<AllExercisePage> createState() => _AllExercisePageState();
}

class _AllExercisePageState extends State<AllExercisePage>  {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    ExerciseViewModel reportTrackingVM =
    Provider.of<ExerciseViewModel>(context, listen: false);
    reportTrackingVM.videosSearchC.clear();
    reportTrackingVM.notifyListeners();
  }
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations local =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    var localization=local.getLocaleData;
    ExerciseViewModel reportTrackingVM =
    Provider.of<ExerciseViewModel>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    var dark = themeChange.darkTheme;
    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
                title:  Text(localization.exercise.toString()),
                backgroundColor: dark?AppColor.neoBGGrey1: AppColor.neoBGWhite1,
                foregroundColor: dark?AppColor.white:null
            ),
            body: Container(
              height: Get.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                        dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                      ])
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PrimaryTextField(
                            backgroundColor: dark?Colors.grey.shade800: Colors.grey.shade400.withOpacity(0.9),
                            borderColor: Colors.transparent,
                            hintText: localization.exerciseVideos.toString(),
                            controller: reportTrackingVM.videosSearchC,
                            hintTextColor:    dark?Colors.white70:Colors.grey.shade600,
                            style: TextStyle(color: dark?Colors.white:Colors.black),
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Visibility(
                      visible: reportTrackingVM.getExerciseVideos.isNotEmpty,
                      child: GridView.builder(
                        itemCount: reportTrackingVM.getExerciseVideos.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),

                        itemBuilder: (BuildContext context, int index) {
                          ExerciseVideos response = reportTrackingVM.getExerciseVideos[index];
                          return InkWell(
                            onTap: () {
                              dPrint('nnnnn');
                              MyNavigator.push(context, WorkOutDetails(response:response));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: CachedNetworkImage(
                                  imageUrl: "https://nutrianalyser.com:313/FileUpload/Thumbnail/${response.thumbnailURL}",
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${response.activityName} ${response.exerciseName}',
                                                  style: TextStyle(color: AppColor.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  response.activityName.toString(),
                                                  style: TextStyle(color:AppColor.white,),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  response.exerciseName.toString(),
                                                  style: TextStyle(color: AppColor.white,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  response.activityName.toString(),
                                                  style: TextStyle(color:AppColor.white,),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  response.exerciseName.toString(),
                                                  style: TextStyle(color: AppColor.white,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

