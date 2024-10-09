import 'dart:io';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_food/controller/shared_preference_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/widgets/data_transfer_widget_no_user.dart';
import 'package:m_food/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:quickalert/quickalert.dart';

class A1101EditUserProfile extends StatefulWidget {
  const A1101EditUserProfile({Key? key}) : super(key: key);

  @override
  _A1101EditUserProfileState createState() => _A1101EditUserProfileState();
}

class _A1101EditUserProfileState extends State<A1101EditUserProfile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  bool isLoading = false;

  //======================================================================
  Image? image;
  final picker = ImagePicker();
  final storage = FirebaseStorage.instance;
  XFile? pickedFileForFirebase;
  //======================================================================
  late FirebaseMessaging messaging;

  TextEditingController textController1 = TextEditingController();
  FocusNode textFieldFocusNode1 = FocusNode();
  TextEditingController textController2 = TextEditingController();
  FocusNode textFieldFocusNode2 = FocusNode();
  TextEditingController textController3 = TextEditingController();
  FocusNode textFieldFocusNode3 = FocusNode();
  TextEditingController textController4 = TextEditingController();
  FocusNode textFieldFocusNode4 = FocusNode();
  TextEditingController textController5 = TextEditingController();
  FocusNode textFieldFocusNode5 = FocusNode();
  TextEditingController textController6 = TextEditingController();
  FocusNode textFieldFocusNode6 = FocusNode();
  TextEditingController textController7 = TextEditingController();
  FocusNode textFieldFocusNode7 = FocusNode();

  bool isLoadingLogout = false;

  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;
    loadData();
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    userData = userController.userData;
    textController1 = TextEditingController(text: userData!['Name']);
    textController2 = TextEditingController(text: userData!['Surname']);
    textController3 = TextEditingController(text: userData!['Phone']);
    textController4 = TextEditingController(text: userData!['Email']);
    textController5 = TextEditingController(text: userData!['Username']);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  //============================================================================
  String message = '';
  final SharedPreferenceController myController = SharedPreferenceController();

  Future<void> saveDataToSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> saveData(String userId) async {
    await saveDataToSharedPreferences('message_key', userId);
    // print('Data saved.');
  }
  // void saveData(String userId) async {
  //   await saveDataToSharedPreferences('message_key', userId);
  //   // print('Data saved.');
  // }

  Future<String?> readDataFromSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  String generateRandomString() {
    // สุ่มตัวเลข 20 หลัก
    String randomNumbers =
        List.generate(20, (_) => Random().nextInt(10).toString()).join();

    // แบ่งตัวเลขเป็นกลุ่ม 4 ตัว
    List<String> numberGroups = List.generate(5, (index) {
      int start = index * 4;
      int end = start + 4;
      return randomNumbers.substring(start, end);
    });

    // สร้างสตริงเช่น 'xxxx-xxxx-xxxx-xxxx-xxxx'
    String formattedString = numberGroups.join('-');

    return formattedString;
  }

  Future<void> saveDataForLogout() async {
    try {
      final userController = Get.find<UserController>();
      setState(() {
        isLoadingLogout = true;
      });

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userController.userData!['UserID'])
          .update(
        {
          'UserTokenID': '',
        },
      ).then((value) async {
        final test =
            FirebaseFirestore.instance.collection('User').doc('NoUser').get();
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await test;
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data();
        } else {
          print('ไม่พบข้อมูลสำหรับเอกสารนี้');
        }
        print('documentdatalogout');
        print(documentSnapshot.data());
        print('savedata');
        await saveData('');
        print('updatestring');
        await myController.updateString('');
        print('updateuser');
        await userController.updateUserDataPhone(documentSnapshot);
        print('logout');
        await Future.delayed(Duration(seconds: 3));
        // .then((value) => context.push('A011_Home'));
      });
    } catch (error) {
      print('error profile_screen.dart -> ${error}');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingLogout = false;
        });
      }
      // runApp(A011HomeWidget());
      Navigator.pop(context);
      Navigator.pop(context);
      // context.push('/');
    }
  }

  //============================================================================

  Future<bool> checkDocument(String phone, String email) async {
    // String userNumberToCheck = "12345";

    // สร้างคำสั่ง query เพื่อค้นหา document
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('Phone', isEqualTo: phone)
        .get();

    QuerySnapshot querySnapshotEmail = await FirebaseFirestore.instance
        .collection('User')
        .where('Email', isEqualTo: email)
        .get();
    // ตรวจสอบว่ามี document ที่ตรงเงื่อนไขหรือไม่
    if (querySnapshot.docs.isNotEmpty || querySnapshotEmail.docs.isNotEmpty) {
      if (querySnapshot.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "หมายเลขโทรศัพท์นี้ มีการสมัครสมาชิกแล้วค่ะ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red.shade900,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        await Future.delayed(Duration(seconds: 2))
            .then((value) => Navigator.pop(context));
      } else {
        Fluttertoast.showToast(
          msg: "อีเมลล์นี้ มีการสมัครสมาชิกแล้วค่ะ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red.shade900,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        await Future.delayed(Duration(seconds: 2))
            .then((value) => Navigator.pop(context));
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      print('Document found');

      print('ไม่พบข้อมูลสำหรับเอกสารนี้');
      return true;
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('UserID', isEqualTo: phone)
          .get();
      print('Document not found');

      if (querySnapshot.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "หมายเลขโทรศัพท์นี้ มีการสมัครสมาชิกแล้วค่ะ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red.shade900,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        await Future.delayed(Duration(seconds: 2))
            .then((value) => Navigator.pop(context));
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        print('Document found');

        print('ไม่พบข้อมูลสำหรับเอกสารนี้');
        return true;
      } else {
        return false;
      }
    }
  }

  String generateRandomNumbers(int length) {
    Random random = Random();
    String result = '';

    for (int i = 0; i < length; i++) {
      result += random.nextInt(10).toString();
    }

    return result;
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        String? downloadURL = '';

        if (pickedFileForFirebase != null) {
          File imageFile = File(pickedFileForFirebase!.path);

          String imageName = DateTime.now().millisecondsSinceEpoch.toString();
          String imageFileName = "${textController3.text}.jpg";
          // print('sign up111');
          Reference ref = storage
              .ref()
              .child("images")
              .child("Users")
              .child(textController3.text)
              .child(imageFileName);
          // print(ref);
          await ref.putFile(imageFile);
          downloadURL = await ref.getDownloadURL();

          print("URL ของรูปภาพ: $downloadURL");
        }

        await FirebaseFirestore.instance
            .collection('User')
            .doc(userData!['UserID'])
            .update(
          {
            // 'UserID': userData!['UserID'],
            'Name': textController1.text,
            'Surname': textController2.text,
            'Phone': textController3.text,
            'Username': textController5.text,
            'DateUpdate': DateTime.now(),
            'Img': downloadURL == '' ? userData!['Img'] : downloadURL,
            'Email': textController4.text,
          },
        ).then((value) async {
          saveData(userData!['UserID']);
          final SharedPreferenceController myController =
              SharedPreferenceController();
          myController.updateString(userData!['UserID']);
          final userController = Get.find<UserController>();
          final test = FirebaseFirestore.instance
              .collection('User')
              .doc(userData!['UserID'])
              .get();
          final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              await test;

          await userController.updateUserDataPhone(documentSnapshot);
        });
        setState(() {});

        // Navigator.pop(context);
        Navigator.pop(context);
      } catch (error) {
        print('error signup_screen.dart -> ${error}');
      } finally {
        if (mounted) {
          setState(() {
            pickedFileForFirebase = null;
            image = null;
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A1101 Edit User Profile ');
    print('==============================');

    String formatThaiDate(Timestamp timestamp) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
      );

      // แปลงปีคริสต์ศักราชเป็นปีพุทธศักราชโดยการเพิ่ม 543
      int thaiYear = dateTime.year + 543;

      // ใช้ intl package เพื่อแปลงรูปแบบวันที่
      String formattedDate = DateFormat('dd-MM-yyyy')
          .format(DateTime(dateTime.year, dateTime.month, dateTime.day));
      formattedDate = formattedDate.substring(0, formattedDate.length - 4);
      // เพิ่มปีพุทธศักราช
      formattedDate += '$thaiYear';

      return formattedDate;
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoadingLogout == true
            ? DataTransferWidgetNoUser(
                success: isLoading,
              )
            : isLoading == true
                ? DataTransferWidgetNoUser(
                    success: isLoading,
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //======================== AppBar =====================================
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 10.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  // context.safePop();
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(
                                                  Icons.chevron_left,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 10.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  // context.pushNamed('A01_01_Home');
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
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
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'มหาชัยฟู้ดส์ จํากัด',
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
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'เปิดหน้าบัญชีใหม่เข้าระบบ',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Kanit',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            userData!.isNotEmpty
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        '${userData!['Name']} ${userData!['Surname']}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'สมัครสมาชิกที่นี่',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                            userData!.isNotEmpty
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        // 'Last login ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(
                                                        //   userData!['DateUpdate']
                                                        //               .seconds *
                                                        //           1000 +
                                                        //       (userData!['DateUpdate']
                                                        //                   .nanoseconds /
                                                        //               1000000)
                                                        //           .round(),
                                                        // ))}',
                                                        'Last login ${formatThaiDate(userData!['DateUpdate'])}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'ล็อกอินเข้าสู่ระบบ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        userData!.isNotEmpty
                                            ? Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // saveDataForLogout();

                                                    // Navigator.pushReplacement(
                                                    //     context,
                                                    //     CupertinoPageRoute(
                                                    //       builder: (context) =>
                                                    //           A0105DashboardWidget(),
                                                    //     )).then((value) {
                                                    //   Navigator.pop(context);
                                                    //   if (mounted) {
                                                    //     setState(() {});
                                                    //   }
                                                    // });
                                                    Navigator.pop(context);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    maxRadius: 20,
                                                    // radius: 1,
                                                    backgroundImage: userData![
                                                                'Img'] ==
                                                            ''
                                                        ? null
                                                        : NetworkImage(
                                                            userData!['Img']),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        // saveDataForLogout();
                                                      },
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 40.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //===================================================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 40.0, 0.0, 35.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'กรุณากรอกข้อมูลของท่าน',
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
                            //===================================================================
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //===================================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                controller: textController1,
                                                focusNode: textFieldFocusNode1,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            fontSize: 16.0,
                                                          ),
                                                  hintText: 'ชื่อจริง',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 14.0,
                                                        ),
                                                textAlign: TextAlign.center,
                                                // validator: textController1Validator
                                                //     .asValidator(context),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'กรุณาใส่ชื่อจริงค่ะ';
                                                  }
                                                  if (value.length > 30) {
                                                    return 'กรุณาใส่ชื่อจริง 30 ตัวอักษรค่ะ';
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
                                  //===================================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                controller: textController2,
                                                focusNode: textFieldFocusNode2,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            fontSize: 16.0,
                                                          ),
                                                  hintText: 'นามสกุล',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 14.0,
                                                        ),
                                                textAlign: TextAlign.center,
                                                // validator: textController2Validator
                                                //     .asValidator(context),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'กรุณาใส่นามสกุลค่ะ';
                                                  }
                                                  if (value.length > 30) {
                                                    return 'กรุณาใส่นามสกุลไม่เกิน 30 ตัวอักษรค่ะ';
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
                                  //===================================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                controller: textController3,
                                                focusNode: textFieldFocusNode3,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            fontSize: 16.0,
                                                          ),
                                                  hintText: 'เบอร์โทรศัพท์',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 12.0,
                                                        ),
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                // validator: textController3Validator
                                                //     .asValidator(context),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'กรุณาใส่เบอร์โทรศัพท์ค่ะ';
                                                  }
                                                  if (value.length < 10 ||
                                                      value.length > 10) {
                                                    return 'กรุณาใส่เบอร์โทรศัพท์ 10 หลักค่ะ';
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
                                  //===================================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                controller: textController4,
                                                focusNode: textFieldFocusNode4,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            fontSize: 16.0,
                                                          ),
                                                  hintText: 'อีเมล์',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 12.0,
                                                        ),
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                // validator: textController4Validator
                                                //     .asValidator(context),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'กรุณาใส่อีเมลล์ค่ะ';
                                                  }
                                                  // if (value.isEmpty) {
                                                  //   return 'กรุณาใส่อีเมลล์ค่ะ';
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
                                  //===================================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                controller: textController5,
                                                focusNode: textFieldFocusNode5,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            fontSize: 16.0,
                                                          ),
                                                  hintText:
                                                      'ตั้งยูสเซอร์เนมของท่าน',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 12.0,
                                                        ),
                                                textAlign: TextAlign.center,
                                                // validator: textController5Validator
                                                //     .asValidator(context),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'กรุณาใส่ชื่อยูเซอร์เนมค่ะ';
                                                  }
                                                  if (value.length > 20) {
                                                    return 'กรุณาใส่ชื่อยูเซอร์เนมไม่เกิน 20 ตัวอักษรค่ะ';
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
                                  //===================================================================
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                  //       10.0, 5.0, 10.0, 5.0),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     children: [
                                  //       Expanded(
                                  //         child: Align(
                                  //           alignment:
                                  //               AlignmentDirectional(0.00, 0.00),
                                  //           child: Padding(
                                  //             padding:
                                  //                 EdgeInsetsDirectional.fromSTEB(
                                  //                     8.0, 0.0, 8.0, 0.0),
                                  //             child: TextFormField(
                                  //               controller: textController6,
                                  //               focusNode: textFieldFocusNode6,
                                  //               autofocus: false,
                                  //               obscureText: false,
                                  //               decoration: InputDecoration(
                                  //                 isDense: true,
                                  //                 labelStyle:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .labelMedium
                                  //                         .override(
                                  //                           fontFamily: 'Kanit',
                                  //                           fontSize: 16.0,
                                  //                         ),
                                  //                 hintText: 'ตั้งพาสเวิร์ของท่าน',
                                  //                 hintStyle:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .labelMedium,
                                  //                 enabledBorder: OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .alternate,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //                 focusedBorder: OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .primary,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //                 errorBorder: OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .error,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //                 focusedErrorBorder:
                                  //                     OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .error,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //               ),
                                  //               style: FlutterFlowTheme.of(context)
                                  //                   .bodyMedium
                                  //                   .override(
                                  //                     fontFamily: 'Kanit',
                                  //                     fontSize: 12.0,
                                  //                   ),
                                  //               textAlign: TextAlign.center,
                                  //               keyboardType:
                                  //                   TextInputType.visiblePassword,
                                  //               // validator: textController6Validator
                                  //               //     .asValidator(context),
                                  //               validator: (value) {
                                  //                 if (value!.isEmpty ||
                                  //                     value.length < 8) {
                                  //                   return 'กรุณาตั้งพาสเวิร์ด 8 ตัวอักษรค่ะ';
                                  //                 }

                                  //                 if (textController6.text !=
                                  //                     textController7.text) {
                                  //                   return 'กรุณาตั้งพาสเวิร์ดให้ตรงกันค่ะ';
                                  //                 }
                                  //                 return null;
                                  //               },
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // //===================================================================
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                  //       10.0, 5.0, 10.0, 5.0),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     children: [
                                  //       Expanded(
                                  //         child: Align(
                                  //           alignment:
                                  //               AlignmentDirectional(0.00, 0.00),
                                  //           child: Padding(
                                  //             padding:
                                  //                 EdgeInsetsDirectional.fromSTEB(
                                  //                     8.0, 0.0, 8.0, 0.0),
                                  //             child: TextFormField(
                                  //               controller: textController7,
                                  //               focusNode: textFieldFocusNode7,
                                  //               autofocus: false,
                                  //               obscureText: false,
                                  //               decoration: InputDecoration(
                                  //                 isDense: true,
                                  //                 labelStyle:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .labelMedium
                                  //                         .override(
                                  //                           fontFamily: 'Kanit',
                                  //                           fontSize: 16.0,
                                  //                         ),
                                  //                 hintText:
                                  //                     'พิมพ์พาสเวิร์ดอีกครั้งให้เหมือนกัน',
                                  //                 hintStyle:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .labelMedium,
                                  //                 enabledBorder: OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .alternate,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //                 focusedBorder: OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .primary,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //                 errorBorder: OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .error,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //                 focusedErrorBorder:
                                  //                     OutlineInputBorder(
                                  //                   borderSide: BorderSide(
                                  //                     color: FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .error,
                                  //                     width: 2.0,
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(8.0),
                                  //                 ),
                                  //               ),
                                  //               style: FlutterFlowTheme.of(context)
                                  //                   .bodyMedium
                                  //                   .override(
                                  //                     fontFamily: 'Kanit',
                                  //                     fontSize: 12.0,
                                  //                   ),
                                  //               textAlign: TextAlign.center,
                                  //               keyboardType:
                                  //                   TextInputType.visiblePassword,
                                  //               // validator: textController7Validator
                                  //               //     .asValidator(context),
                                  //               validator: (value) {
                                  //                 if (value!.isEmpty ||
                                  //                     value.length < 8) {
                                  //                   return 'กรุณาตั้งพาสเวิร์ด 8 ตัวอักษรค่ะ';
                                  //                 }
                                  //                 if (textController6.text !=
                                  //                     textController7.text) {
                                  //                   return 'กรุณาตั้งพาสเวิร์ดให้ตรงกันค่ะ';
                                  //                 }
                                  //                 return null;
                                  //               },
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  //===================================================================
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                  //       10.0, 0.0, 10.0, 10.0),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     children: [
                                  //       Align(
                                  //         alignment: AlignmentDirectional(0.00, 0.00),
                                  //         child: Container(
                                  //           width: 366.0,
                                  //           // height: 52.0,
                                  //           decoration: BoxDecoration(),
                                  //           child: Align(
                                  //             alignment: AlignmentDirectional(0.00, 0.00),
                                  //             child: Padding(
                                  //               padding: EdgeInsetsDirectional.fromSTEB(
                                  //                   0.0, 5.0, 0.0, 0.0),
                                  //               child: GestureDetector(
                                  //                 onTap: () => showQucikAlert(context),

                                  //                 //  showDialog(
                                  //                 //   context: context,
                                  //                 //   builder: (BuildContext ctx) {
                                  //                 //     return showDialogChooseImage(
                                  //                 //         context);
                                  //                 //   },
                                  //                 // ),
                                  //                 child: image != null
                                  //                     ? Stack(
                                  //                         children: [
                                  //                           CircleAvatar(
                                  //                             radius: 75,
                                  //                             backgroundColor: Colors.white,
                                  //                             child: GestureDetector(
                                  //                               onTap: () =>
                                  //                                   showQucikAlert(context),
                                  //                               //     showDialog(
                                  //                               //   context: context,
                                  //                               //   builder:
                                  //                               //       (BuildContext
                                  //                               //           ctx) {
                                  //                               //     return showDialogChooseImage(
                                  //                               //         context);
                                  //                               //   },
                                  //                               // ),
                                  //                               child: ClipRRect(
                                  //                                 borderRadius:
                                  //                                     BorderRadius.circular(
                                  //                                         70),
                                  //                                 child: image!,
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //                           Positioned(
                                  //                             left: 36.5,
                                  //                             bottom: 45,
                                  //                             child: GestureDetector(
                                  //                               onTap: () =>
                                  //                                   showQucikAlert(context),
                                  //                               //     showDialog(
                                  //                               //   context: context,
                                  //                               //   builder:
                                  //                               //       (BuildContext
                                  //                               //           ctx) {
                                  //                               //     return showDialogChooseImage(
                                  //                               //         context);
                                  //                               //   },
                                  //                               // ),
                                  //                               child: Opacity(
                                  //                                 opacity: 0,
                                  //                                 child: Column(
                                  //                                   children: [
                                  //                                     Icon(
                                  //                                       Icons.image,
                                  //                                       size: MediaQuery.of(
                                  //                                                   context)
                                  //                                               .size
                                  //                                               .height *
                                  //                                           0.04,
                                  //                                       color: Colors.white,
                                  //                                     ),
                                  //                                     CustomText(
                                  //                                       text: 'แก้ไขรูปภาพ',
                                  //                                       size: MediaQuery.of(
                                  //                                                   context)
                                  //                                               .size
                                  //                                               .height *
                                  //                                           0.015,
                                  //                                       color: Colors.white,
                                  //                                     )
                                  //                                   ],
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //                         ],
                                  //                       )
                                  //                     : Column(
                                  //                         mainAxisSize: MainAxisSize.max,
                                  //                         children: [
                                  //                           Row(
                                  //                             mainAxisSize:
                                  //                                 MainAxisSize.max,
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment.center,
                                  //                             children: [
                                  //                               Icon(
                                  //                                 Icons.image,
                                  //                                 color:
                                  //                                     FlutterFlowTheme.of(
                                  //                                             context)
                                  //                                         .secondaryText,
                                  //                                 size: 24.0,
                                  //                               ),
                                  //                             ],
                                  //                           ),
                                  //                           Row(
                                  //                             mainAxisSize:
                                  //                                 MainAxisSize.max,
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment.center,
                                  //                             children: [
                                  //                               Text(
                                  //                                 'เพิ่มรูปภาพ',
                                  //                                 style: FlutterFlowTheme
                                  //                                         .of(context)
                                  //                                     .bodyMedium
                                  //                                     .override(
                                  //                                       fontFamily: 'Kanit',
                                  //                                       fontSize: 12.0,
                                  //                                     ),
                                  //                               ),
                                  //                             ],
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  //OLD
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                  //       10.0, 10.0, 10.0, 10.0),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //       Align(
                                  //         alignment: AlignmentDirectional(0.00, 0.00),
                                  //         child: Padding(
                                  //           padding: EdgeInsetsDirectional.fromSTEB(
                                  //               0.0, 5.0, 0.0, 0.0),
                                  //           child: Column(
                                  //             mainAxisSize: MainAxisSize.max,
                                  //             children: [
                                  //               Row(
                                  //                 mainAxisSize: MainAxisSize.max,
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.center,
                                  //                 children: [
                                  //                   Icon(
                                  //                     Icons.image,
                                  //                     color: FlutterFlowTheme.of(context)
                                  //                         .secondaryText,
                                  //                     size: 24.0,
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Row(
                                  //                 mainAxisSize: MainAxisSize.max,
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.center,
                                  //                 children: [
                                  //                   Text(
                                  //                     'เพิ่มรูปภาพ',
                                  //                     style: FlutterFlowTheme.of(context)
                                  //                         .bodyMedium
                                  //                         .override(
                                  //                           fontFamily: 'Kanit',
                                  //                           fontSize: 12.0,
                                  //                         ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 10.0, 10.0, 10.0),
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await showDialogChooseImage(
                                                      context);

                                                  setState(
                                                    () {},
                                                  );
                                                },
                                                child: image != null
                                                    ? Stack(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 75,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                await showDialogChooseImage(
                                                                    context);

                                                                setState(
                                                                  () {},
                                                                );
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            70),
                                                                child: image!,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 36.5,
                                                            bottom: 45,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                await showDialogChooseImage(
                                                                    context);

                                                                setState(
                                                                  () {},
                                                                );
                                                              },
                                                              child: Opacity(
                                                                opacity: 0,
                                                                child: Column(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.04,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    CustomText(
                                                                      text:
                                                                          'แก้ไขรูปภาพ',
                                                                      size: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.015,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : userData!['Img'] != ''
                                                        ? Stack(
                                                            children: [
                                                              CircleAvatar(
                                                                  radius: 75,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          userData![
                                                                              'Img'])
                                                                  // Image.network(
                                                                  //     userData![
                                                                  //         'Img'],
                                                                  //     fit: BoxFit
                                                                  //         .fill),
                                                                  // child:
                                                                  //     GestureDetector(
                                                                  //   onTap:
                                                                  //       () async {
                                                                  //     await showDialogChooseImage(
                                                                  //         context);

                                                                  //     setState(
                                                                  //       () {},
                                                                  //     );
                                                                  //   },
                                                                  //   child:
                                                                  //       ClipRRect(
                                                                  //     borderRadius:
                                                                  //         BorderRadius.circular(
                                                                  //             10),
                                                                  //     child: Image.network(
                                                                  //         userData![
                                                                  //             'Img'],
                                                                  //         fit: BoxFit
                                                                  //             .fill),
                                                                  //   ),
                                                                  // ),
                                                                  ),
                                                              // Positioned(
                                                              //   left: 36.5,
                                                              //   bottom: 45,
                                                              //   child:
                                                              //       GestureDetector(
                                                              //     onTap:
                                                              //         () async {
                                                              //       await showDialogChooseImage(
                                                              //           context);

                                                              //       setState(
                                                              //         () {},
                                                              //       );
                                                              //     },
                                                              //     child:
                                                              //         Opacity(
                                                              //       opacity: 0,
                                                              //       child:
                                                              //           Column(
                                                              //         children: [
                                                              //           Icon(
                                                              //             Icons
                                                              //                 .image,
                                                              //             size: MediaQuery.of(context).size.height *
                                                              //                 0.04,
                                                              //             color:
                                                              //                 Colors.white,
                                                              //           ),
                                                              //           CustomText(
                                                              //             text:
                                                              //                 'แก้ไขรูปภาพ',
                                                              //             size: MediaQuery.of(context).size.height *
                                                              //                 0.015,
                                                              //             color:
                                                              //                 Colors.white,
                                                              //           )
                                                              //         ],
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          )
                                                        : Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.image,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    size: 24.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'เพิ่มรูปภาพ',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          fontSize:
                                                                              12.0,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  //===================================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                print('login');
                                                print(isLoading);
                                                _submitForm();

                                                // context.pushNamed('A011_Home');
                                                // context.pushNamed('A063_DataTransfer');
                                              },
                                              // onPressed: () async {
                                              //   context.pushNamed('A01_04_DataTransfer');
                                              // },
                                              text: 'ส่งข้อมูลเข้าระบบ',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  //===================================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 5.0, 10.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                print('login');
                                                print(isLoading);
                                                // _submitForm();
                                                await saveDataForLogout();

                                                // context.pushNamed('A011_Home');
                                                // context.pushNamed('A063_DataTransfer');
                                              },
                                              // onPressed: () async {
                                              //   context.pushNamed('A01_04_DataTransfer');
                                              // },
                                              text: 'ออกจากระบบ',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: Colors.red.shade900,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  //===================================================================
                                  //Logo
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 40.0, 0.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
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
                                  //===================================================================
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
                                  //===================================================================
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

  Future<dynamic> showQucikAlert(BuildContext context) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'ยกเลิก',

      // customAsset: 'assets/custom.gif',
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
              child: Text(
                "กรุณาเลือกรูปแบบค่ะ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(),
            Container(
              // color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.06,
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera, // ใช้กล้องถ่ายรูป
                  );
                  pickedFileForFirebase = pickedFile;
                  if (pickedFile != null) {
                    File imageFile = File(pickedFile.path);
                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                      sourcePath: imageFile.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                        CropAspectRatioPreset.ratio3x2,
                        CropAspectRatioPreset.original,
                        CropAspectRatioPreset.ratio4x3,
                        CropAspectRatioPreset.ratio16x9
                      ],
                      uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: Colors.deepOrange,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false),
                        IOSUiSettings(
                          title: 'Cropper',
                        ),
                        WebUiSettings(
                          context: context,
                        ),
                      ],
                    );
                    // ImageCropper.ccropImage(
                    //   sourcePath: imageFile.path
                    //       , // ระบุ path ของรูปที่ต้องการครอบตัด
                    //   // เพิ่มตัวเลือกตามต้องการ (optional)
                    //   aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                    //   maxWidth: 512,
                    //   maxHeight: 512,
                    // );

                    if (croppedFile != null) {
                      List<int> bytes = await croppedFile.readAsBytes();

                      setState(() {
                        // pickedFileForFirebase = File(croppedFile!.path);
                        pickedFileForFirebase = XFile(croppedFile.path);
                        image = Image.memory(
                          Uint8List.fromList(bytes),
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        );
                      });
                    }

                    // setState(() {
                    //   image = Image.file(
                    //     File(pickedFile.path),
                    //     width: 140,
                    //     height: 140,
                    //     fit: BoxFit.cover,
                    //   );
                    // });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(
                      'กล้องถ่ายรูป',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.06,
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery, // เลือกจากแกลลอรี
                  );
                  pickedFileForFirebase = pickedFile;
                  if (pickedFile != null) {
                    File imageFile = File(pickedFile.path);
                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                      sourcePath: imageFile.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                        CropAspectRatioPreset.ratio3x2,
                        CropAspectRatioPreset.original,
                        CropAspectRatioPreset.ratio4x3,
                        CropAspectRatioPreset.ratio16x9
                      ],
                      uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: Colors.deepOrange,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false),
                        IOSUiSettings(
                          title: 'Cropper',
                        ),
                        WebUiSettings(
                          context: context,
                        ),
                      ],
                    );
                    // ImageCropper.ccropImage(
                    //   sourcePath: imageFile.path
                    //       , // ระบุ path ของรูปที่ต้องการครอบตัด
                    //   // เพิ่มตัวเลือกตามต้องการ (optional)
                    //   aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                    //   maxWidth: 512,
                    //   maxHeight: 512,
                    // );

                    if (croppedFile != null) {
                      List<int> bytes = await croppedFile.readAsBytes();

                      setState(() {
                        pickedFileForFirebase = XFile(croppedFile.path);
                        image = Image.memory(
                          Uint8List.fromList(bytes),
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        );
                      });
                    }
                    // setState(() {
                    //   image = Image.file(
                    //     File(pickedFile.path),
                    //     width: 140,
                    //     height: 140,
                    //     fit: BoxFit.cover,
                    //   );
                    // });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(
                      'แกลลอรี่',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   // color: Colors.white,
            //   width: MediaQuery.of(context).size.width * 0.60,
            //   height: MediaQuery.of(context).size.height * 0.06,
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         image = null;
            //       });
            //       Navigator.pop(context);
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Icon(
            //           Icons.delete,
            //           color: Colors.red.shade500,
            //           size: MediaQuery.of(context).size.height * 0.03,
            //         ),
            //         SizedBox(
            //           width: MediaQuery.of(context).size.width * 0.03,
            //         ),
            //         Text(
            //           'ลบรูปภาพ',
            //           style: TextStyle(
            //             fontSize: MediaQuery.of(context).size.height * 0.02,
            //             color: Colors.red.shade500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.60,
            //   color: null,
            //   height: MediaQuery.of(context).size.height * 0.10,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       TextButton(
            //           style: ButtonStyle(
            //             side: MaterialStatePropertyAll(
            //               BorderSide(color: Colors.red.shade300, width: 1),
            //             ),
            //           ),
            //           onPressed: () => Navigator.pop(context),
            //           child: CustomText(
            //             text: "ยกเลิก",
            //             size: MediaQuery.of(context).size.height * 0.15,
            //             color: Colors.red.shade300,
            //           )),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      onConfirmBtnTap: () async {
        // await Future.delayed(const Duration(milliseconds: 1000));
        Navigator.pop(context);
      },
      confirmBtnColor: Colors.red.shade900,
    );
  }

  Future<dynamic> showDialogChooseImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            // title: Text('Dialog Title'),
            // content: Text('This is the dialog content.'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                      child: Text(
                        "กรุณาเลือกรูปแบบค่ะ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Divider(),
                    Container(
                      // color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await picker.pickImage(
                            maxWidth: 500,
                            source: ImageSource.camera, // ใช้กล้องถ่ายรูป
                          );
                          pickedFileForFirebase = pickedFile;
                          if (pickedFile != null) {
                            File imageFile = File(pickedFile.path);
                            CroppedFile? croppedFile =
                                await ImageCropper().cropImage(
                              sourcePath: imageFile.path,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.square,
                                CropAspectRatioPreset.ratio3x2,
                                CropAspectRatioPreset.original,
                                CropAspectRatioPreset.ratio4x3,
                                CropAspectRatioPreset.ratio16x9
                              ],
                              uiSettings: [
                                AndroidUiSettings(
                                    toolbarTitle: 'Cropper',
                                    toolbarColor: Colors.deepOrange,
                                    toolbarWidgetColor: Colors.white,
                                    initAspectRatio:
                                        CropAspectRatioPreset.original,
                                    lockAspectRatio: false),
                                IOSUiSettings(
                                  title: 'Cropper',
                                ),
                                WebUiSettings(
                                  context: context,
                                ),
                              ],
                            );
                            // ImageCropper.ccropImage(
                            //   sourcePath: imageFile.path
                            //       , // ระบุ path ของรูปที่ต้องการครอบตัด
                            //   // เพิ่มตัวเลือกตามต้องการ (optional)
                            //   aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                            //   maxWidth: 512,
                            //   maxHeight: 512,
                            // );
                            print('crop');
                            print(croppedFile);

                            if (croppedFile != null) {
                              List<int> bytes = await croppedFile.readAsBytes();
                              // pickedFileForFirebase = File(croppedFile!.path);
                              pickedFileForFirebase = XFile(croppedFile.path);
                              image = Image.memory(
                                Uint8List.fromList(bytes),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              );
                              // if (mounted) {
                              //   setState(() {});
                              // }
                            }

                            // setState(() {
                            //   image = Image.file(
                            //     File(pickedFile.path),
                            //     width: 140,
                            //     height: 140,
                            //     fit: BoxFit.cover,
                            //   );
                            // });
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'กล้องถ่ายรูป',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await picker.pickImage(
                            maxWidth: 500,
                            source: ImageSource.gallery, // เลือกจากแกลลอรี
                          );
                          pickedFileForFirebase = pickedFile;
                          if (pickedFile != null) {
                            File imageFile = File(pickedFile.path);
                            CroppedFile? croppedFile =
                                await ImageCropper().cropImage(
                              sourcePath: imageFile.path,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.square,
                                CropAspectRatioPreset.ratio3x2,
                                CropAspectRatioPreset.original,
                                CropAspectRatioPreset.ratio4x3,
                                CropAspectRatioPreset.ratio16x9
                              ],
                              uiSettings: [
                                AndroidUiSettings(
                                    toolbarTitle: 'Cropper',
                                    toolbarColor: Colors.deepOrange,
                                    toolbarWidgetColor: Colors.white,
                                    initAspectRatio:
                                        CropAspectRatioPreset.original,
                                    lockAspectRatio: false),
                                IOSUiSettings(
                                  title: 'Cropper',
                                ),
                                WebUiSettings(
                                  context: context,
                                ),
                              ],
                            );

                            if (croppedFile != null) {
                              List<int> bytes = await croppedFile.readAsBytes();
                              // pickedFileForFirebase = File(croppedFile!.path);
                              pickedFileForFirebase = XFile(croppedFile.path);
                              image = Image.memory(
                                Uint8List.fromList(bytes),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              );
                              // if (mounted) {
                              //   setState(() {});
                              // }
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'แกลลอรี่',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   // color: Colors.white,
                    //   width: MediaQuery.of(context).size.width * 0.60,
                    //   height: MediaQuery.of(context).size.height * 0.06,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         image = null;
                    //       });
                    //       Navigator.pop(context);
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Icon(
                    //           Icons.delete,
                    //           color: Colors.red.shade500,
                    //           size: MediaQuery.of(context).size.height * 0.03,
                    //         ),
                    //         SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.03,
                    //         ),
                    //         Text(
                    //           'ลบรูปภาพ',
                    //           style: TextStyle(
                    //             fontSize: MediaQuery.of(context).size.height * 0.02,
                    //             color: Colors.red.shade500,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.60,
                    //   color: null,
                    //   height: MediaQuery.of(context).size.height * 0.10,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       TextButton(
                    //           style: ButtonStyle(
                    //             side: MaterialStatePropertyAll(
                    //               BorderSide(color: Colors.red.shade300, width: 1),
                    //             ),
                    //           ),
                    //           onPressed: () => Navigator.pop(context),
                    //           child: CustomText(
                    //             text: "ยกเลิก",
                    //             size: MediaQuery.of(context).size.height * 0.15,
                    //             color: Colors.red.shade300,
                    //           )),
                    //     ],
                    //   ),
                    // )

                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            style: ButtonStyle(
                              side: MaterialStatePropertyAll(
                                BorderSide(
                                    color: Colors.red.shade300, width: 1),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: CustomText(
                              text: "   ยกเลิก   ",
                              size: MediaQuery.of(context).size.height * 0.15,
                              color: Colors.red.shade300,
                            )),
                        TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blue.shade900),
                              // side: MaterialStatePropertyAll(
                              // BorderSide(
                              //     color: Colors.red.shade300, width: 1),
                              // ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                              text: "   บันทึก   ",
                              size: MediaQuery.of(context).size.height * 0.15,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  // AlertDialog showDialogChooseImage(BuildContext context) {
  //   return AlertDialog(
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //     ),
  //     actions: [
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
  //               child: Text(
  //                 "กรุณาเลือกรูปแบบค่ะ",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 20,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ),
  //             const Divider(),
  //             Container(
  //               // color: Colors.white,
  //               width: MediaQuery.of(context).size.width * 0.60,
  //               height: MediaQuery.of(context).size.height * 0.06,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   Navigator.pop(context);
  //                   final pickedFile = await picker.pickImage(
  //                     source: ImageSource.camera, // ใช้กล้องถ่ายรูป
  //                   );
  //                   pickedFileForFirebase = pickedFile;
  //                   if (pickedFile != null) {
  //                     File imageFile = File(pickedFile.path);
  //                     CroppedFile? croppedFile = await ImageCropper().cropImage(
  //                       sourcePath: imageFile.path,
  //                       aspectRatioPresets: [
  //                         CropAspectRatioPreset.square,
  //                         CropAspectRatioPreset.ratio3x2,
  //                         CropAspectRatioPreset.original,
  //                         CropAspectRatioPreset.ratio4x3,
  //                         CropAspectRatioPreset.ratio16x9
  //                       ],
  //                       uiSettings: [
  //                         AndroidUiSettings(
  //                             toolbarTitle: 'Cropper',
  //                             toolbarColor: Colors.deepOrange,
  //                             toolbarWidgetColor: Colors.white,
  //                             initAspectRatio: CropAspectRatioPreset.original,
  //                             lockAspectRatio: false),
  //                         IOSUiSettings(
  //                           title: 'Cropper',
  //                         ),
  //                         WebUiSettings(
  //                           context: context,
  //                         ),
  //                       ],
  //                     );
  //                     // ImageCropper.ccropImage(
  //                     //   sourcePath: imageFile.path
  //                     //       , // ระบุ path ของรูปที่ต้องการครอบตัด
  //                     //   // เพิ่มตัวเลือกตามต้องการ (optional)
  //                     //   aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
  //                     //   maxWidth: 512,
  //                     //   maxHeight: 512,
  //                     // );

  //                     if (croppedFile != null) {
  //                       List<int> bytes = await croppedFile.readAsBytes();

  //                       setState(() {
  //                         // pickedFileForFirebase = File(croppedFile!.path);
  //                         pickedFileForFirebase = XFile(croppedFile.path);
  //                         image = Image.memory(
  //                           Uint8List.fromList(bytes),
  //                           width: 140,
  //                           height: 140,
  //                           fit: BoxFit.cover,
  //                         );
  //                       });
  //                     }

  //                     // setState(() {
  //                     //   image = Image.file(
  //                     //     File(pickedFile.path),
  //                     //     width: 140,
  //                     //     height: 140,
  //                     //     fit: BoxFit.cover,
  //                     //   );
  //                     // });
  //                   }
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Icon(
  //                       Icons.camera_alt,
  //                       color: Colors.black,
  //                       size: MediaQuery.of(context).size.height * 0.03,
  //                     ),
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width * 0.03,
  //                     ),
  //                     Text(
  //                       'กล้องถ่ายรูป',
  //                       style: TextStyle(
  //                         fontSize: MediaQuery.of(context).size.height * 0.02,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               // color: Colors.white,
  //               width: MediaQuery.of(context).size.width * 0.60,
  //               height: MediaQuery.of(context).size.height * 0.06,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   Navigator.pop(context);
  //                   final pickedFile = await picker.pickImage(
  //                     source: ImageSource.gallery, // เลือกจากแกลลอรี
  //                   );
  //                   pickedFileForFirebase = pickedFile;
  //                   if (pickedFile != null) {
  //                     File imageFile = File(pickedFile.path);
  //                     CroppedFile? croppedFile = await ImageCropper().cropImage(
  //                       sourcePath: imageFile.path,
  //                       aspectRatioPresets: [
  //                         CropAspectRatioPreset.square,
  //                         CropAspectRatioPreset.ratio3x2,
  //                         CropAspectRatioPreset.original,
  //                         CropAspectRatioPreset.ratio4x3,
  //                         CropAspectRatioPreset.ratio16x9
  //                       ],
  //                       uiSettings: [
  //                         AndroidUiSettings(
  //                             toolbarTitle: 'Cropper',
  //                             toolbarColor: Colors.deepOrange,
  //                             toolbarWidgetColor: Colors.white,
  //                             initAspectRatio: CropAspectRatioPreset.original,
  //                             lockAspectRatio: false),
  //                         IOSUiSettings(
  //                           title: 'Cropper',
  //                         ),
  //                         WebUiSettings(
  //                           context: context,
  //                         ),
  //                       ],
  //                     );
  //                     // ImageCropper.ccropImage(
  //                     //   sourcePath: imageFile.path
  //                     //       , // ระบุ path ของรูปที่ต้องการครอบตัด
  //                     //   // เพิ่มตัวเลือกตามต้องการ (optional)
  //                     //   aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
  //                     //   maxWidth: 512,
  //                     //   maxHeight: 512,
  //                     // );

  //                     if (croppedFile != null) {
  //                       List<int> bytes = await croppedFile.readAsBytes();

  //                       setState(() {
  //                         pickedFileForFirebase = XFile(croppedFile.path);
  //                         image = Image.memory(
  //                           Uint8List.fromList(bytes),
  //                           width: 140,
  //                           height: 140,
  //                           fit: BoxFit.cover,
  //                         );
  //                       });
  //                     }
  //                     // setState(() {
  //                     //   image = Image.file(
  //                     //     File(pickedFile.path),
  //                     //     width: 140,
  //                     //     height: 140,
  //                     //     fit: BoxFit.cover,
  //                     //   );
  //                     // });
  //                   }
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Icon(
  //                       Icons.image,
  //                       color: Colors.black,
  //                       size: MediaQuery.of(context).size.height * 0.03,
  //                     ),
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width * 0.03,
  //                     ),
  //                     Text(
  //                       'แกลลอรี่',
  //                       style: TextStyle(
  //                         fontSize: MediaQuery.of(context).size.height * 0.02,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             // Container(
  //             //   // color: Colors.white,
  //             //   width: MediaQuery.of(context).size.width * 0.60,
  //             //   height: MediaQuery.of(context).size.height * 0.06,
  //             //   child: GestureDetector(
  //             //     onTap: () {
  //             //       setState(() {
  //             //         image = null;
  //             //       });
  //             //       Navigator.pop(context);
  //             //     },
  //             //     child: Row(
  //             //       mainAxisAlignment: MainAxisAlignment.start,
  //             //       children: [
  //             //         Icon(
  //             //           Icons.delete,
  //             //           color: Colors.red.shade500,
  //             //           size: MediaQuery.of(context).size.height * 0.03,
  //             //         ),
  //             //         SizedBox(
  //             //           width: MediaQuery.of(context).size.width * 0.03,
  //             //         ),
  //             //         Text(
  //             //           'ลบรูปภาพ',
  //             //           style: TextStyle(
  //             //             fontSize: MediaQuery.of(context).size.height * 0.02,
  //             //             color: Colors.red.shade500,
  //             //           ),
  //             //         ),
  //             //       ],
  //             //     ),
  //             //   ),
  //             // ),
  //             Container(
  //               width: MediaQuery.of(context).size.width * 0.60,
  //               color: null,
  //               height: MediaQuery.of(context).size.height * 0.10,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   TextButton(
  //                       style: ButtonStyle(
  //                         side: MaterialStatePropertyAll(
  //                           BorderSide(color: Colors.red.shade300, width: 1),
  //                         ),
  //                       ),
  //                       onPressed: () => Navigator.pop(context),
  //                       child: CustomText(
  //                         text: "ยกเลิก",
  //                         size: MediaQuery.of(context).size.height * 0.15,
  //                         color: Colors.red.shade300,
  //                       )),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
