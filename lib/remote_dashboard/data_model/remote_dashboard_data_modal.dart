






import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/extentions/hex_color_extention.dart';

final Color lightRed="#c5756d".toColor();
final Color yellow="#ffa500".toColor();
final Color red="#ff0000".toColor();
final Color lightGreen="#aeefae".toColor();
final Color green="#008000".toColor();

class RemoteDashboardDataModal{
  String? patientName;
  String? pid;
  String? age;
  String? gender;
  String? mobileNo;
  String? admitDateTime;
  String? consultantName;
  String? wardName;
  String? totalNotificationCount;
  VitalDetail? vitalDetail;
  InvestigationDetail? investigationDetails;
  IoDetails? ioDetails;
  RegVitalDetail? regVitalDetail;


  String? o2_conc;
  String? o2_concUnit;
  String? peep;
  List<VentilatorModeDetailModal>? ventilatorModeDetail;
  List<InfusionDetailModal>? infusionDetail;
  String? noradDetail;
  String? machineType;
  String? machineType1;
  String? noradPrescribed;
  String? isRTFeed;
  String? o2;
  String? o2Unit;
  String? o2DayDiff;
  String? lifeSupportType1;
  String? oxyIconImage;
  String? pawDetail;
  int? o2Level;

  String? wardShortName;
  String? bedName;
  String? subDepartmentName;
  String? totalAdmitDays;
  String? wardTransferDate;
  String? noOfTransfer;
  String? isQuarantineCompleted;

  List<DiagnosisModal>? diagnosis;
  String? pacsDetail;

  String? nsDetail;

  String? wardMobileNo;
  int? intercomNo;
  String? o2AtAdmit;

  //vvvvvvvvviiiiiiiiisssssssssshhhhhhhhhhhhaaaaaaaaaaaaaaallllllllllllllllllllllll
  String? feedback;
  Color? feedbackColor;
  List<FeedbackDetailModal>? feedbackDetail;
  String? pmID;

  String? isExistsFenta;
  String? isExistsNorad;
  String? isExistsAdernaline;
  String? isExistsVasopressin;
  String? isExistsIVFluid;
  String? isExistsMidaz;
  int? isCovid;
  int? wardID;
  String? currentDrugId;


  RemoteDashboardDataModal(
      {
        this.patientName,
        this.pid,
        this.age,
        this.gender,
        this.mobileNo,
        this.admitDateTime,
        this.consultantName,
        this.wardName,
        this.totalNotificationCount,
        this.vitalDetail,
        this.investigationDetails,
        this.ioDetails,
        this.regVitalDetail,

        this.o2_conc,
        this.o2_concUnit,
        this.peep,
        this.ventilatorModeDetail,
        this.infusionDetail,
        this.noradDetail,
        this.machineType,
        this.machineType1,
        this.noradPrescribed,
        this.isRTFeed,
        this.o2,
        this.o2Unit,
        this.o2DayDiff,
        this.lifeSupportType1,
        this.oxyIconImage,
        this.pawDetail,
        this.o2Level,

        this.wardShortName,
        this.bedName,
        this.subDepartmentName,
        this.totalAdmitDays,
        this.wardTransferDate,
        this.noOfTransfer,
        this.isQuarantineCompleted,

        this.diagnosis,
        this.pacsDetail,

        this.nsDetail,

        this.wardMobileNo,
        this.intercomNo,
        this.o2AtAdmit,


        //vvvvvvvvviiiiiiiiisssssssssshhhhhhhhhhhhaaaaaaaaaaaaaaallllllllllllllllllllllll
        this.feedback,
        this.feedbackColor,
        this.feedbackDetail,
        this.pmID,

        this.isExistsAdernaline,
        this.isExistsFenta,
        this.isExistsIVFluid,
        this.isExistsNorad,
        this.isExistsVasopressin,
        this.isExistsMidaz,
        this.isCovid,
        this.wardID,
        this.currentDrugId

      });

