import 'package:medvantage_patient/View/Pages/upload_report_view.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/services/firebase_service/fireBaseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../ViewModal/medicine_reminder_view_moda.dart';
import '../app_manager/app_color.dart';
import '../assets.dart';
import '../common_libs.dart';
import '../main.dart';

class NotificationService {
  // instance of flutternotification plugin
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        defaultPresentSound: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentBanner: true,
        defaultPresentList: true,
        requestSoundPermission: true,
        requestCriticalPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);



    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
         dPrint("Animeshhshs ${notificationResponse.payload}");
         onNotificationNavi(notificationResponse.payload.toString());
            });
  }

  final DarwinNotificationDetails _iOSPlatformChannelSpecifics =
      const DarwinNotificationDetails(presentAlert: true, presentSound: true
      ,presentBadge: true,presentBanner: true,presentList: true,
        sound:"bellicon.wav"
      );

  final AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    "default_notification_channel_id",
    'default_notification_channel_name',
    icon: '@mipmap/ic_launcher',
    color: Colors.white,
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('myringtone'),
  );

  notificationDetails() {
    return NotificationDetails(
        android: androidNotificationDetails, iOS: _iOSPlatformChannelSpecifics);
  }

  //1st create method of show notification//
  showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    dPrint('nnnnnnnnnnnnvvvvvvvvvvvv ');
    // showNotificationPanel(
    //   ["New message received", "Your download is complete", "Don't miss our update!"],
    // );
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  //...create for select time for sehedule notification.....//

  scheduleNotification(
      {required int id,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }




  cancelNotification({
    required int id,
  }) {
    return notificationsPlugin.cancel(id);
  }
}
