import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/Pages/sysmptoms_tracker_view.dart';
import 'package:medvantage_patient/ViewModal/MasterDashoboardViewModal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/functional_sheet.dart';
import 'package:medvantage_patient/app_manager/neomorphic/theme_provider.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/assets.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import '../Localization/app_localization.dart';
import '../Modal/attribute_data_modal.dart';
import '../Modal/selected_symptoms.dart';
import '../Modal/symptoms_problem_data_modal.dart';
import '../View/Pages/addvital_view.dart';
import '../View/Pages/dashboard_view.dart';
import '../View/widget/common_method/show_progress_dialog.dart';
import '../View/widget/common_method/show_symptom_tracker_dialog.dart';
import '../all_api.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_call.dart';
import '../app_manager/api/api_response.dart';
import '../app_manager/dialog.dart';
import '../app_manager/navigator.dart';
import '../app_manager/widgets/buttons/primary_button.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class SymptomsTrackerViewModal extends ChangeNotifier {
  final Api _api = Api();
  TextEditingController searchC = TextEditingController();
  TextEditingController symdateC = TextEditingController(text: DateTime.now().toString());
  List<SymptomsProblemModal> symptomsAdded = [];

  bool showNoData=false;
  bool get getShowNoData=>showNoData;
  set updateShowNoData(bool val){
    showNoData=val;
    notifyListeners();
  }

  clearData() {
    addedSymptoms = [];
    updateProblemList = [];
    SelectedSymptomsAttributeList = [];
    selectedMoreSymptomAttributeList = [];
    searchC.clear();
    getAddedSymptomsList.clear();
    notifyListeners();
  }

  List symptomsVoiceList =[];

  List<SymptomsProblemModal> get getSymptomsTrackerProblemList =>
      List<SymptomsProblemModal>.from(searchC.text == ""
          ? getProblemsResponse.data == null
              ? []
              : getProblemsResponse.data
          : getProblemsResponse.data == null
              ? []
              : getProblemsResponse.data.where((element) =>
                  (element.problemName.toString().toLowerCase().trim())
                      .trim()
                      .contains(searchC.text.toLowerCase().trim())));

  ApiResponse problemsResponse = ApiResponse.initial('initial');

  ApiResponse get getProblemsResponse => problemsResponse;

  set updateProblemsResponse(ApiResponse val) {
    problemsResponse = val;

    notifyListeners();
  }

  getProblemWithIcon(context) async {
    updateProblemsResponse = ApiResponse.loading("Fetching Data");
    final prefs = await SharedPreferences.getInstance();
    updateShowNoData=false;
    try {
      var data = await _api.call(context,
          url: AllApi.getProblemsWithIcon,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {
            "problemName": '',
              "languageId": await prefs.getString("lang").toString()
          }));
      updateShowNoData=true;
      if (data["responseCode"] == 1) {
        problemsResponse.data = (List<SymptomsProblemModal>.from(
            ((data['responseValue'] ?? []) as List)
                .map((e) => SymptomsProblemModal.fromJson(e))));
        updateProblemsResponse =
            ApiResponse<List<SymptomsProblemModal>>.completed(
                getProblemsResponse.data ?? []);

        if (data['responseValue'].isEmpty) {
          updateProblemsResponse = ApiResponse.empty("Data not Available");
        } else {}
      } else {
        updateProblemsResponse = ApiResponse.empty("Data not Available");

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message']);
      }
    } catch (e) {
      updateShowNoData=true;
      updateProblemsResponse = ApiResponse.error(e.toString());
    }
  }

  //.............SELECT MORE SYTMPTOMS.............................//

  //..........search list..........//
  List<SymptomsProblemModal> get getSymptomsTrackerSuggestProblemList =>
      List<SymptomsProblemModal>.from(searchC.text == ""
          ? getSymptomProblemsResponse.data == null
              ? []
              : getSymptomProblemsResponse.data
          : getSymptomProblemsResponse.data == null
              ? []
              : getSymptomProblemsResponse.data.where((element) =>
                  (element.problemName.toString().toLowerCase().trim())
                      .trim()
                      .contains(searchC.text.toLowerCase().trim())));

  ApiResponse symptomsProblemsResponse = ApiResponse.initial('initial');

  ApiResponse get getSymptomProblemsResponse => symptomsProblemsResponse;

  set updateSymptomProblemsResponse(ApiResponse val) {
    symptomsProblemsResponse = val;
    notifyListeners();
  }

  getSymptomsTrackerSuggestProblem(context) async {
    // ProgressDialogue().show(context, loadingText: 'Loading...');
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    updateSymptomProblemsResponse = ApiResponse.loading("Fetching Data");
    try {
      var data = await _api.call(context,
          url: AllApi.getAllSuggestedProblem,localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {"memberId": "380258"}));
      //   ProgressDialogue().hide();
      if (data["responseCode"] == 1) {
        symptomsProblemsResponse.data = (List<SymptomsProblemModal>.from(
            ((data['responseValue'] ?? []) as List)
                .map((e) => SymptomsProblemModal.fromJson(e))));
        updateSymptomProblemsResponse =
            ApiResponse<List<SymptomsProblemModal>>.completed(
                getSymptomProblemsResponse.data ?? []);
        if (data['responseValue'].isEmpty) {
          updateSymptomProblemsResponse =
              ApiResponse.empty("symptoms not Available");
        } else {}
      } else {
        updateSymptomProblemsResponse =
            ApiResponse.empty("symptoms not Available");

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));

        // Alert.show(data['message']);
      }
    } catch (e) {
      updateSymptomProblemsResponse = ApiResponse.error(e.toString());
    }
  }

  getAllProblems(context) async {
    updateSymptomProblemsResponse = ApiResponse.loading("Fetching Data");
    try {
      var data = await _api.call(context,
          url: AllApi.getAllSuggestedProblem,localStorage: true,
          apiCallType:
              ApiCallType.rawPost(body: {"alphabet": searchC.text.toString()}));
      print('nnnnnnnnnnnn$data');
      if (data["responseCode"] == 1) {
        symptomsProblemsResponse.data = (List<SymptomsProblemModal>.from(
            ((data['responseValue'] ?? []) as List)
                .map((e) => SymptomsProblemModal.fromJson(e))));
        updateSymptomProblemsResponse =
            ApiResponse<List<SymptomsProblemModal>>.completed(
                getSymptomProblemsResponse.data ?? []);
        if (data['responseValue'].isEmpty) {
          updateSymptomProblemsResponse =
              ApiResponse.empty("symptoms not Available");
        } else {}
      } else {
        updateSymptomProblemsResponse =
            ApiResponse.empty("symptoms not Available");

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message']);
      }
    } catch (e) {
      updateSymptomProblemsResponse = ApiResponse.error(e.toString());
    }
  }

  List<AttributeDataModal> get getSymptomsAttributeList =>
      getSymptomResponse.data ?? [];
  ApiResponse symptomResponse = ApiResponse.initial("initial");

  ApiResponse get getSymptomResponse => symptomResponse;

  set updateSymptomResponse(ApiResponse val) {
    symptomResponse = val;
    notifyListeners();
  }

  getAttributeByProblem(context) async {
    // ProgressDialogue().show(context, loadingText: 'Loading...');
    updateSymptomResponse = ApiResponse.loading("Fetching Symptomns");
    try {
      var data = await _api.call(context,
          url: AllApi.getAttributeByProblem,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {
            "problemId": getSelectedSymptomProblem.problemId.toString(),
          }));
      // ProgressDialogue().hide();
      if (data['responseCode'] == 1) {
        symptomResponse.data = (List<AttributeDataModal>.from(
            ((data['responseValue'] ?? []) as List)
                .map((e) => AttributeDataModal.fromJson(e))));

        // symptomResponse.data=(List<SymptomsProblemModal>.from(((data['responseValue'] ?? []) as List).map((e) =>
        //     SymptomsProblemModal.fromJson(e))));
        print('nnnnnnnnnnnnnnnnnnn${data['responseCode']}');
        updateSymptomResponse = ApiResponse<List<AttributeDataModal>>.completed(
            getSymptomResponse.data ?? []);

        if (data['responseValue'].isEmpty) {

          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "List is empty".toString()));
          // Alert.show("List is empty");
          updateSymptomResponse = ApiResponse.empty("Address not available");
        } else {
          ShowSymptomsAttributeDataShow(context);
        }
      } else {
        updateSymptomResponse = ApiResponse.empty("Address not available");

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["message"].toString()));
        // Alert.show(data["message"]);
      }
    } catch (e) {}
  }

  late SymptomsProblemModal selectedSymptoms;

  SymptomsProblemModal get getSelectedSymptomProblem => selectedSymptoms;

  set updateSelectedSymptomProblem(SymptomsProblemModal val) {
    selectedSymptoms = val;
  }

  onPressedSymptoms(
      {required int index,
      required SymptomsProblemModal selectedSymptoms,
      context}) async {
    bool isTaped = false;
    if (symptomsAdded
        .map((e) => e.problemId.toString())
        .toList()
        .contains(selectedSymptoms.problemId.toString())) {
      symptomsAdded.removeWhere((element) => element.problemId.toString()==selectedSymptoms.problemId.toString());
      print('nnnnnnnnnnnnnnnn${selectedSymptoms.problemId}nnn'); // symptomsAdded.removeAt(symptomsAdded
      //     .map((e) => e.problemId.toString())
      //     .toList()
      //     .indexOf(selectedSymptoms.problemId.toString()));

    }
    else {
      symptomsAdded.add(selectedSymptoms);
    }
    updateSelectedSymptomProblem = selectedSymptoms;
    print('nnnnnnnnnnnnnnnn${symptomsAdded.length}');
    if (getSelectedMoreSymptomAttribute
        .map((e) => e.id.toString())
        .toList()
        .contains(selectedSymptoms.problemId.toString())) {
      // print( 'nnnn'+SelectedSymptomsAttributeList.map((e) => e.organ!.id.toString()).toList().toString());
      // SelectedSymptomsAttributeList.removeAt( SelectedSymptomsAttributeList.map((e) => e.organ!.id.toString()).toList().indexOf(selectedSymptoms.problemId.toString()));
      SelectedSymptomsAttributeList.removeWhere((item) =>
          item.organ!.id.toString() == selectedSymptoms.problemId.toString());

      notifyListeners();

      isTaped = false;
    } else {
      isTaped = true;
    }
    // updateSelectedSymptomAttribute = selectedSymptoms;
    onPressedMoreSymptomAttributeList();

    if (isTaped) {
      //  await getAttributeByProblem(context);
    }
  }