  factory RemoteDashboardDataModal.fromJson(Map<String, dynamic> json) => RemoteDashboardDataModal(
    patientName: json['patientName'].toString(),
    pid: json['pid'].toString(),
    age: json['age'].toString(),
    gender: json['gender'].toString(),
    mobileNo: json['mobileNo'].toString(),
    admitDateTime: json['admitDateTime'].toString(),
    consultantName: json['consultantName'].toString(),
    wardName: json['wardName'].toString(),
    totalNotificationCount: json['totalNotificationCount'].toString(),
    vitalDetail: VitalDetail(
      pulseRate: _vitalDetails(json,3),
      bpSys: _vitalDetails(json,4),
      bpDia: _vitalDetails(json,6),
      spo2: _vitalDetails(json,56),
      respRate: _vitalDetails(json,7,
          getMachineData: 1),
      heartRate: _vitalDetails(json,74),
      respRateMacine: _vitalDetails(json,7,
          getMachineData: 0),

    ),
    investigationDetails: InvestigationDetail(
      ca: _vitalDetails(json, 612,
          valueInDouble: true,
          nutritionId: 2,
          parameter: "investigationDetail"),
      serumCa: _vitalDetails(json, 187,
          valueInDouble: true,
          parameter: "investigationDetail"),

      alb: _vitalDetails(json, 206,
          valueInDouble: true,
          nutritionId: 1420,
          parameter: "investigationDetail"),

      k: _vitalDetails(json, 611,
          valueInDouble: true,
          nutritionId: 8265,
          parameter: "investigationDetail"),
      serumK: _vitalDetails(json, 499,
          valueInDouble: true,
          parameter: "investigationDetail"),
      nA: _vitalDetails(json, 610,
          valueInDouble: true,
          nutritionId: 336,
          parameter: "investigationDetail"),
      serumNa: _vitalDetails(json, 498,
          valueInDouble: true,
          parameter: "investigationDetail"),

      mg: _vitalDetails(json, 250,
          valueInDouble: true,
          nutritionId: 1178,
          parameter: "investigationDetail"),
      ph: _vitalDetails(json, 607,
          valueInDouble: true,
          parameter: "investigationDetail"),

      pco2: _vitalDetails(json, 608,
          parameter: "investigationDetail"),


      etco2: _vitalDetails(json, 225,),
      po2: _vitalDetails(json, 609,
          parameter: "investigationDetail"),

      lactate: _vitalDetails(json, 614,
          parameter: "investigationDetail"),


      rbs: _vitalDetails(json, 10,),



      tmp: _vitalDetails(json, 5,
          valueInDouble: true),


      creatinine: _vitalDetails(json, 497,
          parameter: "investigationDetail"),


      bUrea: _vitalDetails(json, 496,
          parameter: "investigationDetail"),

      sgot: _vitalDetails(json, 256,
          parameter: "investigationDetail"),

      sgpt: _vitalDetails(json, 740,
          parameter: "investigationDetail"),




    ),

    ioDetails: IoDetails(
      urineOutput: json['urineOutput'].toString(),
      totalIntake: json['totalIntake'].toString(),
      urineProblem: (json['urineProblem']??"").toString(),
      urineProblemColor: _getColor(json['urineProblemColor'].toString()),
      urineProblemMessage: json['urineProblemMessage'].toString(),
    ),


    regVitalDetail: RegVitalDetail(

      BP_Dias:_vitalDetails(json, 6,parameter:'regVitalDetail' )  ,
      BP_Sys:_vitalDetails(json, 4,parameter:'regVitalDetail')  ,
      spo2:_vitalDetails(json, 56,parameter:'regVitalDetail') ,
      Pulse: _vitalDetails(json, 3,parameter:'regVitalDetail') ,
      Temperature:_vitalDetails(json, 5,parameter:'regVitalDetail',valueInDouble: true
      ),
    ),



    o2_conc: json['o2_conc'].toString(),
    o2_concUnit: json['o2_concUnit'].toString(),
    peep: json['peep'].toString(),
    ventilatorModeDetail: List<VentilatorModeDetailModal>.from(
        jsonDecode(json['ventilatorModeDetail']??'[]').map((element) => VentilatorModeDetailModal.fromJson(element))
    ),
    infusionDetail: List<InfusionDetailModal>.from(
        jsonDecode(json['infusionDetail']??'[]').map((element) => InfusionDetailModal.fromJson(element))
    ),

    noradDetail: json['noradDetail']?? ''.toString(),
    machineType: json['machineType']?? ''.toString(),
    machineType1: json['machineType1']?? ''.toString(),
    noradPrescribed: (json['noradPrescribed']?? "").toString() ,
    isRTFeed:  (json['isRTFeed']?? "").toString() ,
    o2: json['o2'].toString(),
    o2Unit: json['o2Unit'].toString(),
    o2DayDiff: json['o2DayDiff'].toString(),
    lifeSupportType1: json['lifeSupportType1']?? ''.toString(),
    oxyIconImage: json['oxyIconImage'].toString(),
    pawDetail: json['pawDetail'].toString(),
    o2Level: json['o2Level']?? 0,

    wardShortName: json['wardShortName'].toString(),
    bedName: json['bedName']?? ''.toString(),
    subDepartmentName: json['subDepartmentName'].toString(),
    totalAdmitDays: json['totalAdmitDays'].toString(),
    wardTransferDate: json['wardTransferDate'].toString(),
    noOfTransfer: json['noOfTransfer'].toString(),
    isQuarantineCompleted: json['isQuarantineCompleted'].toString(),


    diagnosis: List<DiagnosisModal>.from(
        jsonDecode(json['diagnosis']??'[]').map((element) => DiagnosisModal.fromJson(element))
    ),
    pacsDetail: json['pacsDetail'].toString(),


    nsDetail: json['nsDetail'].toString(),

    wardMobileNo: json['wardMobileNo']?? ''.toString(),
    intercomNo: json['intercomNo']?? 0,
    o2AtAdmit: json['o2AtAdmit'].toString(),



    //vvvvvvvvviiiiiiiiisssssssssshhhhhhhhhhhhaaaaaaaaaaaaaaallllllllllllllllllllllll
    feedback: json['feedback']??  ''.toString(),
    feedbackColor: (json['feedbackColor']=='' || json['feedbackColor']==null)? Colors.transparent:json[''],
    feedbackDetail: List<FeedbackDetailModal>.from(
        jsonDecode(json['feedbackDetail']??'[]').map((element) => FeedbackDetailModal.fromJson(element))
    ),

    pmID: json['pmID'].toString(),

    isExistsAdernaline: json['isExistsAdernaline']?? '',
    isExistsFenta: json['isExistsFenta']?? '',
    isExistsIVFluid: json['isExistsIVFluid']?? '',
    isExistsNorad: json['isExistsNorad']?? '',
    isExistsVasopressin: json['isExistsVasopressin']?? '',
    isExistsMidaz: json['isExistsMidaz']?? '',
    isCovid: json['isCovid'],
    wardID: json['wardID'],
    currentDrugId: json['currentDrugId'],



  );

}
class RegVitalDetail{

