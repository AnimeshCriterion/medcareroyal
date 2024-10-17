


import 'dart:ffi';

import 'package:get/get.dart';

class ListenController extends GetxController{


  List<double> stethoData=[];
  List<double> get getStethoData=>stethoData;
  set updateStethoData(List val){
    for(int i=0;i<val.length;i++){
      if(stethoData.length<150){
        stethoData.add(double.parse(val[i].toString()));
      }
      else{
        stethoData.removeAt(0);
        stethoData.add(double.parse(val[i].toString()));
      }
    }
    update();
  }




}