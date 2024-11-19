

import '../../ViewModal/dashboard_view_modal.dart';

class ApiUtil {




   static const String baseUrl = "http://52.172.134.222:205/api/v1.0/";


   // api.medcareroyal.medvantage.tech
   // apimedcareroyal.medvantage.tech
   // https://demo.medvantage.tech/
  //   late String baseUrlMedvanatge = "https://apimedcareroyal.medvantage.tech:7080/";
  // late String baseUrlMedvanatge7084 = "https://apimedcareroyal.medvantage.tech:7084/";
  // late String baseUrlMedvanatge7082 = "https://apimedcareroyal.medvantage.tech:7082/";
  // late String baseUrlMedvanatge7096 = "https://apimedcareroyal.medvantage.tech:7096/";
  // late String baseUrlMedvanatge7100 = "https://apimedcareroyal.medvantage.tech:7100/";
  // late String baseUrlMedvanatge7083 = "https://apimedcareroyal.medvantage.tech:7083/";
   late String voiceAssistance = "http://food.shopright.ai:3478/api/echo/";


   //without http
    late String baseUrlMedvanatge = "http://demo.medvantage.tech:1080/";
    late String baseUrlMedvanatge7084 = "http://demo.medvantage.tech:1084/";
    late String baseUrlMedvanatge7082 = "http://demo.medvantage.tech:1082/";
    late String baseUrlMedvanatge7096 = "http://demo.medvantage.tech:1096/";
    late String baseUrlMedvanatge7100 = "http://demo.medvantage.tech:1100/";
    late String baseUrlMedvanatge7083 = "http://demo.medvantage.tech:1083/";

   //
   // late String baseUrlMedvanatge = "https://demo.medvantage.tech:7080/";
   // late String baseUrlMedvanatge7084 = "https://demo.medvantage.tech:7084/";
   // late String baseUrlMedvanatge7082 = "https://demo.medvantage.tech:7082/";
   // late String baseUrlMedvanatge7096 = "https://demo.medvantage.tech:7096/";
   // late String baseUrlMedvanatge7100 = "https://demo.medvantage.tech:7100/";
   // late String baseUrlMedvanatge7083 = "https://demo.medvantage.tech:7083/";

   // //
 //   late  String baseUrlMedvanatge = "http://172.16.61.31:7080/";
 //   late  String baseUrlMedvanatge7084 = "http://172.16.61.31:7084/";
 //   late  String baseUrlMedvanatge7082 = "http://172.16.61.31:7082/";
 //   late  String baseUrlMedvanatge7096 = "http://172.16.61.31:7096/";
 //   late  String baseUrlMedvanatge7100 = "http://172.16.61.31:7100/";
 // late String baseUrlMedvanatge7083 = "http://172.16.61.31:7083/";

  // static const String baseUrl='http://182.156.200.178:8085/api/v1.0/';
  static const String supplementUrl='http://52.172.134.222:204/';
  static const String kiosUrl='http://182.156.200.178:192/Services/patientProblem.asmx/';
  static const String knowmedBaseUrl='http://182.156.200.179:332/api/v1.0/Knowmed/';
  static const String hisBaseUrl='http://182.156.200.179:201/API/';



  static const Map cancelResponse={'responseCode': 0, 'message': 'Try Again...'};
  static const String imageBase = baseUrl;
}