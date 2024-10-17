import 'package:flutter/cupertino.dart';



import '../Modal/home_iso_request_data_modal.dart';
import '../all_api.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_call.dart';
import '../app_manager/api/api_response.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class HomeIsolationRequestListViewModal extends ChangeNotifier{
  final Api api=Api();
  // List<HomeIsolationRequestDataModal> get getHomeIsoPatientList=> getHomeIsoResponse.data ??[];
  // ApiResponse homeIsoResponse=ApiResponse.initial("initial");
  // ApiResponse get getHomeIsoResponse=>homeIsoResponse;
  // set updateHomeIsoResponse(ApiResponse val){
  //   homeIsoResponse=val;
  //   print("wwwwwwwwww${homeIsoResponse.data}");
  //   print(getHomeIsoPatientList.length);
  //   notifyListeners();
  // }
  //
  // homeIsoPatientRequestData(context)async{
  //   UserRepository userRepository = Provider.of<UserRepository>( context, listen: false);
  //   updateHomeIsoResponse = ApiResponse.loading("loading data.....");
  //   try {
  //     var data = await api.call(context,
  //         url: AllApi.homeIsolationRequestList,
  //         isHISrHeader: true,
  //          localStorage: true,
  //
  //         apiCallType: ApiCallType.rawPost(body: {
  //           "memberId":userRepository.getUser.uhID.toString()
  //         }));
  //     if (data['responseCode'] == 1) {
  //       print("kkkkkkkkkkkkkkkk"+data['responseValue']);
  //       homeIsoResponse.data = (List<HomeIsolationRequestDataModal>.from(((data['responseValue'] ?? []) as List).map((e)
  //       => HomeIsolationRequestDataModal.fromJson(e))));
  //
  //       updateHomeIsoResponse = ApiResponse<List<HomeIsolationRequestDataModal>>.completed(
  //           getHomeIsoResponse.data ?? []);
  //
  //       if (data['responseValue'].isEmpty) {
  //         updateHomeIsoResponse = ApiResponse.empty("Address not available");
  //       }
  //       else {}
  //     }
  //     else {
  //       updateHomeIsoResponse = ApiResponse.empty("Address not available");
  //       Alert.show(data['message']);
  //     }
  //   }
  //   catch (e) {
  //     updateHomeIsoResponse = ApiResponse.error(e.toString());
  //   }}
  //

  List<HomeIsolationRequestDataModal>get getIsoPatientList=>getHomeIsoResponse.data??[];
  ApiResponse homeIsoResponse=ApiResponse.initial("initial");
  ApiResponse get getHomeIsoResponse=>homeIsoResponse;
  set updateHomeIsoResponse(ApiResponse val){
    homeIsoResponse=val;
    notifyListeners();
  }


  homeIsolatePatientData(context)async{
    UserRepository userRepository = Provider.of<UserRepository>( context, listen: false);
    updateHomeIsoResponse=ApiResponse.loading("loading Data");
    try{
      var data=await api.call(context,
          url: AllApi.homeIsolationRequestList,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {
            "memberId":userRepository.getUser.uhID.toString()
          }));
       if(data['responseCode']==1){
         homeIsoResponse.data = (List<HomeIsolationRequestDataModal>.from(
             ((data['responseValue'] ?? []) as List)
                 .map((e) => HomeIsolationRequestDataModal.fromJson(e))));
         updateHomeIsoResponse=ApiResponse<List<HomeIsolationRequestDataModal>>.completed(getHomeIsoResponse.data??[]);
         if(data['responseValue'].isEmpty){
           updateHomeIsoResponse=ApiResponse.empty("Address not availble");
         }
         else{}
       }
    }
        catch(e){}
  }

}