import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_food/a01_home/a01_07_password_reset/a0107_password_reset_widget.dart';

class DynamicLinkProvider {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<String> createLink(String refCode) async {
    String short = '';
    final String url = "https://com.mycompany.mfood?ref=$refCode";
    //ต้องเอา package name ไปเปิดไว้ใน dynamic link ด้วย

    print('Create Link');
    print(url);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      androidParameters: const AndroidParameters(
          packageName: "com.mycompany.mfood", minimumVersion: 0),
      iosParameters: const IOSParameters(
          bundleId: "com.mycompany.mfood", minimumVersion: "0"),
      link: Uri.parse(url),
      uriPrefix: "https://mfoodapplication.page.link",
    );
    print(parameters);
    print('after parabeter dunamiclink');
    try {
      final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;

      print(link);
      final refLink = await link.buildShortLink(parameters);
      print(refLink);
      print(refLink.shortUrl.toString());
      short = refLink.shortUrl.toString();
    } catch (r) {
      print(r);
    }
    return short;
  }

  Future<void> initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();
    print('object');
    print(instanceLink);

    if (instanceLink != null) {
      print('!= null');
      final Uri refLink = instanceLink.link;
      print(refLink.queryParameters["ref"]);
      navigatorKey.currentState
          ?.pushNamed('/deeplink', arguments: refLink.queryParameters);

      // Share.share("this i s thre link ${refLink.data}");
    } else {
      // await Fluttertoast.showToast(msg: 'fdsfdsfdsfsdfdsf');
    }
  }
}
