import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medvantage_patient/app_manager/api/api_util.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/encyption.dart';

import '../../Localization/app_localization.dart';
import '../../Modal/investigation_model.dart';
import '../../ViewModal/MasterDashoboardViewModal.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../assets.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';

class InvestigationPage extends StatefulWidget {
  @override
  _InvestigationPageState createState() => _InvestigationPageState();
}

class _InvestigationPageState extends State<InvestigationPage> {
  late Future<List<Investigation>> investigations;


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  void initState() {
    super.initState();
    investigations = fetchInvestigations();
  }

  Future<List<Investigation>> fetchInvestigations() async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    final url = '${ApiUtil().baseUrlMedvanatge7082}api/PatientIPDPrescription/GetPrescribedInvestigations?${await EncryptDecrypt.encryptString('uhID=${userRepository.currentUser!.uhID}', EncryptDecrypt.key)}&clientID=${await EncryptDecrypt.encryptString('${userRepository.currentUser!.clientId}', EncryptDecrypt.key)}';
print("checkk"+url.toString());
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 1) {
        List<dynamic> investigationsJson = jsonData['responseValue'];
        return investigationsJson.map((item) => Investigation.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load investigations');
      }
    } else {
      throw Exception('Failed to load investigations');
    }
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    MasterDashboardViewModal masterDashboardViewModal =
    Provider.of<MasterDashboardViewModal>(context, listen: true);

    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: true);
    return ColoredSafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Prescribed Investigations'),
        ),
        body: Column(
          children: [
            // Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
            //   InkWell(
            //       onTap: (){
            //         scaffoldKey.currentState!.openDrawer();
            //       },
            //       child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
            //   Text( localization.getLocaleData.presribedMedicine.toString(),
            //     style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 1,color: themeChange.darkTheme==true?Colors.white70:null),),
            // ],),
            Expanded(
              child: FutureBuilder<List<Investigation>>(
                future: investigations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hashCode==404) {
                    return Center(child: Text('No investigations found'));
                  } else if (snapshot.hasData) {
                    final investigations = snapshot.data!;
                    return ListView.builder(
                      itemCount: investigations.length,
                      itemBuilder: (context, index) {
                        final investigation = investigations[index];
                        return ListTile(
                          title: Text(investigation.itemName),
                          subtitle: Text('Prescribed On: ${_formatDate(investigation.createdDate)}'),
                          trailing: Icon(
                            investigation.isDone ? Icons.check_circle : Icons.pending,
                            color: investigation.isDone ? Colors.green : Colors.red,
                          ),
                        );

                      },
                    );
                  } else {
                    return Center(child: Text('No investigations found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String createdDate) {
    // Parse the date string first
    DateTime parsedDate = DateFormat('MM/dd/yyyy hh:mm:ss a').parse(createdDate);

    // Format the date in a professional manner, e.g., "Oct 19, 2024, 03:46 PM"
    return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
  }
}
