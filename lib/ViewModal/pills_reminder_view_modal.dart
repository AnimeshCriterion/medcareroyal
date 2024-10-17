

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';

import '../Localization/app_localization.dart';
import '../Modal/medicine_intake_data_model.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_call.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class PillsReminderViewModal extends ChangeNotifier{
  final Api _api = Api();
  List Daylist=[
    {"day":"SOS",
      "frequency":'0-0-0'
    },
    {"day":"Morning",
      "frequency":'1-0-0'
    },
    {"day":"Afternoon",
      "frequency":'0-1-0'
    },
    {"day":"Evening",
      "frequency":'0-0-1'},
  ];


  List typeIndex=[];
    updateTypeIndex(int val, ){
      print('nnnvnnvn $typeIndex');

      if (!typeIndex.contains(val)) {
        print('nnnvnnvn $val');
        typeIndex.add(val);
      } else {
        print('nnnvvvvvvn $val');
        typeIndex.remove(val);

    }
      print('nnnvnnvn $typeIndex');
      notifyListeners();
  }

  updateFirstValue(int val){
    if (!typeIndex.contains(val)) {
      typeIndex.add(val);
    }
  }


  List medNameandDate = [];
  List<MedicationNameAndDate> get getMedNamesAndDates=>
      List<MedicationNameAndDate>.from(medNameandDate.map((e) =>
          MedicationNameAndDate.fromJson(e)).where((element) =>
      element.date==DateFormat("yyyy-MM-dd").format(DateTime.now())));

  set updateMedNamesAndDates(List val){
    medNameandDate=val;
    notifyListeners();
  }
  pillsReminderApi(context)async{
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
    updateMedNamesAndDates=[];
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    // ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());


    final prefs = await SharedPreferences.getInstance();
    var langId=await prefs.getString("lang").toString();

    var data=await _api.callMedvanatagePatient7082(context, url: "api/PatientMedication/GetAllPatientMedication?UhID=${userRepository.getUser.uhID.toString()}&languageId=${langId.toString()}", apiCallType:ApiCallType.get());
    print('nnnn$data');

     // Get.back();
    if(data["status"]==1){
      updateMedNamesAndDates=data["responseValue"]["medicationNameAndDate"];
    }
    else{

      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
      // Alert.show(data['message'].toString());
    }

  }

  //insert api


  insertMedicine(context , {required int pmID, required int prescriptionID, required String time}) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    print(time); String formattedDate = DateFormat('yyyy-MM-dd  ').format(DateTime.now());
    try{
      var body={
        "pmID": pmID,
        "intakeDateAndTime": formattedDate +time.toString(),
        "prescriptionID": prescriptionID,
        "userID": userRepository.getUser.userId.toString()
      };
      print("BODY $body");
      var data = await _api.callMedvanatagePatient7082(context,
          url: "api/PatientMedication/InsertPatientMedication",
          apiCallType: ApiCallType.rawPost(body: body),
        isSavedApi: true
      );
      //  Get.back();
      if (data['status'] == 1) {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message'].toString());
        await pillsReminderApi(context);
      } else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue'].toString());
      }
    }

    catch(e){
      //  Get.back();
    }
  }
}