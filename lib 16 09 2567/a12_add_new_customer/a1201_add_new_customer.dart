import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/a07_account_customer/a07_01_open_account/a070101_pdpa_account_widget.dart';
import 'package:m_food/a07_account_customer/a07_13_accept/a0714_reject_widget.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:uuid/uuid.dart';

import '/components/appbar_o_pen_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/components/open_accout_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A1201AddNewCustomer extends StatefulWidget {
  const A1201AddNewCustomer({Key? key}) : super(key: key);

  @override
  _A1201AddNewCustomerState createState() => _A1201AddNewCustomerState();
}

class _A1201AddNewCustomerState extends State<A1201AddNewCustomer> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A1201 open account Screen');
    print('==============================');
    userData = userController.userData;

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
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 10.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      // context.safePop();
                                      Navigator.pop(context);
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
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 10.0, 0.0),
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
                                      borderRadius: BorderRadius.circular(50.0),
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
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: FlutterFlowTheme.of(context)
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
                                color: FlutterFlowTheme.of(context).primaryText,
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                userData!.isNotEmpty
                                    ? Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '${userData!['Name']} ${userData!['Surname']}',
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
                                      )
                                    : Row(
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
                                userData!.isNotEmpty
                                    ? Row(
                                        mainAxisSize: MainAxisSize.max,
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
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                          ),
                                        ],
                                      )
                                    : Row(
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
                            userData!.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        maxRadius: 20,
                                        // radius: 1,
                                        backgroundImage: userData!['Img'] == ''
                                            ? null
                                            : NetworkImage(userData!['Img']),
                                      ),
                                    ),
                                  )
                                : Padding(
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
                                            // saveDataForLogout();
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
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Expanded(
                      //   child: Padding(
                      //     padding: EdgeInsetsDirectional.fromSTEB(
                      //         0.0, 0.0, 10.0, 0.0),
                      //     child: MenuSidebarWidget(),
                      //   ),
                      // ),
                      Expanded(
                        // flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              decoration: const BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //============ ตรวจสอบ =================
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 20.0),
                                    child: Container(
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        color: FlutterFlowTheme.of(context)
                                            .accent3,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          //============ ตรวจสอบ =================
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      8.0, 12.0, 8.0, 0.0),
                                              child: TextFormField(
                                                controller: textController,
                                                focusNode: textFieldFocusNode,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  hintText:
                                                      'ตรวจสอบชื่อวามีหน้าบัญชีในระบบอยู่แล้วหรือไม่?',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                  // suffixIcon: Icon(
                                                  //   Icons.search,
                                                  // ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                textAlign: TextAlign.center,
                                                // validator: _model
                                                //     .textControllerValidator
                                                //     .asValidator(context),
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.search),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  //============ เปิดหน้าบัญชีใหม่เข้าสูระบบ =================
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      // context.pushNamed('A07_02_OpenAccount');
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const A0702OpenAccountWidget(),
                                          ));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                          child: Icon(
                                            FFIcons.kfolderPlus,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            size: 30.0,
                                          ),
                                        ),
                                        Text(
                                          'คีย์ข้อมูลการเข้าหาลูกค้าใหม่',
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //============ ข้อมูลลูกค้าที่ยังทำไมครบทุกขั้นตอนที่เซฟเก็บไว้ทำภายหลัง =================
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const A0710SaveWidget(),
                                          ));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                          child: Icon(
                                            FFIcons.kfolderRefresh,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            size: 30.0,
                                          ),
                                        ),
                                        Text(
                                          'รายชื่อลูกค้าที่ได้มีการคีย์เข้ามาแล้วก่อนหน้า',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                        ),
                                        Spacer(),
                                        StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection(
                                                    AppSettings.customerType ==
                                                            CustomerType.Test
                                                        ? 'CustomerTest'
                                                        : 'Customer')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return SizedBox();
                                              }
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'เกิดข้อผิดพลาด: ${snapshot.error}');
                                              }
                                              if (!snapshot.hasData) {
                                                return Text('ไม่พบข้อมูล');
                                              }
                                              if (snapshot.data!.docs.isEmpty) {
                                                print(snapshot.data);
                                              }

                                              // print('stream stream');

                                              customerController
                                                  .updateCustomerData(
                                                      snapshot.data);
                                              // print(customerController
                                              // .customerData!.length);

                                              Map<String, dynamic> customerMap =
                                                  {};
                                              //     data.docs.first.data() as Map<String, dynamic>;

                                              for (int index = 0;
                                                  index <
                                                      snapshot
                                                          .data!.docs.length;
                                                  index++) {
                                                final Map<String, dynamic>
                                                    docData = snapshot
                                                            .data!.docs[index]
                                                            .data()
                                                        as Map<String, dynamic>;

                                                customerMap['key${index}'] =
                                                    docData;
                                              }
                                              // print('aaaa');
                                              // print(customerMap);

                                              Map<String, dynamic>
                                                  filteredData =
                                                  Map.fromEntries(
                                                customerMap.entries.where((entry) =>
                                                    entry.value[
                                                            'บันทึกพร้อมตรวจ'] ==
                                                        true &&
                                                    userData!['EmployeeID'] ==
                                                        entry.value[
                                                            'รหัสพนักงานขาย']),
                                              );
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width: 26.5,
                                                    height: 26.5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(5.0,
                                                              2.0, 5.0, 5.0),
                                                      child: Text(
                                                        filteredData.length
                                                            .toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                      ),
                                                    ),

                                                    //  Padding(
                                                    //   padding: EdgeInsetsDirectional
                                                    //       .fromSTEB(
                                                    //           5.0, 5.0, 5.0, 5.0),
                                                    //   child: Text(
                                                    // filteredData.length.toString(),
                                                    //     style: FlutterFlowTheme.of(
                                                    //             context)
                                                    //         .bodyMedium
                                                    //         .override(
                                                    //           fontFamily: 'Kanit',
                                                    //           color: FlutterFlowTheme
                                                    //                   .of(context)
                                                    //               .primaryBackground,
                                                    //         ),
                                                    //   ),
                                                    // ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
