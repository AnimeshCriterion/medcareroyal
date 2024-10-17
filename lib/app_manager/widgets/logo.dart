import 'package:flutter/material.dart';

import '../../common_libs.dart';
import '../../theme/theme.dart';


class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
        color: themeChange.darkTheme ? Colors.grey.shade800 : Colors.white70,
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: const SizedBox(
          height: 150,
          width: 150,
          child: Image(image: AssetImage('assets/logo.png'),)),
    );
  }
}
