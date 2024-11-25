

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/Pages/storage_data.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_util.dart';
import 'package:medvantage_patient/app_manager/api/error_alert.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:medvantage_patient/app_manager/local_storage/local_storage.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:provider/provider.dart';

import '../../encyption.dart';




enum ApiType{
  get,
  post,
  rawPost,
  rawPut,
  multiPartRequest,
  delete,
}



class ApiCallType {
  Map? body;
  String? fileParameter;
  String? filePath;
  ApiType apiType;

  ApiCallType.get() : apiType = ApiType.get;

  ApiCallType.post({required this.body}) : apiType = ApiType.post;
  ApiCallType.delete({required this.body}) : apiType = ApiType.delete;
  ApiCallType.rawPost({required this.body}) : apiType = ApiType.rawPost;
  ApiCallType.rawPut({required this.body}) : apiType = ApiType.rawPut;
  ApiCallType.multiPartRequest({required this.filePath, required this.fileParameter, required this.body,
  }) : apiType = ApiType.multiPartRequest;}



class Api {


  final LocalStorage _localStorage=LocalStorage();


  Future<dynamic> call(context, {
    required String url,
    required ApiCallType apiCallType,
    bool showRetryEvent = false,
    bool token = false,
    bool isSavedApi =false,

    String? newBaseUrl,
    bool localStorage=false,
    bool isHISrHeader=false,
    Map<String, String>? loginHeader,
    ValueChanged? onFoundStoredData
  }) async {

      String username = 'H!\$\$erV!Ce';
      String password = '0785C700-B96C-44DA-A3A7-AD76C58A9FBC';

      UserRepository userRepository =
          Provider.of<UserRepository>(context, listen: false);

      // String myUrl = (newBaseUrl ?? userRepository.getAppDetails.appBaseUrl.toString()) + url;
      String myUrl = (newBaseUrl ?? ApiUtil.baseUrl) + url;

      dPrint("myUrl: $myUrl");
      String encryptedData=await EncryptDecrypt.encryptString(myUrl.split('?')[1].toString(),EncryptDecrypt.key);
      String encriptedUrl= myUrl.contains('?')? encryptedData: myUrl.split('?')[1].toString();
      myUrl=myUrl.split('?')[0]+'?'+encriptedUrl;
      dPrint("myUrl: $myUrl");



      String accessToken = userRepository.getUser.patientName.toString();
      String userId = userRepository.getUser.uhID.toString();
      Map body = apiCallType.body ?? {};

      var basicAuth =
          'Bearer ${base64Encode(utf8.encode('$username:$password'))}';

      // Map<String, String>? header = token
      //     ? {
      //         'x-access-token': accessToken.toString(),
      //         'userID': userId.toString(),
      //       }
      //     : isHISrHeader
      //         ? {'authorization': basicAuth}
      //         : null;
      // if (apiCallType.apiType == ApiType.rawPost) {
      //   header = header ?? {};
      //   header.addAll({'Content-Type': 'application/json'});
      // }

      Map<String, String>? header =loginHeader??  {
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      };
      if (onFoundStoredData != null) {
        var storedData = (await _localStorage.fetchData(key: url));
        if (storedData != null) {
          onFoundStoredData(storedData);
        }
      }

      http.Response? response;
      http.StreamedResponse? streamResponse;
      // if (kDebugMode) {
        dPrint("Api call at ${DateTime.now()}");
        dPrint("Type: ${apiCallType.apiType.name.toString()}");
        if (header != null) {
          dPrint("Header: $header");
        }
        dPrint("URL: $myUrl");
        dPrint("BODY: $body");
      // }


      try {
        switch (apiCallType.apiType) {
          case ApiType.post:
            response =
                await http.post(Uri.parse(myUrl), body: body, headers: header);
            break;

          case ApiType.get:
            response = await http.get(Uri.parse(myUrl), headers: header);
            break;

          case ApiType.rawPost:
            var request = http.Request('POST', Uri.parse(myUrl));
            request.body = json.encode(body);
            request.headers
                .addAll(header ?? {'Content-Type': 'application/json'});
            streamResponse = await request.send();

            break;

          case ApiType.rawPut:
            response = await http.put(Uri.parse(myUrl), body: jsonEncode(body));
            break;

          case ApiType.multiPartRequest:

            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Not implemented".toString()));
            // Alert.show("Not implemented");
            // var request = http.Request('POST', Uri.parse(myUrl));
            // request.body = json.encode(body);
            // request.headers.addAll(header??{
            //   'Content-Type': 'application/json'
            // });
            // streamResponse = await request.send();

            var request = http.MultipartRequest('POST', Uri.parse(myUrl));
            Map<String, String> body = {};
            request.fields.addAll(body);
            String imagePath = apiCallType.filePath.toString();
            String imagePathName = apiCallType.fileParameter.toString();
            request.files.add(
                await http.MultipartFile.fromPath(imagePathName, imagePath));
            request.headers.addAll(header ?? {});
            streamResponse = await request.send();
            break;
          default:
            break;
        }

        if (response != null) {
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: response.body,
          );
          return data;
        } else if (streamResponse != null) {
          var res = await streamResponse.stream.bytesToString();
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: res,
          );
          return data;
        } else {

          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Null response".toString()));
          // Alert.show("Null response");
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }
      } catch (e) {

        if(isSavedApi){
          Map currentData={
            'fullUrl':myUrl,
            'parameters':body,
            'isToken':token,
            'header':header,
            'methodName':apiCallType.apiType.toString(),
            'fileParameter': apiCallType.fileParameter.toString(),
            'filePath':apiCallType.filePath.toString()
          };

          await  InternalStorage().storeData(context,currentData: currentData);
        }


        if (showRetryEvent) {
          var retry = await errorAlert(
            context,
            'Alert',
            e.toString(),
          );
          if (retry) {
            var data = await call(context,
                url: url,
                apiCallType: apiCallType,
                showRetryEvent: showRetryEvent,
                token: token,
                newBaseUrl: newBaseUrl,
                localStorage: localStorage);
            return data;
          } else {
            var storedData = (await _localStorage.fetchData(key: url));
            var errorRes = storedData ?? ApiUtil.cancelResponse;
            return errorRes;
          }
        } else {
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }


      }


  }



  Future<dynamic> callMedvanatagePatient(context, {
    required String url,
    required ApiCallType apiCallType,
    bool showRetryEvent = false,
    bool token = false,
    bool isSavedApi =false,

    String? newBaseUrl,
    bool localStorage=false,
    bool isHISrHeader=false,
    Map<String, String>? loginHeader,
    ValueChanged? onFoundStoredData
  }) async {


      String username = 'H!\$\$erV!Ce';
      String password = '0785C700-B96C-44DA-A3A7-AD76C58A9FBC';


      UserRepository userRepository = Provider.of<UserRepository>(
          context, listen: false);

      // String myUrl = (newBaseUrl ?? userRepository.getAppDetails.appBaseUrl.toString()+'7080/') + url;
      String myUrl = (newBaseUrl ?? ApiUtil().baseUrlMedvanatge) + url;

      dPrint("myUrl: $myUrl");
      String encryptedData=await EncryptDecrypt.encryptString(myUrl.split('?')[1].toString(),EncryptDecrypt.key);
      String encriptedUrl= myUrl.contains('?')? encryptedData: myUrl.split('?')[1].toString();
      myUrl=myUrl.split('?')[0]+'?'+encriptedUrl;
      dPrint("myUrl: $myUrl");



      String accessToken = userRepository.getUser.patientName.toString();
      String userId = userRepository.getUser.uhID.toString();
      Map body = apiCallType.body ?? {};

      var basicAuth = 'Bearer ${base64Encode(
          utf8.encode('$username:$password'))}';


      // Map<String, String>? header = token ? {
      //   'x-access-token': accessToken.toString(),
      //   'userID': userId.toString(),
      // } : isHISrHeader ?
      // {'authorization': basicAuth}
      //     : null;
      // if (apiCallType.apiType == ApiType.rawPost) {
      //   header = header ?? {};
      //   header.addAll({
      //     'Content-Type': 'application/json'
      //   });
      // }


      Map<String, String>? header =loginHeader??  {
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      };

      if (onFoundStoredData != null) {
        var storedData = (await _localStorage.fetchData(key: url));
        if (storedData != null) {
          onFoundStoredData(storedData);
        }
      }

      http.Response? response;
      http.StreamedResponse? streamResponse;
      // if (kDebugMode) {
        dPrint("Api call at ${DateTime.now()}");
        dPrint("Type: ${apiCallType.apiType.name.toString()}");
        if (header != null) {
          dPrint("Header: $header");
        }
        dPrint("URL: $myUrl");
        dPrint("BODY: $body");
      // }

      try {
        switch (apiCallType.apiType) {
          case ApiType.post:
            response = await http.post(
                Uri.parse(myUrl),
                body: body,
                headers: header
            );
            break;

          case ApiType.get:
            response = await http.get(
                Uri.parse(myUrl),
                headers: header
            );
            break;

          case ApiType.rawPost:
            var request = http.Request('POST', Uri.parse(myUrl));
            request.body = json.encode(body);
            request.headers.addAll(header ?? {
              'Content-Type': 'application/json'
            });
            streamResponse = await request.send();


            break;


          case ApiType.multiPartRequest:

            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Not implemented".toString()));
            // Alert.show("Not implemented");
            // var request = http.Request('POST', Uri.parse(myUrl));
            // request.body = json.encode(body);
            // request.headers.addAll(header??{
            //   'Content-Type': 'application/json'
            // });
            // streamResponse = await request.send();


            var request = http.MultipartRequest('POST', Uri.parse(myUrl));
            Map<String, String> body = {};
            request.fields.addAll(body);
            String imagePath = apiCallType.filePath.toString();
            String imagePathName = apiCallType.fileParameter.toString();
            request.files.add(
                await http.MultipartFile.fromPath(imagePathName, imagePath));
            request.headers.addAll(header ?? {});
            streamResponse = await request.send();
            break;
          default:
            break;
        }


        if (response != null) {
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: response.body,
          );




          return data;
        }
        else if (streamResponse != null) {
          var res = await streamResponse.stream.bytesToString();
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: res,

          );
          return data;
        }
        else {
          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Null response".toString()));
          // Alert.show("Null response");
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }
      }
      catch (e) {

        if(isSavedApi){
          Map currentData={
            'fullUrl':myUrl,
            'parameters':body,
            'isToken':token,
            'header':header,
            'methodName':apiCallType.apiType.toString(),
            'fileParameter': apiCallType.fileParameter.toString(),
            'filePath':apiCallType.filePath.toString()
          };

          await  InternalStorage().storeData(context,currentData: currentData);
        }


        if (showRetryEvent) {
          var retry = await errorAlert(context, 'Alert', e.toString(),
          );
          if (retry) {
            var data = await call(context,
                url: url,
                apiCallType: apiCallType,
                showRetryEvent: showRetryEvent,
                token: token,
                newBaseUrl: newBaseUrl,
                localStorage: localStorage
            );
            return data;
          }
          else {
            var storedData = (await _localStorage.fetchData(key: url));
            var errorRes = storedData ?? ApiUtil.cancelResponse;
            return errorRes;
          }
        }
        else {
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }
      }

  }



  Future<dynamic> callMedvanatagePatient7096(context, {
    required String url,
    required ApiCallType apiCallType,
    bool showRetryEvent = false,
    bool token = false,
    bool isSavedApi =false,

    String? newBaseUrl,
    bool localStorage=false,
    bool isHISrHeader=false,
    Map<String, String>? loginHeader,
    ValueChanged? onFoundStoredData
  }) async {


      String username = 'H!\$\$erV!Ce';
      String password = '0785C700-B96C-44DA-A3A7-AD76C58A9FBC';


      UserRepository userRepository = Provider.of<UserRepository>(
          context, listen: false);


      // String myUrl = (newBaseUrl ?? '${userRepository.getAppDetails.appBaseUrl}7096/') + url;
      String myUrl = (newBaseUrl ?? ApiUtil().baseUrlMedvanatge7096) + url;

      dPrint("myUrl: $myUrl");
      String encryptedData=await EncryptDecrypt.encryptString(myUrl.split('?')[1].toString(),EncryptDecrypt.key);
      String encriptedUrl= myUrl.contains('?')? encryptedData: myUrl.split('?')[1].toString();
      myUrl=myUrl.split('?')[0]+'?'+encriptedUrl;
      dPrint("myUrl: $myUrl");



      String accessToken = userRepository.getUser.patientName.toString();
      String userId = userRepository.getUser.uhID.toString();
      Map body = apiCallType.body ?? {};

      var basicAuth = 'Bearer ${base64Encode(
          utf8.encode('$username:$password'))}';


      // Map<String, String>? header = token ? {
      //   'x-access-token': accessToken.toString(),
      //   'userID': userId.toString(),
      // } : isHISrHeader ?
      // {'authorization': basicAuth}
      //     : null;
      // if (apiCallType.apiType == ApiType.rawPost) {
      //   header = header ?? {};
      //   header.addAll({
      //     'Content-Type': 'application/json'
      //   });
      // }


      Map<String, String>? header =loginHeader??  {
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      };

      if (onFoundStoredData != null) {
        var storedData = (await _localStorage.fetchData(key: url));
        if (storedData != null) {
          onFoundStoredData(storedData);
        }
      }

      http.Response? response;
      http.StreamedResponse? streamResponse;
      // if (kDebugMode) {
        dPrint("Api call at ${DateTime.now()}");
        dPrint("Type: ${apiCallType.apiType.name.toString()}");
        if (header != null) {
          dPrint("Header: $header");
        }
        dPrint("URL: $myUrl");
        dPrint("BODY: $body");
      // }


      try {
        switch (apiCallType.apiType) {
          case ApiType.post:
            response = await http.post(
                Uri.parse(myUrl),
                body: body,
                headers: header
            );
            break;

          case ApiType.get:
            response = await http.get(
                Uri.parse(myUrl),
                headers: header
            );
            break;

          case ApiType.rawPost:
            var request = http.Request('POST', Uri.parse(myUrl));
            request.body = json.encode(body);
            request.headers.addAll(header ?? {
              'Content-Type': 'application/json'
            });
            streamResponse = await request.send();


            break;


          case ApiType.multiPartRequest:
            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Not implemented".toString()));
            // Alert.show("Not implemented");
            // var request = http.Request('POST', Uri.parse(myUrl));
            // request.body = json.encode(body);
            // request.headers.addAll(header??{
            //   'Content-Type': 'application/json'
            // });
            // streamResponse = await request.send();


            var request = http.MultipartRequest('POST', Uri.parse(myUrl));
            Map<String, String> body = {};
            request.fields.addAll(body);
            String imagePath = apiCallType.filePath.toString();
            String imagePathName = apiCallType.fileParameter.toString();
            request.files.add(
                await http.MultipartFile.fromPath(imagePathName, imagePath));
            request.headers.addAll(header ?? {});
            streamResponse = await request.send();
            break;
          default:
            break;
        }


        if (response != null) {
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: response.body,

          );
          return data;
        }
        else if (streamResponse != null) {
          var res = await streamResponse.stream.bytesToString();
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: res,

          );
          return data;
        }
        else {
          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Null response".toString()));
          // Alert.show("Null response");
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }
      }
      catch (e) {

        if(isSavedApi){
          Map currentData={
            'fullUrl':myUrl,
            'parameters':body,
            'isToken':token,
            'header':header,
            'methodName':apiCallType.apiType.toString(),
            'fileParameter': apiCallType.fileParameter.toString(),
            'filePath':apiCallType.filePath.toString()
          };
          await  InternalStorage().storeData(context,currentData: currentData);
        }


        if (showRetryEvent) {
          var retry = await errorAlert(context, 'Alert', e.toString(),
          );
          if (retry) {
            var data = await call(context,
                url: url,
                apiCallType: apiCallType,
                showRetryEvent: showRetryEvent,
                token: token,
                newBaseUrl: newBaseUrl,
                localStorage: localStorage
            );
            return data;
          }
          else {
            var storedData = (await _localStorage.fetchData(key: url));
            var errorRes = storedData ?? ApiUtil.cancelResponse;
            return errorRes;
          }
        }
        else {
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }
      }

  }



  Future<dynamic> callMedvanatagePatient7100(context, {
    required String url,
    required ApiCallType apiCallType,
    bool showRetryEvent = false,
    bool token = false,
    bool isSavedApi =false,

    String? newBaseUrl,
    bool localStorage=false,
    bool isHISrHeader=false,
    Map<String, String>? loginHeader,
    ValueChanged? onFoundStoredData
  }) async {


    String username = 'H!\$\$erV!Ce';
    String password = '0785C700-B96C-44DA-A3A7-AD76C58A9FBC';


    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);


    // String myUrl = (newBaseUrl ?? '${userRepository.getAppDetails.appBaseUrl}7100/') + url;
    String myUrl = (newBaseUrl ?? ApiUtil().baseUrlMedvanatge7100) + url;

    dPrint("myUrl: $myUrl");
    String encryptedData=await EncryptDecrypt.encryptString(myUrl.split('?')[1].toString(),EncryptDecrypt.key);
    String encriptedUrl= myUrl.contains('?')? encryptedData: myUrl.split('?')[1].toString();
    myUrl=myUrl.split('?')[0]+'?'+encriptedUrl;
    dPrint("myUrl: $myUrl");




    String accessToken = userRepository.getUser.patientName.toString();
    String userId =userRepository.getUser.uhID.toString();
    Map body = apiCallType.body??{};

    var basicAuth =  'Bearer ${base64Encode(utf8.encode('$username:$password'))}';


    // Map<String,String>? header = token? {
    //   // 'x-access-token': accessToken.toString(),
    //   // 'userID': userId.toString(),
    //   'Content-Type': 'multipart/form-data',
    //   'accept': '*/*'
    // }:isHISrHeader?
    // {'authorization': basicAuth}
    //     :null;
    // if(apiCallType.apiType==ApiType.rawPost){
    //   header=header??{};
    //   header.addAll({
    //     'Content-Type': 'multipart/form-data',
    //     'accept': '*/*'
    //   });
    // }


    Map<String, String>? header =loginHeader??  {
      'Content-Type': 'application/json',
      'Authorization': basicAuth
    };

    if(onFoundStoredData!=null){
      var storedData=(await _localStorage.fetchData(key: url));
      if(storedData!=null){
        onFoundStoredData(storedData);
      }

    }

    http.Response? response;
    http.StreamedResponse? streamResponse;
    // if (kDebugMode) {
      dPrint("Api call at ${DateTime.now()}");
      dPrint("Type: ${apiCallType.apiType.name.toString()}");
      if(header!=null){
        dPrint("Header: $header");
      }
      dPrint("URL: $myUrl");
      dPrint("BODY: $body");
    // }



    try {
      switch (apiCallType.apiType) {
        case ApiType.post:
          response = await http.post(
              Uri.parse(myUrl),
              body: body,
              headers: header
          );
          break;

        case ApiType.get:
          response = await http.get(
              Uri.parse(myUrl),
              headers: header
          );
          break;

        case ApiType.rawPost:


          var request = http.Request('POST', Uri.parse(myUrl));
          request.body = json.encode(body);
          request.headers.addAll(header??{
            'Content-Type': 'multipart/form-data',
            'accept': '*/*'
          });
          streamResponse = await request.send();


          break;


        case ApiType.multiPartRequest:
          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Not implemented".toString()));
          // Alert.show("Not implemented");
          // var request = http.Request('POST', Uri.parse(myUrl));
          // request.body = json.encode(body);
          // request.headers.addAll(header??{
          //   'Content-Type': 'application/json'
          // });
          // streamResponse = await request.send();


          var request = http.MultipartRequest('POST', Uri.parse(myUrl));
          Map<String, String> body = {};
          request.fields.addAll(body);
          String imagePath=apiCallType.filePath.toString();
          String imagePathName=  apiCallType.fileParameter.toString();
          request.files.add(await http.MultipartFile.fromPath(imagePathName,imagePath));
          request.headers.addAll(header??{});
          streamResponse = await request.send();
          break;
        default:
          break;
      }


      if (response != null) {
        var data = await _handleDecodeAndStorage(
          url: url,
          localStorage: localStorage,
          encodeData: response.body,

        );
        return data;
      }
      else if (streamResponse != null) {
        var res = await streamResponse.stream.bytesToString();
        var data = await _handleDecodeAndStorage(
          url: url,
          localStorage: localStorage,
          encodeData: res,

        );
        return data;

      }
      else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Null response".toString()));
        // Alert.show("Null response");
        var storedData=(await _localStorage.fetchData(key: url));
        var errorRes=storedData??ApiUtil.cancelResponse;
        return errorRes;
      }
    }
    catch (e) {
      //
      if(isSavedApi){
        Map currentData={
          'fullUrl':myUrl,
          'parameters':body,
          'isToken':token,
          'header':header,
          'methodName':apiCallType.apiType.toString(),
          'fileParameter': apiCallType.fileParameter.toString(),
          'filePath':apiCallType.filePath.toString()
        };

        await  InternalStorage().storeData(context,currentData: currentData);
      }


      if (showRetryEvent) {
        var retry = await errorAlert(context, 'Alert', e.toString(),
        );
        if (retry) {
          var data = await call(context,
              url: url,
              apiCallType: apiCallType,
              showRetryEvent: showRetryEvent,
              token: token,
              newBaseUrl: newBaseUrl,
              localStorage: localStorage
          );
          return data;
        }
        else {
          var storedData=(await _localStorage.fetchData(key: url));
          var errorRes=storedData??ApiUtil.cancelResponse;
          return errorRes;
        }
      }
      else {
        var storedData=(await _localStorage.fetchData(key: url));
        var errorRes=storedData??ApiUtil.cancelResponse;
        return errorRes;
      }
    }

  }



  Future<dynamic> callMedvanatagePatient7082(context, {
    required String url,
    required ApiCallType apiCallType,
    bool showRetryEvent = false,
    bool token = false,
    bool isSavedApi =false,

    String? newBaseUrl,
    bool localStorage=false,
    bool isHISrHeader=false,
    Map<String, String>? loginHeader,
    ValueChanged? onFoundStoredData
  }) async {

      String username = 'H!\$\$erV!Ce';
      String password = '0785C700-B96C-44DA-A3A7-AD76C58A9FBC';


      UserRepository userRepository = Provider.of<UserRepository>(
          context, listen: false);


      // String myUrl = (newBaseUrl ?? '${userRepository.getAppDetails.appBaseUrl}7082/') + url;
      String myUrl = (newBaseUrl ?? ApiUtil().baseUrlMedvanatge7082) + url;

      dPrint("myUrl: $myUrl");
      String encryptedData=await EncryptDecrypt.encryptString(myUrl.split('?')[1].toString(),EncryptDecrypt.key);
      String encriptedUrl= myUrl.contains('?')? encryptedData: myUrl.split('?')[1].toString();
      myUrl=myUrl.split('?')[0]+'?'+encriptedUrl;
      dPrint("myUrl: $myUrl");



      String accessToken = userRepository.getUser.patientName.toString();
      String userId = userRepository.getUser.patientName.toString();
      Map body = apiCallType.body ?? {};

      // var basicAuth = 'Bearer ${base64Encode(
      //     utf8.encode('$username:$password'))}';

      var basicAuth = 'Bearer ${ userRepository.getUser.token.toString()}';


      // Map<String, String>? header = token ? {
      //   'x-access-token': accessToken.toString(),
      //   'userID': userId.toString(),
      //   'authorization': basicAuth
      // } : isHISrHeader ?
      // {'authorization': basicAuth}
      //     : null;
      // if (apiCallType.apiType == ApiType.rawPost) {
      //   header = header ?? {'authorization': basicAuth};
      //   header.addAll({
      //     'Content-Type': 'application/json',
      //     'authorization': basicAuth
      //   });
      // }

      Map<String, String>? header =loginHeader??  {
        'Content-Type': 'application/json',
        'Authorization': basicAuth
      };

      if (onFoundStoredData != null) {
        var storedData = (await _localStorage.fetchData(key: url));
        if (storedData != null) {
          onFoundStoredData(storedData);
        }
      }

      http.Response? response;
      http.StreamedResponse? streamResponse;
      // if (kDebugMode) {
        dPrint("Api call at ${DateTime.now()}");
        dPrint("Type: ${apiCallType.apiType.name.toString()}");
        if (header != null) {
          dPrint("Header: $header");
        }
        dPrint("URL: $myUrl");
        dPrint("BODY: $body");
      // }

      dPrint("header: $header");
      try {
        switch (apiCallType.apiType) {
          case ApiType.post:
            response = await http.post(
                Uri.parse(myUrl),
                body: body,
                headers: header
            );
            break;

          case ApiType.get:
            response = await http.get(
                Uri.parse(myUrl),
                headers: header
            );
            break;


          case ApiType.delete:
            response = await http.delete(
                Uri.parse(myUrl),
                headers: header
            );
            break;


          case ApiType.rawPut:
            response = await http.put(
                Uri.parse(myUrl),
                body: jsonEncode(body),
                headers: {
                  'Content-Type': 'application/json'
                }
            );
            break;

          case ApiType.rawPost:
            var request = http.Request('POST', Uri.parse(myUrl));
            request.body = json.encode(body);
            request.headers.addAll(header ?? {
              'Content-Type': 'application/json'
            });
            streamResponse = await request.send();


            break;


          case ApiType.multiPartRequest:
            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Not implemented".toString()));
            // Alert.show("Not implemented");


            var request = http.MultipartRequest('POST', Uri.parse(myUrl));
            Map<String, String> body = {};
            request.fields.addAll(body);
            String imagePath = apiCallType.filePath.toString();
            String imagePathName = apiCallType.fileParameter.toString();
            request.files.add(
                await http.MultipartFile.fromPath(imagePathName, imagePath));
            request.headers.addAll(header ?? {});
            streamResponse = await request.send();
            break;
          default:
            break;
        }


        if (response != null) {
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: response.body,

          );
          var decryptData= await EncryptDecrypt.decryptString(data['data'],EncryptDecrypt.key.toString() ) ;
          log("nnnnnnnnnnnn $decryptData");
          return jsonDecode(decryptData);
        }
        else if (streamResponse != null) {
          var res = await streamResponse.stream.bytesToString();
          var data = await _handleDecodeAndStorage(
            url: url,
            localStorage: localStorage,
            encodeData: res,

          );
          return data;
        }
        else {
          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Null response".toString()));
          // Alert.show("Null response");
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }
      }
      catch (e) {

        if(isSavedApi){
          Map currentData={
            'fullUrl':myUrl,
            'parameters':body,
            'isToken':token,
            'header':header,
            'methodName':apiCallType.apiType.toString(),
            'fileParameter': apiCallType.fileParameter.toString(),
            'filePath':apiCallType.filePath.toString()
          };
          await  InternalStorage().storeData(context,currentData: currentData);
        }


        if (showRetryEvent) {
          var retry = await errorAlert(context, 'Alert', e.toString(),
          );

          if (retry) {
            var data = await call(context,
                url: url,
                apiCallType: apiCallType,
                showRetryEvent: showRetryEvent,
                token: token,
                newBaseUrl: newBaseUrl,
                localStorage: localStorage
            );
            return data;
          }
          else {
            var storedData = (await _localStorage.fetchData(key: url));
            var errorRes = storedData ?? ApiUtil.cancelResponse;
            return errorRes;
          }
        }
        else {
          var storedData = (await _localStorage.fetchData(key: url));
          var errorRes = storedData ?? ApiUtil.cancelResponse;
          return errorRes;
        }
      }
  }




  Future<dynamic> callMedvanatagePatient7084(context, {
    required String url,
    required ApiCallType apiCallType,
    bool showRetryEvent = false,
    bool token = false,
    bool isSavedApi =false,

    String? newBaseUrl,
    bool localStorage=false,
    Map<String, String>? loginHeader,
    bool isHISrHeader=false,
    ValueChanged? onFoundStoredData
  }) async {



    String username = 'H!\$\$erV!Ce';
    String password = '0785C700-B96C-44DA-A3A7-AD76C58A9FBC';


    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    // String myUrl = (newBaseUrl ?? '${userRepository.getAppDetails.appBaseUrl}7084/') + url;
    String myUrl = (newBaseUrl ?? ApiUtil().baseUrlMedvanatge7084) + url;


    dPrint("myUrl: $myUrl");
    String encryptedData=await EncryptDecrypt.encryptString(myUrl.split('?')[1].toString(),EncryptDecrypt.key);
    String encriptedUrl= myUrl.contains('?')? encryptedData: myUrl.split('?')[1].toString();
    myUrl=myUrl.split('?')[0]+'?'+encriptedUrl;
    dPrint("myUrl: $myUrl");






    String accessToken = userRepository.getUser.patientName.toString();
    String userId =userRepository.getUser.uhID.toString();
    Map body = apiCallType.body??{};

    var basicAuth =  'Bearer ${base64Encode(utf8.encode('$username:$password'))}';


    // Map<String,String>? header = token? {
    //   'x-access-token': accessToken.toString(),
    //   'userID': userId.toString(),
    // }:isHISrHeader?
    // {'authorization': basicAuth}
    //     :null;
    // if(apiCallType.apiType==ApiType.rawPost){
    //   header=header??{};
    //   header.addAll({
    //     'Content-Type': 'application/json'
    //   });
    // }


    Map<String, String>? header =loginHeader??  {
      'Content-Type': 'application/json',
      'Authorization': basicAuth
    };

    if(onFoundStoredData!=null){
      var storedData=(await _localStorage.fetchData(key: url));
      if(storedData!=null){
        onFoundStoredData(storedData);
      }

    }

    http.Response? response;
    http.StreamedResponse? streamResponse;
    // if (kDebugMode) {
      dPrint("Api call at ${DateTime.now()}");
      dPrint("Type: ${apiCallType.apiType.name.toString()}");
      if(header!=null){
        dPrint("Header: $header");
      }
      dPrint("URL: $myUrl");
      dPrint("BODY: $body");
    // }


    try {
      switch (apiCallType.apiType) {
        case ApiType.post:
          response = await http.post(
              Uri.parse(myUrl),
              body: body,
              headers: header
          );
          break;

        case ApiType.get:
          response = await http.get(
              Uri.parse(myUrl),
              headers: header
          );
          break;

        case ApiType.rawPost:


          var request = http.Request('POST', Uri.parse(myUrl));
          request.body = json.encode(body);
          request.headers.addAll(header??{
            'Content-Type': 'application/json'
          });
          streamResponse = await request.send();


          break;


        case ApiType.multiPartRequest:
          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Not implemented".toString()));
          // Alert.show("Not implemented");
          // var request = http.Request('POST', Uri.parse(myUrl));
          // request.body = json.encode(body);
          // request.headers.addAll(header??{
          //   'Content-Type': 'application/json'
          // });
          // streamResponse = await request.send();


          var request = http.MultipartRequest('POST', Uri.parse(myUrl));
          Map<String, String> body = {};
          request.fields.addAll(body);
          String imagePath=apiCallType.filePath.toString();
          String imagePathName=  apiCallType.fileParameter.toString();
          request.files.add(await http.MultipartFile.fromPath(imagePathName,imagePath));
          request.headers.addAll(header??{});
          streamResponse = await request.send();
          break;
        default:
          break;
      }


      if (response != null) {
        var data = await _handleDecodeAndStorage(
          url: url,
          localStorage: localStorage,
          encodeData: response.body,

        );
        var decryptdata= await EncryptDecrypt.decryptString(data['data'],EncryptDecrypt.key.toString() ) ;

        return  jsonDecode(decryptdata);
      }
      else if (streamResponse != null) {
        var res = await streamResponse.stream.bytesToString();
        var data = await _handleDecodeAndStorage(
          url: url,
          localStorage: localStorage,
          encodeData: res,

        );
        return data;

      }
      else {
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Null response".toString()));
        // Alert.show("Null response");
        var storedData=(await _localStorage.fetchData(key: url));
        var errorRes=storedData??ApiUtil.cancelResponse;
        return errorRes;
      }
    }
    catch (e) {

      if(isSavedApi){
        Map currentData={
          'fullUrl':myUrl,
          'parameters':body,
          'isToken':token,
          'header':header,
          'methodName':apiCallType.apiType.toString(),
          'fileParameter': apiCallType.fileParameter.toString(),
          'filePath':apiCallType.filePath.toString()
        };

        await  InternalStorage().storeData(context,currentData: currentData);
      }


      if (showRetryEvent) {
        var retry = await errorAlert(context, 'Alert', e.toString(),
        );
        if (retry) {
          var data = await call(context,
              url: url,
              apiCallType: apiCallType,
              showRetryEvent: showRetryEvent,
              token: token,
              newBaseUrl: newBaseUrl,
              localStorage: localStorage
          );
          return data;
        }
        else {
          var storedData=(await _localStorage.fetchData(key: url));
          var errorRes=storedData??ApiUtil.cancelResponse;
          return errorRes;
        }
      }
      else {
        var storedData=(await _localStorage.fetchData(key: url));
        var errorRes=storedData??ApiUtil.cancelResponse;
        return errorRes;
      }
    }
  }








  Future<Map> _handleDecodeAndStorage({

  required String url,
  required var encodeData,
  required bool localStorage,
}) async{
    // if (kDebugMode) {
      dPrint("Response: $encodeData\n");
    // }
    try{
      var decodeData=(await json.decode(encodeData));
      if(localStorage){
        _localStorage.storeData(key: url, data: decodeData);
      }
      return decodeData;
    }
    catch(e){
      var storedData=(await _localStorage.fetchData(key: url));
      var errorRes=storedData??ApiUtil.cancelResponse;
      return errorRes;
    }

  }


}