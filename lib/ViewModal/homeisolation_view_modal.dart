

import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Localization/app_localization.dart';
import '../View/Pages/dashboard_view.dart';
import '../View/Pages/master_dashboard_view.dart';
import '../View/Pages/rmd_view.dart';
import '../all_api.dart';
import '../app_manager/bottomSheet/functional_sheet.dart';

class HomeIsolationViewModal extends ChangeNotifier{

  final Api _api =Api();
  TextEditingController nameC= TextEditingController();
  TextEditingController contactC= TextEditingController();
  TextEditingController comorbidC= TextEditingController();
  TextEditingController symptomsC= TextEditingController();
  TextEditingController symptomsdateC= TextEditingController();
  TextEditingController covidtestdateC= TextEditingController();
  TextEditingController allergiesC= TextEditingController();

 List lifeSupportList=[
  {
  'life':'RA',
  'id':1
  },
  {
  'life': 'OT',
  'id':2
  }
  ];
 List homeCarePackageList =[
   {
     'id':1,
     'packageName': 'SmartHeart Failure Revival Package For 7 Days',
     'packagePrice': '5999.0'
   },

   {
     'id':2,
     'packageName': 'SmartHeart Failure Revival App Package For 14 Days',
     'packagePrice': '9999.0'
   },
   {
     'id':3,
     'packageName': 'SmartHeart Failure Revival Package For 14 Days (For 2 Person)',
     'packagePrice': '13999.0'
   },{
     'id':4,
     'packageName': 'Not Sure',
     'packagePrice': '0'
   },
 ];
 //......selectTestTyp............................../
  getTestType(context){
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    return [
      {
        'test':"Rt-PCR",
        'id':1
      },

      {
        'test':"Truenat",
        'id':2
      },

      {
        'test': "Antigen",
        'id':3
      },
    ];
  }


 int lifeSupportId=0;
 int get getLifeSupportId=>lifeSupportId;
 set updateLifeSupportId(int val){
   lifeSupportId=val;
   notifyListeners();
 }
  int testTypeId=0;
 int get getTestTypeId=>testTypeId;
 set updateTestTypeId(int val){
   testTypeId=val;
   notifyListeners();
 }

  int hospitalId=0;
  int get getHospitalId=>hospitalId;
  set updateHospitalId(int val){
    hospitalId=val;
    notifyListeners();
  }

  List hospitalList =[];
  List get getHospitalList => hospitalList;
  set updateHospitalListResponse(List val ){
    hospitalList=val;
notifyListeners();
  }



  int packageId =0;
  int get getPackageId=>packageId;
  set updatePackageId(int val){
    packageId=val;
    notifyListeners();
  }



 // getHospitalListForHomeIsolation(context) async {
 //
 //  try{
 //    var data = await _api.call(context,
 //        url: AllApi.getHospitalListForHomeIsolation,
 //        localStorage: true,
 //        apiCallType: ApiCallType.rawPost(body: {
 //          "id": 62.toString(),
 //          "name": ""
 //        }));
 //    print(data.toString());
 //    if (data['responseCode']==1){
 //     _updateHospitalListResponse=data['responseValue'];
 //    }
 //  } catch (e) {
 //
 //  }
 // }
  String packageName="";
  String get getPackageName=>packageName;
  set updatePackageName(String val){
    packageName=val;
  }

  HospitalListForHomeIsolation(context) async {
   UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
   var data = await _api.call(context,
       url: AllApi.getHospitalListForHomeIsolation,
       localStorage: true,
       apiCallType: ApiCallType.rawPost(body: {
         "id": 62.toString(),
         "name": ""
       }));
   updateHospitalListResponse=data['responseValue'];

  }



  HomeIsolationRequest(context) async {
    UserRepository userRepository = Provider.of<UserRepository>( context, listen: false);
    try{
      var data = await _api.call(context,
          url: AllApi.getHomeIsolationRequest,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {
            "memberId":userRepository.getUser.uhID.toString(),
            "hospitalId": getHospitalId.toString(),
            "comorbidities": comorbidC.text.toString(),
            "currentProblem": symptomsC.text.toString(),
            "packageId":  getPackageId.toString(),
            "testdate":covidtestdateC.text.toString(),
            "allergires":allergiesC.text.toString(),
            "lifeSupport":  getLifeSupportId.toString(),
            "o2":"",
            "onSetDate":  symptomsdateC.text.toString(),
            "testTypes": getTestTypeId.toString(),
            "dtDataTable": ""
          })) ;
      if(data["responseCode"]==1){
        MyNavigator.push(context, RMDView());
      }
    }
        catch(e){
    }
  }


  onPressedContinue(context)async{
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    await CustomBottomSheet.open(context,child:
        FunctionalSheet(message: localization.getLocaleData.areUSureUWantToContinue.toString(),
          buttonName: localization.getLocaleData.continueText.toString(),
          cancelBtn: localization.getLocaleData.cancel.toString(),
          onPressButton: ()async{
          await HomeIsolationRequest(context);
        },)

    );

  }
}