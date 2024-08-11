import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/a08_customer_rating_group/a0802_customer_orders_history.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class A0801CustomerRatingGroup extends StatefulWidget {
  const A0801CustomerRatingGroup({Key? key}) : super(key: key);

  @override
  _A0801CustomerRatingGroupState createState() =>
      _A0801CustomerRatingGroupState();
}

class _A0801CustomerRatingGroupState extends State<A0801CustomerRatingGroup> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  RxMap<String, dynamic>? customerData;

  TextEditingController seartchCustomerTextfieldController =
      TextEditingController();
  FocusNode seartchCustomerTextfieldFocusNode = FocusNode();

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
    print('This is A080 customer rating group');
    print('==============================');
    userData = userController.userData;
    customerData = customerController.customerData;

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
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //========================= App Bar ===============================
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
                                      borderRadius: BorderRadius.circular(50.0),
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
                                        color: FlutterFlowTheme.of(context)
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
                                color: FlutterFlowTheme.of(context).primaryText,
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
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
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
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
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
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
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
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            userData!.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        maxRadius: 20,
                                        // radius: 1,
                                        backgroundImage: userData!['Img'] == ''
                                            ? null
                                            : NetworkImage(userData!['Img']),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            // saveDataForLogout();
                                          },
                                          child: Icon(
                                            Icons.account_circle,
                                            color: FlutterFlowTheme.of(context)
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
                //========================= Body Screen ===============================
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 10.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //========================= Menu Side Bar ===============================
                      // const Expanded(
                      //   child: Padding(
                      //     padding: EdgeInsetsDirectional.fromSTEB(
                      //         0.0, 0.0, 10.0, 0.0),
                      //     child: MenuSidebarWidget(),
                      //   ),
                      // ),
                      //========================= Screen Body  ===============================
                      Expanded(
                        // flex: 2,
                        child: Container(
                          height: 1100,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //============ ตรวจสอบ =================
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 10.0, 0.0, 20.0),
                                        child: Container(
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            // color: Colors.red,
                                            color: FlutterFlowTheme.of(context)
                                                .accent3,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            children: [
                                              //============ ตรวจสอบ =================
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 12.0, 8.0, 0.0),
                                                  child: TextFormField(
                                                    controller:
                                                        seartchCustomerTextfieldController,
                                                    focusNode:
                                                        seartchCustomerTextfieldFocusNode,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      hintText:
                                                          'ค้นหาบัญชีลูกค้าในระบบ',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                      // suffixIcon: Icon(
                                                      //   Icons.search,
                                                      // ),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    textAlign: TextAlign.center,
                                                    // validator: _model
                                                    //     .textControllerValidator
                                                    //     .asValidator(context),
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.search),
                                              const SizedBox(
                                                width: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      //============ กลุ่มเรทติ้ง =================
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('กลุ่มเรทติ้ง')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
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
                                            if (snapshot.data!.docs.isEmpty) {
                                              print(snapshot.data);
                                            }

                                            final NumberFormat formatter =
                                                NumberFormat('#,###');

                                            List<Map<String, dynamic>>
                                                customerRatingList = [];

                                            for (int index = 0;
                                                index <
                                                    snapshot.data!.docs.length;
                                                index++) {
                                              final Map<String, dynamic>
                                                  docData = snapshot
                                                          .data!.docs[index]
                                                          .data()
                                                      as Map<String, dynamic>;

                                              Map<String, dynamic> entry = {
                                                'key': 'key${index}',
                                                'data': docData,
                                              };

                                              customerRatingList.add(entry);
                                            }

                                            // เรียงลำดับ customerRatingList
                                            customerRatingList.sort((a, b) {
                                              // เรียงลำดับตาม 'ยอดขาย' ให้มากอยู่ตัวหน้า
                                              int salesComparison =
                                                  b['data']['ยอดขาย'].compareTo(
                                                      a['data']['ยอดขาย']);

                                              if (salesComparison != 0) {
                                                print('---');
                                                print(salesComparison);
                                                return salesComparison; // ถ้า 'ยอดขาย' ไม่เท่ากัน ให้คืนผลลัพธ์
                                              }

                                              // ถ้า 'ยอดขาย' เท่ากัน ให้เรียงตาม 'เปรียบเทียบ' ในลำดับถอยหลัง
                                              return b['data']['เปรียบเทียบ'] ==
                                                      '>'
                                                  ? 1
                                                  : -1;
                                            });

                                            // พิมพ์ customerRatingList หลังจากการเรียงลำดับ
                                            for (var element
                                                in customerRatingList) {
                                              print(
                                                  'ยอดขาย: ${element['data']['ยอดขาย']}, เปรียบเทียบ: ${element['data']['เปรียบเทียบ']}');
                                            }

                                            return Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        customerRatingList
                                                            .length;
                                                    i++)
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 0, 0, 10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'กลุ่ม${customerRatingList[i]['data']['ชื่อกลุ่ม']} (ยอดขาย${customerRatingList[i]['data']['เปรียบเทียบ'] == '>' ? 'ตั้งแต่' : 'ไม่เกิน'} ${formatter.format(customerRatingList[i]['data']['ยอดขาย'])} บาท/เดือน)',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleLargeFont
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
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        //======================= รายชื่อ ของลูกค้าที่ตรงเงื่อนไข
                                                        StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(AppSettings
                                                                            .customerType ==
                                                                        CustomerType
                                                                            .Test
                                                                    ? 'CustomerTest'
                                                                    : 'Customer')
                                                                .where(
                                                                    'รหัสพนักงานขาย',
                                                                    isEqualTo:
                                                                        userData![
                                                                            'EmployeeID'])
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return SizedBox();
                                                              }
                                                              if (snapshot
                                                                  .hasError) {
                                                                return Text(
                                                                    'เกิดข้อผิดพลาด: ${snapshot.error}');
                                                              }
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Text(
                                                                    'ไม่พบข้อมูล');
                                                              }
                                                              if (snapshot
                                                                  .data!
                                                                  .docs
                                                                  .isEmpty) {
                                                                print(snapshot
                                                                    .data);
                                                              }

                                                              List<
                                                                      Map<String,
                                                                          dynamic>>
                                                                  customerDataList =
                                                                  [];
                                                              for (QueryDocumentSnapshot customerDoc
                                                                  in snapshot
                                                                      .data!
                                                                      .docs) {
                                                                Map<String,
                                                                        dynamic>
                                                                    customerData =
                                                                    customerDoc
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>;

                                                                customerDataList
                                                                    .add(
                                                                        customerData);
                                                              }

                                                              customerDataList.removeWhere(
                                                                  (customerData) =>
                                                                      customerData[
                                                                          'สถานะ'] ==
                                                                      false);

                                                              print(
                                                                  'A0801 ต้องเปิดคอมเม้นนี้ เพื่อกรองข้อมูลตามจริง');
                                                              //==================================================
                                                              // หากเริ่มทำงานจริง ให้เปิดเงื่อนไขนี้ไว้ เพื่อกรองดาต้าจริง
                                                              customerDataList.removeWhere(
                                                                  (customerData) =>
                                                                      userData![
                                                                          'EmployeeID'] !=
                                                                      customerData[
                                                                          'รหัสพนักงานขาย']);
                                                              //==================================================
                                                              customerDataList
                                                                  .sort((a, b) {
                                                                String nameA = a[
                                                                    'ชื่อนามสกุล'];
                                                                String nameB = b[
                                                                    'ชื่อนามสกุล'];

                                                                return nameA
                                                                    .compareTo(
                                                                        nameB);
                                                              });

                                                              return Column(
                                                                children: [
                                                                  for (int j =
                                                                          0;
                                                                      j <
                                                                          customerDataList
                                                                              .length;
                                                                      j++)
                                                                    StreamBuilder(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection(AppSettings.customerType == CustomerType.Test
                                                                                ? 'CustomerTest'
                                                                                : 'Customer')
                                                                            .doc(customerDataList[j][
                                                                                'CustomerID'])
                                                                            .collection(
                                                                                'Orders')
                                                                            .snapshots(),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.waiting) {
                                                                            return SizedBox();
                                                                          }
                                                                          if (snapshot
                                                                              .hasError) {
                                                                            return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                                                                          }
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return Text('ไม่พบข้อมูล');
                                                                          }
                                                                          if (snapshot
                                                                              .data!
                                                                              .docs
                                                                              .isEmpty) {
                                                                            print(snapshot.data);
                                                                          }

                                                                          // เก็บข้อมูลจาก Firestore ลงใน Map
                                                                          List<Map<String, dynamic>>
                                                                              customerOrderDataList =
                                                                              [];
                                                                          for (QueryDocumentSnapshot customerOrderDoc in snapshot
                                                                              .data!
                                                                              .docs) {
                                                                            Map<String, dynamic>
                                                                                customerOrderData =
                                                                                customerOrderDoc.data() as Map<String, dynamic>;

                                                                            customerOrderDataList.add(customerOrderData);
                                                                          }

                                                                          DateTime
                                                                              now =
                                                                              DateTime.now();
                                                                          DateTime
                                                                              previousMonth =
                                                                              DateTime(now.year, now.month - 1);

                                                                          List<Map<String, dynamic>>
                                                                              filteredList =
                                                                              customerOrderDataList.where((order) {
                                                                            DateTime
                                                                                orderUpdateTime =
                                                                                order['OrdersUpdateTime'].toDate();
                                                                            return orderUpdateTime.isBefore(previousMonth);
                                                                          }).toList();

                                                                          // print(
                                                                          //     customerOrderDataList.length);

                                                                          // print(
                                                                          //     filteredList.length);

                                                                          double
                                                                              totalAmount =
                                                                              filteredList.fold(0.0, (sum, order) {
                                                                            // ทำการบวกยอดรวมของแต่ละ Order
                                                                            double
                                                                                orderTotal =
                                                                                (order['ยอดรวม'] as num).toDouble();
                                                                            return sum +
                                                                                orderTotal;
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
                                                                              customerRatingList[i]['data']['เปรียบเทียบ'] == '>'
                                                                                  ? totalAmount > customerRatingList[i]['data']['ยอดขาย']
                                                                                      ? Padding(
                                                                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              print(
                                                                                                customerDataList[j]['CustomerID'],
                                                                                              );
                                                                                              print(totalAmount);
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  CupertinoPageRoute(
                                                                                                    builder: (context) => A0802CustomerOrdersHistory(customerID: customerDataList[j]['CustomerID'], mapDataCustomer: customerDataList[j], mapDataOrders: customerOrderDataList),
                                                                                                  ));
                                                                                            },
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Column(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          customerDataList[j]['ประเภทลูกค้า'] == 'Company' ? customerDataList[j]['ชื่อบริษัท'] : customerDataList[j]['ชื่อนามสกุล'],
                                                                                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                                fontFamily: 'Kanit',
                                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Spacer(),
                                                                                                Icon(
                                                                                                  Icons.arrow_forward_ios,
                                                                                                  size: 16,
                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : SizedBox()
                                                                                  : i != customerRatingList.length - 1
                                                                                      ? totalAmount < customerRatingList[i]['data']['ยอดขาย'] && totalAmount > customerRatingList[i + 1]['data']['ยอดขาย']
                                                                                          ? Padding(
                                                                                              padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                                                                                              child: InkWell(
                                                                                                onTap: () {
                                                                                                  print(
                                                                                                    customerDataList[j]['CustomerID'],
                                                                                                  );
                                                                                                  print(totalAmount);
                                                                                                  Navigator.push(
                                                                                                      context,
                                                                                                      CupertinoPageRoute(
                                                                                                        builder: (context) => A0802CustomerOrdersHistory(customerID: customerDataList[j]['CustomerID'], mapDataCustomer: customerDataList[j], mapDataOrders: customerOrderDataList),
                                                                                                      ));

                                                                                                  // Navigator.push(
                                                                                                  //     context,
                                                                                                  //     CupertinoPageRoute(
                                                                                                  //       builder: (context) =>
                                                                                                  //           A0714RejectWidget(),
                                                                                                  //     ));
                                                                                                },
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              customerDataList[j]['ประเภทลูกค้า'] == 'Company' ? customerDataList[j]['ชื่อบริษัท'] : customerDataList[j]['ชื่อนามสกุล'],
                                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                                    fontFamily: 'Kanit',
                                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Spacer(),
                                                                                                    Icon(
                                                                                                      Icons.arrow_forward_ios,
                                                                                                      size: 16,
                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          : SizedBox()
                                                                                      : totalAmount < customerRatingList[i]['data']['ยอดขาย']
                                                                                          ? Padding(
                                                                                              padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                                                                                              child: InkWell(
                                                                                                onTap: () {
                                                                                                  print(
                                                                                                    customerDataList[j]['CustomerID'],
                                                                                                  );
                                                                                                  print(totalAmount);
                                                                                                  Navigator.push(
                                                                                                      context,
                                                                                                      CupertinoPageRoute(
                                                                                                        builder: (context) => A0802CustomerOrdersHistory(customerID: customerDataList[j]['CustomerID'], mapDataCustomer: customerDataList[j], mapDataOrders: customerOrderDataList),
                                                                                                      ));

                                                                                                  // Navigator.push(
                                                                                                  //     context,
                                                                                                  //     CupertinoPageRoute(
                                                                                                  //       builder: (context) =>
                                                                                                  //           A0714RejectWidget(),
                                                                                                  //     ));
                                                                                                },
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              customerDataList[j]['ประเภทลูกค้า'] == 'Company' ? customerDataList[j]['ชื่อบริษัท'] : customerDataList[j]['ชื่อนามสกุล'],
                                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                                    fontFamily: 'Kanit',
                                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Spacer(),
                                                                                                    Icon(
                                                                                                      Icons.arrow_forward_ios,
                                                                                                      size: 16,
                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          : SizedBox()
                                                                            ],
                                                                          );
                                                                        }),
                                                                ],
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