  Vital BP_Sys;
  Vital BP_Dias;
  Vital Pulse;
  Vital spo2;
  Vital Temperature;


  RegVitalDetail(
      {
        required this.BP_Sys,
        required this.BP_Dias,
        required this.Pulse,
        required this.spo2,
        required this.Temperature,

      });
}


class VentilatorModeDetailModal {
  String? vmValue;
  String? shortName;


  VentilatorModeDetailModal(
      {
        this.vmValue,
        this.shortName,

      });

  factory VentilatorModeDetailModal.fromJson(Map<String, dynamic> json) => VentilatorModeDetailModal(
    vmValue: json['vmValue'].toString(),
    shortName: json['shortName'].toString(),
  );
}

class InfusionDetailModal {
  String? flowRate;
  String? flowUnit;
  String? drugName;


  InfusionDetailModal(
      {
        this.flowRate,
        this.flowUnit,
        this.drugName,

      });

  factory InfusionDetailModal.fromJson(Map<String, dynamic> json) => InfusionDetailModal(
    flowRate: json['flowRate'].toString(),
    flowUnit: json['flowUnit'].toString(),
    drugName: json['drugName'].toString(),
  );

}


class DiagnosisModal {
  String? diagnosis;
  String? colorCode;

  DiagnosisModal(
      {
        this.diagnosis,
        this.colorCode,
      });

  factory DiagnosisModal.fromJson(Map<String, dynamic> json) => DiagnosisModal(
    diagnosis: json['diagnosis'].toString(),
    colorCode: json['colorCode'].toString(),
  );

}




