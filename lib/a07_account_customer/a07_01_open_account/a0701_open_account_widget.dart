import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_food/a07_account_customer/a07_01_open_account/a070101_pdpa_account_widget.dart';
import 'package:m_food/a07_account_customer/a07_13_accept/a0714_reject_widget.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:uuid/uuid.dart';

import '/components/appbar_o_pen_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/components/open_accout_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'a0701_open_account_model.dart';
export 'a0701_open_account_model.dart';

class A0701OpenAccountWidget extends StatefulWidget {
  const A0701OpenAccountWidget({Key? key}) : super(key: key);

  @override
  _A0701OpenAccountWidgetState createState() => _A0701OpenAccountWidgetState();
}

class _A0701OpenAccountWidgetState extends State<A0701OpenAccountWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();

  bool isLoading = false;

  List<Map<String, dynamic>> customerAll = [];

  List<Map<String, dynamic>> customerAllSave = [];
  List<Map<String, dynamic>> customerAllApprove = [];
  List<Map<String, dynamic>> customerAllWaiting = [];
  List<Map<String, dynamic>> customerAllNoApplove = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      userData = userController.userData;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'CustomerTest'
              : 'Customer')
          .get();

      for (int index = 0; index < querySnapshot.docs.length; index++) {
        final Map<String, dynamic> docData =
            querySnapshot.docs[index].data() as Map<String, dynamic>;

        customerAll.add(docData);
      }

      print(customerAll.length);

      //================================================================

      customerAllSave = customerAll
          .where((customer) =>
              customer['บันทึกพร้อมตรวจ'] == true &&
              userData!['EmployeeID'] == customer['รหัสพนักงานขาย'])
          .toList();

      print(customerAllSave.length);
      //================================================================
      customerAllApprove = customerAll
          .where((customer) =>
              customer['สถานะ'] == true &&
              customer['บันทึกพร้อมตรวจ'] == false &&
              userData!['EmployeeID'] == customer['รหัสพนักงานขาย'])
          .toList();

      print(customerAllApprove.length);
      //================================================================

      customerAllWaiting = customerAll
          .where((customer) =>
              customer['รอการอนุมัติ'] == true &&
              userData!['EmployeeID'] == customer['รหัสพนักงานขาย'])
          .toList();

      print(customerAllWaiting.length);
      //================================================================

      customerAllNoApplove = customerAll
          .where((customer) =>
              customer['สถานะ'] == false &&
              customer['บันทึกพร้อมตรวจ'] == false &&
              customer['รอการอนุมัติ'] == false &&
              userData!['EmployeeID'] == customer['รหัสพนักงานขาย'])
          .toList();

      print(customerAllNoApplove.length);
      //================================================================
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('loading a0701 error');
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A0701 open account Screen');
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

    // List<Map<String, dynamic>> currentData = [
    //   {
    //     'CustomerID': '97ee76fc-cbd0-471e-9fee-255da84f0fc2',
    //     'DateCreate': DateTime.now(),
    //     'Detail': 'ทดสอบคอมเม้น',
    //     'DocId': '20240110102607',
    //     'PositionName': 'ผู้อนุมัติคนที่ 5',
    //     'SectionID': '20231208151899',
    //     'UserId': '1402640188',
    //     'UserName': 'สวิตต์ ศิลปคัมภีรภาพ',
    //     'Approve': true,
    //     'ยื่นเอกสารใหม่': true,
    //   },
    //   {
    //     'CustomerID': '97ee76fc-cbd0-471e-9fee-255da84f0fc2',
    //     'DateCreate': DateTime.now(),
    //     'Detail': 'ทดสอบคอมเม้น',
    //     'DocId': '20240110102608',
    //     'PositionName': 'ผู้อนุมัติคนที่ 4',
    //     'SectionID': '20231208151899',
    //     'UserId': '1402640188',
    //     'UserName': 'สวิตต์ ศิลปคัมภีรภาพ',
    //     'Approve': true,
    //     'ยื่นเอกสารใหม่': true,
    //   },
    //   {
    //     'CustomerID': '97ee76fc-cbd0-471e-9fee-255da84f0fc2',
    //     'DateCreate': DateTime.now(),
    //     'Detail': 'ทดสอบคอมเม้น',
    //     'DocId': '20240110102609',
    //     'PositionName': 'ผู้อนุมัติคนที่ 3',
    //     'SectionID': '20231208151899',
    //     'UserId': '1402640188',
    //     'UserName': 'สวิตต์ ศิลปคัมภีรภาพ',
    //     'Approve': true,
    //     'ยื่นเอกสารใหม่': true,
    //   },
    //   {
    //     'CustomerID': '97ee76fc-cbd0-471e-9fee-255da84f0fc2',
    //     'DateCreate': DateTime.now(),
    //     'Detail': 'ทดสอบคอมเม้น',
    //     'DocId': '20240110102610',
    //     'PositionName': 'ผู้อนุมัติคนที่ 2',
    //     'SectionID': '20231208151899',
    //     'UserId': '1402640188',
    //     'UserName': 'สวิตต์ ศิลปคัมภีรภาพ',
    //     'Approve': true,
    //     'ยื่นเอกสารใหม่': true,
    //   },
    //   {
    //     'CustomerID': '97ee76fc-cbd0-471e-9fee-255da84f0fc2',
    //     'DateCreate': DateTime.now(),
    //     'Detail': 'ทดสอบคอมเม้น',
    //     'DocId': '20240110102611',
    //     'PositionName': 'ผู้อนุมัติคนที่ 1',
    //     'SectionID': '20231208151899',
    //     'UserId': '1402640188',
    //     'UserName': 'สวิตต์ ศิลปคัมภีรภาพ',
    //     'Approve': true,
    //     'ยื่นเอกสารใหม่': true,
    //   },
    //   {
    //     'CustomerID': '97ee76fc-cbd0-471e-9fee-255da84f0fc2',
    //     'DateCreate': DateTime.now(),
    //     'Detail': 'ทดสอบคอมเม้น',
    //     'DocId': '20240110102612',
    //     'PositionName': 'CS คอมเมนท์',
    //     'SectionID': '20231208151899',
    //     'UserId': '1402640188',
    //     'UserName': 'สวิตต์ ศิลปคัมภีรภาพ',
    //     'Approve': true,
    //     'ยื่นเอกสารใหม่': true,
    //   },
    // ];

    // for (int i = 0; i < currentData.length; i++) {
    //   try {
    //     Uuid uuid = Uuid();
    //     String id = uuid.v4();
    //     FirebaseFirestore.instance
    //         .collection('ApproveComment')
    //         .doc(currentData[i]['DocId'])
    //         .set({
    //       'CustomerID': currentData[i]['CustomerID'],
    //       'DateCreate': DateTime.now(),
    //       'Detail': currentData[i]['Detail'],
    //       'DocId': currentData[i]['DocId'],
    //       'PositionName': currentData[i]['PositionName'],
    //       'SectionID': currentData[i]['SectionID'],
    //       'UserId': currentData[i]['UserId'],
    //       'UserName': currentData[i]['UserName'],
    //       'Approve': currentData[i]['Approve'],
    //       'ยื่นเอกสารใหม่': currentData[i]['ยื่นเอกสารใหม่'],
    //     });
    //   } catch (e) {
    //     debugPrint(e.toString());
    //   }
    // }

    // var collectionReference =
    //     FirebaseFirestore.instance.collection('ApproveComment');

    // collectionReference.get().then((querySnapshot) async {
    //   querySnapshot.docs.forEach((document) {
    //     Map<String, dynamic> currentData =
    //         document.data() as Map<String, dynamic>;

    //     // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //     // currentData['วันเดือนปีนัดหมาย'] = DateTime.now();
    //     currentData['Approve'] = true;
    //     currentData['ยื่นเอกสารใหม่'] = false;

    //     // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //     //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //     // }
    //     collectionReference.doc(document.id).update(currentData);
    //   });
    // });

    // ============================ Update เข้าเยี่ยมลูกค้า Field Data ============================
    // var collectionReference =
    //     FirebaseFirestore.instance.collection('เข้าเยี่ยมลูกค้า');

    // collectionReference.get().then((querySnapshot) async {
    //   querySnapshot.docs.forEach((document) {
    //     Map<String, dynamic> currentData =
    //         document.data() as Map<String, dynamic>;

    //     // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //     // currentData['วันเดือนปีนัดหมาย'] = DateTime.now();
    //     currentData['ปีนัดหมาย'] = '2024';

    //     // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //     //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //     // }
    //     collectionReference.doc(document.id).update(currentData);
    //   });
    // });

    // ============================ Update Customer Field Data ============================
    // var collectionReference = FirebaseFirestore.instance.collection('Customer');

    // collectionReference.get().then((querySnapshot) async {
    //   querySnapshot.docs.forEach((document) async {
    //     Map<String, dynamic> currentData =
    //         document.data() as Map<String, dynamic>;

    //     // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //     // currentData['ค้างชำระ'] = true;
    //     // currentData['รวมยอดค้างชำระ'] = 10000;

    //     // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //     //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //     // }

    //     await FirebaseFirestore.instance
    //         .collection('CustomerTest')
    //         .doc(currentData['CustomerID'])
    //         .set(currentData);
    //     // collectionReference.doc(document.id).update(currentData);
    //   });
    // });

    //============================ Update Product Image Data ============================
    // var collectionReference = FirebaseFirestore.instance.collection('Product');

    // List<String> productImage = [
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/productImageExample%2FLINE_ALBUM__231114_10.jpg?alt=media&token=64c6a52b-a4d4-458b-ab80-10b66d1a3d8e',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/productImageExample%2FLINE_ALBUM__231114_11.jpg?alt=media&token=7c7e0c8d-4543-4faf-8630-e4c9bdb00322',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/productImageExample%2FLINE_ALBUM__231114_12.jpg?alt=media&token=2d9d92a0-b941-43d3-829d-a3013a11a628',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/productImageExample%2FLINE_ALBUM__231114_13.jpg?alt=media&token=581bb27d-cb44-4a6c-a799-ec3da728f278',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/productImageExample%2FLINE_ALBUM__231114_8.jpg?alt=media&token=e357e741-45a6-4455-bc4f-7b0ec2e074a2',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/productImageExample%2FLINE_ALBUM__231114_9.jpg?alt=media&token=4ed21431-340c-4bc3-8b3b-ffabdda6c54f',
    // ];
    // String detail = 'ผลิตจากเนื้อปลาชั้นดีจากปลาน้ำจืด แหล่งที่มาจากชุมชนบ้านทุ่งน้ำ ซึ่งเป็นหมู่บ้านที่ผลิตอาหารทะเลโดยเฉพาะ';
    // // สำหรับทุกเอกสารในคอลเลคชัน
    // collectionReference.get().then((querySnapshot) {
    //   querySnapshot.docs.forEach((document) {
    //     Map<String, dynamic> currentData =
    //         document.data() as Map<String, dynamic>;

    //     // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //     currentData['รายละเอียด'] = detail;

    //     // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //     //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //     // }
    //     collectionReference.doc(document.id).update(currentData);
    //   });
    // });

    //============================ Update price special Data ============================
    // void uploadPriceSpecialCustomer() async {
    //   List<String> id = [];
    //   var collectionReference =
    //       FirebaseFirestore.instance.collection('Customer');
    //   // สำหรับทุกเอกสารในคอลเลคชัน
    //   collectionReference.get().then((querySnapshot) {
    //     querySnapshot.docs.forEach((document) {
    //       Map<String, dynamic> currentData =
    //           document.data() as Map<String, dynamic>;

    //       // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //       id.add(currentData['CustomerID']);

    //       // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //       //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //       // }
    //       // collectionReference.doc(document.id).update(currentData);
    //       print(currentData['CustomerID']);
    //     });
    //   }).whenComplete(() async {
    //     List<Map<String, dynamic>> currentData = [
    //       {
    //         'ProductID': '0010017020260',
    //         'DocID': '0010017020260-VAC',
    //         'PRICE': 50,
    //       },
    //       {
    //         'ProductID': '0010017020360',
    //         'DocID': '0010017020360-ถุง',
    //         'PRICE': 30,
    //       },
    //       {
    //         'ProductID': '0010027030125',
    //         'DocID': '0010027030125-VAC',
    //         'PRICE': 70,
    //       },
    //       {
    //         'ProductID': '0010027030260',
    //         'DocID': '0010027030260-VAC',
    //         'PRICE': 30,
    //       },
    //       {
    //         'ProductID': '0010027030360',
    //         'DocID': '0010027030360-ถุง',
    //         'PRICE': 40,
    //       },
    //     ];
    //     for (var element in id) {
    //       try {
    //         for (var elementIn in currentData) {
    //           await FirebaseFirestore.instance
    //               .collection('Customer')
    //               .doc(element)
    //               .collection('ราคาสินค้าพิเศษ')
    //               .doc(elementIn['DocID'])
    //               .set({
    //             'DocID': elementIn['DocID'],
    //             'PRODUCTID': elementIn['ProductID'],
    //             'PRICE': elementIn['PRICE'],
    //           });
    //         }

    //         print('Order created successfully for customer ID: $element');
    //       } catch (e) {
    //         print('Error creating order for customer ID: $element, Error: $e');
    //       }
    //     }
    //   });
    //   print('Success');
    // }

    // uploadPriceSpecialCustomer();

    // // ============================ Update plan send Data ============================
    // void updateOrdersCustomer() async {
    //   final Random random = Random();
    //   List<String> id = [];
    //   var collectionReference =
    //       FirebaseFirestore.instance.collection('CustomerTest');
    //   // สำหรับทุกเอกสารในคอลเลคชัน
    //   collectionReference.get().then((querySnapshot) {
    //     querySnapshot.docs.forEach((document) {
    //       Map<String, dynamic> currentData =
    //           document.data() as Map<String, dynamic>;

    //       // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //       id.add(currentData['CustomerID']);

    //       // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //       //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //       // }
    //       // collectionReference.doc(document.id).update(currentData);
    //       print(currentData['CustomerID']);
    //     });
    //   }).whenComplete(() async {
    //     //=======================================================
    //     //=======================================================

    //     for (var element in id) {
    //       print(element);
    //       var collectionReference = FirebaseFirestore.instance
    //           .collection('CustomerTest')
    //           .doc(element)
    //           .collection('แผนการจัดส่ง');

    //       try {
    //         await collectionReference.get().then((querySnapshot) {
    //           querySnapshot.docs.forEach((document) async {
    //             Map<String, dynamic> currentData =
    //                 document.data() as Map<String, dynamic>;

    //             // final Random random = Random();

    //             // currentData['ProductList'] = [
    //             //   {
    //             //     'ProductID': '0140006371000P',
    //             //     'ชื่อสินค้า':
    //             //         'ผักรวมสามสี (แครอท ถั่วลั่นเตา ข้าวโพด)(F) 1000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็งPre Order',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 150,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0140006421000',
    //             //     'ชื่อสินค้า': 'นักเก็ตไก่ (F) 1000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 200,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0140007981000',
    //             //     'ชื่อสินค้า': 'หนอนไหม (F) 1,000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 200,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0140009961000',
    //             //     'ชื่อสินค้า': 'กุ้งขาว (F) PDTO 51/60 NW 80% 1,000 กรัม ',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 150,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0141319391000',
    //             //     'ชื่อสินค้า': 'NB หมึกแล่บั้ง (F) 1,000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 220,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             // ];

    //             // // สุ่ม index ที่ต้องการลบ
    //             // Random random2 = Random();
    //             // int randomIndex =
    //             //     random.nextInt(currentData['ProductList'].length);

    //             // // ลบ Map ที่ randomIndex ออกจาก List
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);

    //             // // คำนวณยอดรวม
    //             // int totalAmount =
    //             //     currentData['ProductList'].fold(0, (sum, product) {
    //             //   return sum + (product['จำนวน'] * product['ราคา']);
    //             // });

    //             // currentData['ยอดรวม'] = totalAmount;
    //             // currentData['สายส่งโค้ด'] = '';
    //             currentData['ลำดับการจัดส่ง'] = [
    //               true,
    //               true,
    //               true,
    //               false,
    //               false,
    //             ];
    //             currentData['หัวข้อลำดับการจัดส่ง'] = [
    //               'คอนเฟิร์มออเดอร์',
    //               'กำลังดำเนินการ',
    //               'เตรียมจัดส่ง',
    //               'อยู่ระหว่างขนส่ง',
    //               'ได้รับสินค้าแล้ว',
    //             ];

    //             print(currentData['OrdersDateID']);
    //             print(currentData['OrdersDateID']);
    //             print(currentData['OrdersDateID']);

    //             // await collectionReference
    //             //     .doc(currentData['OrdersDateID'])
    //             //     .set(currentData);
    //           });
    //         });

    //         print('Order created successfully for customer ID: $element');
    //       } catch (e) {
    //         print('Error creating order for customer ID: $element, Error: $e');
    //       }
    //     }
    //   });
    //   print('Success');
    // }

    // updateOrdersCustomer();

    // // ============================ Update Order Data ============================
    // void updateOrdersCustomer() async {
    //   final Random random = Random();
    //   List<String> id = [];
    //   var collectionReference =
    //       FirebaseFirestore.instance.collection('Customer');
    //   // สำหรับทุกเอกสารในคอลเลคชัน
    //   collectionReference.get().then((querySnapshot) {
    //     querySnapshot.docs.forEach((document) {
    //       Map<String, dynamic> currentData =
    //           document.data() as Map<String, dynamic>;

    //       // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //       id.add(currentData['CustomerID']);

    //       // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //       //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //       // }
    //       // collectionReference.doc(document.id).update(currentData);
    //       print(currentData['CustomerID']);
    //     });
    //   }).whenComplete(() async {
    //     //=======================================================
    //     //=======================================================

    //     for (var element in id) {
    //       var collectionReference = FirebaseFirestore.instance
    //           .collection('Customer')
    //           .doc(element)
    //           .collection('ราคาสินค้าพิเศษ');

    //       try {
    //         await collectionReference.get().then((querySnapshot) {
    //           querySnapshot.docs.forEach((document) async {
    //             Map<String, dynamic> currentData =
    //                 document.data() as Map<String, dynamic>;

    //             // final Random random = Random();

    //             // currentData['ProductList'] = [
    //             //   {
    //             //     'ProductID': '0140006371000P',
    //             //     'ชื่อสินค้า':
    //             //         'ผักรวมสามสี (แครอท ถั่วลั่นเตา ข้าวโพด)(F) 1000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็งPre Order',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 150,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0140006421000',
    //             //     'ชื่อสินค้า': 'นักเก็ตไก่ (F) 1000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 200,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0140007981000',
    //             //     'ชื่อสินค้า': 'หนอนไหม (F) 1,000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 200,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0140009961000',
    //             //     'ชื่อสินค้า': 'กุ้งขาว (F) PDTO 51/60 NW 80% 1,000 กรัม ',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 150,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             //   {
    //             //     'ProductID': '0141319391000',
    //             //     'ชื่อสินค้า': 'NB หมึกแล่บั้ง (F) 1,000 กรัม',
    //             //     'คำอธิบายสินค้า': 'อาหารแช่แข็ง',
    //             //     'PromotionProductID': '',
    //             //     'สินค้าโปรโมชั่น': false, //bool
    //             //     'คำอธิบายโปรโมชั่น': '',
    //             //     'จำนวน': random.nextInt(36) + 6,
    //             //     'ราคา': 220,
    //             //     'ราคาพิเศษ': false, //bool
    //             //   },
    //             // ];

    //             // // สุ่ม index ที่ต้องการลบ
    //             // Random random2 = Random();
    //             // int randomIndex =
    //             //     random.nextInt(currentData['ProductList'].length);

    //             // // ลบ Map ที่ randomIndex ออกจาก List
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);
    //             // if (currentData['ProductList'].length > randomIndex)
    //             //   currentData['ProductList'].removeAt(randomIndex);

    //             // // คำนวณยอดรวม
    //             // int totalAmount =
    //             //     currentData['ProductList'].fold(0, (sum, product) {
    //             //   return sum + (product['จำนวน'] * product['ราคา']);
    //             // });

    //             // currentData['ยอดรวม'] = totalAmount;
    //             // currentData['สายส่งโค้ด'] = '';
    //             // currentData['รอตรวจการอนุมัติ'] = true;

    //             // await collectionReference
    //             //     .doc(currentData['OrdersDateID'])
    //             //     .update(currentData);

    //             await FirebaseFirestore.instance
    //                 .collection('CustomerTest')
    //                 .doc(element)
    //                 .collection('ราคาสินค้าพิเศษ')
    //                 .doc(currentData['DocID'])
    //                 .set(currentData);
    //           });
    //         });

    //         print('Order created successfully for customer ID: $element');
    //       } catch (e) {
    //         print('Error creating order for customer ID: $element, Error: $e');
    //       }
    //     }
    //   });
    //   print('Success');
    // }

    // updateOrdersCustomer();

    // ============================ Set Order Data ============================
    // void uploadOrdersCustomer() async {
    //   List<String> id = [];
    //   var collectionReference =
    //       FirebaseFirestore.instance.collection('Customer');
    //   // สำหรับทุกเอกสารในคอลเลคชัน
    //   collectionReference.get().then((querySnapshot) {
    //     querySnapshot.docs.forEach((document) {
    //       Map<String, dynamic> currentData =
    //           document.data() as Map<String, dynamic>;

    //       // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //       id.add(currentData['CustomerID']);

    //       // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //       //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //       // }
    //       // collectionReference.doc(document.id).update(currentData);
    //       print(currentData['CustomerID']);
    //     });
    //   }).whenComplete(() async {
    //     for (var element in id) {
    //       // await FirebaseFirestore.instance
    //       //     .collection('Customer')
    //       //     .doc(element)
    //       //     .collection('Orders')
    //       //     .get()
    //       //     .then(
    //       //         (QuerySnapshot<Map<String, dynamic>> orderCollection) async {
    //       //   for (QueryDocumentSnapshot<Map<String, dynamic>> orderDoc
    //       //       in orderCollection.docs) {
    //       //     // ลบเอกสาร 'Orders'
    //       //     await orderDoc.reference.delete();
    //       //   }
    //       // });

    //       try {
    //         for (int i = 0; i < 10; i++) {
    //           // สร้างวันที่แบบสุ่มในระยะเวลา 1 เดือนก่อน ก็ให้ day เป็น 30
    //           DateTime previousMonth =
    //               DateTime.now().subtract(Duration(days: 9)); //9 วันก่อน
    //           DateTime randomDate =
    //               previousMonth.add(Duration(days: Random().nextInt(9)));
    //           // แปลงรูปแบบวันที่ให้เป็น UTC (ตัวอย่างเท่านั้น)

    //           DateTime utcRandomDate = randomDate.toUtc();
    //           String orderID = DateTime.now().toString();
    //           print(orderID);

    //           final Random random = Random();

    //           List currentData = [
    //             {
    //               'DocID': '0010017020260-VAC',
    //               'ProductID': '0010017020260',
    //               'ชื่อสินค้า': 'ส.ขอนแก่น กุนเชียงเชือกแดง 260 กรัม',
    //               'คำอธิบายสินค้า':
    //                   'ผลิตจากเนื้อปลาชั้นดีจากปลาน้ำจืด แหล่งที่มาจากชุมชนบ้านทุ่งน้ำ ซึ่งเป็นหมู่บ้านที่ผลิตอาหารทะเลโดยเฉพาะ',
    //               'PromotionProductID': '',
    //               'สินค้าโปรโมชั่น': false, //bool
    //               'คำอธิบายโปรโมชั่น': '',
    //               'จำนวน': random.nextInt(36) + 6,
    //               'ราคา': 150,
    //               'ราคาพิเศษ': false, //bool
    //             },
    //             {
    //               'DocID': '0030008901000-ซอง',
    //               'ProductID': '0030008901000',
    //               'ชื่อสินค้า': 'หมูหมักนุ่ม 1,000 กรัม',
    //               'คำอธิบายสินค้า':
    //                   'ผลิตจากเนื้อปลาชั้นดีจากปลาน้ำจืด แหล่งที่มาจากชุมชนบ้านทุ่งน้ำ ซึ่งเป็นหมู่บ้านที่ผลิตอาหารทะเลโดยเฉพาะ',
    //               'PromotionProductID': '',
    //               'สินค้าโปรโมชั่น': false, //bool
    //               'คำอธิบายโปรโมชั่น': '',
    //               'จำนวน': random.nextInt(36) + 6,
    //               'ราคา': 200,
    //               'ราคาพิเศษ': false, //bool
    //             },
    //             {
    //               'DocID': '0140005781000-กิโลกรัม',
    //               'ProductID': '0140005781000',
    //               'ชื่อสินค้า': 'ซีฟู้ดมิกซ์ NW 70% 1,000 กรัม',
    //               'คำอธิบายสินค้า':
    //                   'ผลิตจากเนื้อปลาชั้นดีจากปลาน้ำจืด แหล่งที่มาจากชุมชนบ้านทุ่งน้ำ ซึ่งเป็นหมู่บ้านที่ผลิตอาหารทะเลโดยเฉพาะ',
    //               'PromotionProductID': '',
    //               'สินค้าโปรโมชั่น': false, //bool
    //               'คำอธิบายโปรโมชั่น': '',
    //               'จำนวน': random.nextInt(36) + 6,
    //               'ราคา': 200,
    //               'ราคาพิเศษ': false, //bool
    //             },
    //             {
    //               'DocID': '0091527720280-ชุด',

    //               'ProductID': '0091527720280',
    //               'ชื่อสินค้า': 'กันเอง หมูยอ 280 กรัม (1 แถม 1)			',
    //               'คำอธิบายสินค้า':
    //                   'ผลิตจากเนื้อปลาชั้นดีจากปลาน้ำจืด แหล่งที่มาจากชุมชนบ้านทุ่งน้ำ ซึ่งเป็นหมู่บ้านที่ผลิตอาหารทะเลโดยเฉพาะ',
    //               'PromotionProductID': '',
    //               'สินค้าโปรโมชั่น': false, //bool
    //               'คำอธิบายโปรโมชั่น': '',
    //               'จำนวน': random.nextInt(36) + 6,
    //               'ราคา': 150,
    //               'ราคาพิเศษ': false, //bool
    //             },
    //             {
    //               'DocID': '0090047630150-แท่ง',

    //               'ProductID': '0090047630150',
    //               'ชื่อสินค้า': 'หมูดี หมูยอกลาง 150 กรัม		',
    //               'คำอธิบายสินค้า':
    //                   'ผลิตจากเนื้อปลาชั้นดีจากปลาน้ำจืด แหล่งที่มาจากชุมชนบ้านทุ่งน้ำ ซึ่งเป็นหมู่บ้านที่ผลิตอาหารทะเลโดยเฉพาะ',
    //               'PromotionProductID': '',
    //               'สินค้าโปรโมชั่น': false, //bool
    //               'คำอธิบายโปรโมชั่น': '',
    //               'จำนวน': random.nextInt(36) + 6,
    //               'ราคา': 220,
    //               'ราคาพิเศษ': false, //bool
    //             },
    //           ];

    //           // คำนวณยอดรวม
    //           int totalAmount = currentData.fold(0, (sum, product) {
    //             return (product['จำนวน'] * product['ราคา']);
    //           });

    //           // สร้างคลาส Random
    //           Random randomDatePlan = Random();

    //           // สุ่มจำนวนวันที่ต้องการ
    //           int randomDays = randomDatePlan.nextInt(10);

    //           // วันที่ปัจจุบัน
    //           DateTime currentDate = DateTime.now();

    //           // สร้าง DateTime ที่ถูกสุ่มและย้อนหลังไป 10 วัน
    //           DateTime randomDatePlanLast =
    //               currentDate.subtract(Duration(days: randomDays));

    //           await FirebaseFirestore.instance
    //               .collection('Customer')
    //               .doc(element)
    //               .collection('Orders')
    //               .doc(orderID)
    //               .set({
    //             'OrdersDateID': orderID,
    //             'OrdersUpdateTime': utcRandomDate,
    //             'สถานที่จัดส่ง': '',
    //             'วันเวลาจัดส่ง': randomDatePlanLast,
    //             'สายส่ง': '',
    //             'สายส่งโค้ด': '',
    //             'สายส่งไอดี': '',
    //             'ProductList': currentData,
    //             'ยอดรวม': totalAmount,
    //             'สถานะค้างชำระ': false,
    //             // 'สถานะค้างชำระ' : true,
    //             'ค้างชำระ': 0,
    //             // 'ค้างชำระ': random.nextInt(10000) + 1000,
    //             'สถานะเอกสาร': true,
    //             'สถานะอนุมัติขาย': true,
    //             'รอตรวจการอนุมัติ': false,
    //           });
    //         }

    //         print('Order created successfully for customer ID: $element');
    //       } catch (e) {
    //         print('Error creating order for customer ID: $element, Error: $e');
    //       }
    //     }
    //   });
    //   print('Success');
    // }

    // uploadOrdersCustomer();

    //     //============================ Update Data ============================
    // var collectionReference = FirebaseFirestore.instance.collection('User');
    // // สำหรับทุกเอกสารในคอลเลคชัน
    // collectionReference.get().then((querySnapshot) {
    //   querySnapshot.docs.forEach((document) {
    //     Map<String, dynamic> currentData =
    //         document.data() as Map<String, dynamic>;

    //     // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //     // currentData['ListCustomerAddress'] = [
    //     //   {
    //     //     'ID': DateTime.now().toString(),
    //     //     'รหัสสาขา': '01', //new
    //     //     'ชื่อสาขา': 'พหลโยธิน', //new
    //     //     'HouseNumber': '331',
    //     //     'VillageName': 'หมู่บ้านลดาวัลย์',
    //     //     'Road': 'สุขุมวิท', //new
    //     //     'Province': 'ชลบุรี',
    //     //     'District': 'บ้านบึง',
    //     //     'SubDistrict': 'หนองบอนแดง',
    //     //     'PostalCode': '20170',
    //     //     'Latitude': '',
    //     //     'Longitude': '',
    //     //     'Image': '',
    //     //     'ผู้ติดต่อ': 'วันชัย อาจศิริ', //new
    //     //     'ตำแหน่ง': 'ฝ่ายขาย', //new
    //     //     'โทรศัพท์': '0897869409', //new
    //     //   },
    //     // ];

    //     // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //       currentData['ประเภทสินค้า'] = [];
    //     // }
    //     collectionReference.doc(document.id).update(currentData);
    //   });
    // });

    // // ============================ Update Data ============================
    // var collectionReference =
    //     FirebaseFirestore.instance.collection('CustomerTest');
    // // สำหรับทุกเอกสารในคอลเลคชัน
    // collectionReference.get().then((querySnapshot) {
    //   querySnapshot.docs.forEach((document) {
    //     Map<String, dynamic> currentData =
    //         document.data() as Map<String, dynamic>;

    //     // เพิ่มข้อมูลในฟิลด์ที่ต้องการ
    //     currentData['ListCustomerAddress'] = [
    //       {
    //         'ID': DateTime.now().toString(),
    //         'รหัสสาขา': '01', //new
    //         'ชื่อสาขา': 'พหลโยธิน', //new
    //         'HouseNumber': '331',
    //         'VillageName': 'หมู่บ้านลดาวัลย์',
    //         'Road': 'สุขุมวิท', //new
    //         'Province': 'ชลบุรี',
    //         'District': 'บ้านบึง',
    //         'SubDistrict': 'หนองบอนแดง',
    //         'PostalCode': '20170',
    //         'Latitude': '',
    //         'Longitude': '',
    //         'Image': '',
    //         'ผู้ติดต่อ': 'วันชัย อาจศิริ', //new
    //         'ตำแหน่ง': 'ฝ่ายขาย', //new
    //         'โทรศัพท์': '0897869409', //new
    //       },
    //     ];

    //     // if (!currentData.containsKey('ระยะเวลาการดำเนินการ')) {
    //     //   currentData['ระยะเวลาการดำเนินการ'] = '';
    //     // }
    //     collectionReference.doc(document.id).update(currentData);
    //   });
    // });

    //============================ Set New Data ============================

    // List<String> groupName = [
    //   'กุนเชียง',
    //   'หมูหยอง',
    //   'หมูอื่นๆ',
    //   'แหนม',
    //   'แคบหมู',
    //   'หมูยอ',
    //   'ปูอัด',
    //   'ต้ม',
    //   'ทอด',
    //   'สำเร็จรูป-น้ำพริก/น้ำจิ้ม',
    //   'อาหารแปรรูปแห้ง',
    //   'อาหารแช่แข็ง Pre Order',
    //   'ทอด / ต้ม',
    //   'อาหารแช่แข็ง',
    //   'สำเร็จรูป-สแน๊ค',
    //   'ไส้กรอกอีสาน',
    //   'ลูกชิ้นหมู',
    //   'เครื่องปรุงรส',
    //   'ไส้กรอกไก่',
    //   'ไก่อื่นๆ',
    //   'อาหารปรุงพร้อมทาน',
    //   'น้ำ',
    //   'จ้อ',
    // ];

    // List<String> imageUrl = [
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_2.jpg?alt=media&token=b2cb1c22-2f13-4fcd-bec3-fb3990429764',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_3.jpg?alt=media&token=aca7740c-81d0-4d05-8b38-0df8cc4d52d8',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_4.jpg?alt=media&token=d6ff5138-6cfc-4878-a48b-52e0a0aa6970',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_5.jpg?alt=media&token=a34a9a2c-9ceb-419f-ba56-ff656a25efef',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_6.jpg?alt=media&token=68e92334-9ca6-461a-924d-b3a84639b691',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_7.jpg?alt=media&token=b91ef09f-f31f-487e-bf5a-11e57cf6d9ab',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_2.jpg?alt=media&token=b2cb1c22-2f13-4fcd-bec3-fb3990429764',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_3.jpg?alt=media&token=aca7740c-81d0-4d05-8b38-0df8cc4d52d8',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_4.jpg?alt=media&token=d6ff5138-6cfc-4878-a48b-52e0a0aa6970',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_5.jpg?alt=media&token=a34a9a2c-9ceb-419f-ba56-ff656a25efef',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_6.jpg?alt=media&token=68e92334-9ca6-461a-924d-b3a84639b691',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_7.jpg?alt=media&token=b91ef09f-f31f-487e-bf5a-11e57cf6d9ab',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_2.jpg?alt=media&token=b2cb1c22-2f13-4fcd-bec3-fb3990429764',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_3.jpg?alt=media&token=aca7740c-81d0-4d05-8b38-0df8cc4d52d8',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_4.jpg?alt=media&token=d6ff5138-6cfc-4878-a48b-52e0a0aa6970',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_5.jpg?alt=media&token=a34a9a2c-9ceb-419f-ba56-ff656a25efef',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_6.jpg?alt=media&token=68e92334-9ca6-461a-924d-b3a84639b691',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_7.jpg?alt=media&token=b91ef09f-f31f-487e-bf5a-11e57cf6d9ab',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_2.jpg?alt=media&token=b2cb1c22-2f13-4fcd-bec3-fb3990429764',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_3.jpg?alt=media&token=aca7740c-81d0-4d05-8b38-0df8cc4d52d8',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_4.jpg?alt=media&token=d6ff5138-6cfc-4878-a48b-52e0a0aa6970',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_5.jpg?alt=media&token=a34a9a2c-9ceb-419f-ba56-ff656a25efef',
    //   'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/GroupProductExample%2FLINE_ALBUM__231114_6.jpg?alt=media&token=68e92334-9ca6-461a-924d-b3a84639b691',
    // ];
    // for (int i = 0; i < imageUrl.length; i++) {
    //   try {
    //     Uuid uuid = Uuid();
    //     String id = uuid.v4();
    //     FirebaseFirestore.instance.collection('กลุ่มสินค้า').doc(id).set({
    //       'GroupProductID': id,
    //       'ชื่อกลุ่ม': groupName[i],
    //       'รูปภาพ': imageUrl[i],
    //     });
    //   } catch (e) {
    //     debugPrint(e.toString());
    //   }
    // }

    //============================ Set New Data ============================

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoading
            ? Center(
                child: CircularLoading(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 10.0, 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                'เปิดหน้าบัญชีใหม่เข้าระบบ',
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
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Expanded(
                            //   child: Padding(
                            //     padding: EdgeInsetsDirectional.fromSTEB(
                            //         0.0, 0.0, 10.0, 0.0),
                            //     child: MenuSidebarWidget(),
                            //   ),
                            // ),
                            Expanded(
                              // flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Row(
                                              children: [
                                                //============ ตรวจสอบ =================
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 12.0,
                                                                8.0, 0.0),
                                                    child: TextFormField(
                                                      controller:
                                                          textController,
                                                      focusNode:
                                                          textFieldFocusNode,
                                                      autofocus: false,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium,
                                                        hintText:
                                                            'ตรวจสอบชื่อวามีหน้าบัญชีในระบบอยูแล้วหรือไม่?',
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
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium,
                                                      textAlign:
                                                          TextAlign.center,
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
                                        //============ เปิดหน้าบัญชีใหม่เข้าสูระบบ =================
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            // context.pushNamed('A07_02_OpenAccount');
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const A0702OpenAccountWidget(),
                                                )).whenComplete(() async {
                                              customerAll = [];

                                              customerAllSave = [];
                                              customerAllApprove = [];
                                              customerAllWaiting = [];
                                              customerAllNoApplove = [];

                                              await loadData();

                                              setState(() {});
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 5.0, 0.0),
                                                child: Icon(
                                                  FFIcons.kfolderPlus,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  size: 30.0,
                                                ),
                                              ),
                                              Text(
                                                'เปิดหน้าบัญชีใหม่เข้าสู่ระบบ',
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
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //============ ข้อมูลลูกค้าที่ยังทำไมครบทุกขั้นตอนที่เซฟเก็บไว้ทำภายหลัง =================
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const A0710SaveWidget(),
                                                )).whenComplete(() async {
                                              customerAll = [];

                                              customerAllSave = [];
                                              customerAllApprove = [];
                                              customerAllWaiting = [];
                                              customerAllNoApplove = [];

                                              await loadData();

                                              setState(() {});
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 5.0, 0.0),
                                                child: Icon(
                                                  FFIcons.kfolderRefresh,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  size: 30.0,
                                                ),
                                              ),
                                              Text(
                                                'ข้อมูลลูกค้าที่ยังทำไม่ครบทุกขั้นตอนที่เซฟเก็บไว้ทำภายหลัง',
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
                                              Spacer(),
                                              // StreamBuilder(
                                              //     stream: FirebaseFirestore
                                              //         .instance
                                              //         .collection(AppSettings
                                              //                     .customerType ==
                                              //                 CustomerType.Test
                                              //             ? 'CustomerTest'
                                              //             : 'Customer')
                                              //         .snapshots(),
                                              //     builder: (context, snapshot) {
                                              //       if (snapshot
                                              //               .connectionState ==
                                              //           ConnectionState
                                              //               .waiting) {
                                              //         return SizedBox();
                                              //       }
                                              //       if (snapshot.hasError) {
                                              //         return Text(
                                              //             'เกิดข้อผิดพลาด: ${snapshot.error}');
                                              //       }
                                              //       if (!snapshot.hasData) {
                                              //         return Text(
                                              //             'ไม่พบข้อมูล');
                                              //       }
                                              //       if (snapshot
                                              //           .data!.docs.isEmpty) {
                                              //         print(snapshot.data);
                                              //       }

                                              //       print('stream stream');

                                              //       customerController
                                              //           .updateCustomerData(
                                              //               snapshot.data);
                                              //       // print(customerController
                                              //       // .customerData!.length);

                                              //       Map<String, dynamic>
                                              //           customerMap = {};
                                              //       //     data.docs.first.data() as Map<String, dynamic>;

                                              //       for (int index = 0;
                                              //           index <
                                              //               snapshot.data!.docs
                                              //                   .length;
                                              //           index++) {
                                              //         final Map<String, dynamic>
                                              //             docData = snapshot
                                              //                     .data!
                                              //                     .docs[index]
                                              //                     .data()
                                              //                 as Map<String,
                                              //                     dynamic>;

                                              //         customerMap[
                                              //                 'key${index}'] =
                                              //             docData;
                                              //       }
                                              //       // print('aaaa');
                                              //       // print(customerMap);

                                              //       Map<String, dynamic>
                                              //           filteredData =
                                              //           Map.fromEntries(
                                              //         customerMap.entries.where((entry) =>
                                              //             entry.value[
                                              //                     'บันทึกพร้อมตรวจ'] ==
                                              //                 true &&
                                              //             userData![
                                              //                     'EmployeeID'] ==
                                              //                 entry.value[
                                              //                     'รหัสพนักงานขาย']),
                                              //       );

                                              //       // print(AppSettings.customerType);
                                              //       // print(AppSettings.customerType);
                                              //       // print(AppSettings.customerType);
                                              //       // print(AppSettings.customerType);
                                              //       // print(AppSettings.customerType);
                                              //       return
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width: 26.5,
                                                    height: 26.5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(5.0,
                                                              2.0, 5.0, 5.0),
                                                      child: Text(
                                                        customerAllSave.length
                                                            .toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                      ),
                                                    ),

                                                    //  Padding(
                                                    //   padding: EdgeInsetsDirectional
                                                    //       .fromSTEB(
                                                    //           5.0, 5.0, 5.0, 5.0),
                                                    //   child: Text(
                                                    // filteredData.length.toString(),
                                                    //     style: FlutterFlowTheme.of(
                                                    //             context)
                                                    //         .bodyMedium
                                                    //         .override(
                                                    //           fontFamily: 'Kanit',
                                                    //           color: FlutterFlowTheme
                                                    //                   .of(context)
                                                    //               .primaryBackground,
                                                    //         ),
                                                    //   ),
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                              // ;
                                              // }),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //============ ลูกค้าที่ผ่านการอนุมัติหน้าบัญชีแล้ว =================
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      A0713AcceptWidget(),
                                                )).whenComplete(() async {
                                              customerAll = [];

                                              customerAllSave = [];
                                              customerAllApprove = [];
                                              customerAllWaiting = [];
                                              customerAllNoApplove = [];

                                              await loadData();

                                              setState(() {});
                                            });
                                            ;
                                            // context.pushNamed('A07_13_Accept');
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 5.0, 0.0),
                                                        child: Icon(
                                                          FFIcons.kfolderCheck,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ลูกค้าที่ผ่านการอนุมัติหน้าบัญชีแล้ว',
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
                                                ],
                                              ),
                                              Spacer(),
                                              // StreamBuilder(
                                              //     stream: FirebaseFirestore
                                              //         .instance
                                              //         .collection(AppSettings
                                              //                     .customerType ==
                                              //                 CustomerType.Test
                                              //             ? 'CustomerTest'
                                              //             : 'Customer')
                                              //         .snapshots(),
                                              //     builder: (context, snapshot) {
                                              //       if (snapshot
                                              //               .connectionState ==
                                              //           ConnectionState
                                              //               .waiting) {
                                              //         return SizedBox();
                                              //       }
                                              //       if (snapshot.hasError) {
                                              //         return Text(
                                              //             'เกิดข้อผิดพลาด: ${snapshot.error}');
                                              //       }
                                              //       if (!snapshot.hasData) {
                                              //         return Text(
                                              //             'ไม่พบข้อมูล');
                                              //       }
                                              //       if (snapshot
                                              //           .data!.docs.isEmpty) {
                                              //         print(snapshot.data);
                                              //       }

                                              //       print('stream stream');

                                              //       customerController
                                              //           .updateCustomerData(
                                              //               snapshot.data);
                                              //       // print(customerController
                                              //       // .customerData!.length);

                                              //       Map<String, dynamic>
                                              //           customerMap = {};
                                              //       //     data.docs.first.data() as Map<String, dynamic>;

                                              //       for (int index = 0;
                                              //           index <
                                              //               snapshot.data!.docs
                                              //                   .length;
                                              //           index++) {
                                              //         final Map<String, dynamic>
                                              //             docData = snapshot
                                              //                     .data!
                                              //                     .docs[index]
                                              //                     .data()
                                              //                 as Map<String,
                                              //                     dynamic>;

                                              //         customerMap[
                                              //                 'key${index}'] =
                                              //             docData;
                                              //       }
                                              //       // print('aaaa');
                                              //       // print(customerMap);

                                              //       Map<String, dynamic>
                                              //           filteredData =
                                              //           Map.fromEntries(
                                              //         customerMap.entries.where((entry) =>
                                              //             entry.value[
                                              //                     'สถานะ'] ==
                                              //                 true &&
                                              //             entry.value[
                                              //                     'บันทึกพร้อมตรวจ'] ==
                                              //                 false &&
                                              //             userData![
                                              //                     'EmployeeID'] ==
                                              //                 entry.value[
                                              //                     'รหัสพนักงานขาย']),
                                              //       );
                                              //       return
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width: 26.5,
                                                    height: 26.5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(5.0,
                                                              2.0, 5.0, 5.0),
                                                      child: Text(
                                                        customerAllApprove
                                                            .length
                                                            .toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                      ),
                                                    ),

                                                    //  Padding(
                                                    //   padding: EdgeInsetsDirectional
                                                    //       .fromSTEB(
                                                    //           5.0, 5.0, 5.0, 5.0),
                                                    //   child: Text(
                                                    // filteredData.length.toString(),
                                                    //     style: FlutterFlowTheme.of(
                                                    //             context)
                                                    //         .bodyMedium
                                                    //         .override(
                                                    //           fontFamily: 'Kanit',
                                                    //           color: FlutterFlowTheme
                                                    //                   .of(context)
                                                    //               .primaryBackground,
                                                    //         ),
                                                    //   ),
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                              //   ;
                                              // }),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //============ รายการลูกค้าที่รออนุมัติการเปิดหน้าบัญชี =================
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      A0708ListOpenedWidget(),
                                                )).whenComplete(() async {
                                              customerAll = [];
                                              customerAllSave = [];
                                              customerAllApprove = [];
                                              customerAllWaiting = [];
                                              customerAllNoApplove = [];
                                              await loadData();

                                              setState(() {});
                                            });
                                            ;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 5.0, 0.0),
                                                child: Icon(
                                                  FFIcons.kfolderClock,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  size: 30.0,
                                                ),
                                              ),
                                              Text(
                                                'รายการลูกค้าที่รออนุมัติการเปิดหน้าบัญชี',
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
                                              Spacer(),
                                              // StreamBuilder(
                                              //     stream: FirebaseFirestore
                                              //         .instance
                                              //         .collection(AppSettings
                                              //                     .customerType ==
                                              //                 CustomerType.Test
                                              //             ? 'CustomerTest'
                                              //             : 'Customer')
                                              //         .snapshots(),
                                              //     builder: (context, snapshot) {
                                              //       if (snapshot
                                              //               .connectionState ==
                                              //           ConnectionState
                                              //               .waiting) {
                                              //         return SizedBox();
                                              //       }
                                              //       if (snapshot.hasError) {
                                              //         return Text(
                                              //             'เกิดข้อผิดพลาด: ${snapshot.error}');
                                              //       }
                                              //       if (!snapshot.hasData) {
                                              //         return Text(
                                              //             'ไม่พบข้อมูล');
                                              //       }
                                              //       if (snapshot
                                              //           .data!.docs.isEmpty) {
                                              //         print(snapshot.data);
                                              //       }

                                              //       print('stream stream');

                                              //       customerController
                                              //           .updateCustomerData(
                                              //               snapshot.data);
                                              //       // print(customerController
                                              //       // .customerData!.length);

                                              //       Map<String, dynamic>
                                              //           customerMap = {};
                                              //       //     data.docs.first.data() as Map<String, dynamic>;

                                              //       for (int index = 0;
                                              //           index <
                                              //               snapshot.data!.docs
                                              //                   .length;
                                              //           index++) {
                                              //         final Map<String, dynamic>
                                              //             docData = snapshot
                                              //                     .data!
                                              //                     .docs[index]
                                              //                     .data()
                                              //                 as Map<String,
                                              //                     dynamic>;

                                              //         customerMap[
                                              //                 'key${index}'] =
                                              //             docData;
                                              //       }
                                              //       // print('aaaa');
                                              //       // print(customerMap);

                                              //       Map<String, dynamic>
                                              //           filteredData =
                                              //           Map.fromEntries(
                                              //         customerMap.entries.where(
                                              //             (entry) =>
                                              //                 // entry.value['สถานะ'] == false &&
                                              //                 // entry.value['บันทึกพร้อมตรวจ'] ==
                                              //                 //     false &&
                                              //                 entry.value[
                                              //                         'รอการอนุมัติ'] ==
                                              //                     true &&
                                              //                 userData![
                                              //                         'EmployeeID'] ==
                                              //                     entry.value[
                                              //                         'รหัสพนักงานขาย']),
                                              //       );
                                              //       return
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width: 26.5,
                                                    height: 26.5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(5.0,
                                                              2.0, 5.0, 5.0),
                                                      child: Text(
                                                        customerAllWaiting
                                                            .length
                                                            .toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                      ),
                                                    ),

                                                    //  Padding(
                                                    //   padding: EdgeInsetsDirectional
                                                    //       .fromSTEB(
                                                    //           5.0, 5.0, 5.0, 5.0),
                                                    //   child: Text(
                                                    // filteredData.length.toString(),
                                                    //     style: FlutterFlowTheme.of(
                                                    //             context)
                                                    //         .bodyMedium
                                                    //         .override(
                                                    //           fontFamily: 'Kanit',
                                                    //           color: FlutterFlowTheme
                                                    //                   .of(context)
                                                    //               .primaryBackground,
                                                    //         ),
                                                    //   ),
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                              //   ;
                                              // }),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //============ ลูกค้าที่ไม่ผ่านการอนุมัติการเปิดบัญชี =================
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      A0714RejectWidget(),
                                                )).whenComplete(() async {
                                              customerAll = [];
                                              customerAllSave = [];
                                              customerAllApprove = [];
                                              customerAllWaiting = [];
                                              customerAllNoApplove = [];
                                              await loadData();
                                              setState(() {});
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                        child: Icon(
                                                          FFIcons.kfolderCancel,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ลูกค้าที่ไม่ผ่านการอนุมัติการเปิดบัญชี',
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
                                                ],
                                              ),
                                              Spacer(),
                                              // StreamBuilder(
                                              //     stream: FirebaseFirestore
                                              //         .instance
                                              //         .collection(AppSettings
                                              //                     .customerType ==
                                              //                 CustomerType.Test
                                              //             ? 'CustomerTest'
                                              //             : 'Customer')
                                              //         .snapshots(),
                                              //     builder: (context, snapshot) {
                                              //       if (snapshot
                                              //               .connectionState ==
                                              //           ConnectionState
                                              //               .waiting) {
                                              //         return SizedBox();
                                              //       }
                                              //       if (snapshot.hasError) {
                                              //         return Text(
                                              //             'เกิดข้อผิดพลาด: ${snapshot.error}');
                                              //       }
                                              //       if (!snapshot.hasData) {
                                              //         return Text(
                                              //             'ไม่พบข้อมูล');
                                              //       }
                                              //       if (snapshot
                                              //           .data!.docs.isEmpty) {
                                              //         print(snapshot.data);
                                              //       }

                                              //       print(
                                              //           'stream stream CustomerTest');

                                              //       customerController
                                              //           .updateCustomerData(
                                              //               snapshot.data);
                                              //       // print(customerController
                                              //       // .customerData!.length);

                                              //       Map<String, dynamic>
                                              //           customerMap = {};
                                              //       //     data.docs.first.data() as Map<String, dynamic>;

                                              //       for (int index = 0;
                                              //           index <
                                              //               snapshot.data!.docs
                                              //                   .length;
                                              //           index++) {
                                              //         final Map<String, dynamic>
                                              //             docData = snapshot
                                              //                     .data!
                                              //                     .docs[index]
                                              //                     .data()
                                              //                 as Map<String,
                                              //                     dynamic>;

                                              //         customerMap[
                                              //                 'key${index}'] =
                                              //             docData;
                                              //       }
                                              //       // print('aaaa');
                                              //       // print(customerMap);

                                              //       Map<String, dynamic>
                                              //           filteredData =
                                              //           Map.fromEntries(
                                              //         customerMap.entries.where((entry) =>
                                              //             entry.value[
                                              //                     'สถานะ'] ==
                                              //                 false &&
                                              //             entry.value[
                                              //                     'บันทึกพร้อมตรวจ'] ==
                                              //                 false &&
                                              //             entry.value[
                                              //                     'รอการอนุมัติ'] ==
                                              //                 false &&
                                              //             userData![
                                              //                     'EmployeeID'] ==
                                              //                 entry.value[
                                              //                     'รหัสพนักงานขาย']),
                                              //       );
                                              //       return
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width: 26.5,
                                                    height: 26.5,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(5.0,
                                                              2.0, 5.0, 5.0),
                                                      child: Text(
                                                        customerAllNoApplove
                                                            .length
                                                            .toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                      ),
                                                    ),

                                                    //  Padding(
                                                    //   padding: EdgeInsetsDirectional
                                                    //       .fromSTEB(
                                                    //           5.0, 5.0, 5.0, 5.0),
                                                    //   child: Text(
                                                    // filteredData.length.toString(),
                                                    //     style: FlutterFlowTheme.of(
                                                    //             context)
                                                    //         .bodyMedium
                                                    //         .override(
                                                    //           fontFamily: 'Kanit',
                                                    //           color: FlutterFlowTheme
                                                    //                   .of(context)
                                                    //               .primaryBackground,
                                                    //         ),
                                                    //   ),
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                              //   ;
                                              // }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
