


import 'package:flutter/material.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/common_libs.dart';

import '../authenticaton/user_repository.dart';

class PlanOfCareViewModal  extends ChangeNotifier{



  final Api _api = Api();



  List planList=[];
  List get getPlanList=>planList;
  set updatePlanList(List val){
    planList=val;
    notifyListeners();

  }
  bool isLoading=false;
  bool get getIsLoading=>isLoading;
  set updateIsLoading(bool val){
    isLoading=val;
    notifyListeners();
  }

  getNotesTittle(context)async{
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
    ProgressDialogue().show(context,loadingText: 'Loading...');
    updatePlanList=[];
    updateIsLoading=true;
    var data=await _api.callMedvanatagePatient7082(context,
        url: "api/PatientNotes/GetAllPatientNotes?pdmID=16&pid=${userRepository.getUser.pid.toString()}&ClientId=${userRepository.getUser.clientId.toString()}",
        // "api/PatientNotes/GetAllPatientNotes?pdmID=16&pid=29484&ClientId=${userRepository.getUser.clientId.toString()}",
        localStorage: true,
        apiCallType: ApiCallType.get());
    ProgressDialogue().hide();
    updateIsLoading=false;
    print('nnnn'+data.toString());
    updatePlanList=data['responseValue'];
    // https://apimedcareroyal.medvantage.tech:7082/api/PatientNotes/GetAllPatientNotes?pdmID=16&pid=29484&ClientId=223

    // https://apimedcareroyal.medvantage.tech:7082/api/NotesTemplateMaster/GetNotesTittle?clientId223

  }

}