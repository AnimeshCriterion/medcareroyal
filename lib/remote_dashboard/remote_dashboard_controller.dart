import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/app_manager/extentions/hex_color_extention.dart';
import 'package:medvantage_patient/remote_dashboard/remoteMonitorDataModel.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../authenticaton/user_repository.dart';
import '../common_libs.dart';
import 'data_model/drug_intraction_data_modal.dart';
import 'data_model/effected_medicine_data_modal.dart';
import 'data_model/other_side_effect_data_modal.dart';
import 'data_model/select_test_category_data_modal.dart';
import 'data_model/vital_graph_data_modal.dart';

final Color lightRed = "#c5756d".toColor();
final Color yellow = "#ffa500".toColor();
final Color red = "#ff0000".toColor();
final Color lightGreen = "#aeefae".toColor();
final Color green = "#008000".toColor();

class RemoteDashboardController extends GetxController {

  Color pageColor = '#011e37'.toString().toColor();

  late AnimationController animationController;

  TextEditingController searchC=TextEditingController();



  RemoteDashboardMonitoringDataModal selectedPatient=RemoteDashboardMonitoringDataModal();
  RemoteDashboardMonitoringDataModal get getSelectedDPatient=>selectedPatient;
  set updateSelectedPatient(RemoteDashboardMonitoringDataModal val){
    selectedPatient=val;
    update();
  }


  List remoteData = [];


  List<RemoteDashboardMonitoringDataModal> get getRemoteData => List<RemoteDashboardMonitoringDataModal>.from(((searchC.value.text == ''?
      remoteData
      : remoteData.where((e) =>
      (e['patientDataList'].toString().toLowerCase().trim()+
          e['patientDataList'].toString().toLowerCase().trim())
          .trim()
          .contains(searchC.value.text.toLowerCase().trim())))
      .map((element) => RemoteDashboardMonitoringDataModal.fromJson(element))));

  set updateRemoteData(List val) {
    // print('nnvnnnvnvnvnvnnv'+val.toString());
    remoteData = val;
    update();
  }

  dashboardVital(vitalId, index) {
    var data = (getRemoteData[index].patientDataList!.vitalParametersList ?? [])
        .where((element) => element.vitalID.toString() == vitalId.toString())
        .toList();

    // if (getRemoteData[index].patientDataList!.vitalParametersList != null) {}

    if (data.isNotEmpty) {
      return data[0].vitalValue!.toStringAsFixed(0);
    } else {
      return '-';
    }
  }

  dashboardVitalColor(vitalId, index) {
    var data = (getRemoteData[index].patientDataList!.vitalParametersList ?? [])
        .where((element) => element.vitalID.toString() == vitalId.toString())
        .toList();
    if (getRemoteData[index].patientDataList!.vitalParametersList != null) {
      print('nvnvnvnvn${data.length}');
    }
    if (data.isNotEmpty) {
      return data[0].vitalColor.toString().contains('#')
          ? data[0].vitalColor?.toColor()
          : _getColor(data[0].vitalColor.toString().toLowerCase());
    }
  }

  dashboardTimeDiff(vitalId, index) {
    var data = (getRemoteData[index].patientDataList!.vitalParametersList ?? [])
        .where((element) => element.vitalID.toString() == vitalId.toString())
        .toList();

    if (data.isNotEmpty) {
      int totalSeconds = DateTime.now()
          .difference(DateTime.parse(data[0].vitalDateTime.toString()))
          .inSeconds;

      return changeTime(totalSeconds);
    } else {
      return '';
    }
  }

  changeTime(int val) {
    if (val > (3600 * 24)) {
      return '${int.parse((val / (3600 * 24)).toStringAsFixed(0))} d';
    } else if (val < (3600 * 24) && val > 3600) {
      return '${int.parse((val / 3600).toStringAsFixed(0))} Hr';
    } else if (val < 3600 && val > 60) {
      return '${int.parse((val / 60).toStringAsFixed(0))} Min';
    } else if (val < 60) {
      return '${int.parse(val.toStringAsFixed(0))} S';
    }
  }

  vitalTimeBlinkColor(vitalId, index) {
    var data = (getRemoteData[index].patientDataList!.vitalParametersList ?? [])
        .where((element) => element.vitalID.toString() == vitalId.toString())
        .toList();

    if (data.isNotEmpty) {
      int totalSeconds = DateTime.now()
          .difference(DateTime.parse(data[0].vitalDateTime.toString()))
          .inSeconds;

      if (totalSeconds >= (3600 * 2)) {
        return Colors.redAccent;
      } else if (totalSeconds < (3600 * 2) && totalSeconds >= 3600) {
        return Colors.red;
      } else if (totalSeconds < 3600 && totalSeconds > 60) {
        return Colors.green;
      } else if (totalSeconds < 60) {
        return Colors.green;
      }
    } else {
      return Colors.white;
    }
  }

