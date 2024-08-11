import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/index.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DataTransferWidgetNoUser extends StatefulWidget {
  final bool? success;

  const DataTransferWidgetNoUser({this.success, Key? key}) : super(key: key);

  @override
  _DataTransferWidgetNoUserState createState() =>
      _DataTransferWidgetNoUserState();
}

class _DataTransferWidgetNoUserState extends State<DataTransferWidgetNoUser> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double percent = 0.0; // เริ่มต้นที่ 0%
  late Timer _timer;

  void updatePercent() {
    if (mounted) {
      setState(() {
        percent += 0.01; // เพิ่มค่า percent ทีละ 1%
        if (percent >= 1.0) {
          percent = 1.0; // รีเซ็ต percent กลับไปที่ 0% เมื่อเต็ม 100%
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // print(widget.success);
    // สร้างการเรียกใช้งานเวลาเริ่มต้น
    _timer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (percent == 1.0) {
        // if (widget.success == false) {
        _timer.cancel();
        // print('cancel');
        // }
      } else {
        updatePercent();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
              child: Row(
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
                          // Column(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsetsDirectional.fromSTEB(
                          //           0.0, 0.0, 5.0, 0.0),
                          //       child: InkWell(
                          //         splashColor: Colors.transparent,
                          //         focusColor: Colors.transparent,
                          //         hoverColor: Colors.transparent,
                          //         highlightColor: Colors.transparent,
                          //         onTap: () async {
                          //           Navigator.pop(context);
                          //           // context.safePop();
                          //         },
                          //         child: Icon(
                          //           Icons.chevron_left,
                          //           color: FlutterFlowTheme.of(context)
                          //               .secondaryText,
                          //           size: 40.0,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ), //=================================================================
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
                                        color: FlutterFlowTheme.of(context)
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
                        'กำลังสร้างข้อมูลสมาชิกของท่าน',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context).primaryText,
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
                                          color: FlutterFlowTheme.of(context)
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
                                        FlutterFlowTheme.of(context).bodySmall,
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
                                    // Navigator.push(
                                    //     context,
                                    //     CupertinoPageRoute(
                                    //       builder: (context) =>
                                    //           A0701OpenAccountWidget(),
                                    //     ));
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
              // Container(
              //   width: 410.0,
              //   height: 40.0,
              //   decoration: BoxDecoration(),
              //   child: Align(
              //     alignment: AlignmentDirectional(0.00, 0.00),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         InkWell(
              //           splashColor: Colors.transparent,
              //           focusColor: Colors.transparent,
              //           hoverColor: Colors.transparent,
              //           highlightColor: Colors.transparent,
              //           onTap: () async {
              //             // context.pushNamed('A011_Home');
              //           },
              //           child: Column(
              //             mainAxisSize: MainAxisSize.max,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               ClipRRect(
              //                 borderRadius: BorderRadius.circular(30.0),
              //                 child: Image.asset(
              //                   'assets/images/LINE_ALBUM__231114_1.jpg',
              //                   width: 40.0,
              //                   height: 40.0,
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         // InkWell(
              //         //   splashColor: Colors.transparent,
              //         //   focusColor: Colors.transparent,
              //         //   hoverColor: Colors.transparent,
              //         //   highlightColor: Colors.transparent,
              //         //   onTap: () async {
              //         //     context.safePop();
              //         //   },
              //         //   child: Column(
              //         //     mainAxisSize: MainAxisSize.max,
              //         //     children: [
              //         //       Icon(
              //         //         Icons.chevron_left,
              //         //         color:
              //         //             FlutterFlowTheme.of(context).secondaryText,
              //         //         size: 40.0,
              //         //       ),
              //         //     ],
              //         //   ),
              //         // ),
              //         Column(
              //           mainAxisSize: MainAxisSize.max,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               'ส่งข้อมูลเข้าระบบ',
              //               style: FlutterFlowTheme.of(context)
              //                   .titleMedium
              //                   .override(
              //                     fontFamily: 'Kanit',
              //                     color: Colors.black,
              //                   ),
              //             ),
              //           ],
              //         ),

              //         // userData['Img'] == ''
              //         //     ? GestureDetector(
              //         //         onTap: () {
              //         //           // context.pushNamed('A065_Profile');
              //         //         },
              //         //         child: CircleAvatar(
              //         //           backgroundColor: FlutterFlowTheme.of(context)
              //         //               .secondaryText,
              //         //           maxRadius: 20,
              //         //           // radius: 1,
              //         //         ),
              //         //       )
              //         //     : GestureDetector(
              //         //         onTap: () {
              //         //           // context.pushNamed('A065_Profile');
              //         //         },
              //         //         child: CircleAvatar(
              //         //           backgroundColor: FlutterFlowTheme.of(context)
              //         //               .secondaryText,
              //         //           maxRadius: 20,
              //         //           // radius: 1,
              //         //           backgroundImage:
              //         //               NetworkImage(userData['Img']),
              //         //         ),
              //         //       )
              //         InkWell(
              //           splashColor: Colors.transparent,
              //           focusColor: Colors.transparent,
              //           hoverColor: Colors.transparent,
              //           highlightColor: Colors.transparent,
              //           onTap: () async {
              //             // context.pushNamed('A064_Dashboard');
              //           },
              //           child: Column(
              //             mainAxisSize: MainAxisSize.max,
              //             children: [
              //               Icon(
              //                 Icons.account_circle,
              //                 color: FlutterFlowTheme.of(context).secondaryText,
              //                 size: 40.0,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 50.0, 10.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // context.pushNamed('A064_Dashboard');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 50.0, 0.0, 0.0),
                              child: Container(
                                width: 372.0,
                                height: 139.0,
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularPercentIndicator(
                                          radius: 40.0,
                                          lineWidth: 4.0,
                                          percent:
                                              percent, // ใช้ค่า percent ที่เปลี่ยนไปเรื่อยๆ
                                          center: CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            child: Text(
                                              "${(percent * 100).toStringAsFixed(0)}%",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ), // แสดงค่า percent ในรูปแบบข้อความ
                                          progressColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisSize: MainAxisSize.max,
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     ClipRRect(
                                    //       borderRadius:
                                    //           BorderRadius.circular(8.0),
                                    //       child: Image.asset(
                                    //         'assets/images/Loading.png',
                                    //         width: 80.0,
                                    //         height: 80.0,
                                    //         fit: BoxFit.cover,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 10.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'กำลังอัพโหลดไฟล์',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 14.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'กรุณาอย่าปิดหน้าจอนี้เด็ดขาด !',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                fontSize: 14.0,
                                              ),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
