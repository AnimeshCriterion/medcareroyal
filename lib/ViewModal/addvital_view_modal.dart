import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Modal/ManualFoodAssignDataModal.dart';
import '../Modal/vital_history_data_modal.dart';
import '../View/Pages/addvital_view.dart';
import '../View/Pages/rmd_view.dart';
import '../app_manager/api/api_response.dart';
import '../app_manager/bottomSheet/bottom_sheet.dart';
import '../app_manager/bottomSheet/functional_sheet.dart';
import '../app_manager/dialog.dart';
import '../assets.dart';
import '../main.dart';
import '../medcare_utill.dart';

class AddVitalViewModal extends ChangeNotifier {

  final PageController pageController = PageController(initialPage: 0);

   goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
  var allData ;

  String? time;

bool pauseFunc=false;
set updatePauseFunc(val){
  pauseFunc=val;
  notifyListeners();
}

  final formKey = GlobalKey<FormState>();
  TextEditingController systollicC = TextEditingController();
  TextEditingController diatollicC = TextEditingController();
  TextEditingController pulserateC = TextEditingController();
  TextEditingController temperatureC = TextEditingController();
  TextEditingController heartrateC = TextEditingController();
  TextEditingController spo2C = TextEditingController();
  TextEditingController respiratoryC = TextEditingController();
  TextEditingController heightC = TextEditingController();
  TextEditingController weightC = TextEditingController();
  TextEditingController toDateC = TextEditingController();
  TextEditingController formDateC = TextEditingController();
  TextEditingController urineC = TextEditingController();
  TextEditingController rbsC = TextEditingController();
  TextEditingController dateC = TextEditingController();
  TextEditingController timeC = TextEditingController();

  bool isIntake=true;

  bool isEditingText = false;
  clearData(){
    systollicC.clear();
    diatollicC.clear();
    pulserateC.clear();
    temperatureC.clear();
    spo2C.clear();
    respiratoryC.clear();
    heartrateC.clear();
    rbsC.clear();
    weightC.clear();
    heightC.clear();
    notifyListeners();
  }


  late double fluidAdded ;
  String valueFromVoice ='';
  // TextEditingController changeQtyC = TextEditingController();

  double qtyValue=100;
  double get getQtyValue=>qtyValue;
  set updateQtyValue(double val){
    qtyValue=val;
    notifyListeners();
  }

  double maxvalue=100.0;


  TextEditingController fluidC = TextEditingController();

  int subscriptionIndex = 0;
  set updatesubscriptionIndex(int val){
    subscriptionIndex=val;
    notifyListeners();
  }
  int heightIndex = 0;



  String getInstruction(context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    switch (SelectedListIndex) {
      case 0:
        return localization.getLocaleData.makeSureThatYourHandsAareAtNormalBloodPressure.toString();
        break;
      case 1:
        return localization.getLocaleData.makeSureThatYourHandsAreAtNormalSpo2.toString();
      case 2:
        return localization.getLocaleData.makeSureThatYourHandsAreAtNormalHeartRate.toString();
      case 3:
        return localization.getLocaleData.makeSureThatYourHandsAreAtNormalPluseRate.toString();
      case 4:
        return localization.getLocaleData.makeSureThatYourHandsAreAtNormalTemperature.toString();
      case 5:
        return localization.getLocaleData.kindlyRemoveYourShoesAndStandOnWeight.toString();
      case 6:
        return localization.getLocaleData.makeSureThatYourHandsAreAtNormalHeartRate.toString();
      case 7:
        return localization.getLocaleData.makeSureThatYourHandsAreAtNormalHeartRate.toString();
      case 8:
        return localization.getLocaleData.makeSureThatYourHandsAreAtNormalHeartRate.toString();
    }

    return "";
  }


