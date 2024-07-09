import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/a13_visit_customer_plan/a1302_visit_detail.dart';
import 'package:m_food/a13_visit_customer_plan/a1303_visit_form.dart';
import 'package:m_food/a14_visit_save_time/a1402_check_in.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportCheckIn extends StatefulWidget {
  const ReportCheckIn({super.key});

  @override
  _ReportCheckInState createState() => _ReportCheckInState();
}

class _ReportCheckInState extends State<ReportCheckIn> {
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

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
    );

    // แปลงปีคริสต์ศักราชเป็นปีพุทธศักราชโดยการเพิ่ม 543
    int thaiYear = dateTime.year + 543;

    // ใช้ intl package เพื่อแปลงรูปแบบวันที่
    String formattedDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(dateTime.year, dateTime.month, dateTime.day));
    // formattedDate = formattedDate.substring(0, formattedDate.length - 4);
    // // เพิ่มปีพุทธศักราช
    // formattedDate += '$thaiYear';

    return formattedDate;
  }

  String formatThaiDate(DateTime dateTime) {
    final List<String> monthNames = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];

    String day = dateTime.day.toString();
    String month = monthNames[dateTime.month - 1];
    String year =
        (dateTime.year+543).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

    return '$day $month $year';
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;
    return Container(
      decoration: const BoxDecoration(),
      child: Container(
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //================= เพิ่มแผน =============================
            // InkWell(
            //   splashColor: Colors.transparent,
            //   focusColor: Colors.transparent,
            //   hoverColor: Colors.transparent,
            //   highlightColor: Colors.transparent,
            //   onTap: () async {
            //     Navigator.push(
            //         context,
            //         CupertinoPageRoute(
            //           builder: (context) => A1303VisitForm(),
            //         ));
            //   },
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsetsDirectional.fromSTEB(
            //             0.0, 0.0, 5.0, 0.0),
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color: FlutterFlowTheme.of(context).primaryText,
            //             shape: BoxShape.circle,
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsetsDirectional.fromSTEB(
            //                 3.0, 3.0, 3.0, 3.0),
            //             child: Icon(
            //               Icons.edit,
            //               color: FlutterFlowTheme.of(context).primaryBackground,
            //               size: 20.0,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Text(
            //         'เพิ่มแผนการเข้าเยี่ยมลูกค้า',
            //         style: FlutterFlowTheme.of(context).titleMedium.override(
            //               fontFamily: 'Kanit',
            //               color: FlutterFlowTheme.of(context).primaryText,
            //               fontWeight: FontWeight.w500,
            //             ),
            //       ),
            //     ],
            //   ),
            // ),
            //============ รายละเอียดนัดเยี่ยม ======================
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('เข้าเยี่ยมลูกค้า')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingImage();
                  }
                  if (snapshot.hasError) {
                    return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Text('ไม่พบข้อมูล');
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    print(snapshot.data);
                  }

                  print('stream stream');

                  Map<String, dynamic> customerMap = {};
                  //     data.docs.first.data() as Map<String, dynamic>;

                  for (int index = 0;
                      index < snapshot.data!.docs.length;
                      index++) {
                    final Map<String, dynamic> docData =
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                    customerMap['key${index}'] = docData;
                    // customerMap['key${docData['value']['ชื่อนามสกุล']}'] =
                    //     docData;
                  }
                  print('aaaa');
                  print(customerMap);

                  Map<String, dynamic> filteredData = Map.fromEntries(
                    customerMap.entries.where((entry) =>
                        entry.value['UserID'] == userData!['UserID'] &&
                        entry.value['สถานะ'] == true),
                  );

                  List<String> sortedKeys = filteredData.keys.toList();

                  // print(filteredData.keys);
                  // print(sortedKeys);
                  sortedKeys.sort((a, b) => filteredData[b]['วันเดือนปีนัดหมาย']
                      .toDate()
                      .compareTo(
                          filteredData[a]['วันเดือนปีนัดหมาย'].toDate()));

                  // sortedKeys.sort((a, b) {
                  //   return filteredData[a]['ชื่อนามสกุล']
                  //       .compareTo(filteredData[b]['ชื่อนามสกุล']);
                  // });
                  // print(sortedKeys);
                  Map<String, dynamic> sortedFilteredData = Map.fromEntries(
                    sortedKeys.map((key) => MapEntry(key, filteredData[key])),
                  );
                  List<String> uniqueDates = [];
                  List<String> uniqueNormalDates = [];

                  for (var item in sortedFilteredData.entries) {
                    print(formatDate(item.value['วันเดือนปีนัดหมาย']));
                    // // แปลง timestamp เป็น DateTime
                    DateTime dateTime =
                        item.value['วันเดือนปีนัดหมาย'].toDate();
                    // print(dateTime);
                    // ดึงวันที่เป็น String (yyyy-MM-dd)
                    String dateNormal =
                        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

                    if (!uniqueNormalDates.contains(dateNormal)) {
                      uniqueNormalDates.add(dateNormal);
                    }

                    String date = formatThaiDate(
                        item.value['วันเดือนปีนัดหมาย'].toDate());

                    // ตรวจสอบว่า date มีอยู่ใน uniqueDates หรือไม่
                    if (!uniqueDates.contains(date)) {
                      // ถ้าไม่มีให้เพิ่ม date เข้าไปใน uniqueDates และเพิ่ม map ลงใน List
                      uniqueDates.add(date);
                    }
                  }

                  print(uniqueNormalDates);
                  print(uniqueDates);

                  for (var entry in sortedFilteredData.entries) {
                    print(entry);
                  }
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 15.0, 0.0, 0.0),
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          for (int j = 0; j < uniqueDates.length; j++)
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'แผนการเข้าเยี่มมประจำวันที่ ${uniqueDates[j]}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Kanit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(
                                      //   height:
                                      //       24.0 * filteredData.entries.length,
                                      //   child: VerticalDivider(
                                      //     thickness: 2.0,
                                      //     indent: 8.0,
                                      //     endIndent: 8.0,
                                      //     color: FlutterFlowTheme.of(context)
                                      //         .secondaryText,
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            for (var entry
                                                in sortedFilteredData.entries)
                                              uniqueNormalDates[j] !=
                                                      formatDate(entry.value[
                                                          'วันเดือนปีนัดหมาย'])
                                                  ? SizedBox()
                                                  : InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        // context.pushNamed(
                                                        //     'A15_02_DetailVisitCustomerPlan');
                                                        Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  A1402CheckIn(
                                                                      entry:
                                                                          entry),
                                                            ));
                                                      },
                                                      child: Container(
                                                        // color: Colors.red,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: Colors
                                                                  .grey, // สีขอบด้านซ้าย
                                                              width:
                                                                  2.0, // ความหนาขอบด้านซ้าย
                                                            ),
                                                          ),
                                                        ),
                                                        height: 30,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      '${entry.value['ชื่อนามสกุล']}  เวลา ${entry.value['วันเดือนปีนัดหมาย'].toDate().toString().substring(10, 16)} น.',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                          ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    entry.value['สถานะ'] ==
                                                                            true
                                                                        ? Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                5.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.green.shade900,
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(3.0, 3.0, 3.0, 3.0),
                                                                                child: Icon(
                                                                                  Icons.place_outlined,
                                                                                  color: Colors.white,
                                                                                  size: 9.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : SizedBox()
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  size: 16.0,
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
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
