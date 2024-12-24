

import 'package:medvantage_patient/Modal/symptoms_problem_data_modal.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/ViewModal/consultdoctor_view_modal.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/api/api_response.dart';
import 'package:medvantage_patient/assets.dart';
import 'package:flutter/cupertino.dart';

import '../Localization/app_localization.dart';
import '../Modal/organ_system_data_modal.dart';
import '../Modal/selected_symptoms.dart';
import '../View/widget/slected_organ_problem_dialog.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_util.dart';
import '../common_libs.dart';

class FullBodyCheckupDataModal extends ChangeNotifier {
  final Api _api = Api();

  int value = 0;

  late ScrollController scrollController;

  TextEditingController searchC = TextEditingController();
  TextEditingController alphbetC = TextEditingController();


////......fullbodyview......////




  //...................find doctor by symptoms..................
  String symptomsList = "";

  String get getSymptomsList => symptomsList;
  set updateSymptomsList(String val) {
    symptomsList = val;
    notifyListeners();
  }

  List<SymptomsProblemModal>  getSymptomsProblemList(context){

    ConsultDoctorViewModal consultDoctorVM =
    Provider.of<ConsultDoctorViewModal>(context, listen: false);

     return List<SymptomsProblemModal>.from(
      ((consultDoctorVM.searchC.text==''?getProblemResponse.data == null ? [] : getProblemResponse.data:
          getProblemResponse.data == null
              ? [] : getProblemResponse.data.where((element) => (element.problemName.toString().toLowerCase().trim()
          ).trim().contains(consultDoctorVM.searchC.text.toLowerCase().trim())))
      )
  );}

  ApiResponse problemResponse = ApiResponse.initial("initial");
  ApiResponse get getProblemResponse => problemResponse;
  set updateProblemResponse(ApiResponse val) {
    problemResponse = val;
    notifyListeners();
  }

  Future<void> getSymptomsProblem(context) async {
    updateProblemResponse = ApiResponse.loading("Fetching Data");
    try {
      var data = await _api.call(context,
          url: AllApi.getProblemsWithIcon,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {"problemName": ""}));
      if (data['responseCode'] == 1) {

        for(int i=0; i<data['responseValue'].length;i++){
          data['responseValue'][i].addAll({"isSelected":false});
        }

        problemResponse.data = (List<SymptomsProblemModal>.from(
            ((data['responseValue'] ?? []) as List)
                .map((e) => SymptomsProblemModal.fromJson(e))));
        updateProblemResponse =
            ApiResponse<List<SymptomsProblemModal>>.completed(
                getProblemResponse.data ?? []);
        if (data['responseValue'].isEmpty) {
          updateProblemResponse = ApiResponse.empty("");
        } else {}
      } else {
        updateProblemResponse = ApiResponse.empty("message");
        Alert.show(data['message']);
      }
    } catch (e) {
      updateProblemResponse = ApiResponse.error(e.toString());
    }
  }



  // ............searchProblemList..................
  List searchProblem = [];
  List get getProblemList => searchProblem;
  set updateProblemList(List val) {
    searchProblem = val;
    notifyListeners();
  }

  getAllProblems(context) async {
    ConsultDoctorViewModal consultDoctorVM =
    Provider.of<ConsultDoctorViewModal>(context, listen: false);
    try {
      var data = await _api.call(context,
          url: AllApi.patientAllProblems,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(body: {
            "alphabet": consultDoctorVM.searchC.text.toString(),
          }));
      if (data["responseCode"] == 1) {
        updateProblemList = data["responseValue"];
      }
    } catch (e) {}
  }

  //.....SearchListDataAdd................
  List addedSymptoms = [];
  List get getAddedSymptomsList => addedSymptoms;
  set updateAddedSymptomsList(Map val) {
    addedSymptoms.add(val);
    notifyListeners();
  }

// .......RemoveListData..............................

  removeListData(index,problemID) {
    dPrint(index);

    if(addedSymptoms[index]["isVisible"].toString()=="0"){
        addedSymptoms[index]["isVisible"]='1';
      }
      else{
        addedSymptoms[index]["isVisible"] = '0';
        addedSymptoms.removeAt(index);
      }
      notifyListeners();
  }
//.......changeTextColor..........

  changeIsVisible(index, problemMap){
    dPrint(index);
    if (searchProblem[index]["isVisible"].toString() == '0') {
      updateAddedSymptomsList = problemMap;
      searchProblem[index]["isVisible"] =  '1';
    }
    else {
      searchProblem[index]["isVisible"] = '0';

      for (int i = 0; i <addedSymptoms.length; i++) {
        if (addedSymptoms[i]['problemId'].toString() == problemMap['problemId'].toString())
        {
          addedSymptoms.removeAt(i);
          notifyListeners();
        }

      }


    }
    selectedUnlocalizedPrblm.removeAt(selectedUnlocalizedPrblm.map((e) => e.id).toList().indexOf(problemMap['problemId'].toString()));
    SymptomsProblemModal abc=SymptomsProblemModal(isSelected:false,
 problemId: problemMap['problemId'],problemName:problemMap['problemName'] );

    onPressedUnlocalizedProblem(index, abc);
    notifyListeners();
  }

  //......symptom problem.......//






