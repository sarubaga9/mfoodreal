import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:m_food/a09_customer_open_sale/a0903_product_screen.dart';
import 'package:m_food/a09_customer_open_sale/widget/a0904_product_order_model.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:xml2json/xml2json.dart';

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

class A09021AddressSetting extends StatefulWidget {
  final String? edit;
  final String? customerID;
  final Map<String, dynamic>? orderDataMap;
  const A09021AddressSetting(
      {super.key, this.edit, this.orderDataMap, this.customerID});

  @override
  _A09021AddressSettingState createState() => _A09021AddressSettingState();
}

class _A09021AddressSettingState extends State<A09021AddressSetting> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  // late A0904ProductOrderModel _model;

  final productController = Get.find<ProductController>();
  RxMap<String, dynamic>? productGetData;

  bool isLoading = false;
  late Map<String, dynamic> customerData;

  List<Map<String, dynamic>> resultList = [];

  TextEditingController addressDropdownController = TextEditingController();
  List<Map<String, dynamic>> addressDropdown = [];
  List<String> postalCodeDropdown = [];

  List<String> addressList = ['ตัวเลือก'];
  List<String> addressIDList = ['ตัวเลือก'];
  List<String> tablePriceList = ['ตัวเลือก'];
  int indexAddress = 0;
  String dayCalendar = '';

  TextEditingController daySendDropdownController = TextEditingController();
  List<Map<String, dynamic>> daySendDropdown = [];
  List<String> daySendList = ['ตัวเลือก'];

  TextEditingController waySendDropdownController = TextEditingController();
  List<Map<String, dynamic>> waySendDropdown = [];
  List<String> waySendList = ['ตัวเลือก'];

  List<Map<String, dynamic>?>? waySendListData = [];

  late Map<String, dynamic> orderLast;

  String? postalCode;

  DateTime? dateNow;

  String? dateUpdate = '';
  @override
  void initState() {
    // _model = createModel(context, () => A0904ProductOrderModel());
    fetchData();
    super.initState();
  }

  void fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      print('123');
      print(widget.orderDataMap);

      if (!widget.orderDataMap!.isNotEmpty) {
        print('10');

        // สร้างวันที่แบบสุ่มในระยะเวลา 1 เดือนก่อน ก็ให้ day เป็น 30
        DateTime previousMonth =
            DateTime.now().subtract(Duration(days: 9)); //9 วันก่อน
        DateTime randomDate =
            previousMonth.add(Duration(days: Random().nextInt(9)));
        // แปลงรูปแบบวันที่ให้เป็น UTC (ตัวอย่างเท่านั้น)

        DateTime utcRandomDate = randomDate.toUtc();
        print('1');
        orderLast = {
          'OrdersDateID': DateTime.now().toString(),
          'OrdersUpdateTime': utcRandomDate,
          'สถานที่จัดส่ง': '',
          'วันเวลาจัดส่ง': '',
          'สายส่ง': '',
          'สายส่งโค้ด': '',
          'สายส่งไอดี': '',
          'ProductList': [],
          'ยอดรวม': 0,
        };
        print('2');

        print(orderLast);
        print('33');
      } else {
        orderLast = widget.orderDataMap!;
      }

      print(orderLast);

      CollectionReference subCollectionRef =
          FirebaseFirestore.instance.collection('สายส่ง');

      QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

      subCollectionSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        waySendListData!.add(data);
      });

      waySendListData = (waySendListData ?? [])
          .where((map) => map != null)
          .cast<Map<String, dynamic>>()
          .toList();

      // for (var element in waySendListData!) {
      //   if (element!['IS_ACTIVE'] == true) {
      //     // waySendList.add(element['VHC_DESC']);
      //     waySendList.add('${element['VHC_CODE']} ${element['VHC_DESC']}');
      //   }
      // }

      // print(waySendList);
      // ดึงข้อมูลจาก collection 'Customer'
      DocumentSnapshot customerDoc = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'CustomerTest'
              : 'Customer')
          .doc(widget.customerID)
          .get();

      customerData = customerDoc.data() as Map<String, dynamic>;

      if (customerData != null) {
        print('พบข้อมูลลูกค้า');
        for (var element in customerData['ListCustomerAddress']) {
          addressDropdown.add(element);
          // print(element['ชื่อสาขา']);
          // print(element['รหัสสาขา']);
          // print(element['HouseNumber']);
          // print(element['Moo']);
          // print(element['VillageName']);
          // print(element['Road']);
          // print(element['SubDistrict']);
          // print(element['District']);
          // print(element['Province']);
          // print(element['PostalCode']);
          // print(element['ผู้ติดต่อ']);
          // print(element['ตำแหน่ง']);
          // print(element['โทรศัพท์']);
          print(element['PostalCode'].toString().trim());
          print(element['PostalCode'].toString().trim());
          print(element['PostalCode'].toString().trim());
          print(element['PostalCode'].toString().trim());
          print(element['PostalCode'].toString().trim());

          postalCodeDropdown.add(element['PostalCode'].toString().trim());

          String textAll = element['ชื่อสาขา'].toString().trim() +
              ' ' +
              element['รหัสสาขา'].toString().trim() +
              ' ' +
              element['HouseNumber'].toString().trim() +
              ' ' +
              (element['Moo'] == null ? '' : element['Moo'].toString().trim()) +
              ' ' +
              element['VillageName'].toString().trim() +
              ' ' +
              element['Road'].toString().trim() +
              ' ' +
              element['SubDistrict'].toString().trim() +
              ' ' +
              element['District'].toString().trim() +
              ' ' +
              element['Province'].toString().trim() +
              ' ' +
              element['PostalCode'].toString().trim() +
              ' ' +
              element['ผู้ติดต่อ'].toString().trim() +
              ' ' +
              element['ตำแหน่ง'].toString().trim() +
              ' ' +
              element['โทรศัพท์'].toString().trim();
          addressList.add(textAll.trimLeft().trimRight());

          addressIDList.add(element['ID'].toString().trim());

          tablePriceList.add(element['ตารางราคา'].toString().trim());
        }

        Set<String> uniqueStrings =
            addressList.toSet(); // แปลง List เป็น Set เพื่อลบสตริงที่ซ้ำกัน

        addressList =
            uniqueStrings.toList(); // แปลง Set กลับเป็น List เพื่อใช้งานต่อ

        //=======================================================

        if (widget.edit == 'แก้ไขที่อยู่') {
          indexAddress = -1;
          print(indexAddress);
        } else {
          addressDropdownController.text = orderLast['สถานที่จัดส่ง'].isNotEmpty
              ? orderLast['สถานที่จัดส่ง'].trimLeft().trimRight()
              : 'ตัวเลือก';

          indexAddress = addressList.indexOf(addressDropdownController.text);
          print(indexAddress);
        }

        if (indexAddress == -1) {
          addressDropdownController.text = 'ตัวเลือก';
          waySendDropdownController.text = 'ตัวเลือก';
          daySendDropdownController.text = 'ตัวเลือก';
        } else {
          print('0');
          print(orderLast['วันเวลาจัดส่ง']);
          print(orderLast['วันเวลาจัดส่ง_string']);

          //=======================================================

          if (orderLast['วันเวลาจัดส่ง'] == '') {
            daySendDropdownController.text = 'ตัวเลือก';
          } else {
            daySendDropdownController.text = orderLast['วันเวลาจัดส่ง_string'];
          }

          if (orderLast['วันเวลาจัดส่ง'] != '') {
            DateTime inputDateTime =
                DateTime.parse(daySendDropdownController.text);

            // กำหนดรูปแบบของวันที่และเวลา
            DateFormat outputDateFormat = DateFormat('dd-MM-yyyy');

            // แปลง DateTime เป็นสตริงในรูปแบบ 'dd-MM-yyyy'
            daySendDropdownController.text =
                outputDateFormat.format(inputDateTime);
          }

          dateUpdate = daySendDropdownController.text == 'ตัวเลือก'
              ? ''
              : daySendDropdownController.text;

          // if (orderLast['วันเวลาจัดส่ง'] == '') {
          // } else {
          //   daySendList
          //       .add(formatThaiDate(orderLast['วันเวลาจัดส่ง']).toString());
          // }

          print('1');

          waySendDropdownController.text = orderLast['สายส่ง'].isNotEmpty
              ? orderLast['สายส่ง'].trim()
              : 'ตัวเลือก';

          waySendList.clear();

          waySendList.add('ตัวเลือก');

          print('2');

          String dayName = '';
          if (orderLast['วันเวลาจัดส่ง_day'] == null) {
            dayName = '';
          } else {
            dayName = orderLast['วันเวลาจัดส่ง_day'];
            dayCalendar = dayName;
          }
          print('3');

          if (dayName.isEmpty) {
          } else {
            postalCode = postalCodeDropdown[indexAddress];

            print("รหัสไปรษณีย์: $postalCode");
            // RegExp regex = RegExp(r'\b\d{5}\b');

            // // RegExp regex = RegExp(r' \d{5} ');
            // Match? match = regex.firstMatch(addressDropdownController.text);
            // if (match != null) {
            //   String postalCodeIn = match
            //       .group(0)!
            //       .trim(); // ใช้ trim() เพื่อลบช่องว่างด้านหน้าและด้านหลัง
            //   postalCode = postalCodeIn;

            //   print("รหัสไปรษณีย์: $postalCodeIn");
            // } else {
            //   print("ไม่พบรหัสไปรษณีย์");
            // }

            for (var element in waySendListData!) {
              // print(element![
              //     'พื้นที่จัดส่งรหัสไปรษณีย์สำหรับฟิลเตอร์']);
              if (element!['IS_ACTIVE'] == true) {
                for (var element2
                    in element!['พื้นที่จัดส่งรหัสไปรษณีย์สำหรับฟิลเตอร์']) {
                  if (element2 == postalCode) {
                    // print(element['วันที่จัดส่ง']);

                    if (element['วันที่จัดส่ง']['ส่งทุกวัน']) {
                      waySendList
                          .add('${element['VHC_CODE']} ${element['VHC_DESC']}');
                      // print('ส่งทุกวัน');
                    } else {
                      // print('ส่งไม่ทุกวัน');

                      if (dayName == 'Sunday') {
                        // print('เข้าลูป Sunday');
                        // print(element['วันที่จัดส่ง']['ส่งทุกวันอาทิตย์']);

                        if (element['วันที่จัดส่ง']['ส่งทุกวันอาทิตย์']) {
                          waySendList.add(
                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                        }
                      } else if (dayName == 'Monday') {
                        if (element['วันที่จัดส่ง']['ส่งทุกวันจันทร์']) {
                          waySendList.add(
                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                        }
                      } else if (dayName == 'Tuesday') {
                        // print('เข้าลูป Tuesday');
                        // print(element['วันที่จัดส่ง']['ส่งทุกวันอังคาร']);
                        if (element['วันที่จัดส่ง']['ส่งทุกวันอังคาร']) {
                          waySendList.add(
                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                        }
                      } else if (dayName == 'Wednesday') {
                        if (element['วันที่จัดส่ง']['ส่งทุกวันพุธ']) {
                          waySendList.add(
                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                        }
                      } else if (dayName == 'Thursday') {
                        if (element['วันที่จัดส่ง']['ส่งทุกวันพฤหัสบดี']) {
                          waySendList.add(
                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                        }
                      } else if (dayName == 'Friday') {
                        if (element['วันที่จัดส่ง']['ส่งทุกวันศุกร์']) {
                          waySendList.add(
                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                        }
                      } else if (dayName == 'Saturday') {
                        if (element['วันที่จัดส่ง']['ส่งทุกวันเสาร์']) {
                          waySendList.add(
                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                        }
                      }
                    }

                    // for (var entry
                    //     in element['วันที่จัดส่ง'].entries) {
                    //   if (entry.value) {
                    //     print('${entry.key} เป็นวันส่ง');
                    //   } else {
                    //     print('${entry.key} ไม่เป็นวันส่ง');
                    //   }
                    // }
                  }
                }
              }
            }

            Set<String> uniqueStrings =
                waySendList.toSet(); // แปลง List เป็น Set เพื่อลบสตริงที่ซ้ำกัน

            waySendList =
                uniqueStrings.toList(); // แปลง Set กลับเป็น List เพื่อใช้งานต่อ
          }
          print('4');
        }

        print(indexAddress);
        print(indexAddress);
        print(indexAddress);
        print(indexAddress);
        print(indexAddress);
        print(indexAddress);
        print(indexAddress);

        // ...
      } else {
        // กรณีที่ไม่พบข้อมูล
        print('ไม่พบข้อมูลลูกค้า');
      }
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
    // _model.dispose();
    super.dispose();
  }

  String formatThaiDate(Timestamp timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
    );

    // แปลงปีคริสต์ศักราชเป็นปีพุทธศักราชโดยการเพิ่ม 543
    int thaiYear = dateTime.year;

    // ใช้ intl package เพื่อแปลงรูปแบบวันที่
    String formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime(dateTime.year, dateTime.month, dateTime.day));
    formattedDate = formattedDate.substring(0, formattedDate.length - 4);
    // เพิ่มปีพุทธศักราช
    formattedDate += '$thaiYear';

    // dateUpdate = formattedDate;

    // setState(() {});

    return formattedDate;
  }

  //jak datepicker
  Future<void> bottomPicker(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          DateTime _selectDate = dateNow!;
          return Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: Theme.of(context).textTheme.titleMedium?.merge(
                              TextStyle(
                                  color: Colors.grey, fontFamily: 'Kanit')),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // _model.textController2.text =
                          //     DateFormat('dd').format(_selectDate);
                          // _model.textController3.text =
                          //     DateFormat('MM').format(_selectDate); //budda
                          // _model.textController4.text = (int.parse(
                          //             DateFormat('yyyy').format(_selectDate)) +
                          //         543)
                          //     .toString();

                          dateNow = _selectDate;
                          // Timestamp timestamp = Timestamp.fromDate(dateNow);
                          // formatThaiDate(timestamp);

                          Navigator.pop(context);
                        },
                        child: Text(
                          'ตกลง',
                          style: Theme.of(context).textTheme.titleMedium?.merge(
                              TextStyle(
                                  color: Colors.blueAccent,
                                  fontFamily: 'Kanit')),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 350,
                  child: ScrollDatePicker(
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        _selectDate = value;
                      });
                    },
                    minimumDate: DateTime(DateTime.now().year - 150,
                        DateTime.now().month, DateTime.now().day),
                    maximumDate: DateTime(DateTime.now().year + 10, 12, 31),
                    selectedDate: _selectDate,
                    locale: Locale('th'),
                    viewType: [
                      DatePickerViewType.day,
                      DatePickerViewType.month,
                      DatePickerViewType.year,
                    ],
                    scrollViewOptions: DatePickerScrollViewOptions(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      day: ScrollViewDetailOptions(
                        alignment: Alignment.centerRight,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        // margin: const EdgeInsets.only(right: 10),
                      ),
                      month: ScrollViewDetailOptions(
                        label: '  ',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        // margin: const EdgeInsets.only(right: 10),
                      ),
                      year: ScrollViewDetailOptions(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                        ),
                        // margin: const EdgeInsets.only(right: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  toSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;

    print('==============================');
    print('This is A0903 Product Screen');
    print('==============================');

    print(widget.customerID);
    // print(widget.orderDataMap!['OrdersDateID']);
    productGetData = productController.productData;

    List<Map<String, dynamic>> resultList = [];

    if (productGetData != null) {
      productGetData!.forEach((key, value) {
        Map<String, dynamic> entry = value;
        resultList.add(entry);
      });
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: WillPopScope(
        onWillPop: () async {
          if (widget.edit == 'แก้ไขที่อยู่') {
            return false; // ป้องกันการกดปุ่ม "Back"
          } else {
            return true; // ทำงานตามปกติ
          }
        },
        child: SafeArea(
          top: true,
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularLoading(success: !isLoading),
                  ),
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    // color: Colors.red,
                    height: 1150,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 10.0, 10.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                      widget.edit == 'แก้ไขที่อยู่'
                                          ? SizedBox()
                                          : Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      // context.safePop();

                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(
                                                      Icons.chevron_left,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                              highlightColor:
                                                  Colors.transparent,
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
                                                  color: FlutterFlowTheme.of(
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
                                    'เลือกรายละเอียดการขนส่ง',
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
                                                  // Navigator.pop(context);
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
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

                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 30, 35, 0),
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
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                          //============== Address =====================================
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'กรุณาเลือกสถานที่ในการจัดส่ง',
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

                          StatefulBuilder(builder: (context, setState) {
                            indexAddress = addressList
                                .indexOf(addressDropdownController.text);

                            return Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .accent3
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButtonFormField(
                                value: addressDropdownController
                                    .text, // กำหนดค่าเริ่มต้น
                                items: addressList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  indexAddress = addressList.indexOf(newValue!);

                                  print(indexAddress);
                                  print(indexAddress);
                                  print(indexAddress);
                                  print(indexAddress);
                                  print(indexAddress);
                                  print(indexAddress);
                                  print(indexAddress);

                                  // เมื่อมีการเลือก Dropdown

                                  dateUpdate = '';
                                  waySendDropdownController.text = 'ตัวเลือก';

                                  addressDropdownController.text = newValue!;

                                  print(addressDropdownController.text);
                                  print(addressDropdownController.text);
                                  print(addressDropdownController.text);
                                  print(addressDropdownController.text);
                                  print(addressDropdownController.text);

                                  postalCode =
                                      postalCodeDropdown[indexAddress - 1];

                                  print("รหัสไปรษณีย์: $postalCode");

                                  // RegExp regex = RegExp(r'\b\d{5}\b');
                                  // // RegExp regex = RegExp(r' \d{5} ');
                                  // Match? match = regex.firstMatch(
                                  //     addressDropdownController.text);
                                  // if (match != null) {
                                  //   String postalCodeIn = match
                                  //       .group(0)!
                                  //       .trim(); // ใช้ trim() เพื่อลบช่องว่างด้านหน้าและด้านหลัง
                                  //   postalCode = postalCodeIn;
                                  //   postalCode =
                                  //       postalCodeDropdown[indexAddress];

                                  //   print("รหัสไปรษณีย์: $postalCodeIn");
                                  // } else {
                                  //   print("ไม่พบรหัสไปรษณีย์");
                                  // }

                                  waySendList.clear();
                                  waySendList.add('ตัวเลือก');

                                  for (var element in waySendListData!) {
                                    // print(element![
                                    //     'พื้นที่จัดส่งรหัสไปรษณีย์สำหรับฟิลเตอร์']);
                                    if (element!['IS_ACTIVE'] == true) {
                                      for (var element2 in element![
                                          'พื้นที่จัดส่งรหัสไปรษณีย์สำหรับฟิลเตอร์']) {
                                        // print(element2);
                                        if (element2 == postalCode) {
                                          waySendList.add(
                                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                        }
                                      }
                                    }
                                  }

                                  Set<String> uniqueStrings = waySendList
                                      .toSet(); // แปลง List เป็น Set เพื่อลบสตริงที่ซ้ำกัน

                                  waySendList = uniqueStrings
                                      .toList(); // แปลง Set กลับเป็น List เพื่อใช้งานต่อ

                                  setState(() {});

                                  toSetState();
                                },
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'เลือกสถานที่ในการจัดส่ง',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelStyle: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            );
                          }),

                          //============== date =====================================
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'กรุณาเลือกวันและเวลาในการจัดส่ง',
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

                          StatefulBuilder(builder: (context, setState) {
                            return InkWell(
                              onTap: () async {
                                waySendDropdownController.text = 'ตัวเลือก';
                                // await bottomPicker(context);
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.now(), // กำหนดวันที่เริ่มต้น
                                  firstDate: DateTime
                                      .now(), // กำหนดวันที่แรกที่สามารถเลือกได้
                                  lastDate: DateTime(
                                      2100), // กำหนดวันที่สุดท้ายที่สามารถเลือกได้
                                );

                                // if (picked != null && picked != selectedDate) {
                                //   setState(() {
                                //     selectedDate = picked;
                                //   });
                                // }
                                Timestamp timestamp =
                                    Timestamp.fromDate(picked!);
                                dateUpdate = formatThaiDate(timestamp);

                                // print(dateUpdate);

                                daySendDropdownController.text = dateUpdate!;

                                String dayName =
                                    DateFormat('EEEE').format(picked);

                                dayCalendar = dayName;

                                waySendList.clear();

                                waySendList.add('ตัวเลือก');

                                // print(dayCalendar);
                                // print(postalCode);
                                // print(postalCode);
                                // print(postalCode);

                                for (var element in waySendListData!) {
                                  // print(element![
                                  //     'พื้นที่จัดส่งรหัสไปรษณีย์สำหรับฟิลเตอร์']);
                                  if (element!['IS_ACTIVE'] == true) {
                                    for (var element2 in element![
                                        'พื้นที่จัดส่งรหัสไปรษณีย์สำหรับฟิลเตอร์']) {
                                      if (element2 == postalCode) {
                                        // print(element['วันที่จัดส่ง']);

                                        if (element['วันที่จัดส่ง']
                                            ['ส่งทุกวัน']) {
                                          waySendList.add(
                                              '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                          // print('ส่งทุกวัน');
                                        } else {
                                          // print('ส่งไม่ทุกวัน');

                                          if (dayName == 'Sunday') {
                                            // print('เข้าลูป Sunday');
                                            // print(element['วันที่จัดส่ง']
                                            // ['ส่งทุกวันอาทิตย์']);

                                            if (element['วันที่จัดส่ง']
                                                ['ส่งทุกวันอาทิตย์']) {
                                              waySendList.add(
                                                  '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                            }
                                          } else if (dayName == 'Monday') {
                                            if (element['วันที่จัดส่ง']
                                                ['ส่งทุกวันจันทร์']) {
                                              waySendList.add(
                                                  '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                            }
                                          } else if (dayName == 'Tuesday') {
                                            // print('เข้าลูป Tuesday');
                                            // print(element['วันที่จัดส่ง']
                                            // ['ส่งทุกวันอังคาร']);
                                            if (element['วันที่จัดส่ง']
                                                ['ส่งทุกวันอังคาร']) {
                                              waySendList.add(
                                                  '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                            }
                                          } else if (dayName == 'Wednesday') {
                                            if (element['วันที่จัดส่ง']
                                                ['ส่งทุกวันพุธ']) {
                                              waySendList.add(
                                                  '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                            }
                                          } else if (dayName == 'Thursday') {
                                            if (element['วันที่จัดส่ง']
                                                ['ส่งทุกวันพฤหัสบดี']) {
                                              waySendList.add(
                                                  '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                            }
                                          } else if (dayName == 'Friday') {
                                            if (element['วันที่จัดส่ง']
                                                ['ส่งทุกวันศุกร์']) {
                                              waySendList.add(
                                                  '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                            }
                                          } else if (dayName == 'Saturday') {
                                            if (element['วันที่จัดส่ง']
                                                ['ส่งทุกวันเสาร์']) {
                                              waySendList.add(
                                                  '${element['VHC_CODE']} ${element['VHC_DESC']}');
                                            }
                                          }
                                        }

                                        // for (var entry
                                        //     in element['วันที่จัดส่ง']
                                        //         .entries) {
                                        //   if (entry.value) {
                                        //     print('${entry.key} เป็นวันส่ง');
                                        //   } else {
                                        //     print('${entry.key} ไม่เป็นวันส่ง');
                                        //   }
                                        // }
                                      }
                                    }
                                  }
                                }
                                // print('หาสายส่ง');
                                // print(waySendList);

                                Set<String> uniqueStrings = waySendList
                                    .toSet(); // แปลง List เป็น Set เพื่อลบสตริงที่ซ้ำกัน

                                waySendList = uniqueStrings
                                    .toList(); // แปลง Set กลับเป็น List เพื่อใช้งานต่อ

                                if (waySendList.length <= 1) {
                                  Fluttertoast.showToast(
                                      msg: 'วันนี้ไม่มีสายส่งค่ะ');
                                  waySendDropdownController.text =
                                      waySendList[0];
                                } else {
                                  waySendDropdownController.text =
                                      waySendList[1];
                                }

                                setState(
                                  () {},
                                );
                                toSetState();
                              },
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.2),
                                      width: 2,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .accent3
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 5, 0),
                                        child: Text(
                                          dateUpdate!.isEmpty
                                              ? 'เลือกวันและเวลาในการจัดส่ง'
                                              : dateUpdate!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                      ),
                                      SizedBox(
                                          width: 40,
                                          child: Icon(
                                            Icons.calendar_month,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          )),
                                    ],
                                  )),
                            );
                          }),

                          // // Container(
                          // //   width: MediaQuery.of(context).size.width * 0.9,
                          // //   height: 70,
                          // //   decoration: BoxDecoration(
                          // //     color: FlutterFlowTheme.of(context)
                          // //         .accent3
                          // //         .withOpacity(0.2),
                          // //     borderRadius: BorderRadius.circular(10.0),
                          // //   ),
                          // //   child:
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.9,
                          //   child: TextFormField(
                          //     readOnly: true,
                          //     // controller: _model.textController1Company,
                          //     // focusNode: _model.textFieldFocusNode1Company,
                          //     autofocus: false,
                          //     obscureText: false,
                          //     decoration: InputDecoration(
                          //       label: Text('เลือกวันและเวลาในการจัดส่ง'),
                          //       // labelText: 'ชื่อบริษัn',
                          //       isDense: true,
                          //       labelStyle:
                          //           FlutterFlowTheme.of(context).labelMedium,
                          //       hintText: 'เลือกวันและเวลาในการจัดส่ง',
                          //       hintStyle:
                          //           FlutterFlowTheme.of(context).labelMedium,
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: FlutterFlowTheme.of(context).alternate,
                          //           width: 2.0,
                          //         ),
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: FlutterFlowTheme.of(context).primary,
                          //           width: 2.0,
                          //         ),
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //       errorBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: FlutterFlowTheme.of(context).error,
                          //           width: 2.0,
                          //         ),
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //       focusedErrorBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: FlutterFlowTheme.of(context).error,
                          //           width: 2.0,
                          //         ),
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //     ),
                          //     style: FlutterFlowTheme.of(context).bodyMedium,
                          //     textAlign: TextAlign.start,
                          //     // validator: _model.textController1Validator
                          //     //     .asValidator(context),
                          //   ),
                          // ),
                          // // ),

                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.9,
                          //   decoration: BoxDecoration(
                          //     color: FlutterFlowTheme.of(context)
                          //         .accent3
                          //         .withOpacity(0.2),
                          //     borderRadius: BorderRadius.circular(10.0),
                          //   ),
                          //   child: DropdownButtonFormField(
                          //     value: daySendDropdownController
                          //         .text, // กำหนดค่าเริ่มต้น
                          //     items: daySendList.map((String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(
                          //           value,
                          //           maxLines: 2,
                          //           overflow: TextOverflow.ellipsis,
                          //         ),
                          //       );
                          //     }).toList(),
                          //     onChanged: (String? newValue) {
                          //       // เมื่อมีการเลือก Dropdown
                          //       setState(() {
                          //         daySendDropdownController.text = newValue!;
                          //         print(daySendDropdownController.text);
                          //       });
                          //     },
                          //     isExpanded: true,
                          //     decoration: InputDecoration(
                          //       labelText: 'เลือกวันและเวลาในการจัดส่ง',
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: FlutterFlowTheme.of(context)
                          //                 .secondaryText
                          //                 .withOpacity(0.5)),
                          //         borderRadius: BorderRadius.circular(10.0),
                          //       ),
                          //       labelStyle: TextStyle(
                          //           color: FlutterFlowTheme.of(context)
                          //               .secondaryText),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: FlutterFlowTheme.of(context)
                          //                 .secondaryText
                          //                 .withOpacity(0.5)),
                          //         borderRadius: BorderRadius.circular(10.0),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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

                          StatefulBuilder(builder: (context, setState) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .accent3
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButtonFormField(
                                value: waySendDropdownController
                                    .text, // กำหนดค่าเริ่มต้น
                                items: waySendList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  // เมื่อมีการเลือก Dropdown
                                  setState(() {
                                    waySendDropdownController.text = newValue!;
                                    print(waySendDropdownController.text);
                                  });
                                },
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'เลือกสายส่ง',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelStyle: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            );
                          }),
                          //==============  Confirm Button =====================================
                          Spacer(),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 20.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                // context.pushNamed('A11_06_DataTransfer');

                                print(daySendDropdownController.text);
                                print(daySendDropdownController.text);
                                print(daySendDropdownController.text);

                                if (daySendDropdownController.text ==
                                    'ตัวเลือก') {
                                  Fluttertoast.showToast(
                                    msg: 'กรอกข้อมูลให้ครบค่ะ',
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                } else {
                                  // สร้างรูปแบบของวันที่
                                  DateFormat format = DateFormat('dd-MM-yyyy');

                                  // แปลงสตริงเป็นวัตถุ DateTime
                                  DateTime dateTime = format
                                      .parse(daySendDropdownController.text);

                                  print(DateTime.now());
                                  print(DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day));
                                  if (daySendDropdownController.text ==
                                          'ตัวเลือก' ||
                                      dateTime.isBefore(DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day))) {
                                    print(dateTime.isBefore(DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day)));
                                    Fluttertoast.showToast(
                                      msg:
                                          'กรุณาเลือกวันปัจจุบัน หรือวันหลังจากวันปัจจุบันค่ะ',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else if (addressDropdownController.text ==
                                      'ตัวเลือก') {
                                    Fluttertoast.showToast(
                                      msg: 'กรอกข้อมูลให้ครบค่ะ',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else if (waySendDropdownController.text ==
                                      'ตัวเลือก') {
                                    Fluttertoast.showToast(
                                      msg: 'กรอกข้อมูลให้ครบค่ะ',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else {
                                    orderLast['สถานที่จัดส่ง'] =
                                        addressDropdownController.text ==
                                                'ตัวเลือก'
                                            ? ''
                                            : addressDropdownController.text;

                                    orderLast['วันเวลาจัดส่ง'] =
                                        daySendDropdownController.text ==
                                                'ตัวเลือก'
                                            ? ''
                                            : daySendDropdownController.text;

                                    orderLast['วันเวลาจัดส่ง_day'] =
                                        dayCalendar;

                                    print('object');

                                    print(addressIDList[indexAddress]);
                                    print(addressIDList[indexAddress]);
                                    print('------------------');
                                    for (var element in tablePriceList) {
                                      print(element);
                                    }
                                    print('------------------');

                                    print(tablePriceList[indexAddress]);
                                    print(tablePriceList[indexAddress]);
                                    print(tablePriceList[indexAddress]);
                                    print(tablePriceList[indexAddress]);

                                    orderLast['ListCustomerAddressID'] =
                                        addressIDList[indexAddress] ==
                                                'ตัวเลือก'
                                            ? 'ไม่มีข้อมูล'
                                            : addressIDList[indexAddress];
                                    print(orderLast['ListCustomerAddressID']);

                                    orderLast['ตารางราคา'] =
                                        tablePriceList[indexAddress] ==
                                                'ตัวเลือก'
                                            ? 'ไม่มีข้อมูล'
                                            : tablePriceList[indexAddress];
                                    print(
                                        '12312312342143564678764545324534689765546756542342356553');
                                    print(orderLast['ตารางราคา']);
                                    print(orderLast['ตารางราคา']);
                                    print(orderLast['ตารางราคา']);
                                    print(orderLast['ตารางราคา']);
                                    print(orderLast['ตารางราคา']);

                                    // print(orderLast['สถานที่จัดส่ง']);
                                    // print(orderLast['วันเวลาจัดส่ง']);

                                    Map<String, dynamic>? foundMap = {};

                                    if (waySendDropdownController.text ==
                                        'ตัวเลือก') {
                                      // print(foundMap);
                                    } else {
                                      foundMap = waySendListData?.firstWhere(
                                        (Map<String, dynamic>? map) =>
                                            '${map?['VHC_CODE']} ${map?['VHC_DESC']}'
                                            // map?['VHC_DESC']
                                            ==
                                            waySendDropdownController.text,
                                      );

                                      // print(foundMap);
                                    }

                                    orderLast['สายส่ง'] =
                                        waySendDropdownController.text ==
                                                'ตัวเลือก'
                                            ? ''
                                            : waySendDropdownController.text;
                                    orderLast['สายส่งโค้ด'] =
                                        waySendDropdownController.text ==
                                                'ตัวเลือก'
                                            ? ''
                                            : foundMap!['VHC_CODE'];
                                    orderLast['สายส่งไอดี'] =
                                        waySendDropdownController.text ==
                                                'ตัวเลือก'
                                            ? ''
                                            : foundMap!['VHC_ID'];

                                    orderLast['สายส่ง_วันที่จัดส่ง'] =
                                        waySendDropdownController.text ==
                                                'ตัวเลือก'
                                            ? ''
                                            : foundMap!['วันที่จัดส่ง'];

                                    // print(orderLast['สายส่ง']);
                                    // print(orderLast['สายส่งโค้ด']);
                                    // print(orderLast['สายส่งไอดี']);

                                    print(orderLast['ProductList']);
                                    print(orderLast['ProductList']);
                                    print(orderLast['ProductList']);
                                    print(orderLast['ProductList']);
                                    print(orderLast['ProductList']);
                                    print('success');

                                    if (widget.edit == 'แก้ไขที่อยู่') {
                                      print(orderLast!['ตารางราคา']);
                                      print(orderLast!['ตารางราคา']);
                                      print(orderLast!['ตารางราคา']);
                                      print(orderLast!['ตารางราคา']);
                                      print(orderLast!['ตารางราคา']);

                                      List<Map<String, dynamic>> tableData = [];
                                      Map<String, dynamic>? tableDesc;

                                      var jsonString;
                                      List<Map<String, dynamic>> sellPrices =
                                          [];

                                      QuerySnapshot querySnapshotTable =
                                          await FirebaseFirestore.instance
                                              .collection('ตารางราคา')
                                              .get();

                                      for (int index = 0;
                                          index <
                                              querySnapshotTable.docs.length;
                                          index++) {
                                        final Map<String, dynamic> docData =
                                            querySnapshotTable.docs[index]
                                                .data() as Map<String, dynamic>;

                                        tableData.add(docData);
                                      }
                                      try {
                                        tableDesc =
                                            tableData.firstWhere((element) {
                                          return element['PLIST_DESC2'] ==
                                              orderLast!['ตารางราคา'];
                                        });

                                        print('พบ ');
                                      } catch (e) {
                                        print(orderLast!['ตารางราคา']);

                                        print('ไม่พบ ใน list');
                                      }

                                      try {
                                        HttpsCallable callable2 =
                                            FirebaseFunctions.instance
                                                .httpsCallable('getApiMfood');
                                        var params2 = <String, dynamic>{
                                          "url":
                                              "http://mobile.mfood.co.th:7105/MBServices.asmx?op=Sell_Price",
                                          "xml":
                                              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><Sell_Price xmlns="MFOODMOBILEAPI"><PRICE_LIST>${tableDesc!['PLIST_DESC1'].toString()}</PRICE_LIST></Sell_Price></soap:Body></soap:Envelope>'
                                        };

                                        print(params2['xml']);
                                        print(
                                            '======================================= aaaaa');

                                        await callable2
                                            .call(params2)
                                            .then((value) async {
                                          print(
                                              'ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
                                          if (value.data['status'] ==
                                              'success') {}
                                          // response = value.data;
                                          // productList = value.data['data'];

                                          // print(response.toString());

                                          Xml2Json xml2json = Xml2Json();
                                          xml2json.parse(value.data.toString());

                                          print(xml2json);
                                          jsonString = xml2json.toOpenRally();

                                          print(jsonString);
                                          print('kkkkkkkkkkkkkkkk');

                                          Map<String, dynamic> data =
                                              json.decode(jsonString);

                                          Map<String, dynamic>
                                              sellPriceResponse =
                                              data['Envelope']['Body']
                                                  ['Sell_PriceResponse'];

                                          if (sellPriceResponse[
                                                  'Sell_PriceResult'] ==
                                              'true') {
                                            print('is true');
                                          } else {
                                            sellPrices =
                                                List<Map<String, dynamic>>.from(
                                                    sellPriceResponse[
                                                            'Sell_PriceResult']
                                                        ['SELL_PRICE']);
                                          }

                                          // for (Map<String, dynamic> sellPrice in sellPrices) {
                                          for (int i = 0;
                                              i < sellPrices.length;
                                              i++) {
                                            // print("RESULT: ${sellPrice['RESULT']}");
                                            // print("PRODUCT_ID: ${sellPrice['PRODUCT_ID']}");
                                            // print("SALES_PRICE_ID: ${sellPrice['SALES_PRICE_ID']}");
                                            // print("NAMES: ${sellPrice['NAMES']}");
                                            // print("PRICE: ${sellPrice['PRICE']}");
                                            // print("UNIT: ${sellPrice['UNIT']}");
                                            // print(i);
                                            // print(sellPrices[i]['PRODUCT_ID']);
                                            // print("-------------------");

                                            if (sellPrices[i]['PRODUCT_ID'] ==
                                                '0291056100062') {
                                              // print(sellPrices[i]['PRODUCT_ID']);

                                              // print(sellPrices[i]['NAMES']);
                                              // print(sellPrices[i]['UNIT']);
                                              // print(sellPrices[i]['PRICE']);
                                              // print(sellPrices[i]);
                                            }
                                          }
                                          // int count2 = sellPrices
                                          //     .where((item) => item['PRODUCT_ID'] == '0291056100062')
                                          //     .length;

                                          // print(count2);
                                          // print(count2);
                                          // print(count2);
                                          // print(count2);
                                        }).whenComplete(() async {});
                                      } catch (e) {
                                        print(e);
                                      } finally {
                                        print('call api promotins success');
                                      }

                                      for (int i = 0;
                                          i < orderLast['ProductList'].length;
                                          i++) {
                                        Map<String, dynamic> dataMap =
                                            sellPrices.firstWhere((element) =>
                                                element['PRODUCT_ID'] ==
                                                    orderLast['ProductList'][i]
                                                        ['ProductID'] &&
                                                element['UNIT'] ==
                                                    orderLast['ProductList'][i]
                                                        ['ยูนิต']);

                                        print('12345678');
                                        print(orderLast['ProductList'][i]
                                            ['ราคา']);
                                        print(dataMap['PRICE']);
                                        print('12345678');

                                        orderLast['ProductList'][i]['ราคา'] =
                                            double.parse(dataMap['PRICE'])
                                                .toStringAsFixed(2)
                                                .toString();
                                      }
                                      Navigator.pop(context, orderLast);
                                    } else {
                                      Map<String, dynamic>? result =
                                          await Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    A0903ProductScreen(
                                                  customerID: widget.customerID,
                                                  orderDataMap: orderLast,
                                                ),
                                              )).whenComplete(() {
                                        // orderLast = result!;

                                        // สร้างวันที่แบบสุ่มในระยะเวลา 1 เดือนก่อน ก็ให้ day เป็น 30
                                        DateTime previousMonth = DateTime.now()
                                            .subtract(
                                                Duration(days: 9)); //9 วันก่อน
                                        DateTime randomDate = previousMonth.add(
                                            Duration(
                                                days: Random().nextInt(9)));
                                        DateTime utcRandomDate =
                                            randomDate.toUtc();

                                        orderLast = {
                                          'OrdersDateID':
                                              DateTime.now().toString(),
                                          'OrdersUpdateTime': utcRandomDate,
                                          'สถานที่จัดส่ง': '',
                                          'วันเวลาจัดส่ง': '',
                                          'สายส่ง': '',
                                          'สายส่งโค้ด': '',
                                          'สายส่งไอดี': '',
                                          'ProductList': [],
                                          'ยอดรวม': 0,
                                        };
                                      });
                                    }

                                    if (mounted) {
                                      setState(() {});
                                    }

                                    // Navigator.push(
                                    //     context,
                                    //     CupertinoPageRoute(
                                    //       builder: (context) => A0903ProductScreen(
                                    //           customerID: widget.customerID,
                                    //           orderDataMap: orderLast),
                                    //     ));
                                  }
                                }
                              },
                              text: 'ยืนยัน',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).secondary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Kanit',
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                elevation: 3.0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
