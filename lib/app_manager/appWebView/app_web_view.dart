
import 'dart:io';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';


import '../app_color.dart';

//
// class AppWebView extends StatefulWidget {
//   final String url;
//   final String title;
//
//   const AppWebView({Key? key, required this.url, required this.title}) : super(key: key);
//   @override
//   _AppWebViewState createState() => _AppWebViewState();
// }
//
// class _AppWebViewState extends State<AppWebView> {
//
//   final GlobalKey webViewKey = GlobalKey();
//
//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//
//       crossPlatform: InAppWebViewOptions(
//
//         userAgent: 'random',
//         useShouldOverrideUrlLoading: true,
//         mediaPlaybackRequiresUserGesture: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ));
//
//   late PullToRefreshController pullToRefreshController;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();
//
//   get() async {
//
//
//     url=widget.url.toString();
//
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     get();
//
//
//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColor.primaryColor,
//       child: SafeArea(
//         child: Scaffold(
//           // appBar: AppBar(title: Text("Fit Bit")
//           // ,automaticallyImplyLeading: false),
//             body: Stack(
//               children: [
//                 InAppWebView(
//
//                   key: webViewKey,
//                   initialUrlRequest: URLRequest(url: Uri.parse(url.toString())),
//
//
//
//                   initialOptions: options,
//                   pullToRefreshController: pullToRefreshController,
//                   onWebViewCreated: (controller) {
//                     webViewController = controller;
//
//
//                   },
//                   onLoadStart: (controller, url) {
//                     if(url.toString().contains('code=')){
//                       String code=url.toString().split('code=')[1].split('#_=_')[0].toString();
//                       if(code.toString()!=''){
//                      //    MyNavigator.pushReplacement(context, HeartRateView(code: code.toString(),));
//                         // App().replaceNavigate(context, HeartRateView(code: code.toString(),
//                         // )
//                         // );
//                       }
//                     }
//
//                     print('----------------------'+url.toString());
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   androidOnPermissionRequest: (controller, origin, resources) async {
//
//                     return PermissionRequestResponse(
//                         resources: resources,
//                         action: PermissionRequestResponseAction.GRANT);
//                   },
//                   shouldOverrideUrlLoading: (controller, navigationAction) async {
//                     var uri = navigationAction.request.url!;
//                     if (![ "http", "https", "file", "chrome",
//                       "data", "javascript", "about"].contains(uri.scheme)) {
//                       if (await canLaunchUrl(Uri.parse(url))) {
//                         // Launch the App
//                         await launchUrl(
//                           Uri.parse(url),
//                         );
//                         // and cancel the request
//                         return NavigationActionPolicy.CANCEL;
//                       }
//                     }
//
//                     return NavigationActionPolicy.ALLOW;
//                   },
//                   onLoadStop: (controller, url) async {
//
//                     pullToRefreshController.endRefreshing();
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   onLoadError: (controller, url, code, message) {
//                     pullToRefreshController.endRefreshing();
//                   },
//                   onProgressChanged: (controller, progress) {
//                     if (progress == 100) {
//                       pullToRefreshController.endRefreshing();
//                     }
//                     setState(() {
//                       this.progress = progress / 100;
//                       urlController.text = this.url;
//                     });
//                   },
//                   onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   onConsoleMessage: (controller, consoleMessage) {
//                     print(consoleMessage);
//                   },
//                 ),
//                 progress < 1.0
//                     ? LinearProgressIndicator(value: progress) : Container(),
//               ],
//             )
//         ),
//       ),
//     );
//   }
// }