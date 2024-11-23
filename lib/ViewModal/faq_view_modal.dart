
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:provider/provider.dart';

import '../Localization/app_localization.dart';
import '../Modal/faq_data_modal.dart';




class FAQViewModal extends ChangeNotifier{
  final Api _api = Api();
 TextEditingController searchC=TextEditingController();
  var isExpanded = false;
 //  int questionid=0;
 //  int get getQuestionId=>questionid;
 //  set updateQuestionId(int val){
 //    questionid=val;
 // notifyListeners();
 //  }
  List questionid=[];
  List get getQuestionId=>questionid;
  set updateQuestionId(String val){
   if(questionid.contains(val)){
     questionid.remove(val);
   } else{

     questionid.add(val);
   }
    notifyListeners();
  }
  List faqDataList=[];
  List<Answer> get getFaqList=>
  List<Answer>.from((searchC.text==""?faqDataList:faqDataList.where((element) =>
  element["questionName"].toString().toLowerCase().
  contains(searchC.text.toString().toLowerCase())).toList())
      .map((e) => Answer.fromJson(e))).toList() ;
  set updateFaqList(List val){
    faqDataList=val;
    notifyListeners();
  }


 getFAQListData(context)async{
   UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
   ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
   ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
   try{
      var data = await _api.callMedvanatagePatient(context,
          url: AllApi.getFaqList + "setId=9",
          newBaseUrl: "http://172.16.61.31:7080/",
          localStorage: true,
          apiCallType: ApiCallType.get());

      Get.back();
      // dPring("rrrrrrrrrrrrrrrrrr"+data["responseValue"].toString());
      updateFaqList = (data["responseValue"] ?? []).isEmpty
          ? []
          : jsonDecode((data["responseValue"][0]["answers"] ?? "[]"));
    }
    catch(e){
     Get.back();
    }
  }
}