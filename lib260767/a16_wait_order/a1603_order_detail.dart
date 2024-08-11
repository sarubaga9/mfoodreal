import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a09_customer_open_sale/a0905_success_order_product.dart';
import 'package:m_food/a09_customer_open_sale/widget/a0904_product_order_model.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
import 'package:m_food/main.dart';
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

class A1603OrderDetail extends StatefulWidget {
  final String? customerID;
  final bool? checkTeam;

  final Map<String, dynamic>? orderDataMap;
  const A1603OrderDetail({
    super.key,
    this.orderDataMap,
    this.customerID,
    @required this.checkTeam,
  });

  @override
  _A1603OrderDetailState createState() => _A1603OrderDetailState();
}

class _A1603OrderDetailState extends State<A1603OrderDetail> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  late Map<String, dynamic> customerData;

  // late A0904ProductOrderModel _model;

  final productController = Get.find<ProductController>();
  RxMap<String, dynamic>? productGetData;

  List<Map<String, dynamic>> resultList = [];

  late Map<String, dynamic> orderList;

  List<int> productCount = [];

  List<String> productImage = [];

  bool isLoading = false;

  DateTime orderDate = DateTime.now();

  @override
  void initState() {
    loaddata();
    super.initState();
  }

  loaddata() async {
    setState(() {
      isLoading = true;
    });
    // _model = createModel(context, () => A0904ProductOrderModel());

    productGetData = productController.productData;

    List<Map<String, dynamic>> resultList = [];

    orderList = widget.orderDataMap!;

    orderDate = DateTime.parse(orderList['OrdersDateID']);

    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'CustomerTest'
            : 'Customer')
        .doc(widget.customerID)
        .get();

    customerData = customerDoc.data() as Map<String, dynamic>;

    if (productGetData != null) {
      productGetData!.forEach((key, value) {
        // print(value);/
        Map<String, dynamic> entry = value;
        resultList.add(entry);
        // print('0000000000------------------000000000000');
        // print(entry);
        // print('0000000000------------------000000000000');
      });
    }

    for (var key in orderList.keys) {
      var value = orderList[key];
      // print('Key: $key, Value: $value');
      if (key == 'ProductList') {
        for (var element in value) {
          print(element);
          Map<String, dynamic> productMatch = resultList.firstWhere(
              (elementProduct) =>
                  elementProduct['PRODUCT_ID'] == element['ProductID']);
          // print('-888-');

          // print(productMatch);
          print(productMatch['รูปภาพ']);

          // print('-999-');
          if (productMatch['รูปภาพ'] == null) {
            // print(productMatch['รูปภาพ'][0]);
            if (productMatch['รูปภาพ'] == []) {
              if (productMatch['รูปภาพ'][0] != '') {
                productImage.add(productMatch['รูปภาพ'][0]);
              } else {
                productImage.add('');
              }
            } else {
              productImage.add('');
            }
          } else {
            productImage.add(productMatch['รูปภาพ'][0]);
          }
        }
      }
      // ทำสิ่งที่คุณต้องการกับแต่ละ key และ value
    }
    print('111111------------------1111111');

    for (var key in orderList.keys) {
      var value = orderList[key];
      // print('Key: $key, Value: $value');
      if (key == 'ProductList') {
        for (var element in value) {
          String value = element['จำนวน'].toStringAsFixed(0);
          productCount.add(int.parse(value));
          print(element['ราคาพิเศษ']);
        }
      }
      // ทำสิ่งที่คุณต้องการกับแต่ละ key และ value
    }
    print('2222222------------------2222222');

    // print(productCount);
    setState(() {
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;

    print('==============================');
    print('This is A1603 Order Detail');
    print('==============================');

    print(widget.customerID);
    // print(widget.orderDataMap);

    // for (int i = 0; i < widget.orderDataMap!['ProductList'].length; i++) {
    //   print(widget.orderDataMap!['ProductList'][i]);
    // }

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
                                  widget.checkTeam!
                                      ? 'รายละเอียดออเดอร์ที่เปิดแทน'
                                      : 'รายละเอียดออเดอร์',
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
                        //============== Total Price =====================================
                        // Row(
                        //   mainAxisSize: MainAxisSize.max,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsetsDirectional.fromSTEB(
                        //           0.0, 10.0, 0.0, 10.0),
                        //       child: Container(
                        //         width: MediaQuery.sizeOf(context).width * 0.5,
                        //         height: 35.0,
                        //         decoration: BoxDecoration(
                        //           color: FlutterFlowTheme.of(context)
                        //               .accent3
                        //               .withOpacity(0.2),
                        //           borderRadius: BorderRadius.circular(8.0),
                        //           border: Border.all(
                        //             color: FlutterFlowTheme.of(context).accent2,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         child: Row(
                        //           mainAxisSize: MainAxisSize.max,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Expanded(
                        //               child: Padding(
                        //                 padding: const EdgeInsetsDirectional
                        //                     .fromSTEB(20.0, 0.0, 0.0, 0.0),
                        //                 child: Column(
                        //                   mainAxisSize: MainAxisSize.max,
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.center,
                        //                   // crossAxisAlignment: CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text(
                        //                       'รวมรายการสินค้า ${NumberFormat('#,##0').format(orderList['ยอดรวม']).toString()} บาท',
                        //                       style:
                        //                           FlutterFlowTheme.of(context)
                        //                               .bodyMedium
                        //                               .override(
                        //                                 fontFamily: 'Kanit',
                        //                                 fontWeight:
                        //                                     FontWeight.w500,
                        //                               ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //             Column(
                        //               mainAxisSize: MainAxisSize.max,
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Container(
                        //                   height: 33.0,
                        //                   decoration: BoxDecoration(
                        //                     color: FlutterFlowTheme.of(context)
                        //                         .success,
                        //                     borderRadius:
                        //                         const BorderRadius.only(
                        //                       bottomLeft: Radius.circular(0.0),
                        //                       bottomRight: Radius.circular(8.0),
                        //                       topLeft: Radius.circular(0.0),
                        //                       topRight: Radius.circular(8.0),
                        //                     ),
                        //                   ),
                        //                   child: Row(
                        //                     mainAxisSize: MainAxisSize.max,
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       Padding(
                        //                         padding:
                        //                             const EdgeInsetsDirectional
                        //                                 .fromSTEB(
                        //                                 5.0, 0.0, 0.0, 0.0),
                        //                         child: Text(
                        //                           'สรุปการสั่งชื้อ',
                        //                           textAlign: TextAlign.center,
                        //                           style: FlutterFlowTheme.of(
                        //                                   context)
                        //                               .bodyMedium
                        //                               .override(
                        //                                 fontFamily: 'Kanit',
                        //                                 color: FlutterFlowTheme
                        //                                         .of(context)
                        //                                     .primaryBackground,
                        //                               ),
                        //                         ),
                        //                       ),
                        //                       Padding(
                        //                         padding:
                        //                             const EdgeInsetsDirectional
                        //                                 .fromSTEB(
                        //                                 5.0, 0.0, 5.0, 0.0),
                        //                         child: FaIcon(
                        //                           FontAwesomeIcons
                        //                               .shoppingBasket,
                        //                           color: FlutterFlowTheme.of(
                        //                                   context)
                        //                               .primaryBackground,
                        //                           size: 18.0,
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        //============== Order List =====================================

                        SizedBox(
                          height: 20,
                        ),

                        // Row(
                        //   mainAxisSize: MainAxisSize.max,
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     orderList['สถานะเอกสาร'] == true
                        //         ? Icon(
                        //             Icons.check_box,
                        //             color: Colors.green.shade900,
                        //           )
                        //         : Icon(Icons.indeterminate_check_box_outlined),
                        //     SizedBox(
                        //       width: 5,
                        //     ),
                        //     Text(
                        //       orderList['สถานะเอกสาร'] == true
                        //           ? 'ผ่านการตรวจเอกสารออเดอร์แล้ว'
                        //           : 'รอการตรวจเอกสารออเดอร์',
                        //       style: FlutterFlowTheme.of(context)
                        //           .bodyLarge
                        //           .override(
                        //             fontFamily: 'Kanit',
                        //             color: FlutterFlowTheme.of(context)
                        //                 .primaryText,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //     ),
                        //   ],
                        // ),

                        // orderList['สถานะเอกสาร'] == true
                        //     ? Row(
                        //         mainAxisSize: MainAxisSize.max,
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           orderList['รอตรวจการอนุมัติ'] == false
                        //               ? Icon(
                        //                   Icons.check_box,
                        //                   color: Colors.green.shade900,
                        //                 )
                        //               : Icon(Icons
                        //                   .indeterminate_check_box_outlined),
                        //           SizedBox(
                        //             width: 5,
                        //           ),
                        //           Text(
                        //             orderList['รอตรวจการอนุมัติ'] == false
                        //                 ? 'ผ่านการรอตรวจการอนุมัติขายแล้ว'
                        //                 : 'รอตรวจการอนุมัติขาย',
                        //             style: FlutterFlowTheme.of(context)
                        //                 .bodyLarge
                        //                 .override(
                        //                   fontFamily: 'Kanit',
                        //                   color: FlutterFlowTheme.of(context)
                        //                       .primaryText,
                        //                   fontWeight: FontWeight.w500,
                        //                 ),
                        //           ),
                        //         ],
                        //       )
                        //     : SizedBox(),

                        // orderList['สถานะเอกสาร'] == true &&
                        //         orderList['รอตรวจการอนุมัติ'] == false
                        //     ? Row(
                        //         mainAxisSize: MainAxisSize.max,
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           orderList['สถานะอนุมัติขาย'] == true
                        //               ? Icon(
                        //                   Icons.check_box,
                        //                   color: Colors.green.shade900,
                        //                 )
                        //               : Icon(
                        //                   Icons.disabled_by_default,
                        //                   color: Colors.red.shade900,
                        //                 ),
                        //           SizedBox(
                        //             width: 5,
                        //           ),
                        //           Text(
                        //             orderList['สถานะอนุมัติขาย'] == true
                        //                 ? 'ผลการอนุมัติ :   ' + 'อนุมัติขาย'
                        //                 : 'ผลการอนุมัติ :   ' + 'ไม่อนุมัติขาย',
                        //             style: FlutterFlowTheme.of(context)
                        //                 .bodyLarge
                        //                 .override(
                        //                   fontFamily: 'Kanit',
                        //                   color: FlutterFlowTheme.of(context)
                        //                       .primaryText,
                        //                   fontWeight: FontWeight.w500,
                        //                 ),
                        //           ),
                        //         ],
                        //       )
                        //     : SizedBox(),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'ออเดอร์ไอดี',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                orderList['OrdersDateID'],
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'วันที่',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${orderDate.day} ${formatThaiMonth(orderDate.month)} ${orderDate.year}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 5.0, 0.0),
                                child: Icon(
                                  Icons.perm_contact_calendar_outlined,
                                  color: FlutterFlowTheme.of(context).alternate,
                                  size: 24.0,
                                ),
                              ),
                              Text(
                                customerData['ClientIdจากMfoodAPI'],
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                customerData['ประเภทลูกค้า'] == 'Company'
                                    ? customerData['ชื่อบริษัท']
                                    : customerData['ชื่อนามสกุล'],
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Container(
                            // height: 4000,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(8),

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
                                                          productImage[i]
                                                                  .isEmpty
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          10.0,
                                                                          10.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/noproductimage.png',
                                                                      width:
                                                                          65.0,
                                                                      height:
                                                                          65.0,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          10.0,
                                                                          10.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: Image
                                                                        .network(
                                                                      productImage[
                                                                          i],
                                                                      width:
                                                                          65.0,
                                                                      height:
                                                                          65.0,
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
                                                          orderList['ProductList']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'คำอธิบายสินค้า'] ==
                                                                      null ||
                                                                  orderList['ProductList']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'คำอธิบายสินค้า'] ==
                                                                      ''
                                                              ? Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.3,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child: Text(
                                                                    'ยังไม่มีคำอธิบายสินค้า',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                        ),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.3,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child: Text(
                                                                    orderList['ProductList']
                                                                            [i][
                                                                        'คำอธิบายสินค้า'],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                        ),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  orderList['ProductList'][i][
                                                                  'ราคาพิเศษ'] ==
                                                              null ||
                                                          orderList[
                                                                  'ProductList']
                                                              [i]['ราคาพิเศษ']
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
                                                                                  orderList['สถานะเช็คสต็อก'] == 'ยกทั้งตระกร้า' ? '-' : productCount[i].toString(),
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
                                                                          orderList['ProductList'][i]
                                                                              [
                                                                              'ยูนิต'],
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
                                                                  'ราคา ${orderList['สถานะเช็คสต็อก'] == 'ยกทั้งตระกร้า' ? '-' : orderList['ProductList'][i]['ราคา'].toString()} บาท',
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
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  'ราคารวม ${orderList['สถานะเช็คสต็อก'] == 'ยกทั้งตระกร้า' ? '-' : double.parse((double.parse(orderList['ProductList'][i]['ราคา'].toString()) * double.parse(productCount[i].toString())).toString()).toStringAsFixed(2)} บาท',
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
                                                            orderList['ProductList']
                                                                            [i][
                                                                        'ส่วนลดรายการ'] ==
                                                                    '0.0'
                                                                ? SizedBox()
                                                                : Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        'ส่วนลดรายการ ${orderList['ProductList'][i]['ส่วนลดรายการ']} บาท ',

                                                                        // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .override(
                                                                              fontFamily: 'Kanit',
                                                                              color: Colors.red,
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
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.8,
                                      decoration: const BoxDecoration(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.6,
                                            decoration: const BoxDecoration(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'ยอดรวมส่วนลดรายการทั้งหมด',
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
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'ส่วนลดท้ายบิล/Discount',
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
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม/Value of non VAT (N)',
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
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม/Value including VAT (V)',
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
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม/Value excluding VAT',
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
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'ภาษีมูลค่าเพิ่ม/VAT',
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
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'มูลค่าสินค้ารวม/Grand Total',
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
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  // color: Colors.red,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.175,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            orderList['สถานะเช็คสต็อก'] ==
                                                                    'ยกทั้งตระกร้า'
                                                                ? '-'
                                                                : '${orderList['ยอดรวมส่วนลดทั้งหมด'] ?? '0'} บาท',
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
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            orderList['สถานะเช็คสต็อก'] ==
                                                                    'ยกทั้งตระกร้า'
                                                                ? '-'
                                                                : '${orderList['ยอดรวมส่วนลดท้ายบิล'] ?? '0'} บาท',
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
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            orderList['สถานะเช็คสต็อก'] ==
                                                                    'ยกทั้งตระกร้า'
                                                                ? '-'
                                                                : '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            orderList['สถานะเช็คสต็อก'] ==
                                                                    'ยกทั้งตระกร้า'
                                                                ? '-'
                                                                : '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            orderList['สถานะเช็คสต็อก'] ==
                                                                    'ยกทั้งตระกร้า'
                                                                ? '-'
                                                                : '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            orderList['สถานะเช็คสต็อก'] ==
                                                                    'ยกทั้งตระกร้า'
                                                                ? '-'
                                                                : '${NumberFormat('#,##0.00').format(orderList['ภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            orderList['สถานะเช็คสต็อก'] ==
                                                                    'ยกทั้งตระกร้า'
                                                                ? '-'
                                                                : '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้ารวม']).toString()} บาท',
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
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                      // child: Row(
                                      //   mainAxisSize: MainAxisSize.max,
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Column(
                                      //       mainAxisSize: MainAxisSize.max,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.end,
                                      //       children: [
                                      //         Row(
                                      //           mainAxisSize: MainAxisSize.max,
                                      //           children: [
                                      //             Text(
                                      //               'รวม',
                                      //               style: FlutterFlowTheme.of(
                                      //                       context)
                                      //                   .bodyLarge
                                      //                   .override(
                                      //                     fontFamily: 'Kanit',
                                      //                     color:
                                      //                         FlutterFlowTheme.of(
                                      //                                 context)
                                      //                             .primaryText,
                                      //                     fontWeight:
                                      //                         FontWeight.normal,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         Row(
                                      //           mainAxisSize: MainAxisSize.max,
                                      //           children: [
                                      //             Text(
                                      //               'VAT 7%',
                                      //               style: FlutterFlowTheme.of(
                                      //                       context)
                                      //                   .bodyLarge
                                      //                   .override(
                                      //                     fontFamily: 'Kanit',
                                      //                     color:
                                      //                         FlutterFlowTheme.of(
                                      //                                 context)
                                      //                             .primaryText,
                                      //                     fontWeight:
                                      //                         FontWeight.normal,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         Row(
                                      //           mainAxisSize: MainAxisSize.max,
                                      //           children: [
                                      //             Text(
                                      //               'รวมทั้งสิ้น',
                                      //               style: FlutterFlowTheme.of(
                                      //                       context)
                                      //                   .bodyLarge
                                      //                   .override(
                                      //                     fontFamily: 'Kanit',
                                      //                     color:
                                      //                         FlutterFlowTheme.of(
                                      //                                 context)
                                      //                             .primaryText,
                                      //                     fontWeight:
                                      //                         FontWeight.normal,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     Column(
                                      //       mainAxisSize: MainAxisSize.max,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.end,
                                      //       children: [
                                      //         Row(
                                      //           mainAxisSize: MainAxisSize.max,
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.end,
                                      //           children: [
                                      //             Text(
                                      //               '${NumberFormat('#,##0').format(orderList['ยอดรวม']).toString()} บาท',
                                      //               style: FlutterFlowTheme.of(
                                      //                       context)
                                      //                   .bodyLarge
                                      //                   .override(
                                      //                     fontFamily: 'Kanit',
                                      //                     color:
                                      //                         FlutterFlowTheme.of(
                                      //                                 context)
                                      //                             .primaryText,
                                      //                     fontWeight:
                                      //                         FontWeight.normal,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         Row(
                                      //           mainAxisSize: MainAxisSize.max,
                                      //           children: [
                                      //             Text(
                                      //               '${NumberFormat('#,##0').format((orderList['ยอดรวม'] * 0.07)).toString()} บาท',
                                      //               style: FlutterFlowTheme.of(
                                      //                       context)
                                      //                   .bodyLarge
                                      //                   .override(
                                      //                     fontFamily: 'Kanit',
                                      //                     color:
                                      //                         FlutterFlowTheme.of(
                                      //                                 context)
                                      //                             .primaryText,
                                      //                     fontWeight:
                                      //                         FontWeight.normal,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         Row(
                                      //           mainAxisSize: MainAxisSize.max,
                                      //           children: [
                                      //             Text(
                                      //               '${NumberFormat('#,##0').format((orderList['ยอดรวม'] * 1.07)).toString()} บาท',
                                      //               style: FlutterFlowTheme.of(
                                      //                       context)
                                      //                   .bodyLarge
                                      //                   .override(
                                      //                     fontFamily: 'Kanit',
                                      //                     color:
                                      //                         FlutterFlowTheme.of(
                                      //                                 context)
                                      //                             .primaryText,
                                      //                     fontWeight:
                                      //                         FontWeight.normal,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
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
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(8),
                            // borderRadius: BorderRadius.
                            // circular(10.0),
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
                                      Expanded(
                                        child: Text(
                                          orderList['สถานที่จัดส่ง'] == null ||
                                                  orderList['สถานที่จัดส่ง'] ==
                                                      ''
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
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(8),
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
                                      orderList['วันเวลาจัดส่ง'] == null ||
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
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(8),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    orderList['สายส่ง'] == null ||
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
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
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