class IoDetails{

  String urineProblem;
  Color urineProblemColor;
  String totalIntake;
  String urineOutput;
  String urineProblemMessage;



  IoDetails(
      {
        required this.urineProblem,
        required this.urineProblemColor,
        required this.totalIntake,
        required this.urineOutput,
        required this.urineProblemMessage,

      });




}


class VitalDetail{

  Vital pulseRate;
  Vital bpSys;
  Vital bpDia;
  Vital spo2;
  Vital respRate;
  Vital respRateMacine;
  Vital heartRate;


  VitalDetail(
      {
        required this.pulseRate,
        required this.bpSys,
        required this.bpDia,
        required this.spo2,
        required this.respRate,
        required this.heartRate,
        required this.respRateMacine,

      });




}



class InvestigationDetail{

  Vital ca;
  Vital serumCa;
  Vital alb;
  Vital k;
  Vital serumK;
  Vital nA;
  Vital serumNa;
  Vital mg;
  Vital ph;
  Vital pco2;
  Vital etco2;
  Vital po2;
  Vital lactate;
  Vital rbs;
  Vital tmp;
  Vital creatinine;
  Vital bUrea;
  Vital sgot;
  Vital sgpt;


  InvestigationDetail(
      {
        required this.ca,
        required this.serumCa,
        required this.alb,
        required this.k,
        required this.serumK,
        required this.nA,
        required this.serumNa,
        required this.mg,
        required this.ph,
        required this.pco2,
        required this.etco2,
        required this.po2,
        required this.lactate,
        required this.rbs,
        required this.tmp,
        required this.creatinine,
        required this.bUrea,
        required this.sgot,
        required this.sgpt,
      });




}





// Render Vitals

Vital _vitalDetails(json,id,{
  int? getMachineData,
  String? parameter,
  bool? valueInDouble,
  int? nutritionId,
}){
  return Vital(
    id: id,
    value: _renderJsoForValue(json,id,
        getMachineData: getMachineData,
        parameter: parameter,
        valueInDouble: valueInDouble),
    color: _renderJsoForColor(json,id,
      getMachineData: getMachineData,
      parameter: parameter,),
    blink: _renderJsoForBlink(json,id,
        getMachineData: getMachineData,
        parameter: parameter),
    calLastUpdatedTime: _renderJsoForLastUpdateTime(json,id,
        getMachineData: getMachineData,
      parameter: parameter,),
    calLastBlink: _renderJsoForCallLastBlink(json,id,
        getMachineData: getMachineData),
    calLastColor: _renderJsoForCalLastColor(json,id,
        getMachineData: getMachineData,
    parameter: parameter),
      sampleType:_renderJsonForSampleType(json,id,
          getMachineData: getMachineData,
          parameter: parameter,
      ),

    nutrition:_renderJsonForNutrition(json,
        nutritionId: nutritionId
  )
  );
}







class Vital{

  int id;
  String value;
  Color color;
  bool blink;
  String calLastUpdatedTime;
  bool calLastBlink;
  Color calLastColor;
  String sampleType;
  Nutrition nutrition;



  Vital(
      {
        required this.id,
        required this.value,
        required this.color,
        required this.blink,
        required this.calLastUpdatedTime,
        required this.calLastBlink,
        required this.calLastColor,
        required this.sampleType,
        required this.nutrition,

      });


}





class Nutrition
{

  int? memberId;
  int? nutrientID;
  String? nutrientName;
  double? foodPercentage;
  double? medicinePercentage;
  double? remainingPercentage;



  Nutrition(
      {
         this.memberId,
         this.nutrientID,
         this.nutrientName,
         this.foodPercentage,
         this.medicinePercentage,
         this.remainingPercentage,

      });


}

String _renderJsoForValue(Map json,int id,{
  int? getMachineData,
  String? parameter,
  bool? valueInDouble
}){
  List dataList=jsonDecode(json[(parameter??'vitalDetail')]??'[]');
  List dataListAfterCondition=dataList.where((element) => element['vmID']==id).toList();

  if(getMachineData!=null){
    dataListAfterCondition=dataListAfterCondition.where((element) => element['isFromMachine']==getMachineData).toList();
  }
  return       (
      dataList.isEmpty? '-':
      dataListAfterCondition.isEmpty?
          '-':

      (valueInDouble?? false)? dataListAfterCondition
      [0]['vmValue'].toString():
      double.parse(dataListAfterCondition
      [0]['vmValue'].toString()).toInt().toString()
  );

}



