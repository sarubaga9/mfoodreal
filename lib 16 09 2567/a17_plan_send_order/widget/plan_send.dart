import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/a09_customer_open_sale/a09020_product_history_detail.dart';
import 'package:m_food/a13_visit_customer_plan/a1302_visit_detail.dart';
import 'package:m_food/a13_visit_customer_plan/a1303_visit_form.dart';
import 'package:m_food/a17_plan_send_order/a170101_plan_send._list.dart';
import 'package:m_food/a17_plan_send_order/a1702_plan_status.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shimmer/shimmer.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanSend extends StatefulWidget {
  const PlanSend({super.key});

  @override
  _PlanSendState createState() => _PlanSendState();
}

class _PlanSendState extends State<PlanSend> {
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  final customerController = Get.find<CustomerController>();

  TextEditingController textControllerFind = TextEditingController();
  FocusNode textFieldFocusNodeFind = FocusNode();

  bool isLoading = false;
  List<Map<String, dynamic>> customerDataList = [];

  List<DateTime?> uniqueDateFinal = [];
  List<String> id = [];
  List<String> customerName = [];
  List<Map<String, dynamic>> orderWithID = [];
  List<DateTime?> orderDatetimeList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      userData = userController.userData;

      // QuerySnapshot<Map<String, dynamic>> querySnapshot =
      //     await FirebaseFirestore.instance
      //         .collection(AppSettings.customerType == CustomerType.Test
      //             ? 'CustomerTest'
      //             : 'Customer')
      //         .where('รหัสพนักงานขาย', isEqualTo: userData!['EmployeeID'])
      //         .get();

      // for (QueryDocumentSnapshot customerDoc in querySnapshot.docs) {
      //   Map<String, dynamic> customerData =
      //       customerDoc.data() as Map<String, dynamic>;
      //   customerDataList.add(customerData);
      // }

      // customerDataList
      //     .removeWhere((customerData) => customerData['สถานะ'] == false);

      // //==================================================
      // // หากเริ่มทำงานจริง ให้เปิดเงื่อนไขนี้ไว้ เพื่อกรองดาต้าจริง
      // customerDataList.removeWhere((customerData) =>
      //     userData!['EmployeeID'] != customerData['รหัสพนักงานขาย']);
      // //==================================================
      // customerDataList.sort((a, b) {
      //   String nameA = a['ชื่อนามสกุล'];
      //   String nameB = b['ชื่อนามสกุล'];

      //   return nameA.compareTo(nameB);
      // });

      // print(customerDataList.length);
      // print(customerDataList.length);
      // print(customerDataList.length);

      List<DateTime?> allDate = [];

      // for (int i = 0; i < customerDataList.length; i++) {
      //   id.add(customerDataList[i]['CustomerID']);

      //   if (customerDataList[i]['ประเภทลูกค้า'] == 'Company') {
      //     customerName.add(customerDataList[i]['ชื่อบริษัท']);
      //   } else {
      //     customerName.add(
      //         // '${customerDataList[i]['ชื่อ']} ${customerDataList[i]['นามสกุล']}');
      //         '${customerDataList[i]['ชื่อนามสกุล']}');
      //   }

      //   // orderWithID.add([]);
      //   // orderDatetimeList.add([]);
      // }

      // for (int i = 0; i < customerDataList.length; i++) {
      // CollectionReference subCollectionRef = FirebaseFirestore.instance
      //     .collection(AppSettings.customerType == CustomerType.Test
      //         ? 'CustomerTest/${customerDataList[i]['CustomerID']}/แผนการจัดส่ง'
      //         : 'Customer/${customerDataList[i]['CustomerID']}/แผนการจัดส่ง');

      CollectionReference subCollectionRef = FirebaseFirestore.instance
          // .collection(AppSettings.customerType == CustomerType.Test
          //     ? 'CustomerTest/${customerDataList[i]['CustomerID']}/Orders'
          //     : 'Customer/${customerDataList[i]['CustomerID']}/Orders');

          .collection(AppSettings.customerType == CustomerType.Test
              ? 'OrdersTest'
              : 'Orders');

      // ดึงข้อมูลจาก subcollection 'นพกำพห'
      QuerySnapshot subCollectionSnapshot = await subCollectionRef
          .where('UserDocId', isEqualTo: userData!['EmployeeID'])
          .get();
      print('object');
      print(subCollectionSnapshot.docs.length);
      print(subCollectionSnapshot.docs.length);
      print(subCollectionSnapshot.docs.length);

      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      subCollectionSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        orderWithID.add(data);

        data['วันเวลาจัดส่ง'] == ''
            ? null
            : orderDatetimeList.add(data['วันเวลาจัดส่ง'].toDate());

        allDate.add(data['วันเวลาจัดส่ง'] == ''
            ? null
            : data['วันเวลาจัดส่ง'].toDate());

        id.add(data['CustomerDoc']['CustomerID']);