  dynamic addVitalsMachine = [
    {"id": 1, "image": ImagePaths.bp2.toString(), "Name": "BP",'type':'1'},
    {"id": 4, "image": ImagePaths.spo22.toString(), "Name": "SPO2",'type':'2'},
    {"id": 3, "image": ImagePaths.hr.toString(), "Name": "HR",'type':'8'},
    {"id": 2, "image": ImagePaths.pr2.toString(), "Name": "PR",'type':'8'},
    {"id": 5, "image": ImagePaths.temp2.toString(), "Name": "Temp",'type':'5'},
    {"id": 6, "image": ImagePaths.bp.toString(), "Name": "Weight",'type':'0'},
    {"id": 5, "image":  ImagePaths.pr2.toString(), "Name": "ECG",'type':'4'},
    {"id": 5, "image":  ImagePaths.pr2.toString(), "Name": "Stetho",'type':'4'},
    {"id": 5, "image":  ImagePaths.pr2.toString(), "Name": "PTT",'type':'4'},
  ];

  int SelectedListIndex = 0;
  String deviceType='';
  String get getSelecetedDeviceType=>deviceType;
  set updateSelectedDeviceType(String val){
    deviceType=val;
    notifyListeners();
  }



  final Api _api = Api();

  AddVitalRequest(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    dPrint('nnnnnnnnnnnnn');
    List dtDataTable = [];
    dtDataTable.add({
      'vitalId': 4.toString(),
      'vitalValue': systollicC.text,
    });
    dtDataTable.add({
      "vitalId": '6'.toString(),
      "vitalValue": diatollicC.text,
    });
    dtDataTable.add({
      "vitalId": '3'.toString(),
      "vitalValue": pulserateC.text,
    });
    dtDataTable.add({
      "vitalId": '5'.toString(),
      "vitalValue": temperatureC.text,
    });
    dtDataTable.add({"vitalId": '56'.toString(), "vitalValue": spo2C.text});
    dtDataTable.add({
      "vitalId": '7'.toString(),
      "vitalValue": respiratoryC.text,
    });
    dtDataTable.add({
      "vitalId": '1'.toString(),
      "vitalValue": heightC.text,
    });
    dtDataTable.add({
      "vitalId": '2'.toString(),
      "vitalValue": weightC.text,
    });

    for (int i = 0; i < dtDataTable.length; i++) {
      if (dtDataTable[i]['vitalValue'].toString() == '') {
        dtDataTable.removeAt(i);
      }
    }

    var data = await _api.call(
      context,
      url: AllApi.getAddVital,
      localStorage: true,
      apiCallType: ApiCallType.rawPost(body: {
        "memberId": userRepository.getUser.uhID.toString(),
        'dtDataTable': jsonEncode(dtDataTable),
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
        "time": DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
        // "appointmentId": 0,
      }),
    );
  }



  addVitalsData(  {required String isFromMachine}) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(NavigationService.navigatorKey.currentContext!, listen: false);
    ProgressDialogue().show(NavigationService.navigatorKey.currentContext!,  loadingText: localization.getLocaleData.Loading.toString());
    UserRepository userRepository =
        Provider.of<UserRepository>(NavigationService.navigatorKey.currentContext!,  listen: false);
    var request = {};

    var sys=systollicC.value.text.toString()==''? '0':systollicC.value.text.toString();
    var dia=diatollicC.value.text.toString()==''? '0':diatollicC.value.text.toString();
    var rr=respiratoryC.value.text.toString()==''? '0':respiratoryC.value.text.toString();
var spo2=spo2C.value.text.toString()==''? "0":spo2C.value.text.toString();

var pr=pulserateC.value.text.toString()==''? "0":pulserateC.value.text.toString();

var tmp=temperatureC.value.text.toString()==''?"0":temperatureC.value.text.toString();

var hr=heartrateC.text.toString()==''?"0":heartrateC.text.toString();
    var rbs=rbsC.text.toString()==''?'0':rbsC.text.toString();
    var weight=weightC.value.text.toString()==''?'0':weightC.value.text.toString();
    dPrint('nnnnnnnnnnnnnnv '+dateC.text.toString());
    var date=DateFormat('yyyy-MM-dd').format(DateTime.parse(dateC.text));
    var time=DateFormat('HH:mm').format(DateFormat('yyyy-MM-dd HH:mm').parse(dateC.text));
    dPrint('nnnnnnnnnnnnnnv '+time.toString());