//*************************************************************



/////fullbodyview////....................


  clearData(){
    selectedSymptomsList=[];
    notifyListeners();
  }

  List FullBodyCheckup= [
    { "isSelected":false,
      'img':ImagePaths.redEye,
      'title':'Eye',
      'id':'22',
      'language':'1'},
    {
      "isSelected":false,
      'img':ImagePaths.facrDetection,
      'title':'Face',
      'id':'23',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.nose,
      'title':'Nose',
      'id':'37',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.neck,
      'title':'Neck',
      'id':'36',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.arm,
      'title':'Hand',
      'id':'27',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.skinLayer,
      'title':'Skin',
      'id':'42',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.leg,
      'title':'Legs',
      'id':'32',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.teeth,
      'title':'Teeth',
      'id':'43',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.mouth,
      'title':'Mouth',
      'id':'34',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.ear,
      'title':'Ear',
      'id':'19',
      'language':'1'
    },

    {
      "isSelected":true,
      'img':ImagePaths.spine,
      'title':'Spine',
      'id':'12',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.bodyBackPain,
      'title':'Back Pain',
      'id':'12',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.abdomen,
      'title':'Abdomen',
      'id':'1',
      'language':'1'
    },
    {
      "isSelected":false,
      'img':ImagePaths.pelvis,
      'title':'Pelvis',
      'id':'39',
      'language':'1'
    },


  ];

  List<OrganSymptomDataModal> get getOrganList=>getOrganResponse.data??[];
  ApiResponse organResponse=ApiResponse.initial("initial");
  ApiResponse get getOrganResponse=>organResponse;
  set updateOrganResponse(ApiResponse val) {
    organResponse = val;
    notifyListeners();
  }
  deleteSymptoms(index){

    selectedSymptomsList.removeAt(index);
    notifyListeners();
  }

  Map selectedBodyPart={};
  Map get getSelectedBodyPart=>selectedBodyPart;
  set updateSelectedBodyPart(Map val){
    selectedBodyPart=val;
    notifyListeners();
  }


  onPressRadioButon(Index,selectedData,context) async {

    dPrint('vvvvvvvvvvvvvvvv'+Index.toString());
    dPrint('vvvvvvvvvvvvvvvv'+selectedData.toString());
    updateSelectedBodyPart=selectedData;

    // await getSymptomByProblem(context);


  }


  List<SelectedSymptoms> selectedSymptomsList=[];
  List<SelectedSymptoms> get getSelectedSymptomsList => selectedSymptomsList..sort((a, b)
  => a.organ!.id.toString().compareTo(b.organ!.id.toString()));

  selectOrganSymptomList( OrganSymptomDataModal organData){


    if(selectedSymptomsList.map((e) => e.id).toList().contains(organData.id.toString())){

      selectedSymptomsList.removeAt(
          selectedSymptomsList.map((e) => e.id).toList().indexOf(organData.id.toString())
      );
    }
    else{
      selectedSymptomsList.add(
          SelectedSymptoms(
            id: organData.id.toString(),
            isSelected:organData.isSelected,
            symptoms:organData.symptoms.toString(),
            organ: Organ(
                id: getSelectedBodyPart['id'],
                img: getSelectedBodyPart['img'] ,
                isSelected:getSelectedBodyPart['isSelected'] ,
                language: getSelectedBodyPart['language'] ,
                title: getSelectedBodyPart['title'] ),
          )
      );
    }
    notifyListeners();


  }




  List<Organ>  selectedUnlocalizedPrblm=[];
  List<Organ>  get getSelectedUnlocalizedPrblm=>selectedUnlocalizedPrblm;
  set updateSelectedUnlocalizedPrblm(Organ val){
    selectedUnlocalizedPrblm.add(val);
    notifyListeners();
  }

  onPressedUnlocalizedProblem(index, SymptomsProblemModal symptom){
    (problemResponse.data??[])[index].isSelected=!((problemResponse.data??[])[index].isSelected??false);
    if((symptom.isSelected??false)){
      updateSelectedUnlocalizedPrblm = Organ(
          img: symptom.displayIcon.toString(),
          title: symptom.problemName.toString(),
          id: symptom.problemId.toString(),
          isSelected: symptom.isSelected);
    }
    else{
      selectedUnlocalizedPrblm.removeAt(index);
    }
    notifyListeners();
  }
//*************************************************************

}