        if (data['CustomerDoc']['ประเภทลูกค้า'] == 'Company') {
          customerName.add(data['CustomerDoc']['ชื่อนามสกุล']);
          // customerName.add(data['CustomerDoc']['ชื่อบริษัท']);
        } else {
          customerName.add(
              // '${customerDataList[i]['ชื่อ']} ${customerDataList[i]['นามสกุล']}');
              '${data['CustomerDoc']['ชื่อนามสกุล']}');
        }
      });

      // mapDataOrdersData = (mapDataOrdersData ?? [])
      //     .where((map) => map != null)
      //     .cast<Map<String, dynamic>>()
      //     .toList();
      // }
      print(id.length);
      print(customerName.length);

      print(orderDatetimeList);

      print(orderWithID.length);

      print(allDate.length);
      print('object');

      String formatDateCheck(DateTime date) {
        return '${date.day}/${date.month}/${date.year}';
      }

      Set<String> uniqueDates = Set<String>();
      List<DateTime> duplicatedDates = [];

      for (DateTime? date in allDate) {
        if (date == null) {
        } else {
          String formattedDate =
              formatDateCheck(date); // กำหนดวันที่ในรูปแบบที่ต้องการ

          print(formattedDate);

          // ตรวจสอบว่าวันที่ซ้ำกันหรือไม่
          if (uniqueDates.contains(formattedDate)) {
            duplicatedDates.add(date);
          } else {
            uniqueDates.add(formattedDate);
          }
        }
      }

      print('uniqueDates Dates: $uniqueDates');

      String formatDateString(String dateString) {
        List<String> dateParts = dateString.split('/');
        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);

        // กำหนดรูปแบบใหม่ "YYYY-MM-DD"
        return '$year-$month-$day';
      }

      uniqueDateFinal = uniqueDates.map((String dateString) {
        return DateFormat('d/M/yyyy').parse(dateString);
      }).toList();

      uniqueDateFinal.sort((a, b) => b!.compareTo(a!));

      print('333');

      print(uniqueDateFinal);

      // แสดงผลลัพธ์
      print('Duplicated Dates: $duplicatedDates');
      print('uniqueDates Dates: $uniqueDates');

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
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
        (dateTime.year + 543).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

    return '$day $month $year';
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;
    return isLoading
        ? Container(
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                ),
                Center(
                  child: CircularLoading(success: !isLoading),
                ),
              ],
            ),
          )
        : Container(
            decoration: const BoxDecoration(),
            child: Container(
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 10.0),
                    child: Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent3,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 11.0, 8.0, 0.0),
                              child: TextFormField(
                                controller: textControllerFind,
                                focusNode: textFieldFocusNodeFind,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelLarge,
                                  alignLabelWithHint: false,
                                  hintText: 'ค้นหาบัญชีบัญชีลูกค้าในระบบ',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelLarge,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  // suffixIcon: const Icon(
                                  //   Icons.search,
                                  // ),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                textAlign: TextAlign.center,
                                // validator:
                                //     textControllerValidator.asValidator(context),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                  ),
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
                  //         'เพิ่มแผนการจัดส่งลูกค้า',
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
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 15.0, 0.0, 0.0),
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          for (int j = 0; j < uniqueDateFinal.length; j++)
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
                                        'แผนการจัดส่งประจำวันที่ ${formatThaiDate(uniqueDateFinal[j]!)}',
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
                                            for (int k = 0;
                                                k < orderDatetimeList.length;
                                                k++)
                                              // uniqueDateFinal[j].toString() !=
                                              //         formatDate(orderWithID[k]['วันเวลาจัดส่ง'])
                                              //     ? SizedBox()
                                              //     :

                                              orderDatetimeList[k]!.year ==
                                                          uniqueDateFinal[j]!
                                                              .year &&
                                                      orderDatetimeList[k]!
                                                              .month ==
                                                          uniqueDateFinal[j]!
                                                              .month &&
                                                      orderDatetimeList[k]!
                                                              .day ==
                                                          uniqueDateFinal[j]!
                                                              .day
                                                  // orderDatetimeList.any(
                                                  //         (dateTime) =>
                                                  //             dateTime!.year ==
                                                  //                 uniqueDateFinal[
                                                  //                         j]!
                                                  //                     .year &&
                                                  //             dateTime.month ==
                                                  //                 uniqueDateFinal[
                                                  //                         j]!
                                                  //                     .month &&
                                                  //             dateTime.day ==
                                                  //                 uniqueDateFinal[
                                                  //                         j]!
                                                  //                     .day)
                                                  ? InkWell(
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
                                                        print(id[k]);
                                                        print(customerName[k]);
                                                        print(
                                                            uniqueDateFinal[j]);
                                                        print(orderWithID[k]);

                                                        Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  A09020ProductHistoryDetail(
                                                                      customerID:
                                                                          id[k],
                                                                      orderDataMap:
                                                                          orderWithID[
                                                                              k]),
                                                            ));
                                                        // Navigator.push(
                                                        //     context,
                                                        //     CupertinoPageRoute(
                                                        //       builder: (context) => A170101PlanSendList(
                                                        //           customerID:
                                                        //               id[k],
                                                        //           customerName:
                                                        //               customerName[
                                                        //                   k],
                                                        //           orderDataMap:
                                                        //               orderWithID,
                                                        //           uniqueDateFinal:
                                                        //               uniqueDateFinal[
                                                        //                   j]),
                                                        //     ));
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
                                                                Text(
                                                                  orderWithID[k]![
                                                                          'OrdersDateID'] + ' '+
                                                                      customerName[
                                                                          k],
                                                                  // '${entry.value['ชื่อนามสกุล']}  เวลา ${entry.value['วันเดือนปีนัดหมาย'].toDate().toString().substring(10, 16)} น.',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                      ),
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
                                                    )
                                                  : SizedBox()
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
                  ),
                ],
              ),
            ),
          );
  }
}