    try{

var body={
  // "id": 0,
  // "pid": userRepository.getUser.pid.toString(),
  // "pmId": 0,
  "userId": userRepository.getUser.userId.toString(),
  // "vmId": 0,
  "vmValueBPSys": sys.toString(),
  "vmValueBPDias": dia.toString(),
  "vmValueRespiratoryRate":  rr.toString(),
  "vmValueSPO2":  spo2.toString(),
  "vmValuePulse": pr.toString(),
  "vmValueTemperature":  tmp.toString(),
  "vmValueHeartRate":  hr.toString(),
  // "vmValueBMI": 0,
  // "vmValueBMR": 0,
  "weight":  weight.toString(),
  "vmValueUrineOutput": 0,
  "height": 0,
  "vmValueRbs":  rbs.toString(),
  "vitalTime": time.toString(),
  "vitalDate": date.toString(),
  // "vitalIdSearch": 0,
  "uhid": userRepository.getUser.uhID.toString(),
  "currentDate": DateTime.now().toString(),
  // "vitalIdSearchNew": "string",
  "clientId": userRepository.getUser.clientId.toString(),
  // "duration": 0,
  // "vmValue": 0,
  "isFromPatient": true,
  "positionId": getSelectedPosition.toString()
};
var data = await _api.callMedvanatagePatient7082(NavigationService.navigatorKey.currentContext!,
    url:'api/PatientVital/InsertPatientVital',
    localStorage: true,
    apiCallType: ApiCallType.rawPost(body: body),
    isSavedApi: true);
      // var data = await _api.callMedvanatagePatient(NavigationService.navigatorKey.currentContext!,
      //     url:
      //         "${AllApi.addVitalHM}uhID=${userRepository.getUser.uhID.toString()}&positionId=${getSelectedPosition.toString()}&vmValueBPSys=${sys}&vmValueBPDias=${dia}&vmValueRespiratoryRate=${rr}&vmValueSPO2=${spo2}&vmValuePulse=${pr}&vmValueTemperature=${tmp}&vmValueHeartRate=${hr}&vmValueRbs=${rbs}&vmValueUrineOutput=0&weight=${weight}&isFromMachine=${isFromMachine}&userId=${userRepository.getUser.userId.toString()}&IsFromPatient=true&vitalDate=${date}&vitalTime=${time}",
      //     localStorage: true,
      //     apiCallType: ApiCallType.post(body: request),
      //     isSavedApi: true);
      Get.back();
      dPrint('echoechoechoechoechoecho '+data.toString());
      if (data['status'] == 0) {

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["responseValue"].toString()));
        // Alert.show(data["responseValue"]);
      } else {
        //
        // Get.to(()=>const RMDView());
        // Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: "Vital added successfully !".toString()));
        Get.dialog(SimpleDialog(
            surfaceTintColor:Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              //  ZoomIn(duration:Duration(seconds: 2),child: Image.asset('assets/counter.png',height: 94,fit: BoxFit.fitHeight,)),
                 ZoomIn(duration:Duration(seconds: 2),child: Icon(Icons.check_circle_outline,size: 100,color: Colors.lightBlueAccent,)),
                SizedBox(height: 20,),
                Text('Vitals added successfully !'),
              ],
            ),titlePadding:EdgeInsets.all(20)));
        // Alert.show("Vital added successfully !");
      }
    }


    catch(e){
      FocusScope.of(NavigationService.navigatorKey.currentContext!,).unfocus();

    }

    FocusScope.of(NavigationService.navigatorKey.currentContext!,).unfocus();

  }

  addVitalsDataWeight(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    var request = {};
    var data = await _api.callMedvanatagePatient(
      context,
      url:
          "${AllApi.addVitalHM}uhID=${userRepository.getUser.uhID.toString()}&vmValueBPSys=0&vmValueBPDias=0&vmValueRespiratoryRate=0&vmValueSPO2=0&vmValuePulse=0&vmValueTemperature=0&vmValueHeartRate=0&vmValueRbs=0&vmValueUrineOutput=0&weight=${weightC.value.text.toString()}&isFromMachine=1&userId=${userRepository.getUser.userId.toString()}&vitalDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}&vitalTime=${DateFormat('HH:mm').format(DateTime.now())}",
      localStorage: true,
      apiCallType: ApiCallType.post(body: request),
        isSavedApi: true
    );

    if (data['status'] == 0) {

      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["responseValue"].toString()));
      // Alert.show(data["responseValue"]);
    } else {

      Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: "Vital Added Successfully !".toString()));
      // Alert.show("Vital Added Successfully !");
    }

    dPrint("ANimesh$data");
  }

  addVitalsDataUrine(context) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var body = {
      'clientId': userRepository.getUser.clientId.toString(),
      'id': userRepository.getUser.userId.toString(),
      'uhid': userRepository.getUser.uhID.toString(),
      'outputDate': DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
      'outputTypeID': 51,
      'pmID': 0,
      'quantity': urineC.value.text.toString(),
      'unitID': 1,
      'userID': userRepository.getUser.userId.toString()
    };
    dPrint("Request"+body.toString());
    var data = await _api.callMedvanatagePatient7082(NavigationService.navigatorKey.currentContext!,
        url:'api/output/SavePatientOutput',
        localStorage: true,
        apiCallType: ApiCallType.rawPost(body: body),
        isSavedApi: true);

    // var request = {};
    // var data = await _api.callMedvanatagePatient(
    //   context,
    //   url:
    //       "${AllApi.addVitalHM}uhID=${userRepository.getUser.uhID.toString()}&vmValueBPSys=0&vmValueBPDias=0&vmValueRespiratoryRate=0&vmValueSPO2=0&vmValuePulse=0&vmValueTemperature=0&vmValueHeartRate=0&vmValueRbs=0&vmValueUrineOutput=${urineC.value.text.toString()}&weight=0&isFromMachine=1&userId=${userRepository.getUser.userId.toString()}&vitalDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}&vitalTime=${DateFormat('HH:mm').format(DateTime.now())}",
    //   localStorage: true,
    //   apiCallType: ApiCallType.post(body: request),
    //     isSavedApi: true
    // );

     Get.back();

    if (data['status'] == 0) {

      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["responseValue"].toString()));
      // Alert.show(data["responseValue"]);
    } else {
      // Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
      // Alert.show(data['message'].toString());
      // urineC.clear();
      notifyListeners();
     await urinHistory(context);
      myNewDialog(title: 'Output Added Successfully');
    }

    dPrint("ANimesh$data");
  }



  onPressedData(context) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    if (pulserateC.text.isEmpty &&
        pulserateC.text.isEmpty &&
        temperatureC.text.isEmpty &&
        spo2C.text.isEmpty &&
        respiratoryC.text.isEmpty &&
        heightC.text.isEmpty &&
        weightC.text.isEmpty &&
        systollicC.text.isEmpty &&
        diatollicC.text.isEmpty) {

      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Please fill at least one vital".toString()));
      // Alert.show("Please fill at least one vital");
    } else if ((systollicC.text.isEmpty && diatollicC.text.isNotEmpty) ||
        (systollicC.text.isNotEmpty && diatollicC.text.isEmpty)) {

      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Please fill both systollic and diastollic data".toString()));
      // Alert.show("Please fill both systollic and diastollic data");
    } else {
      await CustomBottomSheet.open(context,
          child: FunctionalSheet(
            message: localization.getLocaleData.areYouSureYouWantToddVitale.toString(),
            buttonName: localization.getLocaleData.confirm.toString(),
            onPressButton: () async {
              await AddVitalRequest(context);
              clearData();
            },
          ));
    }
  }

  List<VitalHistoryDataModal> get getVitalHistory =>
      getVitalResponse.data ?? [];
  ApiResponse vitalResponse = ApiResponse.initial("initial");

  ApiResponse get getVitalResponse => vitalResponse;

  set updateVitalResponse(ApiResponse val) {
    vitalResponse = val;
    notifyListeners();
  }

  getVitalDateHistory(context) async {
    updateVitalResponse = ApiResponse.loading("Loading Vital");
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    try {
      var data = await _api.call(context,
          url: AllApi.getPatientVitalsDateWiseHistory,localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {
            "memberId": userRepository.getUser.uhID.toString(),
            "toDate": toDateC.text.toString(),
            "fromDate": formDateC.text.toString(),
          }));
      if (data["responseCode"] == 1) {
        vitalResponse.data = (List<VitalHistoryDataModal>.from(
            ((data["responseValue"] ?? []) as List)
                .map((e) => VitalHistoryDataModal.fromJson(e))));
        updateVitalResponse =
            ApiResponse<List<VitalHistoryDataModal>>.completed(
                getVitalResponse.data ?? []);
        if (data['responseValue'].isEmpty) {
          updateVitalResponse = ApiResponse.empty("Address not available");
        } else {}
      } else {
        updateVitalResponse = ApiResponse.empty("Address not available");

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["message"].toString()));
        // Alert.show(data["message"]);
      }
    } catch (e) {
      updateVitalResponse = ApiResponse.error(e.toString());
    }
  }

  onPressedSave(context) async {
    // if(formKey.currentState!.validate()) {

    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message: 'Are you sure you want to add vital?',
          buttonName: 'Confirm',
          onPressButton: () async {
            await onPressedData(context);
            clearData();
          },
        ));
    // }
  }

  String getLabelsDyanmic(context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    switch (SelectedListIndex) {
      case 0:
        return "Your blood pressure is :";
        break;
      case 1:
        return "Your heart rate is :";
      case 2:
        return "Your pulse rate is :";
        break;
        break;
      case 3:
        return "Your Oxygen level (Spo2) is :";
        break;
      case 4:
        return "Your temperature is :";
        break;
      case 5:
        return localization.getLocaleData.yourWeightIs.toString();
        break;
    }

    return "";
  }

  String getImage() {
    switch (SelectedListIndex) {
      case 0:
        return ImagePaths.bpGIf;
        break;
      case 1:
        return ImagePaths.spo2gif;
        break;
      case 2:
        return ImagePaths.spo2gif;
        break;
      case 3:
        return ImagePaths.spo2gif;
        break;
      case 4:
        return ImagePaths.temp2;
        break;
      case 5:
        return ImagePaths.weightgif;
        break;
      case 6:
        return ImagePaths.spo2gif;
        break;
      case 7:
        return ImagePaths.spo2gif;
      case 8:
        return ImagePaths.spo2gif;
    }

    return "";
  }

  String getHeadings(context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    switch (SelectedListIndex) {
      case 0:
        return localization.getLocaleData.measureYourBloodPressure.toString();
        break;
      case 1:
        return localization.getLocaleData.measureYourSPO2.toString();
      case 2:
        return localization.getLocaleData.measureYourHeartRate.toString();
      case 3:
        return localization.getLocaleData.measureYourPulseRate.toString();
        break;
      case 4:
        return localization.getLocaleData.measureYourTemperature.toString();
        break;
      case 5:
        return localization.getLocaleData.measureYourWeight.toString();
        break;
    }

    return "";
  }


  Future<void> addWaterIntakeData(BuildContext context, double value) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    var request = {};
    var data = await _api.callMedvanatagePatient7096(
      context,
      url:
          "${AllApi.addFoodIntake}Uhid=${userRepository.getUser.uhID.toString()}&dietID=159userId=${userRepository.getUser.userId.toString()}}",
      localStorage: true,
      apiCallType: ApiCallType.post(body: request),
        isSavedApi: true
    );

    if (data['status'] == 0) {

      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data["responseValue"].toString()));
      // Alert.show(data["responseValue"]);
    } else {
      Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: "Vitals added successfully !".toString()));
      // Alert.show("Vitals added successfully !");
       Get.back();
    }

    dPrint("ANimesh$data");
  }



  String selectedFoodID='';
  String get getSelectedFoodId=>selectedFoodID;
  set updateSelectedFoodID(String val){
    selectedFoodID=val;
    notifyListeners();
  }



  fluidIntake(context) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);


    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());

    try {
      if(double.parse(fluidC.text.toString())!=0.0){
        Map<String, dynamic> body =
        // {
        //   "givenFoodDate":DateTime.now().toString(),
        //   "givenFoodQuantity":double.parse(fluidC.text.toString())*itemCount, //Required
        //   "foodId":getSelectedFoodId.toString(), // Required(fixed)
        //   "entryType":"N",
        //   "givenFoodUnitID":27, // Required (fixed)
        //   "uhid":userRepository.getUser.uhID.toString(),
        //   "recommendedUserID": userRepository.getUser.admitDoctorId.toString(),
        // };
        {
          "givenQuanitityInGram": '0',
          "uhid": userRepository.getUser.uhID.toString(),
          "foodId": getSelectedFoodId.toString(), // Required(fixed)
          "pmId": '0',
          "givenFoodQuantity": double.parse(fluidC.text.toString())*itemCount, //Required
          "givenFoodDate": DateTime.now().toString(), //Required
          "givenFoodUnitID": '27', // Required (fixed)
          "recommendedUserID": userRepository.getUser.admitDoctorId.toString(),
          "jsonData": "",
          "fromDate": DateTime.now().toString(),
          "isGiven": '0',
          "entryType": "N", // Required (fixed)
          "isFrom": '0',
          "dietID": '0',
          "userID": userRepository.getUser.userId.toString(),
        };

        dPrint("nnnnnnnnnnnnnn${jsonEncode(body)}");
        var data = await _api.callMedvanatagePatient7096(context,
            url: "api/FoodIntake/InsertFoodIntake",
            apiCallType: ApiCallType.rawPost(body: body),
            isSavedApi: true);
        ProgressDialogue().hide();
        dPrint("nnnnnnnnnnnnnn$data");
        if (data["status"] == 0) {
          Get.showSnackbar( MySnackbar.ErrorSnackBar(message: data['responseValue'].toString()));
          // Alert.show(data['responseValue'].toString());
        } else {
          // Get.to(()=>const RMDView());
          // Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
          // Alert.show(data['message'].toString());
          Get.dialog(SimpleDialog(
              surfaceTintColor:Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ZoomIn(duration:Duration(seconds: 2),child: Image.asset('assets/counter.png',height: 94,fit: BoxFit.fitHeight,)),
                  SizedBox(height: 20,),
                  Text('Intake Added Successfully!'),
                ],
              ),titlePadding:EdgeInsets.all(20)));
        }
      }
      else{

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'you can not add fluid 0.0 ml'.toString()));
        // Alert.show('you can not add fluid 0.0 ml');
      }
    }
    catch (e) {
      ProgressDialogue().hide();
      dPrint(e.toString());

    }
  }




  List manualFoodList=[];
  List<ManualFoodAssignDataModal> get getManualFoodList=>
      List<ManualFoodAssignDataModal>.from(manualFoodList.map((e) => ManualFoodAssignDataModal.fromJson(e)));
  set updateManualFoodList(List val){
    manualFoodList=val;
    notifyListeners();
  }


  int intakeIndex=0;
  int get getInt=>intakeIndex;
  set updateIndex(val){
    if (val >= 0 && val < getManualFoodList.length) {
      intakeIndex = val;
      // goToPage(intakeIndex);
      dPrint(val.toString());
      dPrint(manualFoodList.length.toString());
      notifyListeners();
    }
  }


  manualFoodAssign(context) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
