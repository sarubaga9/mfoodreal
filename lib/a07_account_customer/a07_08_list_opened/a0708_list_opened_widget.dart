import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:shimmer/shimmer.dart';

import '/components/appbar_o_pen_widget.dart';
import '/components/list_open_acoout_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'a0708_list_opened_model.dart';
export 'a0708_list_opened_model.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/user_controller.dart';

class A0708ListOpenedWidget extends StatefulWidget {
  const A0708ListOpenedWidget({Key? key}) : super(key: key);

  @override
  _A0708ListOpenedWidgetState createState() => _A0708ListOpenedWidgetState();
}

class _A0708ListOpenedWidgetState extends State<A0708ListOpenedWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();
  final customerController = Get.find<CustomerController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A0708 list open รออนุมัติ 08 09 Screen');
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
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                      EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                      //   child: Padding(
                      //     padding:
                      //         EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      //     child: MenuSidebarWidget(),
                      //   ),
                      // ),
                      Expanded(
                        // flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 5.0, 0.0),
                                        child: Icon(
                                          FFIcons.kfolderClock,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          size: 30.0,
                                        ),
                                      ),
                                      Text(
                                        'รายการลูกค้าที่รออนุมัติการเปิดหน้าบัญชี',
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
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 10.0),
                                    child: Container(
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .accent3,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 8.0, 0.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 12.0),
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
                                                        'ค้นหารายชื่อเพื่อดูสถานะการอนุมัติการดำเนินการ',
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    focusedErrorBorder:
                                                        InputBorder.none,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                  textAlign: TextAlign.center,
                                                  // validator: _model
                                                  //     .textControllerValidator
                                                  //     .asValidator(context),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.search,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection(AppSettings.customerType ==
                                                CustomerType.Test
                                            ? 'CustomerTest'
                                            : 'Customer')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return _buildLoadingImage();
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


                                      customerController
                                          .updateCustomerData(snapshot.data);
                                      (customerController.customerData!.length);

                                      Map<String, dynamic> customerMap = {};
                                      //     data.docs.first.data() as Map<String, dynamic>;

                                      for (int index = 0;
                                          index < snapshot.data!.docs.length;
                                          index++) {
                                        final Map<String, dynamic> docData =
                                            snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>;

                                        customerMap['key${index}'] = docData;
                                      }

                                      // print(customerMap);

                                      Map<String, dynamic> filteredData =
                                          Map.fromEntries(
                                        customerMap.entries.where((entry) =>
                                            // entry.value['สถานะ'] == false &&
                                            // entry.value['บันทึกพร้อมตรวจ'] ==
                                            //     false &&
                                            entry.value['รอการอนุมัติ'] ==
                                                true &&
                                            userData!['EmployeeID'] ==
                                                entry.value['รหัสพนักงานขาย']),
                                      );

                                      // แปลง Timestamp เป็น DateTime

                                      String customFormatThai(
                                          DateTime dateTime) {
                                        final List<String> monthNames = [
                                          'ม.ค.',
                                          'ก.พ.',
                                          'มี.ค.',
                                          'เม.ย.',
                                          'พ.ค.',
                                          'มิ.ย.',
                                          'ก.ค.',
                                          'ส.ค.',
                                          'ก.ย.',
                                          'ต.ค.',
                                          'พ.ย.',
                                          'ธ.ค.',
                                        ];

                                        String day = dateTime.day.toString();
                                        String month =
                                            monthNames[dateTime.month - 1];
                                        String year = (dateTime.year + 543)
                                            .toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

                                        return '$day $month $year';
                                      }

                                      // print('fdfsdfwwwww');
                                      // for (var entry in filteredData.entries) {
                                      //   Timestamp timestamp =
                                      //       entry.value['CustomerDateUpdate'];
                                      //   DateTime dateTime =
                                      //       DateTime.fromMillisecondsSinceEpoch(
                                      //     timestamp.seconds * 1000 +
                                      //         (timestamp.nanoseconds / 1000000)
                                      //             .round(),
                                      //   );

                                      //   // ใช้ฟังก์ชันแปลงรูปแบบวันที่เอง
                                      //   String formattedDate =
                                      //       customFormatThai(dateTime);
                                      //   print(formattedDate);
                                      //   print(entry.value['ขั้นตอนอนุมัติ']
                                      //       .where((element) => element == true)
                                      //       .length);
                                      // }

                                      // เรียง entries ของ filteredData ตาม Timestamp
                                      var sortedEntries = filteredData.entries
                                          .toList()
                                        ..sort((a, b) => b
                                            .value['CustomerDateUpdate']
                                            .compareTo(
                                                a.value['CustomerDateUpdate']));

                                      // สร้าง Map ใหม่ที่เรียงลำดับ
                                      Map<String, dynamic> sortedData =
                                          Map.fromEntries(sortedEntries);

                                      // แสดงผลลัพธ์
                                      print('เรียงลำดับแล้ว: $sortedData');

                                      return SizedBox(
                                        height: 1045,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              for (var entry
                                                  in sortedData.entries)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, bottom: 5),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      //แปลงเป็น map เพื่อส่งไปหน้า edit
                                                      Map<String, dynamic>
                                                          entryMap = {
                                                        'key': entry.key,
                                                        'value': entry.value,
                                                      };
                                                      print('11233321321');
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (context) =>
                                                                A0712UserGeneralEditWidget(
                                                                    entryMap:
                                                                        entryMap),
                                                          ));
                                                      // context.pushNamed(
                                                      //     'A07_12_UserGeneralEdit');
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            entry.value['ประเภทลูกค้า'] ==
                                                                    'Company'
                                                                ? Text(
                                                                    '${customFormatThai(DateTime.fromMillisecondsSinceEpoch(
                                                                      entry.value['CustomerDateUpdate'].seconds *
                                                                              1000 +
                                                                          (entry.value['CustomerDateUpdate'].nanoseconds / 1000000)
                                                                              .round(),
                                                                    ))} ${entry.value['ชื่อบริษัท']}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium,
                                                                  )
                                                                : Text(
                                                                    '${customFormatThai(DateTime.fromMillisecondsSinceEpoch(
                                                                      entry.value['CustomerDateUpdate'].seconds *
                                                                              1000 +
                                                                          (entry.value['CustomerDateUpdate'].nanoseconds / 1000000)
                                                                              .round(),
                                                                    ))} ${entry.value['ชื่อ']} ${entry.value['นามสกุล']}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium,
                                                                  ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'ผู้บริหารอนุมัติแล้ว ${entry.value['ขั้นตอนอนุมัติ'].where((element) => element == true).length} ท่าน',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // InkWell(
                                  //   splashColor: Colors.transparent,
                                  //   focusColor: Colors.transparent,
                                  //   hoverColor: Colors.transparent,
                                  //   highlightColor: Colors.transparent,
                                  //   onTap: () async {
                                  //     // context.pushNamed('A07_09_step');
                                  //     Navigator.push(
                                  //         context,
                                  //         CupertinoPageRoute(
                                  //           builder: (context) =>
                                  //               A0709StepWidget(),
                                  //         ));
                                  //   },
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Column(
                                  //         mainAxisSize: MainAxisSize.max,
                                  //         children: [
                                  //           Text(
                                  //             '09 ตค 2566 ญญรัชต์ สาระชาติ',
                                  //             style: FlutterFlowTheme.of(context)
                                  //                 .bodyMedium,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       Column(
                                  //         mainAxisSize: MainAxisSize.max,
                                  //         children: [
                                  //           Text(
                                  //             'ผู้บริหารอนุมัติแล้ว 0 ท่าน',
                                  //             style: FlutterFlowTheme.of(context)
                                  //                 .bodyMedium,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
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

  _buildLoadingImage() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          // borderRadius:
          //     BorderRadius.circular(1.5 * MediaQuery.of(context).size.height),
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
    );
  }
}
