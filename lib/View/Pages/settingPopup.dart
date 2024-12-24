import 'package:medvantage_patient/View/widget/common_method/show_progress_dialog.dart';
import 'package:medvantage_patient/ViewModal/login_view_modal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Localization/app_localization.dart';
import '../../app_manager/alert_toast.dart';
import '../../app_manager/api/api_call.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';

class PushNotificationSettingsDialog extends StatefulWidget {
  const PushNotificationSettingsDialog({super.key});

  @override
  _PushNotificationSettingsDialogState createState() =>
      _PushNotificationSettingsDialogState();
}

class _PushNotificationSettingsDialogState
    extends State<PushNotificationSettingsDialog> {
  bool _pushNotificationEnabled = true; // Default value
  bool _isLoading= false; // Default value

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotificationEnabled= prefs.getInt('isNotificationRequired')==0? false:true;
    });

  }



  final Api _api = Api();

  getPatientDetailsByUHID(context) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var data = await _api.callMedvanatagePatient7082(context,
        // newBaseUrl: 'https://apishfc.medvantage.tech:7082/',
        url:
        "api/PatientPersonalDashboard/GetPatientDetailsByUHID?UHID=${userRepository.getUser.uhID.toString()}",
        apiCallType: ApiCallType.get());

     Get.back();

    if (data['status'] == 1) {
      // Alert.show(data['message']);


      int isNotificationRequired=0;

      final prefs = await SharedPreferences.getInstance();
      if(data['responseValue'].isNotEmpty){
        isNotificationRequired=   int.parse((data['responseValue'][0]['isNotificationRequired']??0).toString());
        prefs.setInt('isNotificationRequired', isNotificationRequired);
      }

    } else {
      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['responseValue'].toString()));

      // Alert.show(data['responseValue']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Settings"),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enable Push Notifications"),
          const Spacer(),
         _isLoading? CircularProgressIndicator(

           strokeWidth: 3,
         ): Switch(
           activeColor: AppColor.primaryColor,

            value: _pushNotificationEnabled,
            onChanged: (newValue) {
              setState(() async {
                _pushNotificationEnabled = newValue;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await enableDisablePushNotification(context);
            await getPatientDetailsByUHID(context);
            await  get();
            // Save the settings
            // You can implement your logic here to save the setting
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  enableDisablePushNotification(context) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    final Api _api = Api();
    final LoginViewModal _loginViewModel = LoginViewModal();
    _isLoading=true;
    try {
      var data = await _api.callMedvanatagePatient7082(context,
          url:
          "api/PatientRegistrationForSHFC/UpdatePatientNotification?uhId=${userRepository.getUser.uhID.toString()}&isNotificationRequired=${_pushNotificationEnabled.toString()}",
          apiCallType: ApiCallType.rawPut(body: {}));

      dPrint('nnnnnnnnnnnnn$data');
      if (data['status'] == 1) {
        _isLoading=false;
        dPrint("Dataaa$data");
        await _pushNotificationEnabled?

        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Enabled'.toString()))
        :

    Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Disabled'.toString()))
         ;
        await _loginViewModel.loginWithUHID(context);
        _pushNotificationEnabled=userRepository.getUser.isNotificationRequired==1?true:false;
        setState(() {

        });
      } else {
        _isLoading=false;
        setState(() {

        });
        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
        // Alert.show(data['message']);
      }
    } catch (e) {
      _isLoading=false;
      dPrint('nnnn$e');
    }
  }
}


