import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a08_customer_rating_group/a0803_customer_order_table.dart';
import 'package:m_food/a09_customer_open_sale/a09020_product_history_detail.dart';
import 'package:m_food/a09_customer_open_sale/a09021_address_setting.dart';
import 'package:m_food/a09_customer_open_sale/a0903_product_screen.dart';
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

class A0902CustomerHistoryList extends StatefulWidget {
  final String? customerID;
  const A0902CustomerHistoryList({super.key, this.customerID});

  @override
  _A0902CustomerHistoryListState createState() =>
      _A0902CustomerHistoryListState();
}

class _A0902CustomerHistoryListState extends State<A0902CustomerHistoryList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  RxMap<String, dynamic>? customerData;
  List<Map<String, dynamic>?>? mapDataOrdersData = [];

  List<Map<String, dynamic>?>? orderListStatename = [];

  List<Map<String, dynamic>?>? sectionID2List = [];

  Map<String, dynamic>? customerDataWithID;

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

      //==============================================================
      // ดึงข้อมูลจาก collection 'Customer'
      DocumentSnapshot customerDoc = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'CustomerTest'
              : 'Customer')
          .doc(widget.customerID)
          .get();

      print('customerid');
      print(widget.customerID);

      if (customerDoc.exists) {
        customerDataWithID = customerDoc.data() as Map<String, dynamic>?;

        // // Get current date
        // DateTime now = DateTime.now();

        // // Calculate the date 4 months ago
        // DateTime fourMonthsAgo = DateTime(now.year, now.month - 4, now.day);

        // // Convert to Timestamp for Firestore
        // Timestamp fourMonthsAgoTimestamp = Timestamp.fromDate(fourMonthsAgo);

        // CollectionReference subCollectionRef = FirebaseFirestore.instance
        //     .collection(AppSettings.customerType == CustomerType.Test
        //         ? 'CustomerTest/${widget.customerID}/Orders'
        //         : 'Customer/${widget.customerID}/Orders');

        // QuerySnapshot subCollectionSnapshot = await subCollectionRef
        //     .where('OrdersUpdateTime',
        //         isGreaterThanOrEqualTo: fourMonthsAgoTimestamp)
        //     .get();

        CollectionReference subCollectionRef = FirebaseFirestore.instance
            .collection(AppSettings.customerType == CustomerType.Test
                ? 'CustomerTest/${widget.customerID}/Orders'
                : 'Customer/${widget.customerID}/Orders');

        QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

        subCollectionSnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          mapDataOrdersData!.add(data);
        });

        mapDataOrdersData = (mapDataOrdersData ?? [])
            .where((map) => map != null)
            .cast<Map<String, dynamic>>()
            .toList();

        print(mapDataOrdersData);
      } else {
        // mapDataOrdersData = [];
        print('ไม่พบเอกสารที่มี ID เป็น "124"');
      }

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

      print('3');

      //==============================================================
      CollectionReference orderColection = FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'OrdersTest'
              : 'Orders');
      // FirebaseFirestore.instance.collection('OrdersTest');

      QuerySnapshot orderSubCollections =
          await orderColection.where('CustomerDocId', isEqualTo: widget.customerID).get();

      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      orderSubCollections.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        orderListStatename!.add(data);
        // print('------------');
        // print(data);
        // print('------------');
      });

      print('33');

      orderListStatename = (orderListStatename ?? [])
          .where((map) => map != null)
          .cast<Map<String, dynamic>>()
          .toList();

      orderListStatename!.removeWhere(
          (element) => element!['CustomerDocId'] != widget.customerID);

      // print('------------');

      // for (var element in orderListStatename!) {
      //   print(element!['StateName']);
      // }
      // print(orderListStatename!.length);
      // print('------------');

      //==============================================================

      print('ทดสอบ1');

      for (int i = 0; i < mapDataOrdersData!.length; i++) {
        bool check = orderListStatename!.any((element) =>
            element!['OrdersDateID'] == mapDataOrdersData![i]!['OrdersDateID']);

        print(i);
        if (check) {
          print(check);
          Map<String, dynamic>? dataMatch = orderListStatename!.firstWhere(
              (element) =>
                  element!['OrdersDateID'] ==
                  mapDataOrdersData![i]!['OrdersDateID']);

          Map<String, dynamic>? dataSectionMatch = sectionID2List!.firstWhere(
              (element) => element!['ID'] == dataMatch!['SectionID2']);

          mapDataOrdersData![i]!['ชำระเงินแล้ว'] = dataMatch!['ชำระเงินแล้ว'];
          mapDataOrdersData![i]!['SectionID2'] = dataSectionMatch!['Name'];

          print(mapDataOrdersData![i]!['SectionID2']);
        } else {
          print(check);
          print(mapDataOrdersData![i]!['SectionID2']);
          mapDataOrdersData![i]!['SectionID2'] = 'รอดำเนินการ';
          // mapDataOrdersData![i]!['SectionID2'] = null;
        }
      }

      print('ทดสอบ2');

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
      print(desiredMonth);

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
    print('This is A0902 customer history open list');
    print(widget.customerID);
    print('==============================');
    userData = userController.userData;
    customerData = customerController.customerData;

    // ดึงเดือนปัจจุบัน
    DateTime currentDate = DateTime.now();
    // print('Current Month in Thai: ${formatThaiMonth(currentDate.month)}');

    // ดึงเดือนย้อนหลัง 3 เดือน
    // DateTime threeMonthsAgo = currentDate.subtract(Duration(days: 60));
    // print('Three Months Ago in Thai: ${formatThaiMonth(threeMonthsAgo.month)}');
    // DateTime twoMonthsAgo = currentDate.subtract(Duration(days: 30));
    // print('Three Months Ago in Thai: ${formatThaiMonth(twoMonthsAgo.month)}');
    DateTime oneMonthsAgo = currentDate.subtract(Duration(days: 0));
    print('bb');

    // ย้อนหลัง 1 เดือน
    DateTime twoMonthsAgo =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

    // ย้อนหลัง 2 เดือน
    DateTime threeMonthsAgo =
        DateTime(currentDate.year, currentDate.month - 2, currentDate.day);
    // print(
    // 'Three Months Ago in Thai: ${formatThaiMonth(oneMonthsAgo.month)} ${oneMonthsAgo.year + 543}');

    print('bbb');

    print(mapDataOrdersData);

    sortOrdersByUpdateTime(mapDataOrdersData);
    // print(mapDataOrdersData!.length);
    print('bbbb');

    List<Map<String, dynamic>?>? mapDataOne =
        filterOrdersByMonth(mapDataOrdersData, oneMonthsAgo.month.toString());
    List<Map<String, dynamic>?>? mapDataTwo =
        filterOrdersByMonth(mapDataOrdersData, twoMonthsAgo.month.toString());
    List<Map<String, dynamic>?>? mapDataThree =
        filterOrdersByMonth(mapDataOrdersData, threeMonthsAgo.month.toString());
    print('bbbbb');

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
            : Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    10.0, 10.0, 10.0, 10.0),
                child: SingleChildScrollView(
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //================= เปิดใบสั่งขายสินค้า ======================
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        print('ไปอีกหน้า ${widget.customerID}');
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  A09021AddressSetting(
                                                customerID: widget.customerID,
                                                orderDataMap: {},
                                              ),
                                            ));

                                        print('ไปได้');
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                            child: Icon(
                                              FFIcons.kfileDocumentPlus,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              size: 24.0,
                                            ),
                                          ),
                                          Text(
                                            'เปิดใบสั่งขายสินค้า',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                          child: Icon(
                                            Icons
                                                .perm_contact_calendar_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            size: 24.0,
                                          ),
                                        ),
                                        Text(
                                          customerDataWithID![
                                              'ClientIdจากMfoodAPI'],
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
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          customerDataWithID!['ประเภทลูกค้า'] ==
                                                  'Company'
                                              ? customerDataWithID![
                                                  'ชื่อบริษัท']
                                              : customerDataWithID![
                                                  'ชื่อนามสกุล'],
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
                                    //========================== ประวัติย้อนหลัง 3 เดือน ===================
                                    const SizedBox(height: 10),

                                    Column(
                                      children: [
                                        for (int i = 0; i < 3; i++)
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
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          constraints:
                                                              const BoxConstraints(
                                                            maxWidth: 570.0,
                                                          ),
                                                          decoration:
                                                              const BoxDecoration(),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
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
                                                                    Container(
                                                                      width:
                                                                          10.0,
                                                                      height:
                                                                          10.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            3.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          i == 0
                                                                              ? '${formatThaiMonth(oneMonthsAgo.month)} ${oneMonthsAgo.year + 543}'
                                                                              : i == 1
                                                                                  ? '${formatThaiMonth(twoMonthsAgo.month)} ${twoMonthsAgo.year + 543}'
                                                                                  : '${formatThaiMonth(threeMonthsAgo.month)} ${threeMonthsAgo.year + 543}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily: 'Kanit',
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                fontWeight: FontWeight.w500,
                                                                                lineHeight: 0.9,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // 1 เดือน ย้อนหลัง รายละเอียด
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        6.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                child:
                                                                    Container(
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
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        for (int j =
                                                                                0;
                                                                            j <
                                                                                (i == 0
                                                                                    ? mapDataOne!.length
                                                                                    : i == 1
                                                                                        ? mapDataTwo!.length
                                                                                        : mapDataThree!.length);
                                                                            j++)
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
                                                                                      builder: (context) => A09020ProductHistoryDetail(
                                                                                          customerID: widget.customerID,
                                                                                          orderDataMap: i == 0
                                                                                              ? mapDataOne![j]
                                                                                              : i == 1
                                                                                                  ? mapDataTwo![j]
                                                                                                  : mapDataThree![j]),
                                                                                    ));
                                                                                // Navigator.push(
                                                                                //     context,
                                                                                //     CupertinoPageRoute(
                                                                                //       builder: (context) => A09021AddressSetting(
                                                                                //           customerID: widget.customerID,
                                                                                //           orderDataMap: i == 0
                                                                                //               ? mapDataOne[j]
                                                                                //               : i == 1
                                                                                //                   ? mapDataTwo[j]
                                                                                //                   : mapDataThree[j]),
                                                                                //     ));
                                                                              },
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: 100.0,
                                                                                          child: VerticalDivider(
                                                                                            width: 3.0,
                                                                                            thickness: 1.0,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                // color: Colors.amber,
                                                                                                width: 225,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                                  child: Text(
                                                                                                    i == 0
                                                                                                        ? mapDataOne![j]!['OrdersDateID']
                                                                                                        : i == 1
                                                                                                            ? mapDataTwo![j]!['OrdersDateID']
                                                                                                            : mapDataThree![j]!['OrdersDateID'],
                                                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                          fontFamily: 'Kanit',
                                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        flex: 2,
                                                                                                        child: Text(
                                                                                                          i == 0
                                                                                                              ? customFormatThai(mapDataOne![j]!['วันเวลาจัดส่ง'].toDate())
                                                                                                              : i == 1
                                                                                                                  ? customFormatThai(mapDataTwo![j]!['วันเวลาจัดส่ง'].toDate())
                                                                                                                  : customFormatThai(mapDataThree![j]!['วันเวลาจัดส่ง'].toDate()),
                                                                                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                                fontFamily: 'Kanit',
                                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Expanded(
                                                                                                        flex: 1,
                                                                                                        child: Container(
                                                                                                          // color: Colors.red,
                                                                                                          child: Row(
                                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                i == 0
                                                                                                                    ? mapDataOne![j]!['ชำระเงินแล้ว'] != null
                                                                                                                        ? mapDataOne![j]!['ชำระเงินแล้ว'] != '' && mapDataOne![j]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                                                                            ? mapDataOne![j]!['ชำระเงินแล้ว']
                                                                                                                            : mapDataOne![j]!['SectionID2'] != null && mapDataOne![j]!['SectionID2'] != ''
                                                                                                                                ? mapDataOne![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                    ? 'รอดำเนินการ'
                                                                                                                                    : mapDataOne![j]!['SectionID2']
                                                                                                                                : mapDataOne![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                    ? 'รอดำเนินการ'
                                                                                                                                    : mapDataOne![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                        ? 'รอดำเนินการ'
                                                                                                                                        : 'รอดำเนินการ'
                                                                                                                        : mapDataOne![j]!['SectionID2'] != null && mapDataOne![j]!['SectionID2'] != ''
                                                                                                                            ? mapDataOne![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                ? 'รอดำเนินการ'
                                                                                                                                : mapDataOne![j]!['SectionID2']
                                                                                                                            : mapDataOne![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                ? 'รอดำเนินการ'
                                                                                                                                : mapDataOne![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                    ? 'รอดำเนินการ'
                                                                                                                                    : 'รอดำเนินการ'
                                                                                                                    : i == 1
                                                                                                                        ? mapDataTwo![j]!['ชำระเงินแล้ว'] != null
                                                                                                                            ? mapDataTwo![j]!['ชำระเงินแล้ว'] != '' && mapDataTwo![j]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                                                                                ? mapDataTwo![j]!['ชำระเงินแล้ว']
                                                                                                                                : mapDataTwo![j]!['SectionID2'] != null && mapDataTwo![j]!['SectionID2'] != ''
                                                                                                                                    ? mapDataTwo![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                        ? 'รอดำเนินการ'
                                                                                                                                        : mapDataTwo![j]!['SectionID2']
                                                                                                                                    : mapDataTwo![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                        ? 'รอดำเนินการ'
                                                                                                                                        : mapDataTwo![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                            ? 'รอดำเนินการ'
                                                                                                                                            : 'รอดำเนินการ'
                                                                                                                            : mapDataTwo![j]!['SectionID2'] != null && mapDataTwo![j]!['SectionID2'] != ''
                                                                                                                                ? mapDataTwo![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                    ? 'รอดำเนินการ'
                                                                                                                                    : mapDataTwo![j]!['SectionID2']
                                                                                                                                : mapDataTwo![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                    ? 'รอดำเนินการ'
                                                                                                                                    : mapDataTwo![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                        ? 'รอดำเนินการ'
                                                                                                                                        : 'รอดำเนินการ'
                                                                                                                        // ? mapDataTwo[j]!['สถานะเช็คสต็อก'] ?? ''
                                                                                                                        : mapDataThree![j]!['ชำระเงินแล้ว'] != null
                                                                                                                            ? mapDataThree![j]!['ชำระเงินแล้ว'] != '' && mapDataThree![j]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                                                                                ? mapDataThree![j]!['ชำระเงินแล้ว']
                                                                                                                                : mapDataThree![j]!['SectionID2'] != null && mapDataThree![j]!['SectionID2'] != ''
                                                                                                                                    ? mapDataThree![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                        ? 'รอดำเนินการ'
                                                                                                                                        : mapDataThree![j]!['SectionID2']
                                                                                                                                    : mapDataThree![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                        ? 'รอดำเนินการ'
                                                                                                                                        : mapDataThree![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                            ? 'รอดำเนินการ'
                                                                                                                                            : 'รอดำเนินการ'
                                                                                                                            : mapDataThree![j]!['SectionID2'] != null && mapDataThree![j]!['SectionID2'] != ''
                                                                                                                                ? mapDataThree![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                    ? 'รอดำเนินการ'
                                                                                                                                    : mapDataThree![j]!['SectionID2']
                                                                                                                                : mapDataThree![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                    ? 'รอดำเนินการ'
                                                                                                                                    : mapDataThree![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                        ? 'รอดำเนินการ'
                                                                                                                                        : 'รอดำเนินการ',
                                                                                                                // : mapDataThree[j]!['สถานะเช็คสต็อก'] ?? '',
                                                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                                      fontFamily: 'Kanit',
                                                                                                                      color: i == 0
                                                                                                                          ? mapDataOne![j]!['ชำระเงินแล้ว'] != null
                                                                                                                              ? mapDataOne![j]!['ชำระเงินแล้ว'] != '' && mapDataOne![j]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                                                                                  ? Colors.green.shade700
                                                                                                                                  : Colors.yellow.shade900
                                                                                                                              : mapDataOne![j]!['SectionID2'] != null && mapDataOne![j]!['SectionID2'] != ''
                                                                                                                                  ? mapDataOne![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                      ? Colors.yellow.shade700
                                                                                                                                      : Colors.yellow.shade900
                                                                                                                                  : mapDataOne![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                      ? Colors.yellow.shade700
                                                                                                                                      : mapDataOne![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                          ? Colors.yellow.shade700
                                                                                                                                          : Colors.yellow.shade900
                                                                                                                          : i == 1
                                                                                                                              ? mapDataTwo![j]!['ชำระเงินแล้ว'] != null
                                                                                                                                  ? mapDataTwo![j]!['ชำระเงินแล้ว'] != '' && mapDataTwo![j]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                                                                                      ? Colors.green.shade700
                                                                                                                                      : Colors.yellow.shade900
                                                                                                                                  : mapDataTwo![j]!['SectionID2'] != null && mapDataTwo![j]!['SectionID2'] != ''
                                                                                                                                      ? mapDataTwo![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                          ? Colors.yellow.shade700
                                                                                                                                          : Colors.yellow.shade900
                                                                                                                                      : mapDataTwo![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                          ? Colors.yellow.shade700
                                                                                                                                          : mapDataTwo![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                              ? Colors.yellow.shade700
                                                                                                                                              : Colors.yellow.shade900
                                                                                                                              // ? mapDataTwo[j]!['สถานะเช็คสต็อก'] ?? ''
                                                                                                                              : mapDataThree![j]!['ชำระเงินแล้ว'] != null
                                                                                                                                  ? mapDataThree![j]!['ชำระเงินแล้ว'] != '' && mapDataThree![j]!['ชำระเงินแล้ว'] == 'ชำระเงินแล้ว'
                                                                                                                                      ? Colors.green.shade700
                                                                                                                                      : Colors.yellow.shade900
                                                                                                                                  : mapDataThree![j]!['SectionID2'] != null && mapDataThree![j]!['SectionID2'] != ''
                                                                                                                                      ? mapDataThree![j]!['SectionID2'] == 'ออร์เดอร์ไม่สมบูรณ์'
                                                                                                                                          ? Colors.yellow.shade700
                                                                                                                                          : Colors.yellow.shade900
                                                                                                                                      : mapDataThree![j]!['สถานะเช็คสต็อก'] != 'ปกติ'
                                                                                                                                          ? Colors.yellow.shade700
                                                                                                                                          : mapDataThree![j]!['สถานะอนุมัติขาย'] != true
                                                                                                                                              ? Colors.yellow.shade700
                                                                                                                                              : Colors.yellow.shade900,
                                                                                                                    ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      // Expanded(
                                                                                                      //   flex: 1,
                                                                                                      //   child: Text(
                                                                                                      //     i == 0
                                                                                                      //         ? mapDataOne[j]!['สถานะค้างชำระ'] == true
                                                                                                      //             ? 'ค้างชำระ'
                                                                                                      //             : ''
                                                                                                      //         : i == 1
                                                                                                      //             ? mapDataTwo[j]!['สถานะค้างชำระ'] == true
                                                                                                      //                 ? 'ค้างชำระ'
                                                                                                      //                 : ''
                                                                                                      //             : mapDataThree[j]!['สถานะค้างชำระ'] == true
                                                                                                      //                 ? 'ค้างชำระ'
                                                                                                      //                 : '',
                                                                                                      //     style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                      //           fontFamily: 'Kanit',
                                                                                                      //           color: FlutterFlowTheme.of(context).primaryText,
                                                                                                      //         ),
                                                                                                      //   ),
                                                                                                      // ),
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
                                                                                  Container(
                                                                                    width: 150,
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: Text(
                                                                                      i == 0
                                                                                          ? NumberFormat('#,###').format(mapDataOne![j]!['ยอดรวม']).toString() + ' บาท'
                                                                                          : i == 1
                                                                                              ? NumberFormat('#,###').format(mapDataTwo![j]!['ยอดรวม']).toString() + ' บาท'
                                                                                              : NumberFormat('#,###').format(mapDataThree![j]!['ยอดรวม']).toString() + ' บาท',
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            fontFamily: 'Kanit',
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ].addToEnd(
                                                                              const SizedBox(height: 20.0)),
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
