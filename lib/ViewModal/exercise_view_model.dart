import 'package:get/get.dart';
import 'package:medvantage_patient/Modal/exercise_video_data_modal.dart';
import 'package:medvantage_patient/Modal/medicine_intake_data_model.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:flutter/cupertino.dart';

import '../Localization/app_localization.dart';
import '../Modal/excercise_tracking_data_modal.dart';
import '../app_manager/api/api_call.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class ExerciseViewModel extends ChangeNotifier {
  final Api _api = Api();

  TextEditingController searchc = TextEditingController();
  TextEditingController videosSearchC = TextEditingController();

  List exerciseList = [];
  List exerciseVideoList = [];

  List exerciseVideos=[];
  List<ExerciseVideos> get getExerciseVideos=>List<ExerciseVideos>.from(((videosSearchC.text.isEmpty
      ?exerciseVideos:
      exerciseVideos.where((element) => element['activityName'].toString().toLowerCase().
      contains(videosSearchC.text.toLowerCase().trim())).toList()).map((e) => ExerciseVideos.fromJson(e))));
  set updateExerciseVideos(List val){
    exerciseVideos=val;
    notifyListeners();
  }



  List<ExerciseTrackingDataModal> get getExerciseList =>
      List<ExerciseTrackingDataModal>.from(((searchc.text.isEmpty
              ? exerciseList
              : exerciseList
                  .where((element) => element['activityName']
                      .toString()
                      .toLowerCase()
                      .contains(searchc.text.toLowerCase().trim()))
                  .toList())
          .map((element) => ExerciseTrackingDataModal.fromJson(element))));

  set updateExerciseList(List val) {
    exerciseList = val;
    notifyListeners();
  }

  set updateExerciseVideoList(List val) {
    exerciseVideoList = val;
    notifyListeners();
  }



  getPatientMediaData(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url: 'api/PhysicalActivityMaster/GetAllPhysicalActivity',localStorage: true,
          apiCallType: ApiCallType.get());
      print(data.toString());
      if (data["status"] == 1) {
        updateExerciseList = data['responseValue'];
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  insertExercise(context, activityId, String string) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:
              'api/PatientPhysicalActivityTracker/InsertPatientPhysicalActivity?uhid=${userRepository.getUser.uhID.toString()}&activityId=${activityId}&totalTimeInMinutes=${string}&remark=&userId=${userRepository.getUser.userId}&timeFrom=${DateTime.now().toString()}',
          apiCallType: ApiCallType.post(body: {}),
          isSavedApi: true);
      ProgressDialogue().hide();
      print(data.toString());
      if (data["status"] == 1) {
        Alert.show("Exercise Recorded Successfully !");

      } else {
        Alert.show(data['message']);
      }
    } catch (e) {
      ProgressDialogue().hide();
      print(e.toString());
    }
  }

  List exerciseHistory = [];

  List get getExerciseHistory => exerciseHistory;

  set updateExerciseHistory(List val) {
    exerciseHistory = val;
    notifyListeners();
  }

  getAllPhysicalActivity(
      context,
      ) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:
          'api/PatientPhysicalActivityTracker/GetAllPhysicalActivity?uhid=${userRepository.getUser.uhID.toString()}',
          localStorage: true,
          apiCallType: ApiCallType.get());
      ProgressDialogue().hide();
      print(data.toString());
      if (data["status"] == 1) {
        updateExerciseHistory = data['responseValue'];
      } else {
        Alert.show(data['message']);
      }
    } catch (e) {
      ProgressDialogue().hide();
      print(e.toString());
    }
  }



  getAllExerciseVidoes(context) async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    var body = {
      "userLoginID": userRepository.getUser.userId.toString(),
    };
    var data =  await _api.callMedvanatagePatient7082(context, newBaseUrl:"https://nutrianalyser.com:313/api/" ,
          url: 'Exercise/GetAllRecordByProblemId',localStorage: true,
        apiCallType:  ApiCallType.rawPost(body: body));

    print('nnnnnn'+data.toString());

    if (data['responseMessage'] == "Success!") {
      updateExerciseVideos = data['responseValue'] ?? [];
    } else {
      Alert.show(data['responseMessage'].toString());
    }
  }


}

