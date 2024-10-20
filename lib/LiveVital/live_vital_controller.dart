

import 'package:get/get.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/functional_sheet.dart';
import 'package:intl/intl.dart';

import '../all_api.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_call.dart';
import '../app_manager/bottomSheet/bottom_sheet.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class LiveVitalModal{

  final Api _api = Api();



  addVitalsData(context,{ String BPSys='0', String BPDias='0',String rr='0',String spo2='0',String pr='0',String tmp='0',String hr='0',
    String rbs='0', String urinOutput='0',String height='0',String weight='0'}) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message:
          localization.getLocaleData.areYouSureYouWantToddVitale.toString(),
          buttonName: localization.getLocaleData.yes.toString(),
          onPressButton: () async {
            await addVitals(context,BPSys: BPSys.toString(),
                BPDias: BPDias.toString(),
            rr:rr.toString(),
              spo2: spo2.toString(),
              pr: pr.toString(),
              tmp: tmp.toString(),
              hr: hr.toString(),
              rbs: rbs.toString(),
              urinOutput: urinOutput.toString(),
              height: height.toString(),
              weight: weight.toString()

            );
          },
        ));
  }


  addVitals( context,{ String BPSys='0', String BPDias='0',String rr='0',String spo2='0',
    String pr='0',String tmp='0',String hr='0',String rbs='0',
    String urinOutput='0',String height='0',String weight='0'}) async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    var request={

    };
    try{
      var body = {
        // "id": 0,
        // "pid": userRepository.getUser.pid.toString(),
        // "pmId": 0,
        "userId": userRepository.getUser.userId.toString(),
        // "vmId": 0,
        "vmValueBPSys": BPSys.toString(),
        "vmValueBPDias": BPDias.toString(),
        "vmValueRespiratoryRate": rr.toString(),
        "vmValueSPO2": spo2.toString(),
        "vmValuePulse": pr.toString(),
        "vmValueTemperature": tmp.toString(),
        "vmValueHeartRate": hr.toString(),
        // "vmValueBMI": 0,
        // "vmValueBMR": 0,
        "weight": weight.toString(),
        "vmValueRbs": rbs.toString(),
        "vitalTime": DateFormat('HH:mm').format(DateTime.now()).toString(),
        "vitalDate": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        // "vitalIdSearch": 0,
        "uhid": userRepository.getUser.uhID.toString(),
        "currentDate": DateTime.now().toString(),
        // "vitalIdSearchNew": "string",
        "clientId": userRepository.getUser.clientId.toString(),
        // "duration": 0,
        // "vmValue": 0,
        "isFromPatient": true,
        // "positionId": getSelectedPosition.toString()
      };
      var data = await _api.callMedvanatagePatient7082(context,
          url: 'api/PatientVital/InsertPatientVital',
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: body),
          isSavedApi: true);

      // var data = await _api.callMedvanatagePatient(
      //   context,
      //   url: "${AllApi.addVitalHM}uhID=${userRepository.getUser.uhID}&vmValueBPSys=${BPSys}&vmValueBPDias=${BPDias}&vmValueRespiratoryRate=${rr}&vmValueSPO2=${spo2}&vmValuePulse=${pr}&vmValueTemperature=${tmp}&vmValueHeartRate=${hr}&vmValueRbs=${rbs}&vmValueUrineOutput=${urinOutput}&height=${height}&weight=${weight}&isFromMachine=1&userId=99&IsFromPatient=true&vitalDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}&vitalTime=${DateFormat('HH:mm').format(DateTime.now())}",
      //   localStorage: true,
      //   apiCallType: ApiCallType.post(body: request),
      // );
print('nnnnnnvnnnnvnnn '+data.toString());
      if (data['status'] == 0) {
        Alert.show(data["message"]);
      } else {
        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: "Vital added successfully!".toString()));
        // Alert.show("Vital added successfully!");
      }



    }
    catch(e){

    }
  }

}