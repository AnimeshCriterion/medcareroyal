


import 'package:medvantage_patient/app_manager/extentions/hex_color_extention.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common_libs.dart';
import '../main.dart';
import 'neomorphic/hex.dart';




final BuildContext? _context=NavigationService.navigatorKey.currentContext;




class AppColor {

  // static Color primaryColor =  const Color.fromRGBO(0, 23, 103 ,1);
  // static Color primaryColor = const Color.fromARGB(255, 250, 114, 73);



  static Color get primaryColor  {
    UserRepository userRepository = Provider.of<UserRepository>(_context!, listen: false);
    // return userRepository.getAppDetails.appColorPrimary!.toColor();
    return const Color.fromRGBO(0, 23, 103 ,1);
  }
  // static Color primaryColorDark = Colors.blue.shade900;
  static Color primaryColorDark = const Color.fromARGB(255, 250, 114, 73);
  static Color dullBlack =  const Color.fromARGB(255, 45, 51, 68);
  static Color medlightblack=const Color.fromRGBO(43, 51, 68,1);

  static Color yellow =   Colors.yellow;
  static Color darkYellow = Colors.amber.shade500;

  static Color orange = Colors.orange;


  static Color white = Colors.white;
  static Color texFieldDark = ('#474747').toColor();

  // static Color lightScream = const Color.fromRGBO(255, 237, 212,1);
  // static Color lightScream = const Color.fromRGBO(255, 228, 232, 1.0);

  // static Color black = Colors.black;

  static Color get black  {
    UserRepository userRepository = Provider.of<UserRepository>(_context!, listen: false);

    // print('nnnnnvnnnv :'+userRepository.getAppDetails.appColorSecondary.toString());

    // return  userRepository.getAppDetails.appColorSecondary.toString().toColor();
    return '#000000'.toColor();
  }

  static Color lightBlack= const Color.fromRGBO(44, 44, 44, 1);

  static Color grey= Colors.grey;
  static Color greyVeryLight= Colors.grey.shade200;
  static Color greyVeryVeryLight=const Color.fromRGBO(245, 245, 245,1);

  static Color greyDark = Colors.grey.shade700;
  static Color black12=const Color.fromRGBO(68, 68, 68,1);
  static Color secondaryColorShade1 = const Color.fromRGBO(87, 96, 117, 0.6);
  // static Color greydLight=   Colors.grey;
  // static Color greydark118= const Color.fromRGBO(118, 118, 118, 1);

  static Color greydark12= const Color.fromRGBO(99, 99, 99, 1);
  // static Color secondaryColorShade2 = const Color.fromRGBO(112, 112, 112, 1);

  static Color purple = const Color.fromRGBO(108, 53, 238, 1.0);
  static Color veryLightPurple = const Color.fromRGBO(126, 87, 194, 1.0);
  static const primarySwatchColorLight=Colors.deepPurple;

  static Color blue =  const Color.fromRGBO(32, 133, 205, 1);
  static Color darkBlue = const Color.fromRGBO(2, 42, 67, 1);
  static Color primaryColorLight = const Color.fromRGBO(100, 149, 237, 1);
  static Color lightBlue = const Color.fromRGBO(148, 223, 248, 1);
  static Color veryLightBlue = const Color.fromRGBO(185, 231, 234, 1);
  static Color Blue = const Color.fromRGBO(79, 173, 240, 1);
  static Color BlueVeyVeryLight = const Color.fromRGBO(243, 254, 255, 1);



  static Color green = Colors.green;
  static Color lightGreen = const Color.fromRGBO(115, 242, 43, 1);
  static Color randomShades6 = const Color.fromRGBO(126, 162, 98, 1);
  static Color veryLightGreen = const Color.fromRGBO(198, 234, 185, 1);

  static Color red = Colors.red.shade600;
  static Color secondaryColor = const Color.fromRGBO(255, 102, 102, 1);
  static Color lightPink = const Color.fromRGBO(255, 230, 226, 1);
  static Color verylightPink = const Color.fromRGBO(255, 236, 236, 1);


  static Color randomShades2 = const Color.fromRGBO(28, 187, 180, 1);
  static Color lightblue123=const Color.fromRGBO(137, 205, 209,1);
  static Color lightskyblue=const Color.fromRGBO(202, 246, 255,1);

  static Color randomShades5 = Colors.blueGrey;

