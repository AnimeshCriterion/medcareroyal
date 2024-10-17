import 'package:flutter/material.dart';

class MyNavigator {
  static Future push(context, Widget route, {Object? arguments}) async {
    var data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return route;
        },
        settings: RouteSettings(
          arguments: arguments,
        ),
      ),
    );
    return data;
  }

  static pushReplacement(context, route, {String? routeName}) async {
    var data = await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            settings: routeName != null ? RouteSettings(name: routeName) : null,
            builder: (BuildContext context) {
              return route;
            }));
    return data;
  }

  static pushAndRemoveUntil(context, Widget route) async {
    var data = await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => route,
      ),
      (route) => false,
    );
    return data;
  }

  static navigateTransparent(context, route) async {
    var data = await Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return route;
          },
          transitionsBuilder: (context, a1, a2, widget) {
            return widget;
          },
          transitionDuration: const Duration(milliseconds: 200),
        ));
    return data;
  }
}
