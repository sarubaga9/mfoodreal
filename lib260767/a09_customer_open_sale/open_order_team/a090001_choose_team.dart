import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/a07_account_customer/a07_01_open_account/a070101_pdpa_account_widget.dart';
import 'package:m_food/a07_account_customer/a07_13_accept/a0714_reject_widget.dart';
import 'package:m_food/a09_customer_open_sale/a0901_customer_list.dart';
import 'package:m_food/a09_customer_open_sale/open_order_team/a090002_choose_team_name.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
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

class A090001ChooseTeam extends StatefulWidget {
  const A090001ChooseTeam({
    Key? key,
  }) : super(key: key);

  @override
  _A090001ChooseTeamState createState() => _A090001ChooseTeamState();
}

class _A090001ChooseTeamState extends State<A090001ChooseTeam> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  bool isLoading = false;

  List<Map<String, dynamic>> saleTeamGroup = [];
  List<List<String?>?> listTeamID = [];

  Future<void> getData() async {
    userData = userController.userData;

    isLoading = true;
    setState(() {});

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('จัดการทีมขาย').get();

    for (QueryDocumentSnapshot customerDoc in querySnapshot.docs) {
      Map<String, dynamic> customerData =
          customerDoc.data() as Map<String, dynamic>;
      saleTeamGroup.add(customerData);
    }

    // saleTeamGroup.removeWhere((customerData) => customerData['สมาชิกในกลุ่ม'].firstWhere());
    print('----1----');

    print(saleTeamGroup.length);

    saleTeamGroup.forEach((element) {
      print(element);
    });

    saleTeamGroup.removeWhere((customerData) {
      print(customerData['หัวหน้างาน']);

      print(userData!['EmployeeID']);

      if (customerData['หัวหน้างาน'].isEmpty) {
        return true;
      } else {
        bool check = true;

        for (int i = 0; i < customerData['หัวหน้างาน'].length; i++) {
          if (customerData['หัวหน้างาน'][i]['EmployeeID'] ==
              userData!['EmployeeID']) {
            check = false;
            break;
          } else {
            check = true;
          }
        }

        return check;
        // return customerData['หัวหน้างาน']
        //     .any((member) => member['EmployeeID'] != userData!['EmployeeID']);
      }
    });

    print('----2----');
    print(saleTeamGroup.length);
    for (int i = 0; i < saleTeamGroup.length; i++) {
      listTeamID.add([]);
      saleTeamGroup[i]['สมาชิกในกลุ่ม'].forEach((element) {
        print(element);
        listTeamID[i]!.add(element['EmployeeID']);
      });
    }

    // print(customerDataList.length);
    // print(customerDataList.length);
    // print(customerDataList.length);
    // print(customerDataList.length);
    // print(customerDataList.length);

    // saleTeamGroup.sort((a, b) {
    //   String nameA = a['ชื่อนามสกุล'];
    //   String nameB = b['ชื่อนามสกุล'];

    //   return nameA.compareTo(nameB);
    // });

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
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
    print('This is A090001 choose team');
    print('==============================');

    userData = userController.userData;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoading
            ? Center(
                child: CircularLoading(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 10.0, 10.0),
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
                                  Column(
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      userData!.isNotEmpty
                                          ? Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  '${userData!['Name']} ${userData!['Surname']}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'สมัครสมาชิกที่นี่',
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
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
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                  userData!.isNotEmpty
                                      ? Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
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
                                              backgroundImage:
                                                  userData!['Img'] == ''
                                                      ? null
                                                      : NetworkImage(
                                                          userData!['Img']),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
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
                                                  // saveDataForLogout();
                                                },
                                                child: Icon(
                                                  Icons.account_circle,
                                                  color: FlutterFlowTheme.of(
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
                      //============ เปิดหน้าบัญชีใหม่เข้าสูระบบ =================
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'เลือกกลุ่มที่ต้องการเพื่อดูรายชื่อลูกค้าของสมาชิก',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontSize: 18,
                                    fontFamily: 'Kanit',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      //============ เปิดหน้าบัญชีใหม่เข้าสูระบบ =================
                      for (int i = 0; i < saleTeamGroup.length; i++)
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => A090002ChooseTeamName(
                                      listID: listTeamID[i],
                                      saleTeamGroup: saleTeamGroup[i],
                                    ),
                                  )).whenComplete(() async {
                                setState(() {});
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 5.0, 0.0),
                                  child: Icon(
                                    Icons.circle,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    size: 30.0,
                                  ),
                                ),
                                Text(
                                  saleTeamGroup[i]['ชื่อกลุ่มพนักงาน'],
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
                          ),
                        ),
                      //============ เปิดหน้าบัญชีใหม่เข้าสูระบบ =================
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      //   child: InkWell(
                      //     splashColor: Colors.transparent,
                      //     focusColor: Colors.transparent,
                      //     hoverColor: Colors.transparent,
                      //     highlightColor: Colors.transparent,
                      //     onTap: () async {
                      //       Navigator.push(
                      //           context,
                      //           CupertinoPageRoute(
                      //             builder: (context) =>
                      //                 const A090002ChooseTeamName(),
                      //           )).whenComplete(() async {
                      //         setState(() {});
                      //       });
                      //     },
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.max,
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsetsDirectional.fromSTEB(
                      //               0.0, 0.0, 5.0, 0.0),
                      //           child: Icon(
                      //             Icons.circle,
                      //             color: FlutterFlowTheme.of(context).alternate,
                      //             size: 30.0,
                      //           ),
                      //         ),
                      //         Text(
                      //           'ฝ่ายขาย 2 (ภาคกลางและภาคตะวันตก)',
                      //           style: FlutterFlowTheme.of(context)
                      //               .bodyLarge
                      //               .override(
                      //                 fontFamily: 'Kanit',
                      //                 color: FlutterFlowTheme.of(context)
                      //                     .primaryText,
                      //               ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
