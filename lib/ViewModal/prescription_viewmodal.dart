import 'dart:convert';
import 'dart:developer';

import 'package:medvantage_patient/Modal/prescription_history_data_modal.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/api/api_response.dart';
import 'package:medvantage_patient/app_manager/imageViewer/image_view.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/assets.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Localization/app_localization.dart';
import '../app_manager/imageViewer/ImageView.dart';
import '../app_manager/pdf_viewer.dart';
import '../medcare_utill.dart';

class PrescriptionViewModal extends ChangeNotifier {
  final Api _api = Api();
  List PrescriptionHistory = [
    {
      'date': '30/10/2022',
      'icons': ImagePaths.medicineIcon.toString(),
      "icons2": Icons.arrow_forward_ios_outlined
    },
    {
      'date': '28/10/2022',
      'icons': ImagePaths.medicineIcon.toString(),
      "icons2": Icons.arrow_forward_ios_outlined
    },
    {
      'date': "28/10/2022",
      'icons': ImagePaths.medicineIcon.toString(),
      "icons2": Icons.arrow_forward_ios_outlined
    },
    {
      'date': '28/10/2022',
      'icons': ImagePaths.medicineIcon.toString(),
      "icons2": Icons.arrow_forward_ios_outlined
    },
  ];
  //.......medicine data.....///
  List MedicineList = [
    {
      "pillsImg": ImagePaths.prescriptionPills,
      "medicineName": "Abacavir 150mg",
      "medicineDiscription":
      "1 tablet everyday for 1 week in the morning,\nAfter food",
    },
    {
      "pillsImg": ImagePaths.prescriptionPills,
      "medicineName": "Abacavir 150mg",
      "medicineDiscription":
      "1 tablet everyday for 1 week in the morning,\nAfter food",
    },
    {
      "pillsImg": ImagePaths.prescriptionPills,
      "medicineName": "Abacavir 150mg",
      "medicineDiscription":
      "1 tablet everyday for 1 week in the morning,\nAfter food",
    },
  ];
/////.....medicine data///.......
  List<PrescriptionHistoryDataModal> get getPrescriptionList =>
      getPrescriptionResponse.data ?? [];
  ApiResponse prescriptionResponse = ApiResponse.initial("initial");

  ApiResponse get getPrescriptionResponse => prescriptionResponse;

  set updatePrescriptionResponse(ApiResponse val) {
    prescriptionResponse = val;
    notifyListeners();
  }

  onPressPrescription(
    context, {
    imgUrl,
  }) {
    if (imgUrl.toString() != '') {
      MyNavigator.push(context, MyImageView(url: imgUrl));
    } else {}
  }

  getPatientMedicationList(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    updatePrescriptionResponse = ApiResponse.loading(localization.getLocaleData.Loading.toString());
    try {
      var data = await _api.call(context,
          localStorage: true,
          url: AllApi.getPatientMedicationDetails,
          apiCallType: ApiCallType.rawPost(
              body: {"memberId": userRepository.getUser.uhID.toString()}));



      log('nnnnnnnnnnnn'+data.toString());

      if (data['responseCode'] == 1) {
        prescriptionResponse.data = (List<PrescriptionHistoryDataModal>.from(
            ((data['responseValue'] ?? []) as List)
                .map((e) => PrescriptionHistoryDataModal.fromJson(e))));
        updatePrescriptionResponse =
            ApiResponse<List<PrescriptionHistoryDataModal>>.completed(
                getPrescriptionResponse.data ?? []);
        if (data['responseValue'].isEmpty) {
          updatePrescriptionResponse =
              ApiResponse.empty("Prescription not available");
        } else {}
      } else {
        updatePrescriptionResponse =
            ApiResponse.empty("Prescription not available");
        Alert.show(data['message']);
      }

      dPrint(data);
    } catch (e) {}
  }

  String selectedImage = '';

  String get getSelectedImage => selectedImage;

  set updateSelectedImage(String val) {
    selectedImage = val;
    dPrint('nnnnnnnnnnnn' + getSelectedImage.toString());
    notifyListeners();
  }

  getProfilePath(context) async {
    var data = await _api.call(context,
        url: AllApi.saveMultipleFile,
        apiCallType: ApiCallType.multiPartRequest(
          filePath: getSelectedImage.toString(),
          fileParameter: 'files',
          body: {},
        ),
        token: true);
    // if (jsonDecode(data['data'])['responseCode'] == 1) {
    //   data = jsonDecode(data['data'])['responseValue'];
    // }
    // dPring('vvvvvvvvv'+jsonDecode(data['responseValue'])[0]['filePath'].toString());
    return jsonDecode(data['responseValue'])[0]['filePath'];
  }

  onPressedSubmitButton(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var myFile =
        getSelectedImage.toString() == '' ? '' : await getProfilePath(context);
    try {
     if(myFile!='') {
        var data = await _api.call(context,
            url: AllApi.getpatientMedication,
            apiCallType: ApiCallType.rawPost(body: {
              "memberId": userRepository.getUser.uhID.toString(),
              "problemId": '',
              "problemName": '',
              "serviceProviderDetailsId": "0",
              "serviceProviderName": '',
              "startDate":
                  DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
              "filePath": jsonEncode(myFile).toString(),
              // "dtDataTable": jsonEncode(dtTableList),
            }));
        dPrint(data.toString());
        ProgressDialogue().hide();
        if (data['responseCode'] == 1) {
          Alert.show(data['responseMessage']);
          await getPatientMedicationList(context);
        } else {
          Alert.show(data['responseMessage']);
        }
      }
     else{
       Alert.show("Please Pick the File First");
     }
    } catch (e) {
      dPrint(e.toString());
    }
  }

  String appointmentId = "";

  String get getAppointmentId => appointmentId;

  set updateAppointmentId(String val) {
    appointmentId = val;
  }

  getMedicationForPDF(context) async {

    try {

      var data = await _api.call(context,
          url: AllApi.getMedicationDetailsForPDF,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(
              body: {"appointmentId": getAppointmentId.toString()}));
      if (data["responseCode"] == 1) {
        MyNavigator.push(context, PdfViewer(
            pdfUrl: data["responseValue"],

        )
        );
        // updateAppointmentId = data['responseValue'];
        dPrint("nnnnnn" + data['responseValue']);
      }
    } catch (e) {}
  }





}
