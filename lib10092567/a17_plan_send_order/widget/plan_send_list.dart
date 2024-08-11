import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/a13_visit_customer_plan/a1302_visit_detail.dart';
import 'package:m_food/a13_visit_customer_plan/a1303_visit_form.dart';
import 'package:m_food/a14_visit_save_time/a1402_check_in.dart';
import 'package:m_food/a17_plan_send_order/a1702_plan_status.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanSendList extends StatefulWidget {
  final String? customerID;
  final String? customerName;
  final List<Map<String, dynamic>?>? orderDataMap;
  final DateTime? uniqueDateFinal;
  const PlanSendList(
      {super.key,
      this.orderDataMap,
      this.customerName,
      this.customerID,
      this.uniqueDateFinal});

  @override
  _PlanSendListState createState() => _PlanSendListState();
}

class _PlanSendListState extends State<PlanSendList> {
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
        (dateTime.year).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

    return '$day $month $year';
  }

  String statusSendOrder(int index) {
    int number = 0;
    for (int i = 0;
        i < widget.orderDataMap![index]!['ลำดับการจัดส่ง'].length;
        i++) {
      print(i);
      if (widget.orderDataMap![index]!['ลำดับการจัดส่ง'][i]) {
        number = number + 1;
        print(number);
      } else {}
    }

    print(widget.orderDataMap![index]!['หัวข้อลำดับการจัดส่ง'][number - 1]);

    return widget.orderDataMap![index]!['หัวข้อลำดับการจัดส่ง'][number - 1];
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;
    List<DateTime?> orderDatetimeList = [];

    for (var element in widget.orderDataMap!) {
      if (element!['วันเวลาจัดส่ง'] == '') {
        orderDatetimeList.add(null);
      } else {
        orderDatetimeList.add(element['วันเวลาจัดส่ง'].toDate());
      }
    }

    print(orderDatetimeList);
    print(widget.uniqueDateFinal!.year);
    print(widget.uniqueDateFinal!.month);
    print(widget.uniqueDateFinal!.day);

    print(orderDatetimeList.any((dateTime) {
      if (dateTime == null) {
        return false;
      } else {
        if (dateTime.year == widget.uniqueDateFinal!.year &&
            dateTime.month == widget.uniqueDateFinal!.month &&
            dateTime.day == widget.uniqueDateFinal!.day) {
          return true;
        } else {
          return false;
        }
      }
    }));

    List<int> indices =
        List.generate(orderDatetimeList.length, (index) => index)
            .where((index) {
      if (orderDatetimeList[index] == null) {
        return false;
      } else {
        return orderDatetimeList[index]!.year == widget.uniqueDateFinal!.year &&
            orderDatetimeList[index]!.month == widget.uniqueDateFinal!.month &&
            orderDatetimeList[index]!.day == widget.uniqueDateFinal!.day;
      }
    }).toList();

    print(indices);

    for (var element in indices) {
      print(orderDatetimeList[element]);
    }

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
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.customerName!,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'แผนการขนส่งประจำวันที่ ${formatThaiDate(widget.uniqueDateFinal!)}',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context).primaryText,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            // for (var entry in sortedFilteredData.entries)
                            //   uniqueNormalDates[j] !=
                            //           formatDate(
                            //               entry.value['วันเดือนปีนัดหมาย'])
                            //       ? SizedBox()
                            //       :
                            for (int k = 0; k < indices.length; k++)
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  // context.pushNamed(
                                  //     'A15_02_DetailVisitCustomerPlan');
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => A1702PlanStatus(
                                            customerID: widget.customerID,
                                            customerName: widget.customerName,
                                            uniqueDateFinal:
                                                widget.uniqueDateFinal,
                                            orderDataMap: widget
                                                .orderDataMap![indices[k]]),
                                      ));
                                },
                                child: Container(
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.grey, // สีขอบด้านซ้าย
                                        width: 2.0, // ความหนาขอบด้านซ้าย
                                      ),
                                    ),
                                  ),
                                  height: 30,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            children: [
                                              widget.orderDataMap![indices[k]]![
                                                          'วันเวลาจัดส่ง'] ==
                                                      ''
                                                  ? Text(
                                                      '',
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
                                                    )
                                                  : Text(
                                                      // 'รายการที่ ${k + 1} : ${formatDate(widget.orderDataMap![indices[k]]!['วันเวลาจัดส่ง'])} สถานะ ${statusSendOrder(indices[k])} ',

                                                      'รายการที่ ${k + 1} : สถานะ ${statusSendOrder(indices[k])} ',
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
                                              SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
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
  }
}
