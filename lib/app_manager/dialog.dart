


import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

myNewDialog({required String title}){
  return  Get.dialog(SimpleDialog(
      surfaceTintColor:Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //  ZoomIn(duration:Duration(seconds: 2),child: Image.asset('assets/counter.png',height: 94,fit: BoxFit.fitHeight,)),
          ZoomIn(duration:const Duration(seconds: 2),child: const Icon(Icons.check_circle_outline,size: 100,color: Colors.lightBlueAccent,)),
          const SizedBox(height: 20,),
          Text(title),
        ],
      ),titlePadding:const EdgeInsets.all(20)));
}