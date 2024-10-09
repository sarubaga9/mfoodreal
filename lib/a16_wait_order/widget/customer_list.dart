import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:m_food/a09_customer_open_sale/a0902_customer_history_list.dart';
import 'package:m_food/a16_wait_order/a06001_customer_history_today.dart';
import 'package:m_food/a16_wait_order/a160101_customer_chooseday.dart';
import 'package:m_food/a16_wait_order/a1602_customer_history_order.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/circular_loading_home.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';

class CustomerList extends StatefulWidget {
  final String? status;

  // final List<Map<String, dynamic>?>? dataOrderList;
  // final List<Map<String, dynamic>?>? dataOrderListTeam;

  CustomerList({
    super.key,
    this.status,
    // @required this.dataOrderList,
    // @required this.dataOrderListTeam,
  });

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  TextEditingController textControllerFind = TextEditingController();
  FocusNode textFieldFocusNodeFind = FocusNode();

  List<Map<String, dynamic>> customerDataList = [];

  List<Map<String, dynamic>> customerAllDataList = [];

  bool isLoading = false;

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  List<Map<String, dynamic>?>? mapDataOrdersDataList = [];
  List<Map<String, dynamic>?>? mapDataOrdersDataListTeam = [];

  List<Map<String, dynamic>>? mapDataOrdersDataFirst = [];
  List<Map<String, dynamic>>? mapDataOrdersDataSecond = [];
  List<Map<String, dynamic>>? mapDataOrdersDataThird = [];

  List<Map<String, dynamic>>? mapDataOrdersDataFirstTeam = [];
  List<Map<String, dynamic>>? mapDataOrdersDataSecondTeam = [];
  List<Map<String, dynamic>>? mapDataOrdersDataThirdTeam = [];

  String first = '';
  String second = '';
  String third = '';

  List<String> monthList = [];
  List<String> yearList = [];

  double totalfirst = 0.0;
  double totalsecond = 0.0;
  double totalthird = 0.0;

  // String totalOne = '';
  // String totalTwo = '';
  // String totalThree = '';

  double totalfirstTeam = 0.0;
  double totalsecondTeam = 0.0;
  double totalthirdTeam = 0.0;

  // String totalOneTeam = '';
  // String totalTwoTeam = '';
  // String totalThreeTeam = '';

  DateTime? selectedDate = DateTime.now();

  List<Map<String, dynamic>>? sendMapOne = [];
  List<Map<String, dynamic>>? sendMapTwo = [];
  List<Map<String, dynamic>>? sendMapThree = [];