Color _getColor(String val){


  switch(val.toLowerCase()){
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



Color _renderJsoForColor(Map json,int id,{
  int? getMachineData,
  String? parameter
}){


  List dataList=jsonDecode(json[(parameter??'vitalDetail')]??'[]');


  List dataListAfterCondition=dataList.where((element) => element['vmID']==id).toList();
  if(getMachineData!=null){
    dataListAfterCondition=dataListAfterCondition.where((element) => element['isFromMachine']==getMachineData).toList();
  }

  if(parameter!='vitalDetail'){

    return _getColor(
        dataListAfterCondition.isEmpty?
         ''
        :_renderJsonForColorAccordingToRange(id,dataListAfterCondition[0]).split(' ')[0]);
  }
  else{







    String colorString=dataList.isEmpty? '':
    dataListAfterCondition.isEmpty?
    '':
    dataListAfterCondition
    [0]['vitalColorCode']??'';
    try {
      return       (

          colorString==''?
          Colors.green:
          colorString.toString().toColor()
      );
    }
    catch(e){
      return _getColor(colorString);
    }
  }



}


bool _renderJsoForBlink(Map json,int id,{
  int? getMachineData,
  String? parameter,
}){

  List dataList=jsonDecode(json[(parameter??'vitalDetail')]??'[]');
  List dataListAfterCondition=dataList.where((element) => element['vmID']==id).toList();

  if(getMachineData!=null){
    dataListAfterCondition=dataListAfterCondition.where((element) => element['isFromMachine']==getMachineData).toList();
  }




 // print(dataListAfterCondition[0].toString());

  if(parameter!='vitalDetail'){

    return

      _getBlink(
          dataListAfterCondition.isEmpty?
          ''
              :_renderJsonForColorAccordingToRange(id,
              dataListAfterCondition[0]).split(' ')[1]
      )
     ;
  }
  else {

    String blinkString=dataList.isEmpty? '':
    dataListAfterCondition.isEmpty?
    "":
    dataListAfterCondition
    [0]['vitalBlink'];
    try {
      return       (
          _getBlink(
              blinkString
          )

      );
    }
    catch(e){
      return false;
    }

  }

}


String _renderJsoForLastUpdateTime(Map json,int id,{
  int? getMachineData,
  String? parameter,
}){
  List dataList=jsonDecode(json[(parameter?? 'vitalDetail')]??'[]');
  List dataListAfterCondition=dataList.where((element) => element['vmID']==id).toList();

  if(getMachineData!=null){
    dataListAfterCondition=dataListAfterCondition.where((element) => element['isFromMachine']==getMachineData).toList();
  }

  return       (
      dataList.isEmpty? '-':
      dataListAfterCondition.isEmpty?
      '-':
      dataListAfterCondition
      [0]['calLastUpdatedTime'].toString()
  );

}


bool _getBlink(String val){

  switch(val){

    case 'blink':
      return true;
    case 'blink1':
      return true;
    case '':
      return false;
    default:
      return false;
  }
}


bool _renderJsoForCallLastBlink(Map json,int id,{
  int? getMachineData,
  String? parameter,
}){
  List dataList=jsonDecode(json[(parameter??'vitalDetail')]??'[]');
  List dataListAfterCondition=dataList.where((element) => element['vmID']==id).toList();

  if(getMachineData!=null){
    dataListAfterCondition=dataListAfterCondition.where((element) => element['isFromMachine']==getMachineData).toList();
  }



  if(parameter!='vitalDetail'){

    return

      _getBlink(
          dataListAfterCondition.isEmpty?
          ''
              :_renderJsonForColorAccordingToRange(id,
              dataListAfterCondition[0]).split(' ')[1]
      )
    ;
  }
  else{
    String blinkString=dataList.isEmpty? '':
    dataListAfterCondition.isEmpty?
    "":
    dataListAfterCondition
    [0]['notifyType'];
    try {
      return       (



          _getBlink(blinkString.split(' ')[1])
      );
    }
    catch(e){
      return false;
    }
  }



}


Color _renderJsoForCalLastColor(Map json,int id,{
  int? getMachineData,
  String? parameter,
}){




  List dataList=jsonDecode(json[(parameter??'vitalDetail')]??'[]');
  List dataListAfterCondition=dataList.where((element) => element['vmID']==id).toList();

  if(getMachineData!=null){
    dataListAfterCondition=dataListAfterCondition.where((element) => element['isFromMachine']==getMachineData).toList();
  }



  if(parameter!='vitalDetail'){

    return _getColor(
        dataListAfterCondition.isEmpty?
        ''
            :_renderJsonForColorAccordingToRange(id,dataListAfterCondition[0]).split(' ')[0]);
  }
  else{

    String colorString=dataList.isEmpty? '':
    dataListAfterCondition.isEmpty?
    '':
    dataListAfterCondition
    [0]['notifyType'];
    try {
      return       (

          colorString==''?
          Colors.green:
          _getColor(colorString.split(' ')[0])
      );
    }
    catch(e){
      return Colors.green;
    }
  }



}




String _renderJsonForSampleType(Map json,int id,{
  int? getMachineData,
  String? parameter,
}){
  List dataList=jsonDecode(json[(parameter??'vitalDetail')]??'[]');
  List dataListAfterCondition=dataList.where((element) => element['vmID']==id).toList();

  if(getMachineData!=null){
    dataListAfterCondition=dataListAfterCondition.where((element) => element['isFromMachine']==getMachineData).toList();
  }
  return       (
      dataList.isEmpty? '-':
      dataListAfterCondition.isEmpty?
      '-':
      (dataListAfterCondition
      [0]['sampleType']??'-').toString()
  );

}




Nutrition _renderJsonForNutrition(Map json,{
  int? nutritionId
}){
  List dataList=jsonDecode(json['achievedNutrientDetail']??'[]');
  List dataListAfterCondition=dataList.where((element) => element['nutrientID']==nutritionId).toList();

  return      dataListAfterCondition.isEmpty? Nutrition():Nutrition (
    memberId: dataListAfterCondition[0]['memberId'],
    nutrientID: dataListAfterCondition[0]['nutrientID'],
    foodPercentage: dataListAfterCondition[0]['foodPercentage'],
    medicinePercentage: dataListAfterCondition[0]['medicinePercentage'],
    remainingPercentage: dataListAfterCondition[0]['remainingPercentage'],
  );

}







_renderJsonForColorAccordingToRange(int vmID,Map val){





  double vmValue = double.parse((val['vmValue']??0.0).toString());
  double minValue =double.parse((val['minValue']??0.0).toString());
  double maxValue = double.parse((val['maxValue']??0.0).toString());

  double timeDifference = double.parse((val['timeDifference']??0).toString());
  double notifyTime = double.parse((val['notifyTime']??60).toString());
  int isPatientNormalRange = (val['isPatientNormalRange']??0);

  var returnMessage = "";

  if (vmID == 4) {
    if (vmValue <= 100) {
      if (timeDifference < notifyTime) {
        returnMessage = 'red blink1';
      }
      else {
        returnMessage = 'red';
      }
    }
    else if (vmValue >= 101 && vmValue <= 105) {
      returnMessage = 'lightRed';
    }
    else if (vmValue >= 106 && vmValue <= 110) {
      returnMessage = 'notifyColor';
    }
    else if (vmValue >= 111 && vmValue <= 115) {
      returnMessage = 'lightGreen';
    }
    else if (vmValue >= 116 && vmValue <= 125) {
      returnMessage = 'green';
    }
    else if (vmValue >= 126 && vmValue <= 129) {
      returnMessage = 'lightGreen';
    }
    else if (vmValue >= 130 && vmValue <= 133) {
      returnMessage = 'notifyColor';
    }
    else if (vmValue >= 134 && vmValue <= 137) {
      returnMessage = 'lightRed';
    }
    else {
      if (timeDifference < notifyTime) {
        returnMessage = 'red blink1';
      }
      else {
        returnMessage = 'red';
      }
    }
  }

  else if (vmID == 6) {
    if (vmValue <= 60) {
      if (timeDifference < notifyTime) {
        returnMessage = 'red blink1';
      }
      else {
        returnMessage = 'red';
      }
    }
    else if (vmValue >= 61 && vmValue <= 65) {
      returnMessage = 'lightRed';
    }
    else if (vmValue >= 66 && vmValue <= 70) {
      returnMessage = 'notifyColor';
    }
    else if (vmValue >= 71 && vmValue <= 75) {
      returnMessage = 'lightGreen';
    }
    else if (vmValue >= 76 && vmValue <= 85) {
      returnMessage = 'green';
    }
    else if (vmValue >= 86 && vmValue <= 88) {
      returnMessage = 'lightGreen';
    }
    else if (vmValue >= 89 && vmValue <= 91) {
      returnMessage = 'notifyColor';
    }
    else if (vmValue >= 92 && vmValue <= 94) {
      returnMessage = 'lightRed';
    }
    else {
      if (timeDifference < notifyTime) {
        returnMessage = 'red blink1';
      }
      else {
        returnMessage = 'red';
      }
    }
  }
  else if (vmID == 56) {
    if (vmValue <= 84) {
      if (timeDifference < notifyTime) {
        returnMessage = 'red blink1';
      }
      else {
        returnMessage = 'red';
      }
    }
    else if (vmValue >= 85 && vmValue <= 89) {
      returnMessage = 'lightRed';
    }
    else if (vmValue >= 90 && vmValue <= 94) {
      returnMessage = 'notifyColor';
    }
    else if (vmValue >= 95 && vmValue <= 97) {
      returnMessage = 'lightGreen';
    }
    else if (vmValue >= 98 && vmValue <= 100) {
      returnMessage = 'green';
    }
    else {
      if (timeDifference < notifyTime) {
        returnMessage = 'red blink1';
      }
      else {
        returnMessage = 'red';
      }
    }
  }
  //else if (vmID == 206 && obj.vitalType == 'investigation') {
  //    if (vmValue >= 3.1 && vmValue <= 3.4) {
  //        returnMessage = 'lightRed';
  //    }
  //    else if (vmValue >= 3.5 && vmValue <= 5) {
  //        returnMessage = 'green';
  //    }
  //    else if (vmValue >= 2.8 && vmValue <= 3) {
  //        returnMessage = 'red';
  //    }
  //    else if (vmValue < 2.8) {
  //        returnMessage = 'red blink1';
  //    }
  //    else {
  //        if (timeDifference < notifyTime) {
  //            returnMessage = 'red blink1';
  //        }
  //        else {
  //            returnMessage = 'red';
  //        }
  //    }
  //}
  else {
    if ((vmValue < minValue) && (((vmValue - minValue) / minValue) * 100).abs() <= 10) {
      returnMessage = 'lightRed';
    }
    else if (vmValue >= minValue && vmValue <= maxValue) {
      returnMessage = 'green';
    }
    else if (vmValue > maxValue && ((vmValue - maxValue) / vmValue * 100).abs() <= 10) {
      returnMessage = 'lightRed';
    }
    else if (minValue == 0 && maxValue == 0) {
      returnMessage = '';
    }
    else {
      if (timeDifference < notifyTime) {
        returnMessage = 'red blink1';
      }
      else {
        returnMessage = 'red';
      }

    }
  }

  if (isPatientNormalRange == 1) {
    returnMessage = returnMessage + "borderBottom";
  }
  return (returnMessage+' new');

}




//vvvvvvviiiiiiiiiiissssssssssssshhhhhhhhhhhhaaaaaaaaaaalllllllllllll
class FeedbackDetailModal {
  int? PID;
  String? feedbackHead;
  String? feedbackRating;
  String? feedback;

  FeedbackDetailModal(
      {
        this.PID,
        this.feedbackHead,
        this.feedbackRating,
        this.feedback,
      });

  factory FeedbackDetailModal.fromJson(Map<String, dynamic> json) => FeedbackDetailModal(
    PID: json['PID'] as int,
    feedbackHead: json['feedbackHead'].toString(),
    feedbackRating: json['feedbackRating'].toString(),
    feedback: json['feedback'].toString(),

  );
}