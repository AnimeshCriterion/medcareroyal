
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_color.dart';
//
// class InAppWebViewScreen extends StatefulWidget {
//   final String myUrl;
//   final String titleName;
//
//   const InAppWebViewScreen({Key? key, required this.myUrl,  required this.titleName, }) : super(key: key);
//   @override
//   _InAppWebViewScreenState createState() => _InAppWebViewScreenState();
// }
//
// class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
//
//   final GlobalKey webViewKey = GlobalKey();
//
//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
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
//   get(){
//     url=widget.myUrl.toString();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     get();
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
//              appBar: AppBar(title:Text(widget.titleName.toString()),backgroundColor: AppColor.primaryColor,elevation: 0,),
//             body: SafeArea(
//                 child: Stack(
//                   children: [
//                     InAppWebView(
//                       key: webViewKey,
//                       initialUrlRequest:
//                       URLRequest(url: Uri.parse(url)),
//                       initialOptions: options,
//                       pullToRefreshController: pullToRefreshController,
//                       onWebViewCreated: (controller) {
//                         webViewController = controller;
//                       },
//                       onLoadStart: (controller, url) {
//                         setState(() {
//                           this.url = url.toString();
//                           urlController.text = this.url;
//                         });
//                       },
//                       androidOnPermissionRequest: (controller, origin, resources) async {
//                         return PermissionRequestResponse(
//                             resources: resources,
//                             action: PermissionRequestResponseAction.GRANT);
//                       },
//                       shouldOverrideUrlLoading: (controller, navigationAction) async {
//                         var uri = navigationAction.request.url!;
//
//                         if (![ "http", "https", "file", "chrome",
//                           "data", "javascript", "about"].contains(uri.scheme)) {
//                           if (await canLaunch(url)) {
//                             // Launch the App
//                             await launch(
//                               url,
//                             );
//                             // and cancel the request
//                             return NavigationActionPolicy.CANCEL;
//                           }
//                         }
//
//                         return NavigationActionPolicy.ALLOW;
//                       },
//                       onLoadStop: (controller, url) async {
//                         pullToRefreshController.endRefreshing();
//                         setState(() {
//                           this.url = url.toString();
//                           urlController.text = this.url;
//                         });
//                       },
//                       onLoadError: (controller, url, code, message) {
//                         pullToRefreshController.endRefreshing();
//                       },
//                       onProgressChanged: (controller, progress) {
//                         if (progress == 100) {
//                           pullToRefreshController.endRefreshing();
//                         }
//                         setState(() {
//                           this.progress = progress / 100;
//                           urlController.text = this.url;
//                         });
//                       },
//                       onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                         setState(() {
//                           this.url = url.toString();
//                           urlController.text = this.url;
//                         });
//                       },
//                       onConsoleMessage: (controller, consoleMessage) {
//                         print(consoleMessage);
//                       },
//                     ),
//                     progress < 1.0
//                         ? LinearProgressIndicator(value: progress)
//                         : Container(),
//                   ],
//                 ))
//         ),
//       ),
//     );
//   }
// }