updateShowNoData=false;
 // ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    try {
      var data = await _api.callMedvanatagePatient7096(context,
          url: "api/ManualFoodAssign/GetManualFoodAssignList?Uhid=${userRepository.getUser.uhID.toString()}&intervalTimeInHour=24",
          localStorage: true,
          apiCallType: ApiCallType.get());

      updateShowNoData=true;
       // Get.back();
      dPrint("nnnnnnnnnnnnnn${jsonEncode(data)}");
      if (data["status"] == 1) {
        updateManualFoodList=data['responseValue'];
      } else {

        //Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue'].toString());
      }
    }
    catch (e) {
      updateShowNoData=true;
       // Get.back();

    }
  }


  List urinOutputList=[];
  List get getUrinOutputList=>urinOutputList;
  set updateUrinOutputList(List val){
    urinOutputList=val;
    notifyListeners();
  }
  // https://apishfc.medvantage.tech:7082/api/output/GetPatientOutputList?UHID=UHID00759
  urinHistory(context)async{
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    dPrint("vvvvvvvvvvvv ");
    updateShowNoData=false;
    try{
      var data=await _api.callMedvanatagePatient7082(context,
          url: "api/output/GetPatientOutputList?UHID=${userRepository.getUser.uhID.toString()}",
          localStorage: true,
          apiCallType: ApiCallType.get(),token: false);
      updateShowNoData=true;
      if (data["status"] == 1) {
        updateUrinOutputList=data['responseValue'];
      } else {

       // Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue'].toString());
      }


    }catch(e){
      updateShowNoData=true;
      dPrint("vvvvvvvvvvvv ");}
  }


  deletePatientOutput(context,{pmID,id})async{
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
      var data=await _api.callMedvanatagePatient7082(context, url: "api/output/DeletePatientOutput?pmID=${pmID}&Key=${id}&userID=${userRepository.getUser.userId.toString()}",
          apiCallType: ApiCallType.delete(body: {}),
          isSavedApi: true);
      dPrint("vvvvvvvvvvvv${jsonEncode(data)}");
     Get.back();
      if (data["status"] == 1) {

        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue']??''.toString());
      } else {

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue']??''.toString());
      }
    await urinHistory(context);


  }

  bool isUpdate=false;


  String selectedPmID='';
  String get getSelectedPmID=>selectedPmID;
  set updateSelectedPmID(String val){
    selectedPmID=val;
    notifyListeners();
  }

  String selectedID='';
  String get getSelectedID=>selectedID;
  set updateSelectedID(String val){
    selectedID=val;
    notifyListeners();
  }


  updatePatientOutput(context,)async{
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
      isUpdate=false;
      notifyListeners();
    try{
      var body = {
        'clientId': userRepository.getUser.clientId.toString(),
        'id': getSelectedID.toString(),
        'outputDate': DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
        'outputTypeID': 51,
        'pmID': getSelectedPmID.toString(),
        'quantity': urineC.value.text.toString(),
        'unitID': 1,
        'userID': userRepository.getUser.userId.toString()
      };
      dPrint("vvvvvvvvvvvv${body}");
      var data = await _api.callMedvanatagePatient7082(context,
          url: "api/output/UpdatePatientOutput",
          apiCallType: ApiCallType.rawPut(body: body),
          isSavedApi: true);

      dPrint("vvvvvvvvvvvv${jsonEncode(data)}");
       Get.back();

      if (data["status"] == 1) {

        // Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['responseValue'].toString()));
        myNewDialog(title:'Added successfully');
            // Alert.show(data['responseValue'] ?? ''.toString());
      } else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue'] ?? ''.toString());
      }
    }
    catch(e){
      Get.back();
    }
    // urineC.clear();
    notifyListeners();
    await urinHistory(context);


  }



  bool showNoData=false;
  bool get getShowNoData=>showNoData;
  set updateShowNoData(bool val){
    showNoData=val;
    notifyListeners();
  }

  List vitalHistoryList=[];
  List get getVitalHistoryList=>vitalHistoryList;
  set updateVitalHistoryList(List val){
    vitalHistoryList=val;
    notifyListeners();
  }


  dateWiseVitalMap(vitalDateTime,vitalId){
      List temp= vitalHistoryList.where((element) => element['vitalDateTime'].toString()==vitalDateTime.toString()).toList();
    List VitalData= temp.where((element) => element['vitalID'].toString()==vitalId.toString()).toList();
    return VitalData.isEmpty?'--':double.parse(VitalData[0]['vitalValue'].toString()).toStringAsFixed(0).toString();
  }


  hitVitalHistory(context) async {
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);

    updateShowNoData=false;
    try {

      Map<String, dynamic> body = { };


      var data = await _api.callMedvanatagePatient7082(context,
          url: 'api/PatientVital/GetPatientLastVital?uhID=${userRepository.getUser.uhID.toString()}',
          // url: 'HomeCareService/GetPatientLastVital?uhID=${userRepository.getUser.uhID.toString()}',
          localStorage: true,
          apiCallType: ApiCallType.get());
      clearData();

      updateShowNoData=true;
      dPrint("nnnnnnnnnnnnnn${jsonEncode(data)}");
      // final snackBar = SnackBar(
      //   content: Text("This is a SnackBar message!",style: MyTextTheme.mediumBCB,),
      //   duration: Duration(minutes: 2),  // Duration the SnackBar will be visible
      //   backgroundColor: Colors.white,   // Background color of the SnackBar
      //   behavior: SnackBarBehavior.floating, // Makes the SnackBar float above UI
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      if (data["status"] == 1) {
        updateVitalHistoryList=data['responseValue'];
        // Map<String, List<int>> vitalValues = {};
        //
        // for (var vital in data['responseValue']) {
        //   var name = vital["vitalName"];
        //   var value = vital["vitalValue"];
        //   var date = vital["vitalDateTime"];
        //
        //   if (vitalValues.containsKey(name)) {
        //     vitalValues[name]!.add(value);
        //   } else {
        //     vitalValues[name] = [value];
        //     vitalValues[date] = [date];
        //   }
        // }
        //
        // List<Map<String, dynamic>> result = vitalValues.entries
        //     .map((entry) => {
        //   "name": entry.key,
        //   "values": entry.value,
        // })
        //     .toList();
        // updateVitalHistoryList = result;
        // dPring("######################");
        // log(getVitalHistoryList.toString());

      } else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue'].toString());
      }
    }
    catch (e) {
      updateShowNoData=true;
      dPrint(e.toString());

    }

  }
