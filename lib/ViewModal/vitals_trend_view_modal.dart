


import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:flutter/cupertino.dart';

import '../Modal/vital_chart_data_modal.dart';
import '../all_api.dart';
import '../app_manager/api/api_call.dart';
import '../app_manager/app_color.dart';
import '../assets.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class VitalsTrendsViewModal extends ChangeNotifier{

  final Api _api=Api();

  List VitalTrends = [
    {'title': 'Blood Pressure',
      "color":AppColor.lightPink,
      'icons': ImagePaths.bloodPressure.toString(),
      'id' : -1,},
    {'title': 'Pulse Rate',
      "color":AppColor.lightBlue,
      'icons': ImagePaths.pulse.toString(),
      'id' : 3,},
    {'title': "Heart Rate",
      "color":AppColor.veryLightGreen,
      'icons': ImagePaths.heartRate.toString(),
      'id' : 7,},
    {'title': 'Spo2',
      "color":AppColor.veryLightBlue,
      'icons': ImagePaths.sPO2.toString(),
      'id' : 56,},
    {'title': 'Temp',
      "color":AppColor.darkBlue,
      'icons': ImagePaths.temperature.toString(),
      'id' : 5,}];



  List data= [];
  List vitalList = [];

  List<VitalDataModel> get getVitalData => List<VitalDataModel>.from(
      data.map((element) => VitalDataModel.fromJson(element))
  );

  List<VitalChartData> get getChartData => List<VitalChartData>.from(
      vitalList.map((element) => VitalChartData.fromJson(element))
  );


//filter list for Diastolic data
  List<VitalChartData>  get getDiastolic=>List<VitalChartData>.from(
      (
          vitalList.where(( element) => element['vitalName']=='Dias').toList()
      )
          .map((element) => VitalChartData.fromJson(element))
  );

  //filter list for Systolic data
  List<VitalChartData>  get getSystolic=>List<VitalChartData>.from(
      (
          vitalList.where(( element) => element['vitalName']=='Sys').toList()
      )
          .map((element) => VitalChartData.fromJson(element))
  );
  //filter list for BP data
  List<VitalChartData>  get getBp=>List<VitalChartData>.from(
      (
          vitalList.where(( element) => element['vitalName']=='BP').toList()
      )
          .map((element) => VitalChartData.fromJson(element))
  );


  set updateVitalData(List val){

    vitalList.clear();
    data = val;

    for(int i=0;i<getVitalData.length;i++){

      for(int j=0;j<getVitalData[i].vitalDetails!.length;j++){
        vitalList.add({
          'vitalDate': getVitalData[i].vitalDate,
          'vitalDateForGraph':getVitalData[i].vitalDateForGraph,
          'vitalName':getVitalData[i].vitalDetails![j].vitalName,
          'vitalValue':getVitalData[i].vitalDetails![j].vitalValue,
        });
      }
    }
    notifyListeners();
  }
  Map selectVitals = {};

  bool showNoData=false;
  bool get getShowNoData=>(showNoData);

  set updateShowNoData(bool val){
    showNoData=val;
    notifyListeners();
  }







  Map selectVitalsData = {};
  get getSelectVitals => selectVitalsData;
  set updateSelectVitals(Map val){
    selectVitalsData=val;
    notifyListeners();
  }
  patientVitalList(context)async{
    vitalList=[];
    notifyListeners();
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    try{
      var data= await  _api.call(context,
          url: AllApi.PatientVitalList,
          apiCallType: ApiCallType.rawPost(body: {
            "vitalId":getSelectVitals['id'].toString(),
            "memberId":userRepository.getUser.uhID.toString()
          }));

      if(data["responseCode"]==1){
        print("mmmmmmmmmmm"+data.toString());
        updateVitalData=data["responseValue"];
      }







    }catch(e){}

  }
}