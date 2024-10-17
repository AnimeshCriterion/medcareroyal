

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../app_manager/updater.dart';

class App {
  api(url, body, context, {
    bool? token,
    String? newBaseUrl,
    String? basicAuth,
    // String? newToken,
    Map<String, String>? newHeader,
  }) async {
    try {
      String myUrl = (newBaseUrl == null
          ? ('http://172.16.61.6:201/api/' + url).toString()
          : (newBaseUrl + url).toString());
      // String myToken=(newToken==null?  user.getUserToken.toString():onDutyToken.toString());
      Map<String, String> myHeader = newHeader ?? {
        'accessToken':'',
        'userID': '1234567',
        'authorization': basicAuth ?? ""
      };


      if (basicAuth == null) {
        myHeader.remove("authorization");
      }


      print(myUrl);
      print(body.toString());
      print(myHeader.toString());
      if (token == true) {
        print(myHeader.toString());
      }


      var response = (token ?? false) ? await http.post(
          Uri.parse(myUrl),
          headers: myHeader,
          // newHeader.isEmpty? {
          //    'accessToken':  myToken.toString(),
          //    'userID': user.getUserId.toString(),
          //  }:newHeader,
          body: body
      ) : await http.post(

          Uri.parse(myUrl),
          body: body
      );

      print('fffffffffffdfgdfgdfg');

      log(response.body.toString());
      //log("dfffffffffffffffffffffff"+response.body.toString()+' dsddsfsdf');
      print(
          "dfffffffffffffffffffffff" + response.body.toString() + ' dsddsfsdf');
      var data = await json.decode(response.body);


      if (data is String) {
        // if (data == 'You are logged out, please login again !!' ||
        //     data == 'Unauthorised User') {
        //   Navigator.popUntil(context, ModalRoute.withName('/RMDView'));
        //   await user.removeUserData();
        //   replaceNavigate(context, const LoginPageView());
        //   alertToast(context, data.toString());
        //   return cancelResponse;
        // }
        // else {
        //   var newData = {
        //     'status': 0,
        //     'message': data,
        //   };
        //   print(newData.toString());
        //   return newData;
        // }

        // return newData;
      }
      else {
        if (data is List) {
          Map newMap = {};

          newMap['data'] = data;

          data = newMap;
        }
        data['responseCode'] = response.statusCode;
        //  print(data.toString());
        if (data['status'] == 0 && (data['message'] == 'Invalid Token' ||
            data['message'] == 'Unauthorised User')) {
          print('tttttttttttttt');
          // Navigator.popUntil(context, ModalRoute.withName('/RMDView'));
          // await user.removeUserData();
          // replaceNavigate(context, LoginPageView());
          // alertToast(context, data['message']);
        }
        else {
          print('dddddddddddd');
          return data;
        }
      }

      // if(data is List){
      //   return data[0];
      // }
      // else{
      //   return data;
      // }

    }
    on SocketException {
      print('No Internet connection');
      var retry = await apiDialogue(
        context, 'Alert', 'Internet connection issue, try to reconnect.',
      );
      if (retry) {
        var data = await api(url, body, context,
            token: token);
        return data;
      }
      else {
        return {
          'status': 0,
          'message': '',
        };
      }
    }
    // on TimeoutException catch (e) {
    //   print('Time Out ' + e.toString());
    //   var retry = await apiDialogue(
    //     context, 'Alert', 'Time Out, plz check your connection.',
    //   );
    //   if (retry) {
    //     var data = await api(url, body, context,
    //       token: token,);
    //     return data;
    //   }
    //   else {
    //     return cancelResponse;
    //   }
    // }
    // catch (e) {
    //   print('Error in Api: $e');
    //   var retry = await apiDialogue(
    //     context, 'Alert', 'Some Error Occur, plz check your connection.',
    //   );
    //   if (retry) {
    //     var data = await api(url, body, context,
    //         token: token);
    //     return data;
    //   }
    //   else {
    //     return cancelResponse;
    //   }
    // }
  }


}