//////////////////////////////add water qty////////////////////////
  TextEditingController intakeQTYC=TextEditingController();

  int  itemCount=1;

  var formKey1 = GlobalKey<FormState>();
  List addintakeQty=[
    '60','100','150','200'
  ];
  List get getaddintakeQty=>addintakeQty;
  set updateaddintakeQty(String val){
    addintakeQty.add(val);
    notifyListeners();
  }


  List confirmAddVital=[
    '60','100','150','200'

  ];
  List get getConfirmAddVital=>confirmAddVital;
  set updateConfirmAddVital(List val){
    confirmAddVital=val;
    notifyListeners();
  }

   int SelectedIndex=00;
  int get getSelectedIndex=>SelectedIndex;
  set updateSelectedIndex(int val){
    SelectedIndex=val;
    notifyListeners();
  }


  List patientPosition=[];
  List get getPatientPosition=>patientPosition;
  set updatePatientPosition(List val){
    patientPosition=val;
    notifyListeners();
  }

  String selectedPosition='';
String get getSelectedPosition=>selectedPosition;
set updateSelectedPosition(String val){
  selectedPosition=val;
  notifyListeners();
}
  Future<void> vitalPosition(BuildContext context,  ) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    var request = {};
    var data = await _api.callMedvanatagePatient7082(
        context,
        url:
        "api/StatusMaster/GetAllStatus?typeModule=VitalPosition",
        localStorage: true,
        apiCallType: ApiCallType.get( ),
        isSavedApi: true
    );
    dPrint(('nnnnn '+data.toString()));
    if (data['status'] == 0) {
      // Alert.show(data["responseValue"]);
    } else {
      updatePatientPosition=data["responseValue"] ;

    }

    dPrint("ANimesh$data");
  }
}
