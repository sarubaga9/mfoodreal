import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a09_customer_open_sale/a0902_customer_history_list.dart';
import 'package:m_food/a09_customer_open_sale/widget/list_open_sale_widget.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';

class A0901CustomerList extends StatefulWidget {
  const A0901CustomerList({super.key});

  @override
  _A0901CustomerListState createState() => _A0901CustomerListState();
}

class _A0901CustomerListState extends State<A0901CustomerList> {
  // final scaffoldKeyCustomerList = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  RxMap<String, dynamic>? customerData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A0901 customer list');
    print('==============================');
    userData = userController.userData;
    customerData = customerController.customerData;
    return Scaffold(
      // key: scaffoldKeyCustomerList,
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
                //============== App Bar =====================================
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
                          'รายชื่อลูกค้า',
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
                                        // Navigator.pop(context);
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
                      const EdgeInsetsDirectional.fromSTEB(10.0, 10.0,10.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //========================= Menu Bar ===============================
                      // Expanded(
                      //   flex: 1,
                      //   child: Padding(
                      //     padding: EdgeInsetsDirectional.fromSTEB(
                      //         0.0, 0.0, 10.0, 0.0),
                      //     child: MenuSidebarWidget(),
                      //   ),
                      // ),
                      Expanded(
                        // flex: 2,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: ListOpenSaleWidget(),
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