//animated container search//............
  List searchProblem = [];

  List get getProblemList => searchProblem;

  set updateProblemList(List val) {
    searchProblem = val;
    notifyListeners();
  }
  List tempsearchProblem = [];

  List get getTempProblemList => searchC.text.isEmpty? []: tempsearchProblem.where((e)=>
      e.toString().toLowerCase().trim().contains(searchC.text.toLowerCase().trim())).toList();
  set updateTempProblemList(List val) {
    tempsearchProblem = val;
    notifyListeners();
  }

  getPatientAllProblems(context) async {
    try {
    //   var data = await _api.call(context,
    //       url: AllApi.patientAllProblems,
    //       apiCallType: ApiCallType.rawPost(body: {
    //         "alphabet": searchC.text.toString(),
    //       }));
    final prefs = await SharedPreferences.getInstance();


    var data = await _api.call(context,
        url: "Services/patientProblem.asmx/getAllSymptoms",
        newBaseUrl: "http://182.156.200.178:192/",
        apiCallType: ApiCallType.rawPost(body: {
          "language": prefs.getString("lang").toString(),
        }));
    print("xxxxxxxxxxxx ${jsonDecode(data["d"])["responseValue"]}");
    if (jsonDecode(data["d"])["responseCode"] == 1) {
      List myDAta=jsonDecode(data["d"])["responseValue"];
      for(int i=0;i<myDAta.length;i++){
        myDAta[i].addAll({'isVisible':'0'});

      }
      updateProblemList = myDAta;
      }
    } catch (e) {}
  }

  //.....SearchListDataAdd................
  List addedSymptoms = [];

  List get getAddedSymptomsList => addedSymptoms;

  set updateAddedSymptomsList(Map val) {
    addedSymptoms.add(val);
    notifyListeners();
  }

