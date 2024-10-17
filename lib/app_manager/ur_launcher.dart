




import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {



 static void  launchCaller({
    required String contactNumber
}) async {
    String url = "tel:"+contactNumber.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

 static void  launchMail({
   required String mail
 }) async {
   String url = "mailto:"+mail.toString();
   if (await canLaunchUrl(Uri.parse(url))) {
     await launchUrl(Uri.parse(url));
   } else {
     throw 'Could not launch $url';
   }
 }

}