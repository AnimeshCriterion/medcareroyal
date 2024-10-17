

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

import '../Localization/app_localization.dart';
import '../app_manager/dialog.dart';

class ReportTrackingViewModal extends ChangeNotifier{

 
  String imgPath='';
  String get getImgPath=>imgPath;
  set updateImgPath(String val){
    imgPath=val;
    notifyListeners();
  }

  final Api _api = Api();

  insertPatientMediaData(context,{uhId,admitDoctorId}) async {

    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.uploading.toString());

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
    await getPatientMediaData(context);
      if (response.statusCode == 200) {
        myNewDialog(title:"Report uploaded successfully");
        // Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Report uploaded successfully'.toString()));
        // alertToast(context, 'Report uploaded successfully');




      } else {
        print(response.reasonPhrase);
      }


  }


  bool showNoData=false;
  bool get getShowNoData=>showNoData;
  set updateShowNoData(bool val){
    showNoData=val;
    notifyListeners();
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
    updateShowNoData=false;
    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:'api/PatientMediaData/GetPatientMediaData?uhId=${userRepository.getUser.uhID.toString()}&category=investigation',
          localStorage: true,
          apiCallType: ApiCallType.get());

      updateShowNoData=true;
      print(data.toString()+' kgvbnvcbnfxg');
      if (data["status"] == 1) {
        updatePatientReportList=data['responseValue'];
      } else {

      }
    } catch (e) {
      updateShowNoData=true;
      print(e.toString()+' kgvbnvcbnfxg');
    }
  }

}