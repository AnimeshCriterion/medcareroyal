import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/Modal/supplement_intake_modal.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/api/api_response.dart';
import 'package:medvantage_patient/app_manager/api/api_util.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/functional_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../LiveVital/low_ecg/ecg_controller.dart';
import '../LiveVital/pmd/my_text_theme.dart';
import '../Localization/app_localization.dart';
import '../Modal/SupplementIntakeDataModek.dart';
import '../app_manager/app_color.dart';
import '../app_manager/my_button.dart';
import '../app_manager/widgets/text_field/primary_date_time_field.dart';
import '../authenticaton/user_repository.dart';
import '../medcare_utill.dart';
import '../theme/theme.dart';

class SupplementIntakeViewModal extends ChangeNotifier {
  final Api _api = Api();
  TextEditingController nameC = TextEditingController();
  TextEditingController dateC=TextEditingController();

  List SupplementDate = [
    {'time': "8:00\nam"},
    {'time': "11:00\nam"},
    {'time': "2:00\npm"},
    {'time': "5:00\npm"},
    {'time': "8:00\npm"},
    {'time': "10:00\npm"}
  ];

  String intakeDate = '';

  String get getIntakeDate => intakeDate;

  set updateIntakeListResponse(String val) {
    intakeDate = val as String;
    notifyListeners();
  }

  List<FoodListDataModel> get getIntakeList => getIntakeResponse.data ?? [];

  // List<SupplementIntakeModal> get getIntakeList =>
  //     List<SupplementIntakeModal>.from(getIntakeResponse.data == null
  //         ? []
  //         : getIntakeResponse.data
  //         .map((element) => SupplementIntakeModal.fromJson(element)));

  ApiResponse intakeResponse = ApiResponse.initial("initial");

  ApiResponse get getIntakeResponse => intakeResponse;

  set _updateIntakeResponse(ApiResponse val) {
    intakeResponse = val;

    notifyListeners();
  }


