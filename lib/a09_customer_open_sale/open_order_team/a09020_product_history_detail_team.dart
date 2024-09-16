import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:m_food/a09_customer_open_sale/a09021_address_setting.dart';
import 'package:m_food/a09_customer_open_sale/a0902_customer_history_list.dart';
import 'package:m_food/a09_customer_open_sale/a0905_success_order_product.dart';
import 'package:m_food/a09_customer_open_sale/open_order_team/a09021_address_setting_team.dart';
import 'package:m_food/a09_customer_open_sale/open_order_team/a090501_product_screen_edit_team.dart';
import 'package:m_food/a09_customer_open_sale/widget/a0904_product_order_model.dart';
import 'package:m_food/a20_add_new_customer_first/widget/form_open_customer_edit.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/custom_text.dart';
import 'package:quickalert/quickalert.dart';
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

class A09020ProductHistoryDetailTeam extends StatefulWidget {
  final String? customerID;
  final Map<String, dynamic>? orderDataMap;

  final String? userIDOpen;
  final String? userNameOpen;
  final String? idEmployee;

  const A09020ProductHistoryDetailTeam({
    super.key,
    this.orderDataMap,
    this.customerID,
    @required this.idEmployee,
    @required this.userIDOpen,
    @required this.userNameOpen,
  });

  @override
  _A09020ProductHistoryDetailTeamState createState() =>
      _A09020ProductHistoryDetailTeamState();
}

