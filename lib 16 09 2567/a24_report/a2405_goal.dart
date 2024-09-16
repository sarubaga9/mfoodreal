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
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class A2405Goal extends StatefulWidget {
  final List<Map<String, dynamic>?>? orderList;
  const A2405Goal({super.key, @required this.orderList});

  @override
  _A2405GoalState createState() => _A2405GoalState();
}

class _A2405GoalState extends State<A2405Goal> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  bool isLoading = false;
  List<Map<String, dynamic>> jobList = [];

  List<Map<String, dynamic>?>? orderList = [];

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    jobList.clear();

    userData = userController.userData;
    orderList = widget.orderList;

    await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'เป้าการขาย'
            : 'เป้าการขาย')
        .where('EmployeeID', isEqualTo: userData!['EmployeeID'])
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>>? data) async {
        if (data != null && data.docs.isNotEmpty) {
          print(data.docs.length);
          for (int index = 0; index < data.docs.length; index++) {
            final Map<String, dynamic> docData =
                data.docs[index].data() as Map<String, dynamic>;

            jobList.add(docData);
          }
        }
      },
    );

    print(jobList.length);

    for (int i = 0; i < jobList!.length; i++) {
      // แปลงสตริงเป็นจำนวนเต็ม
      int month = int.parse(jobList[i]['เดือน']);
      int year = int.parse(jobList[i]['ปี']);

      // สร้างตัวแปร DateTime
      DateTime dateTime = DateTime(year, month);

      jobList[i]['dateTime'] = dateTime;
    }

    // เก็บเดือนและปีปัจจุบัน
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    // ฟังก์ชันจัดเรียง
    jobList.sort((a, b) {
      DateTime dateTimeA = a["dateTime"];
      DateTime dateTimeB = b["dateTime"];

      // ถ้าเดือนและปีของ a ตรงกับเดือนและปีปัจจุบัน
      if (dateTimeA.year == currentYear && dateTimeA.month == currentMonth) {
        return -1; // a จะมาก่อน
      }
      // ถ้าเดือนและปีของ b ตรงกับเดือนและปีปัจจุบัน
      else if (dateTimeB.year == currentYear &&
          dateTimeB.month == currentMonth) {
        return 1; // b จะมาก่อน
      }
      // ถ้าเดือนและปีของ a และ b ไม่ตรงกับเดือนและปีปัจจุบัน
      else {
        return dateTimeA.compareTo(dateTimeB); // จัดเรียงตามวันที่
      }
    });

    print('finish');

    for (int i = 0; i < orderList!.length; i++) {
      print(orderList![i]!['OrdersUpdateTime'].toDate().toString());
      print(orderList![i]!['ยอดรวม']);
    }

    // แปลงสตริง datetime เป็น DateTime ใน Map
    // for (var entry in orderList!) {
    //   if (entry!["SALE_ORDER_ID"] == null) {
    //   } else {
    //     entry!["datetime"] = DateTime.parse(entry!["SALE_ORDER_ID"]);
    //   }
    // }

    orderList!.removeWhere((element) => element!['OrdersUpdateTime'] == null);
    orderList!.removeWhere((element) => element!['SALE_ORDER_ID'] == null);

    for (int i = 0; i < orderList!.length; i++) {
      orderList![i]!["datetime"] = DateTime.parse(
          orderList![i]!['OrdersUpdateTime'].toDate().toString());
      print(orderList![i]!["datetime"]);
    }

    // ใช้ Map เพื่อจัดกลุ่มตามเดือนและปี
    Map<String, List<Map<String, dynamic>>> groupedByMonthAndYear = {};

    for (var entry in orderList!) {
      print('==========');
      print(entry!["datetime"]);
      DateTime dateTime = entry!["datetime"];
      String key =
          DateFormat('yyyy-MM').format(dateTime); // ใช้ yyyy-MM เป็นคีย์
      if (groupedByMonthAndYear.containsKey(key)) {
        groupedByMonthAndYear[key]!.add(entry);
      } else {
        groupedByMonthAndYear[key] = [entry];
      }
    }

    // แปลง Map เป็น List<List<Map<String, dynamic>>>
    List<List<Map<String, dynamic>>> listOfLists =
        groupedByMonthAndYear.values.toList();

    List<Map<String, dynamic>> listData = [];

    // แสดงผล

    for (int i = 0; i < listOfLists.length; i++) {
      listData.add({
        'datetime': listOfLists[i][0]["datetime"],
      });

      double total = 0.0;
      for (var entry in listOfLists[i]) {
        print(entry['มูลค่าสินค้ารวม']);
        total = total + double.parse(entry['มูลค่าสินค้ารวม'].toString());
      }
      listData[i]['ยอดรวมรายเดือน'] = total;

      print(listData[i]);
    }

    for (int i = 0; i < jobList.length; i++) {
      for (int j = 0; j < listData.length; j++) {
        if (jobList[i]['dateTime'].year == listData[j]['datetime'].year &&
            jobList[i]['dateTime'].month == listData[j]['datetime'].month) {
          jobList[i]['ยอดรวมรายเดือน'] = listData[j]['ยอดรวมรายเดือน'];
          break;
        }
      }
    }

    // for (var list in listOfLists) {
    //   print("List for ${DateFormat('yyyy-MM').format(list[0]["datetime"])}:");

    //   for (var entry in list) {
    //     print("  ID: ${entry["id"]}, Datetime: ${entry["datetime"]}");
    //   }
    // }

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
    print('This is A2405 goal');
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
                              'เทียบเป้าการขาย',
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
                                            'วันเวลา',
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
                                            'เป้าการขาย',
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
                                            'ยอดขาย',
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
                                            'คิดเป็น %',
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
                            for (int i = 0; i < jobList.length; i++)
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
                                              '${DateFormat('yyyy-MM').format(jobList[i]['dateTime'])}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 12,
                                                        color: i == 0
                                                            ? Colors
                                                                .blue.shade900
                                                            : Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${jobList[i]['เป้าการขาย']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        color: i == 0
                                                            ? Colors
                                                                .blue.shade900
                                                            : Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              jobList[i]['ยอดรวมรายเดือน'] ==
                                                      null
                                                  ? '0'
                                                  // : '${double.parse(jobList[i]['ยอดรวมรายเดือน'].toString()).toStringAsFixed(0)}',

                                                  : NumberFormat("#,##0").format(
                                                      double.parse(jobList[i]
                                                              ['ยอดรวมรายเดือน']
                                                          .toString())),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        color: i == 0
                                                            ? Colors
                                                                .blue.shade900
                                                            : Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              jobList[i]['ยอดรวมรายเดือน'] ==
                                                      null
                                                  ? '0%'
                                                  : '${((double.parse(jobList[i]['ยอดรวมรายเดือน'].toString()) / double.parse(jobList[i]['เป้าการขาย'].toString())) * 100.00).toStringAsFixed(2)}%',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        color: i == 0
                                                            ? Colors
                                                                .blue.shade900
                                                            : Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //   flex: 3,
                                        //   child: Container(
                                        //     alignment: Alignment.center,
                                        //     child: Text(
                                        //       // '${formatThaiDate(jobList[i]['วันที่เริ่ม'])}',
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
                                        //       // '${formatThaiDate(jobList[i]['วันที่สิ้นสุด'])}',
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
                                          'กลุ่มพนักงาน : ${jobList[i]['ชื่อกลุ่มพนักงาน']}',
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
                                                      '${jobList[i]['พนักงานที่ดูแลลูกค้า']['Name']} ${jobList[i]['พนักงานที่ดูแลลูกค้า']['Surname']}',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                    Text(
                                                      '${jobList[i]['ชื่อกลุ่มพนักงาน']}',
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
                                                          '${jobList[i]['พนักงานที่มอบหมายให้ดูแลแทน']['Name']} ${jobList[i]['พนักงานที่มอบหมายให้ดูแลแทน']['Surname']}',
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
                                                          '${jobList[i]['ชื่อกลุ่มพนักงาน']}',
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

                                                              jobList[i][
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
                                                                        jobList[i]
                                                                            [
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
                                                                initialDate: jobList[i]
                                                                            [
                                                                            'วันที่เริ่ม']
                                                                        .toDate() ??
                                                                    DateTime
                                                                        .now(),
                                                                firstDate: jobList[i]
                                                                            [
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

                                                              jobList[i][
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
                                                                        jobList[i]
                                                                            [
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
                                    .doc(jobList[i]['docId'])
                                    .update({
                                  'IS_ACTIVE': true,
                                  'สร้างโดย': userData!['EmployeeID'],
                                  'สร้างโดยชื่อ':
                                      '${userData!['Name']} ${userData!['Surname']}',
                                  'docId': jobList[i]['docId'],
                                  'ชื่อกลุ่มพนักงาน': jobList[i]
                                      ['ชื่อกลุ่มพนักงาน'],
                                  'พนักงานที่ดูแลลูกค้า': jobList[i]
                                      ['พนักงานที่ดูแลลูกค้า'],
                                  'พนักงานที่มอบหมายให้ดูแลแทน': jobList[i]
                                      ['พนักงานที่มอบหมายให้ดูแลแทน'],
                                  'วันที่สร้าง': jobList[i]['วันที่สร้าง'],
                                  'วันที่สิ้นสุด': jobList[i]['วันที่สิ้นสุด'],
                                  'วันที่เริ่ม': jobList[i]['วันที่เริ่ม'],
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
                                          .doc(jobList[i]['docId'])
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
