import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:m_food/a07_account_customer/a07_01_open_account/a0701_open_account_widget.dart';
import 'package:m_food/controller/shared_preference_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/widgets/data_transfer_widget_no_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class A0102LoginWidget extends StatefulWidget {
  const A0102LoginWidget({Key? key}) : super(key: key);

  @override
  _A0102LoginWidgetState createState() => _A0102LoginWidgetState();
}

class _A0102LoginWidgetState extends State<A0102LoginWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textController1 = TextEditingController();
  FocusNode textFieldFocusNode1 = FocusNode();
  TextEditingController textController2 = TextEditingController();
  FocusNode textFieldFocusNode2 = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //============================================================================
  String message = '';

  Future<void> saveDataToSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void saveDataForLogout() async {
    // DocumentSnapshot<Map<String, dynamic>>? data;
  }

  void _makePhoneCall(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launchURL(url);
    } else {
      // ไม่สามารถโทรศัพท์ได้
      // คุณสามารถแสดงข้อความแจ้งเตือนหรือปฏิเสธการโทรศัพท์ได้ตามความต้องการ
    }
  }

  void _launchLine() async {
    // const url = 'line://';
    const url = 'https://line.me/R/home/public/main?id=greenhome';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle cannot launch
      print('Could not launch $url');
    }
  }

  //============================================================================

  bool isNumeric(String str) {
    if (str == null || str.isEmpty) {
      return false;
    }

    return double.tryParse(str) != null;
  }

  //============================================================================
  void _submitForm() async {
    final userController = Get.find<UserController>();
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });

        final String userId = textController1.text;
        final String password = textController2.text;

        String text = userId;
        bool isAllNumeric = isNumeric(text);

        print('login ด้วย userName');
        print('login');

        // final test = FirebaseFirestore.instance
        //     .collection('1000')
        //     .doc('Company')
        //     .collection('User')
        //     .doc(userId)
        //     .get();

        await FirebaseFirestore.instance
            .collection('User')
            .where('Username', isEqualTo: userId)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          print('in Query');
          print(textController1.text);
          print(textController2.text);
          if (querySnapshot.docs.isNotEmpty) {
            print('is not empty');
            querySnapshot.docs.forEach(
              (doc) async {
                // ดึงข้อมูลจากเอกสารแต่ละรายการ
                print('1123213');
                var data = doc.data();
                print(data);
                Map<String, dynamic>? dataMap =
                    doc.data() as Map<String, dynamic>?;
                print(dataMap);
                if (dataMap!['Password'] != password) {
                  print('password wrong');

                  Fluttertoast.showToast(
                      msg: "คุณกรอกพาสเวิร์ดไม่ถูกค่ะ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red.shade900,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  // context.pop();
                } else if (dataMap['Status'] == 'UserRemove') {
                  print('user Romvee Status ');
                  Fluttertoast.showToast(
                      msg:
                          "ยูเซอร์นี้ทำการลบข้อมูลไว้ค่ะ\n   กรุณาติดต่อพนักงานค่ะ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red.shade900,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  print('login000');

                  await userController.updateUserDataUsername(dataMap);
                  print('login111');
                  final SharedPreferenceController sharedPreferenceController =
                      SharedPreferenceController();
                  print('login222');
                  await sharedPreferenceController.updateString(userId);
                  print('login333');
                  await saveDataToSharedPreferences('message_key', userId);
                  print('login444');
                }
              },
            );
          } else {
            print('is empty');
            Fluttertoast.showToast(
                msg: "ยูเซอร์นี้ไม่มีในระบบค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }).catchError((error) {
          print("เกิดข้อผิดพลาด: $error");
        });
        await Future.delayed(Duration(seconds: 5));
        // .then((value) => Navigator.pop(context));

        // if (isAllNumeric) {
        //   print('login ด้วยเบอร์โทรศัพท์');
        //   print('login');

        //   final test = await FirebaseFirestore.instance
        //       .collection('User')
        //       .doc(userId)
        //       .get();
        //   final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = test;
        //   print(documentSnapshot.data());
        //   print(documentSnapshot.exists);

        //   if (documentSnapshot.data() == null) {
        //     await FirebaseFirestore.instance
        //         .collection('User')
        //         .where('Phone', isEqualTo: userId)
        //         .get()
        //         .then((QuerySnapshot querySnapshot) async {
        //       print(userId);
        //       print('1111111');
        //       print(querySnapshot.docs);
        //       querySnapshot.docs.forEach(
        //         (doc) async {
        //           // ดึงข้อมูลจากเอกสารแต่ละรายการ
        //           print('1123213');
        //           var data = doc.data();
        //           print(data);
        //           Map<String, dynamic>? dataMap =
        //               doc.data() as Map<String, dynamic>?;

        //           if (dataMap!['Password'] != password) {
        //             print('password wrong');

        //             Fluttertoast.showToast(
        //                 msg: "คุณกรอกพาสเวิร์ดไม่ถูกค่ะ",
        //                 toastLength: Toast.LENGTH_SHORT,
        //                 gravity: ToastGravity.TOP,
        //                 timeInSecForIosWeb: 3,
        //                 backgroundColor: Colors.red.shade900,
        //                 textColor: Colors.white,
        //                 fontSize: 16.0);
        //             // context.pop();
        //           } else if (dataMap['Status'] == 'UserRemove') {
        //             print('user Romvee Status ');
        //             Fluttertoast.showToast(
        //                 msg:
        //                     "ยูเซอร์นี้ทำการลบข้อมูลไว้ค่ะ\n   กรุณาติดต่อพนักงานค่ะ",
        //                 toastLength: Toast.LENGTH_SHORT,
        //                 gravity: ToastGravity.TOP,
        //                 timeInSecForIosWeb: 3,
        //                 backgroundColor: Colors.red.shade900,
        //                 textColor: Colors.white,
        //                 fontSize: 16.0);
        //           } else {
        //             print('login000');
        //             // print(dataMap['UserAppointment']);
        //             // print(data['UserAppointment']);
        //             // for (var element in dataMap['UserAppointment']) {
        //             //   // print(element['UserAppointmentID']);
        //             //   // print(element);
        //             //   await FirebaseFirestore.instance
        //             //       .collection('1000')
        //             //       .doc('Company')
        //             //       .collection('User')
        //             //       .doc(element['EmployeeID'])
        //             //       .get()
        //             //       .then((DocumentSnapshot<Map<String, dynamic>> value) {
        //             //     if (value.data() != null && value.data()!.isNotEmpty) {
        //             //       final Map<String, dynamic> employeeMap =
        //             //           value.data() as Map<String, dynamic>;
        //             //       // employeeMap.forEach((key, value) {
        //             //       //   employeeData![key] = value;
        //             //       // });
        //             //       print('xxxxxxxxxxxxxxxxx');
        //             //       print(employeeMap);
        //             //     }
        //             //   });
        //             // }
        //             await userController.updateUserDataUsername(dataMap);
        //             print('login111');
        //             final SharedPreferenceController
        //                 sharedPreferenceController =
        //                 SharedPreferenceController();
        //             print('login222');
        //             await sharedPreferenceController.updateString(userId);
        //             print('login333');

        //             print('login444');
        //             dataMap['Level'] == 'Employee'
        //                 ? await FirebaseFirestore.instance
        //                     .collection('User')
        //                     .doc(dataMap['UserID'])
        //                     .collection('Employee')
        //                     .doc(dataMap['UserID'])
        //                     .get()
        //                     .then(
        //                         (DocumentSnapshot<Map<String, dynamic>> value) {
        //                     // final userController = Get.find<UserController>();
        //                     final userData = userController.userData;
        //                     final employeeData = userController.employeeData;

        //                     userController.updateEmployeeData(value);
        //                   })
        //                 : print(dataMap['Level']);
        //             print('login555');
        //             await saveDataToSharedPreferences('message_key', userId);
        //           }
        //         },
        //       );
        //     }).catchError((error) {
        //       print("เกิดข้อผิดพลาด: $error");
        //     });
        //     await Future.delayed(Duration(seconds: 5))
        //         .then((value) => context.pop());
        //   } else if (documentSnapshot.exists) {
        //     final data =
        //         documentSnapshot.data(); // ดึงข้อมูลออกมาจาก DocumentSnapshot
        //     // ทำอะไรกับข้อมูลที่คุณดึงออกมาได้ที่นี่
        //     // print(data);
        //     // print('password');
        //     // print(data!['Password']);
        //     if (userId != data!['Phone']) {
        //       print('เบอร์โทรศัพท์ไม่ตรง');
        //       await Future.delayed(Duration(seconds: 5));
        //       Fluttertoast.showToast(
        //           msg: "เบอร์โทรนี้ไม่ได้เป็นสมาชิกค่ะ",
        //           toastLength: Toast.LENGTH_SHORT,
        //           gravity: ToastGravity.TOP,
        //           timeInSecForIosWeb: 3,
        //           backgroundColor: Colors.red.shade900,
        //           textColor: Colors.white,
        //           fontSize: 16.0);
        //     } else {
        //       if (data['Password'] != password) {
        //         print('password wrong');
        //         await Future.delayed(Duration(seconds: 5));
        //         Fluttertoast.showToast(
        //             msg: "คุณกรอกพาสเวิร์ดไม่ถูกค่ะ",
        //             toastLength: Toast.LENGTH_SHORT,
        //             gravity: ToastGravity.TOP,
        //             timeInSecForIosWeb: 3,
        //             backgroundColor: Colors.red.shade900,
        //             textColor: Colors.white,
        //             fontSize: 16.0);
        //         // context.pop();
        //       } else if (data['Status'] == 'UserRemove') {
        //         print('user Romvee Status ');
        //         Fluttertoast.showToast(
        //             msg:
        //                 "ยูเซอร์นี้ทำการลบข้อมูลไว้ค่ะ\n   กรุณาติดต่อพนักงานค่ะ",
        //             toastLength: Toast.LENGTH_SHORT,
        //             gravity: ToastGravity.TOP,
        //             timeInSecForIosWeb: 3,
        //             backgroundColor: Colors.red.shade900,
        //             textColor: Colors.white,
        //             fontSize: 16.0);
        //       } else {
        //         // print(data['UserAppointment']);

        //         // DateTime convertTimestampToDateTime(Timestamp timestamp) {
        //         //   print(timestamp.toString());
        //         //   return timestamp.toDate();
        //         // }

        //         // for (int i = 0; i < data['UserAppointment'].length; i++) {
        //         //   Map<String, dynamic>? employeeMap;
        //         //   await FirebaseFirestore.instance
        //         //       .collection('1000')
        //         //       .doc('Company')
        //         //       .collection('User')
        //         //       .doc(data['UserAppointment'][i]['EmployeeID'])
        //         //       .get()
        //         //       .then((DocumentSnapshot<Map<String, dynamic>> value) {
        //         //     if (value.data() != null && value.data()!.isNotEmpty) {
        //         //       employeeMap = value.data() as Map<String, dynamic>;
        //         //       // employeeMap.forEach((key, value) {
        //         //       //   employeeData![key] = value;
        //         //       // });
        //         //       print('vvvvvvvvvvvvvvvvvvvvv');
        //         //       print(employeeMap!['UserID']);
        //         //     }
        //         //   });

        //         //   print(data['UserAppointment'][i]['Date']);

        //         //   var userAppointment = data['UserAppointment'][i];
        //         //   DateTime date =
        //         //       convertTimestampToDateTime(userAppointment['Date']);
        //         //   DateTime statusDate =
        //         //       convertTimestampToDateTime(userAppointment['StatusDate']);
        //         //   DateTime dateAddData = convertTimestampToDateTime(
        //         //       userAppointment['DateAddData']);
        //         //   DateTime employeeConfirmDate = convertTimestampToDateTime(
        //         //       userAppointment['EmployeeConfirmDate']);

        //         //   print(date.toString());
        //         //   print(statusDate.toString());
        //         //   print(dateAddData.toString());
        //         //   print(employeeConfirmDate.toString());

        //         //   data['UserAppointment'][i] = {
        //         //     'dateAddData': dateAddData,
        //         //     'userTokenID': data['UserAppointment'][i]['userTokenID'],
        //         //     'statusDate': statusDate,
        //         //     'latitude': data['UserAppointment'][i]['latitude'],
        //         //     'longitude': data['UserAppointment'][i]['longitude'],
        //         //     'userAppointmentID': data['UserAppointment'][i]
        //         //         ['userAppointmentID'],
        //         //     'number': data['UserAppointment'][i]['number'],
        //         //     'userCharactorRecord': data['UserAppointment'][i]
        //         //         ['userCharactorRecord'],
        //         //     'date': date,
        //         //     'status': data['UserAppointment'][i]['status'],
        //         //     'detail': data['UserAppointment'][i]['detail'],
        //         //     'employeeConfirm': data['UserAppointment'][i]
        //         //         ['employeeConfirm'],
        //         //     'employeeConfirmDate': employeeConfirmDate,
        //         //     'address': data['UserAppointment'][i]['address'],
        //         //     'nameAddress': data['UserAppointment'][i]['nameAddress'],
        //         //     'surwayOrAppointment': data['surwayOrAppointment'][i]
        //         //         ['dateAddData'],
        //         //     //=============================================
        //         //     'employeeID': employeeMap!['UserID'],
        //         //     'employee':
        //         //         '${employeeMap!['Name']} ${employeeMap!['Surname']}',
        //         //     'employeePhone': employeeMap!['Phone'],
        //         //     'imageEmployee': employeeMap!['Img'],
        //         //   };
        //         // }
        //         //==============================================================================
        //         // for (var element in data['UserAppointment']) {
        //         //   // print(element['UserAppointmentID']);
        //         //   // print(element);
        //         //   await FirebaseFirestore.instance
        //         //       .collection('1000')
        //         //       .doc('Company')
        //         //       .collection('User')
        //         //       .doc(element['EmployeeID'])
        //         //       .get()
        //         //       .then((DocumentSnapshot<Map<String, dynamic>> value) {
        //         //     if (value.data() != null && value.data()!.isNotEmpty) {
        //         //       final Map<String, dynamic> employeeMap =
        //         //           value.data() as Map<String, dynamic>;
        //         //       // employeeMap.forEach((key, value) {
        //         //       //   employeeData![key] = value;
        //         //       // });
        //         //       print('vvvvvvvvvvvvvvvvvvvvv');
        //         //       print(employeeMap['UserID']);
        //         //     }
        //         //   });
        //         // }
        //         await userController.updateUserDataPhone(documentSnapshot);
        //         // print('login111');
        //         final SharedPreferenceController sharedPreferenceController =
        //             SharedPreferenceController();
        //         await sharedPreferenceController.updateString(userId);

        //         data['Level'] == 'Employee'
        //             ? await FirebaseFirestore.instance
        //                 .collection('1000')
        //                 .doc('Company')
        //                 .collection('User')
        //                 .doc(data['UserID'])
        //                 .collection('Employee')
        //                 .doc(data['UserID'])
        //                 .get()
        //                 .then((DocumentSnapshot<Map<String, dynamic>> value) {
        //                 final userController = Get.find<UserController>();
        //                 final userData = userController.userData;
        //                 final employeeData = userController.employeeData;

        //                 userController.updateEmployeeData(value);
        //               })
        //             : print(data['Level']);
        //         await saveDataToSharedPreferences('message_key', userId);
        //         await Future.delayed(Duration(seconds: 5))
        //             .then((value) => context.pop());
        //       }
        //     }
        //   } else {
        //     Fluttertoast.showToast(
        //         msg: "ไม่พบหมายเลขสมาชิกนี้ค่ะ",
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.TOP,
        //         timeInSecForIosWeb: 3,
        //         backgroundColor: Colors.red.shade900,
        //         textColor: Colors.white,
        //         fontSize: 16.0);
        //     print('ไม่พบข้อมูลสำหรับเอกสารนี้');
        //     // context.pop();
        //   }
        // } else {
        //   print('login ด้วย userName');
        //   print('login');

        //   // final test = FirebaseFirestore.instance
        //   //     .collection('1000')
        //   //     .doc('Company')
        //   //     .collection('User')
        //   //     .doc(userId)
        //   //     .get();

        //   await FirebaseFirestore.instance
        //       .collection('User')
        //       .where('Username', isEqualTo: userId)
        //       .get()
        //       .then((QuerySnapshot querySnapshot) async {
        //     querySnapshot.docs.forEach(
        //       (doc) async {
        //         // ดึงข้อมูลจากเอกสารแต่ละรายการ
        //         print('1123213');
        //         var data = doc.data();
        //         print(data);
        //         Map<String, dynamic>? dataMap =
        //             doc.data() as Map<String, dynamic>?;
        //         print(dataMap);
        //         if (dataMap!['Password'] != password) {
        //           print('password wrong');

        //           Fluttertoast.showToast(
        //               msg: "คุณกรอกพาสเวิร์ดไม่ถูกค่ะ",
        //               toastLength: Toast.LENGTH_SHORT,
        //               gravity: ToastGravity.TOP,
        //               timeInSecForIosWeb: 3,
        //               backgroundColor: Colors.red.shade900,
        //               textColor: Colors.white,
        //               fontSize: 16.0);
        //           // context.pop();
        //         } else if (dataMap['Status'] == 'UserRemove') {
        //           print('user Romvee Status ');
        //           Fluttertoast.showToast(
        //               msg:
        //                   "ยูเซอร์นี้ทำการลบข้อมูลไว้ค่ะ\n   กรุณาติดต่อพนักงานค่ะ",
        //               toastLength: Toast.LENGTH_SHORT,
        //               gravity: ToastGravity.TOP,
        //               timeInSecForIosWeb: 3,
        //               backgroundColor: Colors.red.shade900,
        //               textColor: Colors.white,
        //               fontSize: 16.0);
        //         } else {
        //           print('login000');
        //           // print(data['UserAppointment']);
        //           // for (var element in dataMap['UserAppointment']) {
        //           //   // print(element['UserAppointmentID']);
        //           //   // print(element);
        //           //   await FirebaseFirestore.instance
        //           //       .collection('1000')
        //           //       .doc('Company')
        //           //       .collection('User')
        //           //       .doc(element['EmployeeID'])
        //           //       .get()
        //           //       .then((DocumentSnapshot<Map<String, dynamic>> value) {
        //           //     if (value.data() != null && value.data()!.isNotEmpty) {
        //           //       final Map<String, dynamic> employeeMap =
        //           //           value.data() as Map<String, dynamic>;
        //           //       // employeeMap.forEach((key, value) {
        //           //       //   employeeData![key] = value;
        //           //       // });
        //           //       print('mmmmmmmmmmmmmmmmmm');
        //           //       print(employeeMap);
        //           //     }
        //           //   });
        //           // }
        //           await userController.updateUserDataUsername(dataMap);
        //           print('login111');
        //           final SharedPreferenceController sharedPreferenceController =
        //               SharedPreferenceController();
        //           print('login222');
        //           await sharedPreferenceController.updateString(userId);
        //           print('login333');
        //           await saveDataToSharedPreferences('message_key', userId);
        //           print('login444');
        //         }
        //       },
        //     );
        //   }).catchError((error) {
        //     print("เกิดข้อผิดพลาด: $error");
        //   });
        //   await Future.delayed(Duration(seconds: 5))
        //       .then((value) => context.push('/'));
        // }

        // context.pop();
      } catch (error) {
        print('error login_screen.dart -> ${error}');
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is Login Screen');
    print('==============================');
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoading == true
            ? DataTransferWidgetNoUser(
                success: isLoading,
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //=================================================================
                                Row(
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    //=================================================================
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 5.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.pop(context);
                                              // context.safePop();
                                            },
                                            child: Icon(
                                              Icons.chevron_left,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), //=================================================================
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 5.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              // context.pushNamed('A01_01_Home');
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: Image.asset(
                                                'assets/images/LINE_ALBUM__231114_1.jpg',
                                                width: 40.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 110.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'มหาชัยฟู้ดส์ จํากัด',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ), //=================================================================
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ระบบจัดการสมาชิก',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                ),
                              ],
                            ), //=================================================================
                            Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    //=================================================================
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'สมัครสมาชิกที่นี่',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'ล็อกอินเข้าสู่ระบบ',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //=================================================================
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              // context.pushNamed('A01_02_Login');
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        A0103RegisterWidget(),
                                                  ));
                                            },
                                            child: Icon(
                                              Icons.account_circle,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 40.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //=================================================================
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        //=================================================================
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 40.0, 0.0, 35.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'กรุณาล็อกอินเข้าสู่ระบบ',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        //=================================================================
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              //=================================================================
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 5.0, 0.0, 5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.00, 0.00),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            controller: textController1,
                                            focusNode: textFieldFocusNode1,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 16.0,
                                                      ),
                                              hintText: 'ชื่อผู้ใช้งาน',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 16.0,
                                                ),
                                            textAlign: TextAlign.center,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            // validator: textController1Validator
                                            //     .asValidator(context),

                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'กรุณาชื่อผู้ใช้งานค่ะ';
                                              }

                                              // if (value == 'jaksu') {
                                              //   return null;
                                              // } else if (value.length < 10 ||
                                              //     value.length > 10) {
                                              //   return 'กรุณาใส่เบอร์โทรศัพท์ 10 หลักค่ะ';
                                              // }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //=================================================================
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 5.0, 0.0, 5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.00, 0.00),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            controller: textController2,
                                            focusNode: textFieldFocusNode2,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              hintText: 'พาสเวิร์ด',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 16.0,
                                                ),
                                            textAlign: TextAlign.center,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            // validator: textController2Validator
                                            //     .asValidator(context),

                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value.length < 8) {
                                                return 'กรุณากรอกพาสเวิร์ดค่ะ';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //=================================================================
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 5.0, 10.0, 5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          // context.pushNamed('A01_04_DataTransfer');

                                          _submitForm();
                                          // Navigator.push(
                                          //     context,
                                          //     CupertinoPageRoute(
                                          //       builder: (context) => DataTransferWidgetNoUser(),
                                          //     ));
                                        },
                                        text: 'กดเข้าสู่ระบบ',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Kanit',
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 3.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // //=================================================================
                              // Padding(
                              //   padding: EdgeInsetsDirectional.fromSTEB(
                              //       10.0, 35.0, 10.0, 5.0),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.max,
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       FFButtonWidget(
                              //         onPressed: () async {
                              //           // Navigator.push(
                              //           //     context,
                              //           //     CupertinoPageRoute(
                              //           //       builder: (context) =>
                              //           //           A0103RegisterWidget(),
                              //           //     ));
                              //         },
                              //         text: 'สมัครสมาชิกใหม่คลิกที่นี่',
                              //         options: FFButtonOptions(
                              //           padding: EdgeInsetsDirectional.fromSTEB(
                              //               24.0, 0.0, 24.0, 0.0),
                              //           iconPadding:
                              //               EdgeInsetsDirectional.fromSTEB(
                              //                   0.0, 0.0, 0.0, 0.0),
                              //           color: FlutterFlowTheme.of(context)
                              //               .primaryText,
                              //           textStyle: FlutterFlowTheme.of(context)
                              //               .titleSmall
                              //               .override(
                              //                 fontFamily: 'Kanit',
                              //                 color: Colors.white,
                              //                 fontSize: 14.0,
                              //                 fontWeight: FontWeight.normal,
                              //               ),
                              //           elevation: 3.0,
                              //           borderSide: BorderSide(
                              //             color: Colors.transparent,
                              //             width: 1.0,
                              //           ),
                              //           borderRadius:
                              //               BorderRadius.circular(8.0),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              //=================================================================
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          // context.pushNamed('A01_06_OTP');
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    A0106OtpWidget(),
                                              ));
                                        },
                                        child: Text(
                                          'ลืมรหัสผ่านคลิกที่นี่',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                fontSize: 14.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //=================================================================
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 40.0, 0.0, 5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: Image.asset(
                                        'assets/images/LINE_ALBUM__231114_1.jpg',
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //=================================================================
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'บริษัท มหาชัยฟู้ดส์ จํากัด',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Kanit',
                                          fontSize: 12.0,
                                        ),
                                  ),
                                ],
                              ),
                              //=================================================================
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'MAHACHAI FOODS COMPANY LIMITED',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Kanit',
                                          fontSize: 12.0,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                            //=================================================================
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
