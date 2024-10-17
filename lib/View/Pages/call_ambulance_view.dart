import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';

import '../../Localization/app_localization.dart';
import '../../Localization/language_change_widget.dart';
import '../../app_manager/app_color.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import '../../theme/style.dart';
import 'drawer_view.dart';

class CallForAmbulanceView extends StatefulWidget {
  const CallForAmbulanceView({super.key});

  @override
  State<CallForAmbulanceView> createState() => _CallForAmbulanceViewState();
}

class _CallForAmbulanceViewState extends State<CallForAmbulanceView> {
  ThemeProviderLd themeChangeProvider = new ThemeProviderLd();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    get(context);
    super.initState();
  }

  get(context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
   getPolyPoints();
    getCurrentLocation();
  }

  //////googlemap///////////////////////////////
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCoordinates = [];


  ////get polyline///
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
   "AIzaSyB0AW2vBqSKJPqegh75EhUUxPljXPhaxqU",
    // // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  //location data
  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
          (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
          (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {
          // _markers.add(Marker(markerId: MarkerId('CurrentLocation'),
          // position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        });
      },
    );
  }
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};




  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChange.darkTheme, context);
    return Container(
      color: color.highlightColor,
      child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              drawer: MyDrawer(),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeChange.darkTheme
                          ? AppColor.neoBGGrey1
                          : Colors.grey.shade100,
                      themeChange.darkTheme
                          ? AppColor.neoBGGrey1
                          : Colors.grey.shade100,
                      themeChange.darkTheme
                          ? AppColor.neoBGGrey1
                          : Colors.grey.shade100,
                      themeChange.darkTheme
                          ? AppColor.neoBGGrey1
                          : AppColor.neoBGWhite2,
                      themeChange.darkTheme
                          ? AppColor.neoBGGrey2
                          : AppColor.neoBGWhite2,
                      themeChange.darkTheme
                          ? AppColor.neoBGGrey1
                          : Colors.grey.shade100,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                scaffoldKey.currentState!.openDrawer();
                                // masterDashboardViewModal.onPressOpenDrawer();
                              },
                              child: themeChange.darkTheme
                                  ? Image.asset(
                                "assets/lightm_patient/drawer.png"
                                    ,
                                    )
                                  : Image.asset(
                                       'assets/darkm_patient/drawer.png',
                                    )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "SOS",
                            style: MyTextTheme.largePCB.copyWith(
                              color: AppColor.red,
                            ),
                          ),
                          VerticalDivider(
                            indent: 8,
                            endIndent: 8,
                            thickness: 2,
                            color: themeChange.darkTheme
                                ? Colors.white
                                : AppColor.greyDark,
                          ),
                          Expanded(
                            child: Text("Call for Ambulance",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  color: themeChange.darkTheme
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              changeLanguage();
                            },
                            child: themeChange.darkTheme
                                ? Image.asset(
                              'assets/lightm_patient/noti.png'
                                   ,
                                  )
                                : Image.asset(
                              'assets/darkm_patient/noti.png',
                                  ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Request Accepted",
                                  style: MyTextTheme.mediumGCB.copyWith(
                                      color: themeChange.darkTheme
                                          ? Colors.grey
                                          : Colors.grey.shade500,
                                      fontSize: 18),
                                ),
                                Text(
                                  "Track Ambulance",
                                  style: MyTextTheme.largeGCB.copyWith(height: 1,
                                      color: themeChange.darkTheme
                                          ? AppColor.lightshadowColor1
                                          : AppColor.greyDark,
                                      fontSize: 22),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                                color: themeChange.darkTheme
                                    ? AppColor.greydark12
                                    : AppColor.grey,
                                onPressed: () {},
                                title: "Cancel"),
                          )
                        ],
                      ),
                    ),
                    Container(

                      height: 300,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:
                        currentLocation == null
                            ? const Center(child: Text("Loading"))
                            :
                        Container(

                          child:
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  currentLocation!.latitude!, currentLocation!.longitude!),
                              zoom: 13.5,
                            ),
                            markers: {
                          // Marker(
                          // markerId: MarkerId("currentLocation"),
                          // position: LatLng(
                          //     currentLocation!.latitude!, currentLocation!.longitude!),),
                          //     Marker(
                          //       markerId: const MarkerId("source"),
                          //
                          //       position: sourceLocation,
                          //     ),
                          //     Marker(
                          //       markerId: MarkerId("destination"),
                          //
                          //       position: destination,
                          //     ),
                            },
                            // markers: markers.values.toSet(),
                            onMapCreated: (mapController) {
                              _controller.complete(mapController);
                              },
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId("route"),
                                points: polylineCoordinates,
                                color: const Color(0xFF7B61FF),
                                width: 6,
                              ),
                            },
                          ),
                        )
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    distanceContainer(kms: "1.6 kms", time: "08 mins"),
                    SizedBox(
                      height: 10,
                    ),
                    detailContainer(
                      taxinumber: "UP32JA7005",
                      driverName: "Shripal Mehta",
                        hospitalName:
                            "ERA's Lucknow Medical College & Hospital"),
                  ]),
                ),
              ))),
    );
  }

  changeLanguage() {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(localization.getLocaleData.changeLanguage.toString()),
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LanguageChangeWidget(),
                  ],
                ),
                Positioned(
                  top: -70,
                  right: -15,
                  child: GestureDetector(
                    onTap: () {
                       Get.back();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 18.0,
                        backgroundColor: AppColor.white,
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  distanceContainer({kms, time}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChange.darkTheme, context);
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
          color: color.primaryColor,
          border: Border.all(
              color: themeChange.darkTheme
                  ? AppColor.darkshadowColor2
                  : AppColor.neoBGWhite2),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeChange.darkTheme ? AppColor.neoBGGrey1 : AppColor.white,
              themeChange.darkTheme ? AppColor.neoBGGrey1 : AppColor.white,
              themeChange.darkTheme
                  ? AppColor.neoBGGrey2
                  : AppColor.neoBGWhite2,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: themeChange.darkTheme
                  ? AppColor.darkshadowColor2
                  : AppColor.neoBGWhite2,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 5.0,
              spreadRadius: .5,
            ),
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              kms.toString(),
              style: MyTextTheme.veryLargeBCB.copyWith(
                  color: themeChange.darkTheme
                      ? AppColor.lightshadowColor1
                      : AppColor.darkshadowColor2,
                  fontSize: 30),
            ),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "away",
                style: MyTextTheme.mediumGCB
                    .copyWith(color: AppColor.darkgreen, fontSize: 16),
              ),
            )
          ],
        ),
        Text(
          "Your ambulance is nearby",
          style: MyTextTheme.mediumGCB.copyWith(
            color: themeChange.darkTheme
                ? AppColor.secondaryColorShade2
                : AppColor.grey,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.access_time,
              color: AppColor.darkgreen,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Expected to reach within",
              style: MyTextTheme.mediumGCB.copyWith(
                  color: themeChange.darkTheme
                      ? AppColor.lightshadowColor2
                      : AppColor.greyDark),
            ),
            SizedBox(
              width: 3,
            ),
            Text(time.toString(),
                style: MyTextTheme.mediumGCB
                    .copyWith(color: AppColor.darkgreen, fontSize: 16))
          ],
        )
      ]),
    );
  }

  detailContainer({hospitalName,driverName,taxinumber}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChange.darkTheme, context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              themeChange.darkTheme ? AppColor.neoBGGrey1 : AppColor.white,
              themeChange.darkTheme ? AppColor.neoBGGrey1 : AppColor.white,
              themeChange.darkTheme
                  ? AppColor.neoBGGrey2
                  : AppColor.neoBGWhite2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: themeChange.darkTheme
                  ? AppColor.greyDark
                  : AppColor.neoBGWhite2,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 5.0,
              spreadRadius: .5,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        child: Column(

          children: [
            Row(
              children: [
                themeChange.darkTheme
                    ? Image.asset(
                        'assets/darkm_patient/hospital_building.png',
                      )
                    : Image.asset(
                        'assets/lightm_patient/hospital_building.png',
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "From Hospital",
                      style: MyTextTheme.mediumGCB.copyWith(
                        color: themeChange.darkTheme
                            ? AppColor.secondaryColorShade2
                            : AppColor.grey,
                      ),
                    ),
                    Text(hospitalName.toString(),
                        style: MyTextTheme.mediumGCB.copyWith(
                            color: themeChange.darkTheme
                                ? AppColor.lightshadowColor2
                                : AppColor.greyDark))
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 72,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.green12,
                        radius: 30,
                      ),
                      Positioned(
                        top: 35,
                        right: 4,
                        child: CircleAvatar(
                          child: Image.asset("assets/car.png"),
                          maxRadius: 12,
                          backgroundColor: themeChange.darkTheme
                              ? AppColor.darkshadowColor1
                              : AppColor.lightshadowColor1,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ambulance Driver",
                        style: MyTextTheme.smallGCB.copyWith(
                          color: themeChange.darkTheme
                              ? AppColor.secondaryColorShade2
                              : AppColor.grey,
                        )),
                    Text(driverName.toString(),style: MyTextTheme.mediumGCN.copyWith(
                      fontWeight: FontWeight.w600,
                        color: themeChange.darkTheme
                            ? AppColor.lightshadowColor2
                            : AppColor.greyDark,fontSize: 16)),
                    Text(taxinumber.toString(),style: MyTextTheme.smallGCB.copyWith(color: AppColor.darkgreen),)


                  ],
                )
              ],
            ),
            Divider(
              height: 1,
              color: AppColor.secondaryColorShade2,
              thickness: 1,
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    icon: Icon(Icons.call,color:themeChange.darkTheme?AppColor.darkshadowColor2:AppColor.lightshadowColor2 ,size: 18,),
                    textStyle: MyTextTheme.mediumGCB.copyWith(color:themeChange.darkTheme?AppColor.darkshadowColor2:AppColor.lightshadowColor2 ),

                    color: themeChange.darkTheme?AppColor.green12:Colors.green.shade400,
                      
                      onPressed: (){
                  },title: "Call Hospital"),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: PrimaryButton(
                      icon: Icon(Icons.call,color:themeChange.darkTheme?AppColor.darkshadowColor2:AppColor.lightshadowColor2 ,size: 18,),
                      textStyle: MyTextTheme.mediumGCB.copyWith(color:themeChange.darkTheme?AppColor.darkshadowColor2:AppColor.lightshadowColor2 ),
                      color: themeChange.darkTheme?AppColor.green12:Colors.green.shade400,

                      onPressed: (){
                      },title: "Call Driver"),
                )
              ],
            )

          ],
        ),
      ),
    );
  }
//marker
// Marker(
//   markerId: const MarkerId("currentLocation"),
//   position: LatLng(
//       currentLocation!.latitude!, currentLocation!.longitude!),
// ),
// const Marker(
//   markerId: MarkerId("source"),
//   position: sourceLocation,
// ),
// const Marker(
//   markerId: MarkerId("destination"),
//   position: destination,
// ),
///////
//   void _add() {
//      marker1 = Marker(
//       markerId: MarkerId("currentLocation"),
//       position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//     );
//    marker2 = Marker(
//       markerId: MarkerId("source"),
//       position: sourceLocation,
//     );
//
//       marker3 = Marker(
//       markerId: MarkerId("destination"),
//       position: destination,
//     );
//
//     // if (visibility) {
//     //   markers[const MarkerId('place_name1')] = marker1;
//     //   markers[const MarkerId('place_name2')] = marker2;
//     // } else {
//     //   var blankMarker = const Marker(markerId: MarkerId(""));
//     //   markers[const MarkerId('place_name1')] = blankMarker;
//     //   markers[const MarkerId('place_name2')] = blankMarker;
//     // }
//     return;
//   }
}
