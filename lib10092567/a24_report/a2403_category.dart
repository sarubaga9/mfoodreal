import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme.dart';
import 'package:m_food/flutter_flow/flutter_flow_util.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:quickalert/quickalert.dart';

class A2403Category extends StatefulWidget {
  final List<Map<String, dynamic>?>? orderList;

  const A2403Category({
    super.key,
    @required this.orderList,
  });

  @override
  State<A2403Category> createState() => _A2403CategoryState();
}

class _A2403CategoryState extends State<A2403Category> {
  bool isLoading = false;
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> groupList = [];

  String? optionFirst = '';
  String? optionSecond = '';
  String? optionThird = '';

  DateTime? dayChoose;

  List<String?>? optionFirstString = ['รายวัน', 'รายเดือน', 'รายปี'];

  List<bool?>? optionFirstBool = [false, false, false];

  Future<void> getData() async {
    userData = userController.userData;

    isLoading = true;
    setState(() {});

    QuerySnapshot orderSubCollections = await FirebaseFirestore.instance
        // .collection('OrdersTest')
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'กลุ่มสินค้า'
            : 'กลุ่มสินค้า')
        .where('UserDocId', isEqualTo: userData!['EmployeeID'])
        .get();

    // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
    orderSubCollections.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      groupList!.add(data);
    });

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatThaiDate(Timestamp timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
    );

    int thaiYear = dateTime.year + 543;

    String formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime(dateTime.year, dateTime.month, dateTime.day));
    formattedDate = formattedDate.substring(0, formattedDate.length - 4);
    formattedDate += '$thaiYear';

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A2403 category');
    print('==============================');

    userData = userController.userData;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularLoading(),
              )
            : Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    10.0, 10.0, 10.0, 10.0),
                child: Column(
                  children: [
                    appbar(context),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                // border: Border.all(),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'กรุณาเลือกตัวเลือกให้ครบ เพื่อทำการค้นหารายการ',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Kanit',
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StatefulBuilder(
                                        builder: (contextIn, setState) {
                                          return InkWell(
                                            onTap: () {
                                              QuickAlert.show(
                                                barrierDismissible: false,
                                                context: contextIn,
                                                type: QuickAlertType.custom,
                                                // title: '',
                                                cancelBtnText: 'ยกเลิก',
                                                showCancelBtn: true,
                                                onCancelBtnTap: () {
                                                  optionFirstBool = [
                                                    false,
                                                    false,
                                                    false
                                                  ];
                                                  optionFirst = '';
                                                  setState(
                                                    () {},
                                                  );
                                                  Navigator.of(contextIn,
                                                          rootNavigator: true)
                                                      .pop();
                                                },

                                                cancelBtnTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                confirmBtnText: 'ยืนยัน',
                                                confirmBtnColor:
                                                    Colors.blue.shade900,
                                                onConfirmBtnTap: () {
                                                  setState(() {});
                                                  Navigator.of(contextIn,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                                confirmBtnTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                widget: StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          for (int i = 0;
                                                              i <
                                                                  optionFirstString!
                                                                      .length;
                                                              i++)
                                                            Row(
                                                              children: [
                                                                Checkbox(
                                                                  value:
                                                                      optionFirstBool![
                                                                          i],
                                                                  onChanged:
                                                                      (value) {
                                                                    if (i ==
                                                                        0) {
                                                                      optionFirstBool![
                                                                              0] =
                                                                          value;

                                                                      if (optionFirstBool![
                                                                              0] ==
                                                                          true) {
                                                                        optionFirstBool![1] =
                                                                            false;
                                                                        optionFirstBool![2] =
                                                                            false;
                                                                      }

                                                                      optionFirst =
                                                                          'รายวัน';
                                                                    } else if (i ==
                                                                        1) {
                                                                      optionFirstBool![
                                                                              1] =
                                                                          value;

                                                                      if (optionFirstBool![
                                                                              1] ==
                                                                          true) {
                                                                        optionFirstBool![0] =
                                                                            false;
                                                                        optionFirstBool![2] =
                                                                            false;
                                                                      }

                                                                      optionFirst =
                                                                          'รายเดือน';
                                                                    } else if (i ==
                                                                        2) {
                                                                      optionFirstBool![
                                                                              2] =
                                                                          value;

                                                                      if (optionFirstBool![
                                                                              2] ==
                                                                          true) {
                                                                        optionFirstBool![1] =
                                                                            false;
                                                                        optionFirstBool![0] =
                                                                            false;
                                                                      }

                                                                      optionFirst =
                                                                          'รายปี';
                                                                    }
                                                                    if (mounted) {
                                                                      setState(
                                                                        () {},
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  '${optionFirstString![i]}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                }),
                                              );
                                              if (mounted) {
                                                setState(
                                                  () {},
                                                );
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: optionFirst!.isEmpty
                                                    ? Colors.grey.shade900
                                                    : Colors.green.shade900,
                                                // border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                optionFirst!.isEmpty
                                                    ? '     เลือกหน่วยเวลาในการค้นหา     '
                                                    : optionFirst!,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return InkWell(
                                          onTap: () async {
                                            switch (optionFirst) {
                                              case '':
                                                print('Empty option');
                                                break;

                                              case 'รายวัน':
                                                print('Option 1 selected');
                                                dayChoose =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime
                                                                .now()
                                                            .subtract(Duration(
                                                                days: 365 * 5)),
                                                        lastDate:
                                                            DateTime.now());

                                                break;

                                              case 'รายเดือน':
                                                print('Option 2 selected');
                                                break;

                                              case 'รายปี':
                                                print('Option 2 selected');
                                                break;
                                              default:
                                                print('Default option');
                                            }

                                            setState(
                                              () {},
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: optionFirst == ''
                                                  ? Colors.grey.shade900
                                                  : Colors.green.shade900,
                                              // border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              optionFirst == ''
                                                  ? '      เลือกช่วงเวลา      '
                                                  : optionFirst == 'รายวัน'
                                                      ? formatThaiDate(
                                                          Timestamp.fromDate(
                                                              dayChoose!))
                                                      : optionFirst ==
                                                              'รายเดือน'
                                                          ? 'รายเดือน'
                                                          : 'รายปี',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                            ),
                                          ),
                                        );
                                      }),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          // border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '      เลือกกลุ่มสินค้า      ',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade900,
                                          // border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '      ยืนยัน      ',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
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
                                                  fontSize: 12,
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
                                            'พนักงานดูแล',
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
                                            'พนักงานมอบหมาย',
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
                                            'วันที่เริ่ม',
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
                                            'วันที่สิ้นสุด',
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
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'แก้ไข',
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
                                    ],
                                  ),
                                ))
                              ],
                            ),
                            for (int i = 0; i < dataList.length; i++)
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
                                                        fontSize: 12,
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
                                              '${dataList[i]['ชื่อกลุ่มพนักงาน']}',
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
                                              '${dataList[i]['พนักงานที่ดูแลลูกค้า']['Name']} ${dataList[i]['พนักงานที่ดูแลลูกค้า']['Surname']}',
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
                                              '${dataList[i]['พนักงานที่มอบหมายให้ดูแลแทน']['Name']} ${dataList[i]['พนักงานที่มอบหมายให้ดูแลแทน']['Surname']}',
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
                                              '${formatThaiDate(dataList[i]['วันที่เริ่ม'])}',
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
                                              '${formatThaiDate(dataList[i]['วันที่สิ้นสุด'])}',
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
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {},
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
                                                'แก้ไข',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontSize: 12,
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

  Row appbar(BuildContext context) {
    return Row(
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
                      padding: const EdgeInsetsDirectional.fromSTEB(
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
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
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
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Kanit',
                            color: FlutterFlowTheme.of(context).primaryText,
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
              'ยอดขายตามกลุ่มสินค้า',
              style: FlutterFlowTheme.of(context).titleMedium.override(
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
                                      color: FlutterFlowTheme.of(context)
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
                                      color: FlutterFlowTheme.of(context)
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
                                'Last login ${formatThaiDate(userData!['DateUpdate'])}',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
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
                                style: FlutterFlowTheme.of(context).bodySmall,
                              ),
                            ],
                          ),
                  ],
                ),
                userData!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 0.0, 0.0, 0.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            maxRadius: 20,
                            // radius: 1,
                            backgroundImage: userData!['Img'] == ''
                                ? null
                                : NetworkImage(userData!['Img']),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {},
                              child: Icon(
                                Icons.account_circle,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
    );
  }
}
