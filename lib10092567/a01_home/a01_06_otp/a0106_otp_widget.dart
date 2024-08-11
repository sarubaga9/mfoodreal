import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_food/controller/dynamic_link.dart';
import 'package:m_food/index.dart';
import 'package:m_food/widgets/data_transfer_widget_no_user.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '/components/appbar_nologin_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'a0106_otp_model.dart';
export 'a0106_otp_model.dart';

class A0106OtpWidget extends StatefulWidget {
  const A0106OtpWidget({Key? key}) : super(key: key);

  @override
  _A0106OtpWidgetState createState() => _A0106OtpWidgetState();
}

class _A0106OtpWidgetState extends State<A0106OtpWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> saveDataToSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void sendMail() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final CollectionReference users =
          FirebaseFirestore.instance.collection('User');
      try {
        setState(() {
          isLoading = true;
        });
        var uuid = Uuid();

        // ใช้ฟังก์ชัน v4 เพื่อสร้าง UUID แบบสุ่ม
        String randomUuid = uuid.v4();
        print('before dynamic to email');
        await DynamicLinkProvider().createLink(randomUuid).then((value) async {
          print(randomUuid);
          // ทำการ query เพื่อหาข้อมูลที่มี email เท่ากับ email ที่ต้องการ
          QuerySnapshot querySnapshot =
              await users.where('Email', isEqualTo: textController.text).get();

          // ตรวจสอบว่ามีข้อมูลหรือไม่
          if (querySnapshot.docs.isNotEmpty) {
            // มีข้อมูล แสดงว่าอีเมล์นี้อยู่ใน Firestore
            print('Email ${textController.text} is found in Firestore!');

            String name = '';
            String surname = '';

            // แสดงข้อมูลที่พบ (อาจจะมีหลายข้อมูล)
            querySnapshot.docs.forEach((doc) async {
              print('Document ID: ${doc.id}, Data: ${doc.data()}');

              final test = await FirebaseFirestore.instance
                  .collection('User')
                  .doc(doc.id)
                  .update({
                'TokenResetPassword': randomUuid,
                'TokenResetPasswordDatetime': DateTime.now(),
              });
              //======================================
              int timestamp = DateTime.now().millisecondsSinceEpoch;
              String dateFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                DateTime.fromMillisecondsSinceEpoch(timestamp),
              );

              await saveDataToSharedPreferences('date', dateFormatted);
              await saveDataToSharedPreferences('TokenResetPassword', randomUuid);
              //======================================
              // print('check data');
              print(doc.get('Name'));
              name = doc.get('Name');
              surname = doc.get('Surname');
              print(doc.get('Surname'));
              print('-------------------------------');
              print(name);
              print(surname);
              print('-------------------------------');
              String username = 'narakbazn@gmail.com'; // อีเมลล์ที่ใช้ส่ง
              String password = 'rwsm djsr geig eikf'; // รหัสผ่านของอีเมลล์

              final smtpServer = gmail(username, password);

              // อ่านไฟล์รูปภาพจาก assets
              ByteData data = await rootBundle.load('assets/logo.jpg');
              List<int> imageBytes = data.buffer.asUint8List();
              String base64Image = base64Encode(imageBytes);
              print(base64Image);

              // สร้างข้อความอีเมลล์
              final message = Message()
                ..from = Address(username, 'M Food')
                ..recipients.add(textController.text) // อีเมลล์ผู้รับ
                ..subject = 'การแก้ไขรหัสผ่าน M Food Application'
                ..html = """
    <p>เรียนคุณ $name $surname</p>  <p style="margin-top: 20px;"> </p>
    <p>ท่านได้แจ้งว่าลืมรหัสเข้าสู่ระบบ และ นี่คือลิงค์สำหรับเข้าไปทำการรีเซ็ทและตั้งพาสเวิร์ดของท่านใหม่ มีอายุการใช้งาน 1 ชั่วโมง กรุณาคลิ้กที่ลิงค์นี้<Br>เพื่อเข้าไปแก้ไข และ ตั้งพาสเวิร์ดของท่านใหม่อีกครั้ง</p>
    <p style="margin-top: 20px;"> </p>
    <p>$value</p>
    <p style="margin-top: 40px;"> </p>
    <div style="display: flex; align-items: center;">
      <img src="https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/images%2Flogo%2Flogo.jpg?alt=media&token=90d04cbd-d08a-4cc7-968b-aeff47874688" 
           width="60" height="60">
      <span style="margin-left: 10px;">
        <div>บริษัท มหาชัยฟู้ดส์ จำกัด</div>
        <div>MAHACHAI FOODS COMPANY LIMITED</div>
      </span>
    </div> """;

              try {
                // ส่งอีเมลล์
                final sendReport = await send(message, smtpServer);
                print('Message sent: ' + sendReport.toString());
                await Fluttertoast.showToast(
                  msg: "     กรุณาตรวจสอบอีเมลล์ค่ะ     ",
                  toastLength: Toast.LENGTH_SHORT, // หรือ Toast.LENGTH_LONG
                  gravity: ToastGravity
                      .BOTTOM, // ตำแหน่งของ Toast (TOP, BOTTOM, CENTER)

                  timeInSecForIosWeb:
                      10, // ระยะเวลาที่ Toast จะแสดง (สำหรับ iOS และ Web)

                  backgroundColor: Colors.blue, // สีพื้นหลังของ Toast
                  textColor: Colors.white, // สีข้อความ
                  fontSize: 16.0, // ขนาดตัวอักษร
                ).then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                });
              } on MailerException catch (e) {
                print('Message not sent. \n' + e.toString());
                // handle the exception
              }
            });
          } else {
            // ไม่มีข้อมูล
            print('Email ${textController.text} is not found in Firestore.');
            await Fluttertoast.showToast(
              msg: "     อีเมลล์นี้ไม่มีในระบบลงทะเบียนค่ะ     ",
              toastLength: Toast.LENGTH_SHORT, // หรือ Toast.LENGTH_LONG
              gravity:
                  ToastGravity.BOTTOM, // ตำแหน่งของ Toast (TOP, BOTTOM, CENTER)
              timeInSecForIosWeb:
                  5, // ระยะเวลาที่ Toast จะแสดง (สำหรับ iOS และ Web)
              backgroundColor: Colors.red, // สีพื้นหลังของ Toast
              textColor: Colors.white, // สีข้อความ
              fontSize: 16.0, // ขนาดตัวอักษร
            );
            Navigator.pop(context);
          }
        });
      } catch (e) {
        // ดักจับ error ที่อาจเกิดขึ้น
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is Otp Reset Password Screen');
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
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
                                            color: FlutterFlowTheme.of(context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'สมัครสมาชิกที่นี่',
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
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'ล็อกอินเข้าสู่ระบบ',
                                            style: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
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
                      // wrapWithModel(
                      //   model: _model.appbarNologinModel,
                      //   updateCallback: () => setState(() {}),
                      //   child: AppbarNologinWidget(),
                      // ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 40.0, 0.0, 35.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'กรุณาพิมพ์อีเมลของท่าน',
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
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 8.0, 0.0),
                                        child: TextFormField(
                                          controller: textController,
                                          focusNode: textFieldFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                            hintText: 'อีเมล',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                          // validator: _model.textControllerValidator
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
                                        sendMail();
                                        // context.pushNamed('A01_07_PasswordReset');
                                      },
                                      text: 'แจ้งลืมรหัสและรีเซ็ทใหม่',
                                      options: FFButtonOptions(
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Kanit',
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
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
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 35.0, 10.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      // context.pushNamed('A01_03_Register');
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A0103RegisterWidget(),
                                          ));
                                    },
                                    text: 'สมัครสมาชิกใหม่คลิกที่นี่',
                                    options: FFButtonOptions(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Kanit',
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      elevation: 3.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.00, 0.00),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // context.pushNamed('A01_06_OTP');
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
    );
  }
}
