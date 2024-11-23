


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';

import '../../../Localization/app_localization.dart';
import '../../../app_manager/api/api_call.dart';
import '../../../authenticaton/user_repository.dart';
import '../../../common_libs.dart';
import '../app_api.dart';

class ArchiveController extends GetxController{

  TextEditingController pidC=TextEditingController();

  List stethoAudio=[];
  // List get getStethoAudio=>stethoAudio;


  List get getStethoAudio=>
      pidC.value.text==''? stethoAudio:stethoAudio.where((element) =>
          (
              element['pid'].toString().toLowerCase()
          ).trim().contains(pidC.value.text.toLowerCase().trim())
      ).toList();

  set updateStethoAudio(List val){
    stethoAudio=val;
    update();
  }

  bool showNoData=false;
  bool get getShowNoData=>showNoData;
  set updateShowNoData(bool val){
    showNoData=val;
    update();
  }


  final Api _api = Api();

  getAudioList(context) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:'api/PatientMediaData/GetPatientMediaData?uhId=${userRepository.getUser.uhID.toString()}&category=stethoscope',
          localStorage: true,
          apiCallType: ApiCallType.get());

      ProgressDialogue().hide();
      dPrint(data.toString()+' kgvbnvcbnfxg');
      if (data["status"] == 1) {
        updateStethoAudio=data['responseValue'];
      } else {

      }
    } catch (e) {
      ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
      dPrint(e.toString());
    }
  }


//
  // getAudioList(context,pid) async {
  //
  //
  //   updateStethoAudio=[];
  //   updateShowNoData=false;
  //   var body={
  //     'userID':'1234567',
  //     'pid':pid.toString(),
  //   };
  //   var data=await App().api('patientConnectedDevice/GetPatientStethoFileList', body, context,token: true);
  //
  //   updateShowNoData=true;
  //   dPring('nnnnnnn '+data.toString());
  //   updateStethoAudio=data['stethofileList'];
  // }

bool isPlaying=false;
  bool get getIsPlaying=>isPlaying;
  set updateIsPlaying(bool val){
    isPlaying=val;
    update();
  }
}