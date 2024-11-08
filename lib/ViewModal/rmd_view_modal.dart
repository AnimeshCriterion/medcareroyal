

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Localization/app_localization.dart';
import '../Modal/client_details_data_modal.dart';
import '../Modal/medicine_intake_data_model.dart';
import '../View/widget/common_method/show_progress_dialog.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_call.dart';
import '../assets.dart';
import '../authenticaton/user_repository.dart';

class RMDViewModal extends ChangeNotifier{


  final Api _api = Api();





  List patientLastVitalList=[];
  List get GetPatientLastVitalList=>patientLastVitalList;
  set updatepatientLastVitalList(List val){
    patientLastVitalList=val;
    notifyListeners();
  }

  getValue(vitalID,vitalKey){
    var data='';
    if(vitalID.toString()=='5'){
      data = double.parse(GetPatientLastVitalList.firstWhere(
                  (element) =>
                      element['vitalID'].toString() == vitalID.toString(),
                  orElse: () => {
                        "uhid": "",
                        "pmId": 0,
                        "vitalID": 0,
                        "vitalName": "",
                        "vitalValue": 0,
                        "unit": "",
                        "vitalDateTime": "",
                        "userId": 0,
                        "rowId": 0
                      })[vitalKey]
              .toString())
          .toStringAsFixed(1)
          .toString();
    }else{

      data = double.parse(GetPatientLastVitalList.firstWhere(
              (element) =>
          element['vitalID'].toString() == vitalID.toString(),
          orElse: () => {
            "uhid": "",
            "pmId": 0,
            "vitalID": 0,
            "vitalName": "",
            "vitalValue": 0,
            "unit": "",
            "vitalDateTime": "",
            "userId": 0,
            "rowId": 0
          })[vitalKey]
          .toString())
          .toStringAsFixed(0)
          .toString();
    }
    return    (data.toString()=='0'||data.toString()=='0.0')? '-':data.toString();
  }
  getUnit(vitalID,vitalKey ){
    var data='';


      data = GetPatientLastVitalList.firstWhere(
              (element) =>
          element['vitalID'].toString() == vitalID.toString(),
          orElse: () => {
            "uhid": "",
            "pmId": 0,
            "vitalID": 0,
            "vitalName": "",
            "vitalValue": 0,
            "unit": "",
            "vitalDateTime": "",
            "userId": 0,
            "rowId": 0
          })[vitalKey]
          .toString()   ;

    return    data.toString();
  }

  List vitalId=[
    {'id':7,
    'name':'Resp. Rate',
    'img':ImagePaths.rr2,},
    {'id':6,
      'name':'BP Dia',
      'img':  ImagePaths.bp2, },
    {'id':4,
      'name':'BP Sys',
      'img':  ImagePaths.bp, },
    {'id':56,
      'name':'Spo2',
      'img':  ImagePaths.spo2, },
    {'id':74,
      'name':'Heart Rate',
      'img':  ImagePaths.heartRate, },
    {'id':10,
      'name':'RBS',
      'img':  ImagePaths.rr2, },
    {'id':5,
      'name':'Temperature',
      'img':  ImagePaths.temp, },
    {'id':3,
      'name':'Pulse Rate',
      'img':  ImagePaths.pulse, },

  ];
  String vitalValue='';
  set updateVitalValue(String val){
    vitalValue=val;
    notifyListeners();
  }
  String vitalUnit='';
  set updateVitalUnit(String val){
    vitalUnit=val;
    notifyListeners();
  }
  String vitalVitalTime='';
  set updateVitalTime(String val){
    vitalVitalTime=val;
    notifyListeners();
  }
  String vitalVitalName='';
  set updateVitalName(String val){
    vitalVitalName=val;
    notifyListeners();
  }
  String vitalVitalImg='';
  set updateVitalImg(String val){
    vitalVitalImg=val;
    notifyListeners();
  }
  getVitalsValue() async {
    if(vitalId.isNotEmpty){
        updateVitalName=vitalId[4]['name'].toString();
        updateVitalImg=vitalId[4]['img'].toString();
        updateVitalValue=getValue(vitalId[4]['id'].toString(),'vitalValue');
        updateVitalUnit=getUnit(vitalId[4]['id'].toString(),'unit' );
        vitalVitalTime= getVitalTime(vitalId[4]['id'].toString(),).toString();

    }
    Timer.periodic(Duration(seconds: vitalId.length*5 ), (timer) async {
      for(int i=0;i<vitalId.length;i++){
        await Future.delayed(Duration(seconds: 5))  .then((value) async {
          updateVitalName=vitalId[i]['name'].toString();
          updateVitalImg=vitalId[i]['img'].toString();
          updateVitalValue=getValue(vitalId[i]['id'].toString(),'vitalValue');
          updateVitalUnit=getUnit(vitalId[i]['id'].toString(),'unit' );
          vitalVitalTime= getVitalTime(vitalId[i]['id'].toString(),).toString();
        });
      }
    });

  }

