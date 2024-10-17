import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../authenticaton/user_repository.dart';
import '../../live_vital_controller.dart';
import '../ecg_controller.dart';

class GenerateReportController extends GetxController{

  EcgController ecgController =Get.put(EcgController());

  Map perLead={};
  Map get getPerLead=>perLead;
  set updatePerLead(Map val){
    perLead=val;
    update();
  }

  genrateReportTableData({required String interval, required String intervalValue,required String emptyReturn}){
    var data= getPerLead.isEmpty
        ? emptyReturn.toString()
        :getPerLead['Lead_II']==null? '0':getPerLead['Lead_II'][interval]==null? '0':getPerLead['Lead_II'][interval][intervalValue]??'0';
    return data;
  }


  // String leadGain = '2';

  saveECGBMData(context) async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    Map  body={
      "time":DateTime.now().toString(),
      "PID": userRepository.getUser.pid.toString(),
      "Location": userRepository.getUser.address.toString(),
      "notes":ecgController.notesController.text.toString(),
      "leadGain":"1".toString(),
      "patientInfo": {
        "name":userRepository.getUser.patientName.toString(),
        "gender":userRepository.getUser.pid.toString(),
        "city":userRepository.getUser.cityId.toString(),
        "age":'${DateTime.now().year - int.parse(userRepository.getUser.dob!.split('/')[2])} year' ,
      },
      'payLoad': {
        "leadName":"LEAD II".toString(),
        "data": (ecgController.ecgData.toList().length < 1500
            ? ecgController.ecgData.toList()
            : ecgController.ecgData
            .toList()
            .getRange(
            (ecgController.ecgData.toList().length -
                1500),
            ecgController.ecgData.toList().length))
            .toList().join(',')
      }
    };
    print('nnnnnnnnnnnnvnvnvnvnvnvnvnnvnvnvnvnv'+jsonEncode(body).toString());
    (json.encode(body).toString());
    print(json.encode(body).toString());
    try{
      var response = await http.post(Uri.parse('http://182.156.200.179:1880/ecg'),
          body: json.encode(body),
          headers: {
            "authKey": "4S5NF5N0F4UUN6G",
            "content-type": "application/json",
          }
      );

      print(response.toString());
      var data = await json.decode(response.body);

      print('nnnnnnnnnnnnvnvnvnvnvnvnvnnvnvnvnvnv1112222' + data.toString());
      updatePerLead=data['perlead'][0];
    }
    catch(e){
      print('nnnnnnnnnnnnvnvnvnvnvnvnvnnvnvnvnvnv1112222' + e.toString());
    }
  }



  LiveVitalModal vitalModal=LiveVitalModal();

  saveDeviceVital(context,getHrValue) async {

    var data= await vitalModal.addVitals(context,
      hr: getHrValue.toString()
    );

    // List dtDataTable = [];
    //
    // if(  getHrValue!='00'){
    //   dtDataTable.add({
    //     'vitalId': 74.toString(),
    //     'vitalValue':getHrValue.toString(),
    //   });
    // }
    //
    //
    //
    // var body = {
    //   "memberId": UserData().getUserMemberId,
    //   'dtDataTable': jsonEncode(dtDataTable),
    //   "date": DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
    //   "time": DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
    // };
    //
    // var data = await RawData().api(
    //   "Patient/addVital",
    //   body,
    //   context,
    // );
    // if (data['responseCode'] == 1) {
    //
    //   // alertToast(context,
    //   //     localization.getLocaleData.vitalsSaveSuccessfully.toString());
    //   //  Get.back();
    // }  else {
    //   // alertToast(context, data['responseMessage'].toString());
    // }


  }

}
