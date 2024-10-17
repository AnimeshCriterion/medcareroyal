 import 'package:flutter/cupertino.dart';

import '../assets.dart';

class BedCareConnectViewModal extends ChangeNotifier{

List bottomList=[
  {
    "title":"OTT",
    "image":ImagePaths.ott.toString()
  },
  {
    "title":"Games",
    "image":ImagePaths.games.toString()
  },
  {
    "title":"Food",
    "image":ImagePaths.food.toString()
  },
  {
    "title":"E-Book",
    "image":ImagePaths.ebook.toString()
  },
  {
    "title":"VideoChat",
    "image":ImagePaths.videoChat.toString()
  }
];
List OttList=[
  {
    "channel":"prime",
    "image":ImagePaths.prime.toString()
  },
  {
    "channel":"YouTube",
    "image":ImagePaths.youtube.toString()
  },
  {
    "channel":"Zee5",
    "image":ImagePaths.zee.toString()
  },
  {
    "channel":"sonyLiv",
    "image":ImagePaths.sonilive.toString()
  },
  {
    "channel":"AajTak",
    "image":ImagePaths.aajtak.toString()
  },
  {
    "channel":"NDTV",
    "image":ImagePaths.ndtv.toString()
  },

];

int selectedBottomIndex=0;
set updateSelectedIndex(int val){
  selectedBottomIndex=val;
  notifyListeners();
}


int subscriptionIndex = 0;
bool isIntake=true;



}

