import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:m_food/a01_home/a01_01_home/a0101_home_widget.dart';
import 'package:m_food/app.dart';
import 'package:m_food/controller/category_product_controller.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/dynamic_link.dart';
import 'package:m_food/controller/news_controller.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
import 'package:m_food/controller/shared_preference_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme.dart';
import 'package:m_food/flutter_flow/flutter_flow_util.dart';
import 'package:m_food/flutter_flow/internationalization.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main3333.dart';
import 'package:m_food/main_old.dart';
import 'package:m_food/my_app.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

enum CustomerType {
  Real,
  Test,
}

class AppSettings {
  static CustomerType customerType = CustomerType.Test;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void handleDynamicLink(PendingDynamicLinkData? initialLink) {
  if (initialLink != null) {
    final Uri deepLink = initialLink.link;
    print('Received deep link: $deepLink');
    navigatorKey.currentState
        ?.pushNamed('/deeplink', arguments: deepLink.queryParameters);
  } else {
    print('nodata');
  }
}

void main() async {
  print('เวอร์ชั่นหลังจากวันที่ 17 06 2567');
  // เริ่มโปรแกรมด้วยค่าเริ่มต้นเป็น Real
  print("Initial Customer Type: ${AppSettings.customerType}");

  // ทดสอบการเปลี่ยนค่าเป็น Test
  AppSettings.customerType = CustomerType.Real;

  print("Updated Customer Type: ${AppSettings.customerType}");

  // สามารถเรียกใช้ AppSettings.customerType จากทุกที่ในโปรแกรม

  Future<String?> readDataFromSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  String dateForResetPassword = '';
  String tokenResetPassword = '';

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  await DynamicLinkProvider().initDynamicLink();
  //===============================================================
  Get.put(UserController());
  Get.put(SharedPreferenceController());
  Get.put(NewsController());
  Get.put(CustomerController());
  Get.put(ProductController());
  Get.put(ProductGroupController());
  Get.put(CategoryProductController());
  print('Main() Fuctions');
  //===============================================================
  FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) async {
    // await Fluttertoast.showToast(msg: 'มาจาก dynamic link');
    if (pendingDynamicLinkData != null) {
      final Uri deepLink = pendingDynamicLinkData.link;
      //================================================================
      String? dataDateForResetPassword =
          await readDataFromSharedPreferences('date');
      dateForResetPassword =
          dataDateForResetPassword == '' || dataDateForResetPassword == null
              ? 'No data found!'
              : dataDateForResetPassword;
      //================================================================
      String? dataTokenResetPassword =
          await readDataFromSharedPreferences('TokenResetPassword');
      tokenResetPassword =
          dataTokenResetPassword == '' || dataTokenResetPassword == null
              ? 'No data found!'
              : dataTokenResetPassword;
      //================================================================
      String textDataDateForResetPassword = dateForResetPassword;
      String textdataTokenResetPassword = tokenResetPassword;
      //================================================================
      if (deepLink.queryParameters['ref'] == textdataTokenResetPassword) {
        DateTime parsedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse(textDataDateForResetPassword);
        DateTime now = DateTime.now();
        Duration difference = now.difference(parsedDateTime);
        bool isMoreThanOneHour = difference.inHours > 1;
        //================================================================
        if (isMoreThanOneHour) {
          print('เวลาปัจจุบันมากกว่า 1 ชั่วโมง จาก DateTime.now()');
          runApp(MyApp(navigatorKey: navigatorKey));
        } else {
          print('เวลาปัจจุบันไม่เกิน 1 ชั่วโมง จาก DateTime.now()');
          await FirebaseFirestore.instance
              .collection('User')
              .where('TokenResetPassword',
                  isEqualTo: textdataTokenResetPassword)
              .get()
              .then(
            (value) {
              if (value.docs.isNotEmpty) {
                Map<String, dynamic> data =
                    value.docs.first.data() as Map<String, dynamic>;
                //================================================================
                Map<String, dynamic> to = {'ref': textdataTokenResetPassword};
                //================================================================
                navigatorKey.currentState?.pushNamed('/deeplink',
                    arguments: deepLink.queryParameters);
                //================================================================
                print('มีเอกสาร');
              } else {
                print('ไม่มีเอกสาร');
                runApp(MyApp(navigatorKey: navigatorKey));
              }
            },
          );
        }
      } else {
        runApp(MyApp(navigatorKey: navigatorKey));
      }
    }
  });

  runApp(MyApp(navigatorKey: navigatorKey));
}
