



import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medvantage_patient/LiveVital/stetho_bluetooth/stetho_bluetooth_controller.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';

import '../../Localization/app_localization.dart';
import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../app_manager/alert_toast.dart';
import '../../common_libs.dart';


class StethoBluetoothModal{


  StethoBluetoothController controller=Get.put(StethoBluetoothController());


  // sendData(context){
  //   var body={
  //
  //   };
  //
  //   var data=RawApi().api('http://182.156.200.179:201/patientStethoFile.ashx', body, context);
  //
  //
  // }


  saveAudio(context, {pid, filePath}) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText:localization.getLocaleData.Loading.toString());
    try{
      var body={
        'pid': pid.toString(),
        'position': controller.getTappedBodyPoint.toString(),
        'userID': '1234567',
        'stethoName': '1'
      };
      print('nnvvv '+body.toString());

      var request = await http.MultipartRequest(
          'POST', Uri.parse('http://182.156.200.179:201/patientStethoFile.ashx'));
      // 'http://182.156.200.178:5003/process_data'));
      request.fields
          .addAll(body);
      request.files
          .add(await http.MultipartFile.fromPath('file', filePath.toString()));

      http.StreamedResponse response = await request.send();
      Get.back();
      print('responseresponse ' + await response.statusCode.toString());
      if (response.statusCode == 200) {
        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Success'.toString()));
        // alertToast(context,'Success');
        print('responseresponse ' + await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }
    catch(e){
      print('responseresponse ' + e.toString());
    }
  }


}