
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/ViewModal/MasterDashoboardViewModal.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_date_time_field.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/symptoms_problem_data_modal.dart';
import '../../ViewModal/symptoms_tracker_view_modal.dart';
import '../../app_manager/comman_widget.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../medcare_utill.dart';
import 'drawer_view.dart';

class SymptomTracker extends StatefulWidget {
  final bool? throughVoice;
  const SymptomTracker({Key? key,  this.throughVoice}) : super(key: key);

  @override
  State<SymptomTracker> createState() => _SymptomTrackerState();
}

class _SymptomTrackerState extends State<SymptomTracker> {
  get(context) async {
    SymptomsTrackerViewModal symptomtrackerVM = Provider.of<SymptomsTrackerViewModal>(context, listen: false);
    await symptomtrackerVM.clearData();
    if(widget.throughVoice!=true || widget.throughVoice == null){
       symptomtrackerVM.symptomsAdded.clear();
       await symptomtrackerVM.getHomeCareSymtoms(context);
    }
    await symptomtrackerVM.getProblemWithIcon(context);
    await symptomtrackerVM.getSymptomsTrackerSuggestProblem(context);
    await symptomtrackerVM.getPatientAllProblems(context);

  }

  @override
  void initState() {
    SymptomsTrackerViewModal symptomtrackerVM = Provider.of<SymptomsTrackerViewModal>(context, listen: false);

    // TODO: implement initState
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      get(context);

    });_scrollController = ScrollController();
    super.initState();
    if(widget.throughVoice==true){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for(int i =0;i<symptomtrackerVM.symptomsVoiceList.length;i++){
        dPrint('loop working');
        // symptomtrackerVM.symptomsAdded.add(SymptomsProblemModal(
        //     problemId: symptomtrackerVM.symptomsVoiceList[i]['id'],
        //     problemName: symptomtrackerVM.symptomsVoiceList[i]['symptom'])
        // );

        symptomtrackerVM.updateAddedSymptomsList = {'problemId': symptomtrackerVM.symptomsVoiceList[i]['id'].toString(),'problemName': symptomtrackerVM.symptomsVoiceList[i]['symptom'].toString()};
        symptomtrackerVM.symptomsAdded.add(SymptomsProblemModal(
            problemId: symptomtrackerVM.symptomsVoiceList[i]['id'],
            problemName: symptomtrackerVM.symptomsVoiceList[i]['symptom'].toString()));
        dPrint("SYMPTOMS TRACKER LIST ${symptomtrackerVM.symptomsAdded.length}");
        dPrint("length"+symptomtrackerVM.getAddedSymptomsList.length.toString());
        symptomtrackerVM.updateSelectedSymptomProblem = SymptomsProblemModal(
            problemId: symptomtrackerVM.symptomsVoiceList[i]['id'],
            problemName: symptomtrackerVM.symptomsVoiceList[i]['symptom'].toString());
      }
      // symptomtrackerVM.symdateC.text=DateTime.now().toString();
      // symptomsDate(context);
      // symptomtrackerVM.getHomeCareSymtoms(context);

      });

    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController = ScrollController();

    super.dispose();
  }

  late ScrollController _scrollController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SymptomsTrackerViewModal symptomtrackerVM =
    Provider.of<SymptomsTrackerViewModal>(context, listen: true);
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    final themeProvider = Provider.of<ThemeProviderLd>(context, listen: true);
    MasterDashboardViewModal masterDashboardViewModal =
    Provider.of<MasterDashboardViewModal>(context, listen: true);


    return ColoredSafeArea(
    child: SafeArea(
      child: Scaffold(
         key:   scaffoldKey,
        drawer: const MyDrawer(),
        // resizeToAvoidBottomInset: false,
        backgroundColor: themeProvider.darkTheme ?AppColor.black:AppColor.white,
        // appBar: CustomAppBar(
        //   title:localization.getLocaleData.symptomTracker.toString(),color: AppColor.primaryColor,
        //     titleColor: AppColor.white,
        //     primaryBackColor: AppColor.white
        // ),
        body: Container (
          // decoration: BoxDecoration(

          //   gradient: LinearGradient(
          //     begin: Alignment.bottomCenter,
          //     end: Alignment.topCenter,
          //     colors: [
          //       themeProvider.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
          //       themeProvider.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
          //       themeProvider.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
          //       themeProvider.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
          //       themeProvider.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
          //     ]
          //   )
          // ),
          child: Column(
            children: [

              // Row(crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     // InkWell(
              //     //   onTap: (){
              //     //      Get.back();
              //     //   },
              //     //   child: Padding(
              //     //     padding: const EdgeInsets.all(8.0),
              //     //     child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? Colors.white:Colors.grey,),
              //     //   ),
              //     // ),
              //     InkWell(
              //         onTap: (){
              //           scaffoldKey.currentState!.openDrawer();
              //         },
              //         child: Image.asset(themeProvider.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
              //     Column(crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(localization.getLocaleData.symptoms.toString(),
              //           style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeProvider.darkTheme==true?Colors.white70:null),),
              //         Text('Tracker',style:MyTextTheme.largeBCB.copyWith(fontSize: 25,height: 1,color: themeProvider.darkTheme==true?Colors.white:Colors.black),),
              //       ],
              //     ),
              //   ],
              // ),

              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                    children: [
                  SelectSymptom(),
                      const SizedBox(height: 20),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:  themeProvider.darkTheme==true?AppColor.transparent:AppColor.neoBGWhite1,
                        offset: const Offset(0,-20),
                        spreadRadius: 3,blurRadius: 10
                      )
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   child: NeoConcaveButton(
                      //       func: () async {
                      //
                      //         masterDashboardViewModal.updateSelectedPage='Update Symptoms';
                      //         // MyNavigator.push(context, const SymptomTrackerView());
                      //
                      //   }, title:localization.getLocaleData.trackSymptom.toString()),
                      // ),
                      // const SizedBox(width: 15),
                      Expanded(
                        child: NeoButton(
                          func: () async {
                          // if(symptomtrackerVM.addedSymptoms.length==0){
                          //   Alert.show("Please select any symptoms");
                          // }else{
                            dPrint("SYMPTOMS ADDED LENGTH ${symptomtrackerVM.symptomsAdded.length}");
                          if(symptomtrackerVM.symptomsAdded.isEmpty){
                            dPrint("length ${symptomtrackerVM.getSymptomHistory.length}");
                           // Alert.show(localization.getLocaleData.pleaseSelectSymptomsFirst.toString());
                            if( symptomtrackerVM.getSymptomHistory.isNotEmpty)
                            {
                              dPrint("dPring ERRRRRRRRR00000000 ");
                                      symptomtrackerVM.inputVital2(context);
                            }
                            else{

                              Get.showSnackbar( MySnackbar.ErrorSnackBar(  message:  'Please select symptoms'.toString()));
                              // alertToast(context, 'Please select symptoms');
                            }
                          }
                          else{
                            dPrint("dPring ERRRRRRRR111111");
                            symptomtrackerVM.symdateC.text=DateTime.now().toString();
                            symptomtrackerVM.notifyListeners();
                            await symptomsDate(context);
                            // await symptomtrackerVM.onPressedSave(context);
                          }
                          // }
                        }, title:symptomtrackerVM.symptomsAdded.isNotEmpty? localization.getLocaleData.saveSymptoms.toString():
                        symptomtrackerVM.getSymptomHistory.isNotEmpty? localization.getLocaleData.saveTrackSymptoms.toString():localization.getLocaleData.save.toString(),
                          textStyle: MyTextTheme.mediumBCN.copyWith(color:
                          themeProvider.darkTheme? AppColor.black:AppColor.white,
                          fontWeight:FontWeight.w600),
                        ),
                      ),
                      // Expanded(
                      //   child: PrimaryButton(
                      //       color: AppColor.darkYellow,
                      //       onPressed: () {
                      //         MyNavigator.push(context, const UpdateSymptomsView());
                      //       },
                      //       title:localization.getLocaleData.viewReport.toString()),
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  symptomsDate(context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return Consumer<ThemeProviderLd>(
            builder:  (BuildContext ___context, themeChange,_) {
            return AlertDialog(backgroundColor: themeChange.darkTheme
                ? AppColor.black
                : AppColor.white,
              title:Consumer<SymptomsTrackerViewModal>(
                  builder:  (BuildContext __context, symptomsVM,_) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text(localization.getLocaleData.selectSymptomsDate.toString(),textAlign: TextAlign.center,style:
                        themeChange.darkTheme
                            ? MyTextTheme.largeWCB
                            :  MyTextTheme.largeBCB,),
                        SizedBox(height: 15,),
                        PrimaryDateTimeField( style:  themeChange.darkTheme
                            ? MyTextTheme.mediumWCB
                            :  MyTextTheme.mediumBCB,
                            backgroundColor: themeChange.darkTheme
                                ? AppColor.black
                                : AppColor.white,
                            controller: symptomsVM.symdateC,
                            dateTimePickerType:DateTimePickerType.dateTime ),

                        SizedBox(height: 15,),
                        NeoButton(func:  () async {

                          Get.back();
                          await symptomsVM.onPressedSave(context);
                          // await symptomsVM.addMemberProblem(context);
                          // await symptomsVM.getPatientLastVital(context);
                        },  title:  localization.getLocaleData.saveSymptoms.toString(),
                          textStyle: MyTextTheme.mediumGCN.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: themeChange.darkTheme
                                ? AppColor.black
                                : AppColor.white,
                          ),)
                      ],
                    );
                  }
              ),
              contentPadding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                side: BorderSide(color:themeChange.darkTheme
                    ? AppColor.green
                    : AppColor.green, ),
                borderRadius: BorderRadius.circular(15.0),
              ),
            );
          }
        );
      },
    );
  }
  SearchSymptom() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    SymptomsTrackerViewModal symptomtrackerVM =
    Provider.of<SymptomsTrackerViewModal>(context, listen: true);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextField(
                hintTextColor:themeChange.darkTheme==true?Colors.white70:Colors.grey.shade400,
                backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                onChanged: (val) async {
                  // await symptomtrackerVM.getPatientAllProblems(context);
                  symptomtrackerVM.updateTempProblemList=symptomtrackerVM.getProblemList;
                  setState(() {});
                  dPrint("dddddddddd"+symptomtrackerVM.getProblemList.toString());
                },
                controller: symptomtrackerVM.searchC,
                borderColor:themeChange.darkTheme==true?Colors.transparent:Colors.grey.shade300,
                suffixIcon: Icon(
                  Icons.search,
                  color: AppColor.grey,
                  size: 28,
                ),
                style: TextStyle(color: themeChange.darkTheme==true?
                Colors.white70:AppColor.black),
                hintText: localization.getLocaleData.searchSymptomColdCough.toString(),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
            // color: AppColor.lightPink,
              border: Border.all(color: AppColor.greyVeryLight),
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
          height: symptomtrackerVM.searchC.text.isEmpty ? 0 : 200,
          width: double.infinity,
          child: Center(
              child: symptomtrackerVM.getProblemList.isEmpty
                  ? Text(
                localization.getLocaleData.listIsEmpty.toString(),
                style: MyTextTheme.mediumGCB,
              )
                  : Scrollbar(
                thumbVisibility: true,
                thickness: 1,
                radius: const Radius.circular(10),
                scrollbarOrientation: ScrollbarOrientation.right,
                child: ListView.builder(
                  itemCount: symptomtrackerVM.getTempProblemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomInkWell(
                      onTap: () async {
                        dPrint("ali mz ");
                        await symptomtrackerVM.changeIsVisible(context,index,
                            symptomtrackerVM.getTempProblemList[index]);

                        symptomtrackerVM.searchC.clear();
                        symptomtrackerVM.updateTempProblemList=[];
                        FocusScope.of(context).unfocus();
                        symptomtrackerVM.notifyListeners();

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          color:
                          symptomtrackerVM.getAddedSymptomsList.map((e) => e['problemId'].toString()).toList().
                          contains(symptomtrackerVM.getTempProblemList[index]['id'].toString())
                              ? AppColor.green
                              :themeChange.darkTheme==true? Colors.transparent:Colors.grey.shade300,

                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              symptomtrackerVM.getTempProblemList[index]
                              ["symptoms"]??'',
                              style:  symptomtrackerVM.getAddedSymptomsList.map((e) => e['problemId'].toString()).toList().
                              contains(symptomtrackerVM.getTempProblemList[index]['id'].toString())?
                              MyTextTheme.mediumWCB:themeChange.darkTheme==true?
                              MyTextTheme.mediumWCB:MyTextTheme.mediumGCB,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                children: List.generate(symptomtrackerVM.getAddedSymptomsList.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(4.0,0,4,0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:  AppColor.green),
                          child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SizedBox(width: 5,),
                              Text(
                                symptomtrackerVM.getAddedSymptomsList[index]
                                ["problemName"]
                                    .toString(),
                                style: MyTextTheme.mediumWCB,
                              ),
                              CustomInkWell(
                                  onTap: () {
                                    symptomtrackerVM.removeListData(index, symptomtrackerVM.getAddedSymptomsList[index]["problemId"]);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: AppColor.white,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SelectSymptom() {


    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return
      Consumer<SymptomsTrackerViewModal>(
          builder:  (BuildContext context, symptomtrackerVM,_) {
          return Consumer<ThemeProviderLd>(
              builder:  (BuildContext context, themeChange,_) {
              return Consumer<ApplicationLocalizations>(
                  builder:  (BuildContext context, localization,_) {

                  return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
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
                           Column(crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(localization.getLocaleData.symptomsTracker.toString(),
                                 style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeChange.darkTheme==true?Colors.white70:null),),
                               // Text(localization.getLocaleData.symptomsTracker.toString(),style:MyTextTheme.largeBCB.copyWith(fontSize: 25,height: 1,color: themeChange.darkTheme==true?Colors.white:Colors.black),),
                             ],
                           ),
                        ],
                       ),
                       const SizedBox(
                        height: 10,
                      ),

                      SearchSymptom(),

                      Text(localization.getLocaleData.highlightSymptoms.toString(),
                        // localization.getLocaleData.selectSymptomsWhichYouAreSufferingFrom.toString(),
                        style: MyTextTheme.largeSCN
                            .copyWith(color: themeChange.darkTheme==true?Colors.white60:AppColor.greyDark,
                             fontSize: 14,fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CommonWidgets().showNoData(
                        title: localization.getLocaleData.noDataFound.toString(),
                        show: (symptomtrackerVM.getShowNoData &&
                            symptomtrackerVM.getSymptomsTrackerProblemList
                                .isEmpty),
                        loaderTitle:  localization.getLocaleData.Loading.toString(),
                        showLoader: (!symptomtrackerVM.getShowNoData  &&
                            symptomtrackerVM.getSymptomsTrackerProblemList
                                .isEmpty),
                        child: StaggeredGrid.extent(
                          maxCrossAxisExtent: 150,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children:
                        List.generate(symptomtrackerVM.getSymptomsTrackerProblemList.length, (index) {
                          SymptomsProblemModal problemsData = symptomtrackerVM.getSymptomsTrackerProblemList[index];
                          return  InkWell(
                            onTap: () async {
                              dPrint('yesss');
                              await symptomtrackerVM.onPressedSymptoms(index: index, selectedSymptoms: problemsData, context: context);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Center(
                                  child: Container(
                                    height:(Get.width-26)/4,
                                    width:(Get.width-26)/2,
                                    // padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color:
                                      symptomtrackerVM.getSelectedMoreSymptomAttribute.map((e) =>
                                          e.id.toString()).toList().contains(problemsData.problemId.toString())?AppColor.neoGreen:(themeChange.darkTheme==true?Colors.grey.shade800:Colors.grey.shade400)),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color:themeChange.darkTheme==true?Colors.transparent: Colors.grey.shade300,
                                      //     offset: const Offset(5,5),
                                      //     blurRadius: 5,
                                      //   ),
                                      // ],
                                      // gradient: LinearGradient(
                                      //     begin: Alignment.bottomCenter,
                                      //     end: Alignment.topCenter,
                                      //     colors: [
                                      //       themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                                      //       themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.white,
                                      //       themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.white,
                                      //       themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.white,
                                      //       themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.white,
                                      //     ]
                                      // ),
                                      borderRadius:BorderRadius.circular(10),
                                      // color: AppColor.white
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 3,),
                                        // CachedNetworkImage(
                                        //   imageUrl:'',
                                        //   // problemsData.displayIcon.toString(),
                                        //   placeholder: (context, url) =>
                                        //       Image.asset('assets/symptoms_tracker/${problemsData.problemName.toString()}'),
                                        //   errorWidget: (context, url, error) =>
                                        //       Image.asset('assets/symptoms_tracker/${problemsData.problemName.toString()}'),
                                        //   width: 30,
                                        //   height: 30,
                                        // // ),
                                        // Image.asset(
                                        //   'assets/symptoms_tracker/'
                                        //       '${problemsData.problemName.toString().trim()}.png',
                                        //   color:
                                        //   symptomtrackerVM.getSelectedMoreSymptomAttribute.map((e) =>
                                        //       e.id.toString()).toList().contains(problemsData.problemId.toString())?
                                        //   AppColor.neoGreen:(themeChange.darkTheme?AppColor.grey:Colors.grey.shade600.withOpacity(.7))
                                        //    ,
                                        //   width: 30,
                                        //   height: 30, ),

                                        Image.network(problemsData.displayIcon.toString(),

                                          width: 30,
                                          height: 30, ),
                                        // const SizedBox(height: 3,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                problemsData.problemName.toString(),
                                                style: MyTextTheme.smallBCN.copyWith(fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                    color:
                                                    symptomtrackerVM.getSelectedMoreSymptomAttribute.map((e) =>
                                                        e.id.toString()).toList().contains(problemsData.problemId.toString())?
                                                    AppColor.neoGreen:(themeChange.darkTheme? Colors.white70:AppColor.grey)),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),),
                      ),
                      // Padding(
                      //     padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      //     child: ManageResponse(
                      //       response: symptomtrackerVM.getProblemsResponse,
                      //       child: CustomScrollView(
                      //         physics: const NeverScrollableScrollPhysics(),
                      //         shrinkWrap: true,
                      //         controller: _scrollController,
                      //         slivers: <Widget>[
                      //
                      //
                      //
                      //           // LiveSliverGrid(
                      //           //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      //           //       maxCrossAxisExtent: 125,
                      //           //       childAspectRatio: 7 / 9,
                      //           //         crossAxisSpacing: 5,
                      //           //       mainAxisSpacing: 2),
                      //           //   controller: _scrollController,
                      //           //   delay: const Duration(milliseconds: 100),
                      //           //   showItemInterval: const Duration(milliseconds: 150),
                      //           //   showItemDuration: const Duration(milliseconds: 250),
                      //           //   itemCount: symptomtrackerVM.getSymptomsTrackerProblemList.length,
                      //           //   itemBuilder: (BuildContext context, int index,
                      //           //       Animation<double> animation) {
                      //           //     SymptomsProblemModal problemsData = symptomtrackerVM.getSymptomsTrackerProblemList[index];
                      //           //     return FadeTransition(
                      //           //         opacity: Tween<double>(begin: 0, end: 1)
                      //           //             .animate(animation),
                      //           //         child:  InkWell(
                      //           //           onTap: () async {
                      //           //             await symptomtrackerVM.onPressedSymptoms(index: index, selectedSymptoms: problemsData, context: context);
                      //           //           },
                      //           //           child: Column(
                      //           //             mainAxisAlignment: MainAxisAlignment.center,
                      //           //             children: [
                      //           //               Center(
                      //           //                 child: Container(
                      //           //                   height:(Get.width-26)/3.3,
                      //           //                   width:(Get.width-26)/3.5,
                      //           //                   // padding: const EdgeInsets.all(15.0),
                      //           //                   decoration: BoxDecoration(
                      //           //                     border: Border.all(color:
                      //           //                     symptomtrackerVM.getSelectedMoreSymptomAttribute.map((e) => e.id.toString()).toList().contains(problemsData.problemId.toString())?AppColor.neoGreen:(themeChange.darkTheme==true?Colors.grey.shade800:Colors.grey.shade400)),
                      //           //                     boxShadow: [
                      //           //                       BoxShadow(
                      //           //                         color:themeChange.darkTheme==true?Colors.transparent: Colors.grey.shade300,
                      //           //                         offset: const Offset(5,5),
                      //           //                         blurRadius: 5,
                      //           //                     ),
                      //           //                     ],
                      //           //                       gradient: LinearGradient(
                      //           //                           begin: Alignment.bottomCenter,
                      //           //                           end: Alignment.topCenter,
                      //           //                           colors: [
                      //           //                             themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                      //           //                             themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.white,
                      //           //                             themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.white,
                      //           //                             themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.white,
                      //           //                             themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.white,
                      //           //                           ]
                      //           //                       ),
                      //           //                       borderRadius:BorderRadius.circular(10),
                      //           //                       // color: AppColor.white
                      //           //                   ),
                      //           //                   child: Column(
                      //           //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //           //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //           //                     children: [
                      //           //                       // CachedNetworkImage(
                      //           //                       //   imageUrl:'',
                      //           //                       //   // problemsData.displayIcon.toString(),
                      //           //                       //   placeholder: (context, url) =>
                      //           //                       //       Image.asset('assets/symptoms_tracker/${problemsData.problemName.toString()}'),
                      //           //                       //   errorWidget: (context, url, error) =>
                      //           //                       //       Image.asset('assets/symptoms_tracker/${problemsData.problemName.toString()}'),
                      //           //                       //   width: 30,
                      //           //                       //   height: 30,
                      //           //                       // ),
                      //           //                       Image.asset('assets/symptoms_tracker/${problemsData.problemName.toString().trim()}.png',
                      //           //                         width: 30,
                      //           //                         height: 30, ),
                      //           //                       // const SizedBox(height: 3,),
                      //           //                       Row(
                      //           //                         children: [
                      //           //                           Expanded(
                      //           //                             child: Text(
                      //           //                               problemsData.problemName.toString(),
                      //           //                               style: MyTextTheme.smallBCN.copyWith(
                      //           //                                   fontSize: 12,
                      //           //                                   color:
                      //           //                                   symptomtrackerVM.getSelectedMoreSymptomAttribute.map((e) =>
                      //           //                                       e.id.toString()).toList().contains(problemsData.problemId.toString())?
                      //           //                                   AppColor.neoGreen:(themeChange.darkTheme? Colors.white70:AppColor.greyDark)),
                      //           //                               textAlign: TextAlign.center,
                      //           //                               overflow: TextOverflow.visible,
                      //           //                             ),
                      //           //                           ),
                      //           //                         ],
                      //           //                       ),
                      //           //                     ],
                      //           //                   ),
                      //           //                 ),
                      //           //               ),
                      //           //             ],
                      //           //           ),
                      //           //         ));
                      //           //   },
                      //           // )
                      //         ],
                      //       ),
                      //     )),
                      // Text(
                      // localization.getLocaleData.selectMoreSymptom.toString(),
                      //   style: MyTextTheme.mediumGCN.copyWith(fontWeight: FontWeight.w500,
                      //     color: themeChange.darkTheme==true?Colors.white60:Colors.grey.shade800,),
                      // ),
                      // SizedBox(height: 5,),
                      // ManageResponse(
                      //   response: symptomtrackerVM.getSymptomProblemsResponse,
                      //   child: Wrap(
                      //       children: List.generate(
                      //           symptomtrackerVM.getSymptomsTrackerSuggestProblemList
                      //               .length, (index) {
                      //         SymptomsProblemModal symptomHistoryData = symptomtrackerVM.getSymptomsTrackerSuggestProblemList[index];
                      //         return Padding(
                      //           padding: const EdgeInsets.fromLTRB(5, 6, 5, 5),
                      //           child: InkWell(
                      //             onTap: ()async{
                      //               dPring('${symptomHistoryData.problemId}  $index');
                      //
                      //
                      //               await symptomtrackerVM.onPressedSymptoms(index: index,
                      //                   selectedSymptoms: symptomHistoryData,
                      //                   context: context);
                      //
                      //
                      //             },
                      //             child: Container(
                      //               decoration: BoxDecoration(
                      //                   color:
                      //                   symptomtrackerVM.getSelectedMoreSymptomAttribute.map((e) =>
                      //                       e.id.toString()).toList().contains(symptomHistoryData.problemId.toString())?
                      //                   AppColor.neoGreen:(themeChange.darkTheme==true?Colors.white24:
                      //                   Colors.grey.shade400.withOpacity(.7)),
                      //                   // border: Border.all(
                      //                   //   color: AppColor.grey,
                      //                   // ),
                      //                   borderRadius: BorderRadius.circular(5),
                      //
                      //               ),
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(
                      //                     right: 5, left: 5, top: 5, bottom: 5),
                      //                 child: Text(
                      //                   symptomHistoryData.problemName.toString(),
                      //                   style:  symptomtrackerVM.getSelectedMoreSymptomAttribute.map((e) => e.id.toString()).toList().contains(symptomHistoryData.problemId.toString())?
                      //                   MyTextTheme.smallWCN:(
                      //                       themeChange.darkTheme==true?
                      //                       MyTextTheme.smallWCN:MyTextTheme.smallBCN) ,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       })),
                      // )
                    ],
                  ),
                      );
                }
              );
            }
          );
        }
      );
  }



}
