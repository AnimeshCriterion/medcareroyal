

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

import '../View/Pages/lab_feild_view.dart';
import '../app_manager/api/api_util.dart';
import '../encyption.dart';
import '../medcare_utill.dart';

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

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    var basicAuth = 'Bearer ${ userRepository.getUser.token.toString()}';
    Map<String, String> body={
        'uhId': uhId.toString(),
        'category': 'investigation',
        'dateTime':DateTime.now().toString(),
        'userId':admitDoctorId.toString(),
        // 'formFile':getImgPath.toString()

      };
    dPrint("mdkgmg"+body.toString());

    String encryptedData = await EncryptDecrypt.encryptString(
        'uhId=${uhId}&category=investigation&dateTime=${DateTime.now().toString()}&userId=${admitDoctorId.toString()}', EncryptDecrypt.key);

      var request = http.MultipartRequest(
          'POST', Uri.parse(ApiUtil().baseUrlMedvanatge7082+'api/PatientMediaData/InsertPatientMediaData?'+encryptedData.toString()));

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'formFile', getImgPath.toString());

    request.files.add(multipartFile);
    request.headers.addAll(  {'Content-Type': 'application/json',
      'Authorization': basicAuth
    });

      http.StreamedResponse response = await request.send();



    Get.back();
    var data=await response.stream.bytesToString();
    var decryptData= await EncryptDecrypt.decryptString(jsonDecode(data)['data'],EncryptDecrypt.key.toString() ) ;

    // dPrint('nnvnnvnvnvnnnvnnnnnn https://apimedcareroyal.medvantage.tech:7082/api/PatientMediaData/InsertPatientMediaData?uhId=${uhId}&category=investigation&userId=${admitDoctorId.toString()}&dateTime=${DateTime.now().toString()}'+response.reasonPhrase.toString());
    dPrint('nnvnnvnvnvnnnvnnnnnn '+getImgPath.toString());
    dPrint('nnvnnvnvnvnnnvnnnnnn '+response.request.toString());
    dPrint('nnvnnvnvnvnnnvnnnnnn '+decryptData.toString());
    var url=jsonDecode(decryptData)['responseValue'].isEmpty? '':jsonDecode(decryptData)['responseValue'][0]['url'].toString();
      if (response.statusCode == 200) {

        await  getPatientMediaData(context);
        // https://apimedcareroyal.medvantage.tech:7082/Upload\Image\1730805217123_image_cropper_1730805195025.jpg
        // await labReportExtraction(context,'https://apimedcareroyal.medvantage.tech:7082/'+url.toString());
        // await labReportExtraction(context,ApiUtil().baseUrlMedvanatge7082.toString()+url.toString());
        alertToast(context, 'Report uploaded successfully');




      } else {
        dPrint(response.reasonPhrase);
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
      dPrint(data.toString()+' kgvbnvcbnfxg');
      if (data["status"] == 1) {
        updatePatientReportList=data['responseValue'];
      } else {

      }
    } catch (e) {
      dPrint(e.toString()+' kgvbnvcbnfxg');
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


    // ProgressDialogue().show(context, loadingText: 'Loading...');

    // try {
    //   var data = await _api.callMedvanatagePatient7082(context,
    //       url:'LabReportExtraction/?ImageUrl=${url.toString()}',
    //       newBaseUrl: 'http://172.16.19.195:8004/',
    //       localStorage: true,
    //       apiCallType: ApiCallType.get());
    //
    //   if(Map.from(data).keys.toList().contains('response')){
    //     dPrint(Map.from(data).keys.toList().toString()+' kgvbnvcbnfxg');
    //     updatePatientReportExtraction=data['response']['patient_details'];
    //
    //     dPrint(data.toString()+' nnnnnn');
    //
    //     for(int i=0;i<data['response']['report'].length;i++){
    //       data['response']['report'][i].addAll(
    //           {'val': TextEditingController(text:data['response']['report'][i]['result'].toString())});
    //     }
    //
    //     updateReportExtraction=data['response']['report'];
    //
    //     Get.back();
    //     Get.to(LabFeildView());
    //   }
    //
    // } catch (e) {
    //   Get.back();
    //   dPrint(e.toString()+' kgvbnvcbnfxg');
    // }
  }

  // http://172.16.19.195:8004/docs
  insertInvesigation(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

    ProgressDialogue().show(context, loadingText: 'Loading...');
    List temp=[];

    for(int i=0;i<getReportExtraction.length;i++){
    //   subTestId INT PATH '$.subTestId',
    // subTestname VARCHAR(50) PATH '$.subTestname',
    // isNormal INT PATH '$.isNormal',
    // result DECIMAL(10,2) PATH '$.result',
    // unit VARCHAR(50) PATH '$.unit',
    // `range` VARCHAR(50) PATH '$.range',
    // resultDateTime VARCHAR(50) PATH '$.resultDateTime'
          temp.add({ "itemName":' ',
            "itemId":'',
            "labName": getPatientReportExtraction['lab_name'].toString(),
            "receiptNo":'',
            "resultDateTime": getPatientReportExtraction['collection_date'].toString(),
            "investigationResultJson": [
              { "subTestId": getReportExtraction[i]['id'].toString() ,
                "subTestName": getReportExtraction[i]['test_name'].toString() ,
                "range": getReportExtraction[i]['normal_values'].toString() ,
                "resultDateTime":getPatientReportExtraction['collection_date'].toString(),
              "result": getReportExtraction[i]['result'].toString() ,
              "unit": getReportExtraction[i]['unit'].toString() ,
              "isNormal":'1' ,
              }
            ],
            "clientId": userRepository.getUser.clientId.toString()
          });
      }

   var body= {
      "uhid": userRepository.getUser.uhID.toString(),
    "investigationDetailsJson": temp
    };
    try {
      var data = await _api.callMedvanatagePatient7096(context,
          url:'api/InvestigationByPatient/InsertResult',
          localStorage: true,
          apiCallType: ApiCallType.post(body: body));
      Get.back();
      dPrint(data.toString()+' kgvbnvcbnfxg');
      if (data["status"] == 1) {
        updatePatientReportList=data['responseValue'];
      } else {

      }
    } catch (e) {
      Get.back();
      dPrint(e.toString()+' kgvbnvcbnfxg');
    }
}
}