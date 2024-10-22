


import 'dart:convert';

import 'package:medvantage_patient/View/Pages/addvital_view.dart';
import 'package:medvantage_patient/View/Pages/prescription_checklist.dart';
import 'package:medvantage_patient/View/Pages/supplement_intake_view.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medvantage_patient/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../View/Pages/chat_view.dart';
import '../../View/Pages/food_intake.dart';
import '../../View/Pages/water_intake_view.dart';
import '../local_notification_services.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';


final _firebaseMessaging = FirebaseMessaging.instance;
// final flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
   NotificationService().showNotification(id: 0,
       title: message.notification!.title,
       body: message.notification!.body ,
       payload: jsonEncode(message.data));
   print('Handling a background message ${message.messageId}');

}

final BuildContext? _context=NavigationService.navigatorKey.currentContext;

class FireBaseService{


  connect() async{
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('Initial Message'+message!.data.toString());

      if(message!=null){
        if(message.notification!=null){
          Future.delayed(const Duration(
            seconds: 4,
          )).then((value) async {
            onNotificationNavi(message.data);
          });

        }
      }

    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage? message) async{

      print('onBackgroundMessage');
      print('ON Message$message');
      print('Message data: ${message!.data}');
      NotificationService().showNotification(id: 0,
          title: message.notification!.title,
          body: message.notification!.body ,
          payload: jsonEncode(message.data));


    }



    );
    // await FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {


print('onMessageonMessage ${message!.data }');
print('onMessageonMessage ${message!. notification!.title  }');
print('onMessageonMessage ${message!. notification!.body  }');
print('onMessageonMessage ${message!.data }');

      NotificationService().initNotification();
      NotificationService().showNotification(id: 0,
          title: message.notification!.title,
          body: message.notification!.body ,
      payload: jsonEncode(message.data));

    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the open!');
      print('Message data: ${message.data['type'].toString()}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title}');
        print('Message also contained a notification: ${message.notification!.body}');
        onNotificationNavi(message.data);
      }


    });

  }




 getToken() async{
    var data= await _firebaseMessaging.getToken();
    return data;
  }

}


onNotificationNavi(val){

  switch(val['type'].toString()){

    case 'Food':
      Get.to(()=>const FoodIntakeView());
      break;
    case 'Fluid':
      Get.to(()=>const SliderVerticalWidget());
      break;
    case 'Vital':
      Get.to(()=>const AddVitalView());
      break;
    case 'Supplement':
      Get.to(()=>const SupplementIntakeView());
      break;
    case 'Medicine':
      Get.to(()=>const PrescriptionCheckListView());
      break;
    case 'Chat':
      Get.to(()=>const ChatView());
      break;
  }
}
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();
//   //
//   // print("Handling a background message: ${message.messageId}");
// }







// void handleIncomingCallForeGround(
//
// {
//   required RemoteMessage event,
// }
//     ){
//
//
//   CallStatusController callStatusC=Get.put(CallStatusController());
//
//
//
//   RemoteNotification?  callNotification= event.notification;
//
//   print('thissssss Here '+ callNotification!.title.toString());
//   print('thissssss Here '+ (callNotification.title.toString()=='Call').toString());
//   if(callNotification.title.toString()=='Incoming Call'){
//     callStatusC.updateCurrentCall=MyCall.initiated;
//
//     if((DateTime.parse(event.data['time']).add(const Duration(seconds: 30))).isAfter(DateTime.now())){
//
//
//       print(event.data);
//
//       App().navigate(_context, IncomingCallScreen(
//         callerName: event.data['callerName'].toString(),
//         deviceToken: event.data['deviceToken'].toString(),
//         callerUserId: event.data['callerUserId'].toString(),
//         isAudioCall: event.data['isAudioCall'].toString()=='true',
//         roomName: event.data['roomName'],
//         patientName: event.data['patientName'],
//
//       ));
//     }
//     else {
//       alertToast(_context, 'Missed this Call');
//     }
//
//
//
//
//
//
//   }
//   else if(callNotification.title.toString()=='Call Drop'){
//     callStatusC.updateCurrentCall=MyCall.drop;
//     alertToast(NavigationService.navigatorKey.currentContext,event.notification!.body.toString() );
//     JitsiMeet.closeMeeting();
//
//   }  else if(callNotification.title.toString()=='Call Cut'){
//     callStatusC.updateCurrentCall=MyCall.cut;
//
//   }else if(callNotification.title.toString()=='Missed Call'){
//     callStatusC.updateCurrentCall=MyCall.missed;
//
//   }
//   else if(callNotification.title.toString()=='Call PickedUp'){
//     callStatusC.updateCurrentCall=MyCall.confirmed;
//
//   }
//
//
// }

