import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a01_home/a01_05_dashboard/a0105_dashboard_widget_0707.dart';
import 'package:m_food/a07_account_customer/a07_01_open_account/a070101_pdpa_account_widget.dart';
import 'package:m_food/a09_customer_open_sale/a0901_customer_list.dart';
import 'package:m_food/a09_customer_open_sale/a0902_customer_history_list.dart';
import 'package:m_food/a16_wait_order/a06001_customer_history_today.dart';
import 'package:m_food/a16_wait_order/a1601_customer_wait_order.dart';
import 'package:m_food/a16_wait_order/a1604_search_order.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/user_controller.dart';
import '/components/appbar_o_pen_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/components/open_accout_for_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A1600CustomerChoose extends StatefulWidget {
  final String? status;
  final String? id;

  const A1600CustomerChoose({
    this.status,
    this.id,
    Key? key,
  }) : super(key: key);

  @override
  _A1600CustomerChooseState createState() => _A1600CustomerChooseState();
}

class _A1600CustomerChooseState extends State<A1600CustomerChoose> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  RxMap<String, dynamic>? customerData;

  bool isLoading = false;

  List<Map<String, dynamic>?>? orderList = [];
  List<Map<String, dynamic>>? orderListTosend = [];

  List<Map<String, dynamic>?>? orderListTeam = [];
  List<Map<String, dynamic>>? orderListTosendTeam = [];

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

      print(widget.id);
      print(widget.id);
      print(widget.id);
      print(widget.id);
      print(widget.id);
      print(widget.id);
      print(widget.id);
      print(widget.id);
      print(widget.id);

      //==============================================================
      // CollectionReference orderColection =
      //     FirebaseFirestore.instance.collection('OrdersTest');

      QuerySnapshot orderSubCollections = await FirebaseFirestore.instance
          // .collection('OrdersTest')
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'OrdersTest'
              : 'Orders')
          .where('UserDocId', isEqualTo: widget.id)
          .get();

      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      orderSubCollections.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        orderList!.add(data);
        orderListTosend!.add(data);
        // print('------------');
        // print(data);
        // print('------------');
      });

      QuerySnapshot orderSubCollectionsTeam = await FirebaseFirestore.instance
          // .collection('OrdersTest')
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'OrdersTest'
              : 'Orders')
          .where('idผู้เปิดออเดอร์แทน', isEqualTo: widget.id)
          .get();

      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      orderSubCollectionsTeam.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        orderListTeam!.add(data);
        orderListTosendTeam!.add(data);
        // print('------------');
        // print(data);
        // print('------------');
      });

      print(orderList!.length);
      // // ดึงข้อมูลจาก collection 'Customer'
      // DocumentSnapshot customerDoc = await FirebaseFirestore.instance
      //     .collection(AppSettings.customerType == CustomerType.Test
      //         ? 'CustomerTest'
      //         : 'Customer')
      //     .doc(widget.customerID)
      //     .get();

      // print('customerid');
      // print(widget.customerID);

      // // ตรวจสอบว่าเอกสาร '124' มี subcollection 'นพกำพห' หรือไม่
      // if (customerDoc.exists) {
      //   customerDataWithID = customerDoc.data() as Map<String, dynamic>?;

      //   CollectionReference subCollectionRef = FirebaseFirestore.instance
      //       .collection(AppSettings.customerType == CustomerType.Test
      //           ? 'CustomerTest/${widget.customerID}/Orders'
      //           : 'Customer/${widget.customerID}/Orders');

      //   // ดึงข้อมูลจาก subcollection 'นพกำพห'
      //   QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

      //   // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      //   subCollectionSnapshot.docs.forEach((doc) {
      //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      //     mapDataOrdersData!.add(data);
      //   });

      //   mapDataOrdersData = (mapDataOrdersData ?? [])
      //       .where((map) => map != null)
      //       .cast<Map<String, dynamic>>()
      //       .toList();

      //   print(mapDataOrdersData);
      // } else {
      //   print('ไม่พบเอกสารที่มี ID เป็น "124"');
      // }
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

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A1600 Customer Choose');
    print('==============================');
    userData = userController.userData;

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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoading
            ? CircularLoadingHome()
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 10.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  // context.safePop();
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(
                                                  Icons.chevron_left,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 10.0, 0.0),
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
                                                  // context.pushNamed('A01_01_Home');
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
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
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            userData!.isNotEmpty
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        '${userData!['Name']} ${userData!['Surname']}',
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
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'สมัครสมาชิกที่นี่',
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
                                                    ],
                                                  ),
                                            userData!.isNotEmpty
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'ล็อกอินเข้าสู่ระบบ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        userData!.isNotEmpty
                                            ? Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
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
                                                    Navigator.pop(context);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    maxRadius: 20,
                                                    // radius: 1,
                                                    backgroundImage: userData![
                                                                'Img'] ==
                                                            ''
                                                        ? null
                                                        : NetworkImage(
                                                            userData!['Img']),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        // saveDataForLogout();
                                                      },
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        color:
                                                            FlutterFlowTheme.of(
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Padding(
                            //     padding:
                            //         EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                            //     child: Column(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: [
                            //         Padding(
                            //           padding: EdgeInsetsDirectional.fromSTEB(
                            //               0.0, 0.0, 0.0, 20.0),
                            //           child: MenuSidebarWidget(),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            // context.pushNamed('A07_03_UserGeneral');

                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      A06001CustomerHistoryToday(
                                                    dataOrderList: orderList,
                                                    dataOrderListTeam:
                                                        orderListTeam,
                                                  ),
                                                ));

                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    5.0,
                                                                    0.0),
                                                        child: Icon(
                                                          Icons
                                                              .account_box_rounded,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ประวัติการสินค้าวันนี้ทั้งหมด',
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
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.chevron_right_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                ],
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                InkWell(
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
                                                    //     'A07_06_UserLegalEntity');
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              A1601CustomerWaitOrder(
                                                            status:
                                                                widget.status,
                                                            dataOrderList:
                                                                orderList,
                                                            dataOrderListTeam:
                                                                orderListTeam,
                                                          ),
                                                        ));

                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                        child: Icon(
                                                          FFIcons.kaccountTie,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ประวัติการสั่งสินค้าทั้งหมด',
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.chevron_right_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                InkWell(
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
                                                    //     'A07_06_UserLegalEntity');
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              A1604SearchOrder(
                                                            status:
                                                                widget.status,
                                                            dataOrderList:
                                                                orderListTosend,
                                                            checkTeam: false,
                                                          ),
                                                        ));

                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                        child: Icon(
                                                          FFIcons
                                                              .kaccountSearchOutline,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ค้นหารายการสั่งซื้อ',
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.chevron_right_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                InkWell(
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
                                                    //     'A07_06_UserLegalEntity');
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              A1604SearchOrder(
                                                            status:
                                                                widget.status,
                                                            dataOrderList:
                                                                orderListTosendTeam,
                                                            checkTeam: true,
                                                          ),
                                                        ));

                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                        child: Icon(
                                                          FFIcons
                                                              .kaccountSearchOutline,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ค้นหารายการสั่งซื้อที่เปิดออเดอร์แทน',
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.chevron_right_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
