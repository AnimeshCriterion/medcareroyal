
import 'dart:convert';

import 'package:medvantage_patient/LiveVital/lw_ct_stethoscope/stetho_recording/stetho_recording_data_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../stethoscope_controller.dart';

class StethoController extends GetxController{

 StethoscopeController controller=Get.put(StethoscopeController());

 Rx<TextEditingController> pidTextC=TextEditingController().obs;

 String fileOnePath='';
 String get getFileOnePath=>fileOnePath;
 set updateFileOnePath(String val){
  fileOnePath=val;
  update();
 }

 String fileTwoPath='';
 String get getFileTwoPath=>fileTwoPath;
 set updateFileTwoPath(String val){
  fileTwoPath=val;
  update();
 }


 bool showNoData=false;
 bool get getShowNoData=>showNoData;
 set updateShowNoData(bool val){
  showNoData=val;
  update();
 }


 List recordingData=[];
 List<StethoRecordingDataModal> get getRecordingData=>List<StethoRecordingDataModal>.from(
     recordingData.map((element) => StethoRecordingDataModal.fromJson(element))
 );
 set updateRecordingData(List val){
  recordingData=val;
  update();
 }


 getRecording(context) async {
  updateShowNoData=false;
  var body={};
  // var userId=controller.getSelectedMemberId.toString()!=''? controller.getSelectedMemberId.toString():UserData().getUserMemberId.toString();

  // print('http://aws.edumation.in:5001/sthethoapi/recordingupload/$userId');
  var response = await http.get(Uri.parse('http://aws.edumation.in:5001/sthethoapi/recordingupload/${pidTextC.value.text.toString()}'),

      headers: {
       "authKey": "4S5NF5N0F4UUN6G",
       "content-type": "application/json",
      });
  updateShowNoData=true;
  print(body.toString());
  var data = await json.decode(response.body);
  for(int i=0;i<data['data'].length;i++){
   data['data'][i].addAll({'downloadPer':'0'});
  }
  updateRecordingData=data['data'];
  print('nnnvnnnnvnnnv'+jsonEncode(data).toString());
  // RawData().api('', body, context,isNewBaseUrl: true,newBaseUrl: 'http://aws.edumation.in:5001/sthethoapi/recordingupload/$userId');
  // print(data.toString());

 }
 addPercent(index,per){
  recordingData[index]['downloadPer']=per.toString();
  update();
 }


 //// chart
 List<double> audioSamplesOne = [];
 List<double> get getAudioSamplesOne=>audioSamplesOne;
 set updateAudioSamplesOne(List<double> val){
  audioSamplesOne=val;
  update();
 }

 List<double> audioSamplesTwo=[];
 List<double> get getAudioSampleTwo=>audioSamplesTwo;
 set updateAudioSamplesTwo(List<double> val){
  audioSamplesTwo=val;
  update();
 }

 List<String> downloads=[];
 List<String> get getDownloads=>downloads;
 set updateDownloads(String val){
  downloads.add(val);
  update();
 }

}