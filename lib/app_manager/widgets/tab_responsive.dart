import 'package:flutter/material.dart';



class TabResponsive extends StatelessWidget {

  final Widget child;

  const TabResponsive({Key? key, required this.child}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width>600?
    Center(
      child: SizedBox(
              width: 600,
              child: child),
    )
        : child;
  }


}



class TabResponsiveUtil {
  static bool isTab(BuildContext context){
    return MediaQuery.of(context).size.width>600 ||  MediaQuery.of(context).orientation ==
        Orientation.landscape;
  }
}
