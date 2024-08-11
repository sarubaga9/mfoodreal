import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m_food/main.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailCreditWidget extends StatefulWidget {
  final Map<String, dynamic>? entryMap;

  const DetailCreditWidget({@required this.entryMap, super.key});

  @override
  _DetailCreditWidgetState createState() => _DetailCreditWidgetState();
}

class _DetailCreditWidgetState extends State<DetailCreditWidget> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

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
    print('This is detail credit widget ');
    print('==============================');

    String customFormatThai(DateTime dateTime) {
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
          (dateTime.year + 543).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

      return '$day $month $year';
    }

    String customFormatThaiToMonth(DateTime dateTime) {
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
          (dateTime.year + 543).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

      return '$month $year';
    }

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.entryMap!['value']['ประเภทลูกค้า'] == 'Company'
                    ? widget.entryMap!['value']['ชื่อบริษัท']
                    : widget.entryMap!['value']['ชื่อนามสกุล'],
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Kanit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.entryMap!['value']['ประเภทลูกค้า'] == 'Personal'
                    ? 'เป็นลูกค้าประเภทบุคคลธรรมดา'
                    : 'เป็นลูกค้าประเภทนิติบุคคล',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Kanit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'ประวัติดการสั่งซื้อ เดือนล่าสุด',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Kanit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
              // Column(
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Icon(
              //       Icons.keyboard_arrow_right,
              //       color: FlutterFlowTheme.of(context).secondaryText,
              //       size: 24.0,
              //     ),
              //   ],
              // ),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 970.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        5.0, 0.0, 5.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView(
                          padding: const EdgeInsets.fromLTRB(
                            0,
                            16.0,
                            0,
                            16.0,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                maxWidth: 570.0,
                              ),
                              decoration: const BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 10.0,
                                        height: 10.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(3.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            customFormatThaiToMonth(
                                                DateTime.now()),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontWeight: FontWeight.normal,
                                                  lineHeight: 0.9,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            6.0, 0.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            offset: const Offset(-2.0, 0.0),
                                          )
                                        ],
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection(AppSettings
                                                                .customerType ==
                                                            CustomerType.Test
                                                        ? 'CustomerTest'
                                                        : 'Customer')
                                                    .doc(widget
                                                            .entryMap!['value']
                                                        ['CustomerID'])
                                                    .collection('Orders')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
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
                                                  if (snapshot
                                                      .data!.docs.isEmpty) {
                                                    print(snapshot.data);
                                                  }

                                                  // เก็บข้อมูลจาก Firestore ลงใน Map
                                                  List<Map<String, dynamic>>
                                                      customerOrderDataList =
                                                      [];
                                                  for (QueryDocumentSnapshot customerOrderDoc
                                                      in snapshot.data!.docs) {
                                                    Map<String, dynamic>
                                                        customerOrderData =
                                                        customerOrderDoc.data()
                                                            as Map<String,
                                                                dynamic>;

                                                    customerOrderDataList
                                                        .add(customerOrderData);
                                                  }

                                                  // DateTime now = DateTime.now();
                                                  // DateTime previousMonth =
                                                  //     DateTime(now.year,
                                                  //         now.month - 1);

                                                  // List<Map<String, dynamic>>
                                                  //     filteredList =
                                                  //     customerOrderDataList
                                                  //         .where((order) {
                                                  //   DateTime orderUpdateTime =
                                                  //       order['OrdersUpdateTime']
                                                  //           .toDate();
                                                  //   return orderUpdateTime
                                                  //       .isBefore(
                                                  //           previousMonth);
                                                  // }).toList();

                                                  DateTime now = DateTime.now();
                                                  DateTime currentMonthStart =
                                                      DateTime(now.year,
                                                          now.month, 1);

                                                  List<Map<String, dynamic>>
                                                      filteredList =
                                                      customerOrderDataList
                                                          .where((order) {
                                                    DateTime orderUpdateTime =
                                                        order['OrdersUpdateTime']
                                                            .toDate();
                                                    return orderUpdateTime
                                                        .isAfter(
                                                            currentMonthStart);
                                                  }).toList();

                                                  // จัดเรียง filteredList โดยให้รายการที่มีค่า 'date' มีวันที่ล่าสุดอยู่หน้าสุด
                                                  filteredList.sort((a, b) {
                                                    DateTime dateA =
                                                        a['OrdersUpdateTime']
                                                            .toDate();
                                                    DateTime dateB =
                                                        b['OrdersUpdateTime']
                                                            .toDate();
                                                    return dateB
                                                        .compareTo(dateA);
                                                  });

                                                  print(filteredList);

                                                  // print(
                                                  //     customerOrderDataList.length);

                                                  // print(
                                                  //     filteredList.length);

                                                  double totalAmount =
                                                      filteredList.fold(0.0,
                                                          (sum, order) {
                                                    // ทำการบวกยอดรวมของแต่ละ Order
                                                    double orderTotal =
                                                        (order['ยอดรวม'] as num)
                                                            .toDouble();
                                                    return sum + orderTotal;
                                                  });

                                                  // print(
                                                  //     'ยอดรวมทั้งหมด: $totalAmount');

                                                  // print(customerRatingList[i]['data']
                                                  //     [
                                                  //     'เปรียบเทียบ']);
                                                  // print(customerRatingList[i]['data']
                                                  //     [
                                                  //     'ยอดขาย']);

                                                  // for (var element
                                                  //     in customerRatingList) {
                                                  //   print(element['data']['ยอดขาย']);
                                                  // }
                                                  return Column(
                                                    children: [
                                                      for (int i = 0;
                                                          i <
                                                              filteredList
                                                                  .length;
                                                          i++)
                                                        Container(
                                                          height: 20.0,
                                                          decoration:
                                                              const BoxDecoration(),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        100.0,
                                                                    child:
                                                                        VerticalDivider(
                                                                      width:
                                                                          3.0,
                                                                      thickness:
                                                                          1.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        3.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                    child: Text(
                                                                      customFormatThai(filteredList[i]
                                                                              [
                                                                              'OrdersUpdateTime']
                                                                          .toDate()),
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
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                NumberFormat(
                                                                            '#,###')
                                                                        .format(
                                                                            filteredList[i]!['ยอดรวม'])
                                                                        .toString() +
                                                                    ' บาท',
                                                                style: FlutterFlowTheme.of(
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
                                                        ),
                                                    ],
                                                  );
                                                }),
                                          ].addToEnd(
                                              const SizedBox(height: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ].divide(const SizedBox(height: 0.0)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Container(
          //   width: MediaQuery.sizeOf(context).width * 1.0,
          //   height: MediaQuery.sizeOf(context).height * 0.63,
          //   decoration: BoxDecoration(
          //     color: FlutterFlowTheme.of(context).secondaryBackground,
          //     borderRadius: BorderRadius.circular(20.0),
          //   ),
          //   alignment: const AlignmentDirectional(0.00, 0.00),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Row(
          //         mainAxisSize: MainAxisSize.max,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             'ดึงข้อมูลเครดิตของลูกค้าจาก API M Food',
          //             textAlign: TextAlign.center,
          //             style: FlutterFlowTheme.of(context).titleMedium.override(
          //                   fontFamily: 'Kanit',
          //                   color: FlutterFlowTheme.of(context).primaryText,
          //                 ),
          //           ),
          //         ],
          //       ),
          //       Row(
          //         mainAxisSize: MainAxisSize.max,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             'ที่ต้องการให้มาแสดงที่หน้านี้',
          //             style: FlutterFlowTheme.of(context).titleMedium.override(
          //                   fontFamily: 'Kanit',
          //                   color: FlutterFlowTheme.of(context).primaryText,
          //                 ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
