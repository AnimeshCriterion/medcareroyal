import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../Localization/app_localization.dart';
import '../../ViewModal/MasterDashoboardViewModal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/navigator.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'drawer_view.dart';
import '../../theme/style.dart';

class HomeCareTrainingView extends StatefulWidget {
  const HomeCareTrainingView({super.key});

  @override
  State<HomeCareTrainingView> createState() => _HomeCareTrainingViewState();
}

class _HomeCareTrainingViewState extends State<HomeCareTrainingView> {
  int _value = 0;
  late VideoPlayerController _controller;
  ThemeProviderLd themeChangeProvider = new ThemeProviderLd();

  @override
  void initState() {
    super.initState();
    get();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
  }

  get() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  int selectedTabIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChangeProvider.darkTheme, context);
    MasterDashboardViewModal masterDashboardViewModal =
        Provider.of<MasterDashboardViewModal>(context, listen: true);

    List widgetList = [
      trainingVideo(),
      gameWidget(),
      searchWidget(),
      educationWidget(),
      Text("Coming Soon"),
    ];
    var containerColor1 = themeChange.darkTheme == true
        ? AppColor.veryLightGreen.withOpacity(0.1)
        : Colors.green.shade100;
    var containerColor2 =
        themeChange.darkTheme == true ? AppColor.neoBGGrey2 : Colors.white24;
    var imagecolor1 =
        themeChange.darkTheme == true ? AppColor.darkgreen : Colors.green;
    var imagecolor2 = themeChange.darkTheme == true ? Colors.grey : Colors.grey;
    return ColoredSafeArea(
        child: SafeArea(
          child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                onTap: (val) {
                  setState(() {
                    selectedTabIndex = val;
                  });
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    backgroundColor: themeChange.darkTheme == true
                        ? AppColor.neoBGGrey2
                        : AppColor.neoBGWhite1,
                    icon: Container(
                        decoration: BoxDecoration(
                            color: selectedTabIndex == 0
                                ? containerColor1
                                : containerColor2,
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/home_care_training/video_icon.png",
                          color:
                              selectedTabIndex == 0 ? imagecolor1 : imagecolor2,
                        )),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                          color: selectedTabIndex == 1
                              ? containerColor1
                              : containerColor2,
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/home_care_training/vector_remote.png",
                        color:
                            selectedTabIndex == 1 ? imagecolor1 : imagecolor2,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: themeChange.darkTheme == true
                                  ? AppColor.lightshadowColor2
                                  : AppColor.white,
                              width: 1),
                          color: selectedTabIndex == 2
                              ? AppColor.darkgreen
                              : AppColor.grey.withOpacity(.3),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Icon(Icons.search_rounded,
                            color: selectedTabIndex == 2
                                ? AppColor.lightshadowColor2
                                : themeChange.darkTheme == true
                                    ? AppColor.lightshadowColor2
                                    : AppColor.greyDark,
                            size: 32)),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                          color: selectedTabIndex == 3
                              ? containerColor1
                              : containerColor2,
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/home_care_training/education.png",
                        color:
                            selectedTabIndex == 3 ? imagecolor1 : imagecolor2,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                        decoration: BoxDecoration(
                            color: selectedTabIndex == 4
                                ? containerColor1
                                : containerColor2,
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/home_care_training/chart_graph.png",
                          color:
                              selectedTabIndex == 4 ? imagecolor1 : imagecolor2,
                        )),
                    label: '',
                  ),
                ],
              ),
              key: scaffoldKey,
              drawer: MyDrawer(),
              // resizeToAvoidBottomInset: false,
              backgroundColor: color.scaffoldBackgroundColor,
              // appBar: CustomAppBar(
              //   title:localization.getLocaleData.symptomTracker.toString(),color: AppColor.primaryColor,
              //     titleColor: AppColor.white,
              //     primaryBackColor: AppColor.white
              // ),
              body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      themeChange.darkTheme == true
                          ? AppColor.neoBGGrey2
                          : AppColor.neoBGWhite1,
                      themeChange.darkTheme == true
                          ? AppColor.neoBGGrey2
                          : AppColor.neoBGWhite2,
                      themeChange.darkTheme == true
                          ? AppColor.neoBGGrey2
                          : AppColor.neoBGWhite1,
                      themeChange.darkTheme == true
                          ? AppColor.neoBGGrey1
                          : AppColor.neoBGWhite1,
                      themeChange.darkTheme == true
                          ? AppColor.neoBGGrey1
                          : AppColor.neoBGWhite1,
                    ])),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                  child: Image.asset(
                                      themeChange.darkTheme == true
                                          ? ImagePaths.menuDark
                                          : ImagePaths.menulight,
                                      height: 40)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localization.getLocaleData.medcareRoyal.toString(),
                                    style: MyTextTheme().largePCB.copyWith(
                                        fontSize: 21,
                                        height: 0,
                                        color: themeChange.darkTheme == true
                                            ? Colors.white70
                                            : Colors.grey.shade600),
                                  ),
                                  Text(
                                    localization.getLocaleData.training.toString(),
                                    style: MyTextTheme().largeBCB.copyWith(
                                        fontSize: 35,
                                        height: 1,
                                        color: themeChange.darkTheme == true
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: widgetList[selectedTabIndex])
                  ],
                ),
              )
          ),
        ));
  }

  trainingVideo() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: ListView(children: [
              PrimaryTextField(
                borderColor: AppColor.white,
                onChanged: (val) async {
                  setState(() {});
                },
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor.grey,
                  size: 28,
                ),

                hintText: localization.getLocaleData.searchDisease.toString(),
                hintTextColor: themeChange.darkTheme == true
                    ? Colors.grey.shade400
                    : Colors.grey.shade400,
                // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              videoWidget(
                  title: localization.getLocaleData.medcareRoyalTutorialVideo,
                  subtext: localization.getLocaleData.medcareRoyalTutorial.toString())
            ]),
          ),
        ),
      ],
    );
  }

  gameWidget() {

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
            'assets/home_care_training/rectangle.png',
          ))),
          child: Image.asset(
            "assets/home_care_training/doctor_dash.png",
            width: 360,

          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.getLocaleData.doctorDashHospitalGame.toString(),
                style: MyTextTheme().mediumGCB.copyWith(
                    fontSize: 15,
                    color: themeChange.darkTheme == true
                        ? AppColor.lightshadowColor2
                        : AppColor.greyDark),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: MyTextTheme().mediumGCN.copyWith(
                    color: themeChange.darkTheme == true
                        ? AppColor.lightshadowColor2
                        : AppColor.greyDark),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style: MyTextTheme().smallGCN.copyWith(
                    color: themeChange.darkTheme == true
                        ? AppColor.lightshadowColor2
                        : AppColor.greyDark),
              )
            ],
          ),
        )
      ],
    );
  }

  searchWidget() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            children: [
              Image.asset("assets/home_care_training/virus.png"),
              PrimaryTextField(
                backgroundColor: themeChange.darkTheme == true
                    ? AppColor.greyDark.withOpacity(.5)
                    : AppColor.white,
                borderColor: themeChange.darkTheme == true
                    ? AppColor.darkshadowColor2
                    : AppColor.white,
                onChanged: (val) async {
                  setState(() {});
                },
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor.grey,
                  size: 28,
                ),
                hintText: localization.getLocaleData.searchDisease.toString(),
                hintTextColor: themeChange.darkTheme == true
                    ? Colors.grey
                    : Colors.grey.shade600,
                // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
              ),
            ],
          ),
        )
      ],
    );
  }

  educationWidget() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color:themeChange.darkTheme? AppColor.greyDark:Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10)),
        child:ListView.builder(
          itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text((index+1).toString()+". ", style: MyTextTheme().smallGCN.copyWith(
                        color: themeChange.darkTheme == true
                            ? AppColor.lightshadowColor1
                            : AppColor.greyDark)),
                    Expanded(
                      child:   Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        style: MyTextTheme().smallGCN.copyWith(
                            color: themeChange.darkTheme == true
                                ? AppColor.lightshadowColor2
                                : AppColor.greyDark),
                      ),
                    )
                  ],),
                  StaggeredGrid.count(
                    crossAxisCount: 2,children:  List.generate(4, (index) =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Radio(value: index,
                              activeColor: Colors.green,

                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  _value = value as int;
                                });
                              }),
                          Text("Lorem ipsum",style: MyTextTheme().smallGCN.copyWith(
                              color: themeChange.darkTheme == true
                                  ? AppColor.lightshadowColor1
                                  : AppColor.greyDark))
                        ],)))
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  videoWidget({title, subtext}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChangeProvider.darkTheme, context);
    // late VideoPlayerController _controller;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          children: List.generate(3,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(12)),
                          height: 150,
                          child:  CachedNetworkImage(
                            imageUrl:"https://nutrianalyser.com:313/FileUpload/Thumbnail/2024631644330.jpg",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius: BorderRadius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ' ',
                                                  style: TextStyle(color: AppColor.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            placeholder: (context, url) =>Container(
                              decoration:  BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                color: AppColor.green,
                              ),
                              // child: Image.asset(
                              //   "assets/" + ImageConstant().defaultBlogImage.toString(),
                              //   fit: BoxFit.cover,
                              // )
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(' ',
                                                  style: TextStyle(color:AppColor.white,),
                                                ),
                                                // const SizedBox(height: 5),
                                                // Text(
                                                //   response.exerciseName.toString(),
                                                //   style: TextStyle(color: AppColor.white,),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration:  BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                color: AppColor.primaryColor,
                              ),
                              // child: Image.asset(
                              //   "assets/" + ImageConstant().defaultBlogImage.toString(),
                              //   fit: BoxFit.cover,
                              // )
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(' ',
                                                  style: TextStyle(color:AppColor.white,),
                                                ),
                                                // const SizedBox(height: 5),
                                                // Text(
                                                //   response.exerciseName.toString(),
                                                //   style: TextStyle(color: AppColor.white,),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        title.toString(),
                        style: MyTextTheme().mediumBCB.copyWith(
                              color: themeChange.darkTheme == true
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        subtext.toString(),
                        style: MyTextTheme().mediumGCN.copyWith(
                            color: themeChange.darkTheme == true
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            height: 1),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ))),
    );
    // Center(
    // child:_controller.value.isInitialized?
    // AspectRatio(aspectRatio: _controller.value.aspectRatio,
    //   child:VideoPlayer(_controller) ,):
    //     Container()
    // );
  }
}
