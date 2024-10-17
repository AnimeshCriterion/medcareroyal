import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import '../../Modal/exercise_video_data_modal.dart';
import '../../app_manager/app_color.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';


class WorkOutDetails extends StatefulWidget {
  final ExerciseVideos response;
   WorkOutDetails({Key? key, required this.response}) : super(key: key);

  @override
  State<WorkOutDetails> createState() => _WorkOutDetailsState();
}

class _WorkOutDetailsState extends State<WorkOutDetails> {

 late FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(widget.response.videoURL.toString()),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flickManager.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:themeChange.darkTheme
            ? AppColor.darkshadowColor1
            : AppColor.lightshadowColor1,
        foregroundColor: themeChange.darkTheme
          ? AppColor.lightshadowColor1
          : AppColor.darkshadowColor1,
        iconTheme:   IconThemeData(color: themeChange.darkTheme
            ? AppColor.lightshadowColor1
            : AppColor.darkshadowColor1,),
        title: Row(
          children: [
            Text(widget.response.exerciseName.toString(),
              style:
              TextStyle(color:themeChange.darkTheme
                  ? AppColor.lightshadowColor1
                  : AppColor.darkshadowColor1, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeChange.darkTheme
                  ? AppColor.darkshadowColor1
                  : AppColor.lightshadowColor1,
              themeChange.darkTheme
                  ? AppColor.darkshadowColor1
                  : AppColor.lightshadowColor1,
              themeChange.darkTheme ? AppColor.black :
              AppColor.lightshadowColor2,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Get.theme.secondaryHeaderColor
                ),
                child: FlickVideoPlayer(
                    flickManager: flickManager
                ),
              ),
              Expanded(child: Html(data: widget.response.description.toString(),style: {

              },))
            ],
          ),
        ),
      )
    );
  }
}
