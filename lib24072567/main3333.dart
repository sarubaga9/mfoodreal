// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/instance_manager.dart';
// import 'package:m_food/a01_home/a01_01_home/a0101_home_widget.dart';
// import 'package:m_food/controller/category_product_controller.dart';
// import 'package:m_food/controller/customer_controller.dart';
// import 'package:m_food/controller/dynamic_link.dart';
// import 'package:m_food/controller/news_controller.dart';
// import 'package:m_food/controller/shared_preference_controller.dart';
// import 'package:m_food/controller/user_controller.dart';
// import 'package:m_food/flutter_flow/flutter_flow_theme.dart';
// import 'package:m_food/flutter_flow/flutter_flow_util.dart';
// import 'package:m_food/flutter_flow/internationalization.dart';
// import 'package:m_food/index.dart';
// import 'package:m_food/main_old.dart';
// import 'package:m_food/widgets/circular_loading.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();

// //   final appState = FFAppState(); // Initialize FFAppState
// //   await appState.initializePersistedState();

// //   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// //   // runApp(MyApp());
// //   Get.put(UserController());
// //   Get.put(SharedPreferenceController());
// //   Get.put(NewsController());
// //   print('is load in Main()');
// //   // await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

// //   // Check if you received the link via `getInitialLink` first
// //   final PendingDynamicLinkData? initialLink =
// //       await FirebaseDynamicLinks.instance.getInitialLink();

// //   if (initialLink != null) {
// //     final Uri deepLink = initialLink.link;
// //     // Example of using the dynamic link to push the user to a different screen
// //     print(deepLink.path);
// //     navigatorKey.currentState?.pushNamed(deepLink.path);
// //     // Navigator.pushNamed(context, deepLink.path);
// //   }

