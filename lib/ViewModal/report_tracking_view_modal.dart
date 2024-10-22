

import 'dart:convert';

import 'package:get/get.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReportTrackingViewModal extends ChangeNotifier{

 
  String imgPath='';
  String get getImgPath=>imgPath;
  set updateImgPath(String val){
    imgPath=val;
    notifyListeners();
  }

  final Api _api = Api();

  insertPatientMediaData(context,{uhId,admitDoctorId}) async {


    ProgressDialogue().show(context, loadingText: 'Loading...');

    Map<String, String> body={
        'uhId': uhId.toString(),
        'category': 'investigation',
        'dateTime':DateTime.now().toString(),
        'userId':admitDoctorId.toString(),
        // 'formFile':getImgPath.toString()

      };
    print("mdkgmg"+body.toString());


      var request = http.MultipartRequest(
          'POST', Uri.parse('https://apimedcareroyal.medvantage.tech:7082/api/PatientMediaData/InsertPatientMediaData?uhId=${uhId}&category=investigation&dateTime=${DateTime.now().toString()}&userId=${admitDoctorId.toString()}'));

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'formFile', getImgPath.toString());

    request.files.add(multipartFile);
    request.headers.addAll(  {'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();



    Get.back();
    var data=await response.stream.bytesToString();
    print('nnvnnvnvnvnnnvnnnnnn https://apimedcareroyal.medvantage.tech:7082/api/PatientMediaData/InsertPatientMediaData?uhId=${uhId}&category=investigation&userId=${admitDoctorId.toString()}&dateTime=${DateTime.now().toString()}'+response.reasonPhrase.toString());
    print('nnvnnvnvnvnnnvnnnnnn '+getImgPath.toString());
    print('nnvnnvnvnvnnnvnnnnnn '+response.request.toString());
    print('nnvnnvnvnvnnnvnnnnnn '+data.toString());
    var url=jsonDecode(data)['responseValue'].isEmpty? '':jsonDecode(data)['responseValue'][0]['url'].toString();
      if (response.statusCode == 200) {

        await  getPatientMediaData(context);
        // await labReportExtraction(context,'https://apimedcareroyal.medvantage.tech:7082/Upload/Image/'+url.toString());
        alertToast(context, 'Report uploaded successfully');




      } else {
        print(response.reasonPhrase);
      }


  }



  List patientReportList=[];
  List get getPatientReportList=>patientReportList;
  set updatePatientReportList(List val){
    patientReportList=val;
    notifyListeners();
  }


  getPatientMediaData(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:'api/PatientMediaData/GetPatientMediaData?uhId=${userRepository.getUser.uhID.toString()}&category=investigation',
          localStorage: true,
          apiCallType: ApiCallType.get());
      print(data.toString()+' kgvbnvcbnfxg');
      if (data["status"] == 1) {
        updatePatientReportList=data['responseValue'];
      } else {

      }
    } catch (e) {
      print(e.toString()+' kgvbnvcbnfxg');
    }
  }

  String selectedInvestigation='';
  String get getSelectedInvestion=>selectedInvestigation;
  set updateSelectedInvestigation(String  val){
    selectedInvestigation=val;
    notifyListeners();
  }

  List upperList=[
    {
      'title':'Radiology',
      'img':'assets/radiology.png',
    },
    {
      'title':'Imaging',
      'img':'assets/imaging.png',
    },
    {
      'title':'Lab',
      'img':'assets/lab.png',
    },
  ];

  String selectedTestType='';
  String get getSelectedTestType=>selectedTestType;
  set updateSelectedTestType(String val)
  {
    selectedTestType=val;
    notifyListeners();

  }
  // http://172.16.19.195:8004/LabReportExtraction/?ImageUrl=s.jpg


  Map patientReportExtraction= {};
  Map get getPatientReportExtraction=>patientReportExtraction;

  set updatePatientReportExtraction(Map val){
    patientReportExtraction=val;
    notifyListeners();
  }


  List reportExtraction=[];
  List get getReportExtraction=>reportExtraction;
  set updateReportExtraction(List val){
    reportExtraction=val;
    notifyListeners();
  }



  labReportExtraction(context,url) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:'LabReportExtraction/?ImageUrl=${url.toString()}',
          newBaseUrl: 'http://172.16.19.195:8004/',
          localStorage: true,
          apiCallType: ApiCallType.get());

      print(data.toString()+' kgvbnvcbnfxg');
      if(Map.from(data).keys.contains('response')){
        updatePatientReportExtraction=data['response'];


        for(int i=0;i<=data['response']['report'].length;i++){
          data['response']['report'][i].add(
              {'val': TextEditingController(text:data['response']['report'][i]['result'].toString())});
        }

        updateReportExtraction=data['response']['report'];

        // Get.to(LabFeildView());
      }

    } catch (e) {
      print(e.toString()+' kgvbnvcbnfxg');
    }
  }

  // http://172.16.19.195:8004/docs
  insertInvesigation(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
   var body= {
      "uhid": userRepository.getUser.uhID.toString(),
    "investigationDetailsJson": [
      { "itemName": '',
    "itemId":'',
    "labName":'',
    "receiptNo":'',
    "resultDateTime":'',
    "investigationResultJson": [
      { "subTestId":'',
      "subTestName":'',
      "range":'',
      "resultDateTime":'',
      }
    ],
    "clientId": userRepository.getUser.clientId.toString()
  }]};
    try {
      var data = await _api.callMedvanatagePatient7096(context,
          url:'api/InvestigationByPatient/InsertResult',
          localStorage: true,
          apiCallType: ApiCallType.post(body: body));
      print(data.toString()+' kgvbnvcbnfxg');
      if (data["status"] == 1) {
        updatePatientReportList=data['responseValue'];
      } else {

      }
    } catch (e) {
      print(e.toString()+' kgvbnvcbnfxg');
    }
}
}