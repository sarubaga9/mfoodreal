import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a08_customer_rating_group/a0803_customer_order_table.dart';
import 'package:m_food/a09_customer_open_sale/a09020_product_history_detail.dart';
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

class A160401SearchHistory extends StatefulWidget {
  final List<Map<String, dynamic>>? listOrders;
  final bool? checkTeam;
  const A160401SearchHistory({
    this.listOrders,
    @required this.checkTeam,
    super.key,
  });

  @override
  _A160401SearchHistoryState createState() => _A160401SearchHistoryState();
}

class _A160401SearchHistoryState extends State<A160401SearchHistory> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  RxMap<String, dynamic>? customerData;
  List<Map<String, dynamic>>? customerDataList = [];

  List<Map<String, dynamic>>? mapDataOrdersData = [];

  Map<String, dynamic>? customerDataWithID;

  List<dynamic> orderIDHistoryList = [];
  List<dynamic> orderCustomerIDHistoryList = [];
  List<dynamic> orderTimeHistoryList = [];

  List<Map<String, dynamic>?>? orderListStatename = [];
  List<Map<String, dynamic>?>? sectionID2List = [];

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

      print('check01');

      userData = userController.userData;

      // if (userData!['ออเดอร์วันนี้'] == null) {
      //   orderIDHistoryList = [];
      // } else {
      //   orderIDHistoryList = userData!['ออเดอร์วันนี้'];
      // }

      // if (userData!['ออเดอร์วันนี้_วันที่'] == null) {
      //   orderTimeHistoryList = [];
      // } else {
      //   orderTimeHistoryList = userData!['ออเดอร์วันนี้_วันที่'];
      // }

      // if (userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] == null) {
      //   orderCustomerIDHistoryList = [];
      // } else {
      //   orderCustomerIDHistoryList = userData!['ออเดอร์วันนี้_ไอดีลูกค้า'];
      // }
      // print('check02');

      // print(orderIDHistoryList);
      // print(orderTimeHistoryList);
      // print(orderCustomerIDHistoryList);

      // for (int i = 0; i < orderTimeHistoryList.length; i++) {
      //   Timestamp timestamp = orderTimeHistoryList[i];
      //   DateTime dateTime = timestamp.toDate();

      //   DateTime now = DateTime.now();

      //   if (dateTime.year == now.year &&
      //       dateTime.month == now.month &&
      //       dateTime.day == now.day) {
      //   } else {
      //     orderIDHistoryList[i] = '';

      //     orderTimeHistoryList[i] = 'ไม่มีเวลา';
      //     orderCustomerIDHistoryList[i] = '';
      //   }
      // }
      // print('check03');

      // print(orderIDHistoryList);
      // print(orderTimeHistoryList);
      // print(orderCustomerIDHistoryList);

      // orderIDHistoryList
      //     .removeWhere((element) => element! == null || element!.isEmpty);

      // print('a');

      // orderTimeHistoryList.removeWhere((element) => element! == 'ไม่มีเวลา');
      // // orderTimeHistoryList.removeWhere((element) {
      // //   print(element);

      // //   return element! == 'ไม่มีเวลา';
      // // });
      // print('b');

      // orderCustomerIDHistoryList
      //     .removeWhere((element) => element! == null || element!.isEmpty);
      // print('c');

      // print('check04');
      // print(orderIDHistoryList.length);
      // print(orderTimeHistoryList.length);
      // print(orderCustomerIDHistoryList.length);

      // userData!['ออเดอร์วันนี้'] = orderIDHistoryList;

      // userData!['ออเดอร์วันนี้_วันที่'] = orderTimeHistoryList;

      // userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] = orderCustomerIDHistoryList;
      // print('check05');

      // await FirebaseFirestore.instance
      //     .collection('User')
      //     .doc(userData!['UserID'])
      //     .update(
      //   {
      //     'ออเดอร์วันนี้': orderIDHistoryList,
      //     'ออเดอร์วันนี้_วันที่': orderTimeHistoryList,
      //     'ออเดอร์วันนี้_ไอดีลูกค้า': orderCustomerIDHistoryList,
      //   },
      // ).then((value) {
      //   // if (mounted) {
      //   // setState(() {});
      //   // }
      // });

      // print('check error');

      // for (int i = 0; i < orderIDHistoryList.length; i++) {
      //   print(i);
      //   CollectionReference subCollectionRefOrder = FirebaseFirestore.instance
      //       .collection(AppSettings.customerType == CustomerType.Test
      //           ? 'CustomerTest/${orderCustomerIDHistoryList[i]}/Orders'
      //           : 'Customer/${orderCustomerIDHistoryList[i]}/Orders');

      //   QuerySnapshot subCollectionSnapshotOrder =
      //       await subCollectionRefOrder.get();

      //   if (subCollectionSnapshotOrder.docs.length == 0) {
      //     mapDataOrdersData!.add({});
      //   } else {
      //     subCollectionSnapshotOrder.docs.forEach((doc) {
      //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      //       if (data['OrdersDateID'] == null) {
      //         mapDataOrdersData!.add({});
      //       } else {
      //         if (orderIDHistoryList[i] == data['OrdersDateID']) {
      //           mapDataOrdersData!.add(data);
      //           print('-------------------------');
      //           mapDataOrdersData!.last!['CustomerID'] =
      //               orderCustomerIDHistoryList[i];
      //           print(mapDataOrdersData!.last);
      //         } else {
      //           mapDataOrdersData!.add({});
      //         }
      //       }
      //     });
      //   }
      // }

      mapDataOrdersData = widget.listOrders;

      //==============================================================
      CollectionReference sectionID2ListColection =
          FirebaseFirestore.instance.collection('Section');

      QuerySnapshot sectionID2ListSubCollections =
          await sectionID2ListColection.get();

      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      sectionID2ListSubCollections.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        sectionID2List!.add(data);
        // print('------------');
        // print(data);
        // print('------------');
      });

      for (int i = 0; i < mapDataOrdersData!.length; i++) {
        Map<String, dynamic>? dataSectionMatch = sectionID2List!.firstWhere(
            (element) =>
                element!['ID'] == mapDataOrdersData![i]!['SectionID2']);

        mapDataOrdersData![i]!['SectionID2'] = dataSectionMatch!['Name'];

        print(mapDataOrdersData![i]!['SectionID2']);
      }

      print('======== 5 ========');
      print(mapDataOrdersData!.length);

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
    print(desiredMonth);
    // กรองข้อมูลเฉพาะเดือนที่ต้องการ
    return orders?.where((order) {
      Timestamp orderTime = order?['OrdersUpdateTime'] as Timestamp;
      String orderMonth = orderTime
          .toDate()
          .month
          .toString()
          .padLeft(2, '0'); // แปลงให้มี 2 หลัก

      print(orderMonth);
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
    print('This is A160401 search history');
    // print(widget.customerID);
    print('==============================');

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
                            Expanded(
                              child: Container(
                                // height: 20.0,
                                decoration: const BoxDecoration(),
                                child: Column(
                                  children: [
                                    Container(
                                      // color: Colors.amber,
                                      // width: 225,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(3.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          widget.checkTeam!
                                              ? 'ข้อมูลการค้นหาออเดอร์ที่เปิดแทน'
                                              : 'ข้อมูลการค้นหา',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                  fontSize: 20,
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: mapDataOrdersData!.length == 0
                                          ? 50
                                          : 5,
                                    ),
                                    mapDataOrdersData!.length == 0
                                        ? Text(
                                            'วันนี้ยังไม่มีคำสั่งขายค่ะ!!',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                    fontSize: 14,
                                                    fontFamily: 'Kanit',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontWeight:
                                                        FontWeight.w800),
                                          )
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: (56 *
                                                    mapDataOrdersData!.length) +
                                                60,
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: DataTable2(
                                                  border: TableBorder.all(
                                                      width: 0.2),
                                                  columnSpacing: 12,
                                                  horizontalMargin: 12,
                                                  minWidth: 600,
                                                  columns: [
                                                    DataColumn2(
                                                        label: Text(
                                                          'ลำดับ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                        // size: ColumnSize.L,
                                                        fixedWidth: 50),
                                                    DataColumn2(
                                                        label: Text(
                                                          '   รหัสลูกค้า',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                        // size: ColumnSize.L,
                                                        fixedWidth: 100),
                                                    DataColumn2(
                                                        label: Text(
                                                          '   ชื่อลูกค้า',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                        // size: ColumnSize.L,
                                                        fixedWidth: 150),
                                                    DataColumn2(
                                                        label: Text(
                                                          '         Sale Order',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                        // size: ColumnSize.L,
                                                        fixedWidth: 150),
                                                    DataColumn2(
                                                        label: Text(
                                                          '  เวลาเปิดใบสั่งขาย',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                        // size: ColumnSize.L,
                                                        fixedWidth: 100),
                                                    DataColumn2(
                                                        label: Text(
                                                          '   ยอดเงิน',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                        // size: ColumnSize.L,
                                                        fixedWidth: 75),
                                                    DataColumn2(
                                                        label: Text(
                                                          '  ติดตามสถานะ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                        // size: ColumnSize.L,
                                                        fixedWidth: 100),
                                                  ],
                                                  rows: List<DataRow>.generate(
                                                      mapDataOrdersData!.length,
                                                      (index) => DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Text(
                                                                    '    ${(index + 1).toString()}',
                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                    '  ${mapDataOrdersData![index]!['CustomerDoc']['ClientIdจากMfoodAPI']}',

                                                                    // '  ${mapDataOrdersData![index]!['CustomerDoc']['CustomerID']}',
                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                    '  ${mapDataOrdersData![index]!['CustomerDoc']['ประเภทลูกค้า'] == 'Company' ? mapDataOrdersData![index]!['CustomerDoc']['ชื่อบริษัท'] : mapDataOrdersData![index]!['CustomerDoc']['ชื่อนามสกุล'] == ' ' ? '${mapDataOrdersData![index]!['CustomerDoc']['ชื่อ']} ${mapDataOrdersData![index]!['CustomerDoc']['นามสกุล']}' : mapDataOrdersData![index]!['CustomerDoc']['ชื่อนามสกุล']}',

                                                                    // '  ${mapDataOrdersData![index]!['CustomerDoc']['ชื่อนามสกุล']}',
                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                        fontSize:
                                                                            10,
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                    '${mapDataOrdersData![index]!['SALE_ORDER_ID_REF'] == null ? 'รอดำเนินการ' : mapDataOrdersData![index]!['SALE_ORDER_ID_REF']}',
                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                        fontSize:
                                                                            10,
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                    '${DateFormat("dd-MM-yyyy \nเวลา HH:mm:ss น.").format(DateTime.parse(mapDataOrdersData![index]!['OrdersDateID']))}',
                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                    '    ${double.parse(mapDataOrdersData![index]!['มูลค่าสินค้ารวม'].toString()).toStringAsFixed(2)}',
                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          CupertinoPageRoute(
                                                                            builder: (context) =>
                                                                                A1603OrderDetail(
                                                                              customerID: mapDataOrdersData![index]['CustomerDoc']['CustomerID'],
                                                                              orderDataMap: mapDataOrdersData![index],
                                                                              checkTeam: widget.checkTeam,
                                                                            ),
                                                                          ));
                                                                    },
                                                                    child: Text(
                                                                      mapDataOrdersData![index]!['ชำระเงินแล้ว'] !=
                                                                              null
                                                                          ? mapDataOrdersData![index]!['ชำระเงินแล้ว'] != '' && mapDataOrdersData![index]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                              ? mapDataOrdersData![index]!['ชำระเงินแล้ว']
                                                                              : mapDataOrdersData![index]!['SectionID2'] != null && mapDataOrdersData![index]!['SectionID2'] != ''
                                                                                  ? mapDataOrdersData![index]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                      ? 'รอดำเนินการ'
                                                                                      : mapDataOrdersData![index]!['SectionID2']
                                                                                  : mapDataOrdersData![index]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                      ? 'รอดำเนินการ'
                                                                                      : mapDataOrdersData![index]!['สถานะอนุมัติขาย'] != true
                                                                                          ? 'รอดำเนินการ'
                                                                                          : 'รอดำเนินการ'
                                                                          : mapDataOrdersData![index]!['SectionID2'] != null && mapDataOrdersData![index]!['SectionID2'] != ''
                                                                              ? mapDataOrdersData![index]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                  ? 'รอดำเนินการ'
                                                                                  : mapDataOrdersData![index]!['SectionID2']
                                                                              : mapDataOrdersData![index]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                  ? 'รอดำเนินการ'
                                                                                  : mapDataOrdersData![index]!['สถานะอนุมัติขาย'] != true
                                                                                      ? 'รอดำเนินการ'
                                                                                      : 'รอดำเนินการ',

                                                                      // '    ${mapDataOrdersData![index]!['สถานะเช็คสต็อก'] == 'ปกติ' ? 'ดำเนินการแล้ว' : 'รอดำเนินการ'}',
                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color: mapDataOrdersData![index]!['SectionID2'] == 'ชำระเงินแล้ว' || mapDataOrdersData![index]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                              ? Colors.green.shade700
                                                                              : Colors.yellow.shade900,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]))),
                                            )),
                                    mapDataOrdersData!.isEmpty
                                        ? SizedBox(
                                            height: 50,
                                          )
                                        : SizedBox(
                                            height: 0,
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