  static Color randomShades7 = const Color.fromRGBO(188, 140, 190, 1);
  static Color randomShades3 = const Color.fromRGBO(188, 140, 190, 1);
  static Color randomShades4 = const Color.fromRGBO(245, 150, 120, 1);


  static final secondaryColorLight=("#8b24e7").toColor();
  static final Color buttonTextWhite = '#FEFEFF'.toColor();

  static Color customBlack=("#2B3344").toColor();
  static final Color sliderTextGrey = '#59606E'.toColor();
  static final Color textDarkGrey = '#3F4E6E'.toColor();
  static final Color paragraphText = '#23384D'.toColor();
  static final Color themeColor = '#2B97A3'.toColor();
  static final bgColor=("#eff3f4").toColor();
  static Color pharmacyPrimaryColor =  const Color.fromRGBO(10, 88, 108, 1);


  static Color transparent = Colors.transparent;

  static Color customBlue = const Color.fromRGBO(87, 96, 117,1);
  static Color diseasebanner = const Color.fromRGBO(216, 232, 237,1);
  static Color lightYellow = const Color.fromRGBO(235, 255, 0,1);
  static Color neoGreen = hexToColor('#1BD15D');
  static Color neoGreyLight = hexToColor('#474747');
  static Color neoBGGrey1 =       hexToColor('#303238');

  static Color neoBGGrey2 =  hexToColor('#1e1e1e');

  static Color neoBGWhite2 =  hexToColor('#cfcfcf');
  static Color neoBGWhite1 =  hexToColor('#f5f5f5');

  static Color blackLight =  hexToColor('#282b2d');
  static Color blackDark =  hexToColor('#111212');

  static Color blackLight2 =  hexToColor('#191e24');
  static Color blackDark2 =  hexToColor('#111215');
  static Color bgGreen =  hexToColor('#37d15d');


  static Color cardDark =  hexToColor('#24252B');
  static Color bgDark =  hexToColor('#181A20');
  static Color bgWhite =  hexToColor('#F4F4F4');
  static Color bgWhite2 =  hexToColor('#EAEAEA');



 static Color greyLight = Colors.grey.withOpacity(0.3);
static Color lightGrey = Colors.grey.shade100;
 static Color orangeButtonColor = Colors.orange.shade300;
static Color randomShades1 = const Color.fromRGBO(240, 178, 105, 1);
 static Color secondaryColorShade2 = const Color.fromRGBO(112, 112, 112, 1);
 static Color darkshadowColor1 = const Color.fromRGBO(49, 51, 56, 1);
 static Color darkshadowColor2 = const Color.fromRGBO(67, 70, 79, 1);
 static Color lightshadowColor1 = const Color.fromRGBO(244, 244, 244, 1);
 static Color lightshadowColor2 = const Color.fromRGBO(207, 207, 207, 1);
 static Color darkgreen = const Color.fromRGBO(0, 187, 68, 1);
 static Color green12 = const Color.fromRGBO(27, 209, 93, 1);
 static Color lightgreen11 = const Color.fromRGBO(159, 226, 170, 1);
 static Color lightgreen13 = const Color.fromRGBO(129, 245, 155, 1);


















  static Color get buttonColor  {
    UserRepository userRepository = Provider.of<UserRepository>(_context!, listen: false);
    return Colors.white;
    return const Color.fromRGBO(0, 23, 103 ,1);
  }




}





class VitalioColors {

  static Color primaryBlue = HexColor('#1564ED');
  static Color white = Colors.white;
  static Color primaryBlueLight = HexColor('#F5F8FC');
  static Color greyText = HexColor('#546788');
  static Color greyLight = HexColor('#BABFC9');
  static Color greyBG = hexToColor('#EDF1F6');
  static Color greyBG2 = hexToColor('#F7F9FB');
  static Color greyText2 = hexToColor('#828691');
  static Color greyBlue = hexToColor('#546788');
  static Color greyBlueBG = hexToColor('#EDF1F6');
  static Color charcoalGray=hexToColor('#202529');
  static Color bgDark=hexToColor('#141415');
  static Color bgDark2=hexToColor('#252527');
  static Color msgLightblue=hexToColor('#E4EEFF');
  static Color skyBlue=hexToColor('#C2D9FF');
  static Color cardDark =  hexToColor('#24252B');
  static Color brightRed=hexToColor('#D40000');
}