  getVitalTime(vitalID){
    int difference=0;
    String unit='';
   var dateTime=GetPatientLastVitalList.firstWhere((element) => element['vitalID'].toString()==vitalID.toString(),
        orElse: ()=>{"uhID":" ","homecareId":0,"vitalID":0,"vitalName":"Weight","vitalValue":0,"unit":" ","vitalDateTime":"","userId":0} )['vitalDateTime'].toString();

      difference = DateTime.now()
        .difference(DateTime.parse(dateTime.toString()))
        .inMinutes;
    unit='Min';
    if(difference>=60){

        difference = DateTime.now()
          .difference(DateTime.parse(dateTime.toString()))
          .inHours;
        unit='Hr';
    }


   return difference==0? '':difference.toString()+' '+unit;
    }

  hitVitalHistory(context) async {
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);


    try {

      Map<String, dynamic> body = { };


      var data = await _api.callMedvanatagePatient7082(context,
          url: 'api/PatientVital/GetPatientLastVital?uhID=${userRepository.getUser.uhID.toString()}',
          // url: 'HomeCareService/GetPatientLastVital?uhID=${userRepository.getUser.uhID.toString()}',
          localStorage: false,
          apiCallType: ApiCallType.get());

      print("nnnnnnnnnnnnnn${jsonEncode(data)}");
      if (data["status"] == 1) {
        updatepatientLastVitalList= data['responseValue'];


      } else {

        // Alert.show(data['responseValue'].toString());
      }
    }
    catch (e) {
      print(e.toString());

    }
  }

  insertMedication(context,String pmID,String prescriptionID, String time)async{
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    String formattedDate = DateFormat('yyyy-MM-dd ').format(DateTime.now() );
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString()



    );
    try{
      var body = {
        // "uhID":userRepository.getUser.uhID.toString(),
        "pmID": pmID,
        "intakeDateAndTime":formattedDate.toString()+time.toString(),
        "prescriptionID": prescriptionID,
        "userID": userRepository.getUser.userId.toString(),

      };
      print("BODY $body");

      var data = await _api.callMedvanatagePatient7082(context,
          url: "api/PatientMedication/InsertPatientMedication",
          apiCallType: ApiCallType.rawPost(body: body),
          isSavedApi: true);
      print("DATA @@ $data");

      Get.back();
      if (data['status'] == 1) {
        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message'].toString());
        await pillsReminderApi(context);
      } else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message:data['responseValue'].toString()));
        // Alert.show(data['responseValue'].toString());
      }
    }
    catch(e){
      Get.back();
    }
  }

List  ManualFoodList=[];
  List get getManualFoodList=>ManualFoodList;
  set updateManualFoodList(List val){
    ManualFoodList=val;
    notifyListeners();
  }

  getWaterIntake(){
    var dataa= getManualFoodList.isEmpty? '0':getManualFoodList.firstWhere((element) => element['foodID'].toString()=='97694',orElse: ()=>
    {"foodID":0,"foodName":"","quantity":"0.0"}
    )['quantity'].toString() ;
    var data=(double.parse( dataa.toString().trim()==''? '0.0':dataa)/1000).toStringAsFixed(2).toString() ;
    return  data;
  }

  manualFoodAssign(context) async {
    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    // ProgressDialogue().show(context, loadingText:localization.getLocaleData.Loading.toString());
    try {
      var data = await _api.callMedvanatagePatient7096(context,
          url: "api/ManualFoodAssign/GetManualFoodAssignList?Uhid=${userRepository.getUser.uhID.toString()}&intervalTimeInHour=24",
          localStorage: true,
          apiCallType: ApiCallType.get());

      // Get.back();
      print("nnnnnnnnnnnnnn${jsonEncode(data)}");
      if (data["status"] == 1) {
        updateManualFoodList=data['responseValue'];
      } else {

        // Alert.show(data['responseValue'].toString());
      }
    }
    catch (e) {
      // Get.back();

    }
  }

  List medNameandDate=[];
  List<MedicationNameAndDate> get getMedNamesandDates => List<MedicationNameAndDate>.from(
      medNameandDate.map((e) => MedicationNameAndDate.fromJson(e)).where((medication) {
        return  DateFormat('yyyy-MM-dd').format(DateTime.now() ).toString()==  medication.date.toString();
      }).toList()
  );
