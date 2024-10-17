import 'dart:convert';
import 'package:medvantage_patient/services/local_notification_services.dart';
import 'package:flutter/cupertino.dart';
import '../Modal/medicine_reminder_data_modal.dart';
import '../all_api.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_call.dart';
import '../app_manager/api/api_response.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class MedicineReminderViewModal extends ChangeNotifier{

TextEditingController dateC=TextEditingController();

List<MedicineReminderDataModal>get  getMedicineList=>getMedicineResponse.data??[];
ApiResponse medicineResponse=ApiResponse.initial("initial");
ApiResponse get getMedicineResponse=>medicineResponse;
set updateMedicineResponse(ApiResponse val){
  medicineResponse=val;
  notifyListeners();
}

final Api _api=Api();
   getMedicineReminderList(context)async{
     updateMedicineResponse=ApiResponse.loading("Loading Data...");

     UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
     try{
       var data=await _api.call(
           context,
           url: AllApi.getMedicineReminder,
           localStorage: true,
           apiCallType:ApiCallType.rawPost(body: {
              "memberId":userRepository.getUser.uhID.toString()
           }));
       if(data['responseCode']==1){
         medicineResponse.data=(List<MedicineReminderDataModal>.from(((data['responseValue']??[])as List).map((e)=>MedicineReminderDataModal.fromJson(e))));
         updateMedicineResponse=ApiResponse<List<MedicineReminderDataModal>>.completed(getMedicineResponse.data??[]);
         if (data['responseValue'].isEmpty) {
           updateMedicineResponse = ApiResponse.empty("Address not available");
         }
         else {}}
       else {
         updateMedicineResponse = ApiResponse.empty("Address not available");
         Alert.show(data['message']);
       }

     }

     catch(e){
       updateMedicineResponse=ApiResponse.error(e.toString());
     }
   }


   storeDateTimeData({mid,time,midName,dosageName})async{

     List reminderData=[];

    var data=await getDateTimeData();

    print('nnnnnnnnnnnnnnnnnnnn $data');

     reminderData=data??[];
     print("mmmmmmmmm"+data.toString());

     reminderData.add({'mid':mid,'time':time.toString()});

     final SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.setString('reminder',jsonEncode(reminderData));
        getDateTimeData();

     NotificationService().scheduleNotification(

         title: "its medicine Time",body: "medicine: ${midName.toString()}\n(${dosageName.toString()})",
         id: mid,scheduleNotificationDateTime:DateTime.parse(time));
     // AwesomeNotifications().createNotification(
     //     content: NotificationContent(title:"its medicine Time" ,
     //         body:"medicine: ${midName.toString()}\n(${dosageName.toString()})",
     //         id: mid, channelKey: 'Basic',),
     //         schedule: NotificationCalendar(weekday: DateTime.monthsPerYear,)
     // );

        notifyListeners();
   }

   List reminderDateAndTime=[];
   List get getReminderDateTime=>reminderDateAndTime;
   set updateReminderDateTime(List val){
     reminderDateAndTime=val;
   }

   getDateTimeData()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String? reminderTime = prefs.getString('reminder');
    print(reminderTime);
     var data=jsonDecode(reminderTime??"[]");
     updateReminderDateTime=data;
     print(reminderTime);
     return data;
   }

   onPressedRemove(mId, time) async {
     print(mId);
     print(time);
     reminderDateAndTime.removeWhere((element) =>(element['mid'].toString().trim()==mId.toString().trim() && element['time'].toString().trim()==time.toString().trim()));
     print(reminderDateAndTime);
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString('reminder',jsonEncode(reminderDateAndTime));
     getDateTimeData();
    NotificationService().cancelNotification(id: int.parse(mId));
     notifyListeners();
   }}
