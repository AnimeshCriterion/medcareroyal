import 'package:flutter/material.dart';
import 'dart:convert';  // For jsonEncode
import 'package:http/http.dart' as http;
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';

import '../authenticaton/user_repository.dart';
import '../common_libs.dart';

class RequestCallbackFormStyled extends StatefulWidget {
  @override
  _RequestCallbackFormStyledState createState() =>
      _RequestCallbackFormStyledState();
}

class _RequestCallbackFormStyledState extends State<RequestCallbackFormStyled> {
  final _formKey = GlobalKey<FormState>();
  final String apiUrl = "https://apimedcareroyal.medvantage.tech:7082/api/LogInForSHFCApp/EmergencyAlertAPI";
TextEditingController remarkC=TextEditingController();

  String _reason = '';


  // This function will be used to make the API call
  Future<void> callEmergencyAlertAPI() async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    // Set up query parameters
    String uhid = userRepository.getUser.uhID.toString();
    String deviceToken =userRepository.getUser.token.toString();
    String clientId =userRepository.getUser.clientId.toString();
    String emergencyNumber = '0';

    // Construct the full URL with parameters
    Uri url = Uri.parse('$apiUrl?Uhid=$uhid&deviceToken=$deviceToken&clientId=$clientId&remark=${remarkC.value.text.toString()}&emergencyNumber=$emergencyNumber');
print("CheckUrl"+url.toString());
    try {
      // Make the GET request
      final response = await http.post(url);

      // Check for a successful response
      if (response.statusCode == 200) {
        // Parse the JSON response
        var responseData = json.decode(response.body);
        print('Response data: $responseData');

        // Handle response data, e.g., show success message or process the data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Callback requested!')),
        );
        Navigator.of(context).pop(
        );
      } else {
        print('Failed to call API. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong please try again .'))
        );
      }
    } catch (error) {
      // Handle any exceptions
      print('Error calling API: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in Communication with Server .'))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Request Callback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller:remarkC ,
              decoration: InputDecoration(
                labelText: 'Reason for Callback',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
              onSaved: (value) {
                _reason = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please specify the reason for callback';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                       await callEmergencyAlertAPI();
                  
                      }
                    },
                                 title: 'Request Callback',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