  bpMapValue({required String sys, required String dys}) {
    double mapvalue = 0.0;
    if (sys != '-' && dys != '-') {
      mapvalue =
          ((double.parse(sys.toString()) + (2 * double.parse(dys.toString()))) /
              3);
    }
    return mapvalue.toStringAsFixed(0);
  }

  Color _getColor(String val) {
    switch (val.toLowerCase()) {
      case 'red':
        return red;
      case 'green':
        return green;

      case 'lightred':
        return lightRed;
      case 'lightgreen':
        return lightGreen;
      case 'yellow':
        return yellow;
      case 'notifycolor':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  // PatientDashBoardDataModel get getRemoteData=>PatientDashBoardDataModel.fromJson(remoteData);
  //
  //
  // set updateRemoteDataa(val){
  //   remoteData=val;
  //   update();
  // }

  List<ColorCodes> colorCodes = [
    ColorCodes(color: green, title: 'Normal'),
    ColorCodes(color: lightGreen, title: 'Borderline Normal Side'),
    ColorCodes(color: yellow, title: 'Border Line'),
    ColorCodes(color: lightRed, title: 'Borderline Abnormal Side'),
    ColorCodes(color: red, title: 'Abnormal'),
  ];

  bool showVitals = true;

  bool get getShowVitals => showVitals;

  set updateShowVitals(bool val) {
    showVitals = val;
    update();
  }

  onPressSwitch() {
    updateShowVitals = !getShowVitals;
  }

  // PatientAdded
  // UpdatedPatientVitals
  // UpdatePatientInvestigation
  // UpdatePatientDiagonsis
  // UpdatePatientPacs
  // PatientOnLifeSupport
  // PatientOnInfusionPumpData
  // PatientReleaseFromInfusionPumpData
  // PatientReleaseFromLifeSupport
  // PatientOnOxygenSupport
  // PatientReleaseFromOxygenSupport
  // PatientOnDVTPumpSupport
  // PatientECGGraph
  // PatientReleaseFromDVTPumpSupport
  // PatientOnFeed
  // PatientFeedback
  // RemovePatient

  // SignalR
  // https://api.medvantage.tech
  // http://172.16.61.31:7085

  final serverUrl = "https://apimedcareroyal.medvantage.tech:7085/PatientDashboard";

  // final hubConnection = new HubConnectionBuilder().withUrl(serverUrl).build();

  // hubCallback: (methodName, message) => print('MethodName = $methodName, Message = $message'));


  connectServer(context) async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    print(hubConnection.state.toString());
    await hubConnection.start();
    // print('nnnnnnn${hubConnection.connectionId}');

    // var clientId = UserData().getUserData.clientId.toString();
    // var id = UserData().getUserData.id.toString();

    //hubConnection.on("PatientAdded", PatientAdded([id,clientId]));

    // print("clientId:$clientId");
    print(hubConnection.state.toString());

    dynamic data =
        await hubConnection.invoke("AddUser", args: <Object>[int.parse(userRepository.getUser.clientId.toString()),
          int.parse(275.toString())]);

    // if(data['status']==1){
    print('nnnnnnvnnnvnnnn${data['responseValue'].length.toString()}');
    updateRemoteData = data['responseValue'];

  }



  List data = [].obs;
  List vitalList = [].obs;

  List<VitalDataModel> get getVitalData => List<VitalDataModel>.from(
      data.map((element) => VitalDataModel.fromJson(element)));

  List<VitalChartData> get getChartData => List<VitalChartData>.from(
      vitalList.map((element) => VitalChartData.fromJson(element)));

//filter list for Diastolic data
  List<VitalChartData> get getDiastolic => List<VitalChartData>.from(
      (vitalList.where((element) => element['vitalName'] == 'BP_Dias').toList())
          .map((element) => VitalChartData.fromJson(element)));

  //filter list for Systolic data
  List<VitalChartData> get getSystolic => List<VitalChartData>.from(
      (vitalList.where((element) => element['vitalName'] == 'BP_Sys').toList())
          .map((element) => VitalChartData.fromJson(element)));

  //filter list for BP data
  List<VitalChartData> get getBp => List<VitalChartData>.from(
      (vitalList.where((element) => element['vitalName'] == 'BP').toList())
          .map((element) => VitalChartData.fromJson(element)));

  set updateVitalData(List val) {
    vitalList.clear();
    data = val;
    update();

    print('nnnnnnnn ' + getBp.length.toString());
    for (int i = 0; i < data.length; i++) {
      vitalList.add({
        'vitalDate': data[i]['vitalDateTime'],
        'vitalDateForGraph':  data[i]['vitalDateTime'],
        'vitalName': data[i]['vitalName'],
        'vitalValue': data[i]['vitalValue'],
      });
    }

    update();
  }







  getPatientVitalGraph(
      {required String UHID, required String vitalIdSearchNew}) async {

    // ProgressDialogue().show(loadingText: 'Loading...');
    // String userId = localDataStorage.getUserData.id.toString();
    // Response response = await masterApi.getApi(
    //   'PatientVital/GetPatientVitalGraphByDate?userId=${userId}&UHID=${UHID}&vitalIdSearchNew=${vitalIdSearchNew}&vitalDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}&CurrentDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}'
    // );
    // Get.back();
    // print('nnnnnnn' + response.body.toString());
    // if (response.body['status'] == 1) {
    //   updateVitalData = response.body['responseValue']['patientGraph'].isEmpty? []:
    //   jsonDecode(response.body['responseValue']['patientGraph'][0]['vitalDetails']);
    //
    //   print('nnnnnnn' + data.toString());
    // }
  }


  List effectedMedicineList = [];

  List<EffectedMedicineDataModal> get geteffectedMedicineList =>
      List<EffectedMedicineDataModal>.from(effectedMedicineList
          .map((e) => EffectedMedicineDataModal.fromJson(e)));

  set updateEffectedMedicineList(List val) {
    effectedMedicineList = val;
    update();
  }

  List otherSideEffectList = [];

  List<OtherSideEffectDataModal> get getOtherSideEffectList =>
      List<OtherSideEffectDataModal>.from(
          otherSideEffectList.map((e) => OtherSideEffectDataModal.fromJson(e)));

  set updateOtherSideEffectList(List val) {
    otherSideEffectList = val;
    update();
  }


  sideEffectChecker(context,
      {required String brandId,
      required String medicineId,
      required String problemId}) async {

    // {"PId":28803,"
    // ""BrandId":22908,"DrugName":"dry syrup - CEFLENTE - 50.00 - mg","PrescreptionDateTime":"2023-06-28 17:53:21","UserId":99}

    var body = {
      'brandId': brandId.toString(),
      'medicineId': medicineId.toString(),
      'problemId': problemId.toString()
    };
    print(body.toString());
    // Response response =
    //     await api7082.postDataByJson('ADRReport/sideEffectChecker', body);

    // if (response.body['status'] == 1) {
    //   updateEffectedMedicineList =
    //       response.body['responseValue'][0]['effectedMedicine'];
    //   updateOtherSideEffectList =
    //       response.body['responseValue'][0]['otherSideEffect'];
    //
    //
    // }
  }

  clearData(){
    effectedMedicineList = [];
    otherSideEffectList = [];
    drugIntractionList=[];
    update();
  }

  List drugIntractionList=[];

  List<DrugIntractionDataModal> get getDrugIntractionList=>List<DrugIntractionDataModal>.from(
      drugIntractionList.map((e) => DrugIntractionDataModal.fromJson(e)));

  set updateDrugIntractionList(List val){
    drugIntractionList=val;
    update();
  }
  //
  // getDrugIntraction(brandId,medicineName) async {
  //   var body = {
  //     'brandId': brandId.toString(),
  //     'medicineName': medicineName.toString(),
  //   };
  //   print(body.toString());
  //   Response response = await api7082.postDataByJson('ADRReport/getDrugIntraction', body);
  //
  //   if (response.body['status'] == 1) {
  //     updateDrugIntractionList=response.body['responseValue'];
  //   }

  }



  List testCategoryList=[];
  List<SelectTestCategoryDataModal> get getTestCategoryList=>List<SelectTestCategoryDataModal>.
  from(testCategoryList.map((e) => SelectTestCategoryDataModal.fromJson(e)));
  set updateTestCategoryList(List val){
    testCategoryList=val;
    // update();
  }

  int selectedInvestigation=0;
  int get getSelectedInvestigation=>selectedInvestigation;
  set updateSelectedInvestigation(int val){
    selectedInvestigation=val;
    // update();
  }


  selectTestCategory(context,  ) async {


  //   Response response =
  //   await masterApi.getApi('AllMasters/SelectTestCategory', );
  //   print(response.body.toString());
  //   if (response.body['status'] == 1) {
  //     updateTestCategoryList=response.body['responseValue'];
  //     investigationDetailsModule(context);
  //   }
  // }
}

class ColorCodes {
  Color color;
  String title;

  ColorCodes({
    required this.color,
    required this.title,
  });
}