  List<Map<String, dynamic>>? sendMapOneTeam = [];
  List<Map<String, dynamic>>? sendMapTwoTeam = [];
  List<Map<String, dynamic>>? sendMapThreeTeam = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> selectDate(
      BuildContext context, String month, String year) async {
    final monthNames = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    final int? selectedMonthNumber = monthNames[month];

    final int? yearChoose = int.parse(year);

    final DateTime firstDate = DateTime(yearChoose!, selectedMonthNumber!, 1);
    final DateTime lastDate = DateTime(yearChoose, selectedMonthNumber + 1, 0);

    if (selectedMonthNumber != null) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(yearChoose, selectedMonthNumber),
        firstDate: firstDate,
        lastDate: lastDate,
        initialDatePickerMode: DatePickerMode.day,
        selectableDayPredicate: (DateTime date) {
          return date.month == selectedMonthNumber;
        },
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      } else {
        selectedDate = null;
      }
    }
  }

  // Future<void> selectDate(BuildContext context, String month) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(selectedDate.year - 1),
  //     lastDate: DateTime(selectedDate.year + 1),
  //     selectableDayPredicate: (DateTime date) {
  //       // แปลงชื่อเดือนให้เป็นตัวเลขก่อน
  //       final monthNames = {
  //         'January': 1,
  //         'February': 2,
  //         'March': 3,
  //         'April': 4,
  //         'May': 5,
  //         'June': 6,
  //         'July': 7,
  //         'August': 8,
  //         'September': 9,
  //         'October': 10,
  //         'November': 11,
  //         'December': 12,
  //       };
  //       final selectedMonth = monthNames.keys.firstWhere(
  //         (key) => key.toLowerCase() == month, // เดือนที่ต้องการ (May)
  //         orElse: () => '',
  //       );
  //       final selectedMonthNumber = monthNames[selectedMonth];
  //       return date.month ==
  //           selectedMonthNumber; // เฉพาะเดือนที่ต้องการ (เดือนที่ 5)
  //     },
  //   );
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  String englishToThaiMonth(String englishMonth) {
    final Map<String, String> monthMap = {
      'January': 'มกราคม',
      'February': 'กุมภาพันธ์',
      'March': 'มีนาคม',
      'April': 'เมษายน',
      'May': 'พฤษภาคม',
      'June': 'มิถุนายน',
      'July': 'กรกฎาคม',
      'August': 'สิงหาคม',
      'September': 'กันยายน',
      'October': 'ตุลาคม',
      'November': 'พฤศจิกายน',
      'December': 'ธันวาคม',
    };

    // ค้นหาชื่อเดือนใน Map และคืนค่าชื่อเดือนภาษาไทย
    return monthMap[englishMonth] ?? '';
  }

  void loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // วันที่ปัจจุบัน
      DateTime currentDate = DateTime.now();

      // เดือนปัจจุบัน
      first = DateFormat('MMMM').format(currentDate);

      // เดือนที่ย้อนหลัง 2 เดือน
      DateTime oneMonthsAgo =
          currentDate.subtract(Duration(days: 30)); // 60 วัน = 2 เดือน
      second = DateFormat('MMMM').format(oneMonthsAgo);

      // เดือนที่ย้อนหลัง 2 เดือน
      DateTime twoMonthsAgo =
          currentDate.subtract(Duration(days: 60)); // 60 วัน = 2 เดือน
      third = DateFormat('MMMM').format(twoMonthsAgo);

      yearList.add(DateFormat('yyyy').format(twoMonthsAgo));
      yearList.add(DateFormat('yyyy').format(oneMonthsAgo));
      yearList.add(DateFormat('yyyy').format(currentDate));

      print('เดือนปัจจุบัน: $first');
      print('เดือนก่อนหน้า 2 เดือน: $second');
      print('เดือนก่อนหน้า 2 เดือน: $third');

      monthList.add(third);
      monthList.add(second);
      monthList.add(first);

      userData = userController.userData;

      QuerySnapshot orderSubCollections = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'ReportSalesEndOfDayByTarget'
              : 'ReportSalesEndOfDayByTarget')
          .where('UserDocId', isEqualTo: userData!['EmployeeID'])
          .get();
      Map<String, Map<String, dynamic>> monthlyData = {};

      orderSubCollections.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String monthYear = '${data['year']}-${data['month']}';
        double total = 0.0;
        int countOrder = 0;

        if (data['ยอดรวม'] != null) {
          total = double.parse(data['ยอดรวม'].toString());
        }

        if (data['countOrder'] != null) {
          countOrder = int.parse(data['countOrder'].toString());
        }

        if (monthlyData.containsKey(monthYear)) {
          monthlyData[monthYear]!['total'] += total;
          monthlyData[monthYear]!['countOrder'] += countOrder;
        } else {
          monthlyData[monthYear] = {
            'total': total,
            'countOrder': countOrder,
          };
        }
      });

// แปลง monthlyData เป็น List และเรียงลำดับตามเดือนล่าสุด
      List<Map<String, dynamic>> sortedMonthlyData =
          monthlyData.entries.map((entry) {
        return {
          'monthYear': entry.key,
          'total': entry.value['total'],
          'countOrder': entry.value['countOrder'],
        };
      }).toList();

// เรียงลำดับจากเดือนล่าสุดไปเก่าสุด
      sortedMonthlyData
          .sort((b, a) => a['monthYear'].compareTo(b['monthYear']));

// เลือกเฉพาะ 3 เดือนล่าสุด
      sortedMonthlyData = sortedMonthlyData.take(3).toList();

// จัดรูปแบบข้อมูลสำหรับแสดงผล
      final numberFormat = NumberFormat('#,##0', 'th_TH');
      List<Map<String, String>> formattedMonthlyData =
          sortedMonthlyData.map((data) {
        var parts = data['monthYear'].split('-');
        var year = int.parse(parts[0]);
        var month = int.parse(parts[1]);
        var date = DateTime(year, month);
        var formattedDate = DateFormat('MMMM yyyy', 'th_TH').format(date);
        return {
          'month': formattedDate,
          'total': numberFormat.format(data['total']),
          'countOrder': numberFormat.format(data['countOrder']),
        };
      }).toList();

