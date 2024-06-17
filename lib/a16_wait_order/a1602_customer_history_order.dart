import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a08_customer_rating_group/a0803_customer_order_table.dart';
import 'package:m_food/a09_customer_open_sale/a09021_address_setting.dart';
import 'package:m_food/a09_customer_open_sale/a0903_product_screen.dart';
import 'package:m_food/a16_wait_order/a1603_order_detail.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';

class A1602CustomerHistoryOrder extends StatefulWidget {
  final String? customerID;
  final String? status;

  const A1602CustomerHistoryOrder({super.key, this.customerID, this.status});

  @override
  _A1602CustomerHistoryOrderState createState() =>
      _A1602CustomerHistoryOrderState();
}

class _A1602CustomerHistoryOrderState extends State<A1602CustomerHistoryOrder> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  late Map<String, dynamic> customerData;
  List<Map<String, dynamic>?>? mapDataOrdersData = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      // ดึงข้อมูลจาก collection 'Customer'
      DocumentSnapshot customerDoc = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'CustomerTest'
              : 'Customer')
          .doc(widget.customerID)
          .get();

      if (customerDoc.exists) {
        // แปลง DocumentSnapshot เป็น Map<String, dynamic>
        customerData = customerDoc.data() as Map<String, dynamic>;

        // สามารถทำอะไรกับ customerData ต่อได้
        print('Customer Data: $customerData');
      } else {
        customerData = {};
        print('Document does not exist');
      }

      print(customerData);

      print('customerid');
      print(widget.customerID);

      // ตรวจสอบว่าเอกสาร '124' มี subcollection 'นพกำพห' หรือไม่
      if (customerDoc.exists) {
        CollectionReference subCollectionRef = FirebaseFirestore.instance
            .collection(AppSettings.customerType == CustomerType.Test
                ? 'CustomerTest/${widget.customerID}/Orders'
                : 'Customer/${widget.customerID}/Orders');

        // ดึงข้อมูลจาก subcollection 'นพกำพห'
        QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

        // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
        subCollectionSnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (widget.status == 'ทั้งหมด') {
            mapDataOrdersData!.add(data);
          } else {
            // if (data['สถานะเอกสาร'] == true &&
            //     data['รอตรวจการอนุมัติ'] == false &&
            //     data['สถานะอนุมัติขาย'] == false) {
            if (data['สถานะเอกสาร'] == true && data['สถานะค้างชำระ'] == true) {
              mapDataOrdersData!.add(data);
            } else {}
          }
        });

        mapDataOrdersData = (mapDataOrdersData ?? [])
            .where((map) => map != null)
            .cast<Map<String, dynamic>>()
            .toList();

        // print(mapDataOrdersData);
      } else {
        print('ไม่พบเอกสารที่มี ID เป็น "124"');
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
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

  String formatThaiMonth(int month) {
    // สร้าง Map เพื่อทำการแมปเดือนเป็นภาษาไทย
    Map<int, String> thaiMonths = {
      1: 'มกราคม',
      2: 'กุมภาพันธ์',
      3: 'มีนาคม',
      4: 'เมษายน',
      5: 'พฤษภาคม',
      6: 'มิถุนายน',
      7: 'กรกฎาคม',
      8: 'สิงหาคม',
      9: 'กันยายน',
      10: 'ตุลาคม',
      11: 'พฤศจิกายน',
      12: 'ธันวาคม',
    };

    return thaiMonths[month] ?? 'Unknown';
  }

  void sortOrdersByUpdateTime(List<Map<String, dynamic>?>? orders) {
    // เรียงลำดับตาม 'OrdersUpdateTime' โดยใหม่ที่สุดมาก่อน
    orders?.sort((a, b) {
      Timestamp timeA = a?['OrdersUpdateTime'] as Timestamp;
      Timestamp timeB = b?['OrdersUpdateTime'] as Timestamp;

      return timeB.toDate().compareTo(timeA.toDate());
    });
  }

  List<Map<String, dynamic>?>? filterOrdersByMonth(
      List<Map<String, dynamic>?>? orders, String desiredMonth) {
    // print(desiredMonth);
    // กรองข้อมูลเฉพาะเดือนที่ต้องการ
    return orders?.where((order) {
      Timestamp orderTime = order?['OrdersUpdateTime'] as Timestamp;
      String orderMonth = orderTime
          .toDate()
          .month
          .toString()
          .padLeft(2, '0'); // แปลงให้มี 2 หลัก

      // print(orderMonth);
      // print(desiredMonth);

      return orderMonth == desiredMonth.padLeft(2, '0');
    }).toList();
  }

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

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A1602 customer history order');
    print(widget.customerID);
    print(widget.status);
    print('==============================');
    userData = userController.userData;
    // customerData = customerController.customerData!;

    // ดึงเดือนปัจจุบัน
    DateTime currentDate = DateTime.now();
    // print('Current Month in Thai: ${formatThaiMonth(currentDate.month)}');

    // ดึงเดือนย้อนหลัง 3 เดือน
    DateTime threeMonthsAgo = currentDate.subtract(Duration(days: 60));
    // print('Three Months Ago in Thai: ${formatThaiMonth(threeMonthsAgo.month)}');
    DateTime twoMonthsAgo = currentDate.subtract(Duration(days: 30));
    // print('Three Months Ago in Thai: ${formatThaiMonth(twoMonthsAgo.month)}');
    DateTime oneMonthsAgo = currentDate.subtract(Duration(days: 0));
    // print(
    // 'Three Months Ago in Thai: ${formatThaiMonth(oneMonthsAgo.month)} ${oneMonthsAgo.year + 543}');

    sortOrdersByUpdateTime(mapDataOrdersData);
    // print(mapDataOrdersData!.length);

    // List<Map<String, dynamic>?>? mapDataOne =
    //     filterOrdersByMonth(mapDataOrdersData, oneMonthsAgo.month.toString());
    // List<Map<String, dynamic>?>? mapDataTwo =
    //     filterOrdersByMonth(mapDataOrdersData, twoMonthsAgo.month.toString());
    // List<Map<String, dynamic>?>? mapDataThree =
    //     filterOrdersByMonth(mapDataOrdersData, threeMonthsAgo.month.toString());

    // print(mapDataOne!.length);
    // print(mapDataTwo!.length);
    // print(mapDataThree!.length);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularLoading(success: !isLoading),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 10.0, 10.0),
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
                                'ประวัติการสั่งสินค้า',
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
                                              // Navigator.pop(context);
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
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 0.0),
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

                            //========================= Body ===============================
                            Expanded(
                              // flex: 2,
                              child: Container(
                                decoration: const BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // //================= เปิดใบสั่งขายสินค้า ======================
                                    // InkWell(
                                    //   splashColor: Colors.transparent,
                                    //   focusColor: Colors.transparent,
                                    //   hoverColor: Colors.transparent,
                                    //   highlightColor: Colors.transparent,
                                    //   onTap: () async {
                                    //     Navigator.push(
                                    //         context,
                                    //         CupertinoPageRoute(
                                    //           builder: (context) =>
                                    //               A09021AddressSetting(
                                    //             customerID: widget.customerID,
                                    //             orderDataMap: {},
                                    //           ),
                                    //         ));
                                    //   },
                                    //   child: Row(
                                    //     mainAxisSize: MainAxisSize.max,
                                    //     mainAxisAlignment: MainAxisAlignment.end,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.end,
                                    //     children: [
                                    //       Padding(
                                    //         padding: const EdgeInsetsDirectional
                                    //             .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                    //         child: Icon(
                                    //           FFIcons.kfileDocumentPlus,
                                    //           color: FlutterFlowTheme.of(context)
                                    //               .alternate,
                                    //           size: 24.0,
                                    //         ),
                                    //       ),
                                    //       Text(
                                    //         'เปิดใบสั่งขายสินค้า',
                                    //         style: FlutterFlowTheme.of(context)
                                    //             .bodyLarge
                                    //             .override(
                                    //               fontFamily: 'Kanit',
                                    //               color:
                                    //                   FlutterFlowTheme.of(context)
                                    //                       .primaryText,
                                    //               fontWeight: FontWeight.w500,
                                    //             ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          customerData['ประเภทลูกค้า'] ==
                                                  'Company'
                                              ? customerData['ชื่อบริษัท']
                                              : customerData['ชื่อ'] +
                                                  ' ' +
                                                  customerData['นามสกุล'],
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
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ประวัติการสั่งสินค้าทั้งหมด',
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          '***',
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
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            // color: mapDataOrdersData![j]!['สถานะเอกสาร'] == false ? Colors.yellow.shade700 : Colors.green.shade700,
                                            width: 20,
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green.shade900,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'เอกสารออเดอร์ผ่านแล้ว',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText
                                                        .withOpacity(0.5),
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            // color: mapDataOrdersData![j]!['สถานะเอกสาร'] == false ? Colors.yellow.shade700 : Colors.green.shade700,
                                            width: 20,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red.shade900,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'รอตรวจเอกสารออเดอร์',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText
                                                        .withOpacity(0.5),
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    //================= ดึงข้อมูลอื่นๆจาก API M Food ที่ต้องการ ======================
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsetsDirectional.fromSTEB(
                                    //           0.0, 10.0, 0.0, 10.0),
                                    //   child: Container(
                                    //     width: MediaQuery.sizeOf(context).width *
                                    //         1.0,
                                    //     height: 250.0,
                                    //     decoration: BoxDecoration(
                                    //       color: FlutterFlowTheme.of(context)
                                    //           .secondaryBackground,
                                    //       borderRadius:
                                    //           BorderRadius.circular(20.0),
                                    //     ),
                                    //     alignment: const AlignmentDirectional(
                                    //         0.00, 0.00),
                                    //     child: Column(
                                    //       mainAxisSize: MainAxisSize.max,
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         Row(
                                    //           mainAxisSize: MainAxisSize.max,
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: [
                                    //             Text(
                                    //               'ดึงข้อมูลอื่นๆจาก API M Food ที่ต้องการ ',
                                    //               style:
                                    //                   FlutterFlowTheme.of(context)
                                    //                       .headlineSmall,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         Row(
                                    //           mainAxisSize: MainAxisSize.max,
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: [
                                    //             Text(
                                    //               'ให้มาแสดงที่หน้านี้',
                                    //               style:
                                    //                   FlutterFlowTheme.of(context)
                                    //                       .headlineSmall,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    //========================== ประวัติย้อนหลังทั้งหมด ===================
                                    const SizedBox(height: 10),

                                    Column(
                                      children: [
                                        // for (int i = 0; i < 3; i++)
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  constraints:
                                                      const BoxConstraints(
                                                    maxWidth: 970.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: ListView(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      0,
                                                      0.0,
                                                      0,
                                                      0.0,
                                                    ),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        constraints:
                                                            const BoxConstraints(
                                                          maxWidth: 570.0,
                                                        ),
                                                        decoration:
                                                            const BoxDecoration(),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // 1 เดือน ย้อนหลัง
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      1.0,
                                                                      0.0,
                                                                      1.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  // Container(
                                                                  //   width: 10.0,
                                                                  //   height: 10.0,
                                                                  //   decoration:
                                                                  //       BoxDecoration(
                                                                  //     color: FlutterFlowTheme.of(
                                                                  //             context)
                                                                  //         .secondaryText,
                                                                  //     shape: BoxShape
                                                                  //         .circle,
                                                                  //     border:
                                                                  //         Border
                                                                  //             .all(
                                                                  //       color: FlutterFlowTheme.of(
                                                                  //               context)
                                                                  //           .secondaryBackground,
                                                                  //       width:
                                                                  //           2.0,
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                  // Expanded(
                                                                  //   child:
                                                                  //       Padding(
                                                                  //     padding: const EdgeInsetsDirectional
                                                                  //         .fromSTEB(
                                                                  //         3.0,
                                                                  //         0.0,
                                                                  //         0.0,
                                                                  //         0.0),
                                                                  //     child: Text(
                                                                  //       i == 0
                                                                  //           ? '${formatThaiMonth(oneMonthsAgo.month)} ${oneMonthsAgo.year + 543}'
                                                                  //           : i == 1
                                                                  //               ? '${formatThaiMonth(twoMonthsAgo.month)} ${twoMonthsAgo.year + 543}'
                                                                  //               : '${formatThaiMonth(threeMonthsAgo.month)} ${threeMonthsAgo.year + 543}',
                                                                  //       style: FlutterFlowTheme.of(
                                                                  //               context)
                                                                  //           .bodyLarge
                                                                  //           .override(
                                                                  //             fontFamily:
                                                                  //                 'Kanit',
                                                                  //             color:
                                                                  //                 FlutterFlowTheme.of(context).primaryText,
                                                                  //             fontWeight:
                                                                  //                 FontWeight.w500,
                                                                  //             lineHeight:
                                                                  //                 0.9,
                                                                  //           ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                            // 1 เดือน ย้อนหลัง รายละเอียด
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                // decoration:
                                                                //     BoxDecoration(
                                                                //   color: FlutterFlowTheme
                                                                //           .of(context)
                                                                //       .primaryBackground,
                                                                //   boxShadow: [
                                                                //     BoxShadow(
                                                                //       color: FlutterFlowTheme.of(
                                                                //               context)
                                                                //           .secondaryText,
                                                                //       offset:
                                                                //           const Offset(
                                                                //               -2.0,
                                                                //               0.0),
                                                                //     )
                                                                //   ],
                                                                //   border:
                                                                //       Border.all(
                                                                //     color: FlutterFlowTheme.of(
                                                                //             context)
                                                                //         .primaryBackground,
                                                                //   ),
                                                                // ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      for (int j =
                                                                              0;
                                                                          j < mapDataOrdersData!.length;
                                                                          // (i == 0
                                                                          //     ? mapDataOne!.length
                                                                          //     : i == 1
                                                                          //         ? mapDataTwo!.length
                                                                          //         : mapDataThree!.length);
                                                                          j++)
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 5.0),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                20.0,
                                                                            decoration:
                                                                                const BoxDecoration(),
                                                                            child:
                                                                                InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    CupertinoPageRoute(
                                                                                      builder: (context) => A1603OrderDetail(customerID: widget.customerID, orderDataMap: mapDataOrdersData![j]),
                                                                                    ));
                                                                              },
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                        child: Container(
                                                                                          alignment: Alignment.center,
                                                                                          // color: mapDataOrdersData![j]!['สถานะเอกสาร'] == false ? Colors.yellow.shade700 : Colors.green.shade700,
                                                                                          width: 20,
                                                                                          child: mapDataOrdersData![j]!['สถานะเอกสาร'] == false
                                                                                              ? Icon(
                                                                                                  Icons.close,
                                                                                                  color: Colors.red.shade900,
                                                                                                  size: 16,
                                                                                                )
                                                                                              : Icon(
                                                                                                  Icons.check,
                                                                                                  size: 16,
                                                                                                  color: Colors.green.shade900,
                                                                                                ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),

                                                                                  // mapDataOrdersData![j]!['สถานะเอกสาร'] == false
                                                                                  //     ? Row(
                                                                                  //         mainAxisSize: MainAxisSize.max,
                                                                                  //         children: [
                                                                                  //           Padding(
                                                                                  //             padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //             child: Container(
                                                                                  //               alignment: Alignment.center,
                                                                                  //               color: Colors.yellow.shade700,
                                                                                  //               width: 120,
                                                                                  //               child: Text(
                                                                                  //                 'รอตรวจเอกสาร',
                                                                                  //                 style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  //                       fontFamily: 'Kanit',
                                                                                  //                       color: Colors.white,
                                                                                  //                     ),
                                                                                  //               ),
                                                                                  //             ),
                                                                                  //           ),
                                                                                  //         ],
                                                                                  //       )
                                                                                  //     : mapDataOrdersData![j]!['สถานะค้างชำระ'] == true
                                                                                  //         ? Row(
                                                                                  //             mainAxisSize: MainAxisSize.max,
                                                                                  //             children: [
                                                                                  //               Padding(
                                                                                  //                 padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //                 child: Container(
                                                                                  //                   alignment: Alignment.center,
                                                                                  //                   color: Colors.red.shade900,
                                                                                  //                   width: 120,
                                                                                  //                   child: Text(
                                                                                  //                     'ค้างชำระ',
                                                                                  //                     style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  //                           fontFamily: 'Kanit',
                                                                                  //                           color: Colors.white,
                                                                                  //                         ),
                                                                                  //                   ),
                                                                                  //                 ),
                                                                                  //               ),
                                                                                  //             ],
                                                                                  //           )
                                                                                  //         : mapDataOrdersData![j]!['สถานะอนุมัติขาย'] == false
                                                                                  //             ? Row(
                                                                                  //                 mainAxisSize: MainAxisSize.max,
                                                                                  //                 children: [
                                                                                  //                   Padding(
                                                                                  //                     padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //                     child: Container(
                                                                                  //                       alignment: Alignment.center,
                                                                                  //                       color: Colors.blue.shade700,
                                                                                  //                       width: 120,
                                                                                  //                       child: Text(
                                                                                  //                         'รอการอนุมัติ',
                                                                                  //                         style: FlutterFlowTheme.of(context).bodyLarge.override(fontFamily: 'Kanit', color: Colors.white),
                                                                                  //                       ),
                                                                                  //                     ),
                                                                                  //                   ),
                                                                                  //                 ],
                                                                                  //               )
                                                                                  //             : Row(
                                                                                  //                 mainAxisSize: MainAxisSize.max,
                                                                                  //                 children: [
                                                                                  //                   Padding(
                                                                                  //                     padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //                     child: Container(
                                                                                  //                       alignment: Alignment.center,
                                                                                  //                       color: Colors.green.shade700,
                                                                                  //                       width: 120,
                                                                                  //                       child: Text(
                                                                                  //                         'อนุมัติขาย',
                                                                                  //                         style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  //                               fontFamily: 'Kanit',
                                                                                  //                               color: Colors.white,
                                                                                  //                             ),
                                                                                  //                       ),
                                                                                  //                     ),
                                                                                  //                   ),
                                                                                  //                 ],
                                                                                  //               ),
                                                                                  // mapDataOrdersData![j]!['สถานะค้างชำระ'] == true
                                                                                  //     ? Row(
                                                                                  //         mainAxisSize: MainAxisSize.max,
                                                                                  //         children: [
                                                                                  //           Padding(
                                                                                  //             padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //             child: Container(
                                                                                  //               alignment: Alignment.center,
                                                                                  //               color: Colors.red.shade900,
                                                                                  //               width: 120,
                                                                                  //               child: Text(
                                                                                  //                 'ค้างชำระ',
                                                                                  //                 style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  //                       fontFamily: 'Kanit',
                                                                                  //                       color: Colors.white,
                                                                                  //                     ),
                                                                                  //               ),
                                                                                  //             ),
                                                                                  //           ),
                                                                                  //         ],
                                                                                  //       )
                                                                                  //     : mapDataOrdersData![j]!['สถานะเอกสาร'] == false
                                                                                  //         ? Row(
                                                                                  //             mainAxisSize: MainAxisSize.max,
                                                                                  //             children: [
                                                                                  //               Padding(
                                                                                  //                 padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //                 child: Container(
                                                                                  //                   alignment: Alignment.center,
                                                                                  //                   color: Colors.yellow.shade700,
                                                                                  //                   width: 120,
                                                                                  //                   child: Text(
                                                                                  //                     'รอตรวจเอกสาร',
                                                                                  //                     style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  //                           fontFamily: 'Kanit',
                                                                                  //                           color: Colors.white,
                                                                                  //                         ),
                                                                                  //                   ),
                                                                                  //                 ),
                                                                                  //               ),
                                                                                  //             ],
                                                                                  //           )
                                                                                  //         : mapDataOrdersData![j]!['สถานะอนุมัติขาย'] == true
                                                                                  //             ? Row(
                                                                                  //                 mainAxisSize: MainAxisSize.max,
                                                                                  //                 children: [
                                                                                  //                   Padding(
                                                                                  //                     padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //                     child: Container(
                                                                                  //                       alignment: Alignment.center,
                                                                                  //                       color: Colors.green.shade700,
                                                                                  //                       width: 120,
                                                                                  //                       child: Text(
                                                                                  //                         'อนุมัติขาย',
                                                                                  //                         style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  //                               fontFamily: 'Kanit',
                                                                                  //                               color: Colors.white,
                                                                                  //                             ),
                                                                                  //                       ),
                                                                                  //                     ),
                                                                                  //                   ),
                                                                                  //                 ],
                                                                                  //               )
                                                                                  //             : Row(
                                                                                  //                 mainAxisSize: MainAxisSize.max,
                                                                                  //                 children: [
                                                                                  //                   Padding(
                                                                                  //                     padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                  //                     child: Container(
                                                                                  //                       alignment: Alignment.center,
                                                                                  //                       color: Colors.yellow.shade700,
                                                                                  //                       width: 120,
                                                                                  //                       child: Text(
                                                                                  //                         'รอการอนุมัติ',
                                                                                  //                         style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  //                               fontFamily: 'Kanit',
                                                                                  //                               color: Colors.blue.shade400,
                                                                                  //                             ),
                                                                                  //                       ),
                                                                                  //                     ),
                                                                                  //                   ),
                                                                                  //                 ],
                                                                                  //               ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 120,
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        // SizedBox(
                                                                                        //   height: 100.0,
                                                                                        //   child: VerticalDivider(
                                                                                        //     width: 3.0,
                                                                                        //     thickness: 1.0,
                                                                                        //     color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        //   ),
                                                                                        // ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(1.0, 0.0, 0.0, 0.0),
                                                                                          child: Text(
                                                                                            customFormatThai(mapDataOrdersData![j]!['OrdersUpdateTime'].toDate()),
                                                                                            // i == 0
                                                                                            //     ? customFormatThai(mapDataOne![j]!['OrdersUpdateTime'].toDate())
                                                                                            //     : i == 1
                                                                                            //         ? customFormatThai(mapDataTwo![j]!['OrdersUpdateTime'].toDate())
                                                                                            //         : customFormatThai(mapDataThree![j]!['OrdersUpdateTime'].toDate()),
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  fontFamily: 'Kanit',
                                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                        child: Container(
                                                                                          alignment: Alignment.center,
                                                                                          color: mapDataOrdersData![j]!['สถานะเอกสาร'] == false
                                                                                              ? Colors.white
                                                                                              : mapDataOrdersData![j]!['สถานะค้างชำระ'] == true
                                                                                                  ? Colors.red.shade700
                                                                                                  : Colors.green.shade700,
                                                                                          width: 100,
                                                                                          child: Text(
                                                                                            mapDataOrdersData![j]!['สถานะเอกสาร'] == false
                                                                                                ? 'รอตรวจเอกสาร'
                                                                                                : mapDataOrdersData![j]!['สถานะค้างชำระ'] == true
                                                                                                    ? 'ค้างชำระ'
                                                                                                    : 'ไม่ค้างชำระ',
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  fontFamily: 'Kanit',
                                                                                                  color: mapDataOrdersData![j]!['สถานะเอกสาร'] == false ? Colors.grey.shade900 : Colors.white,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                        child: Container(
                                                                                          alignment: Alignment.center,
                                                                                          color: mapDataOrdersData![j]!['สถานะเอกสาร'] == false
                                                                                              ? Colors.white
                                                                                              : mapDataOrdersData![j]!['รอตรวจการอนุมัติ'] == true
                                                                                                  ? Colors.yellow.shade700
                                                                                                  : mapDataOrdersData![j]!['สถานะอนุมัติขาย'] == false
                                                                                                      ? Colors.red.shade700
                                                                                                      : Colors.green.shade700,
                                                                                          width: 100,
                                                                                          child: Text(
                                                                                            mapDataOrdersData![j]!['สถานะเอกสาร'] == false
                                                                                                ? 'รอตรวจเอกสาร'
                                                                                                : mapDataOrdersData![j]!['รอตรวจการอนุมัติ'] == true
                                                                                                    ? 'รอการอนุมัติขาย'
                                                                                                    : mapDataOrdersData![j]!['สถานะอนุมัติขาย'] == false
                                                                                                        ? 'ไม่อนุมัติขาย'
                                                                                                        : 'อนุมัติขาย',
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  fontFamily: 'Kanit',
                                                                                                  color: mapDataOrdersData![j]!['สถานะเอกสาร'] == false ? Colors.grey.shade900 : Colors.white,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Spacer(),
                                                                                  Text(
                                                                                    NumberFormat('#,###').format(mapDataOrdersData![j]!['ยอดรวม']).toString() + ' บาท',
                                                                                    // i == 0
                                                                                    //     ? NumberFormat('#,###').format(mapDataOne![j]!['ยอดรวม']).toString() + ' บาท'
                                                                                    //     : i == 1
                                                                                    //         ? NumberFormat('#,###').format(mapDataTwo![j]!['ยอดรวม']).toString() + ' บาท'
                                                                                    //         : NumberFormat('#,###').format(mapDataThree![j]!['ยอดรวม']).toString() + ' บาท',
                                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                          fontFamily: 'Kanit',
                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ].addToEnd(const SizedBox(
                                                                        height:
                                                                            20.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(
                                                        height: 0.0)),
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