  TextEditingController intakeTimeC=TextEditingController();
  Widget iconAccordingToGivenStatus(
      context, String isGiven, SupplementIntakeDataModel data) {
    dPrint('nnnnvnnn '+isGiven.toString());
    if (isGiven == "0") {
      return Consumer<ThemeProviderLd>(
          builder: (BuildContext __context, themeChange, _) {
          return InkWell(
            onTap: () async {
              await CustomBottomSheet.open(context,
                  child:  Consumer<ThemeProviderLd>(
                      builder: (BuildContext _context, themeChange, _) {
                      return Container( decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:  themeChange.darkTheme
                            ? AppColor.black
                            : AppColor.white,
                      ),


                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Intake Time',style: themeChange.darkTheme
                                  ?MyTextTheme().largeWCB:MyTextTheme().largeBCB,),
                              SizedBox(height: 15,),
                              PrimaryDateTimeField(
                                controller: intakeTimeC,
                                dateTimePickerType: DateTimePickerType.time,
                                hintText: 'Select Intake Time',
                                onChanged: (val){
                                  dPrint('intakeTimeCintakeTimeC '+intakeTimeC.toString());
                                  notifyListeners();
                                },
                              ),
                              SizedBox(height: 35,),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyButton(color:  themeChange.darkTheme
                                  ? AppColor.white
                                  : AppColor.black,textStyle: themeChange.darkTheme
                                      ?  MyTextTheme().mediumWCB.copyWith(color: Colors.black): MyTextTheme().mediumWCB
                                    ,title: 'Save',width: 150,onPress: () async {
                                      if(intakeTimeC.text.isNotEmpty){
                                Get.back();
                                await CustomBottomSheet.open(context,
                                    child: FunctionalSheet(
                                      message:
                                          'Are you sure you have taken this supplement?',
                                      buttonName: 'Yes',
                                      onPressButton: () async {
                                        intakeSupplement(context, data);
                                      },
                                    ));
                                      }
                                      else{
                                        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message:  'Please select time'.toString()));
                                        // alertToast(context, 'Please select time');
                                      }
                            },),
                                ],
                              )

                            ],
                          ),
                        ),
                      );
                    }
                  ));



            },
            child: Container(
              alignment: Alignment.center,

              child:  Icon(
                  Icons.error,
                  size: 25,color: Colors.orange
              ),
            ),
          );
        }
      );
    } else if (isGiven == "1") {
      return InkWell(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const CircleAvatar(
            radius: 10,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
      );
    } else {
      return Consumer<ThemeProviderLd>(
          builder: (BuildContext ___context, themeChange, _) {
          return InkWell(
            onTap: () async {
              await CustomBottomSheet.open(context,
                  child: Consumer<ThemeProviderLd>(
                      builder: (BuildContext __context, themeChange, _) {
                      return Container( decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:  themeChange.darkTheme
                            ? AppColor.black
                            : AppColor.white,
                      ),


                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Intake Time',style: themeChange.darkTheme
                                  ?  MyTextTheme().largeBCB.copyWith(color: Colors.white): MyTextTheme().largeBCB,),
                              SizedBox(height: 15,),
                              PrimaryDateTimeField(
                                controller: intakeTimeC,
                                dateTimePickerType: DateTimePickerType.time,
                                hintText: 'Select Intake Time',
                                onChanged: (val){
                                  dPrint('intakeTimeCintakeTimeC '+intakeTimeC.toString());
                                  notifyListeners();
                                },
                              ),
                              SizedBox(height: 35,),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyButton(title: 'Save', color:  themeChange.darkTheme
                                  ? AppColor.white
                                      : AppColor.black,textStyle: themeChange.darkTheme
                                      ?  MyTextTheme().mediumWCB.copyWith(color: Colors.black): MyTextTheme().mediumWCB, width: 150,onPress: () async {
                                    if(intakeTimeC.text.isNotEmpty){
                                Get.back();
                                await CustomBottomSheet.open(context,
                                    child: FunctionalSheet(
                                      message:
                                          'Are you sure you have taken this supplement?',
                                      buttonName: 'Yes',
                                      onPressButton: () async {
                                        intakeSupplement(context, data);
                                      },
                                    ));
                                    }
                                    else{
                                      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message:  'Please select time'.toString()));
                                      // alertToast(context, 'Please select time');
                                    }
                            },),
                                ],
                              )

                            ],
                          ),
                        ),
                      );
                    }
                  ));

            },
            child: Container(
              alignment: Alignment.center,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child:  CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.access_time_filled,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ),
          );
        }
      );
    }
  }


  bool showNoData=false;
  bool get getShowNoData=>showNoData;
  set updateShowNoData(bool val){
    showNoData=val;
    notifyListeners();
  }
  List dataList = [];

  set updateDataList(List val) {
    dataList = val;
    notifyListeners();
  }

  List<SupplementIntakeDataModel> get getDataList =>
      List<SupplementIntakeDataModel>.from(dataList
          .map((e) => SupplementIntakeDataModel.fromJson(e))
       ).toList();


  Rx<TextEditingController> dateController = TextEditingController().obs;

  apiCall(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    updateDataList=[];
    updateShowNoData=false;
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
// ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());

    final prefs = await SharedPreferences.getInstance();
    var langId=await prefs.getString("lang").toString();
    var data = await _api.callMedvanatagePatient7096(context,
        url:
            "api/MedicationIntake/GetSupplementIntake?Uhid=${userRepository.getUser.uhID.toString()}&entryType=D&languageId=${langId.toString()}&fromDate=${dateC.text.toString()}",
        localStorage: true,
        apiCallType: ApiCallType.get());

    updateShowNoData=true;
     // Get.back();
    if (data['status'] == 1) {
      updateDataList = data['foodIntakeList'];
      dPrint("Animesh"+dataList.toList().toString());
    } else {
      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
      // Alert.show(data['responseValue'].toString());
    }
  }


  intakeSupplement(
    context,
    SupplementIntakeDataModel datamodel,
  ) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    try{
      var data = await _api.callMedvanatagePatient7096(context,
          url:
              "api/MedicationIntake/IntakeBySupplementID?Uhid=${userRepository.getUser.uhID.toString()}&medicationID=${datamodel.medicationId.toString()}&userID=${userRepository.getUser.userId.toString()}&givenAt=${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()+' '+intakeTimeC.text.toString()}",
          apiCallType: ApiCallType.post(body: {}),
          isSavedApi: true);

       Get.back();
      if (data['status'] == 1) {

        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message'].toString());
        apiCall(context);
      } else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message'].toString());
      }
    }
    catch(e){

       Get.back();
    }
  }


}
