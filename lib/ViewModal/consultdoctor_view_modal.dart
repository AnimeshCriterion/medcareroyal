import 'package:medvantage_patient/Modal/alldepartment_data_modal.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/api/api_response.dart';
import 'package:flutter/cupertino.dart';

import '../Localization/app_localization.dart';
import '../common_libs.dart';
import 'fullbody_checkup_viewmodal.dart';

class ConsultDoctorViewModal extends ChangeNotifier {

  final Api _api = Api();
  clearData(context){
    //
    // FullBodyCheckupDataModal bodycheckupVM =
    // Provider.of<FullBodyCheckupDataModal>(context, listen: false);
    searchC.clear();
    // bodycheckupVM.searchC.clear();
  }

  bool isViewAll = false;

  TextEditingController searchC = TextEditingController();
  onPressedViewAllSpecialities() {
    isViewAll = !isViewAll;
    notifyListeners();
  }

  // List<AllDepartmentDataModal> get getDepartmentList =>
  //     List<AllDepartmentDataModal>.from(getConsultDoctorResponse.data == null
  //         ? []
  //         : getConsultDoctorResponse.data
  //         .map((element) => AllDepartmentDataModal.fromJson(element)));
  List<AllDepartmentDataModal> get getDepartmentList =>
      List<AllDepartmentDataModal>.from(searchC.text == ""
          ? getConsultDoctorResponse.data == null
              ? []
              : getConsultDoctorResponse.data
          : getConsultDoctorResponse.data == null
              ? []
              : getConsultDoctorResponse.data.where((element) =>
                  (element.departmentName.toString().toLowerCase().trim())
                      .trim()
                      .contains(searchC.text.toLowerCase().trim())));


  ApiResponse consultDoctorResponse = ApiResponse.initial('initial');

  ApiResponse get getConsultDoctorResponse => consultDoctorResponse;

  set _updateConsultDoctorResponse(ApiResponse val) {
    consultDoctorResponse = val;

    notifyListeners();
  }

  getAllDepartment(context) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    _updateConsultDoctorResponse = ApiResponse.loading(localization.getLocaleData.Loading.toString());
    try {
      var data = await _api.call(context,
          url: AllApi.getAllDepartment,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {'isEmergency': '0'}));

      if (data['responseCode'] == 1) {

        consultDoctorResponse.data = (List<AllDepartmentDataModal>.from(
            ((data['responseValue'] ?? []) as List)
                .map((e) => AllDepartmentDataModal.fromJson(e))));
        _updateConsultDoctorResponse =
        ApiResponse<List<AllDepartmentDataModal>>.completed(
            getConsultDoctorResponse.data ?? []);

        // _updateConsultDoctorResponse =
            // ApiResponse<List>.completed(data['responseValue'] ?? []);

        if (data['responseValue'].isEmpty) {
          _updateConsultDoctorResponse =
              ApiResponse.empty("Data not Available");
        } else {}
      } else {
        _updateConsultDoctorResponse = ApiResponse.empty("Data not Available");
        Alert.show(data['message']);
      }
    } catch (e) {
      _updateConsultDoctorResponse = ApiResponse.error(e.toString());
    }
  }
}
