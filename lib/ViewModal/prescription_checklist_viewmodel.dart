import 'dart:convert';
import 'dart:developer';

import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/View/Pages/addvital_view.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/authenticaton/user.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

import '../LiveVital/pmd/my_text_theme.dart';
import '../Modal/medicine_intake_data_model.dart';
import '../app_manager/api/api_call.dart';
import '../app_manager/app_color.dart';
import '../app_manager/bottomSheet/bottom_sheet.dart';
import '../app_manager/bottomSheet/functional_sheet.dart';
import '../app_manager/my_button.dart';
import '../app_manager/widgets/text_field/primary_date_time_field.dart';
import '../authenticaton/user_repository.dart';
import '../theme/theme.dart';

class MedicineViewCheckListDataMOdel extends ChangeNotifier{
  final Api _api = Api();
  Rx<TextEditingController> dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now())).obs;

  Rx<TextEditingController> dateShowController = TextEditingController(text: DateFormat("dd MMM yyyy").format(DateTime.now())).obs;

  TextEditingController dateC=TextEditingController();
  List<JsonTime> durationType = [];

  List medDates = [];
  List medNames = [];
  List medNameandDate = [];
  List medDosage = [];


  bool showNoData=false;
  bool get getShowNoData=>showNoData;
  set updateShowNoData(bool val){
    showNoData=val;
    notifyListeners();
  }

  Map<String,dynamic> dataList = {};
  set notifyListnerDataList(Map<String,dynamic> val){
    dataList = val;
    notifyListeners();
  }

  /// DRUG DATES ///
  List<Date> get getMedDates => List<Date>.from(
      medDates.map((e) => Date.fromJson(e))
  );
  set notifyListnerMedDate(List val){
    medDates = val;
    notifyListeners();
  }

  /// DRUG NAMES ///
  List<DrugName> get getMedNames => List<DrugName>.from(
      medNames.map((e) => DrugName.fromJson(e))
  );
  set notifyListnerMedName(List val){
    medNames = val;
    notifyListeners();
  }

 var  fullData ;
  get getFullData=>fullData;
  set updateFullData(val){
    fullData=val;
    notifyListeners();
  }


  /// DRUG DATE AND NAMES
  List<MedicationNameAndDate> get getMedNamesandDates =>
      List<MedicationNameAndDate>.from(
      medNameandDate.map((e) => MedicationNameAndDate.fromJson(e)).where((medication) {
        return  dateController.value.text ==  medication.date.toString();
        //
        // return  ' ' ==  ' ';
      }).toList()
  );


  String checkIcon='';
  set updateCheckIcon(String val){
    checkIcon=val;
    // notifyListeners();
  }

  String missedIcon='';
  set updateMissedIcon(String val){
    missedIcon=val;
    // notifyListeners();
  }
  String upcomingIcon='';
  set setUpcomingIcon(String val){
    upcomingIcon=val;
    // notifyListeners();
  }
  String lateIcon='';
  set setUpdateLateIcon(String val){
    lateIcon=val;
    // notifyListeners();
  }
  String UpdateSOSicon='';
  set setUpdateSOSicon(String val){
    UpdateSOSicon=val;
    // notifyListeners();
  }

  clearData(){
    setUpcomingIcon='';
    updateMissedIcon='';
    updateCheckIcon='';
    UpdateSOSicon='';
    lateIcon='';
    notifyListeners();

  }




  set notifyListnerMedNameandDate(List val){
    medNameandDate = val;
    notifyListeners();
  }

  /// DOSAGE FORM
  List<DosageForm> get getDosageForm => List<DosageForm>.from(
      medDosage.map((e) => DosageForm.fromJson(e))
  );
  set notifyListnerDosageForm(List val){
    medDosage = val;
    notifyListeners();
  }

  apiCall(context)async{
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
    updateShowNoData=false;
    final prefs = await SharedPreferences.getInstance();
    var langId=await prefs.getString("lang").toString();
    // ProgressDialogue().show(context, loadingText: 'Loading...');
    var data=await _api.callMedvanatagePatient7082(context,
        url: "api/PatientMedication/GetAllPatientMedication?UhID=${userRepository.getUser.uhID.toString()}&languageId=${langId.toString()}",
        localStorage: true,
        apiCallType: ApiCallType.get());

    updateShowNoData=true;
    //  Get.back();
    if(data['status']==1){
      notifyListnerDataList = data['responseValue'];
      notifyListnerMedDate = dataList['date'];
      notifyListnerMedName = dataList['drugName'];
      notifyListnerMedNameandDate = dataList['medicationNameAndDate'];
      notifyListnerDosageForm = dataList['dosageForm'];
      updateFullData=data;
    }else{
      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
      // Alert.show(data['message'].toString());
    }

    updateShowNoData=true;
  }
  TextEditingController intakeTimeC=TextEditingController();

  insertMedication(context,int pmID,int prescriptionID, String time,{duration,})async{
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    dPrint(  intakeTimeC.text.toString(),);
    String formattedDate = DateFormat('yyyy-MM-dd ').format(DateFormat('dd MMM yyyy').parse(dateShowController.value.text));
    // String time = DateFormat('HH:mm').format(DateFormat('yyyy-MM-ddHH:mm').parse(intakeTimeC.text));
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString()



    );
    dPrint(formattedDate.toString()+ intakeTimeC.text.toString(),);
    try{
      var body = {
        // "uhID":userRepository.getUser.uhID.toString(),
        "pmID": pmID,
        // "intakeDateAndTime":formattedDate.toString()+time.toString(),
        "intakeDateAndTime":formattedDate.toString()+intakeTimeC.text.toString(),
        "prescriptionID": prescriptionID,
        "userID": userRepository.getUser.userId.toString(),
        "duration": duration.toString(),
        "compareTime": time.toString()
      };

      var data = await _api.callMedvanatagePatient7082(context,
          url: "api/PatientMedication/InsertPatientMedication",
          apiCallType: ApiCallType.rawPost(body: body),
      isSavedApi: true);

       Get.back();
      if (data['status'] == 1) {
        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message'].toString());
        await apiCall(context);
      } else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message:data['responseValue'].toString()));
        // Alert.show(data['responseValue'].toString());
      }
    }
    catch(e){
       Get.back();
    }
  }



  bool checkDurationType(String duration){
    dPrint("Animes$duration");
   return durationType.map((e) =>
        e.durationType.toString().trim().removeAllWhitespace.toLowerCase()).toList().contains(duration.toLowerCase());
  }

  Widget missedOrNot(context, String duration, List<JsonTime> jsonTimeData, MedicationNameAndDate medicationNameAndDate){

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    String iconString=jsonTimeData.isEmpty? '':jsonTimeData[0].icon.toString();
    String durationTypeString=jsonTimeData.isEmpty? '':jsonTimeData[0].durationType.toString();
    String timeString=jsonTimeData.isEmpty? '':jsonTimeData[jsonTimeData.map((e) => e.durationType.toString().toLowerCase()).toList().indexOf(duration.toLowerCase())].time.toString();
    dPrint('nnnnvnnvnnnnnn '+timeString);

     if(checkDurationType(duration) == false){
      return const Center(child: Text("--",textAlign: TextAlign.center,));
    }
     else if( iconString.toString() == "isStop"){
       return const Center(child: Text("--",textAlign: TextAlign.center,));
     }
    else{
      if(iconString.toString()=='check' ){
        updateCheckIcon='check';
      }
      else  if(iconString.toString()=='exclamation'){
        updateMissedIcon='missed';
      }
      else if(iconString.toString()=='late'){
        lateIcon='late';
      }
      else if(durationTypeString.toString()=='SOS'){
        UpdateSOSicon='SOS';
      }
      else{
        setUpcomingIcon='upcoming';
      }

      return InkWell(
        onTap: ()async{
          ApplicationLocalizations localization =
          Provider.of<ApplicationLocalizations>(context, listen: false);
          if(iconString.toString() != "check"){
            DateTime datee=DateFormat('HH:mm').parse((DateFormat('HH:mm').format(DateFormat('yyyy-MM-dd hh:mm a').parse('2024-08-07 '+timeString.toString()) )));
            int data=        datee.difference( DateFormat('HH:mm').parse(DateFormat('HH:mm').format(DateTime.now() )) ).inHours;

           if(data<=1) {
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
                             MyButton(title: 'Save ',color:  themeChange.darkTheme
                             ? AppColor.white
                                 : AppColor.black,textStyle: themeChange.darkTheme
                                 ?  MyTextTheme().mediumWCB.copyWith(color: Colors.black): MyTextTheme().mediumWCB, width: 150,onPress: () async {
                               if(intakeTimeC.value.text.isNotEmpty){
                                 Get.back(

                               );
                               dPrint('intakeTimeCintakeTimeC '+intakeTimeC.value.text.toString());

                               await CustomBottomSheet.open(context,
                                   child: FunctionalSheet(
                                     message: localization
                                         .getLocaleData.areYouSureYouHaveTakenThisMedicine
                                         .toString(),
                                     buttonName:  localization.getLocaleData.yes.toString(),
                                     onPressButton: () async {

                                            await insertMedication(
                                                context,
                                                int.parse(medicationNameAndDate
                                                    .pmId
                                                    .toString()),
                                                int.parse(medicationNameAndDate
                                                    .prescriptionRowID
                                                    .toString()),
                                                DateFormat('HH:mm')
                                                    .format(
                                                        DateFormat('hh:mm a')
                                                            .parse(timeString
                                                                .toString()))
                                                    .toString(),
                                            duration: duration.toString());

                                        },
                                   ));
                               }
                               else{
                                 Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Please select time'.toString()));
                                 // alertToast(context, 'Please select time');
                               }
                             },),
                           ],
                         )

                       ],
                     ),
                   ),
                 ));
            }
           else{

             Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Medicine cannot be updated for previous days or before the prescribed time.".toString()));
             // Alert.show("Before time you can't take medicine.");
           }
          }else{
            showMedicineTimePopup(context,medicationNameAndDate.drugName.toString(),
                timeString.toString());


          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: iconString.toString() == "check"  ?
                Colors.green : iconString.toString() == "exclamation"?
                Colors.red: durationTypeString.toString() == "SOS"?Colors.red:iconString.toString() == "late"?Colors.blue:Colors.blue,
                child: Icon(iconString.toString() == "check"  ?
                Icons.check:iconString.toString() == "exclamation" && durationTypeString.toString() != "SOS"?
                  Icons.error_outline:durationTypeString.toString() == "SOS"?
                Icons.sos:iconString.toString() == "late"?
                Icons.watch_later:
                Icons.schedule,
                  color: Colors.white,
                  size: 15,),
              ),
              Visibility(
                visible: medicationNameAndDate.remark!.isNotEmpty,
                child: Text(medicationNameAndDate.remark.toString(),overflow: TextOverflow.ellipsis,
                style: TextStyle(color: themeChange.darkTheme? Colors.white:Colors.black),),
              )
            ],
          ),
        ),
      );
    }
    notifyListeners();
  }


  vitalDialog(context){
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Are you want to add Vital.'),
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top:25),
              child: SizedBox(
                height: 135,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: PrimaryButton(onPressed: (){
                         Get.back();
                        MyNavigator.push(context, const AddVitalView());
                      }, title: localization.getLocaleData.yes.toString()),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 150,
                      child: PrimaryButton(onPressed: (){
                         Get.back();

                      }, title: localization.getLocaleData.later.toString()),
                    ),

                  ],
                ),
              ),
            ));
      },
    );
  }

  void showMedicineTimePopup(BuildContext context, String medicineName, String medicineTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MedicineTimePopup(
          medicineName: medicineName,
          medicineTime: medicineTime,
        );
      },
    );
  }

}


class MedicineTimePopup extends StatelessWidget {
  final String medicineName;
  final String medicineTime;

  MedicineTimePopup({required this.medicineName, required this.medicineTime});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medicine Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Medicine: $medicineName',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Time: $medicineTime',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}