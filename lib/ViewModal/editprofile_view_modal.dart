import 'dart:convert';

import 'package:get/get.dart';
import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/all_api.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Localization/app_localization.dart';
import '../Modal/member_data_modal.dart';
import '../View/Pages/dashboard_view.dart';
import '../app_manager/alert_toast.dart';
import '../app_manager/api/api_response.dart';
import '../app_manager/api/api_util.dart';
import '../app_manager/bottomSheet/bottom_sheet.dart';
import '../app_manager/bottomSheet/functional_sheet.dart';
import '../app_manager/dialog.dart';
import '../authenticaton/user.dart';
import '../medcare_utill.dart';
import 'package:http/http.dart' as http;

class EditProfileViewModal extends ChangeNotifier {
  final Api _api = Api();
  var formKey = GlobalKey<FormState>();

  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController aleternamephoneC = TextEditingController();
  TextEditingController dobC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController addressline2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController modalityC = TextEditingController();
  TextEditingController heightC = TextEditingController();
  TextEditingController weightC = TextEditingController();



  int selectedGender=0;
  int selectedBloodGroup=0;
  int get getSelectedGender=>selectedGender;

  set selectbloodgroupID(selectbloodgroupID) {
    selectedBloodGroup=selectbloodgroupID;
    notifyListeners();
  }
  set updateSelectedGender(int val){
    selectedGender=val;
    notifyListeners();
  }


  clearData() {
    nameC.clear();
    emailC.clear();
    phoneC.clear();
    dobC.clear();
    addressC.clear();
    heightC.clear();
    weightC.clear();
    updateSelectedGender=0;
    updateSelectedMemberId='';
    //updateSelectedImage='';
    notifyListeners();
  }

  String selectedMemberId = '';

  String get getSelectedMemberId => selectedMemberId;

  set updateSelectedMemberId(String val) {
    selectedMemberId = val;
    notifyListeners();
  }

  String selectedImage = '';

  String get getSelectedImage => selectedImage;

  set updateSelectedImage(String val) {
    selectedImage = val;
    notifyListeners();
  }

  getProfilePath(context) async {
    dPrint(getSelectedImage.toString());
    var data = await _api.call(context,
        url: AllApi.saveMultipleFile,
        apiCallType: ApiCallType.multiPartRequest(
          filePath: getSelectedImage.toString(),
          fileParameter: 'files',
          body: {},
        ),
        token: true);
    return jsonDecode(data['responseValue'])[0]['filePath'];
  }