// ถ้ามีข้อมูลน้อยกว่า 3 เดือน ให้เพิ่ม "-" จนครบ 3 เดือน
      while (formattedMonthlyData.length < 3) {
        formattedMonthlyData.add({
          'month': '-',
          'total': '0',
          'countOrder': '0',
        });
      }

      mapDataOrdersDataList = formattedMonthlyData;

// ตัวอย่างการใช้งาน
      print("3 เดือนล่าสุด (เรียงจากล่าสุดไปเก่าสุด):");
      formattedMonthlyData.forEach((monthData) {
        print(
            '${monthData['month']}: ยอดรวม ${monthData['total']}, จำนวน Order ${monthData['countOrder']}');
      });
      print('หลังโหลด');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    textControllerFind.dispose();
    textFieldFocusNodeFind.unfocus();
    super.dispose();
  }

  void findName(String nameProduct) {
    if (nameProduct.isEmpty) {
      customerDataList = customerAllDataList;
    } else {
      customerDataList = customerAllDataList
          .where((product) =>
              product['ชื่อนามสกุล'].contains(nameProduct) ||
              product['ClientIdจากMfoodAPI'].contains(nameProduct))
          .toList();
    }
    print(nameProduct);
    print(customerDataList.length);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //========================== textfield search =============================

        // Padding(
        //   padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
        //   child: Container(
        //     height: 30.0,
        //     decoration: BoxDecoration(
        //       color: FlutterFlowTheme.of(context).accent3,
        //       borderRadius: BorderRadius.circular(10.0),
        //     ),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: Padding(
        //             padding: const EdgeInsetsDirectional.fromSTEB(
        //                 8.0, 11.0, 8.0, 0.0),
        //             child: TextFormField(
        //               controller: textControllerFind,
        //               // focusNode: textFieldFocusNodeFind,
        //               autofocus: false,
        //               obscureText: false,
        //               decoration: InputDecoration(
        //                 isDense: true,
        //                 labelStyle: FlutterFlowTheme.of(context).labelLarge,
        //                 alignLabelWithHint: false,
        //                 hintText: 'ค้นหาบัญชีบัญชีลูกค้าในระบบ',
        //                 hintStyle: FlutterFlowTheme.of(context).labelLarge,
        //                 enabledBorder: InputBorder.none,
        //                 focusedBorder: InputBorder.none,
        //                 errorBorder: InputBorder.none,
        //                 focusedErrorBorder: InputBorder.none,
        //                 // suffixIcon: const Icon(
        //                 //   Icons.search,
        //                 // ),
        //               ),
        //               style: FlutterFlowTheme.of(context).bodyMedium,
        //               textAlign: TextAlign.center,
        //               // validator:
        //               //     textControllerValidator.asValidator(context),
        //             ),
        //           ),
        //         ),
        //         Icon(
        //           Icons.search,
        //           color: Colors.grey.shade700,
        //         ),
        //         const SizedBox(width: 10)
        //       ],
        //     ),
        //   ),
        // ),
        //========================== รายชื่อลูกค้า ทั้งหมด =============================
        isLoading
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: Center(
                    child: CircularLoading(success: !isLoading),
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 1.0),
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsetsDirectional.fromSTEB(
                    //       0.0, 0.0, 0.0, 10.0),
                    //   child: Container(
                    //     height: 30.0,
                    //     decoration: BoxDecoration(
                    //       color: FlutterFlowTheme.of(context).accent3,
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //           child: Padding(
                    //             padding: const EdgeInsetsDirectional.fromSTEB(
                    //                 8.0, 11.0, 8.0, 0.0),
                    //             child: TextFormField(
                    //               onChanged: (value) {
                    //                 findName(textControllerFind.text);
                    //               },
                    //               controller: textControllerFind,
                    //               focusNode: textFieldFocusNodeFind,
                    //               autofocus: false,
                    //               obscureText: false,
                    //               decoration: InputDecoration(
                    //                 isDense: true,
                    //                 labelStyle:
                    //                     FlutterFlowTheme.of(context).labelLarge,
                    //                 alignLabelWithHint: false,
                    //                 hintText: 'ค้นหาบัญชีบัญชีลูกค้าในระบบ',
                    //                 hintStyle:
                    //                     FlutterFlowTheme.of(context).labelLarge,
                    //                 enabledBorder: InputBorder.none,
                    //                 focusedBorder: InputBorder.none,
                    //                 errorBorder: InputBorder.none,
                    //                 focusedErrorBorder: InputBorder.none,
                    //                 // suffixIcon: const Icon(
                    //                 //   Icons.search,
                    //                 // ),
                    //               ),
                    //               style:
                    //                   FlutterFlowTheme.of(context).bodyMedium,
                    //               textAlign: TextAlign.center,
                    //               // validator:
                    //               //     textControllerValidator.asValidator(context),
                    //             ),
                    //           ),
                    //         ),
                    //         Icon(
                    //           Icons.search,
                    //           color: Colors.grey.shade700,
                    //         ),
                    //         const SizedBox(width: 10)
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                'ประวัติเปิดใบสั่งขายสินค้า',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontSize: 18,
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          for (int i = 0; i < 3; i++)
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.black, // สีของเส้นขอบด้านซ้าย
                                    width: 2.0, // ความหนาของเส้นขอบด้านซ้าย
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        // color: Colors.red,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 70,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ข้อมูลประจำเดือน ${englishToThaiMonth(monthList[i])} ${yearList[i]}',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                      fontSize: 18,
                                                      fontFamily: 'Kanit',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                // elevation:
                                                //     MaterialStateProperty.all(
                                                //         8), // ความสูงของปุ่ม
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // ความโค้งของขอบ
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black.withOpacity(
                                                            0.1)), // สีของปุ่ม
                                              ),
                                              onPressed: () async {
                                                print(i);
                                                await selectDate(
                                                  context,
                                                  i == 0
                                                      ? third
                                                      : i == 1
                                                          ? second
                                                          : first,
                                                  yearList[i],
                                                );
                                                if (selectedDate == null) {
                                                  return;
                                                }

                                                print(selectedDate);

                                                if (mounted) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                }

                                                List<Map<String, dynamic>?>?
                                                    mapDataOrdersDataOld = [];
                                                List<Map<String, dynamic>?>?
                                                    mapDataOrdersDataOldTeam =
                                                    [];

                                                DateTime now = DateTime(
                                                    selectedDate!.year,
                                                    selectedDate!.month,
                                                    selectedDate!.day);
                                                String startOfDay = DateFormat(
                                                        'yyyy-MM-dd 00:00:00.000000')
                                                    .format(now);
                                                String endOfDay = DateFormat(
                                                        'yyyy-MM-dd 23:59:59.999999')
                                                    .format(now);

                                                QuerySnapshot
                                                    orderSubCollections =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(AppSettings
                                                                    .customerType ==
                                                                CustomerType
                                                                    .Test
                                                            ? 'OrdersTest'
                                                            : 'Orders')
                                                        .where('UserDocId',
                                                            isEqualTo: userData![
                                                                'EmployeeID'])
                                                        .where('OrdersDateID',
                                                            isGreaterThanOrEqualTo:
                                                                startOfDay)
                                                        .where('OrdersDateID',
                                                            isLessThan:
                                                                endOfDay)
                                                        .get();

                                                // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
                                                orderSubCollections.docs
                                                    .forEach((doc) {
                                                  Map<String, dynamic> data =
                                                      doc.data() as Map<String,
                                                          dynamic>;
                                                  mapDataOrdersDataOld
                                                      .add(data);
                                                  // orderListTosend!.add(data);
                                                  // print('------------');
                                                  // print(data['INVOICE_NO']);
                                                  // print('------------');
                                                });

                                                QuerySnapshot
                                                    orderSubCollectionsTeam =
                                                    await FirebaseFirestore.instance
                                                        .collection(AppSettings
                                                                    .customerType ==
                                                                CustomerType
                                                                    .Test
                                                            ? 'OrdersTest'
                                                            : 'Orders')
                                                        .where(
                                                            'idผู้เปิดออเดอร์แทน',
                                                            isEqualTo: userData![
                                                                'EmployeeID'])
                                                        .where('OrdersDateID',
                                                            isGreaterThanOrEqualTo:
                                                                startOfDay)
                                                        .where('OrdersDateID',
                                                            isLessThan:
                                                                endOfDay)
                                                        .get();

                                                // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
                                                orderSubCollectionsTeam.docs
                                                    .forEach((doc) {
                                                  Map<String, dynamic> data =
                                                      doc.data() as Map<String,
                                                          dynamic>;
                                                  mapDataOrdersDataOldTeam!
                                                      .add(data);
                                                  // orderListTosendTeam!.add(data);
                                                  // print('------------');
                                                  // print(data);
                                                  // print('------------');
                                                });

                                                //==============================================================
                                                List<Map<String, dynamic>?>?
                                                    sectionID2List = [];

                                                CollectionReference
                                                    sectionID2ListColection =
                                                    FirebaseFirestore.instance
                                                        .collection('Section');

                                                QuerySnapshot
                                                    sectionID2ListSubCollections =
                                                    await sectionID2ListColection
                                                        .get();

                                                // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
                                                sectionID2ListSubCollections
                                                    .docs
                                                    .forEach((doc) {
                                                  Map<String, dynamic> data =
                                                      doc.data() as Map<String,
                                                          dynamic>;
                                                  sectionID2List!.add(data);
                                                });

                                                print('3');
                                                print(mapDataOrdersDataOld!
                                                    .length);
                                                print(mapDataOrdersDataOldTeam!
                                                    .length);

                                                for (int i = 0;
                                                    i <
                                                        mapDataOrdersDataOld!
                                                            .length;
                                                    i++) {
                                                  print(mapDataOrdersDataOld![
                                                      i]!);
                                                  Map<String, dynamic>?
                                                      dataSectionMatch =
                                                      sectionID2List!.firstWhere(
                                                          (element) =>
                                                              element!['ID'] ==
                                                              mapDataOrdersDataOld![
                                                                      i]![
                                                                  'SectionID2']);

                                                  mapDataOrdersDataOld![i]![
                                                          'SectionID2'] =
                                                      dataSectionMatch!['Name'];

                                                  print(mapDataOrdersDataOld![
                                                      i]!['SectionID2']);
                                                }

                                                for (int i = 0;
                                                    i <
                                                        mapDataOrdersDataOldTeam!
                                                            .length;
                                                    i++) {
                                                  Map<String, dynamic>?
                                                      dataSectionMatch =
                                                      sectionID2List!.firstWhere(
                                                          (element) =>
                                                              element!['ID'] ==
                                                              mapDataOrdersDataOldTeam![
                                                                      i]![
                                                                  'SectionID2']);

                                                  mapDataOrdersDataOldTeam![i]![
                                                          'SectionID2'] =
                                                      dataSectionMatch!['Name'];

                                                  print(
                                                      mapDataOrdersDataOldTeam![
                                                          i]!['SectionID2']);
                                                }

                                                print(mapDataOrdersDataOldTeam
                                                    .length);
                                                print(mapDataOrdersDataOld
                                                    .length);
                                                print(selectedDate.toString());

                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          A160101CustomerChooseDay(
                                                              listOrdersTeam:
                                                                  mapDataOrdersDataOldTeam,
                                                              listOrders:
                                                                  mapDataOrdersDataOld,
                                                              date: selectedDate
                                                                  .toString()),
                                                    ));

                                                if (mounted) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                'กดที่นี่เพื่อูรายละเอียด',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontSize: 18,
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'จำนวนการออกออเดอร์',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontSize: 18,
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${i == 0 ? mapDataOrdersDataList![2]!['countOrder'].toString() : i == 1 ? mapDataOrdersDataList![1]!['countOrder'].toString() : mapDataOrdersDataList![0]!['countOrder'].toString()}',

                                              // '${i == 0 ? mapDataOrdersDataThird!.length : i == 1 ? mapDataOrdersDataSecond!.length : mapDataOrdersDataFirst!.length}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontSize: 18,
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'จำนวนยอดเงิน',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontSize: 18,
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${i == 0 ? mapDataOrdersDataList![2]!['total'].toString() : i == 1 ? mapDataOrdersDataList![1]!['total'].toString() : mapDataOrdersDataList![0]!['total'].toString()}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontSize: 18,
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Divider(),
                    SizedBox(
                      height: 50,
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           SizedBox(
                    //             width: 30,
                    //           ),
                    //           Text(
                    //             'ประวัติเปิดใบสั่งขายสินค้า (ที่ได้รับมอบหมาย)',
                    //             style: FlutterFlowTheme.of(context)
                    //                 .bodyLarge
                    //                 .override(
                    //                   fontSize: 18,
                    //                   fontFamily: 'Kanit',
                    //                   color: FlutterFlowTheme.of(context)
                    //                       .primaryText,
                    //                 ),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       for (int i = 0; i < 3; i++)
                    //         Container(
                    //           decoration: BoxDecoration(
                    //             border: Border(
                    //               left: BorderSide(
                    //                 color: Colors.black, // สีของเส้นขอบด้านซ้าย
                    //                 width: 2.0, // ความหนาของเส้นขอบด้านซ้าย
                    //               ),
                    //             ),
                    //           ),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             children: [
                    //               SizedBox(
                    //                 width: 20,
                    //               ),
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 children: [
                    //                   Container(
                    //                     // color: Colors.red,
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.9,
                    //                     height: 70,
                    //                     child: Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Text(
                    //                           'ข้อมูลประจำเดือน กุมภาพันธ์ 2024',
                    //                           style: FlutterFlowTheme.of(
                    //                                   context)
                    //                               .bodyLarge
                    //                               .override(
                    //                                   fontSize: 18,
                    //                                   fontFamily: 'Kanit',
                    //                                   color:
                    //                                       FlutterFlowTheme.of(
                    //                                               context)
                    //                                           .primaryText,
                    //                                   fontWeight:
                    //                                       FontWeight.bold),
                    //                         ),
                    //                         ElevatedButton(
                    //                           style: ButtonStyle(
                    //                             // elevation:
                    //                             //     MaterialStateProperty.all(
                    //                             //         8), // ความสูงของปุ่ม
                    //                             shape:
                    //                                 MaterialStateProperty.all(
                    //                               RoundedRectangleBorder(
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         12), // ความโค้งของขอบ
                    //                               ),
                    //                             ),
                    //                             backgroundColor:
                    //                                 MaterialStateProperty.all(
                    //                                     Colors.black.withOpacity(
                    //                                         0.1)), // สีของปุ่ม
                    //                           ),
                    //                           onPressed: () async {
                    //                             await selectDate(
                    //                               context,
                    //                               i == 0
                    //                                   ? third
                    //                                   : i == 1
                    //                                       ? second
                    //                                       : first,
                    //                               i == 0
                    //                                   ? third
                    //                                   : i == 1
                    //                                       ? second
                    //                                       : first,
                    //                             );
                    //                           },
                    //                           child: Text(
                    //                             'กดที่นี่เพื่อูรายละเอียด',
                    //                             style:
                    //                                 FlutterFlowTheme.of(context)
                    //                                     .bodyLarge
                    //                                     .override(
                    //                                       fontSize: 18,
                    //                                       fontFamily: 'Kanit',
                    //                                       color: FlutterFlowTheme
                    //                                               .of(context)
                    //                                           .primaryText,
                    //                                     ),
                    //                           ),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.9,
                    //                     child: Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.start,
                    //                       children: [
                    //                         Text(
                    //                           'จำนวนการออกออเดอร์',
                    //                           style:
                    //                               FlutterFlowTheme.of(context)
                    //                                   .bodyLarge
                    //                                   .override(
                    //                                     fontSize: 18,
                    //                                     fontFamily: 'Kanit',
                    //                                     color:
                    //                                         FlutterFlowTheme.of(
                    //                                                 context)
                    //                                             .primaryText,
                    //                                   ),
                    //                         ),
                    //                         Spacer(),
                    //                         Text(
                    //                           '${i == 0 ? mapDataOrdersDataThird!.length : i == 1 ? mapDataOrdersDataSecond!.length : mapDataOrdersDataFirst!.length}',
                    //                           style:
                    //                               FlutterFlowTheme.of(context)
                    //                                   .bodyLarge
                    //                                   .override(
                    //                                     fontSize: 18,
                    //                                     fontFamily: 'Kanit',
                    //                                     color:
                    //                                         FlutterFlowTheme.of(
                    //                                                 context)
                    //                                             .primaryText,
                    //                                   ),
                    //                         ),
                    //                         SizedBox(
                    //                           width: 50,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.9,
                    //                     child: Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.start,
                    //                       children: [
                    //                         Text(
                    //                           'จำนวนยอดเงิน',
                    //                           style:
                    //                               FlutterFlowTheme.of(context)
                    //                                   .bodyLarge
                    //                                   .override(
                    //                                     fontSize: 18,
                    //                                     fontFamily: 'Kanit',
                    //                                     color:
                    //                                         FlutterFlowTheme.of(
                    //                                                 context)
                    //                                             .primaryText,
                    //                                   ),
                    //                         ),
                    //                         Spacer(),
                    //                         Text(
                    //                           '${i == 0 ? totalThree.toString() : i == 1 ? totalTwo.toString() : totalOne.toString()}',
                    //                           style:
                    //                               FlutterFlowTheme.of(context)
                    //                                   .bodyLarge
                    //                                   .override(
                    //                                     fontSize: 18,
                    //                                     fontFamily: 'Kanit',
                    //                                     color:
                    //                                         FlutterFlowTheme.of(
                    //                                                 context)
                    //                                             .primaryText,
                    //                                   ),
                    //                         ),
                    //                         SizedBox(
                    //                           width: 50,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //     ],
                    //   ),
                    // ),

                    // for (int i = 0; i < customerDataList.length; i++)
                    //   customerDataList.length == 0
                    //       ? SizedBox()
                    //       : Padding(
                    //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    //           child: InkWell(
                    //             splashColor: Colors.transparent,
                    //             focusColor: Colors.transparent,
                    //             hoverColor: Colors.transparent,
                    //             highlightColor: Colors.transparent,
                    //             onTap: () async {
                    //               Navigator.push(
                    //                   context,
                    //                   CupertinoPageRoute(
                    //                     builder: (context) =>
                    //                         A1602CustomerHistoryOrder(
                    //                       customerID: customerDataList[i]
                    //                           ['CustomerID'],
                    //                       status: widget.status,
                    //                     ),
                    //                   ));
                    //             },
                    //             child: Row(
                    //               mainAxisSize: MainAxisSize.max,
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   children: [
                    //                     Text(
                    //                       customerDataList[i]
                    //                           ['ClientIdจากMfoodAPI'],
                    //                       style: FlutterFlowTheme.of(context)
                    //                           .bodyLarge
                    //                           .override(
                    //                             fontFamily: 'Kanit',
                    //                             color:
                    //                                 FlutterFlowTheme.of(context)
                    //                                     .primaryText,
                    //                           ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   width: 10,
                    //                 ),
                    //                 Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   children: [
                    //                     Text(
                    //                       // customerDataList[i]['ประเภทลูกค้า'] ==
                    //                       //         'Company'
                    //                       //     ? customerDataList[i]['ชื่อบริษัท']
                    //                       //     : customerDataList[i]['ชื่อนามสกุล'],

                    //                       customerDataList[i]['ประเภทลูกค้า'] ==
                    //                               'Company'
                    //                           ? customerDataList[i]
                    //                               ['ชื่อบริษัท']
                    //                           : customerDataList[i]
                    //                               ['ชื่อนามสกุล'],

                    //                       // : '${customerDataList[i]['ชื่อ']} ${customerDataList[i]['นามสกุล']}',
                    //                       style: FlutterFlowTheme.of(context)
                    //                           .bodyLarge
                    //                           .override(
                    //                             fontFamily: 'Kanit',
                    //                             color:
                    //                                 FlutterFlowTheme.of(context)
                    //                                     .primaryText,
                    //                           ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 // Column(
                    //                 //   mainAxisSize: MainAxisSize.max,
                    //                 //   children: [
                    //                 //     Text(
                    //                 //       'ยอดค้างชำระ ${NumberFormat('#,##0').format(customerDataList[i]['รวมยอดค้างชำระ']).toString()} บาท',
                    //                 //       style: FlutterFlowTheme.of(context)
                    //                 //           .bodyLarge
                    //                 //           .override(
                    //                 //             fontFamily: 'Kanit',
                    //                 //             color: FlutterFlowTheme.of(context)
                    //                 //                 .primaryText,
                    //                 //           ),
                    //                 //     ),
                    //                 //     // Icon(
                    //                 //     //   FFIcons.kfileDocumentPlus,
                    //                 //     //   color:
                    //                 //     //       FlutterFlowTheme.of(context).alternate,
                    //                 //     //   size: 24.0,
                    //                 //     // ),
                    //                 //   ],
                    //                 // ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                  ],
                ),
              ),
      ],
    );
  }
}
