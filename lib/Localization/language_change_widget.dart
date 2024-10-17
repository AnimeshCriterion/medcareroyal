


import 'package:get/get.dart';

import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localization.dart';

class LanguageChangeWidget extends StatefulWidget {
  final isPopScreen;
  const LanguageChangeWidget({Key? key, this.isPopScreen=false}) : super(key: key);

  @override
  State<LanguageChangeWidget> createState() => _LanguageChangeWidgetState();
}

class _LanguageChangeWidgetState extends State<LanguageChangeWidget> {
  ApplicationLocalizations dddd = ApplicationLocalizations();
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: true);
    return      Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/translate.png',height: 25,width: 30),
        const SizedBox(width: 10,),
        DropdownButton<Language>(
          style:  MyTextTheme.mediumBCB,
          borderRadius: BorderRadius.circular(10),
          value: localization.getLanguage,
          elevation: 0,
          underline: Container(),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: localization.listOfLanguages.map((Language items) {
            return DropdownMenuItem(
              value: items,
              child: Text(getLanguageInRealLanguage(items).toString()),
            );
          }).toList(),

          onChanged: (Language? newValue) {
            setState(() async {
              if(newValue!=null){
                final prefs = await SharedPreferences.getInstance();
                if( Language.english==newValue){
                  await prefs.setString('lang',"1");
                }
              else  if( Language.hindi==newValue){
                  await prefs.setString('lang',"2");
                }
              else if( Language.arabic==newValue){
                  await prefs.setString('lang',"10");
                }
              print("language.....${await prefs.getString("lang").toString()}");
                localization.updateLanguage(newValue);
                localization.notifyListeners();
                 Get.back();
                if(widget.isPopScreen){
                   Get.back();
                }
              }
            });



          },
        ),
      ],
    );
  }
}
