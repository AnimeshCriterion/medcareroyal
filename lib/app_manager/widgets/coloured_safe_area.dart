





import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:flutter/material.dart';

class ColoredSafeArea extends StatelessWidget {
  final Widget child;
  final Color? color;

  const ColoredSafeArea({Key? key, required this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.green,
      child: SafeArea(
        child: child,
      ),
    );
  }
}

