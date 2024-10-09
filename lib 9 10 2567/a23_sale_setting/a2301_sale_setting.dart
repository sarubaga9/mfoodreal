import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:m_food/a13_visit_customer_plan/widget/visit_customer_plan_widget.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class A2301SaleSetting extends StatefulWidget {
  const A2301SaleSetting({super.key});

  @override
  _A2301SaleSettingState createState() => _A2301SaleSettingState();
}

class _A2301SaleSettingState extends State<A2301SaleSetting> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  bool isLoading = false;
  List<Map<String, dynamic>> jobList = [];

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    userData = userController.userData;

    await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'จัดการทีมขายtest'
            : 'จัดการทีมขาย')
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>>? data) async {
        if (data != null && data.docs.isNotEmpty) {
          print('จำนวนลูกค้าที่มี ');
          print(data.docs.length);
          for (int index = 0; index < data.docs.length; index++) {
            final Map<String, dynamic> docData =
                data.docs[index].data() as Map<String, dynamic>;
            print(docData['หัวหน้างาน'].length);

            for (int i = 0; i < docData['หัวหน้างาน'].length; i++) {
              print(docData['หัวหน้างาน'][i]['EmployeeID']);
              print(docData['หัวหน้างาน'][i]['Name']);
              print(docData['หัวหน้างาน'][i]['Surname']);
              if (docData['หัวหน้างาน'][i]['EmployeeID'] ==
                  userData!['EmployeeID']) {
                jobList.add(docData);
              }
            }
          }
        }
      },
    );

    print(jobList.length);

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
    print('This is A2301 sale setting');
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
                              'จัดการทีมขาย',
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
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ลำดับ',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ชื่อกลุ่มพนักงาน',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
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
                                            'สมาชิกในกลุ่ม',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
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
                                            'จัดการ',
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
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${i + 1}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${jobList[i]['ชื่อกลุ่มพนักงาน']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
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
                                              jobList[i]['สมาชิกในกลุ่ม']
                                                  .length
                                                  .toString(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await chooseTeam(context, i);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  3, 7, 3, 7),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue.shade900,
                                                  // border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                'มอบหมายงาน',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: Colors.white,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    color: null,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'หัวหน้ากลุ่ม ${jobList[i]['หัวหน้างาน'].length} คน',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                color: Colors.black,
                                              ),
                                        ),
                                        for (int j = 0;
                                            j < jobList[i]['หัวหน้างาน'].length;
                                            j++)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${jobList[i]['หัวหน้างาน'][j]['Name']} ${jobList[i]['หัวหน้างาน'][j]['Surname']}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Kanit',
                                                              color:
                                                                  Colors.black,
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
                                                              color:
                                                                  Colors.black,
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
                                                      InkWell(
                                                        onTap: () {
                                                          setState(
                                                            () {
                                                              if (chooseEmloyee
                                                                  .isEmpty) {
                                                                chooseEmloyee =
                                                                    jobList[i][
                                                                        'หัวหน้างาน'][j];
                                                              } else {
                                                                jobList[i]['หัวหน้างาน']
                                                                            [j][
                                                                        'วันที่เริ่มDate'] =
                                                                    DateTime
                                                                        .now();
                                                                jobList[i]['หัวหน้างาน']
                                                                            [j][
                                                                        'วันที่เริ่ม'] =
                                                                    formatThaiDate(
                                                                        Timestamp.fromDate(
                                                                            DateTime.now()));
                                                                jobList[i]['หัวหน้างาน']
                                                                            [j][
                                                                        'วันที่สิ้นสุด'] =
                                                                    formatThaiDate(
                                                                        Timestamp.fromDate(
                                                                            DateTime.now()));

                                                                bool check = chooseEmloyeeList.any((element) =>
                                                                    jobList[i]['หัวหน้างาน']
                                                                            [j][
                                                                        'EmployeeID'] ==
                                                                    element[
                                                                        'EmployeeID']);

                                                                bool checkHead =
                                                                    false;

                                                                chooseEmloyee[
                                                                            'EmployeeID'] ==
                                                                        jobList[i]['หัวหน้างาน'][j]
                                                                            [
                                                                            'EmployeeID']
                                                                    ? checkHead =
                                                                        true
                                                                    : checkHead =
                                                                        false;

                                                                if (!check &&
                                                                    !checkHead) {
                                                                  chooseEmloyeeList
                                                                      .add(jobList[
                                                                              i]
                                                                          [
                                                                          'หัวหน้างาน'][j]);
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          'มีรายชื่อพนักงานคนนี้แล้วค่ะ',
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red
                                                                              .shade900);
                                                                }
                                                              }
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .blue.shade900,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: const Icon(
                                                            Icons.settings,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        Text(
                                          'สมาชิกในกลุ่ม ${jobList[i]['สมาชิกในกลุ่ม'].length} คน',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                color: Colors.black,
                                              ),
                                        ),
                                        for (int j = 0;
                                            j <
                                                jobList[i]['สมาชิกในกลุ่ม']
                                                    .length;
                                            j++)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${jobList[i]['สมาชิกในกลุ่ม'][j]['Name']} ${jobList[i]['สมาชิกในกลุ่ม'][j]['Surname']}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Kanit',
                                                              color:
                                                                  Colors.black,
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
                                                              color:
                                                                  Colors.black,
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
                                                      InkWell(
                                                        onTap: () {
                                                          setState(
                                                            () {
                                                              if (chooseEmloyee
                                                                  .isEmpty) {
                                                                chooseEmloyee =
                                                                    jobList[i][
                                                                        'สมาชิกในกลุ่ม'][j];
                                                              } else {
                                                                jobList[i]['สมาชิกในกลุ่ม']
                                                                            [j][
                                                                        'วันที่เริ่มDate'] =
                                                                    DateTime
                                                                        .now();
                                                                jobList[i]['สมาชิกในกลุ่ม']
                                                                            [j][
                                                                        'วันที่เริ่ม'] =
                                                                    formatThaiDate(
                                                                        Timestamp.fromDate(
                                                                            DateTime.now()));
                                                                jobList[i]['สมาชิกในกลุ่ม']
                                                                            [j][
                                                                        'วันที่สิ้นสุด'] =
                                                                    formatThaiDate(
                                                                        Timestamp.fromDate(
                                                                            DateTime.now()));

                                                                bool check = chooseEmloyeeList.any((element) =>
                                                                    jobList[i]['สมาชิกในกลุ่ม']
                                                                            [j][
                                                                        'EmployeeID'] ==
                                                                    element[
                                                                        'EmployeeID']);

                                                                bool checkHead =
                                                                    false;

                                                                chooseEmloyee[
                                                                            'EmployeeID'] ==
                                                                        jobList[i]['สมาชิกในกลุ่ม'][j]
                                                                            [
                                                                            'EmployeeID']
                                                                    ? checkHead =
                                                                        true
                                                                    : checkHead =
                                                                        false;

                                                                if (!check &&
                                                                    !checkHead) {
                                                                  chooseEmloyeeList
                                                                      .add(jobList[
                                                                              i]
                                                                          [
                                                                          'สมาชิกในกลุ่ม'][j]);
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          'มีรายชื่อพนักงานคนนี้แล้วค่ะ',
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red
                                                                              .shade900);
                                                                }
                                                                // chooseEmloyeeList.add(
                                                                //     jobList[i][
                                                                //             'สมาชิกในกลุ่ม']
                                                                //         [j]);
                                                              }
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .blue.shade900,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: const Icon(
                                                            Icons.settings,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
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
                                          'ชื่อพนักงานที่ดูแลลูกค้า',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                color: Colors.black,
                                              ),
                                        ),
                                        chooseEmloyee.isEmpty
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Text(
                                                        'คุณยังไม่ได้เลือกพนักงานขายที่จะดูแลลูกค้า',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Kanit',
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade400,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${chooseEmloyee['Name']} ${chooseEmloyee['Surname']}',
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
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(
                                                                () {
                                                                  chooseEmloyee =
                                                                      {};
                                                                },
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .red
                                                                    .shade900,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: const Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )
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
                                        chooseEmloyeeList.isEmpty
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Text(
                                                        'คุณยังไม่ได้เลือกพนักงานขายที่จะดูแลลูกค้า',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Kanit',
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  for (int k = 0;
                                                      k <
                                                          chooseEmloyeeList
                                                              .length;
                                                      k++)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade400,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
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
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${chooseEmloyeeList[k]['Name']} ${chooseEmloyeeList[k]['Surname']}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${jobList[i]['ชื่อกลุ่มพนักงาน']}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                          () {
                                                                            chooseEmloyeeList.removeAt(k);
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .red
                                                                              .shade900,
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                        ),
                                                                        padding:
                                                                            EdgeInsets.all(15),
                                                                        margin:
                                                                            EdgeInsets.all(5),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5,
                                                                      right: 5),
                                                              child: Divider(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'ระยะเวลาให้ดูแลแทน',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          final DateTime?
                                                                              picked =
                                                                              await showDatePicker(
                                                                            context:
                                                                                context,
                                                                            initialDate:
                                                                                DateTime.now(),
                                                                            firstDate:
                                                                                DateTime.now(),
                                                                            lastDate:
                                                                                DateTime.now().add(const Duration(days: 90)),
                                                                          );

                                                                          chooseEmloyeeList[k]['วันที่เริ่ม'] =
                                                                              formatThaiDate(Timestamp.fromDate(picked!));

                                                                          chooseEmloyeeList[k]['วันที่เริ่มDate'] =
                                                                              picked;

                                                                          setState(
                                                                            () {},
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.black,
                                                                            borderRadius:
                                                                                BorderRadius.circular(6),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.calendar_month_outlined,
                                                                                color: Colors.white,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                chooseEmloyeeList[k]['วันที่เริ่ม'],
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      fontFamily: 'Kanit',
                                                                                      color: Colors.white,
                                                                                    ),
                                                                              ),
                                                                              const Spacer(),
                                                                              Text(
                                                                                'วันเดือนปี ที่เริ่ม',
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      fontFamily: 'Kanit',
                                                                                      color: Colors.white,
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
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          final DateTime?
                                                                              picked =
                                                                              await showDatePicker(
                                                                            context:
                                                                                context,
                                                                            initialDate:
                                                                                chooseEmloyeeList[k]['วันที่เริ่มDate'] ?? DateTime.now(),
                                                                            firstDate:
                                                                                chooseEmloyeeList[k]['วันที่เริ่มDate'] ?? DateTime.now(),
                                                                            lastDate:
                                                                                DateTime.now().add(const Duration(days: 90)),
                                                                          );

                                                                          chooseEmloyeeList[k]['วันที่สิ้นสุด'] =
                                                                              formatThaiDate(Timestamp.fromDate(picked!));

                                                                          chooseEmloyeeList[k]['วันที่สิ้นสุดDate'] =
                                                                              picked;

                                                                          setState(
                                                                            () {},
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.black,
                                                                            borderRadius:
                                                                                BorderRadius.circular(6),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.calendar_month_outlined,
                                                                                color: Colors.white,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                chooseEmloyeeList[k]['วันที่สิ้นสุด'],
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      fontFamily: 'Kanit',
                                                                                      color: Colors.white,
                                                                                    ),
                                                                              ),
                                                                              const Spacer(),
                                                                              Text(
                                                                                'วันเดือนปี ที่สิ้นสุด',
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      fontFamily: 'Kanit',
                                                                                      color: Colors.white,
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
                                                ],
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

                                // await Future.delayed(
                                //     const Duration(seconds: 5));

                                // 202404220928213140

                                for (int m = 0;
                                    m < chooseEmloyeeList.length;
                                    m++) {
                                  // DateFormat dateFormat =
                                  //     DateFormat('yyyyMMdd');
                                  DateFormat dateFormat =
                                      DateFormat('yyyyMMddHHmmssSSS');
                                  String formattedDate =
                                      dateFormat.format(DateTime.now());

                                  // formattedDate =
                                  //     '$formattedDate${userData!['EmployeeID']}';

                                  // chooseEmloyeeList[m].forEach((key, value) {
                                  //   print('Key: $key, Value: $value');
                                  // });

                                  await FirebaseFirestore.instance
                                      .collection(AppSettings.customerType ==
                                              CustomerType.Test
                                          ? 'ประวัติมอบหมายงาน'
                                          : 'ประวัติมอบหมายงาน')
                                      .doc(formattedDate)
                                      .set({
                                    'IS_ACTIVE': true,
                                    'สร้างโดย': userData!['EmployeeID'],
                                    'สร้างโดยชื่อ':
                                        '${userData!['Name']} ${userData!['Surname']}',
                                    'docId': formattedDate,
                                    'ชื่อกลุ่มพนักงาน': jobList[i]
                                        ['ชื่อกลุ่มพนักงาน'],
                                    'พนักงานที่ดูแลลูกค้า': chooseEmloyee,
                                    'พนักงานที่มอบหมายให้ดูแลแทน':
                                        chooseEmloyeeList[m],
                                    'วันที่สร้าง': DateTime.now(),
                                    'วันที่สิ้นสุด': chooseEmloyeeList[m]
                                        ['วันที่สิ้นสุดDate'],
                                    'วันที่เริ่ม': chooseEmloyeeList[m]
                                        ['วันที่เริ่มDate'],
                                  });

                                  print('finish $m');
                                  print('---------');
                                }

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
                      )
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