set updatetmedNameandDate(List val){
  medNameandDate=val;
  notifyListeners();
}


  pillsReminderApi(context)async{
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
    updatetmedNameandDate=[];
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    // ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());

        try{
      final prefs = await SharedPreferences.getInstance();
      var langId = await prefs.getString("lang").toString();

      var data = await _api.callMedvanatagePatient7082(context,
          url:
              "api/PatientMedication/GetAllPatientMedication?UhID=${userRepository.getUser.uhID.toString()}&languageId=${langId.toString()}",
          apiCallType: ApiCallType.get());
      print('nnnn' + data.toString());

      // Get.back();
      if (data["status"] == 1) {
        updatetmedNameandDate = data["responseValue"]["medicationNameAndDate"];
      } else {

        // Alert.show(data['message'].toString());
      }
    }
    catch(e){}
  }



  List  getMediconeCount(){

    List  upcomingMedicine=[];
  for(int i=0;i<getMedNamesandDates.length;i++){

    for(int j=0;j<(getMedNamesandDates[i].jsonTime??[]).length;j++){


      if((getMedNamesandDates[i].jsonTime??[])[j].icon=='upcoming'    ) {

        upcomingMedicine.add(Map.from({'drugName':getMedNamesandDates[i].drugName.toString(),
          'pmId':getMedNamesandDates[i].pmId.toString(),
          'prescriptionRowID':getMedNamesandDates[i].prescriptionRowID.toString(),
          'dosageForm':getMedNamesandDates[i].dosageForm.toString(),
          'remark':getMedNamesandDates[i].remark.toString(),
          'icon':(getMedNamesandDates[i].jsonTime??[])[j].icon.toString(),
          'time':(getMedNamesandDates[i].jsonTime??[])[j].time.toString(),
        }));
        
      }

    }
  }

  return upcomingMedicine;
  }

  currentWise(context){
   int hr= int.parse(DateFormat('HH').format(DateTime.now()).toString());

   ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
   print('nnnn' + hr.toString());
   if(hr>0 && hr <=12){
     return localization.getLocaleData.gm.toString();
   }
   else  if(hr>12  &&  hr <=17){
     return localization.getLocaleData.gnoon.toString();
   }
   else  if(hr>17  &&  hr <=20){
     return localization.getLocaleData.ge.toString();
   }
   else  if(hr>19  &&  hr <=24){
     return localization.getLocaleData.gn.toString();
   }
   return '';
  }


  getMediconecheck(){

    int n=0;
    for(int i=0;i<getMedNamesandDates.length;i++){

      for(int j=0;j<(getMedNamesandDates[i].jsonTime??[]).length;j++){
        if((getMedNamesandDates[i].jsonTime??[])[j].icon=='check'  ) {
          n++;
        }
      }
    }

    return n;
  }




  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set updateCurrentIndex(int val) {
    _currentIndex = val;
    notifyListeners();
  }

  int _steps = 0;
  double _distance = 0.0;
  double get distance => _distance;
  int _todaysStep = 0;
  int get todaysStep => _todaysStep;
  set updateTodayStep(int val) {
    _todaysStep = val;
    notifyListeners();
  }

  StreamSubscription<StepCount>? _subscription;
  late Pedometer _pedometer;

  // Start the step counter and manage the step data
  Future<void> startStepCounter() async {
    final prefs = await SharedPreferences.getInstance();
    print("nnvnnnnnvnnnnvnnnnvn : $_steps");
    final dateFormat = DateFormat('yyyy-MM-dd');
    final currentDate = dateFormat.format(DateTime.now());

    print("nnvnnnnnvnnnnvnnnnvn : $_steps");
    _subscription = Pedometer.stepCountStream.listen(
          (StepCount event) async {
        _steps = event.steps;

        print("Today's Step: $_steps");
        var storedData = prefs.getString('step');

        if (storedData != null) {
          var decodedData = jsonDecode(storedData);

          if (decodedData['time'] == currentDate) {
            var updatedData = {
              'steps': decodedData['steps'],
              'currentstep': _steps,
              'time': currentDate,
            };
            prefs.setString('step', jsonEncode(updatedData));
          } else {
            _initializeStepData(prefs, currentDate);
          }

          updateTodayStep = int.parse(decodedData['currentstep'].toString()) - int.parse(decodedData['steps'].toString());

          _distance = _calculateDistance(_todaysStep);
        } else {
          _initializeStepData(prefs, currentDate);
        }

        print("Today's Step: $_todaysStep");
        print("Distance: $_distance km");
      },
      onError: (error) {
        print('ErrorToday: $error');
      },
    );

    // Initial calculation of today's steps if data is already stored
    var initialData = prefs.getString('step');
    if (initialData != null) {
      var decodedData = jsonDecode(initialData);
      updateTodayStep = int.parse(decodedData['currentstep'].toString()) - int.parse(decodedData['steps'].toString());
    }

    print("Initial Today's Step: $_todaysStep");
  }

  // Calculate the distance based on the number of steps
  double _calculateDistance(int steps) {
    const double stepLengthInMeters = 0.78; // Average step length in meters
    return steps * stepLengthInMeters / 1000; // Convert to kilometers
  }

  // Initialize step data if no previous data exists or the date has changed
  void _initializeStepData(SharedPreferences prefs, String currentDate) {
    var initialData = {
      'steps': _steps,
      'currentstep': _steps,
      'time': currentDate,
    };
    prefs.setString('step', jsonEncode(initialData));
    updateTodayStep = 0;
  }


  Map<String, dynamic> ClientDetails={};
  ClientDetailsDataModal get getClintDetails=>ClientDetailsDataModal.fromJson(ClientDetails);
  set updateClintDetails(Map<String, dynamic> val){
    ClientDetails=val;

    notifyListeners();
  }


  GetClient(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    try {
      var data = await _api.callMedvanatagePatient7084(context,
          url: "api/Users/GetClient?id=${userRepository.getUser.clientId.toString()}",localStorage: true,
          apiCallType: ApiCallType.get( ));
      print("nnnnnnnnnnnnnn $data");
      if (data["status"] == 1) {
        updateClintDetails=data["responseValue"].isEmpty? {}:data["responseValue"][0];
      } else {

        // Alert.show("Symptoms Added Successfully !");
      }
    } catch (e) {}
  }


  patientParameterSetting(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url: "api/PatientParameterSetting/Get?Pid=${userRepository.getUser.pid.toString()}&ClientId=${userRepository.getUser.clientId.toString()}",localStorage: true,
          apiCallType: ApiCallType.get( ));
      print("nnnnnnnnnnnnnn $data");
      if (data["status"] == 1) {
        updateClintDetails=data["responseValue"].isEmpty? {}:data["responseValue"][0];
      } else {

        // Alert.show("Symptoms Added Successfully !");
      }
    } catch (e) {}
  }


  List bannerList = [];

  List get getNewBannerList => bannerList;

  set updateBannerList(List val) {
    bannerList = val;
    notifyListeners();
  }

  bannerImg(context) async {
    try {
      var data = await _api.callMedvanatagePatient(context,
          url: "api/AppBanner/GetImagesForAppBanner",localStorage: true,
          apiCallType: ApiCallType.get());
      print("nnnnnnnnnnnnnn $data");
      if (data["status"] == 1) {
        updateBannerList = data['responseValue'];
      } else {
        // Alert.show("Symptoms Added Successfully !");
      }
    } catch (e) {}
  }

  callTiming(){

    String morningTime='';
    var currentDate=(DateFormat('yyyy-MM-dd').format(DateTime.now())).toString();

    morningTime=(DateTime.parse('${currentDate} 23:00:00').difference(DateTime.now()).inMinutes).toString();
    print('nnnnvnnnvnnnv '+morningTime.toString());
    return morningTime;
  }
}