  onPressedUpdateMember(context) async {
    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message: 'Are you sure you want to update?',
          buttonName: 'yes',
          onPressButton: () async {
            await updateMember(context);
          },
        ));
    return Future.value(false);
  }

  onPressedAddMember(context) async {
    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message: 'Are you sure you want to add?',
          buttonName: 'yes',
          onPressButton: () async {
            await addMember(context);
          },
        ));
    return Future.value(false);
  }

  updateMember(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

    // ProgressDialogue().show(context, loadingText: 'Loading...');
    //
    // var myFile = getSelectedImage.toString() == '' ? '' : await getProfilePath(context);
    //
    // dPring('nnnnnnnnnnnnnnnnnnnnnnnn');
    // var data = await _api.call(context,
    //     url: AllApi.updateMember,
    //     apiCallType: ApiCallType.rawPost(body: {
    //       "memberId": userRepository.getUser.uhID.toString(),
    //       "name": nameC.text.toString(),
    //       "mobileNo": phoneC.text.toString(),
    //       "emailId": emailC.text.toString(),
    //       "gender": getSelectedGender.toString(),
    //       "dob": DateFormat('yyyy-mm-dd')
    //           .format(DateFormat("yyyy-mm-dd").parse(
    //         dobC.text.toString(),
    //       ))
    //           .toString(),
    //       "countryId": userRepository.getUser.countryId,
    //       "stateId": userRepository.getUser.stateId,
    //       "districtId": userRepository.getUser.districtId,
    //       "pincode": userRepository.getUser.pinCode,
    //       "address": addressC.text.toString(),
    //       "profilePhotoPath": myFile.toString() == ''
    //           ? userRepository.getUser.profilePhotoPath.toString() == ''
    //           ? ''
    //           :userRepository.getUser.profilePhotoPath.toString()
    //           .trim()
    //           .split('/')[4]
    //           .toString()
    //           : myFile.toString() ,
    //       "aadhaarNo": userRepository.getUser.aadhaarNo,
    //       "height": heightC.text.toString(),
    //       "weight": weightC.text.toString(),
    //     }));
    // ProgressDialogue().hide();
    // if (data['responseCode'] == 1) {
    //   data['responseValue'][0]
    //       .addAll({'token': userRepository.getUser.token.toString()});
    //
    //   await userRepository.updateUserData(User.fromJson(data['responseValue'][0]));
    //
    //   notifyListeners();
    // } else {
    //   Alert.show(data['responseMessage']);
    // }
  }

  addMember(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    // try {
    //   var myFile = getSelectedImage.toString() == ''
    //       ? ''
    //       : await getProfilePath(context);
    //   var body = {
    //     "userLoginId": userRepository.getUser.uhID.toString(),
    //     "name": nameC.text.toString(),
    //     "mobileNo": phoneC.value.text.toString(),
    //     "emailId": emailC.value.text.toString(),
    //     "gender":getSelectedGender.toString(),
    //     "dob": DateFormat('yyyy-mm-dd')
    //         .format(DateFormat("yyyy-mm-dd").parse(
    //       dobC.text.toString(),
    //     ))
    //         .toString(),
    //     "countryId": userRepository.getUser.countryId,
    //     "stateId": userRepository.getUser.stateId,
    //     "districtId": userRepository.getUser.districtId,
    //     "countryCallingCode": 0.toString(),
    //     "pincode": userRepository.getUser.pinCode,
    //     "address": addressC.text.toString(),
    //     "profilePhotoPath": myFile.toString(),
    //   };
    //
    //   dPring(body.toString());
    //
    //   var data = await _api.call(context,
    //       url: AllApi.addMember, apiCallType: ApiCallType.rawPost(body: body));
    //
    //   ProgressDialogue().hide();
    //   if (data['responseCode'] == 1) {
    //     Alert.show(data['responseMessage']);
    //     await getMember(context);
    //      Get.back();
    //   } else {
    //     Alert.show(data['responseMessage']);
    //   }
    // } catch (e) {
    //   _updateMemberResponse = ApiResponse.error(e.toString());
    // }
  }

  //********* MEMBER HISTORY START**********************

  List<MemberDataModal> get getMemberList => (List<MemberDataModal>.from(
      ((getMemberResponse.data!=null? getMemberResponse.data:[]) as List)
          .map((e) => MemberDataModal.fromJson(e))));

  ApiResponse memberResponse = ApiResponse.initial("initial");

  ApiResponse get getMemberResponse => memberResponse;

  set _updateMemberResponse(ApiResponse val) {
    memberResponse = val;
    notifyListeners();
  }

  Future<void> getMember(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    _updateMemberResponse = ApiResponse.loading("Fetching Member List");
    try {
      var data = await _api.call(context,
          url: AllApi.getMember,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(
              body: getSelectedMemberId.toString()==''?{
                "userLoginId": userRepository.getUser.uhID.toString()
              }: {
                "memberId": getSelectedMemberId.toString(),
                "userLoginId": userRepository.getUser.uhID.toString()
              }
          ));
      if (data['responseCode'] == 1) {

        data['responseValue'][0].addAll({'token': userRepository.getUser.patientName.toString()});

        if( getSelectedMemberId.toString()!=''){
          await userRepository
              .updateUserData(User.fromJson(data['responseValue'][0]));
        }
        notifyListeners();
        dPrint('nnnnnnnnnnnn' + userRepository.getUser.patientName.toString());
        notifyListeners();


        _updateMemberResponse = ApiResponse<List>.completed(
            data['responseValue']);

        if (data['responseValue'].isEmpty) {
          _updateMemberResponse = ApiResponse.empty("Address not available");
        } else {

        }
      } else {
        _updateMemberResponse = ApiResponse.empty("Address not available");
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseMessage'].toString()));
        // Alert.show(data['responseMessage']);
      }
    } catch (e) {
      _updateMemberResponse = ApiResponse.error(e.toString());
    }
  }


  onPressedDelete(context, memberID) async {
    updateSelectedMemberId = memberID;

    await CustomBottomSheet.open(context,
        child: FunctionalSheet(
          message: 'Are you sure you want to delete?',
          buttonName: 'yes',
          onPressButton: () async {
            await deleteMember(context);
          },
        ));
    return Future.value(false);
  }

  Future<void> deleteMember(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText:localization.getLocaleData.Loading.toString() );
    try {
      var data = await _api.call(context,
          url: AllApi.deleteMember,
          localStorage: true,
          apiCallType: ApiCallType.rawPost(
              body: {"memberId": getSelectedMemberId.toString()}));
      ProgressDialogue().hide();
      if (data['responseCode'] == 1) {
        updateSelectedMemberId='';
        await getMember(context);

        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['responseMessage'].toString()));
        // Alert.show(data['responseMessage']);
      } else {

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseMessage'].toString()));
        // Alert.show(data['responseMessage']);
      }
    } catch (e) {
      ApiResponse.error(e.toString());
    }
  }


  // Future<void> updateUserData(context) async {
  //   UserRepository userRepository =
  //   Provider.of<UserRepository>(context, listen: false);
  //   ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
  //   ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
  //   try {
  //
  //     var body={
  //       "patientName":nameC.value.text,
  //       "dob":DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy")
  //           .parse(userRepository.getUser.dob.toString())),
  //       "genderId": getSelectedGender,
  //       "countryCallingCode": "91",
  //       "mobileNo": phoneC.value.text,
  //       "countryId": userRepository.getUser.countryId,
  //       "stateId": userRepository.getUser.stateId,
  //       "cityId": userRepository.getUser.cityId,
  //       "address": addressC.value.text,
  //       "userId": userRepository.getUser.userId,
  //       "idNumber": "",
  //       "idTypeId": 0,
  //       'guardianAddress':'null',
  //       "age": userRepository.getUser.age,
  //       "departmentId": userRepository.getUser.deptId,
  //       "doctorId": userRepository.getUser.admitDoctorId,
  //       "emailID":emailC.value.text,
  //       "uhID": userRepository.getUser.uhID.toString(),
  //       "pid": userRepository.getUser.pid,
  //       "ageUnitId": userRepository.getUser.ageUnitId,
  //       "bloodGroupId": selectedBloodGroup,
  //       "height": heightC.value.text,
  //       "weight": weightC.value.text,
  //       "zip": userRepository.getUser.zip.toString(),
  //       "alternateMobileNo": aleternamephoneC.value.text,
  //       "alternateCountryCode": "91",
  //       "addressLine2": addressline2.value.text,
  //       'guardianMobileNo':''
  //     };
  //
  //
  //
  //
  //   var data = await _api.callMedvanatagePatient7082(context,
  //         url:'api/PatientRegistration/UpdatePatient',
  //         localStorage: true,
  //         token: false,
  //         apiCallType: ApiCallType.rawPut(
  //             body: body));
  //     ProgressDialogue().hide();
  //     dPrint("objecsdsdst"+data.toString());
  //     dPrint("objecsdsdst"+jsonEncode(body));
  //     if (data['status'] == 1) {
  //
  //      // Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Profile updated Successfully !'));
  //
  //       // Alert.show("Profile updated Successfully !");
  //       loginWithUHID(context);
  //        Get.back();
  //       myNewDialog(title:"Profile updated Successfully !");
  //     } else {
  //
  //       Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
  //       // Alert.show(data['responseValue']);
  //     }
  //   } catch (e) {
  //     ApiResponse.error(e.toString());
  //   }
  // }

  Future<void> updateUserData(context,   {filePath}) async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    //
    // ProgressDialogue().show(context, loadingText: 'Loading...');
    var age= userRepository.getUser.age.toString()=='null'? '':userRepository.getUser.age.toString();
    var dob= userRepository.getUser.dob.toString()=='null'? '':userRepository.getUser.dob.toString();
    print( 'nnnnvnnnvnnvnn '+ dob.toString());
    var request = http.MultipartRequest('PUT', Uri.parse('${ApiUtil().baseUrlMedvanatge7082}api/PatientRegistration/UpdatePatient'));

    request.fields.addAll( filePath.toString().isNotEmpty?{
      'patientName': nameC.value.text.toString().isNotEmpty?nameC.value.text.toString():userRepository.getUser.patientName.toString(),
      'dob': dob.toString(),
      'genderId': getSelectedGender.toString(),
      'mobileNo':phoneC.value.text.toString().isNotEmpty? phoneC.value.text.toString():userRepository.getUser.mobileNo.toString(),
      'countryId': userRepository.getUser.countryId.toString(),
      'stateId': userRepository.getUser.stateId.toString(),
      'cityId': userRepository.getUser.cityId.toString(),
      'address':  addressC.value.text,
      'userId': userRepository.getUser.userId.toString(),
      'IdNumber': '0',
      'IdTypeId': '0',
      'age':  age.toString(),
      'emailID': emailC.value.text.toString(),
      'pid': userRepository.getUser.pid.toString(),
      'languageId': '0',
      'ageUnitId': userRepository.getUser.ageUnitId.toString(),
      'bloodGroupId': userRepository.getUser.bloodGroupId.toString(),
      'height':heightC.value.text.toString()==''?  userRepository.getUser.height.toString():double.parse(heightC.value.text.toString()).toStringAsFixed(2),
      'weight': weightC.value.text.toString()==''?  userRepository.getUser.weight.toString():double.parse( weightC.value.text.toString()).toStringAsFixed(2),
      'IsCashLess': 'false',
      'InsuranceCompanyId': '0',
      'IsNotificationRequired': 'false',
      'PermanentCountryId': '0',
      'PermanentCityId': '0',
      'PermanentStateId': '0',
      'IsRegister': '0',
      'guardianAddress': ' ',
      'guardianMobileNo': ' ',
    }:
    {
      'patientName': nameC.value.text.toString().isNotEmpty?nameC.value.text.toString():userRepository.getUser.patientName.toString(),
      'dob': dob.toString(),
      'genderId': getSelectedGender.toString(),
      'mobileNo':phoneC.value.text.toString().isNotEmpty? phoneC.value.text.toString():userRepository.getUser.mobileNo.toString(),
      'countryId': userRepository.getUser.countryId.toString(),
      'stateId': userRepository.getUser.stateId.toString(),
      'cityId': userRepository.getUser.cityId.toString(),
      'address':  addressC.value.text,
      'userId': userRepository.getUser.userId.toString(),
      'IdNumber': '0',
      'IdTypeId': '0',
      'age':  age.toString(),
      'emailID': emailC.value.text.toString(),
      'pid': userRepository.getUser.pid.toString(),
      'languageId': '0',
      'ageUnitId': userRepository.getUser.ageUnitId.toString(),
      'bloodGroupId':  userRepository.getUser.bloodGroupId.toString(),
      'height': double.parse(heightC.value.text.toString()).toStringAsFixed(2),
      'weight': double.parse( weightC.value.text.toString()).toStringAsFixed(2),
      'IsCashLess': 'false',
      'InsuranceCompanyId': '0',
      'IsNotificationRequired': 'false',
      'PermanentCountryId': '0',
      'PermanentCityId': '0',
      'PermanentStateId': '0',
      'IsRegister': '0',
      'guardianAddress': ' ',
      'guardianMobileNo': ' ',
      "ProfileURL": userRepository.getUser.profileUrl.toString().replaceAll('https://api.medvantage.tech:7082/', ''),
    }
    ) ;

    print( 'nnvnnvnnnnnvnnn '+ request.fields.toString());
    if(filePath.toString().isNotEmpty){
      request.files.add(await http.MultipartFile.fromPath('FormFile', filePath.toString()));
    }

    http.StreamedResponse response = await request.send();

    var myData=await response.stream.bytesToString();

    print( 'nnvnnvnnnnnvnnn '+ myData.toString());
    if (response.statusCode == 200) {
      Alert.show("Profile updated Successfully !");
      //
      await userRepository
          .updateUserData(User.fromJson(jsonDecode(myData)['responseValue'][0]))
          .then((value) async {
        //       DashboardViewModal dashboardVM =
        // Provider.of<DashboardViewModal>(context, listen: false);
        // await dashboardVM.appDetails(context) ;
        dPrint("Aniemsh $value");
        // Get.offAll(RMDView());
        // MyNavigator.pushAndRemoveUntil(context, const RMDView());
      });

      // await loginWithUHID(context,userRepository.getUser.uhID.toString());
      // await loginWithUHID(context,userRepository.getUser.uhID.toString());
      Get.back();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  loginWithUHID(context) async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    var data = await _api.callMedvanatagePatient7082(context,
        url:
        "api/PatientPersonalDashboard/GetPatientDetailsByUHID?UHID=${userRepository.getUser.uhID..toString()}",
        localStorage: true,
        apiCallType: ApiCallType.get());

    if (data['status'] == 1) {

     // Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: data['message'].toString()));
      // Alert.show(data['message']);
      await userRepository.updateUserData(User.fromJson(data['responseValue'][0])).then((value) async {
        dPrint("Aniemsh$value");
 //       MyNavigator.pushAndRemoveUntil(context, const DashboardView());
      });

      dPrint("Aniemsh${userRepository.getUser.mobileNo}");
    } else {
      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));
      // Alert.show(data['responseValue']);
    }
  }



//********* MEMBER HISTORY END**********************

}
