import 'package:flutter/material.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';

import '../Localization/app_localization.dart';
import '../all_api.dart';
import '../app_manager/api/api_call.dart';
import '../assets.dart';
import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class FeedbackViewModal extends ChangeNotifier{
  final Api _api = Api();
  TextEditingController emailC=TextEditingController();
  TextEditingController feedbackC=TextEditingController();

  List EmojiList=[
    {"id":1,
    "emoji":ImagePaths.cryEmoji.toString()
    },
    {"id":2,
      "emoji":ImagePaths.sadEmoji.toString()
    },
    {"id":3,
      "emoji":ImagePaths.happyEmoji.toString()
    },
    {"id":4,
      "emoji":ImagePaths.laughEmoji.toString()
    },
    {"id":5,
      "emoji":ImagePaths.favEmoji.toString()
    }
  ];
  int selectedId=0;
  int get getSelectedId=>selectedId;
  set updateSelectedId(int val){
    selectedId=val;
    notifyListeners();
  }


   saveFeedbackData(context)async{
     ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
     UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
   // try{
  var data=await _api.callMedvanatagePatient(context,
      url:AllApi.saveFeedBackData,
      apiCallType:ApiCallType.post(body: {

        "uhid":userRepository.getUser.uhID.toString(),
        "email": emailC.text.toString(),
        "rating": getSelectedId.toString(),
        "moduleId": getModuleId.toString(),
        "feedback": feedbackC.text.toString(),
      }

      ),
    localStorage: true
  );

    ProgressDialogue().hide();
  if(data["responseCode"]==1){
    clearData();
  }
  else{

  }

  dPrint("kkkkkkkkkkkkk"+data.toString());
      // }
      // catch(e){}
   }

   ///get all status//typemodule///////////
  int moduleid=0;
  int get getModuleId=>moduleid;
  set updateModuleId(int val){
    moduleid=val;
    notifyListeners();

  }

  List moduleList=[];
  List get getAllStatusData=>moduleList;
  set updateAllStatusData(List val){
    moduleList=val;
    notifyListeners();
  }

   getAllStatus(context) async {
    var data=await _api.callMedvanatagePatient(context,
        url: AllApi.getAllStatus+ "typeModule=feedback" ,
        apiCallType: ApiCallType.get(),
        newBaseUrl: "http://172.16.61.31:7082/",
        localStorage: true
    );
    dPrint("tttttttttttttttttttt"+data.toString());
         updateAllStatusData=data["responseValue"];
   }

   clearData(){
    List temp=[];
    temp=getAllStatusData;

    updateAllStatusData=[];
    Future.delayed(Duration(milliseconds: 500)).then((value) =>  updateAllStatusData=temp);

    updateModuleId=0;
     emailC.clear();
     feedbackC.clear();
     selectedId=0;
     notifyListeners();

   }}




