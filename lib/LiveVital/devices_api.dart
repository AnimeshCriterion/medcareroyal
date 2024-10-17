

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_manager/api/api_util.dart';
import '../app_manager/app_color.dart';
import '../app_manager/theme/text_theme.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class RawData{

  var cancelResponse = {'status': 0, 'message': 'Try Again...'};


  api(url,var body,context,{
    bool? token,
    bool? isNewBaseUrl,
    String? newBaseUrl,
    String? newToken,
    bool showRetry=true
  })
  async {
    try{

      UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
      var fullUrl= ApiUtil.baseUrl+url;



      var myHeader=newToken==null? {
        'x-access-token': userRepository.getUser.patientName.toString(),
        'userID': userRepository.getUser.uhID.toString()
      }:{ 'Authorization': newToken??"",
        'x-access-token':userRepository.getUser.patientName.toString(),
        'userID':userRepository.getUser.uhID.toString()
      };
      var response = !(token??   false)?  await Dio().post(fullUrl,
        data: body,
        options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }
        ),
      ):
      await Dio().post(fullUrl,
        data: body,
        options: Options(
            headers:myHeader
        ),
      );
      var data = await jsonDecode(response.toString());
      if (kDebugMode) {
        // log('**data***$data');
      }
      if(data is List){
        return data[0];
      }
      else{
        return data;
      }

    }
    on SocketException {
      print('No Internet connection');
      if(showRetry){
        var retry=await apiDialogue(context, 'Alert  !!!', 'Internet connection issue, try to reconnect.',
        );
        if(retry){
          var data= await api(url,body,context,
              token: token);
          return data;
        }
        else{
          return cancelResponse;
        }
      }

    }

  }




  getapi(url,context,{
    bool? token,
    bool? isNewBaseUrl,
    String? newBaseUrl,
    bool showRetry=true
  })
  async {
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    // print('**********************');
    //   print(data);
    //  print("*********************i");
    try{
      //Map<String, String> headerC;
      // var formData = FormData.fromMap(body);
      var fullUrl=ApiUtil.baseUrl+url;
      //  print('bodyyyyyyyyy:  '+body.toString());
      print('baseurl:  '+fullUrl.toString());
      // print('userId:  '+user.getUserId.toString());

      var response = !(token??   false)?  await Dio().get(fullUrl,
        options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }
        ),
      ):
      await Dio().get(fullUrl,
        options: Options(
            headers: {
              'x-access-token':userRepository.getUser.uhID.toString(),
              //'token':  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IlN0dWRlbnQyMDIyIiwibmFtZWlkIjoiNCIsInJvbGUiOiI3IiwicHJpbWFyeXNpZCI6IjkiLCJuYmYiOjE2NTUxOTI4MzIsImV4cCI6MTY1NTE5NjQzMiwiaWF0IjoxNjU1MTkyODMyfQ.g4U-naBHpQnRKyagGfj_PTCNn1aJPR0Qst2Bjbw2jns",
              // 'userID': user.getUserId.toString()
            }
        ),
      );

      var data = await jsonDecode(response.toString());
      print(data);
      if(data is List){
        return data[0];
      }
      else{
        return data;
      }



    }
    on SocketException {
      print('No Internet connection');
      if(showRetry){
        var retry=await apiDialogue(context, 'Alert  !!!', 'Internet connection issue, try to reconnect.',
        );
        if(retry){
          var data= await getapi(url,context,
              token: token);
          return data;
        }
        else{
          return cancelResponse;
        }
      }

    }

  }






  apiDialogue(context, alert, msg, {bool? showCanCelButton}) {
    var canPressOk = true;
    var retry = false;
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return StatefulBuilder(builder: (context, setState) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            child: Lottie.asset('assets/noInterNet.json'),
                          ),
                          Text(msg.toString(),
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumWCB),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Visibility(
                                visible: showCanCelButton ?? true,
                                child: Expanded(
                                    flex: 2,
                                    child: PrimaryButton(
                                        color: AppColor.grey,
                                        onPressed: () {
                                          if (canPressOk) {
                                            canPressOk = false;
                                             Get.back();
                                            retry = false;
                                          }
                                        },
                                        title: 'Cancel')),
                              ),
                              Visibility(
                                visible: showCanCelButton ?? true,
                                child: const Expanded(child: SizedBox()),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: PrimaryButton(
                                      onPressed: () {
                                        if (canPressOk) {
                                          canPressOk = false;
                                           Get.back();
                                          retry = true;
                                        }
                                      },
                                      title: 'Retry')),
                              const Expanded(child: SizedBox()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }).then((val) {
      canPressOk = false;
      return retry;
    });
  }
}
