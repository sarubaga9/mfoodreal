import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:m_food/a13_visit_customer_plan/widget/visit_customer_plan_widget.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class A2404Customer extends StatefulWidget {
  final List<Map<String, dynamic>?>? orderList;
  const A2404Customer({super.key, @required this.orderList});

  @override
  _A2404CustomerState createState() => _A2404CustomerState();
}

class _A2404CustomerState extends State<A2404Customer> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  bool isLoading = false;

  List<Map<String, dynamic>?>? orderList = [];

  List<Map<String, dynamic>> dataList = [];

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    userData = userController.userData;
    orderList = widget.orderList;

    orderList!.removeWhere((element) => element!['OrdersUpdateTime'] == null);
    orderList!.removeWhere((element) => element!['SALE_ORDER_ID'] == null);

    for (int i = 0; i < orderList!.length; i++) {
      orderList![i]!["datetime"] = DateTime.parse(
          orderList![i]!['OrdersUpdateTime'].toDate().toString());
      print(orderList![i]!["datetime"]);
    }

    // ใช้ Map เพื่อจัดกลุ่มตามเดือนและปี
    Map<String, List<Map<String, dynamic>>> groupedByID = {};

    for (var entry in orderList!) {
      String key = entry!['CustomerDoc']['CustomerID'];
      if (groupedByID.containsKey(key)) {
        groupedByID[key]!.add(entry);
      } else {
        groupedByID[key] = [entry];
      }
    }

    // แปลง Map เป็น List<List<Map<String, dynamic>>>
    List<List<Map<String, dynamic>>> listOfLists = groupedByID.values.toList();

    for (int i = 0; i < listOfLists.length; i++) {
      print("List for : ${listOfLists[i]}");
      print(listOfLists[i][0]['CustomerDoc']['CustomerID']);
      print(listOfLists[i][0]['CustomerDoc']['ชื่อนามสกุล']);
      print(listOfLists[i][0]['CustomerDoc']['PhoneTypeCountry']);
      print(listOfLists[i][0]['CustomerDoc']['PhoneNumber']);
      dataList.add({
        'รหัสลูกค้า': listOfLists[i][0]['CustomerDoc']['CustomerID'],
        'ชื่อนามสกุล': listOfLists[i][0]['CustomerDoc']['ชื่อนามสกุล'],
        'ประเภทลูกค้า': listOfLists[i][0]['CustomerDoc']['ประเภทลูกค้า'],
        'โทรศัพท์': listOfLists[i][0]['CustomerDoc']['PhoneTypeCountry'] +
            ' ' +
            listOfLists[i][0]['CustomerDoc']['PhoneNumber'],
      });

      double total = 0.0;

      print(total);
      for (var entry in listOfLists[i]) {
        print(double.parse(entry['มูลค่าสินค้ารวม'].toString()));
        total = total + double.parse(entry['มูลค่าสินค้ารวม'].toString());
      }

      dataList.last['ยอดขาย'] = NumberFormat("#,##0").format(total).toString();

      print(dataList.last);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A2404 customer');
    print('==============================');

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
            : Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    10.0, 10.0, 10.0, 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //======================== App Bar ==============================
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
                              'ยอดขายลูกค้า',
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
                                                style:
                                                    FlutterFlowTheme.of(context)
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
                                                style:
                                                    FlutterFlowTheme.of(context)
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
                                                style:
                                                    FlutterFlowTheme.of(context)
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
                                                style:
                                                    FlutterFlowTheme.of(context)
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
                                            backgroundImage:
                                                userData!['Img'] == ''
                                                    ? null
                                                    : NetworkImage(
                                                        userData!['Img']),
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
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                // saveDataForLogout();
                                              },
                                              child: Icon(
                                                Icons.account_circle,
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 30.0, 10.0, 0.0),
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  height: 60,
                                  color: Colors.black87,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ID',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ชื่อ-นามสกุล',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'โทรศัพท์',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ประเภทลูกค้า',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ยอดขาย',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                      ),
                                      // Expanded(
                                      //   flex: 3,
                                      //   child: Container(
                                      //     alignment: Alignment.center,
                                      //     child: Text(
                                      //       'วันที่เริ่ม',
                                      //       style: FlutterFlowTheme.of(context)
                                      //           .titleMedium
                                      //           .override(
                                      //             fontFamily: 'Kanit',
                                      //             fontSize: 12,
                                      //             color: Colors.white,
                                      //           ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Expanded(
                                      //   flex: 3,
                                      //   child: Container(
                                      //     alignment: Alignment.center,
                                      //     child: Text(
                                      //       'วันที่สิ้นสุด',
                                      //       style: FlutterFlowTheme.of(context)
                                      //           .titleMedium
                                      //           .override(
                                      //             fontFamily: 'Kanit',
                                      //             fontSize: 12,
                                      //             color: Colors.white,
                                      //           ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Expanded(
                                      //   flex: 2,
                                      //   child: Container(
                                      //     alignment: Alignment.center,
                                      //     child: Text(
                                      //       'แก้ไข',
                                      //       style: FlutterFlowTheme.of(context)
                                      //           .titleMedium
                                      //           .override(
                                      //             fontFamily: 'Kanit',
                                      //             fontSize: 12,
                                      //             color: Colors.white,
                                      //           ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                            for (int i = 0; i < dataList!.length; i++)
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black.withOpacity(0.3),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${dataList[i]['รหัสลูกค้า']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${dataList[i]['ชื่อนามสกุล']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${dataList[i]['โทรศัพท์']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              dataList[i]['ประเภทลูกค้า'] ==
                                                      'Personal'
                                                  ? 'บุคคลธรรมดา'
                                                  : 'นิติบุคล',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${dataList[i]['ยอดขาย']} บาท',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //   flex: 3,
                                        //   child: Container(
                                        //     alignment: Alignment.center,
                                        //     child: Text(
                                        //       // '${formatThaiDate(orderList![i]['วันที่เริ่ม'])}',
                                        //       'ทดสอบ',
                                        //       style:
                                        //           FlutterFlowTheme.of(context)
                                        //               .titleMedium
                                        //               .override(
                                        //                 fontSize: 12,
                                        //                 fontFamily: 'Kanit',
                                        //                 color: Colors.black,
                                        //               ),
                                        //     ),
                                        //   ),
                                        // ),
                                        // Expanded(
                                        //   flex: 3,
                                        //   child: Container(
                                        //     alignment: Alignment.center,
                                        //     child: Text(
                                        //       // '${formatThaiDate(orderList![i]['วันที่สิ้นสุด'])}',
                                        //       'ทดสอบ',

                                        //       style:
                                        //           FlutterFlowTheme.of(context)
                                        //               .titleMedium
                                        //               .override(
                                        //                 fontSize: 12,
                                        //                 fontFamily: 'Kanit',
                                        //                 color: Colors.black,
                                        //               ),
                                        //     ),
                                        //   ),
                                        // ),
                                        // Expanded(
                                        //   flex: 2,
                                        //   child: GestureDetector(
                                        //     onTap: () async {
                                        //       await chooseTeam(context, i)
                                        //           .whenComplete(
                                        //               () => loadData());
                                        //     },
                                        //     child: Container(
                                        //       alignment: Alignment.center,
                                        //       margin: EdgeInsets.fromLTRB(
                                        //           3, 7, 3, 7),
                                        //       decoration: BoxDecoration(
                                        //           color: Colors.blue.shade900,
                                        //           // border: Border.all(),
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   20)),
                                        //       child: Text(
                                        //         'แก้ไข',
                                        //         style:
                                        //             FlutterFlowTheme.of(context)
                                        //                 .titleMedium
                                        //                 .override(
                                        //                   fontSize: 12,
                                        //                   fontFamily: 'Kanit',
                                        //                   color: Colors.white,
                                        //                 ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<dynamic> chooseTeam(BuildContext context, int i) {
    Map<String, dynamic> chooseEmloyee = {};
    List<Map<String, dynamic>> chooseEmloyeeList = [];

    bool isLoadSaveData = false;

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

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: StatefulBuilder(builder: (context, setState) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: isLoadSaveData
                ? Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const CircularLoading(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //header
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.8,
                                color: Colors.black87,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'กลุ่มพนักงาน : ${orderList![i]!['ชื่อกลุ่มพนักงาน']}',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //เนื้อหา
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    color: null,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ชื่อพนักงานที่ดูแลลูกค้า',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                color: Colors.black,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 5),
                                            child: Row(
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
                                                    Text(
                                                      '${orderList![i]!['พนักงานที่ดูแลลูกค้า']['Name']} ${orderList![i]!['พนักงานที่ดูแลลูกค้า']['Surname']}',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                    Text(
                                                      '${orderList![i]!['ชื่อกลุ่มพนักงาน']}',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'ชื่อพนักงานที่มอบหมายให้ดูแลแทน',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                color: Colors.black,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 5),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${orderList![i]!['พนักงานที่มอบหมายให้ดูแลแทน']['Name']} ${orderList![i]!['พนักงานที่มอบหมายให้ดูแลแทน']['Surname']}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                        ),
                                                        Text(
                                                          '${orderList![i]!['ชื่อกลุ่มพนักงาน']}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Divider(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'ระยะเวลาให้ดูแลแทน',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              final DateTime?
                                                                  picked =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate: DateTime
                                                                        .now()
                                                                    .add(const Duration(
                                                                        days:
                                                                            90)),
                                                              );

                                                              orderList![i]![
                                                                      'วันที่เริ่ม'] =
                                                                  Timestamp
                                                                      .fromDate(
                                                                          picked!);

                                                              setState(
                                                                () {},
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .calendar_month_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    formatThaiDate(
                                                                        orderList![i]![
                                                                            'วันที่เริ่ม']),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Text(
                                                                    'วันเดือนปี ที่เริ่ม',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              final DateTime?
                                                                  picked =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate: orderList![i]![
                                                                            'วันที่เริ่ม']
                                                                        .toDate() ??
                                                                    DateTime
                                                                        .now(),
                                                                firstDate: orderList![i]![
                                                                            'วันที่เริ่ม']
                                                                        .toDate() ??
                                                                    DateTime
                                                                        .now(),
                                                                lastDate: DateTime
                                                                        .now()
                                                                    .add(const Duration(
                                                                        days:
                                                                            90)),
                                                              );

                                                              orderList![i]![
                                                                      'วันที่สิ้นสุด'] =
                                                                  Timestamp
                                                                      .fromDate(
                                                                          picked!);

                                                              setState(
                                                                () {},
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .calendar_month_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    formatThaiDate(
                                                                        orderList![i]![
                                                                            'วันที่สิ้นสุด']),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Text(
                                                                    'วันเดือนปี ที่สิ้นสุด',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //ปุ่ม ยกเลิก และ ยืนยัน
                      Container(
                        height: 60,
                        color: Colors.white,
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                                decoration: BoxDecoration(
                                    color: Colors.red.shade900,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'ยกเลิก',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                setState(
                                  () {},
                                );
                                isLoadSaveData = true;

                                await FirebaseFirestore.instance
                                    .collection(AppSettings.customerType ==
                                            CustomerType.Test
                                        ? 'ประวัติมอบหมายงาน'
                                        : 'ประวัติมอบหมายงาน')
                                    .doc(orderList![i]!['docId'])
                                    .update({
                                  'IS_ACTIVE': true,
                                  'สร้างโดย': userData!['EmployeeID'],
                                  'สร้างโดยชื่อ':
                                      '${userData!['Name']} ${userData!['Surname']}',
                                  'docId': orderList![i]!['docId'],
                                  'ชื่อกลุ่มพนักงาน':
                                      orderList![i]!['ชื่อกลุ่มพนักงาน'],
                                  'พนักงานที่ดูแลลูกค้า':
                                      orderList![i]!['พนักงานที่ดูแลลูกค้า'],
                                  'พนักงานที่มอบหมายให้ดูแลแทน': orderList![i]![
                                      'พนักงานที่มอบหมายให้ดูแลแทน'],
                                  'วันที่สร้าง': orderList![i]!['วันที่สร้าง'],
                                  'วันที่สิ้นสุด':
                                      orderList![i]!['วันที่สิ้นสุด'],
                                  'วันที่เริ่ม': orderList![i]!['วันที่เริ่ม'],
                                });

                                print('---------');

                                if (mounted) {
                                  Navigator.pop(context);
                                  isLoadSaveData = false;
                                  setState(
                                    () {},
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'ยืนยัน',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        color: Colors.white,
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () async {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    // backgroundColor: Colors.red.shade900,
                                    // text: 'คุณยืนยันการลบมอบหมายงานนี้',
                                    title: 'คุณยืนยันการลบมอบหมายงานนี้',
                                    confirmBtnText: 'ยืนยัน',
                                    onConfirmBtnTap: () async {
                                      setState(
                                        () {},
                                      );
                                      isLoadSaveData = true;

                                      Navigator.pop(context);

                                      await FirebaseFirestore.instance
                                          .collection(
                                              AppSettings.customerType ==
                                                      CustomerType.Test
                                                  ? 'ประวัติมอบหมายงาน'
                                                  : 'ประวัติมอบหมายงาน')
                                          .doc(orderList![i]!['docId'])
                                          .delete();

                                      await Future.delayed(
                                          Duration(seconds: 3));

                                      print('---------');

                                      if (mounted) {
                                        isLoadSaveData = false;
                                        setState(
                                          () {},
                                        );
                                        Navigator.pop(context);
                                      }
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(150, 10, 150, 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade900,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'ต้องการลบการมอบหมายงาน',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
