import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_food/a09_customer_open_sale/a0902_customer_history_list.dart';
import 'package:m_food/a09_customer_open_sale/widget/list_open_sale_widget.dart';
import 'package:m_food/a16_wait_order/a1603_order_detail.dart';
import 'package:m_food/a16_wait_order/a160401_search_history.dart';
import 'package:m_food/a16_wait_order/widget/customer_list.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';

class A1604SearchOrder extends StatefulWidget {
  final List<Map<String, dynamic>>? dataOrderList;

  final String? status;

  final bool? checkTeam;
  const A1604SearchOrder({
    super.key,
    this.status,
    @required this.dataOrderList,
    @required this.checkTeam,
  });

  @override
  _A1604SearchOrderState createState() => _A1604SearchOrderState();
}

class _A1604SearchOrderState extends State<A1604SearchOrder> {
  // final scaffoldKeyCustomerList = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  RxMap<String, dynamic>? customerData;

  TextEditingController textControllerFindSaleOrderID = TextEditingController();
  FocusNode textFieldFocusNodeFindSaleOrderID = FocusNode();

  TextEditingController textControllerFindInvoiceNo = TextEditingController();
  FocusNode textFieldFocusNodeFindInvoiceNo = FocusNode();

  TextEditingController textControllerFindCustomerID = TextEditingController();
  FocusNode textFieldFocusNodeFindCustomerID = FocusNode();

  TextEditingController textControllerFindCustmerName = TextEditingController();
  FocusNode textFieldFocusNodeFindCustomerName = FocusNode();

  List<Map<String, dynamic>> customerDataList = [];

  List<Map<String, dynamic>> customerAllDataList = [];

  bool isLoading = false;

  List<Map<String, dynamic>>? mapDataOrdersData = [];

  DateTime? selectedDate = DateTime.now();
  DateTime? selectedDateBefore;
  DateTime? selectedDateAfter;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadData() async {
    try {
      setState(() {
        isLoading = true;
      });
      userData = userController.userData;

      selectedDateBefore = null;
      selectedDateAfter = null;

      mapDataOrdersData = widget.dataOrderList;

      print(mapDataOrdersData!.length);
      print(mapDataOrdersData!.length);
      print(mapDataOrdersData!.length);
      print(mapDataOrdersData!.length);
      print(mapDataOrdersData!.length);

      // QuerySnapshot<Map<String, dynamic>> querySnapshot =
      //     await FirebaseFirestore.instance
      //         .collection(AppSettings.customerType == CustomerType.Test
      //             ? 'CustomerTest'
      //             : 'Customer')
      //         .get();

      // for (QueryDocumentSnapshot customerDoc in querySnapshot.docs) {
      //   Map<String, dynamic> customerData =
      //       customerDoc.data() as Map<String, dynamic>;
      //   customerDataList.add(customerData);
      // }

      // customerDataList
      //     .removeWhere((customerData) => customerData['สถานะ'] == false);

      // // print('A0901 ต้องเปิดคอมเม้นนี้ เพื่อกรองข้อมูลตามจริง');
      // //==================================================
      // // หากเริ่มทำงานจริง ให้เปิดเงื่อนไขนี้ไว้ เพื่อกรองดาต้าจริง
      // customerDataList.removeWhere((customerData) =>
      //     userData!['EmployeeID'] != customerData['รหัสพนักงานขาย']);

      // // customerDataList
      // //     .removeWhere((customerData) => customerData['ค้างชำระ'] == false);

      // //==================================================
      // customerDataList.sort((a, b) {
      //   String nameA = a['ชื่อนามสกุล'];
      //   String nameB = b['ชื่อนามสกุล'];

      //   return nameA.compareTo(nameB);
      // });

      // customerAllDataList = customerDataList;

      // for (int i = 0; i < customerDataList.length; i++) {
      //   // print(i);
      //   CollectionReference subCollectionRefOrder = FirebaseFirestore.instance
      //       .collection(AppSettings.customerType == CustomerType.Test
      //           ? 'CustomerTest/${customerDataList[i]['CustomerID']}/Orders'
      //           : 'Customer/${customerDataList[i]['CustomerID']}/Orders');

      //   QuerySnapshot subCollectionSnapshotOrder =
      //       await subCollectionRefOrder.get();

      //   // print(customerDataList[i]['CustomerID']);

      //   if (subCollectionSnapshotOrder.docs.length == 0) {
      //     // mapDataOrdersData!.add({});
      //   } else {
      //     subCollectionSnapshotOrder.docs.forEach((doc) {
      //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      //       data['CustomerID'] = customerDataList[i]['CustomerID'];
      //       data['CustomerName'] = customerDataList[i]['ชื่อนามสกุล'];

      //       print(data['CustomerName']);

      //       mapDataOrdersData!.add(data);
      //     });
      //   }
      // }

      print(mapDataOrdersData!.length);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
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

  void findSaleOrderID(String id) {
    print(id);

    Map<String, dynamic> mapData = mapDataOrdersData!.firstWhere(
      (element) => element['SALE_ORDER_ID_REF'] == id,
      orElse: () => {},
    );
    print(id);
    print(mapData);

    if (!mapData.isNotEmpty) {
      Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
    } else {
      textControllerFindSaleOrderID.clear();
      textControllerFindCustomerID.clear();
      textControllerFindCustmerName.clear();

      textFieldFocusNodeFindSaleOrderID.unfocus();
      textFieldFocusNodeFindCustomerID.unfocus();
      textFieldFocusNodeFindCustomerName.unfocus();
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => A1603OrderDetail(
              customerID: mapData['CustomerDoc']['CustomerID'],
              orderDataMap: mapData,
              checkTeam: widget.checkTeam,
            ),
          ));
    }
  }

