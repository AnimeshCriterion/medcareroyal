
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Localization/app_localization.dart';
import '../Modal/activity_chromicle_data_modal.dart';
import '../View/Pages/activities_chronicle_view.dart';
import '../View/Pages/addvital_view.dart';
import '../View/Pages/pills_reminder_view.dart';
import '../View/Pages/urin_output.dart';
import '../View/Pages/water_intake_view.dart';
import '../View/widget/common_method/show_progress_dialog.dart';
import '../all_api.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_call.dart';
import '../authenticaton/user_repository.dart';
import '../main.dart';

class ActivitiesChronicleViewModal extends ChangeNotifier{
  final Api _api = Api();


  List bottomNavigationList=[
    {"title":"Activities",
    "icons":Icons.snowshoeing

    },
    {
      "title":"Food",
      "icons":Icons.rice_bowl_sharp
    },
    {
      "title":"Medicines",
      "icons":Icons.medical_information_outlined
    },
    {
      "title":"Vitals",
      "icons":Icons.output
    },
    {
      "title":"Output",
      "icons":Icons.output
    },
    {
      "title":"Others",
      "icons":Icons.devices_other
    },
  ];
  ///
  // onselectedPage(index){
  //   switch(val){
  //     case 'Activities':
  //       return ActivitiesChronicleView();
  //case 'Food':
  //       return SliderVerticalWidget();
  //case 'Medicines':
  //       return PillsReminderView();
  // case 'Vitals':
  //      return AddVitalView();
  //       case 'Output':
  // return UrinOutputView();
  //      case 'Others':
  //      return "";
 int selectedBottomIndex=0;
 set updateSelectedIndex(int val){
   selectedBottomIndex=val;
   notifyListeners();
 }


  List addVitalData=[];
List get getAddVitalData=>addVitalData;
set updateAddVitalData(List val){
  addVitalData=val;
  notifyListeners();
}
 removeVitalData(index){
   addVitalData.removeAt(index);
   notifyListeners();
 }
 clearVitalData(){
   addVitalData.clear();
   notifyListeners();
 }
 // List addVital=[
 //    {
 //      "id":1,
 //      "vital":"BP Diastolic",
 //      "value":false,
 //      "controller":TextEditingController(),
 //      "unit":"mmHg"
 //    },
 //      {
 //         "id":2,
 //         "vital":"BP Systolic",
 //        "value":false,
 //        "controller":TextEditingController(),
 //        "unit":"mmHg"
 //      },
 //    {
 //         "id":3,
 //         "vital":"Pulse Rate",
 //      "value":false,
 //      "controller":TextEditingController(),
 //      "unit":"/min"
 //            },
 //    {
 //         "id":4,
 //         "vital":"Spo2",
 //      "value":false,
 //      "controller":TextEditingController(),
 //      "unit":"%"
 //            },
 //    {
 //         "id":5,
 //         "vital":"Temperature",
 //      "value":false,
 //      "controller":TextEditingController(),
 //      "unit":" \u2109"
 //
 //    },
 //    {
 //         "id":6,
 //         "vital":"Glucose",
 //      "value":false,
 //      "controller":TextEditingController(),
 //      "unit":"mmol/L"
 //    },
 //  ];



  List vitalsList=[];
List get getVitalsList=>vitalsList;
set updateVVitalsList(List val){
  vitalsList=val;
  notifyListeners();
}

  ///////////////////............................////////////////////////////////
  bool isAddVital=false;

  Map<String, dynamic> allActivityChronicleData={};
  AllActivityChronicleDataModal get getAllActivityChronicleData=>
      AllActivityChronicleDataModal.fromJson(allActivityChronicleData);
  set updateAllActivityChronicleData( Map<String, dynamic> val){
    allActivityChronicleData=val;
    notifyListeners();
  }

  getActivityChronicleList(context)async{
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
   UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
   try{
     var data = await _api.callMedvanatagePatient(

     context,
     url:
     "${AllApi.allActivityCronicleList}UHID=${"UHID00901"}",
     localStorage: true,
     newBaseUrl: 'http://172.16.61.31:7080/',
     apiCallType: ApiCallType.post(body: {}),
   );
     Get.back();
     print('nnnnnnnnnnnnnnnnvnnvn '+ data["responseValue"][0]  .toString());
     print('nnnnnnnnnnnnnnnnvnnvn '+ data["responseValue"][0]['vitalList']  .toString());

     updateAllActivityChronicleData=(data["responseValue"]??[]).isEmpty? {}:data["responseValue"][0];
     updateVVitalsList=(data["responseValue"]??[]).isEmpty? {}:data["responseValue"][0]['vitalList'];
     for(int i=0;i<getVitalsList.length;i++){
       vitalsList[i]['isSelected']=false;
       notifyListeners();
     }

   }
       catch(e){
         Get.back();
       }
 }
///////////////////
//
  getVitalValue(vitalID){
  return  addVitalData.firstWhere((e) => e['vitalID'].toString()==vitalID.toString(),
    orElse: ()=>{'controller':TextEditingController()})['controller'].text;
  }

  AddVitalRequest(context,{systollicC,diatollicC,respiratoryC,spo2C,pulserateC,temperatureC,
    heartrateC,rbsC,weightC}) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    // var request = {};

    var sys=systollicC.toString()==''? '0':systollicC.toString();
    var dia=diatollicC.toString()==''? '0':diatollicC.toString();
    var rr=respiratoryC.toString()==''? '0':respiratoryC.toString();
    var spo2=spo2C.toString()==''? "0":spo2C.toString();

    var pr=pulserateC.toString()==''? "0":pulserateC.toString();

    var tmp=temperatureC.toString()==''?"0":temperatureC.toString();

    var hr=heartrateC.toString()==''?"0":heartrateC.toString();
    var rbs=rbsC.toString()==''?'0':rbsC.toString();
    var weight=weightC.toString()==''?'0':weightC.toString();
    var date=DateFormat('yyyy-MM-dd').format(DateTime.now());
    var time=DateFormat('HH:mm').format(DateTime.now());
    print('nnnnnnnnnnnnnnv '+time.toString());



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
      // "positionId": getSelectedPosition.toString()
    };
    var data = await _api.callMedvanatagePatient7082(NavigationService.navigatorKey.currentContext!,
        url:'api/PatientVital/InsertPatientVital',
        localStorage: true,
        apiCallType: ApiCallType.rawPost(body: body),
        isSavedApi: true);

    // var data = await _api.callMedvanatagePatient(
    //     context,
    //     url:
    //     "${AllApi.addVitalHM}uhID=${userRepository.getUser.uhID.toString()}&vmValueBPSys=${sys}&vmValueBPDias=${dia}&vmValueRespiratoryRate=${rr}&vmValueSPO2=${spo2}&vmValuePulse=${pr}&vmValueTemperature=${tmp}&vmValueHeartRate=${hr}&vmValueRbs=${rbs}&vmValueUrineOutput=0&weight=${weight}&isFromMachine=1&userId=${userRepository.getUser.userId.toString()}&IsFromPatient=true&vitalDate=${date}&vitalTime=${time}",
    //     localStorage: true,
    //     apiCallType: ApiCallType.post(body: request),
    //     isSavedApi: true
    // );
    Get.back();

    if (data['status'] == 0) {
      Alert.show(data["responseValue"]);
    } else {

      Get.back();
      Alert.show("Vital added successfully !");
    }

    print("ANimesh$data");
  }
}