// //   FirebaseDynamicLinks.instance.onLink.listen(
// //     (pendingDynamicLinkData) {
// //       // Set up the `onLink` event listener next as it may be received here
// //       if (pendingDynamicLinkData != null) {
// //         final Uri deepLink = pendingDynamicLinkData.link;
// //         // Example of using the dynamic link to push the user to a different screen
// //         // Navigator.pushNamed(context, deepLink.path);
// //         print(deepLink.path);
// //         navigatorKey.currentState?.pushNamed(deepLink.path);
// //       }
// //     },
// //   );
// //   runApp(ChangeNotifierProvider(
// //     create: (context) => appState,
// //     child: MyApp(),
// //   ));
// //   // runApp(MyApp(initialLink));
// // }

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void handleDynamicLink(PendingDynamicLinkData? initialLink) {
//   if (initialLink != null) {
//     final Uri deepLink = initialLink.link;
//     // Handle the deep link as needed
//     print('deeplink from email');
//     print('Received deep link: $deepLink');
//     print(deepLink.queryParameters);

//     navigatorKey.currentState
//         ?.pushNamed('/deeplink', arguments: deepLink.queryParameters);
//   } else {
//     print('nodata');
//   }
// }

// void main() async {
//   //=========================================================================
//   Future<String?> readDataFromSharedPreferences(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }

//   String dateForResetPassword = '';
//   String tokenResetPassword = '';

//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   // final appState = FFAppState(); // Initialize FFAppState
//   // await appState.initializePersistedState();

//   await DynamicLinkProvider().initDynamicLink();
//   // runApp(MyApp());
//   Get.put(UserController());
//   Get.put(SharedPreferenceController());
//   Get.put(NewsController());
//   Get.put(CustomerController());
//   Get.put(CategoryProductController());
//   print('is load in Main()');

//   // FirebaseDynamicLinks.instance.onLink.listen(
//   //   (pendingDynamicLinkData) {
//   //     // Set up the `onLink` event listener next as it may be received here
//   //     print('object222222');
//   //     if (pendingDynamicLinkData != null) {
//   //       final Uri deepLink = pendingDynamicLinkData.link;
//   //       // Example of using the dynamic link to push the user to a different screen
//   //       // Navigator.pushNamed(context, deepLink.path);
//   //       print(deepLink.queryParameters["ref"]);
//   //       // // navigatorKey.currentState?.pushNamed(deepLink.path);
//   //       // navigatorKey.currentState?.push(CupertinoPageRoute(
//   //       //   builder: (context) => A0107PasswordResetWidget(),
//   //       // ));
//   //       runApp(A0107PasswordResetWidget());
//   //     } else {
//   //       runApp(ChangeNotifierProvider(
//   //         create: (context) => appState,
//   //         child: MyApp(),
//   //       ));
//   //     }
//   //   },
//   // );
//   // Set up dynamic links

//   // final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
//   // handleDynamicLink(initialLink);
//   // print('prrrr');

//   // final PendingDynamicLinkData? initialLink =
//   //     await FirebaseDynamicLinks.instance.getInitialLink();

//   // if (initialLink != null) {
//   //   final Uri deepLink = initialLink.link;
//   //   // Example of using the dynamic link to push the user to a different screen
//   //   print(deepLink.path);
//   //   navigatorKey.currentState
//   //       ?.pushNamed('/deeplink', arguments: deepLink.queryParameters);
//   //   // Navigator.pushNamed(context, deepLink.path);
//   // }

//   FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) async {
//     await Fluttertoast.showToast(msg: 'มาจาก dynamic link');
//     print('1232432131213');
//     print(pendingDynamicLinkData);
//     print('deeplink from email');

//     if (pendingDynamicLinkData != null) {
//       final Uri deepLink = pendingDynamicLinkData.link;
//       print('Received deep link: $deepLink');
//       print(deepLink.queryParameters);

//       //================================================================
//       print('is load in restepassword');
//       String? dataDateForResetPassword =
//           await readDataFromSharedPreferences('date');
//       dateForResetPassword =
//           dataDateForResetPassword == '' || dataDateForResetPassword == null
//               ? 'No data found!'
//               : dataDateForResetPassword;

//       String? dataTokenResetPassword =
//           await readDataFromSharedPreferences('TokenResetPassword');
//       tokenResetPassword =
//           dataTokenResetPassword == '' || dataTokenResetPassword == null
//               ? 'No data found!'
//               : dataTokenResetPassword;

//       print('shared preference');

//       String textDataDateForResetPassword = dateForResetPassword;
//       String textdataTokenResetPassword = tokenResetPassword;

//       print(textDataDateForResetPassword);
//       print(textdataTokenResetPassword);

//       if (deepLink.queryParameters['ref'] == textdataTokenResetPassword) {
//         DateTime parsedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
//             .parse(textDataDateForResetPassword);
//         // สร้าง Duration ที่เท่ากับ 1 ชั่วโมง
//         Duration oneHour = Duration(hours: 1);

//         // เปรียบเทียบว่าเวลาปัจจุบันเกินจาก existingDateTime มากกว่า 1 ชั่วโมงหรือไม่
//         // bool isMoreThanOneHour = parsedDateTime.difference(DateTime.now()) > oneHour;

//         DateTime now = DateTime.now();
//         Duration difference = now.difference(parsedDateTime);

//         bool isMoreThanOneHour = difference.inHours > 1;

//         if (isMoreThanOneHour) {
//           print('เวลาปัจจุบันมากกว่า 1 ชั่วโมง จาก DateTime.now()');
//           runApp(MyApp(navigatorKey: navigatorKey));
//         } else {
//           print('เวลาปัจจุบันไม่เกิน 1 ชั่วโมง จาก DateTime.now()');
//           await FirebaseFirestore.instance
//               .collection('User')
//               .where('TokenResetPassword',
//                   isEqualTo: textdataTokenResetPassword)
//               .get()
//               .then((value) {
//             if (value.docs.isNotEmpty) {
//               // มีเอกสาร
//               Map<String, dynamic> data =
//                   value.docs.first.data() as Map<String, dynamic>;
//               // print(data);
//               Map<String, dynamic> to = {'ref': textdataTokenResetPassword};
//               // if (navigatorKey.currentContext != null) {
//               //   Navigator.of(navigatorKey.currentContext!)
//               //       .pushNamed('/deeplink', arguments: to);
//               // }
//               // navigatorKey.currentState?.pushNamed('/deeplink', arguments: to);
//               // runApp(MyApp(
//               //     navigatorKey: navigatorKey,
//               //     initialRoute: '/deeplink',
//               //     initialRouteArgs: to));

//               navigatorKey.currentState
//                   ?.pushNamed('/deeplink', arguments: deepLink.queryParameters);

//               // runApp(MyApp(
//               //   navigatorKey: navigatorKey,
//               //   initialRoute: '/deeplink',
//               //   initialRouteArgs: to,
//               // ));
//               print(to);
//               print(to);
//               print('มีเอกสาร');
//             } else {
//               // ไม่มีเอกสาร
//               print('ไม่มีเอกสาร');
//               runApp(MyApp(navigatorKey: navigatorKey));
//             }
//           });
//         }
//       } else {
//         runApp(MyApp(navigatorKey: navigatorKey));
//       }
//     }
//   });

//   runApp(MyApp(navigatorKey: navigatorKey));

//   // runApp(ChangeNotifierProvider(
//   //   create: (context) {
//   //     return FFAppState(); // Initialize FFAppState
//   //   },
//   //   child: MyApp(),
//   // ));

//   // FirebaseDynamicLinks.instance.onLink.listen(
//   //   (pendingDynamicLinkData) {
//   //     // Set up the `onLink` event listener next as it may be received here
//   //     print('object222222');
//   //     if (pendingDynamicLinkData != null) {
//   //       final Uri deepLink = pendingDynamicLinkData.link;
//   //       print('a');
//   //       print(deepLink.queryParameters["ref"]);
//   //       // Use the stored appContext to push a new page
//   //       Navigator.pushNamed(appContext!, '/deeplink');

//   //       print(deepLink.queryParameters["ref"]);
//   //     } else {
//   //       runApp(ChangeNotifierProvider(
//   //         create: (context) {
//   //           appContext = context; // Store the context
//   //           return FFAppState(); // Initialize FFAppState
//   //         },
//   //         child: MyApp(),
//   //       ));
//   //     }
//   //   },
//   // );
// }

// class MyApp extends StatefulWidget {
//   final GlobalKey<NavigatorState> navigatorKey;
//   final Map<String, dynamic>? initialRouteArgs;
//   final String? initialRoute;

//   const MyApp({
//     Key? key,
//     required this.navigatorKey,
//     this.initialRouteArgs,
//     this.initialRoute,
//   }) : super(key: key);
//   // final GlobalKey<NavigatorState> navigatorKey;

//   // const MyApp({required this.navigatorKey});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final userController = Get.find<
//       UserController>(); //=========================================================================
//   late FirebaseMessaging messaging;
// //=========================================================================
//   //message for sharedpreference
//   String message = '';

// //=========================================================================
//   String messageNotifications = '';
// //=========================================================================
//   Locale? _locale;
//   ThemeMode _themeMode = ThemeMode.system;
//   bool isLoading = false;

//   final categoryProductController = Get.find<CategoryProductController>();
//   RxMap<String, dynamic>? userData;
//   RxMap<String, dynamic>? employeeData;

//   //=========================================================================
//   Future<String?> readDataFromSharedPreferences(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }

// //=========================================================================
//   bool isNumeric(String str) {
//     if (str == null || str.isEmpty) {
//       return false;
//     }

//     return double.tryParse(str) != null;
//   }

//   //=========================================================================
//   isLoadingData() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       //================================================================

//       messaging = FirebaseMessaging.instance;
//       //================================================================
//       print('is load in mYapp');
//       String? data = await readDataFromSharedPreferences('message_key');
//       message = data == '' || data == null ? 'No data found!' : data;

//       print('shared preference');
//       print(message);

//       String text = message;
//       bool isAllNumeric = isNumeric(text);
// //=========================================================================
//       if (isAllNumeric) {
//         print('ข้อความนี้มีเป็นตัวเลขทั้งหมด');
//         print(message);
//         await FirebaseFirestore.instance
//             .collection('User')
//             .doc(message)
//             .get()
//             .then((DocumentSnapshot<Map<String, dynamic>> value) async {
//           if (value.exists) {
//             final Map<String, dynamic> employeeMap =
//                 value.data() as Map<String, dynamic>;
//             await userController.updateUserDataPhone(value);
//           } else {
//             await FirebaseFirestore.instance
//                 .collection('User')
//                 .where('Phone', isEqualTo: message)
//                 .get()
//                 .then((QuerySnapshot querySnapshot) async {
//               querySnapshot.docs.forEach(
//                 (doc) async {
//                   // ดึงข้อมูลจากเอกสารแต่ละรายการ
//                   var data = doc.data();
//                   Map<String, dynamic>? dataMap =
//                       doc.data() as Map<String, dynamic>?;
//                   await userController.updateUserDataUsername(dataMap);
//                 },
//               );
//             }).catchError((error) {
//               print("เกิดข้อผิดพลาด: $error");
//             });
//           }
//         });
//       } else {
//         print('ข้อความนี้เป็นตัวอักษร');
//         await FirebaseFirestore.instance
//             .collection('User')
//             .where('Username', isEqualTo: message)
//             .get()
//             .then(
//           (QuerySnapshot querySnapshot) async {
//             querySnapshot.docs.forEach(
//               (doc) async {
//                 Map<String, dynamic>? dataMap =
//                     doc.data() as Map<String, dynamic>?;
//                 // print(dataMap!['UserAppointment'].length.toString());
//                 await userController.updateUserDataUsername(dataMap);
//                 // dataMap!['Level'] == 'Employee'
//                 //     ? await FirebaseFirestore.instance
//                 //         .collection('User')
//                 //         .doc(userController.userData!['UserID'])
//                 //         .collection('Employee')
//                 //         .doc(userController.userData!['UserID'])
//                 //         .get()
//                 //         .then(
//                 //         (DocumentSnapshot<Map<String, dynamic>> value) async {
//                 //           await userController.updateEmployeeData(value);
//                 //         },
//                 //       )
//                 //     : print(dataMap['Level']);

//                 await messaging.requestPermission();
//               },
//             );
//           },
//         );
//       }
// //=========================================================================
//       userData = userController.userData;
//       employeeData = userController.employeeData;
// //=========================================================================
//       if (message == 'No data found!') {
//       } else {
//         while (userData!.isEmpty) {
//           // ทำสิ่งที่คุณต้องการในลูปนี้
//           // ตรวจสอบค่าหรือทำการกำหนดค่าให้ targetValue
//           // เมื่อค่าไม่เท่ากับ null ให้ลูปหยุด
//           await Future.delayed(Duration(seconds: 3));
//         }
//       }

// //=========================================================================
//     } catch (e) {
//     } finally {
//       if (userData!.isNotEmpty) {
//         print('LOAD DATA CONPLETE IN MYAPP');
//         // print(userData!.isNotEmpty);
//         // print('LOAD DATA CONPLETE IN MYAPP');
//         // print('is load in muapp');
//         if (mounted) {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             isLoading = false;
//           });
//         }
//         print('LOAD DATA CONPLETE IN MYAPP');
//         // print(userData!.isNotEmpty);
//         // print('LOAD DATA CONPLETE IN MYAPP');
//         // print('is load in muapp');
//       }
//     }
//   }

// //=========================================================================
//   @override
//   void initState() {
//     // Navigator.of(context).pushNamed(
//     //   '/deeplink',
//     //   arguments: widget.initialRouteArgs,
//     // );

//     // navigatorKey.currentState

//     // ?.pushNamed('/deeplink', arguments: {'ref': widget.initialRoute});

//     print('initstate');
//     print(widget.initialRoute);
//     print(widget.initialRouteArgs);

//     // WidgetsBinding.instance?.addPostFrameCallback((_) {
//     //   // ให้เรียก pushNamed ใน addPostFrameCallback เพื่อให้ build กำลังจะเสร็จสิ้น
//     //   navigatorKey.currentState!.pushNamed(
//     //     widget.initialRoute!,
//     //     arguments: widget.initialRouteArgs,
//     //   );
//     // });
//     isLoadingData2();
//     isLoadingData();
//     // TODO: implement initState
//     super.initState();
//   }

//   isLoadingData2() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       await updateUser();

//       await FirebaseFirestore.instance
//           .collection('CategoryProduct')
//           .get()
//           .then((QuerySnapshot<Map<String, dynamic>>? querySnapshot) async {
//         await categoryProductController
//             .updateCategoryProductsData(querySnapshot);
//       });

// //       messaging = FirebaseMessaging.instance;
// //       print('is load in mYapp');
// //       String? data = await readDataFromSharedPreferences('message_key');
// //       message = data == '' || data == null ? 'No data found!' : data;

// //       print('shared preference');
// //       print(message);

// //       String text = message;
// //       bool isAllNumeric = isNumeric(text);
// // //=========================================================================
// //       // print(isAllNumeric.toString());
// //       if (isAllNumeric) {
// //         print('ข้อความนี้มีเป็นตัวเลขทั้งหมด');
// //         print(message);
// //         await FirebaseFirestore.instance
// //             .collection('1000')
// //             .doc('Company')
// //             .collection('User')
// //             .doc(message)
// //             .get()
// //             .then((DocumentSnapshot<Map<String, dynamic>> value) async {
// //           // print(value);
// //           // print(value.exists);
// //           if (value.exists) {
// //             // print('111');
// //             final Map<String, dynamic> employeeMap =
// //                 value.data() as Map<String, dynamic>;
// //             await userController.updateUserDataPhone(value);
// //             // print('suptopic');
// //             // print(userData!['Level']);
// //             // userData!['Level'] == 'User'
// //             //     ? await messaging.subscribeToTopic("User")
// //             //     : print('is Employee');
// //             // print('suptopic');

// //             // messaging.requestPermission();
// //           } else {
// //             // print('222');
// //             await FirebaseFirestore.instance
// //                 .collection('1000')
// //                 .doc('Company')
// //                 .collection('User')
// //                 .where('Phone', isEqualTo: message)
// //                 .get()
// //                 .then((QuerySnapshot querySnapshot) async {
// //               querySnapshot.docs.forEach(
// //                 (doc) async {
// //                   // ดึงข้อมูลจากเอกสารแต่ละรายการ
// //                   var data = doc.data();
// //                   Map<String, dynamic>? dataMap =
// //                       doc.data() as Map<String, dynamic>?;
// //                   // await userController.updateUserDataPhone();
// //                   await userController.updateUserDataUsername(dataMap);
// //                   // print('suptopic');
// //                   // print(userData!['Level']);
// //                   // userData!['Level'] == 'User'
// //                   //     ? await messaging.subscribeToTopic("User")
// //                   //     : print('is Employee');
// //                   // print('suptopic');

// //                   // messaging.requestPermission();
// //                   // setState(() {
// //                   //   // print('before');
// //                   //   // print(message);
// //                   //   message = dataMap!['UserID'];
// //                   //   // print(message);
// //                   // });
// //                 },
// //               );
// //             }).catchError((error) {
// //               print("เกิดข้อผิดพลาด: $error");
// //             });
// //           }
// //         });
// //       } else {
// //         print('ข้อความนี้เป็นตัวอักษร');
// //         await FirebaseFirestore.instance
// //             .collection('1000')
// //             .doc('Company')
// //             .collection('User')
// //             .where('Username', isEqualTo: message)
// //             .get()
// //             .then(
// //           (QuerySnapshot querySnapshot) async {
// //             querySnapshot.docs.forEach(
// //               (doc) async {
// //                 Map<String, dynamic>? dataMap =
// //                     doc.data() as Map<String, dynamic>?;
// //                 // print(dataMap!['UserAppointment'].length.toString());
// //                 await userController.updateUserDataUsername(dataMap);
// //                 dataMap!['Level'] == 'Employee'
// //                     ? await FirebaseFirestore.instance
// //                         .collection('1000')
// //                         .doc('Company')
// //                         .collection('User')
// //                         .doc(userController.userData!['UserID'])
// //                         .collection('Employee')
// //                         .doc(userController.userData!['UserID'])
// //                         .get()
// //                         .then(
// //                         (DocumentSnapshot<Map<String, dynamic>> value) async {
// //                           await userController.updateEmployeeData(value);
// //                         },
// //                       )
// //                     : print(dataMap['Level']);

// //                 // print('suptopic');
// //                 // print(userData!['Level']);
// //                 // userData!['Level'] == 'User'
// //                 //     ? await messaging.subscribeToTopic("User")
// //                 //     : print('is Employee');
// //                 // print('suptopic');

// //                 await messaging.requestPermission();

// //                 // setState(() {
// //                 //   message = dataMap['UserID'];
// //                 // });
// //               },
// //             );
// //           },
// //         );
// //       }
// // //=========================================================================
// //       userData = userController.userData;
// //       employeeData = userController.employeeData;
// // //=========================================================================
// //       if (message == 'No data found!') {
// //       } else {
// //         while (userData!.isEmpty) {
// //           // ทำสิ่งที่คุณต้องการในลูปนี้
// //           // ตรวจสอบค่าหรือทำการกำหนดค่าให้ targetValue
// //           // เมื่อค่าไม่เท่ากับ null ให้ลูปหยุด
// //           await Future.delayed(Duration(seconds: 3));
// //         }
// //       }

// // //=========================================================================
//     } catch (e) {
//     } finally {
//       // if (userData!.isNotEmpty) {
//       //   print('LOAD DATA CONPLETE IN MYAPP');
//       //   // print(userData!.isNotEmpty);
//       //   // print('LOAD DATA CONPLETE IN MYAPP');
//       //   // print('is load in muapp');
//       //   if (mounted) {
//       //     setState(() {
//       //       isLoading = false;
//       //     });
//       //   }
//       // } else {
//       //   if (mounted) {
//       //     setState(() {
//       //       isLoading = false;
//       //     });
//       //   }
//       //   print('LOAD DATA CONPLETE IN MYAPP');
//       //   // print(userData!.isNotEmpty);
//       //   // print('LOAD DATA CONPLETE IN MYAPP');
//       //   // print('is load in muapp');
//       // }
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> updateUser() async {
//     print('UP Category Product');
//     List<Map<String, dynamic>> categorys = [
//       {
//         'CategoryId': '1',
//         'NameCategory': 'อาหารทะเลแปรรูปแบบต้ม',
//         'ImageUrl': '',
//         // 'ListOfCategory': List<dynamic>.from(listOfCategory!),
//         // 'ListImageGroup': List<dynamic>.from(listImageGroup!),
//         'ListOfCategory': [],
//         'ListImageGroup': [],
//       },
//       {
//         'CategoryId': '2',
//         'NameCategory': 'อาหารทะเลแปรรูปแบบทอด',
//         'ImageUrl': '',
//         // 'ListOfCategory': List<dynamic>.from(listOfCategory!),
//         // 'ListImageGroup': List<dynamic>.from(listImageGroup!),
//         'ListOfCategory': [],
//         'ListImageGroup': [],
//       },
//       {
//         'CategoryId': '3',
//         'NameCategory': 'น้ำพริก น้ำจิ้ม',
//         'ImageUrl': '',
//         // 'ListOfCategory': List<dynamic>.from(listOfCategory!),
//         // 'ListImageGroup': List<dynamic>.from(listImageGroup!),
//         'ListOfCategory': [],
//         'ListImageGroup': [],
//       },
//       {
//         'CategoryId': '4',
//         'NameCategory': 'อาหารฮาลาล',
//         'ImageUrl': '',
//         // 'ListOfCategory': List<dynamic>.from(listOfCategory!),
//         // 'ListImageGroup': List<dynamic>.from(listImageGroup!),
//         'ListOfCategory': [],
//         'ListImageGroup': [],
//       },
//       {
//         'CategoryId': '5',
//         'NameCategory': 'อาหารแปรรูป',
//         'ImageUrl': '',
//         // 'ListOfCategory': List<dynamic>.from(listOfCategory!),
//         // 'ListImageGroup': List<dynamic>.from(listImageGroup!),
//         'ListOfCategory': [],
//         'ListImageGroup': [],
//       },
//     ];
//     print(categorys);
//     try {
//       // print('0824788384');
//       // await FirebaseFirestore.instance
//       //     .collection('1000')
//       //     .doc('Company')
//       //     .collection('User')
//       //     .doc('0824788384')
//       //     .collection('chat')
//       //     .doc('Admin1')
//       //     .set(
//       //   {'message': messages},
//       // );

//       await FirebaseFirestore.instance
//           .collection('CategoryProduct')
//           .doc('food')
//           .set(
//         {
//           'food': categorys,
//         },
//       );
//     } catch (e) {
//       debugPrint(e.toString());
//     }

//     // List<NewsModel> yourDataList = [
//     //   NewsModel(
//     //     id: "1",
//     //     title: "กำจัดปลวกด้วยการวางท่อ",
//     //     detail:
//     //         "วิธีนี้เป็นการวางระบบท่อเข้าไปบริเวณใต้พื้นของบ้านหรืออาคารตามแนว...",
//     //     by: "ผู้โพสต์ที่ 1",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/003-News-Pic.png",
//     //       "assets/images/003-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "2",
//     //     title: "กำจัดปลวกราคาเท่าไหร่?",
//     //     detail:
//     //         "เมื่อปลวกขื้นบ้านหลายท่านคงพยายามหาวิธีแก้ไข และ กำจัดปลวกบางคน อาจ",
//     //     by: "ผู้โพสต์ที่ 2",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/004-News-Pic.png",
//     //       "assets/images/004-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "3",
//     //     title: "ฆ่าราชินีปลวกจะเร็จไหม",
//     //     detail:
//     //         "เมื่อพบปัญาปลวกขื้นบ้านหลายท่านเสาะหาวิธีกำจัดปลวกที่บอกต่อกันว่า",
//     //     by: "ผู้โพสต์ที่ 3",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/005-News-Pic.png",
//     //       "assets/images/005-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "4",
//     //     title: "กำจัดปลวกด้วยการวางท่อ",
//     //     detail:
//     //         "วิธีนี้เป็นการวางระบบท่อเข้าไปบริเวณใต้พื้นของบ้านหรืออาคารตามแนว...",
//     //     by: "ผู้โพสต์ที่ 4",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/003-News-Pic.png",
//     //       "assets/images/003-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "5",
//     //     title: "กำจัดปลวกราคาเท่าไหร่?",
//     //     detail:
//     //         "เมื่อปลวกขื้นบ้านหลายท่านคงพยายามหาวิธีแก้ไข และ กำจัดปลวกบางคน อาจ",
//     //     by: "ผู้โพสต์ที่ 5",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/004-News-Pic.png",
//     //       "assets/images/004-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "6",
//     //     title: "ฆ่าราชินีปลวกจะเร็จไหม",
//     //     detail:
//     //         "เมื่อพบปัญาปลวกขื้นบ้านหลายท่านเสาะหาวิธีกำจัดปลวกที่บอกต่อกันว่า",
//     //     by: "ผู้โพสต์ที่ 6",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/005-News-Pic.png",
//     //       "assets/images/005-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "7",
//     //     title: "กำจัดปลวกด้วยการวางท่อ",
//     //     detail:
//     //         "วิธีนี้เป็นการวางระบบท่อเข้าไปบริเวณใต้พื้นของบ้านหรืออาคารตามแนว...",
//     //     by: "ผู้โพสต์ที่ 7",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/003-News-Pic.png",
//     //       "assets/images/003-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "8",
//     //     title: "กำจัดปลวกราคาเท่าไหร่?",
//     //     detail:
//     //         "เมื่อปลวกขื้นบ้านหลายท่านคงพยายามหาวิธีแก้ไข และ กำจัดปลวกบางคน อาจ",
//     //     by: "ผู้โพสต์ที่ 8",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/004-News-Pic.png",
//     //       "assets/images/004-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     //   NewsModel(
//     //     id: "9",
//     //     title: "ฆ่าราชินีปลวกจะเร็จไหม",
//     //     detail:
//     //         "เมื่อพบปัญาปลวกขื้นบ้านหลายท่านเสาะหาวิธีกำจัดปลวกที่บอกต่อกันว่า",
//     //     by: "ผู้โพสต์ที่ 9",
//     //     dateCreate: DateTime.now(),
//     //     image: [
//     //       "assets/images/005-News-Pic.png",
//     //       "assets/images/005-News-Pic.png"
//     //     ],
//     //     sharedSubject: '',
//     //     sharedUrl: '',
//     //   ),
//     // ];

//     // for (var index = 0; index < yourDataList.length; index++) {
//     //   await FirebaseFirestore.instance
//     //       .collection('1000')
//     //       .doc('Company')
//     //       .collection('News')
//     //       .doc(yourDataList[index].id)
//     //       .set(
//     //     {
//     //       'ID': yourDataList[index].id,
//     //       'Title': yourDataList[index].title,
//     //       'Detail': yourDataList[index].detail,
//     //       'By': yourDataList[index].by,
//     //       'DateCreate': yourDataList[index].dateCreate,
//     //       'Image': yourDataList[index].image,
//     //       'SharedSubject': yourDataList[index].sharedSubject,
//     //       'SharedUrl': yourDataList[index].sharedUrl
//     //     },
//     //   );
//     // }
//     // print('111');
//     // print(myController.userData!['ID']);

//     // List<Map<String, dynamic>> messages = [
//     //   {
//     //     'senderID': '0824788384',
//     //     'receiverID': 'Admin1',
//     //     'message': 'Hello, how are you?',
//     //     'sentTime': DateTime.now(),
//     //     'messageType': 'text',
//     //   },
//     //   {
//     //     'senderID': '0824788384',
//     //     'receiverID': 'Admin1',
//     //     'message': 'I\'m good, thanks!',
//     //     'sentTime': DateTime.now().add(Duration(minutes: 5)),
//     //     'messageType': 'text',
//     //   },
//     //   {
//     //     'senderID': '0824788384',
//     //     'receiverID': 'Admin1',
//     //     'message': 'Hi there!',
//     //     'sentTime': DateTime.now().add(Duration(minutes: 10)),
//     //     'messageType': 'text',
//     //   },
//     //   {
//     //     'senderID': '0824788384',
//     //     'receiverID': 'Admin1',
//     //     'message': 'Hello user1!',
//     //     'sentTime': DateTime.now().add(Duration(minutes: 15)),
//     //     'messageType': 'text',
//     //   },
//     //   {
//     //     'senderID': '0824788384',
//     //     'receiverID': 'Admin1',
//     //     'message': 'Goodbye!',
//     //     'sentTime': DateTime.now().add(Duration(minutes: 20)),
//     //     'messageType': 'text',
//     //   },
//     // ];
//     // print(messages);
//     // try {
//     //   // print('0824788384');
//     //   // await FirebaseFirestore.instance
//     //   //     .collection('1000')
//     //   //     .doc('Company')
//     //   //     .collection('User')
//     //   //     .doc('0824788384')
//     //   //     .collection('chat')
//     //   //     .doc('Admin1')
//     //   //     .set(
//     //   //   {'message': messages},
//     //   // );

//     //   await FirebaseFirestore.instance
//     //       .collection('1000')
//     //       .doc('Company')
//     //       .collection('Admin')
//     //       .doc('0824788384')
//     //       .set(
//     //     {'message': messages},
//     //   );
//     // } catch (e) {
//     //   debugPrint(e.toString());
//     // }
//     // List<UserAppointmentSurwayHome> userAppointments = [
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '1',
//     //     number: '1', // นัดครั้งที่ 1
//     //     date: DateTime(2023, 9, 14, 13, 30),
//     //     status: true,
//     //     detail: 'Meeting with client',
//     //     employee: 'John Doe',
//     //     employeePhone: '1234567890',
//     //     employeeConfirm: 'Alice',
//     //     employeeConfirmDate: DateTime(2023, 9, 14, 10, 0),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '2',
//     //     number: '2', // นัดครั้งที่ 2
//     //     date: DateTime(2023, 9, 15, 10, 0),
//     //     status: true,
//     //     detail: 'Team meeting',
//     //     employee: 'Jane Smith',
//     //     employeePhone: '9876543210',
//     //     employeeConfirm: 'Bob',
//     //     employeeConfirmDate: DateTime(2023, 9, 15, 9, 0),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '3',
//     //     number: '3', // นัดครั้งที่ 3
//     //     date: DateTime(2023, 9, 16, 14, 0),
//     //     status: true,
//     //     detail: 'Training session',
//     //     employee: 'Michael Johnson',
//     //     employeePhone: '5555555555',
//     //     employeeConfirm: 'Catherine',
//     //     employeeConfirmDate: DateTime(2023, 9, 16, 11, 0),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '4',
//     //     number: '4', // นัดครั้งที่ 4
//     //     date: DateTime(2023, 9, 17, 9, 30),
//     //     status: true,
//     //     detail: 'Project presentation',
//     //     employee: 'David Williams',
//     //     employeePhone: '1111111111',
//     //     employeeConfirm: 'Emily',
//     //     employeeConfirmDate: DateTime(2023, 9, 17, 8, 0),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '5',
//     //     number: '5', // นัดครั้งที่ 5
//     //     date: DateTime(2023, 9, 18, 16, 0),
//     //     status: false,
//     //     detail: 'Client meeting',
//     //     employee: 'Sophia Anderson',
//     //     employeePhone: '9999999999',
//     //     employeeConfirm: 'Daniel',
//     //     employeeConfirmDate: DateTime(2023, 9, 18, 14, 0),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '6',
//     //     number: '6', // นัดครั้งที่ 6
//     //     date: DateTime(2023, 9, 19, 11, 0),
//     //     status: false,
//     //     detail: 'Team brainstorming',
//     //     employee: 'Laura Davis',
//     //     employeePhone: '7777777777',
//     //     employeeConfirm: 'Alex',
//     //     employeeConfirmDate: DateTime(2023, 9, 19, 10, 0),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '7',
//     //     number: '7', // นัดครั้งที่ 7
//     //     date: DateTime(2023, 9, 20, 13, 0),
//     //     status: false,
//     //     detail: 'Project kickoff',
//     //     employee: 'Chris Martin',
//     //     employeePhone: '8888888888',
//     //     employeeConfirm: 'Grace',
//     //     employeeConfirmDate: DateTime(2023, 9, 20, 11, 30),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     //   UserAppointmentSurwayHome(
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     lat: '13.712623030392686',
//     //     lot: '100.79026937541336',
//     //     userAppointmentHomeID: '8',
//     //     number: '8', // นัดครั้งที่ 8
//     //     date: DateTime(2023, 9, 21, 15, 0),
//     //     status: false,
//     //     detail: 'Team training',
//     //     employee: 'Sarah Johnson',
//     //     employeePhone: '6666666666',
//     //     employeeConfirm: 'Kevin',
//     //     employeeConfirmDate: DateTime(2023, 9, 21, 14, 0),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.jpg?alt=media&token=19ce3afc-f265-4bcd-9a9b-2dacaa5f7373',
//     //   ),
//     // ];

//     // print(messages);
//     // List<Map<String, dynamic>> listDatato = [];
//     // try {
//     //   for (var userAppointment in userAppointments) {
//     //     listDatato.add(userAppointment.toJson());
//     //   }
//     //   await FirebaseFirestore.instance
//     //       .collection('1000')
//     //       .doc('Company')
//     //       .collection('User')
//     //       .doc('0824788384')
//     //       .update({'UserAppointmentSurwayHome': listDatato});
//     // } catch (e) {
//     //   debugPrint(e.toString());
//     // }
//     // List<UserAppointment> userAppointmentAddAll = [
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '1',
//     //     number: '1',
//     //     date: DateTime.now(),
//     //     status: true,
//     //     goCustomerHome: true,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'John Doe',
//     //     employeePhone: '1234567890',
//     //     employeeConfirm: 'Alice',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: false,
//     //     userCharactorRecord: '',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '2',
//     //     number: '2',
//     //     date: DateTime.now(),
//     //     status: true,
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'Jane Smith',
//     //     employeePhone: '9876543210',
//     //     employeeConfirm: 'Bob',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: false,
//     //     userCharactorRecord: '',
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '3',
//     //     number: '3',
//     //     date: DateTime.now(),
//     //     userCharactorRecord: '',
//     //     status: true,
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'Michael Johnson',
//     //     employeePhone: '5555555555',
//     //     employeeConfirm: 'Catherine',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: false,
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '4',
//     //     number: '4',
//     //     date: DateTime.now(),
//     //     status: false,
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'David Williams',
//     //     employeePhone: '1111111111',
//     //     userCharactorRecord: '',
//     //     employeeConfirm: 'Emily',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: false,
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '5',
//     //     number: '5',
//     //     date: DateTime.now(),
//     //     status: false,
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     userCharactorRecord: '',
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'Sophia Anderson',
//     //     employeePhone: '9999999999',
//     //     employeeConfirm: 'Daniel',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: true,
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '6',
//     //     userCharactorRecord: '',
//     //     number: '6',
//     //     date: DateTime.now(),
//     //     status: false,
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'Laura Davis',
//     //     employeePhone: '7777777777',
//     //     employeeConfirm: 'Alex',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: true,
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '7',
//     //     number: '7',
//     //     date: DateTime.now(),
//     //     userCharactorRecord: '',
//     //     status: false,
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'Chris Martin',
//     //     employeePhone: '8888888888',
//     //     employeeConfirm: 'Grace',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: true,
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   UserAppointment(
//     //     star: '',
//     //     dateAddData: DateTime.now(),
//     //     userTokenID: '',
//     //     statusDate: DateTime.now().add(Duration(hours: 2)),
//     //     latitude: '13.712623030392686',
//     //     longitude: '100.79026937541336',
//     //     userAppointmentID: '8',
//     //     number: '8',
//     //     userCharactorRecord: '',
//     //     date: DateTime.now(),
//     //     status: false,
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         'ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี',
//     //     employeeID: '0982512281',
//     //     employee: 'Sarah Johnson',
//     //     employeePhone: '6666666666',
//     //     employeeConfirm: 'Kevin',
//     //     employeeConfirmDate: DateTime.now(),
//     //     address: 'ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170',
//     //     nameAddress: 'หมู่บ้านลดาวัลย์',
//     //     surwayOrAppointment: true,
//     //     imageEmployee:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FUsers%2F0982512281%2F0982512281.png?alt=media&token=1caacf96-9fb7-49f4-8729-9eab5656737c',
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     // ];
//     // print(messages);
//     // List<Map<String, dynamic>> listData = [];
//     // try {
//     //   for (var userAppointment in userAppointmentAddAll) {
//     //     // print(userAppointment.employeeID);
//     //     listData.add(userAppointment.toJson());
//     //   }
//     //   await FirebaseFirestore.instance
//     //       .collection('1000')
//     //       .doc('Company')
//     //       .collection('User')
//     //       .doc('0824788384')
//     //       .update({'UserAppointment': listData});
//     // } catch (e) {
//     //   debugPrint(e.toString());
//     // }

//     // List<EmployeeAppointment> appointments = [
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_1",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: true,
//     //     number: "1",
//     //     totalNumber: "8",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "กัญญา รุ่งพเนจร",
//     //     customerPhone: "081-234-5671",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-17T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: true,
//     //       adminConfirmStatusPay: true,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_2",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: true,
//     //     number: "2",
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '2',
//     //     customerName: "นางสาววรรณรทร สุดใจ",
//     //     customerPhone: "082-345-6782",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-18T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_2",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_3",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: true,
//     //     number: "3",
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นายสุทธิพงษ์ ปรารถนา",
//     //     customerPhone: "083-456-7893",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-19T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_3",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_4",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: true,
//     //     number: "4",
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นางสาววีรยา ปลื้มใจ",
//     //     customerPhone: "084-567-8914",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-20T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_4",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_5",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: true,
//     //     number: "5",
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นายวิทยา หัสดี",
//     //     customerPhone: "085-678-9025",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-21T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_5",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_6",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: true,
//     //     number: "6",
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นางสาวเพ็ญศรี ประดู่",
//     //     customerPhone: "086-789-0136",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-22T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_6",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_7",
//     //     employeeTokenID: '',
//     //     number: "7",
//     //     surwayOrAppointment: false,
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นายนิติพงษ์ คำใจ",
//     //     customerPhone: "087-890-1247",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-23T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_7",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_8",
//     //     employeeTokenID: '',
//     //     number: "2",
//     //     surwayOrAppointment: false,
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: true,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นางสาววิไลรัตน์ พรหมใจ",
//     //     customerPhone: "088-901-2358",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-24T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_8",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_9",
//     //     employeeTokenID: '',
//     //     number: "4",
//     //     totalNumber: "7",
//     //     surwayOrAppointment: false,
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: false,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นายธนิตย์ รักเมือง",
//     //     customerPhone: "089-012-3469",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-25T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_9",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_10",
//     //     employeeTokenID: '',
//     //     number: "5",
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: false,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     surwayOrAppointment: false,
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นางสาวนภาพร อ่อนใจ",
//     //     customerPhone: "090-123-4570",
//     //     adminNameConfirm: "Admin1",
//     //     adminConfirmDate: DateTime.parse("2023-09-26T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์  10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: ["WorkImage_10_1", "WorkImage_10_2"],
//     //       customerAppointmentPDPA: "CustomerAppointmentPDPA_10",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_10",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_11",
//     //     employeeTokenID: '',
//     //     number: "5",
//     //     surwayOrAppointment: false,
//     //     totalNumber: "7",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: false,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นางสาวนภาพร อ่อนอุมา",
//     //     customerPhone: "090-123-4570",
//     //     adminNameConfirm: "Admin1_1",
//     //     adminConfirmDate: DateTime.parse("2023-09-26T14:22:00.000Z"),
//     //     customerLatitude: "13.712027",
//     //     customerLongitude: "100.7887237",
//     //     customerAddress: "ราชพฤกษ์-ปิ่นเกล้า ถนน ราชพฤกษ์ 10170",
//     //     customerNameAddress: "หมู่บ้านลดาวัลย์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_11",
//     //     ),
//     //   ),
//     //   // เพิ่มข้อมูลอีก 9 รายการต่อไปนี้
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_12",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: false,
//     //     number: "3",
//     //     totalNumber: "5",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: false,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นายอนุรักษ์ พรหมมา",
//     //     customerPhone: "091-234-5678",
//     //     adminNameConfirm: "Admin2_2",
//     //     adminConfirmDate: DateTime.parse("2023-09-27T10:45:00.000Z"),
//     //     customerLatitude: "13.712345",
//     //     customerLongitude: "100.789012",
//     //     customerAddress: "อำเภอปทุมวัน จังหวัดกรุงเทพฯ 12120",
//     //     customerNameAddress: "บ้านนายอนุรักษ์",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_12",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_13",
//     //     employeeTokenID: '',
//     //     surwayOrAppointment: false,
//     //     number: "4",
//     //     totalNumber: "6",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: false,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นายสุรชัย ใจดี",
//     //     customerPhone: "092-345-6789",
//     //     adminNameConfirm: "Admin3_3",
//     //     adminConfirmDate: DateTime.parse("2023-09-28T13:15:00.000Z"),
//     //     customerLatitude: "13.712678",
//     //     customerLongitude: "100.789345",
//     //     customerAddress: "เขตลาดกระบัง กรุงเทพ 10520",
//     //     customerNameAddress: "บ้านนายสุรชัย",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_13",
//     //     ),
//     //   ),
//     //   EmployeeAppointment(
//     //     employeeAppointmentID: "ID_14",
//     //     employeeTokenID: '',
//     //     number: "4",
//     //     surwayOrAppointment: false,
//     //     totalNumber: "6",
//     //     date: DateTime.now().add(Duration(hours: 2)),
//     //     dateFinish: DateTime.now().add(Duration(hours: 24)),
//     //     status: false,
//     //     statusDate: DateTime.now().add(Duration(hours: 8)),
//     //     goCustomerHome: false,
//     //     goCustomerHomeDateTime: DateTime.now(),
//     //     detail:
//     //         "ใช้ท่อ HDPE ชนิดหนาพิเศษ ทนแรงดันสูง\nฉีดเคมีให้  1 ครั้ง หลังจากวางท่อป้องกันและกำจัดปลวก\nเสร็จเรียบร้อยตรวจเช็คเหยื่อทุกๆ  3 เดือน ใน ระยะเวลา 1  ปี\nพื้นที่ให้บริการ 51 จังหวัด\nรับประกัน 1 ปี",
//     //     customerID: '0824788384',
//     //     customerAppointmentID: '1',
//     //     customerName: "นายอำนาจ ใจมด",
//     //     customerPhone: "092-345-6789",
//     //     adminNameConfirm: "Admin3_3",
//     //     adminConfirmDate: DateTime.parse("2023-09-28T13:15:00.000Z"),
//     //     customerLatitude: "13.712678",
//     //     customerLongitude: "100.789345",
//     //     customerAddress: "เขตลาดกระบัง กรุงเทพ 10520",
//     //     customerNameAddress: "บ้านนายสุรชัย",
//     //     customerPDPAImg: "",
//     //     customerPdpaConfirm: false,
//     //     appointmentRecord: AppointmentRecord(
//     //       homeWidth: "12 เมตร",
//     //       homeLength: "15 เมตร",
//     //       areaSize: "30 ตารางวา",
//     //       homeHeight: "2 ชั้น",
//     //       homeCount: "1 หลัง",
//     //       areaTotal: "60 ตารางวา",
//     //       date: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       customerConfirmPay: "5000",
//     //       appointmentTotal: '7 ครั้ง',
//     //       firstDate: DateTime.parse("2023-09-17T14:22:00.000Z").toString(),
//     //       workImage: [],
//     //       customerAppointmentPDPA: "",
//     //       recordConfirm: false,
//     //     ),
//     //     customerPayConfirm: CustomerPayConfirm(
//     //       payTotal: "",
//     //       payDate: DateTime.now(),
//     //       payImage: [],
//     //       payStatus: false,
//     //       adminConfirmStatusPay: false,
//     //       gbQrcode: "GbQrcode_1",
//     //     ),
//     //   ),
//     // ];
//     // print(messages);
//     // List<Map<String, dynamic>> listDataa = [];

//     // print('employee updata data 0982512281');
//     // print(appointments.length);
//     // try {
//     //   for (var appointment in appointments) {
//     //     print(appointment);
//     //     listDataa.add(appointment.toJson());
//     //   }

//     //   print(listDataa);
//     //   await FirebaseFirestore.instance
//     //       .collection('1000')
//     //       .doc('Company')
//     //       .collection('User')
//     //       .doc('0982512281')
//     //       .collection('Employee')
//     //       .doc('0982512281')
//     //       .update({
//     //     // 'EmployeeCode': '009899876888',
//     //     'EmployeeAppointment': listDataa,
//     //     // 'EmployeeAppointmentSurWayHome': [],
//     //     // 'EmployeeEquipment': [],
//     //     // 'EmployeePayRecordMonth': [],
//     //   });
//     // } catch (e) {
//     //   debugPrint(e.toString());
//     // }

//     // final List<Equipment> equipmentList = [
//     //   Equipment(
//     //     equipmentID: 'eq1',
//     //     equipmentName: 'Laptop',
//     //     equipmentDetail: 'MacBook Pro',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FLaptop.jpg?alt=media&token=e8ee02c6-8229-4d1e-9fbd-c7efab6b378a',
//     //     equipmentCount: '5',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq2',
//     //     equipmentName: 'Projector',
//     //     equipmentDetail: 'High-resolution projector',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FProjector.jpg?alt=media&token=8e656cc1-1633-41a3-8569-621bb9edda16',
//     //     equipmentCount: '2',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq3',
//     //     equipmentName: 'Printer',
//     //     equipmentDetail: 'Color inkjet printer',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FPrinter.jpg?alt=media&token=65d30b45-c170-43c0-b2e8-7b9efa134239',
//     //     equipmentCount: '3',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq4',
//     //     equipmentName: 'Tablet',
//     //     equipmentDetail: 'iPad Pro',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FTablet.jpg?alt=media&token=4eb43951-15d5-4362-9aa3-3c67f684b17b',
//     //     equipmentCount: '4',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq5',
//     //     equipmentName: 'Camera',
//     //     equipmentDetail: 'Professional DSLR camera',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FCamera.jpg?alt=media&token=530f5b72-6aa7-4ca1-aa84-9d6b700fff49',
//     //     equipmentCount: '6',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq6',
//     //     equipmentName: 'Microphone',
//     //     equipmentDetail: 'High-quality studio microphone',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FMicrophone.jpg?alt=media&token=83be51ab-93aa-456f-a28a-3477826464bb',
//     //     equipmentCount: '8',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq7',
//     //     equipmentName: 'Headphones',
//     //     equipmentDetail: 'Noise-canceling headphones',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FHeadphones.jpg?alt=media&token=76cbbdaa-038d-46a3-9e97-139d429c7ca0',
//     //     equipmentCount: '10',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq8',
//     //     equipmentName: 'Monitor',
//     //     equipmentDetail: '27-inch 4K monitor',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FMonitor.jpg?alt=media&token=83d8fd1a-e16b-46b3-b90a-4ba4dad1b24d',
//     //     equipmentCount: '7',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq9',
//     //     equipmentName: 'Smartphone',
//     //     equipmentDetail: 'Latest smartphone model',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FSmartphone.jpg?alt=media&token=acfae328-eb3c-49e0-bf51-243331e41d52',
//     //     equipmentCount: '12',
//     //   ),
//     //   Equipment(
//     //     equipmentID: 'eq10',
//     //     equipmentName: 'Scanner',
//     //     equipmentDetail: 'High-speed document scanner',
//     //     equipmentImage:
//     //         'https://firebasestorage.googleapis.com/v0/b/greenhome-4a2df.appspot.com/o/images%2FEquipments%2FScanner.jpg?alt=media&token=d42aa6b8-fceb-42fc-8082-1cf2eb5e5cb9',
//     //     equipmentCount: '9',
//     //   ),
//     // ];

//     // print(equipmentList);
//     // List<Map<String, dynamic>> equipmentAll = [];
//     // try {
//     //   for (var equipment in equipmentList) {
//     //     equipmentAll.add(equipment.toJson());
//     //   }
//     //   await FirebaseFirestore.instance
//     //       .collection('1000')
//     //       .doc('Company')
//     //       .collection('EquipmentData')
//     //       .doc('Equipment')
//     //       .set({
//     //     'EquipmentList': equipmentAll,
//     //   });
//     // } catch (e) {
//     //   debugPrint(e.toString());
//     // }

//     // final List<EmployeeEquipment> employeeEquipmentList = [
//     //   EmployeeEquipment(
//     //       customerName: 'John Doe',
//     //       employeeTokenID: '',
//     //       date: DateTime.now(),
//     //       employeeEquipmentID: 'empEq2',
//     //       status: false,
//     //       equipment: [],
//     //       surwayOrAppointment: false,
//     //       employeeAppointmentID: 'app2',
//     //       customerNameAddress: 'หมูบ้านวงงาม'),
//     //   EmployeeEquipment(
//     //       customerName: 'Jane Smith',
//     //       employeeTokenID: '',
//     //       date: DateTime.now(),
//     //       employeeEquipmentID: 'empEq3',
//     //       status: false,
//     //       equipment: [],
//     //       surwayOrAppointment: false,
//     //       employeeAppointmentID: 'app3',
//     //       customerNameAddress: 'หมูบ้านจันทรา'),
//     //   EmployeeEquipment(
//     //       customerName: 'Michael Johnson',
//     //       employeeTokenID: '',
//     //       date: DateTime.now(),
//     //       employeeEquipmentID: 'empEq4',
//     //       status: false,
//     //       equipment: [],
//     //       surwayOrAppointment: false,
//     //       employeeAppointmentID: 'app4',
//     //       customerNameAddress: 'หมูบ้านลดา'),
//     //   EmployeeEquipment(
//     //       customerName: 'Emily Davis',
//     //       employeeTokenID: '',
//     //       date: DateTime.now(),
//     //       employeeEquipmentID: 'empEq5',
//     //       status: false,
//     //       equipment: [],
//     //       surwayOrAppointment: true,
//     //       employeeAppointmentID: 'app5',
//     //       customerNameAddress: 'หมูบ้านลดา'),
//     //   EmployeeEquipment(
//     //       customerName: 'Daniel Wilson',
//     //       employeeTokenID: '',
//     //       date: DateTime.now(),
//     //       employeeEquipmentID: 'empEq6',
//     //       status: false,
//     //       equipment: [],
//     //       surwayOrAppointment: true,
//     //       employeeAppointmentID: 'app6',
//     //       customerNameAddress: 'หมูบ้านลดา'),
//     // EmployeeEquipment(
//     //   customerName: 'Sara Taylor',
//     //   employeeTokenID: '',
//     //   date: DateTime.now(),
//     //   employeeEquipmentID: 'empEq6',
//     //   status: false,
//     //   equipment: [],
//     //   surwayOrAppointment: false,
//     //   employeeAppointmentID: 'app6',
//     //   customerNameAddress: 'หมูบ้านลดา',
//     // ),
//     // EmployeeEquipment(
//     //     customerName: 'Robert Brown',
//     //     employeeTokenID: '',
//     //     date: DateTime.now(),
//     //     employeeEquipmentID: 'empEq7',
//     //     status: false,
//     //     equipment: [],
//     //     surwayOrAppointment: false,
//     //     employeeAppointmentID: 'app7',
//     //     customerNameAddress: 'หมูบ้านลดา'),
//     // EmployeeEquipment(
//     //     customerName: 'Karen Clark',
//     //     employeeTokenID: '',
//     //     date: DateTime.now(),
//     //     employeeEquipmentID: 'empEq8',
//     //     status: false,
//     //     equipment: [],
//     //     surwayOrAppointment: false,
//     //     employeeAppointmentID: 'app8',
//     //     customerNameAddress: 'หมูบ้านลดา'),
//     // EmployeeEquipment(
//     //     customerName: 'Matthew White',
//     //     employeeTokenID: '',
//     //     date: DateTime.now(),
//     //     employeeEquipmentID: 'empEq9',
//     //     status: false,
//     //     equipment: [],
//     //     surwayOrAppointment: false,
//     //     employeeAppointmentID: 'app9',
//     //     customerNameAddress: 'หมูบ้านลดา'),
//     // EmployeeEquipment(
//     //     customerName: 'Laura Anderson',
//     //     employeeTokenID: '',
//     //     date: DateTime.now(),
//     //     employeeEquipmentID: 'empEq10',
//     //     status: false,
//     //     equipment: [],
//     //     surwayOrAppointment: false,
//     //     employeeAppointmentID: 'app10',
//     //     customerNameAddress: 'หมูบ้านลดา'),
//     // ];
//     // print(equipmentList);
//     // List<Map<String, dynamic>> equipmentAllData = [];
//     // try {
//     //   for (var equipment in employeeEquipmentList) {
//     //     equipmentAllData.add(equipment.toJson());
//     //   }
//     //   await FirebaseFirestore.instance
//     //       .collection('1000')
//     //       .doc('Company')
//     //       .collection('User')
//     //       .doc('0982512281')
//     //       .collection('Employee')
//     //       .doc('0982512281')
//     //       .update({
//     //     'EmployeeEquipment': equipmentAllData,
//     //   });
//     // } catch (e) {
//     //   debugPrint(e.toString());
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     print('===========================');
//     print(auth.currentUser);

//     print(widget.initialRoute);
//     print(widget.initialRouteArgs);

//     // navigatorKey.currentState
//     //     ?.pushNamed('/deeplink', arguments: {'ref': widget.initialRouteArgs});

//     return isLoading
//         ? MaterialApp(
//             locale: _locale,
//             supportedLocales: const [
//               Locale('en', ''),
//             ],
//             theme: ThemeData(
//               brightness: Brightness.light,
//               scrollbarTheme: ScrollbarThemeData(),
//             ),
//             darkTheme: ThemeData(
//               brightness: Brightness.light,
//               scrollbarTheme: ScrollbarThemeData(),
//             ),
//             themeMode: _themeMode,
//             debugShowCheckedModeBanner: false,
//             home: Scaffold(
//               body: Container(
//                 child: Center(
//                   child: CircularLoading(success: !isLoading),
//                 ),
//               ),
//             ),
//           )
//         : MaterialApp(
//             locale: _locale,
//             supportedLocales: const [Locale('en', '')],
//             theme: ThemeData(
//               brightness: Brightness.light,
//               scrollbarTheme: ScrollbarThemeData(),
//             ),
//             themeMode: _themeMode,
//             debugShowCheckedModeBanner: false,
//             // navigatorKey: navigatorKey,
//             // onGenerateRoute: (settings) {
//             //   if (settings.name == '/deeplink') {
//             //     final Map<String, dynamic> data =
//             //         settings.arguments as Map<String, dynamic>;
//             //     return MaterialPageRoute(
//             //       builder: (context) => A0107PasswordResetWidget(),
//             //     );
//             //   }
//             //   return MaterialPageRoute(builder: (context) => NavBarPage());
//             // },
//             navigatorKey: navigatorKey,
//             onGenerateRoute: (settings) {
//               if (settings.name == '/deeplink') {
//                 print('hhhhhhh');
//                 print(settings.name);
//                 print(settings.arguments);

//                 final Map<String, dynamic> data =
//                     settings.arguments as Map<String, dynamic>;
//                 print('123');
//                 print(data);

//                 // Push to the desired screen using the global navigator key

//                 // loadEmail(data);

//                 return MaterialPageRoute(
//                   builder: (context) => A0107PasswordResetWidget(data: data),
//                 );
//               }
//               return MaterialPageRoute(builder: (context) => NavBarPage());
//             },
//             home: NavBarPage());
//   }
// }

// class NavBarPage extends StatefulWidget {
//   final String? initialPage;
//   final Widget? page;

//   const NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

//   @override
//   State<NavBarPage> createState() => _NavBarPageState();
// }

// class _NavBarPageState extends State<NavBarPage>  {
//   String _currentPageName = 'A01_01_Home';
//   late Widget? _currentPage;

//   final GlobalKey<_NavBarPageState> navBarKey = GlobalKey<_NavBarPageState>();

//   @override
//   void initState() {
//     super.initState();
//     _currentPageName = widget.initialPage ?? _currentPageName;
//     _currentPage = widget.page;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabs = {
//       // 'A01_01_Home': A0101HomeWidget(),
//       // 'A02_01_Favorite': A0201FavoriteWidget(),
//       // 'A03_01_Chat': A0301ChatWidget(),
//       // 'A04_01_ListOrder': A0401ListOrderWidget(),
//       // 'A06_01_Setting': A0601SettingWidget(),
//       'A01_01_Home': A0101HomeWidget(),
//       'A02_01_Favorite': Container(),
//       'A03_01_Chat': Container(),
//       'A04_01_ListOrder': Container(),
//       'A06_01_Setting': Container(),
//     };

//     final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

//     final MediaQueryData queryData = MediaQuery.of(context);

//     return Scaffold(
//       // appBar: AppBar( ),
//       body: MediaQuery(
//           data: queryData
//               .removeViewInsets(removeBottom: true)
//               .removeViewPadding(removeBottom: true),
//           child: _currentPage ?? tabs[_currentPageName]!),
//       extendBody: true,
//       bottomNavigationBar: FloatingNavbar(

//         currentIndex: currentIndex,
//         onTap: (i) => setState(() {
//           _currentPage = null;
//           _currentPageName = tabs.keys.toList()[i];
//         }),
//         backgroundColor: FlutterFlowTheme.of(context).alternate,
//         selectedItemColor: FlutterFlowTheme.of(context).primaryBackground,
//         unselectedItemColor: FlutterFlowTheme.of(context).secondaryBackground,
//         selectedBackgroundColor: Color(0x00000000),
//         borderRadius: 0.0,
//         itemBorderRadius: 8.0,
//         margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//         padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//         width: double.infinity,
//         elevation: 0.0,
//         items: [
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 0 ? Icons.home_sharp : Icons.home_sharp,
//                   color: currentIndex == 0
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 0 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'หน้าหลัก',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 1
//                       ? Icons.favorite_sharp
//                       : Icons.favorite_sharp,
//                   color: currentIndex == 1
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 1 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'สั่งประจำ',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 2 ? Icons.email_sharp : Icons.email_sharp,
//                   color: currentIndex == 2
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 2 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'แช็ทคุยกับเรา',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 3
//                       ? Icons.shopping_basket_sharp
//                       : Icons.shopping_basket_sharp,
//                   color: currentIndex == 3
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 3 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'รายการสั่งชื้อ',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 4
//                       ? Icons.settings_sharp
//                       : Icons.settings_sharp,
//                   color: currentIndex == 4
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 4 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'การตั้งค่า',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: MyHomePage(),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   List<dynamic>? provinces = [];
// //   List<dynamic>? amphures = [];
// //   List<dynamic>? tambons = [];
// //   Map<String, dynamic> selected = {
// //     'province_id': null,
// //     'amphure_id': null,
// //     'tambon_id': null,
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchData();
// //   }

// //   void fetchData() async {
// //     // Replace the URL with the actual URL of your JSON data.
// //     print('fetchData');
// //     var response = await DefaultAssetBundle.of(context)
// //         .loadString('assets/thai_province_data.json.txt');
// //     print('-------');
// //     print(response);
// //     var result = json.decode(response);
// //     print('-------');
// //     print(result);
// //     setState(() {
// //       provinces = result;
// //       print(provinces);
// //     });
// //   }

// //   void setAmphures(List<dynamic>? newAmphures) {
// //     print('----amphor');
// //     print(newAmphures);
// //     setState(() {
// //       amphures = newAmphures!;
// //     });
// //   }

// //   void setTambons(List<dynamic>? newTambons) {
// //     print('----tambon');
// //     print(newTambons);
// //     setState(() {
// //       tambons = newTambons!;
// //     });
// //   }

// //   Widget dropdownList({
// //     String? label,
// //     String? id,
// //     List<dynamic>? list,
// //     String? child,
// //     List<String>? childsId,
// //     List<Function(List<dynamic>?)>? setChilds,
// //   }) {
// //     void onChangeHandle(String? selectedValue) {
// //       print(';;;;;');
// //       print(selectedValue);
// //       print(setChilds);
// //       print('eeeee');
// //       setChilds == null ? null : setChilds!.forEach((setChild) => setChild([]));
// //       print('llll');
// //       print(setChilds);
// //       Map<String, dynamic> unSelectChilds;
// //       setChilds == null
// //           ? unSelectChilds = {}
// //           : unSelectChilds = Map.fromIterable(childsId!,
// //               key: (item) => item, value: (item) => null);
// //       print(unSelectChilds);
// //       int? dependId =
// //           selectedValue!.isNotEmpty ? int.parse(selectedValue) : null;
// //       print(dependId);
// //       setState(() {
// //         selected = {
// //           ...selected,
// //           ...unSelectChilds,
// //           id!: dependId,
// //         };
// //         print('tttttt');
// //         print(selected);
// //       });

// //       if (selectedValue.isEmpty) return;

// //       if (child != null) {
// //         Map<String, dynamic> parent =
// //             list!.firstWhere((item) => item['id'] == dependId);
// //         print('pppppppppppp');
// //         print(parent);
// //         List<dynamic> childs = parent[child];
// //         setChilds!.first(childs);
// //       }
// //     }

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label!),
// //         DropdownButton<String>(
// //           value: selected[id]?.toString(),
// //           onChanged: onChangeHandle,
// //           items: [
// //             DropdownMenuItem(
// //               value: '',
// //               child: Text('Select ...'),
// //             ),
// //             for (var item in list!)
// //               DropdownMenuItem(
// //                 value: item['id'].toString(),
// //                 child: Text('${item['name_th']} - ${item['name_en']}'),
// //               ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Thailand Province List'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             dropdownList(
// //               label: 'Province: ',
// //               id: 'province_id',
// //               list: provinces,
// //               child: 'amphure',
// //               childsId: ['amphure_id', 'tambon_id'],
// //               setChilds: [setAmphures, setTambons],
// //             ),
// //             SizedBox(height: 16.0),
// //             dropdownList(
// //               label: 'District: ',
// //               id: 'amphure_id',
// //               list: amphures,
// //               child: 'tambon',
// //               childsId: ['tambon_id'],
// //               setChilds: [setTambons],
// //             ),
// //             SizedBox(height: 16.0),
// //             dropdownList(
// //               label: 'Sub-district: ',
// //               id: 'tambon_id',
// //               list: tambons,
// //               setChilds: null,
// //               childsId: null,
// //             ),
// //             SizedBox(height: 16.0),
// //             Text(
// //               json.encode(selected),
// //               style: TextStyle(fontFamily: 'monospace'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


