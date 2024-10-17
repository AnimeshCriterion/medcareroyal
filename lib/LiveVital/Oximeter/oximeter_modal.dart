

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../Localization/app_localization.dart';
import '../../app_manager/alert_toast.dart';
import '../../authenticaton/user_repository.dart';
import '../live_vital_controller.dart';
import 'oximeter_controlle.dart';


class OximeterModal {


  // DashboardController dashC=Get.put(DashboardController());
  // IPDController ipdC=Get.put(IPDController());
  OximeterController controller=Get.put(OximeterController());
  LiveVitalModal vitalModal=LiveVitalModal();


  // Press Event


  void saveData(context) async{

    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);
    if(controller.getOximeterData.spo2==null){
      Alert.show('No data to save.');
    }
    else{
      // vitalModal.onPressedClear(context);
      // vitalModal.controller.vitalTextX[2].text=controller.getOximeterData.spo2.toString() ;
      // vitalModal.controller.vitalTextX[0].text=controller.getOximeterData.heartRate.toString();
      // vitalModal.controller.vitalsList[6]['controller'].text=controller.getOximeterData.hrv.toString();
      // vitalModal.controller.vitalsList[6]['controller'].text=controller.getOximeterData.perfusionIndex.toString();


          var data= await vitalModal.addVitalsData(context,spo2: controller.getOximeterData.spo2.toString(),
         pr: controller.getOximeterData.heartRate.toString(),
             );


      if(data['status']==0){
        Alert.show(data['message'].toString());
      }
      else{
        if(data['responseCode']==1){
          Alert.show('Data Saved Successfully !');
        }
        else{
          Alert.show(data['message'].toString());
        }
      }
    }
  }



}