  void findINVOICENO(String id) {
    print(id);

    Map<String, dynamic> mapData = mapDataOrdersData!.firstWhere(
      (element) => element['INVOICE_NO'] == id,
      orElse: () => {},
    );
    print(id);
    print(mapData);

    if (!mapData.isNotEmpty) {
      Fluttertoast.showToast(msg: 'ไม่มี INVOICE NO. นี้ค่ะ');
    } else {
      textControllerFindSaleOrderID.clear();
      textControllerFindCustomerID.clear();
      textControllerFindCustmerName.clear();

      textFieldFocusNodeFindSaleOrderID.unfocus();
      textFieldFocusNodeFindCustomerID.unfocus();
      textFieldFocusNodeFindCustomerName.unfocus();
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => A1603OrderDetail(
              customerID: mapData['CustomerDoc']['CustomerID'],
              orderDataMap: mapData,
              checkTeam: widget.checkTeam,
            ),
          ));
    }
  }

  void findSaleCustomerID(String id) {
    print(id);

    Map<String, dynamic> mapData = mapDataOrdersData!.firstWhere(
      (element) => element['CustomerDoc']['CustomerID'] == id,
      orElse: () => {},
    );
    print(id);
    print(mapData);

    if (!mapData.isNotEmpty) {
      Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
    } else {
      textControllerFindSaleOrderID.clear();
      textControllerFindCustomerID.clear();
      textControllerFindCustmerName.clear();

      textFieldFocusNodeFindSaleOrderID.unfocus();
      textFieldFocusNodeFindCustomerID.unfocus();
      textFieldFocusNodeFindCustomerName.unfocus();
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => A1603OrderDetail(
              customerID: mapData['CustomerDoc']['CustomerID'],
              orderDataMap: mapData,
              checkTeam: widget.checkTeam,
            ),
          ));
    }
  }

  void findSaleCustomerName(String id) {
    print(id);

    Map<String, dynamic> mapData = mapDataOrdersData!.firstWhere(
      (element) => element['CustomerDoc']['ชื่อนามสกุล'] == id,
      orElse: () => {},
    );
    print(id);
    print(mapData);

    if (!mapData.isNotEmpty) {
      Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
    } else {
      textControllerFindSaleOrderID.clear();
      textControllerFindCustomerID.clear();
      textControllerFindCustmerName.clear();

      textFieldFocusNodeFindSaleOrderID.unfocus();
      textFieldFocusNodeFindCustomerID.unfocus();
      textFieldFocusNodeFindCustomerName.unfocus();
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => A1603OrderDetail(
              customerID: mapData['CustomerDoc']['CustomerID'],
              orderDataMap: mapData,
              checkTeam: widget.checkTeam,
            ),
          ));
    }
  }

  Future<void> findAll(String customerID, String customerName,
      DateTime? firstDay, DateTime? lastDay) async {
    print(customerID);
    print(customerName);

    bool firstStringDay = false;
    bool lastStringDay = false;

    if (firstDay == null) {
      firstStringDay = true;
    }

    if (lastDay == null) {
      lastStringDay = true;
    }
    print(firstStringDay.toString());
    print(lastStringDay.toString());

    print(firstDay.toString());
    print(lastDay.toString());

    print(mapDataOrdersData);

    List<Map<String, dynamic>> mapData = [];
    bool check = true;

    if (firstStringDay && lastStringDay) {
      // check = firstDay!.isBefore(lastDay!);
    } else {
      if (!firstStringDay && !lastStringDay) {
        bool checkIn = firstDay!.isBefore(lastDay!);
        check = checkIn;
      } else {
        check = false;
      }
    }

    print(check);

    if (!check) {
      print('1111');

      Fluttertoast.showToast(msg: 'กรุณาเลือกวันตามลำดับค่ะ');
    } else if (customerID == '' &&
        customerName == '' &&
        firstStringDay &&
        lastStringDay) {
      print('1');
      Fluttertoast.showToast(msg: 'กรอกข้อมูลเพื่อการค้นหาค่ะ');
    } else if (!firstStringDay && lastStringDay) {
      print('11');

      Fluttertoast.showToast(msg: 'กรุณาเลือกวันที่ทั้ง 2 วันค่ะ');
    } else if (firstStringDay && !lastStringDay) {
      print('111');

      Fluttertoast.showToast(msg: 'กรุณาเลือกวันที่ทั้ง 2 วันค่ะ');
    } else if (customerID != '' &&
        customerName == '' &&
        lastStringDay &&
        firstStringDay) {
      //ค้นหาแค่รหัสลูกค้า
      print('11111');

      mapData = mapDataOrdersData!
          .where(
            (element) => element['CustomerDoc']['CustomerID'] == customerID,
          )
          .toList();

      if (!mapData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
      } else {
        textControllerFindSaleOrderID.clear();
        textControllerFindCustomerID.clear();
        textControllerFindCustmerName.clear();

        textFieldFocusNodeFindSaleOrderID.unfocus();
        textFieldFocusNodeFindCustomerID.unfocus();
        textFieldFocusNodeFindCustomerName.unfocus();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => A160401SearchHistory(
                  checkTeam: widget.checkTeam, listOrders: mapData),
            ));
      }
    } else if (customerID == '' &&
        customerName != '' &&
        lastStringDay &&
        firstStringDay) {
      //ค้นหาแค่ชื่อลูกค้า
      print('111111');

      mapData = mapDataOrdersData!
          .where(
            // (element) => element['CustomerName'] == customerName,
            (element) =>
                element['CustomerDoc']['ชื่อนามสกุล'].toString().contains(
                      customerName,
                    ),
          )
          .toList();
      if (!mapData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
      } else {
        textControllerFindSaleOrderID.clear();
        textControllerFindCustomerID.clear();
        textControllerFindCustmerName.clear();

        textFieldFocusNodeFindSaleOrderID.unfocus();
        textFieldFocusNodeFindCustomerID.unfocus();
        textFieldFocusNodeFindCustomerName.unfocus();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => A160401SearchHistory(
                  checkTeam: widget.checkTeam, listOrders: mapData),
            ));
      }
    } else if (customerID != '' &&
        customerName != '' &&
        lastStringDay &&
        firstStringDay) {
      //ค้นหาแค่ชื่อลูกค้า && รหัสลูกค้า
      print('1111111');

      mapData = mapDataOrdersData!
          .where(
            (element) =>
                element['CustomerDoc']['ชื่อนามสกุล'] == customerName &&
                element['CustomerDoc']['CustomerID'] == customerID,
          )
          .toList();
      if (!mapData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
      } else {
        textControllerFindSaleOrderID.clear();
        textControllerFindCustomerID.clear();
        textControllerFindCustmerName.clear();

        textFieldFocusNodeFindSaleOrderID.unfocus();
        textFieldFocusNodeFindCustomerID.unfocus();
        textFieldFocusNodeFindCustomerName.unfocus();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => A160401SearchHistory(
                  checkTeam: widget.checkTeam, listOrders: mapData),
            ));
      }
    } else if (customerID != '' &&
        customerName == '' &&
        !lastStringDay &&
        !firstStringDay) {
      //ค้นหาแค่รหัสลูกค้า กับ ระยะเวลา
      print('11111111');

      mapData = mapDataOrdersData!.where((element) {
        DateTime orderDate = DateTime.parse(element['OrdersDateID'].toString());
        return orderDate.isAfter(firstDay!) &&
            orderDate.isBefore(lastDay!) &&
            element['CustomerDoc']['CustomerID'] == customerID;
      }).toList();

      if (!mapData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
      } else {
        textControllerFindSaleOrderID.clear();
        textControllerFindCustomerID.clear();
        textControllerFindCustmerName.clear();

        textFieldFocusNodeFindSaleOrderID.unfocus();
        textFieldFocusNodeFindCustomerID.unfocus();
        textFieldFocusNodeFindCustomerName.unfocus();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => A160401SearchHistory(
                  checkTeam: widget.checkTeam, listOrders: mapData),
            ));
      }
    } else if (customerID == '' &&
        customerName != '' &&
        !lastStringDay &&
        !firstStringDay) {
      //ค้นหาแค่ชื่อลูกค้า กับ ระยะเวลา
      print('111111111');

      mapData = mapDataOrdersData!.where((element) {
        DateTime orderDate = DateTime.parse(element['OrdersDateID'].toString());
        return orderDate.isAfter(firstDay!) &&
            orderDate.isBefore(lastDay!) &&
            // element['CustomerName'] == customerName!;
            element['CustomerDoc']['ชื่อนามสกุล'].toString().contains(
                  customerName,
                );
      }).toList();
      if (!mapData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
      } else {
        textControllerFindSaleOrderID.clear();
        textControllerFindCustomerID.clear();
        textControllerFindCustmerName.clear();

        textFieldFocusNodeFindSaleOrderID.unfocus();
        textFieldFocusNodeFindCustomerID.unfocus();
        textFieldFocusNodeFindCustomerName.unfocus();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => A160401SearchHistory(
                  checkTeam: widget.checkTeam, listOrders: mapData),
            ));
      }
    } else if (customerID == '' &&
        customerName == '' &&
        !lastStringDay &&
        !firstStringDay) {
      //ค้นหาแค่ระยะเวลา
      print('1111111111');
      print('อยู่ตรงนี้');

      mapData = mapDataOrdersData!.where((element) {
        print(element['OrdersDateID']);
        DateTime orderDate = DateTime.parse(element['OrdersDateID'].toString());
        print('ก่อน lastDay');

        print(lastDay);
        print(lastDay);
        print(lastDay);
        print(lastDay);
        print(lastDay);
        return orderDate.isAfter(firstDay!) && orderDate.isBefore(lastDay!);
      }).toList();

      print(mapData.length);
      print(mapData.length);
      print(mapData.length);
      if (!mapData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
      } else {
        textControllerFindSaleOrderID.clear();
        textControllerFindCustomerID.clear();
        textControllerFindCustmerName.clear();

        textFieldFocusNodeFindSaleOrderID.unfocus();
        textFieldFocusNodeFindCustomerID.unfocus();
        textFieldFocusNodeFindCustomerName.unfocus();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => A160401SearchHistory(
                  checkTeam: widget.checkTeam, listOrders: mapData),
            ));
      }
    } else if (customerID != '' &&
        customerName != '' &&
        !lastStringDay &&
        !firstStringDay) {
      //ค้นหาทั้งหมด
      print('11111111111');

      mapData = mapDataOrdersData!.where((element) {
        DateTime orderDate = DateTime.parse(element['OrdersDateID'].toString());
        return orderDate.isAfter(firstDay!) &&
            orderDate.isBefore(lastDay!) &&
            element['CustomerDoc']['CustomerID'] == customerID &&
            // element['CustomerName'] == customerName;
            element['CustomerDoc']['ชื่อนามสกุล']
                .toString()
                .contains(customerName);
      }).toList();

      if (!mapData.isNotEmpty) {
        Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
      } else {
        textControllerFindSaleOrderID.clear();
        textControllerFindCustomerID.clear();
        textControllerFindCustmerName.clear();

        textFieldFocusNodeFindSaleOrderID.unfocus();
        textFieldFocusNodeFindCustomerID.unfocus();
        textFieldFocusNodeFindCustomerName.unfocus();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => A160401SearchHistory(
                  checkTeam: widget.checkTeam, listOrders: mapData),
            ));
      }
    }

    print(mapData.length);

    // if (!mapData.isNotEmpty) {
    //   Fluttertoast.showToast(msg: 'ไม่มีเลขออเดอร์นี้ค่ะ');
    // } else {
    //   textControllerFindSaleOrderID.clear();
    //   textControllerFindCustomerID.clear();
    //   textControllerFindCustmerName.clear();

    //   textFieldFocusNodeFindSaleOrderID.unfocus();
    //   textFieldFocusNodeFindCustomerID.unfocus();
    //   textFieldFocusNodeFindCustomerName.unfocus();
    //   Navigator.push(
    //       context,
    //       CupertinoPageRoute(
    //         builder: (context) => A1603OrderDetail(
    // checkTeam: widget.checkTeam,
    //             customerID: mapData['CustomerID'], orderDataMap: mapData),
    //       ));
    // }
  }

  Future<void> selectDate(
    BuildContext context,
    String day,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        if (day == 'before') {
          DateTime pickedWithEndOfDay = DateTime(selectedDate!.year,
              selectedDate!.month, selectedDate!.day, 0, 0, 0);
          // selectedDate = pickedWithEndOfDay;
          selectedDateBefore = pickedWithEndOfDay;
          // selectedDateBefore = selectedDate;
        } else if (day == 'after') {
          DateTime pickedWithEndOfDay = DateTime(selectedDate!.year,
              selectedDate!.month, selectedDate!.day, 23, 59, 59);
          // selectedDateAfter = selectedDate;
          selectedDateAfter = pickedWithEndOfDay;
        }
      });
    } else {
      setState(() {
        selectedDate = null;
        if (day == 'before') {
          selectedDateBefore = null;
        } else if (day == 'after') {
          selectedDateAfter = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A1604 search order');
    print('==============================');
    print(widget.status);
    userData = userController.userData;
    customerData = customerController.customerData;
    return Scaffold(
      // key: scaffoldKeyCustomerList,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoading
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: CircularLoading(success: !isLoading),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 10.0, 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                'รายชื่อลูกค้า',
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
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
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
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
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

                      SizedBox(
                        height: 50,
                      ),

                      widget.checkTeam!
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'ค้นหาข้อมูลที่เปิดออเดอร์แทน',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                            fontSize: 16,
                                            fontFamily: 'Kanit',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      widget.checkTeam!
                          ? SizedBox(
                              height: 10,
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: MediaQuery.of(context).size.height * 0.18,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '   ค้นหาด้วย Sale Order   ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                                fontSize: 16,
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 12.0, 12.0, 12.0),
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                // onChanged: (value) {
                                                //   findSaleOrderID(
                                                //       textControllerFindSaleOrderID
                                                //           .text);
                                                // },

                                                inputFormatters: [
                                                  UpperCaseTextFormatter(), // ตัวแปลงให้เป็นตัวพิมพ์ใหญ่
                                                ],
                                                controller:
                                                    textControllerFindSaleOrderID,
                                                focusNode:
                                                    textFieldFocusNodeFindSaleOrderID,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  alignLabelWithHint: false,
                                                  hintText:
                                                      'ค้นหาด้วย Sale Order',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                  // suffixIcon: const Icon(
                                                  //   Icons.search,
                                                  // ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                textAlign: TextAlign.center,
                                                // validator:
                                                //     textControllerValidator.asValidator(context),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              findSaleOrderID(
                                                  textControllerFindSaleOrderID
                                                      .text);
                                            },
                                            child: Icon(
                                              Icons.search,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 10)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(12.0),
                                  //   child: Container(
                                  //     width: 800,
                                  //     padding: EdgeInsets.all(8),
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: BorderRadius.circular(16),
                                  //     ),
                                  //     child: Text(
                                  //       'ค้นหาด้วย Sale Order',
                                  //       style: FlutterFlowTheme.of(context)
                                  //           .bodySmall
                                  //           .override(
                                  //             fontSize: 20,
                                  //             fontFamily: 'Kanit',
                                  //             color: FlutterFlowTheme.of(context)
                                  //                 .primaryText,
                                  //           ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () {
                                        findSaleOrderID(
                                            textControllerFindSaleOrderID.text);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade900,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '        กดที่นี่เพื่อค้นหา        ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontSize: 20,
                                                fontFamily: 'Kanit',
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: MediaQuery.of(context).size.height * 0.18,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '   ค้นหาด้วย INVOICE NO.   ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                                fontSize: 16,
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 12.0, 12.0, 12.0),
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                // onChanged: (value) {
                                                //   findSaleOrderID(
                                                //       textControllerFindSaleOrderID
                                                //           .text);
                                                // },

                                                inputFormatters: [
                                                  UpperCaseTextFormatter(), // ตัวแปลงให้เป็นตัวพิมพ์ใหญ่
                                                ],
                                                controller:
                                                    textControllerFindInvoiceNo,
                                                focusNode:
                                                    textFieldFocusNodeFindInvoiceNo,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  alignLabelWithHint: false,
                                                  hintText:
                                                      'ค้นหาด้วย INVOICE NO.',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                  // suffixIcon: const Icon(
                                                  //   Icons.search,
                                                  // ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                textAlign: TextAlign.center,
                                                // validator:
                                                //     textControllerValidator.asValidator(context),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              findINVOICENO(
                                                  textControllerFindInvoiceNo
                                                      .text);
                                            },
                                            child: Icon(
                                              Icons.search,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 10)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(12.0),
                                  //   child: Container(
                                  //     width: 800,
                                  //     padding: EdgeInsets.all(8),
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: BorderRadius.circular(16),
                                  //     ),
                                  //     child: Text(
                                  //       'ค้นหาด้วย Sale Order',
                                  //       style: FlutterFlowTheme.of(context)
                                  //           .bodySmall
                                  //           .override(
                                  //             fontSize: 20,
                                  //             fontFamily: 'Kanit',
                                  //             color: FlutterFlowTheme.of(context)
                                  //                 .primaryText,
                                  //           ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () {
                                        findINVOICENO(
                                            textControllerFindInvoiceNo.text);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade900,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '        กดที่นี่เพื่อค้นหา        ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontSize: 20,
                                                fontFamily: 'Kanit',
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '   ค้นหาด้วย รหัสลูกค้า/ชื่อลูกค้า   ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                                fontSize: 16,
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Container(
                                      // padding: EdgeInsets.all(8),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.white,
                                      //   borderRadius: BorderRadius.circular(16),
                                      // ),
                                      child: Text(
                                        '   รหัสลูกค้า   ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 12.0, 12.0, 12.0),
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  // findName(textControllerFind.text);
                                                },
                                                controller:
                                                    textControllerFindCustomerID,
                                                focusNode:
                                                    textFieldFocusNodeFindCustomerID,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  alignLabelWithHint: false,
                                                  hintText:
                                                      'ค้นหาด้วยรหัสลูกค้า',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                  // suffixIcon: const Icon(
                                                  //   Icons.search,
                                                  // ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                textAlign: TextAlign.center,
                                                // validator:
                                                //     textControllerValidator.asValidator(context),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.search,
                                            color: Colors.grey.shade700,
                                          ),
                                          const SizedBox(width: 10)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(12.0),
                                  //   child: Container(
                                  //     width: 800,
                                  //     padding: EdgeInsets.all(8),
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: BorderRadius.circular(16),
                                  //     ),
                                  //     child: Text(
                                  //       'ค้นหาด้วย Sale Order',
                                  //       style: FlutterFlowTheme.of(context)
                                  //           .bodySmall
                                  //           .override(
                                  //             fontSize: 20,
                                  //             fontFamily: 'Kanit',
                                  //             color: FlutterFlowTheme.of(context)
                                  //                 .primaryText,
                                  //           ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Container(
                                      // padding: EdgeInsets.all(8),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.white,
                                      //   borderRadius: BorderRadius.circular(16),
                                      // ),
                                      child: Text(
                                        '   ชื่อลูกค้า   ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 12.0, 12.0, 12.0),
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 0.0, 8.0, 0.0),
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  // findName(textControllerFind.text);
                                                },
                                                controller:
                                                    textControllerFindCustmerName,
                                                focusNode:
                                                    textFieldFocusNodeFindCustomerName,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  alignLabelWithHint: false,
                                                  hintText:
                                                      'ค้นหาด้วยชื่อลูกค้า โดย ชื่อ-นามสกุล หรือ ชื่อบริษัท',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                  // suffixIcon: const Icon(
                                                  //   Icons.search,
                                                  // ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                textAlign: TextAlign.center,
                                                // validator:
                                                //     textControllerValidator.asValidator(context),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.search,
                                            color: Colors.grey.shade700,
                                          ),
                                          const SizedBox(width: 10)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(12.0),
                                  //   child: Container(
                                  //     width: 800,
                                  //     padding: EdgeInsets.all(8),
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: BorderRadius.circular(16),
                                  //     ),
                                  //     child: Text(
                                  //       'ค้นหาด้วย Sale Order',
                                  //       style: FlutterFlowTheme.of(context)
                                  //           .bodySmall
                                  //           .override(
                                  //             fontSize: 20,
                                  //             fontFamily: 'Kanit',
                                  //             color: FlutterFlowTheme.of(context)
                                  //                 .primaryText,
                                  //           ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Container(
                                      // padding: EdgeInsets.all(8),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.white,
                                      //   borderRadius: BorderRadius.circular(16),
                                      // ),
                                      child: Text(
                                        '   เลือกช่วงเวลาการค้นหา   ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await selectDate(
                                              context,
                                              'before',
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 350,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              selectedDateBefore != null
                                                  ? formatThaiDate(
                                                      Timestamp.fromDate(
                                                          selectedDateBefore!))
                                                  : 'วันที่เริ่ม',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontSize: 20,
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await selectDate(
                                              context,
                                              'after',
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 350,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              selectedDateAfter != null
                                                  ? formatThaiDate(
                                                      Timestamp.fromDate(
                                                          selectedDateAfter!))
                                                  : 'วันที่สิ้นสุด',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontSize: 20,
                                                        fontFamily: 'Kanit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () async {
                                        // if (textControllerFindCustomerID.text !=
                                        //     '') {
                                        // } else if (textControllerFindCustmerName
                                        //         .text !=
                                        //     '') {}
                                        // findSaleOrderID(
                                        //     textControllerFindSaleOrderID.text);
                                        await findAll(
                                          textControllerFindCustomerID.text,
                                          textControllerFindCustmerName.text,
                                          selectedDateBefore,
                                          selectedDateAfter,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade900,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '        กดที่นี่เพื่อค้นหา        ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontSize: 20,
                                                fontFamily: 'Kanit',
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.fromSTEB(
                      //       10.0, 10.0, 10.0, 0.0),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Expanded(
                      //         // flex: 2,
                      //         child: Padding(
                      //           padding: const EdgeInsetsDirectional.fromSTEB(
                      //               0.0, 10.0, 0.0, 0.0),
                      //           child: CustomerList(status: widget.status),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(), // แปลงข้อความทั้งหมดเป็นตัวพิมพ์ใหญ่
      selection: newValue.selection,
    );
  }
}
