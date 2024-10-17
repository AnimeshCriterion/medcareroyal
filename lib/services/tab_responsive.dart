

import 'package:flutter/material.dart';

class TabResponsive {



  wrapInTab({
    required BuildContext context,
    required Widget child
  }){
    return MediaQuery.of(context).size.width>600?
        Center(
          child: SizedBox(
              width: 600,
              child: child),
        ): child;
  }




  bool isTab(context){
    return MediaQuery.of(context).size.width>600;
  }

}