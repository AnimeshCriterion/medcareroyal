

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({Key? key, required this.child,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/gym_bg.png"),
          fit: BoxFit.cover
        )
      ),
      child: Container(
          color: Colors.black54,
          child: child),
    );
  }
}