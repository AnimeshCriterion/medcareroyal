import 'package:date_time_picker/date_time_picker.dart';
import 'package:medvantage_patient/Modal/supplement_intake_modal.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/api/api_response.dart';
import 'package:medvantage_patient/app_manager/api/api_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/app_manager/my_button.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_date_time_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Localization/app_localization.dart';
import '../Modal/SupplementIntakeDataModek.dart';
import '../Modal/food_intake_data_moel.dart';
import '../app_manager/app_color.dart';
import '../app_manager/bottomSheet/bottom_sheet.dart';
import '../app_manager/bottomSheet/functional_sheet.dart';
import '../authenticaton/user_repository.dart';

import 'package:get/get.dart';

import '../medcare_utill.dart';
import '../theme/theme.dart';
class FoodIntakeViewModel extends ChangeNotifier {
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
      context, String isGiven, FoodIntakeDataModel data, {index3}) {

    if (isGiven == "0") {
      return  Consumer<ThemeProviderLd>(
          builder: (BuildContext context, themeChange, _) {
          return InkWell(
            onTap: () async {
              await CustomBottomSheet.open(context,
              child: Container( decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:  themeChange.darkTheme
                    ? AppColor.white
                    : AppColor.black,
              ),


                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Intake Time',style:  themeChange.darkTheme
                          ? MyTextTheme.largePCB.copyWith(color: Colors.white):MyTextTheme.largeBCB,),
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
                          MyButton(title: 'Save',width: 150,onPress: () async {
                            Get.back(

                            );
                            await CustomBottomSheet.open(context,
                                child: FunctionalSheet(
                                  message: 'Are you sure you have taken this food?',
                                  buttonName: 'Yes',
                                  onPressButton: () async {
                                    intakeSupplement(context, data);
                                  },
                                ));
                          },),
                        ],
                      )

                    ],
                  ),
                ),
              ));

            },
            child: Container(
              alignment: Alignment.center,

              child: Icon(
                Icons.error,
                color: Colors.orange,
                size: 25,
              ),
            ),
          );
        }
      );
    } else if (isGiven == "1") {
      return InkWell(
        onTap: () {},
        child: Container(
          height: 20,alignment: Alignment.center,
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
      return  Consumer<ThemeProviderLd>(
          builder: (BuildContext context, themeChange, _) {
          return InkWell(
            onTap: () async {
              await CustomBottomSheet.open(context,
                  child: Container( decoration: BoxDecoration(
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
                              ? MyTextTheme.largePCB.copyWith(color: Colors.white):MyTextTheme.largeBCB, ),
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
                              MyButton(title: 'Save',width: 150,onPress: () async {
                                Get.back(

                                );
                                await CustomBottomSheet.open(context,
                                    child: FunctionalSheet(
                                      message: 'Are you sure you have taken this food?',
                                      buttonName: 'Yes',
                                      onPressButton: () async {
                                        intakeSupplement(context, data);
                                      },
                                    ));
                              },),
                            ],
                          )

                        ],
                      ),
                    ),
                  ));
            },
            child: Container(alignment: Alignment.center,
              child: CircleAvatar(
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

  Rx<TextEditingController> dateController = TextEditingController().obs;


  bool showNoData=false;
  bool get getShowNoData=>showNoData;
  set updateShowNoData(bool val){
    showNoData=val;
    notifyListeners();
  }
  apiCall(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    dPrint( 'nvnnvnnvnnv '+dateC.text);
    updateFoodDataList=[];
    updateShowNoData=false;
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    try{

      final prefs = await SharedPreferences.getInstance();
      var langId=await prefs.getString("lang").toString();
      var data = await _api.callMedvanatagePatient7096(context,
          url:
              "api/FoodIntake/GetFoodIntake?Uhid=${userRepository.getUser.uhID.toString()}&entryType=D&languageId=${langId.toString()}&fromDate=${DateFormat('yyyy-MM-dd').format(DateTime.parse(dateC.text.toString()))}",
          localStorage: true,
          apiCallType: ApiCallType.get());
      dPrint('nnnvnnnv '+data  .toString());
      updateShowNoData=true;
       // Get.back();
      if (data['status'] == 1) {
        updateFoodDataList = data['foodIntakeList'];

        dPrint("animesh" + getDataList.toList().toString());
      } else {

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
        // Alert.show(data['responseValue'].toString());
      }
    }
    catch(e){
      updateShowNoData=true;
       // Get.back();

    }
  }

  List getFoodDataList = [];

  set updateFoodDataList(List val) {
    getFoodDataList = val;
    notifyListeners();
  }

  List<FoodIntakeDataModel> get getDataList =>
      List<FoodIntakeDataModel>.from(getFoodDataList
          .map((e) => FoodIntakeDataModel.fromJson(e))
      ).toList();

  intakeSupplement(
      context,
      FoodIntakeDataModel datamodel,
      ) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    var data = await _api.callMedvanatagePatient7096(context,
        url:
        "api/FoodIntake/IntakeByDietID?Uhid=${userRepository.getUser.uhID.toString()}&dietID=${datamodel.dietId}&userID=99&givenAt=${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()+' '+DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(intakeTimeC.text)) .toString()}",
        apiCallType: ApiCallType.post(body: {}),
        isSavedApi: true);
    if (data['status'] == 1) {

      Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
      // Alert.show(data['message'].toString());
      apiCall(context);
    } else {
      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
      // Alert.show(data['message'].toString());
    }
  }
}