class _A09020ProductHistoryDetailTeamState
    extends State<A09020ProductHistoryDetailTeam> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  late Map<String, dynamic> orderLast;

  // late A0904ProductOrderModel _model;

  final productController = Get.find<ProductController>();
  RxMap<String, dynamic>? productGetData;

  late Map<String, dynamic> customerDataFetch;

  List<Map<String, dynamic>> resultList = [];

  late Map<String, dynamic> orderList;

  List<int> productCount = [];

  List<String> productImage = [];

  bool isLoading = false;
  bool isLoading2 = false;

  var jsonStringDiscount;
  List<Map<String, dynamic>> productPromotionDiscount = [];

  var jsonStringBonusItem;
  List<Map<String, dynamic>> productPromotionBonusItem = [];

  TextEditingController inModalDialog = TextEditingController(text: '0');

  List<Map<String, dynamic>?> productCovertRatio = [];

  double customerPercentDiscount = 0.0;

  List<Map<String, dynamic>> newOrder = [];

  bool statusOrderPass = true;
  bool showButtonEdit = false;
  bool showButtonEditDayAfter = false;
  bool showButtonCancleOrder = false;

  String orderDateBefore = '';
  String orderDateBeforeDay = '';
  String orderDateBeforeString = '';

  bool showCheckbox = false;

  List<bool> checkBoxList = [];
  Map<String, dynamic>? customerDataWithmfoodtoken;

  Map<String, dynamic>? urlApi;

  @override
  void initState() {
    // _model = createModel(context, () => A0904ProductOrderModel());
    loadData();
    super.initState();
  }

  List<dynamic> deepCopyList(List<dynamic> original) {
    List<dynamic> copy = [];
    for (var value in original) {
      if (value is Map<String, dynamic>) {
        copy.add(deepCopyMap(value));
      } else if (value is List) {
        copy.add(deepCopyList(value));
      } else {
        copy.add(value);
      }
    }
    return copy;
  }

  Map<String, dynamic> deepCopyMap(Map<String, dynamic> original) {
    Map<String, dynamic> copy = {};
    original.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        copy[key] = deepCopyMap(value);
      } else if (value is List) {
        copy[key] = deepCopyList(value);
      } else {
        copy[key] = value;
      }
    });
    return copy;
  }

  String convertFirebaseTimestampToDateString(Timestamp timestamp) {
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

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      //==============================================================
      // ดึงข้อมูลจาก collection 'mfoodtoken'
      DocumentSnapshot customerDocmfoodtoken = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'mfoodtoken'
              : 'mfoodtoken')
          .doc('EDpTMkR8myW4zhdUALCP')
          .get();

      print('customerid');
      print(widget.customerID);

      if (customerDocmfoodtoken.exists) {
        customerDataWithmfoodtoken =
            customerDocmfoodtoken.data() as Map<String, dynamic>?;
      }

      print(customerDataWithmfoodtoken!['token_key']);
      print(customerDataWithmfoodtoken!['token_key']);
      print(customerDataWithmfoodtoken!['token_key']);
      print(customerDataWithmfoodtoken!['token_key']);
      print(customerDataWithmfoodtoken!['token_key']);

      //==============================================================

      // ดึงข้อมูลจาก collection 'mfoodtoken'
      DocumentSnapshot urlApiWithPort = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'AppSettingUrl'
              : 'AppSettingUrl')
          .doc(AppSettings.customerType == CustomerType.Test ? '7104' : '7105')
          .get();

      if (urlApiWithPort.exists) {
        urlApi = urlApiWithPort.data() as Map<String, dynamic>?;
      }

      print(urlApi!['Url']);
      print(urlApi!['Url']);
      print(urlApi!['Url']);
      print(urlApi!['Url']);
      print(urlApi!['Url']);

      //==============================================================
      //=======================================================================================
      // ดึงข้อมูลจาก collection 'Customer'
      DocumentSnapshot customerDoc = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'CustomerTest'
              : 'Customer')
          .doc(widget.customerID)
          .get();

      Map<String, dynamic> data = customerDoc.data() as Map<String, dynamic>;

      customerDataFetch = customerDoc.data() as Map<String, dynamic>;

      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);

      //=======================================================================================

      productGetData = productController.productData;

      if (productGetData != null) {
        productGetData!.forEach((key, value) {
          Map<String, dynamic> entry = value;

          resultList.add(entry);
        });
      }

      orderList = widget.orderDataMap!;

      //==============================================================
      CollectionReference orderColection = FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'OrdersTest'
              : 'Orders');

      QuerySnapshot orderSubCollections = await orderColection
          .where('OrdersDateID', isEqualTo: orderList['OrdersDateID'])
          .get();

      String? saleOrderIdRef;
      String? saleOrderIdINVOICENO;
      for (var doc in orderSubCollections.docs) {
        // ตรวจสอบหลายฟิลด์
        var data = doc.data() as Map<String, dynamic>;

        saleOrderIdRef = data.containsKey('SALE_ORDER_ID_REF') ? 'Y' : 'N';
        saleOrderIdINVOICENO = data.containsKey('INVOICE_NO') ? 'Y' : 'N';
        break;
      }
      if (orderSubCollections.docs.isNotEmpty) {
        print('orderSubCollections.docs.isNotEmpty');

        print(orderList['SALE_ORDER_ID_REF']);
        if (saleOrderIdRef == 'Y') {
          orderList['SALE_ORDER_ID_REF'] =
              orderSubCollections.docs.first['SALE_ORDER_ID_REF'];

          orderList['SALE_ORDER_ID'] =
              orderSubCollections.docs.first['SALE_ORDER_ID'];
        } else {
          orderList['SALE_ORDER_ID_REF'] = null;
        }

        print(orderList['INVOICE_NO']);
        if (saleOrderIdINVOICENO == 'Y') {
          orderList['INVOICE_NO'] =
              orderSubCollections.docs.first['INVOICE_NO'];
        } else {
          orderList['INVOICE_NO'] = null;
        }

        if (orderList['SALE_ORDER_ID_REF'] == null) {
          if (orderSubCollections.docs.first['SectionID2'] ==
              '20240309000000') {
            orderList['SectionID2'] = 'อยู่ระหว่างออกบิลขาย';
            orderList['SALE_ORDER_ID_REF'] = null;
          } else if (orderSubCollections.docs.first['SectionID2'] ==
              '20240309000002') {
            orderList['SectionID2'] = 'บุ๊กกิ้งออเดอร์';
            orderList['SALE_ORDER_ID_REF'] = null;
            orderList['INVOICE_NO'] = saleOrderIdINVOICENO == 'Y'
                ? orderSubCollections.docs.first['INVOICE_NO']
                : null;

            orderList['docId'] = orderSubCollections.docs.first['docId'];
          }
          print(orderList['SectionID2']);
          print(orderList['SALE_ORDER_ID_REF']);
          print(orderList['INVOICE_NO']);
        } else {
          if (orderSubCollections.docs.first['SectionID2'] ==
              '20240309000000') {
            orderList['SectionID2'] = 'อยู่ระหว่างออกบิลขาย';
            orderList['SALE_ORDER_ID_REF'] =
                orderSubCollections.docs.first['SALE_ORDER_ID_REF'];
          } else if (orderSubCollections.docs.first['SectionID2'] ==
              '20240309000002') {
            orderList['SectionID2'] = 'บุ๊กกิ้งออเดอร์';
            orderList['SALE_ORDER_ID_REF'] =
                orderSubCollections.docs.first['SALE_ORDER_ID_REF'];
            orderList['INVOICE_NO'] = saleOrderIdINVOICENO == 'Y'
                ? orderSubCollections.docs.first['INVOICE_NO']
                : null;

            orderList['docId'] = orderSubCollections.docs.first['docId'];
          }
          print(orderList['SectionID2']);
          print(orderList['SALE_ORDER_ID_REF']);
          print(orderList['INVOICE_NO']);
        }
      } else {
        print('orderSubCollections.docs.isEmpty');
      }
      //==============================================================
      print('SectionID2 && SALE_ORDER_ID_REF');
      print(orderList['SectionID2']);
      print(orderList['SALE_ORDER_ID_REF']);
      print(orderList['INVOICE_NO']);
      if (orderList['SectionID2'] == 'บุ๊กกิ้งออเดอร์') {
        showButtonEdit = true;
      } else if (orderList['SectionID2'] == 'อยู่ระหว่างออกบิลขาย' &&
          orderList['SALE_ORDER_ID_REF'] != null) {
        showButtonEdit = true;
      }
      String timestampString = orderList['วันเวลาจัดส่ง'].toDate().toString();
      DateTime dateTimeCheck = DateTime(
        DateTime.parse(timestampString).year,
        DateTime.parse(timestampString).month,
        DateTime.parse(timestampString).day,
      );

      DateTime now = DateTime.now();
      DateTime nowDate = DateTime(now.year, now.month, now.day);

      // เช็คสองเงื่อนไข: วันเดียวกันหรือ now น้อยกว่า
      showButtonEditDayAfter = nowDate.isBefore(dateTimeCheck) ||
          nowDate.isAtSameMomentAs(dateTimeCheck);

      // แสดงผลลัพธ์
      print('Show button: $showButtonEditDayAfter');

      if (orderList['INVOICE_NO'] == null) {
        showButtonCancleOrder = true;
      }

      //==============================================================

      //==============================================================

      // String timestampString = orderList['วันเวลาจัดส่ง'].toDate().toString();
      // DateTime dateTimeCheck = DateTime(
      //   DateTime.parse(timestampString).year,
      //   DateTime.parse(timestampString).month,
      //   DateTime.parse(timestampString).day,
      // );

      // DateTime now = DateTime.now();
      // DateTime nowDate = DateTime(now.year, now.month, now.day);

      // // เช็คสองเงื่อนไข: วันเดียวกันหรือ now น้อยกว่า
      // showButtonEditDayAfter = nowDate.isBefore(dateTimeCheck) ||
      //     nowDate.isAtSameMomentAs(dateTimeCheck);

      // // แสดงผลลัพธ์
      // print('Show button: $showButtonEditDayAfter');

      //==============================================================

      List<String> imageList = [];

      for (var elementList in orderList['ProductList']) {
        print('0');
        Map<String, dynamic>? result = resultList.firstWhere(
          (element) => element['DocId'] == elementList['DocID'],
          orElse: () => {},
        );
        print('01');
        imageList.add(result['รูปภาพ'] == null || result['รูปภาพ'].isEmpty
            ? ''
            : result['รูปภาพ'][0]);

        checkBoxList.add(false);
      }

      productImage = imageList;

      print('0000');
      print(orderList);
      print(orderList['ProductList']);

      print(imageList.length);
      print(imageList);

      print('0000');

      if (orderList['วันเวลาจัดส่ง'].runtimeType.toString() == 'Timestamp') {
        Timestamp timestamp = orderList['วันเวลาจัดส่ง'];
        String dateString = convertFirebaseTimestampToDateString(timestamp);

        orderDateBefore = dateString;
        // String dateString2 =
        //     convertTimestampToDateString(int.parse(orderList['วันเวลาจัดส่ง_day'].toString));

        // orderDateBeforeDay = dateString2;
        // String dateString3 =
        //     convertTimestampToDateString(int.parse(orderList['วันเวลาจัดส่ง_string'].toString));
        // orderDateBeforeString = dateString3;

        orderList['วันเวลาจัดส่ง'] = orderDateBefore;
        orderDateBeforeDay = orderList['วันเวลาจัดส่ง_day'].toString();
        orderDateBeforeString = orderList['วันเวลาจัดส่ง_string'].toString();
        print('--------- covert timpstamp --------------');
      } else {
        orderDateBefore = orderList['วันเวลาจัดส่ง'].toString();
        orderDateBeforeDay = orderList['วันเวลาจัดส่ง_day'].toString();
        orderDateBeforeString = orderList['วันเวลาจัดส่ง_string'].toString();
      }

      // print(orderList!['วันเวลาจัดส่ง']);
      // print(orderList!['วันเวลาจัดส่ง']);

      // print(orderList!['วันเวลาจัดส่ง_day']);
      // print(orderList!['ListCustomerAddressID']);

      // print(orderList);

      //====================== คิดยอดบิล ========================================

      double sumTotalVat = 0.0;
      double sumTotalNoVat = 0.0;

      // for (var element in orderList['ProductList']) {
      for (int i = 0; i < orderList['ProductList'].length; i++) {
        Map<String, dynamic> dataMap = resultList.firstWhere((product) =>
            product['PRODUCT_ID'] == orderList['ProductList'][i]['ProductID']);
        print(dataMap['VAT_TYPE']);
        print(dataMap['NAMES']);

        orderList['ProductList'][i]['ประเภทสินค้าDesc'] =
            dataMap['ประเภทสินค้าDesc'];

        orderList['ProductList'][i]['RESULT'] = dataMap['RESULT'];

        if (dataMap['VAT_TYPE'] == 'V') {
          print('v');
          if (orderList['ProductList'][i]['ส่วนลดรายการ'] == null) {
            print('is null');
            orderList['ProductList'][i]['ส่วนลดรายการ'] = '0.0';
          }
          if (orderList['ProductList'][i]['ส่วนลดรายการ'] != '0.0') {
            double discount = double.parse(
                orderList['ProductList'][i]['ส่วนลดรายการ'].toString());

            // print(discount);
            sumTotalVat = sumTotalVat +
                (double.parse(orderList['ProductList'][i]['จำนวน'].toString()) *
                    double.parse(
                        orderList['ProductList'][i]['ราคา'].toString()));
            // print(sumTotalVat);

            sumTotalVat = sumTotalVat - discount;
          } else {
            // print(sumTotalVat);
            sumTotalVat = sumTotalVat +
                (double.parse(orderList['ProductList'][i]['จำนวน'].toString()) *
                    double.parse(
                        orderList['ProductList'][i]['ราคา'].toString()));
            // print(sumTotalVat);
          }
        } else {
          print('n');

          if (orderList['ProductList'][i]['ส่วนลดรายการ'] == null) {
            print('is null');

            orderList['ProductList'][i]['ส่วนลดรายการ'] = '0.0';
          }
          if (orderList['ProductList'][i]['ส่วนลดรายการ'] != '0.0') {
            double discount = double.parse(
                orderList['ProductList'][i]['ส่วนลดรายการ'].toString());
            // print(discount);

            sumTotalNoVat = sumTotalNoVat +
                (double.parse(orderList['ProductList'][i]['จำนวน'].toString()) *
                    double.parse(
                        orderList['ProductList'][i]['ราคา'].toString()));
            sumTotalNoVat = sumTotalNoVat - discount;
            // print(sumTotalNoVat);
          } else {
            sumTotalNoVat = sumTotalNoVat +
                (double.parse(orderList['ProductList'][i]['จำนวน'].toString()) *
                    double.parse(
                        orderList['ProductList'][i]['ราคา'].toString()));
            // print(sumTotalNoVat);
          }
        }

        // if (dataMap['VAT_TYPE'] == 'V') {
        //   // print(sumTotalVat);
        //   // print(element['จำนวน']);
        //   // print(element['ราคา']);
        //   sumTotalVat = sumTotalVat +
        //       (orderList['ProductList'][i]['จำนวน'] *
        //           double.parse(orderList['ProductList'][i]['ราคา']));
        // } else {
        //   sumTotalNoVat = sumTotalNoVat +
        //       (orderList['ProductList'][i]['จำนวน'] *
        //           double.parse(orderList['ProductList'][i]['ราคา']));
        // }

        // print('จำนวนสต๊อก');
        // orderList['ProductList'][i]['จำนวนสต๊อก'] = dataMap['Balance'];
        // String numberString = dataMap['Balance'];
        // String result = numberString.indexOf('.') != -1
        //     ? numberString.substring(0, numberString.indexOf('.'))
        //     : numberString;
        // orderList['ProductList'][i]['จำนวนสต๊อก'] = result;
        // print(orderList['ProductList'][i]['จำนวนสต๊อก']);

        // total = total + sumTotal;
        if (orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] == true) {
          orderList['ProductList'][i]['RESULT'] = false;
        }
      }
      // }

      // print('for first');

      // for (int i = 0; i < orderList['ProductList'].length; i++) {
      //   // Map<String, dynamic> dataMap = resultList.firstWhere((product) =>
      //   //     product['PRODUCT_ID'] == orderList['ProductList'][i]['ProductID']);

      //   // orderList['ProductList'][i]['จำนวนสต๊อก'] =
      //   //     int.parse(dataMap['Balance']);
      //   // print(orderList['ProductList'][i]['จำนวนสต๊อก']);

      //   print(orderList['ProductList'][i]['จำนวนสต๊อก']);

      //   double one =
      //       double.parse(orderList['ProductList'][i]['จำนวนสต๊อก'].toString());

      //   double stockTotal = one;

      //   print(stockTotal);
      //   print(stockTotal.toStringAsFixed(
      //       stockTotal.truncateToDouble() == stockTotal ? 0 : 1));

      //   orderList['ProductList'][i]['จำนวนสต๊อก'] = stockTotal.toStringAsFixed(
      //       stockTotal.truncateToDouble() == stockTotal ? 0 : 1);
      // }

      // print('for second');

      orderList['ส่วนลด'] = 0.0;
      orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
      orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
      orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] =
          sumTotalVat - ((sumTotalVat * 7) / 107);
      orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
      orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;
      orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;

      // print(orderList['ส่วนลด']);
      // print(orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม']);
      // print(orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม']);
      // print(orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม']);
      // print(orderList['ภาษีมูลค่าเพิ่ม']);
      // print(orderList['มูลค่าสินค้ารวม']);
      // print('for third');

      //==============================================================

      // print('totalA');

      double totalA = double.parse(
          orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'].toString());

      // orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'];

      // print(totalA);
      double totalB = double.parse(
          orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'].toString());
      // orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'];
      // print(totalB);

      double totalAll = totalA + totalB;

      DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

      // String totalAllString = NumberFormat('#,##0.00').format(totalAll);

      // String totalPriceSum = totalAllString;
      // print(totalAll);
      // print(totalAll);
      // print(totalAll);
      // print(totalAll);
      // print(totalAll);

      HttpsCallable callableBillLast =
          FirebaseFunctions.instance.httpsCallable('getApiMfood');
      var paramsBillLast = AppSettings.customerType == CustomerType.Test
          ? <String, dynamic>{
              "url":
                  "${urlApi!['Url']}:7104/MBServices.asmx?op=BILL_DISCOUNT_INFO",
              // "http://mobile.mfood.co.th:7105/MBServices.asmx?op=SALES_ITEM_PROMOTION",
              "xml":
                  //pro type discount
                  // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>${data['ClientIdจากMfoodAPI']}</Client_ID><ITEMCODE>${orderList['ProductList'][i]['ProductID']}</ITEMCODE><UM>${orderList['ProductList'][i]['ยูนิต']}</UM><QTY>${orderList['ProductList'][i]['จำนวน']}</QTY><DOC_DATE>$formattedDate</DOC_DATE><ITEMAMT>$totalPrice</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
                  //pro type bonus item
                  // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>01000004</Client_ID><ITEMCODE>0271330020450</ITEMCODE><UM>ซอง</UM><QTY>20</QTY><DOC_DATE>2024-04-01</DOC_DATE><ITEMAMT>980</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
                  '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><BILL_DISCOUNT_INFO xmlns="MFOODMOBILEAPI"><Token>${customerDataWithmfoodtoken!['token_key']}</Token><PROMO_DATE>$formattedDate</PROMO_DATE><CUSTMER_ID>${data['ClientIdจากMfoodAPI']}</CUSTMER_ID><BILL_AMT>$totalAll</BILL_AMT></BILL_DISCOUNT_INFO></soap12:Body></soap12:Envelope>'
            }
          : <String, dynamic>{
              "url":
                  "${urlApi!['Url']}:7105/MBServices.asmx?op=BILL_DISCOUNT_INFO",
              // "http://mobile.mfood.co.th:7105/MBServices.asmx?op=SALES_ITEM_PROMOTION",
              "xml":
                  //pro type discount
                  // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>${data['ClientIdจากMfoodAPI']}</Client_ID><ITEMCODE>${orderList['ProductList'][i]['ProductID']}</ITEMCODE><UM>${orderList['ProductList'][i]['ยูนิต']}</UM><QTY>${orderList['ProductList'][i]['จำนวน']}</QTY><DOC_DATE>$formattedDate</DOC_DATE><ITEMAMT>$totalPrice</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
                  //pro type bonus item
                  // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>01000004</Client_ID><ITEMCODE>0271330020450</ITEMCODE><UM>ซอง</UM><QTY>20</QTY><DOC_DATE>2024-04-01</DOC_DATE><ITEMAMT>980</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
                  '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><BILL_DISCOUNT_INFO xmlns="MFOODMOBILEAPI"><Token>${customerDataWithmfoodtoken!['token_key']}</Token><PROMO_DATE>$formattedDate</PROMO_DATE><CUSTMER_ID>${data['ClientIdจากMfoodAPI']}</CUSTMER_ID><BILL_AMT>$totalAll</BILL_AMT></BILL_DISCOUNT_INFO></soap12:Body></soap12:Envelope>'
            };

      // print(paramsDiscount['xml']);
      // print('======================================= aaaaa');

      await callableBillLast.call(paramsBillLast).then((value) async {
        print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
        if (value.data['status'] == 'success') {}

        Xml2Json xml2json = Xml2Json();
        xml2json.parse(value.data.toString());

        jsonStringDiscount = xml2json.toOpenRally();

        Map<String, dynamic> data = json.decode(jsonStringDiscount);

        // print('================= 44444444 ===================');
// I/flutter (11081): {Envelope: {soap: http://www.w3.org/2003/05/soap-envelope, xsi: http://www.w3.org/2001/XMLSchema-instance, xsd: http://www.w3.org/2001/XMLSchema, Body: {BILL_DISCOUNT_INFOResponse: {xmlns: MFOODMOBILEAPI, BILL_DISCOUNT_INFOResult: {RESULT: true, BILLING_DISCOUNT_PERCENT: 2%, BILLING_DISCOUNT_BAHT: 0}}}}}
        // print(data);
        // print(data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']);

        if (data['Envelope']['Body']['BILL_DISCOUNT_INFOResponse']
                ['BILL_DISCOUNT_INFOResult'] ==
            'true') {
        } else {
          Map<String, dynamic> sellPriceResponse = data['Envelope']['Body']
              ['BILL_DISCOUNT_INFOResponse']['BILL_DISCOUNT_INFOResult'];

          // print('================= 5 ===================');
          // print(sellPriceResponse);

          // double totalNovat =
          //     double.parse(orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม']);
          // double totalVatButNovat =
          //     double.parse(orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม']);

          String percentageString =
              sellPriceResponse['BILLING_DISCOUNT_PERCENT'];
          double percentage =
              double.parse(percentageString.replaceAll('%', '')) / 100;

          customerPercentDiscount = percentage;

          print('ส่วนลดลูกค้า');
          print(customerPercentDiscount);

          // setState(() {});
        }
      }).whenComplete(() async {
        double total = orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] +
            orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'];

        total = total * customerPercentDiscount;

        print('ส่วนลดท้ายบิล');

        print(total);

        String totalPriceDiscountDoubleString =
            total.toStringAsFixed(2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

        orderList['ยอดรวมส่วนลดท้ายบิล'] = totalPriceDiscountDoubleString;

        orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] -
            double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);
      });
      print('0000000');
      //============= ดึงข้อมูล product coverrt ratio ไว้เทียบ =====================
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('PROUDUCT_CONVERT_RATIO')
              .get();

      for (QueryDocumentSnapshot customerDoc in querySnapshot.docs) {
        Map<String, dynamic> customerData =
            customerDoc.data() as Map<String, dynamic>;

        productCovertRatio.add(customerData);
      }
      print('000111');

      // ===============================================================

      for (var key in orderList.keys) {
        var value = orderList[key];
        // print('Key: $key, Value: $value');
        if (key == 'ProductList') {
          for (var element in value) {
            double total = double.parse(element['จำนวน'].toString());

            productCount.add(int.parse(total.toStringAsFixed(0)));
          }
        }
        // ทำสิ่งที่คุณต้องการกับแต่ละ key และ value
      }

      print('0000000111111');

      // print('for fouth');

      // print(productCount);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String customFormatThai(DateTime dateTime) {
    final List<String> monthNames = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];

    String day = dateTime.day.toString();
    String month = monthNames[dateTime.month - 1];
    String year =
        (dateTime.year + 543).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

    return '$day $month $year';
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

  String priceSumProduct(double price, int total) {
    double totalPrice = price * total;

    String totalPriceAsString = totalPrice
        .toStringAsFixed(2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

    print(totalPriceAsString); // Output: 31.50 (เป็น double)

    // double formattedTotalPrice = double.parse(
    //     totalPriceAsString); // แปลงสตริงที่มีทศนิยม 2 ตำแหน่งเป็น double
    // print(formattedTotalPrice); // Output: 31.50 (เป็น double)

    return totalPriceAsString;
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;

    print('==============================');
    print('This is A09020 Product History Detail');
    print(widget.customerID);
    print('==============================');

    // productGetData = productController.productData;

    // List<Map<String, dynamic>> resultList = [];

    // if (productGetData != null) {
    //   productGetData!.forEach((key, value) {
    //     // print(value);/
    //     Map<String, dynamic> entry = value;
    //     resultList.add(entry);
    //     // print(entry);
    //   });
    // }

    // print(userData!['EmployeeID']);
    // print(userData!['EmployeeID']);
    // print(userData!['EmployeeID']);
    // print(userData!['EmployeeID']);
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
                                  'ประวัติการสั่งซื้อ',
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
                        //                       'รวมรายการสินค้า ${NumberFormat('#,##0.00').format(orderList['ยอดรวม']).toString()} บาท',
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

                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 14, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'ผู้เปิดออเดอร์แทน : ',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                              ),
                              Text(
                                widget.userIDOpen!,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                              ),
                              Text(
                                ' ' + widget.userNameOpen!,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: 'Kanit',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 25,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // color: Colors.amber,
                                  // width: 225,
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            3.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'ออเดอร์ไอดี ${widget.orderDataMap!['OrdersDateID']}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Kanit',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'วันที่ ${customFormatThai(widget.orderDataMap!['OrdersUpdateTime'].toDate())}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Kanit',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                customerDataFetch['ประเภทลูกค้า'] == 'Company'
                                    ? customerDataFetch['ชื่อบริษัท']
                                    : customerDataFetch['ชื่อนามสกุล'],
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

                        const SizedBox(height: 2),

                        //============== Order List =====================================
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            // height: 4000,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .accent3
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText
                                    .withOpacity(0.5),
                              ),
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
                                                      showCheckbox
                                                          ? Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                orderList['ProductList'][i]
                                                                            [
                                                                            'RESULT'] ==
                                                                        true
                                                                    ? Checkbox(
                                                                        value:
                                                                            checkBoxList[i],
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkBoxList[i] =
                                                                                value!;

                                                                            if (checkBoxList[i]) {
                                                                              print(orderList['ProductList'][i]);
                                                                            }
                                                                          });
                                                                        },
                                                                      )
                                                                    : Checkbox(
                                                                        value:
                                                                            checkBoxList[i],
                                                                        onChanged:
                                                                            null,
                                                                      )
                                                              ],
                                                            )
                                                          : SizedBox(),
                                                      Column(
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
                                                                    10.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child: productImage[
                                                                          i] ==
                                                                      null
                                                                  ? Image.asset(
                                                                      'assets/images/noproductimage.png',
                                                                      width:
                                                                          65.0,
                                                                      height:
                                                                          65.0,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    )
                                                                  : productImage[
                                                                              i] ==
                                                                          ''
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/images/noproductimage.png',
                                                                          width:
                                                                              65.0,
                                                                          height:
                                                                              65.0,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )
                                                                      : Image
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
                                                            orderList['ProductList']
                                                                        [i][
                                                                    'ชื่อสินค้า'] ??
                                                                'ไม่มีชื่อสินค้า',
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
                                                          Text(
                                                            orderList['ProductList']
                                                                        [i][
                                                                    'ประเภทสินค้าDesc'] ??
                                                                'ไม่มีประเภทสินค้า',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.3,
                                                            decoration:
                                                                const BoxDecoration(),
                                                            child: Text(
                                                              orderList['ProductList']
                                                                          [i][
                                                                      'คำอธิบายสินค้า'] ??
                                                                  '',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Kanit',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                  ),
                                                              maxLines: 3,
                                                            ),
                                                          ),
                                                          orderList['ProductList']
                                                                          [i][
                                                                      'RESULT'] ==
                                                                  false
                                                              ? Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.3,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child: Text(
                                                                    orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] ==
                                                                            true
                                                                        ? 'สินค้าของแถม'
                                                                        : 'สินค้าปิดการสั่งขาย',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color: Colors
                                                                              .red
                                                                              .shade900,
                                                                        ),
                                                                    maxLines: 3,
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  // orderList['ProductList'][i]
                                                  //         ['ราคาพิเศษ']
                                                  //     ? Row(
                                                  //         mainAxisSize:
                                                  //             MainAxisSize.max,
                                                  //         children: [
                                                  //           Padding(
                                                  //             padding:
                                                  //                 const EdgeInsetsDirectional
                                                  //                     .fromSTEB(
                                                  //                     0.0,
                                                  //                     0.0,
                                                  //                     10.0,
                                                  //                     0.0),
                                                  //             child: Container(
                                                  //               decoration:
                                                  //                   BoxDecoration(
                                                  //                 color: FlutterFlowTheme.of(
                                                  //                         context)
                                                  //                     .error,
                                                  //                 borderRadius:
                                                  //                     BorderRadius
                                                  //                         .circular(
                                                  //                             15.0),
                                                  //               ),
                                                  //               child: Padding(
                                                  //                 padding:
                                                  //                     const EdgeInsetsDirectional
                                                  //                         .fromSTEB(
                                                  //                         10.0,
                                                  //                         4.0,
                                                  //                         10.0,
                                                  //                         4.0),
                                                  //                 child: Text(
                                                  //                   'สินค้าโปรโมชั่น',
                                                  //                   style: FlutterFlowTheme.of(
                                                  //                           context)
                                                  //                       .bodySmall
                                                  //                       .override(
                                                  //                         fontFamily:
                                                  //                             'Kanit',
                                                  //                         color:
                                                  //                             FlutterFlowTheme.of(context).primaryBackground,
                                                  //                       ),
                                                  //                 ),
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                  //           Text(
                                                  //             '',
                                                  //             style: FlutterFlowTheme
                                                  //                     .of(context)
                                                  //                 .bodyMedium,
                                                  //           ),
                                                  //         ],
                                                  //       )
                                                  //     : SizedBox()
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // color: Colors.yellow,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
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
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  20.0,
                                                                  0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment.start,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  // Padding(
                                                                  //   padding: EdgeInsets
                                                                  //       .fromLTRB(
                                                                  //           0,
                                                                  //           0,
                                                                  //           5,
                                                                  //           0),
                                                                  //   child: Text(
                                                                  //     'สินค้าคงเหลือ ${orderList['ProductList'][i]['จำนวนสต๊อก']} ${orderList['ProductList'][i]['ยูนิต']}',
                                                                  //     style: FlutterFlowTheme.of(
                                                                  //             context)
                                                                  //         .bodyLarge
                                                                  //         .override(
                                                                  //           fontFamily:
                                                                  //               'Kanit',
                                                                  //           color:
                                                                  //               Colors.red,
                                                                  //           fontSize:
                                                                  //               8,
                                                                  //         ),
                                                                  //   ),
                                                                  // ),
                                                                  Container(
                                                                    // height: 32.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .accent2,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: 30.0,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                shape: BoxShape.rectangle,
                                                                              ),
                                                                              child: StatefulBuilder(builder: (context, setState) {
                                                                                return Row(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () async {},
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                                                                        decoration: BoxDecoration(
                                                                                          shape: BoxShape.rectangle,
                                                                                          color: Theme.of(context).disabledColor.withOpacity(0.2),
                                                                                        ),
                                                                                        child: Text(
                                                                                          productCount[i].toString(),
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 14.0,
                                                                                            fontFamily: 'Kanit',
                                                                                            letterSpacing: 1.0,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              }),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              5.0,
                                                                              0.0,
                                                                              5.0,
                                                                              0.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                orderList['ProductList'][i]['ยูนิต'].toString(),
                                                                                // 'หน่วย',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                // mainAxisAlignment:
                                                                //     MainAxisAlignment
                                                                //         .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    'ราคา ${orderList['ProductList'][i]['ราคา'].toString()} บาท ',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                        ),
                                                                  ),
                                                                  // Text(
                                                                  //   'ราคารวม ${priceSumProduct(double.parse(orderList['ProductList'][i]['ราคา']), productCount[i]).toString()} บาท ',

                                                                  //   // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                  //   style: FlutterFlowTheme.of(
                                                                  //           context)
                                                                  //       .bodyLarge
                                                                  //       .override(
                                                                  //         fontFamily:
                                                                  //             'Kanit',
                                                                  //         color: FlutterFlowTheme.of(context)
                                                                  //             .primaryText,
                                                                  //       ),
                                                                  // ),
                                                                  // Text(
                                                                  //   'ส่วนลดรายการ ${orderList['ProductList'][i]['ส่วนลด']} บาท ',

                                                                  //   // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                  //   style: FlutterFlowTheme.of(
                                                                  //           context)
                                                                  //       .bodyLarge
                                                                  //       .override(
                                                                  //         fontFamily:
                                                                  //             'Kanit',
                                                                  //         color: FlutterFlowTheme.of(context)
                                                                  //             .primaryText,
                                                                  //       ),
                                                                  // ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ราคารวม ${priceSumProduct(double.parse(orderList['ProductList'][i]['ราคา'].toString()), productCount[i]).toString()} บาท ',

                                                                    // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              orderList['ProductList']
                                                                              [
                                                                              i]
                                                                          [
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
                                                              orderList['ProductList']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'มีของแถม'] ==
                                                                      false
                                                                  ? SizedBox()
                                                                  : SizedBox(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Text(
                                                                                'รายการของแถม',

                                                                                // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Kanit',
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                maxLines: 2,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Text(
                                                                                '${orderList['ProductList'][i]['ชื่อของแถม']}',

                                                                                // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Kanit',
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.clip,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Text(
                                                                                'จำนวน ${orderList['ProductList'][i]['จำนวนของแถม'].toString()} ${orderList['ProductList'][i]['หน่วยของแถม']}',

                                                                                // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Kanit',
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                maxLines: 2,
                                                                              ),
                                                                            ],
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
                                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                      decoration: const BoxDecoration(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'ยอดรวมส่วนลดรายการทั้งหมด',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'ส่วนลดท้ายบิล/Discount',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม/Value of non VAT (N)',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม/Value including VAT (V)',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม/Value excluding VAT',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'ภาษีมูลค่าเพิ่ม/VAT',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'มูลค่าสินค้ารวม/Grand Total',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${orderList['ยอดรวมส่วนลดทั้งหมด'] == null ? '0.00' : orderList['ยอดรวมส่วนลดทั้งหมด']} บาท',
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
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${orderList['ยอดรวมส่วนลดท้ายบิล']} บาท',
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
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                                // Row(
                                                //   mainAxisSize: MainAxisSize.max,
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.end,
                                                //   children: [
                                                //     Text(
                                                //       '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม']).toString()} บาท',
                                                //       style: FlutterFlowTheme.of(
                                                //               context)
                                                //           .bodyLarge
                                                //           .override(
                                                //             fontFamily: 'Kanit',
                                                //             color: FlutterFlowTheme
                                                //                     .of(context)
                                                //                 .primaryText,
                                                //             fontWeight:
                                                //                 FontWeight.normal,
                                                //           ),
                                                //     ),
                                                //   ],
                                                // ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${NumberFormat('#,##0.00').format(orderList['ภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้ารวม']).toString()} บาท',
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
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryText
                                  .withOpacity(0.5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    orderList['สถานที่จัดส่ง'] == ''
                                        ? 'คุณไม่ได้เลือก'
                                        : orderList['สถานที่จัดส่ง'],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Kanit',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
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
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryText
                                  .withOpacity(0.5),
                            ),
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
                                      orderList['วันเวลาจัดส่ง'] == ''
                                          ? 'คุณไม่ได้เลือก'
                                          : orderList['วันเวลาจัดส่ง']
                                              .toString(),
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
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryText
                                  .withOpacity(0.5),
                            ),
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
                                          orderList['สายส่ง'] == ''
                                              ? 'คุณไม่ได้เลือก'
                                              : orderList['สายส่ง'],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
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
                        //==============  Confirm Button =====================================
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            text: 'ย้อนกลับ',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
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
                        showCheckbox
                            ? Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    List<Map<String, dynamic>>?
                                        nonNullableList = [];

                                    print(checkBoxList);
                                    print(checkBoxList);
                                    print(checkBoxList);
                                    print(checkBoxList);
                                    for (int i = 0;
                                        i < checkBoxList.length;
                                        i++) {
                                      if (checkBoxList[i]) {
                                        print(
                                            'เลือกสินค้านี้ ${orderList['ProductList'][i]['ProductID']}');
                                        orderList['ProductList'][i]['จำนวน'] =
                                            0;
                                        orderList['ProductList'][i]['ราคา'] =
                                            '0';

                                        nonNullableList!
                                            .add(orderList['ProductList'][i]);
                                      } else {
                                        print(
                                            'ไม่เลือกสินค้านี้ ${orderList['ProductList'][i]['ProductID']}');

                                        nonNullableList.add({});
                                      }
                                    }

                                    print(nonNullableList);

                                    nonNullableList!.removeWhere(
                                        (element) => !element.isNotEmpty);

                                    orderList['ProductList'] = [];

                                    orderList['ProductList'] = nonNullableList;

                                    print(nonNullableList.length);
                                    print(nonNullableList.length);
                                    print(nonNullableList.length);
                                    print(nonNullableList.length);
                                    print(nonNullableList.length);
                                    print('ประวัติออเดอร์');

                                    // print(orderList['ProductList']);
                                    // print(orderList['ProductList']);
                                    // print(orderList['ProductList']);
                                    // print(orderList['ProductList']);
                                    // print(orderList['ProductList']);

                                    for (int i = 0;
                                        i < nonNullableList.length;
                                        i++) {
                                      print(nonNullableList[i]['LeadTime']);

                                      //=============== โหลด LeadTime อีกครั้ง =========================

                                      QuerySnapshot querySnapshot =
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  AppSettings.customerType ==
                                                          CustomerType.Test
                                                      ? 'ProductTest'
                                                      : 'Product')
                                              .where('PRODUCT_ID',
                                                  isEqualTo: nonNullableList[i]
                                                      ['ProductID'])
                                              .get();

                                      if (querySnapshot.docs.isNotEmpty) {
                                        // print(querySnapshot.docs.length);
                                        // length == 1 เพราะ PRODUCT_ID มีตัวเดียว

                                        for (var doc in querySnapshot.docs) {
                                          Map<String, dynamic> data = doc.data()
                                              as Map<String, dynamic>;
                                          // print('Document data: ${doc.data()}');
                                          // print('จำนวนสต๊อก');
                                          // print(foundMap['Balance']);

                                          print(data['LeadTime']);

                                          if (data['LeadTime'] == null) {
                                            nonNullableList[i]['LeadTime'] =
                                                '0';
                                          } else {
                                            nonNullableList[i]['LeadTime'] =
                                                data['LeadTime'];
                                          }

                                          // print(foundMap['Balance']);
                                        }
                                      } else {
                                        print('No documents found!');
                                      }

                                      //=======================================================

                                      print(nonNullableList[i]['LeadTime']);
                                    }

                                    orderLast = {
                                      'OrdersDateID': DateTime.now().toString(),
                                      'OrdersUpdateTime': DateTime.now(),
                                      'สถานที่จัดส่ง': '',
                                      'วันเวลาจัดส่ง': '',
                                      'สายส่ง': '',
                                      'สายส่งโค้ด': '',
                                      'สายส่งไอดี': '',
                                      'ProductList': nonNullableList,
                                      'ยอดรวม': 0,
                                    };

                                    await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              A09021AddressSettingTeam(
                                            customerID: widget.customerID,
                                            orderDataMap: orderLast,
                                            idEmployee: widget.idEmployee,
                                            userIDOpen: widget.userIDOpen,
                                            userNameOpen: widget.userNameOpen,
                                          ),
                                        )).whenComplete(() async {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      // Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //     builder: (context) =>
                                      //         A0902CustomerHistoryList(
                                      //             customerID:
                                      //                 widget.customerID),
                                      //   ),
                                      // );
                                      // Navigator.pushAndRemoveUntil(
                                      //     context,
                                      //     CupertinoPageRoute(
                                      //       builder: (context) =>
                                      //           A0902CustomerHistoryList(
                                      //               customerID:
                                      //                   widget.customerID),
                                      //     ),
                                      //     (route) => false);
                                    });
                                  },
                                  text:
                                      'ทำการส่งสินค้าที่เลือกทั้งหมด ไปเปิดออเดอร์ใหม่',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 40.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: Colors.green.shade900,
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
                              )
                            : Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    setState(() {
                                      showCheckbox = true;
                                    });
                                  },
                                  text:
                                      'ทำการเลือกสินค้าออเดอร์นี้ เพื่อเลือกสินค้า และสั่งออเดอร์ใหม่',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 40.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: orderList['ProductList'].length == 0
                                        ? Colors.grey.shade400
                                        : Colors.yellow.shade900,
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

                        !showButtonEdit
                            ? const SizedBox(
                                height: 50,
                              )
                            : const SizedBox(
                                height: 50,
                              ),
                        !showButtonEdit
                            ? const SizedBox(
                                height: 0,
                              )
                            : Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: !showButtonEditDayAfter
                                    ? FFButtonWidget(
                                        onPressed: () async {},
                                        text:
                                            'วันจัดส่งน้อยกว่าวันปัจจุบัน ไม่สามารถแก้ไขออเดอร์ได้ค่ะ',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: Colors.red.shade900,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Kanit',
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 3.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      )
                                    : FFButtonWidget(
                                        onPressed: () async {
                                          bool checkLastStatus = false;
                                          //==============================================================
                                          CollectionReference orderColection =
                                              FirebaseFirestore.instance
                                                  .collection(AppSettings
                                                              .customerType ==
                                                          CustomerType.Test
                                                      ? 'OrdersTest'
                                                      : 'Orders');

                                          QuerySnapshot orderSubCollections =
                                              await orderColection
                                                  .where('OrdersDateID',
                                                      isEqualTo: orderList[
                                                          'OrdersDateID'])
                                                  .get();

                                          if (orderSubCollections
                                              .docs.isNotEmpty) {
                                            if (orderSubCollections
                                                    .docs.first['SectionID2'] ==
                                                '20240309000000') {
                                              checkLastStatus = true;
                                            } else if (orderSubCollections.docs
                                                        .first['SectionID2'] ==
                                                    '20240309000002'
                                                //     &&
                                                // orderSubCollections.docs.first[
                                                //         'SALE_ORDER_ID_REF'] !=
                                                //     null
                                                ) {
                                              checkLastStatus = true;
                                            }
                                          }
                                          //==============================================================

                                          if (checkLastStatus) {
                                            Map<String, dynamic> data = {};

                                            //==================== Step 1 ==============================
                                            await FirebaseFirestore.instance
                                                .collection(AppSettings
                                                            .customerType ==
                                                        CustomerType.Test
                                                    ? 'ระยะเวลาแก้ไขออเดอร์Test'
                                                    : 'ระยะเวลาแก้ไขออเดอร์')
                                                // .collection('ระยะเวลารับคำสั่งขายTest')
                                                .doc('1')
                                                .get()
                                                .then((DocumentSnapshot
                                                    documentSnapshot) {
                                              if (documentSnapshot.exists) {
                                                // ดึงข้อมูลจากเอกสาร
                                                data = documentSnapshot.data()
                                                    as Map<String, dynamic>;
                                              } else {
                                                print(
                                                    'Document does not exist');
                                              }
                                            }).catchError((error) {
                                              print(
                                                  "Failed to fetch document: $error");
                                              return;
                                            });
                                            // print(data['IS_ACTIVE']);
                                            // print(data['EndTime']);
                                            //==================== จบ Step 1 ==============================
                                            //==================== Step 2 ==============================
                                            DateTime now = DateTime.now();
                                            // แปลงสตริงเป็น DateTime
                                            DateFormat dateFormat =
                                                DateFormat("HH:mm");
                                            DateTime inputTime =
                                                dateFormat.parse(
                                                    data['EndTime'].toString());
                                            // สร้าง DateTime ใหม่ที่มีวันที่เดียวกับเวลาปัจจุบัน แต่ใช้เวลาที่ได้จากสตริง
                                            DateTime inputDateTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              inputTime.hour,
                                              inputTime.minute,
                                            );

                                            int day = now.year;
                                            int month = now.month;
                                            int year = now.day;
                                            DateTime newDate = DateTime(
                                                year,
                                                month,
                                                day,
                                                now.hour,
                                                now.minute);

                                            print(inputDateTime.toString());
                                            print(newDate.toString());
                                            if (data['IS_ACTIVE'] == true) {
                                              // เปรียบเทียบเวลาปัจจุบันกับเวลาจากสตริง
                                              // if (newDate.year == inputDateTime.year &&
                                              //     newDate.month ==
                                              //         inputDateTime.month &&
                                              //     newDate.day == inputDateTime.day) {
                                              // if (now.isAfter(inputDateTime)) {
                                              if ((newDate.hour >
                                                      inputDateTime.hour ||
                                                  (newDate.hour ==
                                                          inputDateTime.hour &&
                                                      newDate.minute >
                                                          inputDateTime
                                                              .minute))) {
                                                print(
                                                    "เวลาปัจจุบันเกินจาก 16:00 แล้ว และเป็นวันเดียวกัน");

                                                if (mounted) {
                                                  await QuickAlert.show(
                                                      context: context,
                                                      type:
                                                          QuickAlertType.error,
                                                      title:
                                                          'คุณทำการแก้ไขออเดอร์เลยเวลาที่กำหนด',
                                                      text:
                                                          'เวลาการแก้ไขออเดอร์ ต้องไมเ่กิน ${data['EndTime']} น.',
                                                      confirmBtnText: 'ตกลง');
                                                }

                                                return;
                                              }
                                              // }
                                            }
                                            print(
                                                "เวลาปัจจุบันยังไม่เกิน 16:00");

                                            //===============================================================

                                            List<Map<String, dynamic>>?
                                                nonNullableList = [];

                                            for (int i = 0;
                                                i <
                                                    orderList['ProductList']
                                                        .length;
                                                i++) {
                                              nonNullableList!.add(
                                                  orderList['ProductList'][i]);
                                            }

                                            for (int i = 0;
                                                i < nonNullableList!.length;
                                                i++) {
                                              print(nonNullableList[i]
                                                  ['LeadTime']);

                                              //=============== โหลด LeadTime อีกครั้ง =========================

                                              QuerySnapshot querySnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(AppSettings
                                                                  .customerType ==
                                                              CustomerType.Test
                                                          ? 'ProductTest'
                                                          : 'Product')
                                                      .where('PRODUCT_ID',
                                                          isEqualTo:
                                                              nonNullableList[i]
                                                                  ['ProductID'])
                                                      .get();

                                              if (querySnapshot
                                                  .docs.isNotEmpty) {
                                                // print(querySnapshot.docs.length);
                                                // length == 1 เพราะ PRODUCT_ID มีตัวเดียว

                                                for (var doc
                                                    in querySnapshot.docs) {
                                                  Map<String, dynamic> data =
                                                      doc.data() as Map<String,
                                                          dynamic>;
                                                  // print('Document data: ${doc.data()}');
                                                  // print('จำนวนสต๊อก');
                                                  // print(foundMap['Balance']);

                                                  print(data['LeadTime']);

                                                  if (data['LeadTime'] ==
                                                      null) {
                                                    nonNullableList[i]
                                                        ['LeadTime'] = '0';
                                                  } else {
                                                    nonNullableList[i]
                                                            ['LeadTime'] =
                                                        data['LeadTime'];
                                                  }

                                                  // print(foundMap['Balance']);
                                                }
                                              } else {
                                                print('No documents found!');
                                              }

                                              //=======================================================

                                              print(nonNullableList[i]
                                                  ['LeadTime']);
                                            }

                                            // return;

                                            orderLast = {
                                              'OrdersDateID':
                                                  DateTime.now().toString(),
                                              'OrdersUpdateTime':
                                                  DateTime.now(),
                                              'สถานที่จัดส่ง': '',
                                              'วันเวลาจัดส่ง': '',
                                              'สายส่ง': '',
                                              'สายส่งโค้ด': '',
                                              'สายส่งไอดี': '',
                                              'ProductList': nonNullableList,
                                              'ยอดรวม': 0,
                                            };

                                            Map<String, dynamic> originalMap =
                                                widget.orderDataMap!;
                                            // Map<String, dynamic> copiedMap =
                                            //     Map<String, dynamic>.from(originalMap);

                                            Map<String, dynamic> copiedMap =
                                                deepCopyMap(originalMap);

                                            await Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      A090501ProductSceenEditTeam(
                                                          customerID:
                                                              widget.customerID,
                                                          orderDataMap: widget
                                                              .orderDataMap,
                                                          orderOLD: copiedMap),
                                                )).whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });

                                            // await Navigator.push(
                                            //     context,
                                            //     CupertinoPageRoute(
                                            //       builder: (context) => A09021AddressSetting(
                                            //           customerID: widget.customerID,
                                            //           orderDataMap: orderLast),
                                            //     )).whenComplete(() async {
                                            //   Navigator.pop(context);
                                            //   Navigator.pop(context);
                                            //   Navigator.pop(context);
                                            //   // Navigator.push(
                                            //   //   context,
                                            //   //   CupertinoPageRoute(
                                            //   //     builder: (context) =>
                                            //   //         A0902CustomerHistoryList(
                                            //   //             customerID:
                                            //   //                 widget.customerID),
                                            //   //   ),
                                            //   // );
                                            //   // Navigator.pushAndRemoveUntil(
                                            //   //     context,
                                            //   //     CupertinoPageRoute(
                                            //   //       builder: (context) =>
                                            //   //           A0902CustomerHistoryList(
                                            //   //               customerID:
                                            //   //                   widget.customerID),
                                            //   //     ),
                                            //   //     (route) => false);
                                            // });
                                          } else {
                                            if (mounted) {
                                              await QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.error,
                                                  title:
                                                      'การแก้ไขออเดอร์ไม่สามารถทำได้',
                                                  text:
                                                      'ขณะนี้ ออเดอร์นี้ได้ถูกเปลี่ยนสถานะแล้วค่ะ',
                                                  confirmBtnText: 'ตกลง');
                                            }

                                            return;
                                          }
                                        },
                                        text: 'ทำการแก้ไขออเดอร์',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: Colors.purple.shade900,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Kanit',
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 3.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                              ),
                        !showButtonCancleOrder
                            ? const SizedBox(
                                height: 0,
                              )
                            : const SizedBox(
                                height: 50,
                              ),
                        !showButtonCancleOrder
                            ? const SizedBox(
                                height: 0,
                              )
                            : orderList['SectionID2'] == 'ยกเลิกออเดอร์' ||
                                    orderList['SectionID2'] == 'รอดำเนินการ'
                                ? const SizedBox(
                                    height: 0,
                                  )
                                : FFButtonWidget(
                                    onPressed: () async {
                                      if (orderList['SALE_ORDER_ID_REF'] ==
                                          null) {
                                        if (mounted) {
                                          await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              title:
                                                  'ยังไม่สามารถยกเลิกออเดอร์ได้',
                                              text:
                                                  'ยังไม่สามารถยกเลิกได้ ต้องได้รับ SALE_ORDER_ID_REF ก่อนค่ะ',
                                              confirmBtnText: 'ตกลง');
                                        }

                                        return;
                                      }

                                      // ดึงข้อมูลจาก collection 'mfoodtoken'

                                      Map<String, dynamic>? urlApi = {};
                                      DocumentSnapshot urlApiWithPort =
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  AppSettings.customerType ==
                                                          CustomerType.Test
                                                      ? 'AppSettingUrl'
                                                      : 'AppSettingUrl')
                                              .doc(AppSettings.customerType ==
                                                      CustomerType.Test
                                                  ? '7104'
                                                  : '7105')
                                              .get();

                                      if (urlApiWithPort.exists) {
                                        urlApi = urlApiWithPort.data()
                                            as Map<String, dynamic>?;
                                      }

                                      print(urlApi!['Url']);

                                      Map<String, dynamic>? tokenApi = {};
                                      DocumentSnapshot tokenApiWithPort =
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  AppSettings.customerType ==
                                                          CustomerType.Test
                                                      ? 'mfoodtoken'
                                                      : 'mfoodtoken')
                                              .doc(AppSettings.customerType ==
                                                      CustomerType.Test
                                                  ? 'EDpTMkR8myW4zhdUALCP'
                                                  : 'EDpTMkR8myW4zhdUALCP')
                                              .get();

                                      if (tokenApiWithPort.exists) {
                                        tokenApi = tokenApiWithPort.data()
                                            as Map<String, dynamic>?;
                                      }

                                      print(tokenApi!['token_key']);

                                      String xmlString =
                                          '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><Cancel_SO xmlns="MFOODMOBILEAPI"><SO_NO>${orderList['SALE_ORDER_ID_REF']}</SO_NO><Token>${tokenApi['token_key']}</Token></Cancel_SO></soap12:Body></soap12:Envelope>';

                                      print(xmlString);
                                      try {
                                        HttpsCallable callableCancelLast =
                                            FirebaseFunctions.instance
                                                .httpsCallable('getApiMfood');
                                        var paramsCancelLast =
                                            AppSettings.customerType ==
                                                    CustomerType.Test
                                                ? <String, dynamic>{
                                                    "url":
                                                        "${urlApi!['Url']}:7104/MBServices.asmx?op=Cancel_SO",
                                                    "xml":
                                                        '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><Cancel_SO xmlns="MFOODMOBILEAPI"><SO_NO>${orderList['SALE_ORDER_ID_REF']}</SO_NO><Token>${tokenApi['token_key']}</Token></Cancel_SO></soap12:Body></soap12:Envelope>'
                                                  }
                                                : <String, dynamic>{
                                                    "url":
                                                        "${urlApi!['Url']}:7105/MBServices.asmx?op=Cancel_SO",
                                                    "xml":
                                                        '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><Cancel_SO xmlns="MFOODMOBILEAPI"><SO_NO>${orderList['SALE_ORDER_ID_REF']}</SO_NO><Token>${tokenApi['token_key']}</Token></Cancel_SO></soap12:Body></soap12:Envelope>'
                                                  };

                                        if (mounted) {
                                          bool deleteOrder = false;
                                          await QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.info,
                                            title: 'คุณกำลังจะยกเลิกออเดอร์นี้',
                                            text: 'คุณต้องการยกเลิกออเดอร์นี้',
                                            confirmBtnText:
                                                'ยืนยันการยกเลิกออเดอร์',
                                            cancelBtnText: 'ยกเลิก',
                                            showCancelBtn: true,
                                            showConfirmBtn: true,
                                            onCancelBtnTap: () => Navigator.of(
                                                    context,
                                                    rootNavigator: true)
                                                .pop(),
                                            onConfirmBtnTap: () async {
                                              deleteOrder = true;
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          );
                                          print(deleteOrder);
                                          print(deleteOrder);
                                          print(deleteOrder);
                                          // return;
                                          if (deleteOrder) {
                                            print(orderList['SectionID2']);
                                            print(orderList['SectionID2']);
                                            print(orderList['SectionID2']);
                                            print(orderList['SectionID2']);
                                            print(orderList['SectionID2']);

                                            if (orderList['SectionID2'] ==
                                                'บุ๊กกิ้งออเดอร์') {
                                              await FirebaseFirestore.instance
                                                  .collection(AppSettings
                                                              .customerType ==
                                                          CustomerType.Test
                                                      ? 'LogXMLยกเลิกso'
                                                      : 'LogXMLยกเลิกso')
                                                  .doc(
                                                      DateTime.now().toString())
                                                  .set({
                                                'OrdersDateID':
                                                    orderList['OrdersDateID'],
                                                'Timestamp': DateTime.now(),
                                                'URL': AppSettings
                                                            .customerType ==
                                                        CustomerType.Test
                                                    ? "${urlApi!['Url']}:7104/MBServices.asmx?op=Cancel_SO"
                                                    : "${urlApi!['Url']}:7105/MBServices.asmx?op=Cancel_SO",
                                                'XML': AppSettings
                                                            .customerType ==
                                                        CustomerType.Test
                                                    ? '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><Cancel_SO xmlns="MFOODMOBILEAPI"><SO_NO>${orderList['SALE_ORDER_ID_REF']}</SO_NO><Token>${tokenApi!['token_key']}</Token></Cancel_SO></soap12:Body></soap12:Envelope>'
                                                    : '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><Cancel_SO xmlns="MFOODMOBILEAPI"><SO_NO>${orderList['SALE_ORDER_ID_REF']}</SO_NO><Token>${tokenApi!['token_key']}</Token></Cancel_SO></soap12:Body></soap12:Envelope>',
                                                'note': "ยกเลิกออเดอร์ผ่านแอพ",
                                                'order': orderList,
                                              });

                                              Navigator.of(context,
                                                  rootNavigator: true);
                                              await FirebaseFirestore.instance
                                                  .collection(AppSettings
                                                              .customerType ==
                                                          CustomerType.Test
                                                      ? 'OrdersTest'
                                                      : 'Orders')
                                                  .doc(orderList['docId'])
                                                  .update({
                                                'SectionID2': '20240309000004'
                                              }).then((value) async {
                                                await QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.info,
                                                  title:
                                                      'ยกเลิก ${orderList['OrdersDateID']} ออเดอร์แล้ว',
                                                  text:
                                                      'คุณทำการยกเลิกออเดอร์สำเร็จแล้วค่ะ',
                                                  confirmBtnText: 'ตกลง',
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            } else {
                                              await callableCancelLast
                                                  .call(paramsCancelLast)
                                                  .then((value) async {
                                                print(
                                                    'ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
                                                if (value.data['status'] ==
                                                    'success') {
                                                  print(value.data['status']);
                                                  print(value.data);

                                                  Xml2Json xml2json =
                                                      Xml2Json();
                                                  xml2json.parse(
                                                      value.data.toString());

                                                  jsonStringDiscount =
                                                      xml2json.toOpenRally();

                                                  Map<String, dynamic> data =
                                                      json.decode(
                                                          jsonStringDiscount);

                                                  print(data);

                                                  Map<String,
                                                      dynamic> dataMap = data[
                                                                  'Envelope']
                                                              ['Body']
                                                          ['Cancel_SOResponse']
                                                      ['Cancel_SOResult'];
                                                  print(dataMap);

                                                  if (dataMap['RESULT']
                                                          .toString() ==
                                                      'false') {
                                                    if (mounted) {
                                                      await QuickAlert.show(
                                                          context: context,
                                                          type: QuickAlertType
                                                              .error,
                                                          title:
                                                              'การยกเลิกออเดอร์ไม่สามารถทำได้',
                                                          text:
                                                              '${dataMap['SALE_ORDER_ID_REF'].toString()} ${dataMap['DETAIL'].toString()}',
                                                          confirmBtnText:
                                                              'ตกลง');
                                                    }

                                                    return;
                                                  } else {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(AppSettings
                                                                    .customerType ==
                                                                CustomerType
                                                                    .Test
                                                            ? 'LogXMLยกเลิกso'
                                                            : 'LogXMLยกเลิกso')
                                                        .doc(DateTime.now()
                                                            .toString())
                                                        .set({
                                                      'OrdersDateID': orderList[
                                                          'OrdersDateID'],
                                                      'Timestamp':
                                                          DateTime.now(),
                                                      'URL': AppSettings
                                                                  .customerType ==
                                                              CustomerType.Test
                                                          ? "${urlApi!['Url']}:7104/MBServices.asmx?op=Cancel_SO"
                                                          : "${urlApi!['Url']}:7105/MBServices.asmx?op=Cancel_SO",
                                                      'XML': AppSettings
                                                                  .customerType ==
                                                              CustomerType.Test
                                                          ? '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><Cancel_SO xmlns="MFOODMOBILEAPI"><SO_NO>${orderList['SALE_ORDER_ID_REF']}</SO_NO><Token>${tokenApi!['token_key']}</Token></Cancel_SO></soap12:Body></soap12:Envelope>'
                                                          : '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><Cancel_SO xmlns="MFOODMOBILEAPI"><SO_NO>${orderList['SALE_ORDER_ID_REF']}</SO_NO><Token>${tokenApi!['token_key']}</Token></Cancel_SO></soap12:Body></soap12:Envelope>',
                                                      'note':
                                                          "ยกเลิกออเดอร์ผ่านแอพ",
                                                      'order': orderList,
                                                    });

                                                    Navigator.of(context,
                                                        rootNavigator: true);
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(AppSettings
                                                                    .customerType ==
                                                                CustomerType
                                                                    .Test
                                                            ? 'OrdersTest'
                                                            : 'Orders')
                                                        .doc(orderList['docId'])
                                                        .update({
                                                      'SectionID2':
                                                          '20240309000004'
                                                    }).then((value) async {
                                                      await QuickAlert.show(
                                                        context: context,
                                                        type:
                                                            QuickAlertType.info,
                                                        title:
                                                            'ยกเลิก ${dataMap['SALE_ORDER_ID_REF']} ออเดอร์แล้ว',
                                                        text:
                                                            'คุณทำการยกเลิกออเดอร์สำเร็จแล้วค่ะ',
                                                        confirmBtnText: 'ตกลง',
                                                      );
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        print('ข้อผิดพลาดในการส่งคำขอ: $e');
                                      }
                                    },
                                    text: 'ยกเลิกออเดอร์',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 40.0,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: Colors.red.shade900,
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
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
