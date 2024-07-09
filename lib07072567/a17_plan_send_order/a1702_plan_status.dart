import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a09_customer_open_sale/a0905_success_order_product.dart';
import 'package:m_food/a09_customer_open_sale/widget/a0904_product_order_model.dart';
import 'package:m_food/a17_plan_send_order/widget/staus_plan_send.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/custom_text.dart';

import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';

class A1702PlanStatus extends StatefulWidget {
  final String? customerName;
  final String? customerID;
  final Map<String, dynamic>? orderDataMap;
  final DateTime? uniqueDateFinal;
  const A1702PlanStatus(
      {super.key,
      this.customerID,
      this.orderDataMap,
      this.customerName,
      this.uniqueDateFinal});

  @override
  _A1702PlanStatusState createState() => _A1702PlanStatusState();
}

class _A1702PlanStatusState extends State<A1702PlanStatus> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  // late A0904ProductOrderModel _model;

  final productController = Get.find<ProductController>();
  RxMap<String, dynamic>? productGetData;

  List<Map<String, dynamic>> resultList = [];

  late Map<String, dynamic> orderList;

  List<int> productCount = [];

  List<String> productImage = [];

  bool isLoading = false;

  @override
  void initState() {
    // _model = createModel(context, () => A0904ProductOrderModel());

    productGetData = productController.productData;

    List<Map<String, dynamic>> resultList = [];

    orderList = widget.orderDataMap!;

    print(orderList);

    if (productGetData != null) {
      productGetData!.forEach((key, value) {
        // print(value);/
        Map<String, dynamic> entry = value;
        resultList.add(entry);
        // print(entry);
      });
    }

    for (var key in orderList.keys) {
      var value = orderList[key];
      // print('Key: $key, Value: $value');
      if (key == 'ProductList') {
        for (var element in value) {
          Map<String, dynamic> productMatch = resultList.firstWhere(
              (elementProduct) => elementProduct['DocId'] == element['DocID']);

          // print(productMatch);
          if (productMatch.isNotEmpty) {
            print(productMatch['รูปภาพ'][0]);
            productImage.add(productMatch['รูปภาพ'][0]);
          }
        }
      }
      // ทำสิ่งที่คุณต้องการกับแต่ละ key และ value
    }

    for (var key in orderList.keys) {
      var value = orderList[key];
      // print('Key: $key, Value: $value');
      if (key == 'ProductList') {
        for (var element in value) {
          productCount.add(element['จำนวน']);
        }
      }
      // ทำสิ่งที่คุณต้องการกับแต่ละ key และ value
    }

    // print(productCount);

    super.initState();
  }

  @override
  void dispose() {
    // _model.dispose();
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

  void decrement(
      int index, int number, void Function(VoidCallback) setStateFunc) {
    int total = 0;
    if (productCount[index] > 0) {
      setStateFunc(() {
        productCount[index]--;
        orderList['ProductList'][index]['จำนวน'] = productCount[index];
      });
    }
    print(index);
    print(orderList['ProductList'][index]['จำนวน']);
    print(orderList['ยอดรวม']);

    for (var element in orderList['ProductList']) {
      int sumTotal = (element['จำนวน'] * element['ราคา']);

      total = total + sumTotal;
    }
    orderList['ยอดรวม'] = total;
    if (mounted) {
      setState(() {});
    }
  }

  void increment(
      int index, int number, void Function(VoidCallback) setStateFunc) {
    int total = 0;

    setStateFunc(() {
      productCount[index]++;
      orderList['ProductList'][index]['จำนวน'] = productCount[index];
    });
    print(index);
    print(orderList['ProductList'][index]['จำนวน']);
    print(orderList['ยอดรวม']);

    for (var element in orderList['ProductList']) {
      int sumTotal = (element['จำนวน'] * element['ราคา']);

      total = total + sumTotal;
    }

    orderList['ยอดรวม'] = total;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;

    print('==============================');
    print('This is A1702 Plan Status');
    print('==============================');

    print(widget.customerName);
    print(widget.customerID);
    print(widget.uniqueDateFinal);
    print(widget.orderDataMap!['OrdersDateID']);

    print(widget.orderDataMap!['ProductList'].length);
    // print(widget.orderDataMap);

    // for (int i = 0; i < widget.orderDataMap!['ProductList'].length; i++) {
    //   print(widget.orderDataMap!['ProductList'][i]);
    // }

    List<bool> listBool = [];
    for (var element in widget.orderDataMap!['ลำดับการจัดส่ง']) {
      print(element);
      listBool.add(element);
    }
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
            : Container(
                // color: Colors.red,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        10.0, 10.0, 10.0, 0.0),
                    child: Column(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 10.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              // context.safePop();
                                              Navigator.pop(context, orderList);
                                            },
                                            child: Icon(
                                              Icons.chevron_left,
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                  'รายละเอียดออเดอร์',
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
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    '${userData!['Name']} ${userData!['Surname']}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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

                        StatusPlanSend(checkBool: listBool, name: 
                          widget.orderDataMap!['หัวข้อลำดับการจัดส่ง']
                        ),

                        //============== Order List =====================================

                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Container(
                            // height: 4000,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .accent3
                                  .withOpacity(0.2),
                              // borderRadius: BorderRadius.circular(10.0),
                              // border: Border.all(
                              //   color: FlutterFlowTheme.of(context)
                              //       .secondaryText
                              //       .withOpacity(0.5),
                              // ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 10.0, 10.0, 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < orderList['ProductList'].length;
                                      i++)
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // color: Colors.green,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    10.0,
                                                                    10.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                productImage[i],
                                                                width: 65.0,
                                                                height: 65.0,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            orderList[
                                                                    'ProductList']
                                                                [
                                                                i]['ชื่อสินค้า'],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.3,
                                                            decoration:
                                                                const BoxDecoration(),
                                                            child: Text(
                                                              orderList['ProductList']
                                                                      [i][
                                                                  'คำอธิบายสินค้า'],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Kanit',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  orderList['ProductList'][i]
                                                          ['ราคาพิเศษ']
                                                      ? Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          10.0,
                                                                          4.0,
                                                                          10.0,
                                                                          4.0),
                                                                  child: Text(
                                                                    'สินค้าโปรโมชั่น',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium,
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox()
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Container(
                                                  // height: double.minPositive,
                                                  // color: Colors.red,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 20.0, 0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              // height: 32.0,
                                                              decoration: BoxDecoration(
                                                                  // borderRadius:
                                                                  //     BorderRadius
                                                                  //         .circular(
                                                                  //             8.0),
                                                                  // border:
                                                                  //     Border.all(
                                                                  //   color: FlutterFlowTheme.of(
                                                                  //           context)
                                                                  //       .accent2,
                                                                  //   width: 1.0,
                                                                  // ),
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  // Column(
                                                                  //   mainAxisSize:
                                                                  //       MainAxisSize
                                                                  //           .max,
                                                                  //   mainAxisAlignment:
                                                                  //       MainAxisAlignment
                                                                  //           .start,
                                                                  //   children: [
                                                                  //     Container(
                                                                  //       height: 30.0,
                                                                  //       decoration:
                                                                  //           BoxDecoration(
                                                                  //         borderRadius:
                                                                  //             BorderRadius.circular(
                                                                  //                 8.0),
                                                                  //         shape: BoxShape
                                                                  //             .rectangle,
                                                                  //       ),
                                                                  //       child:
                                                                  //           FlutterFlowCountController(
                                                                  //         decrementIconBuilder:
                                                                  //             (enabled) =>
                                                                  //                 FaIcon(
                                                                  //           FontAwesomeIcons
                                                                  //               .minus,
                                                                  //           color: enabled
                                                                  //               ? FlutterFlowTheme.of(context)
                                                                  //                   .secondaryText
                                                                  //               : FlutterFlowTheme.of(context)
                                                                  //                   .error,
                                                                  //           size:
                                                                  //               18.0,
                                                                  //         ),
                                                                  //         incrementIconBuilder:
                                                                  //             (enabled) =>
                                                                  //                 FaIcon(
                                                                  //           FontAwesomeIcons
                                                                  //               .plus,
                                                                  //           color: enabled
                                                                  //               ? FlutterFlowTheme.of(context)
                                                                  //                   .secondaryText
                                                                  //               : FlutterFlowTheme.of(context)
                                                                  //                   .error,
                                                                  //           size:
                                                                  //               18.0,
                                                                  //         ),
                                                                  //         countBuilder:
                                                                  //             (count) =>
                                                                  //                 Text(
                                                                  //           count
                                                                  //               .toString(),
                                                                  //           style: FlutterFlowTheme.of(
                                                                  //                   context)
                                                                  //               .bodyMedium
                                                                  //               .override(
                                                                  //                 fontFamily:
                                                                  //                     'Kanit',
                                                                  //                 fontSize:
                                                                  //                     14.0,
                                                                  //                 letterSpacing:
                                                                  //                     30.0,
                                                                  //               ),
                                                                  //         ),
                                                                  //         count: 0,
                                                                  //         updateCount:
                                                                  //             (count) =>
                                                                  //                 setState(() =>
                                                                  //                     0),
                                                                  //         stepSize: 1,
                                                                  //       ),
                                                                  //     ),
                                                                  //   ],
                                                                  // ),
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            30.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                        ),
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                setState) {
                                                                          return Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              // GestureDetector(
                                                                              //   onTap: () => decrement(
                                                                              //     i,
                                                                              //     productCount[i],
                                                                              //     setState,
                                                                              //   ),
                                                                              //   child: Container(
                                                                              //     padding: EdgeInsets.all(8),
                                                                              //     decoration: BoxDecoration(
                                                                              //         // shape: BoxShape.circle,
                                                                              //         // color: productCount[i] >
                                                                              //         //         0
                                                                              //         //     ? Theme.of(context)
                                                                              //         //         .primaryColor
                                                                              //         //     : Theme.of(context)
                                                                              //         //         .disabledColor,

                                                                              //         ),
                                                                              //     child: FaIcon(
                                                                              //       FontAwesomeIcons.minus,
                                                                              //       color: Colors.black,
                                                                              //       size: 12.0,
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
                                                                              Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 3),
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.rectangle,
                                                                                  // color: Theme.of(context).disabledColor.withOpacity(0.2),
                                                                                ),
                                                                                child: Text(
                                                                                  productCount[i].toString(),
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 14.0,
                                                                                    fontFamily: 'Kanit',
                                                                                    letterSpacing: 2.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              // GestureDetector(
                                                                              //   onTap: () => increment(
                                                                              //     i,
                                                                              //     productCount[i],
                                                                              //     setState,
                                                                              //   ),
                                                                              //   child: Container(
                                                                              //     padding: EdgeInsets.all(8),
                                                                              //     decoration: BoxDecoration(
                                                                              //         // shape: BoxShape.circle,
                                                                              //         // color: Theme.of(context)
                                                                              //         //     .primaryColor,
                                                                              //         ),
                                                                              //     child: FaIcon(
                                                                              //       FontAwesomeIcons.plus,
                                                                              //       color: Colors.black,
                                                                              //       size: 12.0,
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          );
                                                                        }),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'หน่วย',
                                                                          style:
                                                                              FlutterFlowTheme.of(context).bodyMedium,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // Column(
                                                                  //   mainAxisSize:
                                                                  //       MainAxisSize
                                                                  //           .max,
                                                                  //   mainAxisAlignment:
                                                                  //       MainAxisAlignment
                                                                  //           .center,
                                                                  //   children: [
                                                                  //     FFButtonWidget(
                                                                  //       onPressed:
                                                                  //           () {
                                                                  //         print(
                                                                  //             'Button pressed ...');
                                                                  //       },
                                                                  //       text:
                                                                  //           'อัพเดท',
                                                                  //       options:
                                                                  //           FFButtonOptions(
                                                                  //         height:
                                                                  //             28.0,
                                                                  //         padding: const EdgeInsetsDirectional
                                                                  //             .fromSTEB(
                                                                  //             10.0,
                                                                  //             0.0,
                                                                  //             10.0,
                                                                  //             0.0),
                                                                  //         iconPadding:
                                                                  //             const EdgeInsetsDirectional
                                                                  //                 .fromSTEB(
                                                                  //                 0.0,
                                                                  //                 0.0,
                                                                  //                 0.0,
                                                                  //                 0.0),
                                                                  //         color: FlutterFlowTheme.of(
                                                                  //                 context)
                                                                  //             .secondary,
                                                                  //         textStyle: FlutterFlowTheme.of(
                                                                  //                 context)
                                                                  //             .bodySmall
                                                                  //             .override(
                                                                  //               fontFamily:
                                                                  //                   'Kanit',
                                                                  //               color:
                                                                  //                   FlutterFlowTheme.of(context).primaryBackground,
                                                                  //             ),
                                                                  //         elevation:
                                                                  //             0.0,
                                                                  //         borderSide:
                                                                  //             const BorderSide(
                                                                  //           color: Colors
                                                                  //               .transparent,
                                                                  //           width:
                                                                  //               0.0,
                                                                  //         ),
                                                                  //         borderRadius:
                                                                  //             const BorderRadius
                                                                  //                 .only(
                                                                  //           bottomLeft:
                                                                  //               Radius.circular(
                                                                  //                   0.0),
                                                                  //           bottomRight:
                                                                  //               Radius.circular(
                                                                  //                   8.0),
                                                                  //           topLeft: Radius
                                                                  //               .circular(
                                                                  //                   0.0),
                                                                  //           topRight:
                                                                  //               Radius.circular(
                                                                  //                   8.0),
                                                                  //         ),
                                                                  //       ),
                                                                  //     ),
                                                                  //   ],
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  'ราคา ${orderList['ProductList'][i]['ราคา'].toString()} บาท',
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
                                                          ],
                                                        ),
                                                      ),
                                                      // Column(
                                                      //   mainAxisSize:
                                                      //       MainAxisSize.max,
                                                      //   children: [
                                                      //     GestureDetector(
                                                      //       onTap: () {
                                                      //         showDialog(
                                                      //           barrierDismissible:
                                                      //               false,
                                                      //           context:
                                                      //               context,
                                                      //           builder:
                                                      //               (BuildContext
                                                      //                   context) {
                                                      //             return StatefulBuilder(
                                                      //                 builder:
                                                      //                     (context,
                                                      //                         setState) {
                                                      //               return AlertDialog(
                                                      //                 // title: Text('Dialog Title'),
                                                      //                 // content: Text('This is the dialog content.'),
                                                      //                 actionsPadding:
                                                      //                     EdgeInsets.all(
                                                      //                         20),
                                                      //                 shape:
                                                      //                     RoundedRectangleBorder(
                                                      //                   borderRadius:
                                                      //                       BorderRadius.circular(20.0),
                                                      //                 ),
                                                      //                 actions: [
                                                      //                   Padding(
                                                      //                     padding: const EdgeInsets
                                                      //                         .all(
                                                      //                         8.0),
                                                      //                     child:
                                                      //                         Column(
                                                      //                       mainAxisAlignment:
                                                      //                           MainAxisAlignment.center,
                                                      //                       children: [
                                                      //                         Text('คุณต้องการลบสินค้านี้ ใช่หรือไม่ ?', style: FlutterFlowTheme.of(context).headlineMedium),
                                                      //                         SizedBox(
                                                      //                           height: 35,
                                                      //                         ),
                                                      //                         Row(
                                                      //                           mainAxisAlignment: MainAxisAlignment.end,
                                                      //                           children: [
                                                      //                             TextButton(
                                                      //                                 style: ButtonStyle(
                                                      //                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      //                                     RoundedRectangleBorder(
                                                      //                                       borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                                      //                                     ),
                                                      //                                   ),
                                                      //                                   side: MaterialStatePropertyAll(
                                                      //                                     BorderSide(color: Colors.green.shade300, width: 1),
                                                      //                                   ),
                                                      //                                 ),
                                                      //                                 onPressed: () => Navigator.pop(context),
                                                      //                                 child: CustomText(
                                                      //                                   text: "   ยกเลิก   ",
                                                      //                                   size: MediaQuery.of(context).size.height * 0.15,
                                                      //                                   color: Colors.green.shade300,
                                                      //                                 )),
                                                      //                             Spacer(),
                                                      //                             TextButton(
                                                      //                                 style: ButtonStyle(
                                                      //                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      //                                     RoundedRectangleBorder(
                                                      //                                       borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                                      //                                     ),
                                                      //                                   ),
                                                      //                                   side: MaterialStatePropertyAll(
                                                      //                                     BorderSide(color: Colors.red.shade300, width: 1),
                                                      //                                   ),
                                                      //                                 ),
                                                      //                                 onPressed: () {
                                                      //                                   print(i);
                                                      //                                   productCount.removeAt(i);
                                                      //                                   productImage.removeAt(i);
                                                      //                                   orderList['ProductList'].removeAt(i);

                                                      //                                   int total = 0;

                                                      //                                   for (var element in orderList['ProductList']) {
                                                      //                                     int qty = int.parse(element['จำนวน'].toString());
                                                      //                                     int price = int.parse(element['ราคา'].toString());

                                                      //                                     int sumTotal = qty * price;

                                                      //                                     total = total + sumTotal;
                                                      //                                   }

                                                      //                                   orderList['ยอดรวม'] = total;

                                                      //                                   Navigator.pop(context);
                                                      //                                 },
                                                      //                                 child: CustomText(
                                                      //                                   text: "   ตกลง   ",
                                                      //                                   size: MediaQuery.of(context).size.height * 0.15,
                                                      //                                   color: Colors.red.shade300,
                                                      //                                 )),
                                                      //                             // TextButton(
                                                      //                             //     style: ButtonStyle(
                                                      //                             //       backgroundColor: MaterialStatePropertyAll(
                                                      //                             //           Colors.blue.shade900),
                                                      //                             //       // side: MaterialStatePropertyAll(
                                                      //                             //       // BorderSide(
                                                      //                             //       //     color: Colors.red.shade300, width: 1),
                                                      //                             //       // ),
                                                      //                             //     ),
                                                      //                             //     onPressed: () {
                                                      //                             //       Navigator.pop(context);
                                                      //                             //     },
                                                      //                             //     child: CustomText(
                                                      //                             //       text: "   บันทึก   ",
                                                      //                             //       size: MediaQuery.of(context).size.height * 0.15,
                                                      //                             //       color: Colors.white,
                                                      //                             //     )),
                                                      //                           ],
                                                      //                         ),
                                                      //                       ],
                                                      //                     ),
                                                      //                   ),
                                                      //                 ],
                                                      //               );
                                                      //             });
                                                      //           },
                                                      //         ).then((value) {
                                                      //           if (mounted) {
                                                      //             print(
                                                      //                 productCount);
                                                      //             print(
                                                      //                 productImage);
                                                      //             print(orderList[
                                                      //                 'ProductList']);

                                                      //             setState(
                                                      //                 () {});
                                                      //           }
                                                      //         });
                                                      //       },
                                                      //       child: Icon(
                                                      //         Icons
                                                      //             .delete_outline,
                                                      //         color: FlutterFlowTheme
                                                      //                 .of(
                                                      //                     context)
                                                      //             .error
                                                      //             .withOpacity(
                                                      //                 0.7),
                                                      //         size: 30.0,
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                      ],
                                    ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    decoration: const BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'รวม',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'VAT 7%',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'รวมทั้งสิ้น',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${NumberFormat('#,##0').format(orderList['ยอดรวม']).toString()} บาท',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  '${NumberFormat('#,##0').format((orderList['ยอดรวม'] * 0.07)).toString()} บาท',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  '${NumberFormat('#,##0').format((orderList['ยอดรวม'] * 1.07)).toString()} บาท',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                            ),
                          ),
                        ),

                        //============== Address =====================================
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'สถานที่ในการจัดส่ง',
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
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .accent3
                                .withOpacity(0.2),
                            // borderRadius: BorderRadius.circular(10.0),
                            // border: Border.all(
                            //   color: FlutterFlowTheme.of(context)
                            //       .secondaryText
                            //       .withOpacity(0.5),
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        orderList['สถานที่จัดส่ง'] == ''
                                            ? 'คุณไม่ได้เลือก'
                                            : orderList['สถานที่จัดส่ง'],
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Kanit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //============== date =====================================
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'วันและเวลาในการจัดส่ง',
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
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .accent3
                                .withOpacity(0.2),
                            // borderRadius: BorderRadius.circular(10.0),
                            // border: Border.all(
                            //   color: FlutterFlowTheme.of(context)
                            //       .secondaryText
                            //       .withOpacity(0.5),
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      orderList['วันเวลาจัดส่ง'] == ''
                                          ? 'คุณไม่ได้เลือก'
                                          : formatThaiDate(
                                              orderList['วันเวลาจัดส่ง']),
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
                              ],
                            ),
                          ),
                        ),
                        //============== สายส่ง =====================================
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ระบบสายส่ง',
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
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .accent3
                                .withOpacity(0.2),
                            // borderRadius: BorderRadius.circular(10.0),
                            // border: Border.all(
                            //   color: FlutterFlowTheme.of(context)
                            //       .secondaryText
                            //       .withOpacity(0.5),
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      orderList['สายส่ง'] == ''
                                          ? 'คุณไม่ได้เลือก'
                                          : orderList['สายส่ง'],
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
                              ],
                            ),
                          ),
                        ),
                        //==============  Confirm Button =====================================
                        // SizedBox(
                        //   height: 40,
                        // ),
                        // orderList['สถานะเอกสาร'] == true &&
                        //         orderList['รอตรวจการอนุมัติ'] == false &&
                        //         orderList['สถานะอนุมัติขาย'] == false
                        //     ? Padding(
                        //         padding: const EdgeInsetsDirectional.fromSTEB(
                        //             0.0, 0.0, 0.0, 0.0),
                        //         child: FFButtonWidget(
                        //           onPressed: () async {
                        //             String orderID = DateTime.now().toString();
                        //             try {
                        //               setState(() {
                        //                 isLoading = true;
                        //               });
                        //               print(orderList['สายส่ง']);
                        //               print(orderList['สายส่งโค้ด']);
                        //               print(orderList['สายส่งไอดี']);
                        //               print(orderList['สถานที่จัดส่ง']);
                        //               print(orderList['วันเวลาจัดส่ง']);
                        //               print(orderList['ยอดรวม']);
                        //               print(orderList['ProductList']);

                        //               await FirebaseFirestore.instance
                        //                   .collection('Customer')
                        //                   .doc(widget.customerID)
                        //                   .collection('Orders')
                        //                   .doc(orderID)
                        //                   .set({
                        //                 'OrdersDateID': orderID,
                        //                 'OrdersUpdateTime': DateTime.now(),
                        //                 'สถานที่จัดส่ง':
                        //                     orderList['สถานที่จัดส่ง'],
                        //                 'วันเวลาจัดส่ง':
                        //                     orderList['วันเวลาจัดส่ง'],
                        //                 'สายส่ง': orderList['สายส่ง'],
                        //                 'สายส่งโค้ด': orderList['สายส่งโค้ด'],
                        //                 'สายส่งไอดี': orderList['สายส่งไอดี'],
                        //                 'ProductList': orderList['ProductList'],
                        //                 'ยอดรวม': orderList['ยอดรวม'],
                        //                 'ค้างชำระ': 0,
                        //                 'สถานะเอกสาร': false,
                        //                 'สถานะอนุมัติขาย': false,
                        //               }).whenComplete(() {
                        //                 Navigator.push(
                        //                     context,
                        //                     CupertinoPageRoute(
                        //                       builder: (context) =>
                        //                           A0905SuccessOrderProduct(),
                        //                     ));
                        //               });

                        //               setState(() {
                        //                 isLoading = false;
                        //               });
                        //             } catch (e) {
                        //               print(e);
                        //             }
                        //           },
                        //           text: 'ยื่นขอเปิดออเดอร์สินค้าอีกครั้ง',
                        //           options: FFButtonOptions(
                        //             width: double.infinity,
                        //             height: 40.0,
                        //             padding:
                        //                 const EdgeInsetsDirectional.fromSTEB(
                        //                     24.0, 0.0, 24.0, 0.0),
                        //             iconPadding:
                        //                 const EdgeInsetsDirectional.fromSTEB(
                        //                     0.0, 0.0, 0.0, 0.0),
                        //             color: Colors.red.shade900,
                        //             // FlutterFlowTheme.of(context).secondary,
                        //             textStyle: FlutterFlowTheme.of(context)
                        //                 .titleSmall
                        //                 .override(
                        //                   fontFamily: 'Kanit',
                        //                   color: Colors.white,
                        //                   fontSize: 14.0,
                        //                   fontWeight: FontWeight.normal,
                        //                 ),
                        //             elevation: 3.0,
                        //             borderSide: const BorderSide(
                        //               color: Colors.transparent,
                        //               width: 1.0,
                        //             ),
                        //             borderRadius: BorderRadius.circular(8.0),
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
