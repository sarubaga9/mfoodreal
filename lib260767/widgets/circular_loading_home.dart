import 'dart:async';

import 'package:flutter/material.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularLoadingHome extends StatefulWidget {
  final bool? success;
  const CircularLoadingHome({this.success, Key? key}) : super(key: key);

  @override
  State<CircularLoadingHome> createState() => _CircularLoadingHomeState();
}

class _CircularLoadingHomeState extends State<CircularLoadingHome> {
  double percent = 0.0; // เริ่มต้นที่ 0%
  late Timer _timer;

  void updatePercent() {
    if (mounted) {
      setState(() {
        percent += 0.01; // เพิ่มค่า percent ทีละ 1%
        if (percent > 1.0) {
          percent = 1.0; // รีเซ็ต percent กลับไปที่ 0% เมื่อเต็ม 100%
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // สร้างการเรียกใช้งานเวลาเริ่มต้น
    _timer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (percent == 1.0
          // || widget.success == true
          ) {
        _timer.cancel();
      } else {
        updatePercent();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Column(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
          //       child: Container(
          //         width: 410.0,
          //         height: 40.0,
          //         decoration: BoxDecoration(),
          //         child: Align(
          //           alignment: AlignmentDirectional(0.00, 0.00),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               InkWell(
          //                 splashColor: Colors.transparent,
          //                 focusColor: Colors.transparent,
          //                 hoverColor: Colors.transparent,
          //                 highlightColor: Colors.transparent,
          //                 onTap: () async {
          //                   context.safePop();
          //                 },
          //                 child: Column(
          //                   mainAxisSize: MainAxisSize.max,
          //                   children: [
          //                     Icon(
          //                       Icons.chevron_left_sharp,
          //                       color:
          //                           FlutterFlowTheme.of(context).secondaryText,
          //                       size: 40.0,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Column(
          //                 mainAxisSize: MainAxisSize.max,
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     'กำลังประมวลผล',
          //                     style: FlutterFlowTheme.of(context)
          //                         .titleMedium
          //                         .override(
          //                           fontFamily: 'Kanit',
          //                           color: Colors.black,
          //                         ),
          //                   ),
          //                 ],
          //               ),
          //               InkWell(
          //                 splashColor: Colors.transparent,
          //                 focusColor: Colors.transparent,
          //                 hoverColor: Colors.transparent,
          //                 highlightColor: Colors.transparent,
          //                 onTap: () async {
          //                   context.pushNamed('A062_Login');
          //                 },
          //                 child: Column(
          //                   mainAxisSize: MainAxisSize.max,
          //                   children: [
          //                     ClipRRect(
          //                       borderRadius: BorderRadius.circular(30.0),
          //                       child: Image.asset(
          //                         'assets/images/Screenshot_2566-09-11_at_10.40.44.png',
          //                         width: 40.0,
          //                         height: 40.0,
          //                         fit: BoxFit.cover,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     Stack(
          //       children: [
          //         InkWell(
          //           splashColor: Colors.transparent,
          //           focusColor: Colors.transparent,
          //           hoverColor: Colors.transparent,
          //           highlightColor: Colors.transparent,
          //           onTap: () async {
          //             context.pushNamed('A064_Dashboard');
          //           },
          //           child: Column(
          //             mainAxisSize: MainAxisSize.max,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(
          //                     0.0, 50.0, 0.0, 0.0),
          //                 child: Container(
          //                   width: 372.0,
          //                   height: 139.0,
          //                   decoration: BoxDecoration(),
          //                   child: InkWell(
          //                     splashColor: Colors.transparent,
          //                     focusColor: Colors.transparent,
          //                     hoverColor: Colors.transparent,
          //                     highlightColor: Colors.transparent,
          //                     onTap: () async {
          //                       context.pushNamed('A084_Ticked');
          //                     },
          //                     child: Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Row(
          //                           mainAxisSize: MainAxisSize.max,
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             ClipRRect(
          //                               borderRadius:
          //                                   BorderRadius.circular(8.0),
          //                               child: Image.asset(
          //                                 'assets/images/Loading.png',
          //                                 width: 80.0,
          //                                 height: 80.0,
          //                                 fit: BoxFit.cover,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                         Padding(
          //                           padding: EdgeInsetsDirectional.fromSTEB(
          //                               0.0, 10.0, 0.0, 0.0),
          //                           child: Row(
          //                             mainAxisSize: MainAxisSize.max,
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.center,
          //                             children: [
          //                               Text(
          //                                 'กำลังอัพโหลดไฟล์',
          //                                 style: FlutterFlowTheme.of(context)
          //                                     .bodyMedium
          //                                     .override(
          //                                       fontFamily: 'Kanit',
          //                                       fontSize: 16.0,
          //                                     ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         Row(
          //                           mainAxisSize: MainAxisSize.min,
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             Text(
          //                               'กรุณาอย่าปิดหน้าจอนี้เด็ดขาด !',
          //                               style: FlutterFlowTheme.of(context)
          //                                   .bodyMedium
          //                                   .override(
          //                                     fontFamily: 'Kanit',
          //                                     fontSize: 16.0,
          //                                   ),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // CircularPercentIndicator(
          //   radius: 40.0,
          //   lineWidth: 4.0,
          //   percent: percent, // ใช้ค่า percent ที่เปลี่ยนไปเรื่อยๆ
          //   center: CircleAvatar(
          //     radius: 30,
          //     backgroundColor: FlutterFlowTheme.of(context).secondaryText,
          //     child: Text(
          //       "${(percent * 100).toStringAsFixed(0)}%",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ), // แสดงค่า percent ในรูปแบบข้อความ
          //   progressColor: FlutterFlowTheme.of(context).secondaryText,
          // ),
          // CircularProgressIndicator(
          //   color: FlutterFlowTheme.of(context).secondaryText,
          // ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.40,
          // ),
          Text(
            'กรุณารอสักครู่ค่ะ...',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Kanit',
                  fontSize: 16.0,
                ),
          ),
        ],
      )),
    );
  }
}
