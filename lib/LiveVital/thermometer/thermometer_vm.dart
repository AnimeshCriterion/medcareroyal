

import 'dart:convert';

import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../authenticaton/user_repository.dart';
import '../devices_api.dart';


class ThermometerVM extends ChangeNotifier{



  String tempalue='';
  String get getTempValue=>tempalue;

  set updateGetTempValue(List val){

    var c;

    print('vvvvvvvvvvvvvvvvnnnnnnnnnnnv'+val.toString());
    if(val.isNotEmpty){
      c = val[2].toRadixString(16) + val[1].toRadixString(16);

      final number = int.parse(c, radix: 16);

      for (int i = 0; i < number.toString().length - 1; i++) {
        print(number.toString()[i].toString());
        tempalue = tempalue + number.toString()[i];
      }
      tempalue =
          tempalue + '.' + number.toString()[number.toString().length - 1];
    }
    print('vvvvvvvvvvvvvvvvv'+tempalue.toString());

    notifyListeners();
  }



  String myv='';
  String get getmyv=>myv;

  set updateGetmyv(String val){

    myv=val;
    notifyListeners();
  }
  String tmpType='';
  String get gettmpType=>tmpType;

  set updateGettmpType(String val){
    tmpType=val;
    notifyListeners();
  }






  saveDeviceVital(context) async {

    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);



    if(getmyv.toString()!=''){
      ProgressDialogue().show(context, loadingText: 'saving Vitals...');
      var body = {
        "memberId": userRepository.getUser.uhID.toString(),
        'dtDataTable': jsonEncode([
          {
            'vitalId': 6.toString(),
            'vitalValue': getmyv.toString(),
          }
        ]),
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
        "time": DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
      };

      var data = await RawData().api(
        "Patient/addVital",
        body,
        context,
      );
      ProgressDialogue().hide();
      if (data['responseCode'] == 1) {
        Alert.show('vital Saved Successfully !');

      } else {
        Alert.show( data['responseMessage'].toString());
      }
    }else{
      Alert.show( 'Please measure your temperature');
    }

  }


}