// .......RemoveListData..............................
  removeListData(index, problemID) {
    print(index);
    if (symptomsAdded
        .map((e) => e.problemId.toString())
        .toList()
        .contains(problemID.toString())) {
      symptomsAdded.removeAt(symptomsAdded
          .map((e) => e.problemId.toString())
          .toList()
          .indexOf(problemID.toString()));
    }
    if (addedSymptoms[index]["isVisible"].toString() == "0") {
      addedSymptoms[index]["isVisible"] = '1';
    } else {
      addedSymptoms[index]["isVisible"] = '0';
      addedSymptoms.removeAt(index);
    }
    notifyListeners();
  }

//.......changeTextColor..........
  changeIsVisible(context, index, problemMap) async {
    print(index);

    if (searchProblem[index]["isVisible"].toString() == '0') {
      updateAddedSymptomsList = {'problemId': problemMap['id'].toString(),'problemName': problemMap['symptoms'].toString()};
      searchProblem[index]["isVisible"] = '1';

      symptomsAdded.add(SymptomsProblemModal(
          problemId: problemMap['id'],
          problemName: problemMap['symptoms']));

      updateSelectedSymptomProblem = SymptomsProblemModal(
          problemId: problemMap['id'],
          problemName: problemMap['symptoms']);
      // await getAttributeByProblem(context);
    } else {
      searchProblem[index]["isVisible"] = '0';

      SelectedSymptomsAttributeList.removeWhere((item) =>
          item.organ!.id.toString() == problemMap['id'].toString());
      addedSymptoms.removeWhere((e) =>
          e['problemId'].toString() == problemMap['id'].toString());

      notifyListeners();
    }
  }

  //.............................selected alertdialog list..............//
  deleteSymptomsData(index) {
    SelectedSymptomsAttributeList.removeAt(index);
    notifyListeners();
  }

  List<SelectedSymptoms> SelectedSymptomsAttributeList = [];

  List<SelectedSymptoms> get getSelectedSymptomAttribute =>
      SelectedSymptomsAttributeList;

  OnPressedSelectAttributeSymptom({AttributeDetailsDataModal? attributeData}) {
    // print("xxxxxxxxxxxx$attributeData");
    if (SelectedSymptomsAttributeList.map((e) => e.id.toString())
        .toList()
        .contains(attributeData!.attributeValueId.toString())) {
      SelectedSymptomsAttributeList.removeAt(
          SelectedSymptomsAttributeList.map((e) => e.id.toString())
              .toList()
              .indexOf(attributeData.problemId.toString()));
    } else {
      SelectedSymptomsAttributeList.add(SelectedSymptoms(
        id: attributeData.attributeValueId.toString(),
        symptoms: attributeData.attributeValue.toString(),
        attributeID: attributeData.attributeId.toString(),
        organ: Organ(
          id: getSelectedSymptomProblem.problemId.toString(),
          img: getSelectedSymptomProblem.displayIcon.toString(),
        ),
      ));
    }
    notifyListeners();
  }

  List<Organ> selectedMoreSymptomAttributeList = [];

  List<Organ> get getSelectedMoreSymptomAttribute =>
      selectedMoreSymptomAttributeList;

  onPressedMoreSymptomAttributeList() {
    if (selectedMoreSymptomAttributeList
        .where((e) => e.id.toString()==getSelectedSymptomProblem.problemId.toString() ).isNotEmpty)
        // .toList()
        // .toString()
        // .contains(getSelectedSymptomProblem.problemId.toString()))
    {

      print('nnvvvvvvv '+selectedMoreSymptomAttributeList
          .map((e) => e.id.toString())
          .toList().toString()+'nnnv');

      selectedMoreSymptomAttributeList.removeWhere((element) =>
      element.id.toString()==getSelectedSymptomProblem.problemId.toString()) ;
      // selectedMoreSymptomAttributeList.removeAt(selectedMoreSymptomAttributeList
      //     .map((e) => e.id.toString())
      //     .toList()
      //     .indexOf(getSelectedSymptomProblem.problemId.toString()));
      //
    } else {
      selectedMoreSymptomAttributeList.add(
        Organ(
          id: getSelectedSymptomProblem.problemId.toString(),
          img: getSelectedSymptomProblem.displayIcon.toString(),
        ),
      );
      print('nnvvvvvvnnnnnnv '+getSelectedSymptomProblem.problemId.toString());
    }
    notifyListeners();
  }

  onPressedSave(context) async {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message:
              localization.getLocaleData.areUSureUWantToSaveSymptoms.toString(),
          buttonName: localization.getLocaleData.confirm.toString(),
          cancelBtn: localization.getLocaleData.cancel.toString(),
          onPressButton: () async {
            await addMemberProblem(context);
            await getPatientLastVital(context);
            myNewDialog(title: 'Added successfully !');
            Future.delayed(Duration(seconds: 3), () {
              Navigator.pop(context);
            });
          },
        ));
  }


  int vitalTimeDiff = 0;

  int get getVitalTimeDiff => vitalTimeDiff;

  set updateVitalTimeDiff(int val) {
    vitalTimeDiff = val;
    notifyListeners();
  }

  getPatientLastVital(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    try {
      ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
      var data = await _api.callMedvanatagePatient7082(context,

          url: 'api/PatientVital/GetPatientLastVital?uhID=${userRepository.getUser.uhID.toString()}',
          // url:
          //     "HomeCareService/GetPatientLastVital?uhID=${userRepository.getUser.uhID.toString()}",
          localStorage: true,
          apiCallType: ApiCallType.get());
      print("nnnnnnnnnnnnnn$data");

       Get.back();
      if (data["status"] == 1) {
        // Alert.show(data["message"].toString());
        var dateTime = data['responseValue'].isEmpty
            ? DateTime.now().toString()
            : data['responseValue'][0]['vitalDateTime'];

        print(DateTime.now().toString());
        print(dateTime);
        final difference = DateTime.now()
            .difference(DateTime.parse(dateTime.toString()))
            .inMinutes;
        updateVitalTimeDiff = int.parse(difference.toString());

        if (getVitalTimeDiff >= 15) {
          inputVital(context);
        }
        print("nnnvnnnvn$difference");
      } else {

        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: "Symptoms Added Successfully !".toString()));
        // Alert.show("Symptoms Added Successfully !");
      }
    } catch (e) {
      Get.back();
    }
  }

  inputVital(context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);


    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProviderLd>(
            builder: (__context, themeChange, _){
            return AlertDialog(shadowColor:  AppColor.greyLight,
              backgroundColor:themeChange.darkTheme==true?Colors.black:AppColor.neoBGWhite1,
                title: Text(localization.getLocaleData.doYouWantToAddYourVitals.toString(),style: TextStyle(
                  color: themeChange.darkTheme==true? Colors.white:AppColor.black
                ),),
                contentPadding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),

                content: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        ImagePaths.iconVitalAlert,
                        height: 147,
                        width: 147,
                      ),
                      SizedBox(
                        width: 150,
                        child: PrimaryButton(color: Colors.green,
                            onPressed: () {
                               Get.back();
                              MyNavigator.push(context, const AddVitalView());
                            },
                            title: localization.getLocaleData.yes.toString(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: PrimaryButton(
                          onPressed: () {
                             Get.back();
                          },
                          title: localization.getLocaleData.addLater.toString(),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                    ],
                  ),
                ));
          }
        );
      },
    );
  }


  inputVital2(context) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    MasterDashboardViewModal masterDashboardViewModal =
    Provider.of<MasterDashboardViewModal>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    await CustomBottomSheet.open(context,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                    themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                    themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                    themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                  ]
              )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(localization.getLocaleData.doYouWantToAddYourVitals.toString(),
                        style: MyTextTheme.mediumBCB.copyWith(color: themeChange.darkTheme==true?Colors.white70 :Colors.grey.shade700),),
                    ),

                  InkWell(
                    onTap: (){
                       Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.close,size: 31,color: themeChange.darkTheme? Colors.white:Colors.grey,),
                    ),
                  )
                  ],
                ),
              ),
              Container(
                height: 1,
                             color: Colors.grey,
                  child: Row()),
              Image.asset(
                ImagePaths.confuse,
                height: 250,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: PrimaryButton(
                      elevation: 0,
                      onPressed: () {

                         Get.back();
                        // masterDashboardViewModal.updateSelectedPage='Update Symptoms';
                        MyNavigator.push(context, SymptomTrackerView());
                      },
                      title: localization.getLocaleData.addLater.toString(),
                      color: themeChange.darkTheme? Colors.grey.shade800 : Colors.grey.shade400,
                      textStyle: TextStyle(color: themeChange.darkTheme? Colors.grey:Colors.white) ,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: PrimaryButton(
                      color: AppColor.neoGreen,
                      onPressed: () {
                         Get.back();
                        MyNavigator.push(context, const AddVitalView());
                      },
                      title: localization.getLocaleData.yes.toString(),

                      textStyle: TextStyle(color:themeChange.darkTheme?  Colors.black:Colors.white) ,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ));
  }

  addMemberProblem(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var dtDataTable = [];

    for (int index = 0; index < symptomsAdded.length; index++) {
      dtDataTable.add({
        'detailID': symptomsAdded[index].problemId.toString(),
        'detailsDate': symdateC.text.toString(),
        'isfrompatient': '1',
        'details': symptomsAdded[index].problemName.toString(),
      });
    }

    for (int i = 0; i < symptomHistory.length; i++) {
      bool isIdFound=false;
      if(symptomHistory[i]['isSymptom']!='0' ){

        for (int j = 0; j < dtDataTable.length; j++) {
        if(dtDataTable[j]['detailID'].toString()==symptomHistory[i]['detailID'].toString()){
          isIdFound=true;
        }
      }
        if(!isIdFound){
          dtDataTable.add({
            'detailID': symptomHistory[i]['detailID'].toString(),
            'detailsDate': DateTime.now().toString(),
            'details': symptomHistory[i]['details'].toString(),
          });
        }
      }
    }

    try {
      print('save');
      var data = await _api.callMedvanatagePatient7082(context,
          url:
          // 'api/PatientIPDPrescription/InsertSymtoms?uhID=${userRepository.getUser.uhID.toString()}&doctorId=0&jsonSymtoms=${jsonEncode(dtDataTable).toString()}&userId=${userRepository.getUser.userId.toString()}&clientID=${userRepository.getUser.clientId.toString()}',
              "${AllApi.addSymptompsHm}uhID=${userRepository.getUser.uhID.toString()}&userID=${userRepository.getUser.userId.toString()}&isProvisionalDiagnosis=0&isFromPatient=1&doctorId=0&jsonSymtoms=${jsonEncode(dtDataTable).toString()}",
          apiCallType: ApiCallType.post(body: {}),
      isSavedApi: true);
      print("Check$data");

       Get.back();
      if (data["status"] == 0) {

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["responseValue"].toString()));
        // Alert.show(data["responseValue"].toString());
      } else {
        // ProgressDialogue().hide();
        await  getHomeCareSymtoms(context);
        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
        ProgressDialogue().hide();
        // Alert.show(data['message'].toString());
      }
      SelectedSymptomsAttributeList=[];
      selectedMoreSymptomAttributeList=[];
      symptomsAdded=[];
      updateTempProblemList=[];
      addedSymptoms=[];
      notifyListeners();
    } catch (e) {
      Get.back();
    }
  }

  List symptomHistory = [];

  List get getSymptomHistory => symptomHistory;

  set updateSymptomHistory(List val) {
    symptomHistory = val;
    notifyListeners();
  }

  getHomeCareSymtoms(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    updateSymptomHistory=[];
    updateShowNoData=false;
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    // ProgressDialogue().show(context, loadingText:localization.getLocaleData.Loading.toString());

    try {
      var data = await _api.callMedvanatagePatient(context,
          url:
              "api/HomeCareSymtoms/GetHomeCareSymtoms?uhID=${userRepository.getUser.uhID.toString()}&clientID=${userRepository.getUser.clientId.toString()}",
          localStorage: true,
          apiCallType: ApiCallType.post(body: {}));
      print("nnnnnnnnnnnn $data");

      updateShowNoData=true;
       // Get.back();
      if (data["status"] == 0) {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["responseValue"].toString()));
        // Alert.show(data["responseValue"].toString());
      } else {

        print('nnnnvvvn '+data['responseValue'].toString());
        for(int i=0;i<data['responseValue'].length;i++){
          data['responseValue'][i].addAll({'isSymptom':''});
        }

        print('nnnnvvvn '+data['responseValue'].toString());
        updateSymptomHistory = data['responseValue'];
      }
    } catch (e) {
      updateShowNoData=true;
       // Get.back();
    }
  }



  int currentIndex=0;
  int get getCurrentIndex=>currentIndex;
  set updateCurrentIndex(int val){
    currentIndex=val;
    notifyListeners();
  }

  onPressedNext(){
    if(getCurrentIndex<getSymptomHistory.length){
      updateCurrentIndex=getCurrentIndex+1;
    }
    notifyListeners();
  }

  onPressedPrevious(){
    if(0<getCurrentIndex){
      updateCurrentIndex=getCurrentIndex-1;
    }
    notifyListeners();
  }




  onPressedYesNo(val){
    symptomHistory[getCurrentIndex]['isSymptom'] =val;
    notifyListeners();
  }


  updateProblem(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    MasterDashboardViewModal masterDashboardViewModal =
    Provider.of<MasterDashboardViewModal>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var dtDataTable = [];
    for (int i = 0; i < symptomHistory.length; i++) {
      if(symptomHistory[i]['isSymptom']!='0' ){
        dtDataTable.add({
          'detailID': symptomHistory[i]['detailID'].toString(),
          'detailsDate': DateTime.now().toString(),
          'details': symptomHistory[i]['details'].toString(),
          "isFromPatient":"1"
        });
      }
    }

    if(dtDataTable.isEmpty){
      dtDataTable.add({
        'detailID': '',
        'detailsDate':'',
        'details':'',
        "isFromPatient":""
      });
    }

    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:
          // 'api/PatientIPDPrescription/InsertSymtoms?uhID=${userRepository.getUser.uhID.toString()}&doctorId=0&jsonSymtoms=${jsonEncode(dtDataTable).toString()}&userId=${userRepository.getUser.userId.toString()}&clientID=${userRepository.getUser.clientId.toString()}',
          "${AllApi.addSymptompsHm}uhID=${userRepository.getUser.uhID.toString()}&isProvisionalDiagnosis=0&doctorId=0&jsonSymtoms=${jsonEncode(dtDataTable).toString()}",
          apiCallType: ApiCallType.post(body: {}),
          isSavedApi: true);
      print("Check$data");
       Get.back();
      if (data["status"] == 0) {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["responseValue"].toString()));
        // Alert.show(data["responseValue"].toString());
      } else {
        // Get.offAll(DashboardView() );
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Get.offAll(()=>DashboardView());
        Get.back();
        masterDashboardViewModal.updateSelectedPage ='Home';
        updateCurrentIndex=0; // await  getHomeCareSymtoms(context);

        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message:data['message'].toString()));
        // Alert.show(data['message'].toString());
      }
    } catch (e) {
      Get.back();
    }
  }

}
