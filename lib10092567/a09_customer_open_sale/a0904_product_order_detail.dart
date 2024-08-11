import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:m_food/a09_customer_open_sale/a09021_address_setting.dart';
import 'package:m_food/a09_customer_open_sale/a0905_success_order_product.dart';
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

class A0904ProductOrderDetail extends StatefulWidget {
  final String? customerID;
  final List<String>? imageProduct;

  final Map<String, dynamic>? orderDataMap;
  const A0904ProductOrderDetail(
      {super.key, this.orderDataMap, this.imageProduct, this.customerID});

  @override
  _A0904ProductOrderDetailState createState() =>
      _A0904ProductOrderDetailState();
}

class _A0904ProductOrderDetailState extends State<A0904ProductOrderDetail> {
  TextEditingController textController1 = TextEditingController();
  FocusNode textFieldFocusNode1 = FocusNode();
  TextEditingController textController2 = TextEditingController();
  FocusNode textFieldFocusNode2 = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  // late A0904ProductOrderModel _model;

  final productController = Get.find<ProductController>();
  RxMap<String, dynamic>? productGetData;

  late Map<String, dynamic> customerDataFetch;

  List<Map<String, dynamic>> resultList = [];

  late Map<String, dynamic> orderList;

  List<int> productCount = [];

  List<int> productCountOld = [];

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
  List<Map<String, dynamic>> orderLoss = [];

  bool statusOrderPass = true;

  String orderDateBefore = '';
  String orderDateBeforeDay = '';
  String orderDateBeforeString = '';

  List<Map<String, dynamic>?>? planProductBalanceList = [];

  bool checkConvertRatio = false;

  bool isBetweenCheckBalance(
      DateTime dateTime, DateTime today, DateTime endDate) {
    //dateTime = วันที่สินค้าเข้าตามแผน
    //today = วันปัจจุบัน
    //endDate = วันที่ลูกค้าเลือกวันขนส่ง

    print('วันที่สินค้าเข้าตามแผน $dateTime');
    print('วันปัจจุบัน $today');
    print('วันที่ลูกค้าเลือกวันขนส่ง $endDate');

    if (dateTime.isAfter(today) && dateTime.isBefore(endDate)) {
      print('วันที่สินค้าเข้า มากกว่าวันปัจจุบัน  น้อยกว่าวันขนส่ง');
      return true;
    } else if (dateTime.year == endDate.year &&
        dateTime.month == endDate.month &&
        dateTime.day == endDate.day &&
        dateTime.isAfter(today)) {
      print('วันที่สินค้าเข้า เท่ากับวันปัจจุบัน น้อยกว่าวันขนส่ง');

      return true;
    } else {
      print('วันที่สินค้าเข้า ไม่เข้าเงื่อนไข');

      return false;
    }
    // return dateTime.isAfter(today) && dateTime.isBefore(endDate);
  }

  @override
  void initState() {
    super.initState();

    // _model = createModel(context, () => A0904ProductOrderModel());

    loadData('ปกติ', {});
    print('1');

    print('2');
  }

  Future<void> loadData(String? edit, Map<String, dynamic>? order) async {
    planProductBalanceList!.clear();

    try {
      setState(() {
        isLoading = true;
      });
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

      // ===============================================================
      //=======================================================================================

      CollectionReference planBalance = FirebaseFirestore.instance
          .collection('แผนสั่งซื้อสินค้า_ProductList');

      QuerySnapshot planBalanceQuery = await planBalance.get();

      if (planBalanceQuery.docs.length == 0) {
        planProductBalanceList!.add({});
      } else {
        planBalanceQuery.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          String dateTimeString = data['วันที่สินค้าเข้า_string'];

          DateTime dateTime = DateTime.parse(dateTimeString);

          DateTime dateTimeNow = DateTime.now();

          if (dateTime.isBefore(dateTimeNow)) {
            print('เลยเวลานี้ไปแล้ว');
          } else {
            planProductBalanceList!.add(data);
          }
        });

        print('แผน fastmove');

        print(planProductBalanceList!.length);

        planProductBalanceList!.removeWhere((element) =>
            element!['IS_ACTIVE'] == false ||
            element['ยืนยันแผน'] != 'ยืนยันแผนแล้ว');

        print(planProductBalanceList!.length);
      }
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

          if (entry['PRODUCT_ID'] == '0270310070900') {
            print(entry['PRODUCT_ID']);
            print(entry['PRODUCT_ID']);
            print(entry['PRODUCT_ID']);
            print(entry['PRODUCT_ID']);
            print(entry['PRODUCT_ID']);
            print(entry['Balance']);
          }

          resultList.add(entry);
        });
      }

      productImage.addAll(widget.imageProduct!);

      if (edit == 'แก้ไข') {
        orderList = order!;
      } else {
        orderList = widget.orderDataMap!;
      }

      orderDateBefore = orderList['วันเวลาจัดส่ง'] ?? '';
      orderDateBeforeDay = orderList['วันเวลาจัดส่ง_day'] ?? '';
      orderDateBeforeString = orderList['วันเวลาจัดส่ง_string'] ?? '';

      // print(orderList!['วันเวลาจัดส่ง']);
      // print(orderList!['วันเวลาจัดส่ง']);

      // print(orderList!['วันเวลาจัดส่ง_day']);
      // print(orderList!['ListCustomerAddressID']);

      // print(orderList);

      await checkPromotions();

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

        orderList['ProductList'][i]['ขั้นต่ำหน่วย'] =
            dataMap['ขั้นต่ำหน่วย'] ?? 'ไม่มีหน่วย';

        print('======== check type for kuntum =======');
        print(orderList['ProductList'][i]['ประเภทสินค้าDesc']);
        print(orderList['ProductList'][i]['ประเภทสินค้าDesc']);
        print(orderList['ProductList'][i]['ประเภทสินค้าDesc']);
        print('======== check type for kuntum =======');

        if (orderList['ProductList'][i]['ประเภทสินค้าDesc'] ==
            'สินค้าที่ต้องสั่งจองล่วงหน้า (Pre-Order)') {
          if (dataMap['ขั้นต่ำจำนวน'] == null) {
            orderList['ProductList'][i]['ขั้นต่ำจำนวน'] = 0;
          } else {
            orderList['ProductList'][i]['ขั้นต่ำจำนวน'] =
                int.parse(dataMap['ขั้นต่ำจำนวน'].toString());
          }
        } else {
          orderList['ProductList'][i]['ขั้นต่ำจำนวน'] = 0;
        }

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
      var paramsBillLast = <String, dynamic>{
        "url":
            "http://mobile.mfood.co.th:7105/MBServices.asmx?op=BILL_DISCOUNT_INFO",
        // "http://mobile.mfood.co.th:7105/MBServices.asmx?op=SALES_ITEM_PROMOTION",
        "xml":
            //pro type discount
            // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>${data['ClientIdจากMfoodAPI']}</Client_ID><ITEMCODE>${orderList['ProductList'][i]['ProductID']}</ITEMCODE><UM>${orderList['ProductList'][i]['ยูนิต']}</UM><QTY>${orderList['ProductList'][i]['จำนวน']}</QTY><DOC_DATE>$formattedDate</DOC_DATE><ITEMAMT>$totalPrice</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
            //pro type bonus item
            // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>01000004</Client_ID><ITEMCODE>0271330020450</ITEMCODE><UM>ซอง</UM><QTY>20</QTY><DOC_DATE>2024-04-01</DOC_DATE><ITEMAMT>980</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
            '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><BILL_DISCOUNT_INFO xmlns="MFOODMOBILEAPI"><PROMO_DATE>$formattedDate</PROMO_DATE><CUSTMER_ID>${data['ClientIdจากMfoodAPI']}</CUSTMER_ID><BILL_AMT>$totalAll</BILL_AMT></BILL_DISCOUNT_INFO></soap12:Body></soap12:Envelope>'
      };

      print(paramsBillLast['xml']);
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

      for (var key in orderList.keys) {
        var value = orderList[key];
        // print('Key: $key, Value: $value');
        if (key == 'ProductList') {
          for (var element in value) {
            productCount.add(int.parse(element['จำนวน'].toString()));
          }
        }
        // ทำสิ่งที่คุณต้องการกับแต่ละ key และ value
      }

      print('0000000111111');

      // print('for fouth');

      // print(productCount);
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> checkPromotions() async {
    print('CHECK PROMOTIONS');

    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'CustomerTest'
            : 'Customer')
        .doc(widget.customerID)
        .get();

    Map<String, dynamic> data = customerDoc.data() as Map<String, dynamic>;

    String totalPriceDiscount = '';

    double totalPriceDiscountDouble = 0.0;

    for (int i = 0; i < orderList['ProductList'].length; i++) {
      Map<String, dynamic>? foundmapRatio = productCovertRatio.firstWhere(
        (element) =>
            element!['PRODUCT_ID'] ==
                orderList['ProductList'][i]['ProductID'] &&
            element['UNIT'] == orderList['ProductList'][i]['ยูนิต'],
        orElse: () => {},
      );

      // foundmapRatio!['CONVERT_RATIO'] = null;

      if (foundmapRatio!['CONVERT_RATIO'] == null) {
        checkConvertRatio = true;

        // if (i % 2 == 0) {
        //   foundmapRatio!['CONVERT_RATIO'] = '0';
        // } else {
        //   foundmapRatio!['CONVERT_RATIO'] = '1';
        // }
      }

      orderList['ProductList'][i]['CONVERT_RATIO'] =
          foundmapRatio!['CONVERT_RATIO'] ?? '0';

      print(i);
      print(i);
      print(i);
      // print(orderList['ProductList']);
      //I/flutter (11081): {RESULT: true, PRODUCT_ID: 0271330020450, FREE_UNIT: ซอง, PRODUCT_TYPE: FREE, FREE_ID: 0271330020450, FREE_UNIT: ซอง, FREE_QTY: 1.000000, PROMO_PRICE: 0, DISCOUNT_UNIT: true, BILLING_DISCOUNT: true}

      // specialPriceProductList = (specialPriceProductList ?? [])
      //     .where((map) => map != null)
      //     .cast<Map<String, dynamic>>()
      //     .toList();

      // print(specialPriceProductList);
      // ================================= เช็คโปร ============================
      double price =
          double.parse(orderList['ProductList'][i]['ราคา'].toString());
      double total =
          double.parse(orderList['ProductList'][i]['จำนวน'].toString());

      double totalPrice = price * total;
      print(totalPrice);
      print(totalPrice);
      print(totalPrice);
      print(totalPrice);

      DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

      HttpsCallable callableDiscount =
          FirebaseFunctions.instance.httpsCallable('getApiMfood');
      var paramsDiscount = <String, dynamic>{
        "url":
            "http://mobile.mfood.co.th:7105/MBServices.asmx?op=SALES_ITEM_PROMOTION",
        "xml":
            //pro type discount
            '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>${data['ClientIdจากMfoodAPI']}</Client_ID><ITEMCODE>${orderList['ProductList'][i]['ProductID']}</ITEMCODE><UM>${orderList['ProductList'][i]['ยูนิต']}</UM><QTY>${orderList['ProductList'][i]['จำนวน']}</QTY><DOC_DATE>$formattedDate</DOC_DATE><ITEMAMT>$totalPrice</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
        //pro type bonus item
        // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>01000004</Client_ID><ITEMCODE>0271330020450</ITEMCODE><UM>ซอง</UM><QTY>20</QTY><DOC_DATE>2024-04-01</DOC_DATE><ITEMAMT>980</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
//    <?xml version="1.0" encoding="utf-8"?>
// <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
//   <soap12:Body>
//     <BILL_DISCOUNT_INFO xmlns="MFOODMOBILEAPI">
//       <PROMO_DATE>2024-03-19</PROMO_DATE>
//       <CUSTMER_ID>01001201</CUSTMER_ID>
//       <BILL_AMT>10000</BILL_AMT><!-- ยอดรวมก่อน VAT -->
//     </BILL_DISCOUNT_INFO>
//   </soap12:Body>
// </soap12:Envelope>
      };

      print(paramsDiscount['xml']);
      // print('======================================= aaaaa');

      await callableDiscount.call(paramsDiscount).then((value) async {
        print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
        if (value.data['status'] == 'success') {}

        Xml2Json xml2json = Xml2Json();
        xml2json.parse(value.data.toString());

        jsonStringDiscount = xml2json.toOpenRally();

        Map<String, dynamic> data = json.decode(jsonStringDiscount);
        // print('================= 4 ===================');

        // print(data);
        // print(data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']);

        if (data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']
                ['SALES_ITEM_PROMOTIONResult'] ==
            'true') {
          orderList['ProductList'][i]['ส่วนลดรายการ'] = '0.0';

          orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] = false;
          orderList['ProductList'][i]['ไอดีของแถม'] = '';
          orderList['ProductList'][i]['ชื่อของแถม'] = '';
          orderList['ProductList'][i]['จำนวนของแถม'] = '0';
          orderList['ProductList'][i]['หน่วยของแถม'] = '';
          orderList['ProductList'][i]['มีของแถม'] = false;

          // print('is SALES_ITEM_PROMOTIONResult Empty');
        } else {
          print(data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']
              ['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST']);

          print(data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']
                  ['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST']
              .runtimeType);

          if (data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']
                      ['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST']
                  .runtimeType ==
              List<dynamic>) {
            print('Promotion List');
            print('Promotion List');
            print('Promotion List');
            for (int j = 0;
                j <
                    data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']
                                ['SALES_ITEM_PROMOTIONResult']
                            ['SALESPROMOTION_LIST']
                        .length;
                j++) {
              Map<String, dynamic> sellPriceResponse = data['Envelope']['Body']
                      ['SALES_ITEM_PROMOTIONResponse']
                  ['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST'][j];
              print('================= 5 1===================');
              // print(sellPriceResponse);
              if (sellPriceResponse['PRODUCT_TYPE'] == 'ITEM DISCOUNT') {
                double discount =
                    double.parse(sellPriceResponse['DISCOUNT_UNIT']);

                String totalPriceDiscount = discount.toStringAsFixed(
                    2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

                orderList['ProductList'][i]['ส่วนลดรายการ'] =
                    totalPriceDiscount;

                orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] = false;
                // orderList['ProductList'][i]['ไอดีของแถม'] = '';
                // orderList['ProductList'][i]['ชื่อของแถม'] = '';
                // orderList['ProductList'][i]['จำนวนของแถม'] = '0';
                // orderList['ProductList'][i]['หน่วยของแถม'] = '';
                // orderList['ProductList'][i]['มีของแถม'] = false;
              } else if (sellPriceResponse['PRODUCT_TYPE'] == 'FREE') {
                // I/flutter (11081): {RESULT: true, PRODUCT_ID: 0271330020450, FREE_UNIT: ซอง, PRODUCT_TYPE: FREE, FREE_ID: 0271330020450, FREE_UNIT: ซอง, FREE_QTY: 2.000000, PROMO_PRICE: 0, DISCOUNT_UNIT: true, BILLING_DISCOUNT: true}

                // orderList['ProductList'][i]['ส่วนลดรายการ'] = '0.0';

                print('มีของแถม');
                print('มีของแถม');
                print('มีของแถม');
                print('มีของแถม');
                print('มีของแถม');

                orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] = false;
                orderList['ProductList'][i]['ไอดีของแถม'] =
                    sellPriceResponse['FREE_ID'];

                Map<String, dynamic> dataMap = resultList.firstWhere(
                    (product) =>
                        product['PRODUCT_ID'] ==
                        orderList['ProductList'][i]['ไอดีของแถม']);

                print('นี่คือของแถม');
                print(dataMap);
                print('--------------------');

                // print(resultList[0]);

                orderList['ProductList'][i]['ชื่อของแถม'] = dataMap['NAMES'];

                double discount = double.parse(sellPriceResponse['FREE_QTY']);

                String totalPriceDiscount = discount.toStringAsFixed(
                    0); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

                orderList['ProductList'][i]['จำนวนของแถม'] = totalPriceDiscount;
                orderList['ProductList'][i]['หน่วยของแถม'] =
                    sellPriceResponse['FREE_UNIT'];
                orderList['ProductList'][i]['มีของแถม'] = true;
              } else {
                orderList['ProductList'][i]['ส่วนลดรายการ'] = '0.0';

                orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] = false;
                orderList['ProductList'][i]['ไอดีของแถม'] = '';
                orderList['ProductList'][i]['ชื่อของแถม'] = '';
                orderList['ProductList'][i]['จำนวนของแถม'] = '0';
                orderList['ProductList'][i]['หน่วยของแถม'] = '';
                orderList['ProductList'][i]['มีของแถม'] = false;
              }
            }

            print('================= 5 1 end      ===================');
          } else {
            Map<String, dynamic> sellPriceResponse = data['Envelope']['Body']
                    ['SALES_ITEM_PROMOTIONResponse']
                ['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST'];
            print('================= 5 ===================');
            // print(sellPriceResponse);
            if (sellPriceResponse['PRODUCT_TYPE'] == 'ITEM DISCOUNT') {
              double discount =
                  double.parse(sellPriceResponse['DISCOUNT_UNIT']);

              String totalPriceDiscount = discount.toStringAsFixed(
                  2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

              orderList['ProductList'][i]['ส่วนลดรายการ'] = totalPriceDiscount;

              orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] = false;
              orderList['ProductList'][i]['ไอดีของแถม'] = '';
              orderList['ProductList'][i]['ชื่อของแถม'] = '';
              orderList['ProductList'][i]['จำนวนของแถม'] = '0';
              orderList['ProductList'][i]['หน่วยของแถม'] = '';
              orderList['ProductList'][i]['มีของแถม'] = false;
            } else if (sellPriceResponse['PRODUCT_TYPE'] == 'FREE') {
              // I/flutter (11081): {RESULT: true, PRODUCT_ID: 0271330020450, FREE_UNIT: ซอง, PRODUCT_TYPE: FREE, FREE_ID: 0271330020450, FREE_UNIT: ซอง, FREE_QTY: 2.000000, PROMO_PRICE: 0, DISCOUNT_UNIT: true, BILLING_DISCOUNT: true}
              orderList['ProductList'][i]['ส่วนลดรายการ'] = '0.0';

              orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] = false;
              orderList['ProductList'][i]['ไอดีของแถม'] =
                  sellPriceResponse['FREE_ID'];

              Map<String, dynamic> dataMap = resultList.firstWhere((product) =>
                  product['PRODUCT_ID'] ==
                  orderList['ProductList'][i]['ไอดีของแถม']);

              // print(resultList[0]);

              orderList['ProductList'][i]['ชื่อของแถม'] = dataMap['NAMES'];

              double discount = double.parse(sellPriceResponse['FREE_QTY']);

              String totalPriceDiscount = discount.toStringAsFixed(
                  0); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

              orderList['ProductList'][i]['จำนวนของแถม'] = totalPriceDiscount;
              orderList['ProductList'][i]['หน่วยของแถม'] =
                  sellPriceResponse['FREE_UNIT'];
              orderList['ProductList'][i]['มีของแถม'] = true;
            } else {
              orderList['ProductList'][i]['ส่วนลดรายการ'] = '0.0';

              orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] = false;
              orderList['ProductList'][i]['ไอดีของแถม'] = '';
              orderList['ProductList'][i]['ชื่อของแถม'] = '';
              orderList['ProductList'][i]['จำนวนของแถม'] = '0';
              orderList['ProductList'][i]['หน่วยของแถม'] = '';
              orderList['ProductList'][i]['มีของแถม'] = false;
            }

            print('=================  5   end ===================');
          }
        }

        // print(totalPriceDiscountDouble);
        // print(double.parse(
        //     orderList['ProductList'][i]['ส่วนลดรายการ'].toString()));

        // print(totalPriceDiscount);

        totalPriceDiscountDouble = totalPriceDiscountDouble +
            double.parse(
                orderList['ProductList'][i]['ส่วนลดรายการ'].toString());

        // print(totalPriceDiscountDouble);

        String totalPriceDiscountDoubleString = totalPriceDiscountDouble
            .toStringAsFixed(2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

        totalPriceDiscount = totalPriceDiscountDoubleString;

        orderList['ยอดรวมส่วนลดทั้งหมด'] = totalPriceDiscount;

        // print(orderList['ยอดรวมส่วนลดทั้งหมด']);
      }).whenComplete(() async {});

      // HttpsCallable callableBonusItem =
      //     FirebaseFunctions.instance.httpsCallable('getApiMfood');
      // var paramsBonusItem = <String, dynamic>{
      //   "url":
      //       "http://mobile.mfood.co.th:7105/MBServices.asmx?op=SALES_ITEM_PROMOTION",
      //   "xml":
      //       // '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><Sell_Price xmlns="MFOODMOBILEAPI"><PRICE_LIST>${tableDesc!['PLIST_DESC1'].toString()}</PRICE_LIST></Sell_Price></soap:Body></soap:Envelope>'
      //       // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><CHECK_PROMOTION_INFO xmlns="MFOODMOBILEAPI"><sCLIENT_ID>01000003</sCLIENT_ID><sPRODUCT_CODE>0140006421000</sPRODUCT_CODE><sORDER_DATE>2024-03-18</sORDER_DATE></CHECK_PROMOTION_INFO></soap12:Body></soap12:Envelope>'
      //       '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>01000004</Client_ID><ITEMCODE>0271330020450</ITEMCODE><UM>ซอง</UM><QTY>20</QTY><DOC_DATE>2024-04-01</DOC_DATE><ITEMAMT>980</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
      // };

      // // print(params2['xml']);
      // // print('======================================= aaaaa');

      // await callableBonusItem.call(paramsBonusItem).then((value) async {
      //   print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
      //   if (value.data['status'] == 'success') {}

      //   Xml2Json xml2json = Xml2Json();
      //   xml2json.parse(value.data.toString());

      //   jsonStringBonusItem = xml2json.toOpenRally();

      //   Map<String, dynamic> data = json.decode(jsonStringBonusItem);
      //   print('================= 6 ===================');

      //   print(data);

      //   // Map<String, dynamic> sellPriceResponse = data['Envelope']['Body']
      //   //     ['CHECK_PROMOTION_INFOResponse']['CHECK_PROMOTION_INFOResult'];

      //   print('================= 7 ===================');
      //   // // print(sellPriceResponse);

      //   // // if (sellPriceResponse['Sell_PriceResult'] == 'true') {
      //   // //   print('is true');
      //   // // } else {
      //   // sellPrices = List<Map<String, dynamic>>.from(
      //   //     sellPriceResponse['PROMOTION_INFO']);
      //   // // }

      //   // print(sellPrices.length);

      //   // for (int i = 0; i < sellPrices.length; i++) {
      //   //   // if (sellPrices[i]['PRODUCT_ID'] == '0291056100062') {
      //   //   print(sellPrices[i]);
      //   //   // }
      //   // }
      //   // // // int count2 = sellPrices
      //   // // //     .where((item) => item['PRODUCT_ID'] == '0291056100062')
      //   // // //     .length;
      // }).whenComplete(() async {});
      print(i);
      print(i);
      print(i);
    }
  }

  @override
  void dispose() {
    // _model.dispose();
    textController1.dispose();
    textFieldFocusNode1.unfocus();
    textController2.dispose();
    textFieldFocusNode2.unfocus();
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

  void decrement(
      int index, int number, void Function(VoidCallback) setStateFunc) async {
    double total = 0.0;
    if (productCount[index] > 0) {
      setStateFunc(() {
        productCount[index]--;
        orderList['ProductList'][index]['จำนวน'] = productCount[index];
      });
    }
    print(index);
    print(orderList['ProductList'][index]['จำนวน']);
    print(orderList['ยอดรวม']);

    // for (var element in orderList['ProductList']) {
    //   double sumTotal = (element['จำนวน'] * double.parse(element['ราคา']));

    //   total = total + sumTotal;
    // }

    await checkPromotions();

    double sumTotalVat = 0.0;
    double sumTotalNoVat = 0.0;

    for (var element in orderList['ProductList']) {
      Map<String, dynamic> dataMap = resultList.firstWhere(
          (product) => product['PRODUCT_ID'] == element['ProductID']);

      if (dataMap['VAT_TYPE'] == 'V') {
        if (element['ส่วนลดรายการ'] != '0.0') {
          double discount = double.parse(element['ส่วนลดรายการ']);
          sumTotalVat =
              sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));

          sumTotalVat = sumTotalVat - discount;
        } else {
          sumTotalVat =
              sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
        }
      } else {
        if (element['ส่วนลดรายการ'] != '0.0') {
          double discount = double.parse(element['ส่วนลดรายการ']);

          sumTotalNoVat = sumTotalNoVat +
              (element['จำนวน'] * double.parse(element['ราคา']));
          sumTotalNoVat = sumTotalNoVat - discount;
        } else {
          sumTotalNoVat = sumTotalNoVat +
              (element['จำนวน'] * double.parse(element['ราคา']));
        }
      }
    }

    orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;
    orderList['ส่วนลด'] = 0.0;
    orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
    orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
    orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] =
        sumTotalVat - ((sumTotalVat * 7) / 107);
    orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
    orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;

    double totalA = orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] +
        orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'];

    totalA = totalA * customerPercentDiscount;

    print('ส่วนลดท้ายบิล');

    print(totalA);

    String totalPriceDiscountDoubleString =
        totalA.toStringAsFixed(2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

    orderList['ยอดรวมส่วนลดท้ายบิล'] = totalPriceDiscountDoubleString;

    orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] -
        double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);

    // orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] -
    //     double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);

    if (mounted) {
      setState(() {});
    }
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

  void increment(
      int index, int number, void Function(VoidCallback) setStateFunc) async {
    double total = 0.0;
    setStateFunc(() {
      productCount[index]++;
      orderList['ProductList'][index]['จำนวน'] = productCount[index];
    });
    // print(index);
    // print(orderList['ProductList'][index]['จำนวน']);
    // print(orderList['ยอดรวม']);

    // for (var element in orderList['ProductList']) {
    //   double sumTotal = (element['จำนวน'] * double.parse(element['ราคา']));

    //   total = total + sumTotal;
    // }
    await checkPromotions();

    double sumTotalVat = 0.0;
    double sumTotalNoVat = 0.0;

    for (var element in orderList['ProductList']) {
      Map<String, dynamic> dataMap = resultList.firstWhere(
          (product) => product['PRODUCT_ID'] == element['ProductID']);

      // if (dataMap['VAT_TYPE'] == 'V') {
      //   sumTotalVat =
      //       sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
      // } else {
      //   sumTotalNoVat =
      //       sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
      // }
      if (dataMap['VAT_TYPE'] == 'V') {
        if (element['ส่วนลดรายการ'] != '0.0') {
          double discount = double.parse(element['ส่วนลดรายการ']);
          sumTotalVat =
              sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));

          sumTotalVat = sumTotalVat - discount;
        } else {
          sumTotalVat =
              sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
        }
      } else {
        if (element['ส่วนลดรายการ'] != '0.0') {
          double discount = double.parse(element['ส่วนลดรายการ']);

          sumTotalNoVat = sumTotalNoVat +
              (element['จำนวน'] * double.parse(element['ราคา']));
          sumTotalNoVat = sumTotalNoVat - discount;
        } else {
          sumTotalNoVat = sumTotalNoVat +
              (element['จำนวน'] * double.parse(element['ราคา']));
        }
      }
    }
    orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;
    orderList['ส่วนลด'] = 0.0;
    orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
    orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
    orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] =
        sumTotalVat - ((sumTotalVat * 7) / 107);
    orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
    orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;

    double totalA = orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] +
        orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'];

    totalA = totalA * customerPercentDiscount;

    print('ส่วนลดท้ายบิล');

    print(totalA);

    String totalPriceDiscountDoubleString =
        totalA.toStringAsFixed(2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

    orderList['ยอดรวมส่วนลดท้ายบิล'] = totalPriceDiscountDoubleString;

    orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] -
        double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);
    // orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] -
    //     double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;

    print('==============================');
    print('This is A0904 Product Order Detail');
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
                                              print(orderList);
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
                                  'สรุปการสั่งซื้อ',
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 10.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                height: 35.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .accent3
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).accent2,
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'รวมรายการสินค้า ${NumberFormat('#,##0.00').format(orderList['ยอดรวม']).toString()} บาท',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 33.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .success,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(8.0),
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        5.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  'สรุปการสั่งชื้อ',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        5.0, 0.0, 5.0, 0.0),
                                                child: FaIcon(
                                                  FontAwesomeIcons
                                                      .shoppingBasket,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  size: 18.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                customerDataFetch['ClientIdจากMfoodAPI'],
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
                                width: 5,
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
                                    Stack(
                                      children: [
                                        orderList['ProductList'][i]
                                                    ['CONVERT_RATIO'] ==
                                                '0'
                                            ? Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        color:
                                                            Colors.red.shade100,
                                                        child: Text(
                                                          '     รายการนี้มีปัญหาเรื่องไม่พบ Convert Ratio \n กรุณา ลบรายการ ออกเพื่อดำเนินการเปิดออเดอร์ค่ะ ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: Colors
                                                                    .red
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        10.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: productImage[
                                                                              i] ==
                                                                          null
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
                                                                      : productImage[i] ==
                                                                              ''
                                                                          ? Image
                                                                              .asset(
                                                                              'assets/images/noproductimage.png',
                                                                              width: 65.0,
                                                                              height: 65.0,
                                                                              fit: BoxFit.contain,
                                                                            )
                                                                          : Image
                                                                              .network(
                                                                              productImage[i],
                                                                              width: 65.0,
                                                                              height: 65.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
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
                                                              Text(
                                                                orderList['ProductList']
                                                                        [i][
                                                                    'ชื่อสินค้า'],
                                                                style: FlutterFlowTheme.of(
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
                                                                              .w500,
                                                                    ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    orderList['ProductList'][i]
                                                                            [
                                                                            'ประเภทสินค้าDesc'] ??
                                                                        'ไม่มีประเภทสินค้า',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  orderList['ProductList'][i]
                                                                              [
                                                                              'ประเภทสินค้าDesc'] !=
                                                                          'สินค้าที่ต้องสั่งจองล่วงหน้า (Pre-Order)'
                                                                      ? SizedBox()
                                                                      : Text(
                                                                          'สั่งขั้นต่ำ ${orderList['ProductList'][i]['ขั้นต่ำจำนวน'].toString()} ${orderList['ProductList'][i]['ขั้นต่ำหน่วย']}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily: 'Kanit',
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                        ),
                                                                ],
                                                              ),
                                                              Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.3,
                                                                decoration:
                                                                    const BoxDecoration(),
                                                                child: Text(
                                                                  orderList['ProductList']
                                                                          [i][
                                                                      'คำอธิบายสินค้า'],
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      ),
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              StatefulBuilder(
                                                                  builder: (context,
                                                                      setStatePlan) {
                                                                return GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    List<Map<String, dynamic>?>?
                                                                        planWithProduct =
                                                                        [];

                                                                    print(
                                                                        'จำนวน plan ทั้งหมด');
                                                                    print(planProductBalanceList!
                                                                        .length);

                                                                    for (int m =
                                                                            0;
                                                                        m < planProductBalanceList!.length;
                                                                        m++) {
                                                                      print(planProductBalanceList![m]![
                                                                              'ProductDoc']
                                                                          [
                                                                          'PRODUCT_ID']);

                                                                      print(orderList['ProductList']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'ProductID']);

                                                                      if (planProductBalanceList![m]!['ProductDoc']
                                                                              [
                                                                              'PRODUCT_ID'] ==
                                                                          orderList['ProductList'][i]
                                                                              [
                                                                              'ProductID']) {
                                                                        planWithProduct!
                                                                            .add(planProductBalanceList![m]);
                                                                      }
                                                                    }
                                                                    print(
                                                                        'จำนวน plan ที่ตรงกับสินค้านี้');
                                                                    print(planWithProduct!
                                                                        .length);

                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              AlertDialog(
                                                                        actionsPadding:
                                                                            EdgeInsets.all(20),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0),
                                                                        ),
                                                                        actions: [
                                                                          WillPopScope(
                                                                            child:
                                                                                Container(
                                                                              // color: Colors
                                                                              //     .red,
                                                                              width: MediaQuery.sizeOf(context).width * 0.6,
                                                                              // height: MediaQuery.sizeOf(context).height *
                                                                              //     0.6,

                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text(
                                                                                      'ดูแผนการสั่งซื้อ ${orderList['ProductList'][i]['ชื่อสินค้า']}',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Kanit',
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            fontSize: 18,
                                                                                          ),
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                    planWithProduct.isEmpty
                                                                                        ? SizedBox(
                                                                                            height: 50,
                                                                                          )
                                                                                        : SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                    planWithProduct.isEmpty
                                                                                        ? SizedBox(
                                                                                            height: 100,
                                                                                            child: Text(
                                                                                              'สินค้ารายการนี้ ไม่มีแผนการผลิตค่ะ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Kanit',
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 14,
                                                                                                  ),
                                                                                            ),
                                                                                          )
                                                                                        : SizedBox(),
                                                                                    for (var planData in planWithProduct)
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              flex: 3,
                                                                                              child: Text(
                                                                                                'วันที่สินค้าเข้า : ${planData!['วันที่สินค้าเข้า_string']}',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Kanit',
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 14,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              flex: 2,
                                                                                              child: Text(
                                                                                                'จำนวน ${planData!['Balance'].toString()} ${planData!['Unit'].toString()}',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Kanit',
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 14,
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
                                                                            onWillPop: () async =>
                                                                                true,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ).then(
                                                                        (value) {
                                                                      planWithProduct
                                                                          .clear();
                                                                      setStatePlan(
                                                                          () {});
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.3,
                                                                    decoration:
                                                                        const BoxDecoration(),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .search,
                                                                            size:
                                                                                14,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).tertiary),
                                                                        Text(
                                                                          'ดูแผนการสั่งซื้อ',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Kanit',
                                                                                color: FlutterFlowTheme.of(context).tertiary,
                                                                              ),
                                                                          maxLines:
                                                                              2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                              Text(
                                                                'Lead time = ${orderList['ProductList'][i]['LeadTime']} วัน ',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Kanit',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .tertiary,
                                                                    ),
                                                                maxLines: 2,
                                                              ),
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                                              BorderRadius.circular(8.0),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).accent2,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                                                                        GestureDetector(
                                                                                          onTap: () async {
                                                                                            decrement(
                                                                                              i,
                                                                                              productCount[i],
                                                                                              setState,
                                                                                            );
                                                                                            CustomProgressDialog.show(context);

                                                                                            await checkPromotions().whenComplete(() => CustomProgressDialog.hide(context));
                                                                                          },
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.all(8),
                                                                                            decoration: BoxDecoration(
                                                                                                // shape: BoxShape.circle,
                                                                                                // color: productCount[i] >
                                                                                                //         0
                                                                                                //     ? Theme.of(context)
                                                                                                //         .primaryColor
                                                                                                //     : Theme.of(context)
                                                                                                //         .disabledColor,

                                                                                                ),
                                                                                            child: FaIcon(
                                                                                              FontAwesomeIcons.minus,
                                                                                              color: Colors.black,
                                                                                              size: 12.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () async {
                                                                                            await showModalBottomSheet(
                                                                                              isDismissible: false,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.vertical(
                                                                                                  top: Radius.circular(40.0), // ตั้งค่าเพื่อทำให้มุมบนสองข้างเป็นโค้ง
                                                                                                ),
                                                                                              ),
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return Container(
                                                                                                  height: 300,
                                                                                                  padding: EdgeInsets.all(60),
                                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        'กรุณากรอกจำนวนที่ต้องการค่ะ',
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 24.0,
                                                                                                          fontFamily: 'Kanit',
                                                                                                          letterSpacing: 1.0,
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 20,
                                                                                                      ),
                                                                                                      TextFormField(
                                                                                                        controller: inModalDialog,
                                                                                                        onEditingComplete: () async {
                                                                                                          CustomProgressDialog.show(context);

                                                                                                          await checkPromotions();

                                                                                                          double sumTotalVat = 0.0;
                                                                                                          double sumTotalNoVat = 0.0;

                                                                                                          for (var element in orderList['ProductList']) {
                                                                                                            Map<String, dynamic> dataMap = resultList.firstWhere((product) => product['PRODUCT_ID'] == element['ProductID']);

                                                                                                            // if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                            //   sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                            // } else {
                                                                                                            //   sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                            // }
                                                                                                            if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                              if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                                double discount = double.parse(element['ส่วนลดรายการ']);
                                                                                                                sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));

                                                                                                                sumTotalVat = sumTotalVat - discount;
                                                                                                              } else {
                                                                                                                sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                              }
                                                                                                            } else {
                                                                                                              if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                                double discount = double.parse(element['ส่วนลดรายการ']);

                                                                                                                sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                                sumTotalNoVat = sumTotalNoVat - discount;
                                                                                                              } else {
                                                                                                                sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                              }
                                                                                                            }
                                                                                                          }
                                                                                                          orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;
                                                                                                          orderList['ส่วนลด'] = 0.0;
                                                                                                          orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
                                                                                                          orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
                                                                                                          orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] = sumTotalVat - ((sumTotalVat * 7) / 107);
                                                                                                          orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
                                                                                                          orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;

                                                                                                          double totalA = orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] + orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'];

                                                                                                          totalA = totalA * customerPercentDiscount;

                                                                                                          print('ส่วนลดท้ายบิล');

                                                                                                          print(totalA);

                                                                                                          String totalPriceDiscountDoubleString = totalA.toStringAsFixed(2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

                                                                                                          orderList['ยอดรวมส่วนลดท้ายบิล'] = totalPriceDiscountDoubleString;

                                                                                                          orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] - double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);

                                                                                                          // orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] - double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);

                                                                                                          inModalDialog.clear();

                                                                                                          CustomProgressDialog.hide(context);

                                                                                                          Navigator.of(context).pop();

                                                                                                          setState(
                                                                                                            () {},
                                                                                                          );
                                                                                                          // CustomProgressDialog.show(context);

                                                                                                          // await checkPromotions().whenComplete(() => CustomProgressDialog.hide(context)).whenComplete(() => Navigator.of(context).pop());
                                                                                                        },
                                                                                                        onChanged: (value) async {
                                                                                                          productCount[i] = int.parse(value);

                                                                                                          orderList['ProductList'][i]['จำนวน'] = productCount[i];
                                                                                                          print(i);
                                                                                                          print(orderList['ProductList'][i]['จำนวน']);
                                                                                                          print(orderList['ยอดรวม']);

                                                                                                          // for (var element in orderList['ProductList']) {
                                                                                                          //   double sumTotal = (element['จำนวน'] * double.parse(element['ราคา']));

                                                                                                          //   total = total + sumTotal;
                                                                                                          // }

                                                                                                          setState(
                                                                                                            () {},
                                                                                                          );
                                                                                                        },
                                                                                                        inputFormatters: [
                                                                                                          FilteringTextInputFormatter.digitsOnly
                                                                                                        ],
                                                                                                        keyboardType: TextInputType.number,
                                                                                                        textAlign: TextAlign.center, // กำหนดให้ข้อความอยู่ตรงกลาง
                                                                                                        decoration: InputDecoration(
                                                                                                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0), // กำหนดระยะห่างของข้อความ
                                                                                                          hintText: 'กรอกจำนวนสินค้า', // ข้อความ placeholder
                                                                                                          border: OutlineInputBorder(
                                                                                                            // เพิ่มเส้นขอบ
                                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                                            borderSide: BorderSide(
                                                                                                              color: Colors.grey, // สีขอบ
                                                                                                              width: 1.0, // ความกว้างของขอบ
                                                                                                            ),
                                                                                                          ),
                                                                                                          enabledBorder: OutlineInputBorder(
                                                                                                            // เพิ่มเส้นขอบเมื่อสถานะ enable
                                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                                            borderSide: BorderSide(
                                                                                                              color: Colors.grey, // สีขอบ
                                                                                                              width: 1.0, // ความกว้างของขอบ
                                                                                                            ),
                                                                                                          ),
                                                                                                          focusedBorder: OutlineInputBorder(
                                                                                                            // เพิ่มเส้นขอบเมื่อสถานะ focus
                                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                                            borderSide: BorderSide(
                                                                                                              color: Colors.blue, // สีขอบเมื่อ focus
                                                                                                              width: 2.0, // ความกว้างของขอบเมื่อ focus
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 20,
                                                                                                      ),
                                                                                                      ElevatedButton(
                                                                                                          onPressed: () async {
                                                                                                            if (inModalDialog.text.isEmpty) {
                                                                                                              print('ไม่ได้กรอกจำนวน');
                                                                                                              Navigator.of(context).pop();
                                                                                                            } else {
                                                                                                              productCount[i] = int.parse(inModalDialog.text);

                                                                                                              orderList['ProductList'][i]['จำนวน'] = productCount[i];
                                                                                                              print(i);
                                                                                                              print(orderList['ProductList'][i]['จำนวน']);
                                                                                                              print(orderList['ยอดรวม']);

                                                                                                              // for (var element in orderList['ProductList']) {
                                                                                                              //   double sumTotal = (element['จำนวน'] * double.parse(element['ราคา']));

                                                                                                              //   total = total + sumTotal;
                                                                                                              // }
                                                                                                              CustomProgressDialog.show(context);

                                                                                                              await checkPromotions();

                                                                                                              double sumTotalVat = 0.0;
                                                                                                              double sumTotalNoVat = 0.0;

                                                                                                              for (var element in orderList['ProductList']) {
                                                                                                                Map<String, dynamic> dataMap = resultList.firstWhere((product) => product['PRODUCT_ID'] == element['ProductID']);
                                                                                                                if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                                  if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                                    double discount = double.parse(element['ส่วนลดรายการ']);
                                                                                                                    sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));

                                                                                                                    sumTotalVat = sumTotalVat - discount;
                                                                                                                  } else {
                                                                                                                    sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                                  }
                                                                                                                } else {
                                                                                                                  if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                                    double discount = double.parse(element['ส่วนลดรายการ']);

                                                                                                                    sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                                    sumTotalNoVat = sumTotalNoVat - discount;
                                                                                                                  } else {
                                                                                                                    sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                                  }
                                                                                                                }
                                                                                                                // if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                                //   sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                                // } else {
                                                                                                                //   sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                                // }
                                                                                                              }
                                                                                                              orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;
                                                                                                              orderList['ส่วนลด'] = 0.0;
                                                                                                              orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
                                                                                                              orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
                                                                                                              orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] = sumTotalVat - ((sumTotalVat * 7) / 107);
                                                                                                              orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
                                                                                                              orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;

                                                                                                              double totalA = orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] + orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'];

                                                                                                              totalA = totalA * customerPercentDiscount;

                                                                                                              print('ส่วนลดท้ายบิล');

                                                                                                              print(totalA);

                                                                                                              String totalPriceDiscountDoubleString = totalA.toStringAsFixed(2); // แปลงผลรวมเป็นสตริงที่มีทศนิยม 2 ตำแหน่ง

                                                                                                              orderList['ยอดรวมส่วนลดท้ายบิล'] = totalPriceDiscountDoubleString;

                                                                                                              orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] - double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);
                                                                                                              // orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] - double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);

                                                                                                              inModalDialog.clear();

                                                                                                              CustomProgressDialog.hide(context);

                                                                                                              Navigator.of(context).pop();

                                                                                                              // await checkPromotions().whenComplete(() => CustomProgressDialog.hide(context)).whenComplete(() => Navigator.of(context).pop());
                                                                                                            }
                                                                                                          },
                                                                                                          child: Text(
                                                                                                            'ตกลง',
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              fontSize: 24.0,
                                                                                                              fontFamily: 'Kanit',
                                                                                                              letterSpacing: 1.0,
                                                                                                            ),
                                                                                                          ))
                                                                                                    ],
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          },
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
                                                                                        GestureDetector(
                                                                                          onTap: () async {
                                                                                            increment(
                                                                                              i,
                                                                                              productCount[i],
                                                                                              setState,
                                                                                            );

                                                                                            CustomProgressDialog.show(context);

                                                                                            await checkPromotions().whenComplete(() => CustomProgressDialog.hide(context));
                                                                                          },
                                                                                          // onTap: () => increment(
                                                                                          //   i,
                                                                                          //   productCount[i],
                                                                                          //   setState,
                                                                                          // ),
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.all(8),
                                                                                            decoration: BoxDecoration(
                                                                                                // shape: BoxShape.circle,
                                                                                                // color: Theme.of(context)
                                                                                                //     .primaryColor,
                                                                                                ),
                                                                                            child: FaIcon(
                                                                                              FontAwesomeIcons.plus,
                                                                                              color: Colors.black,
                                                                                              size: 12.0,
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
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    orderList['ProductList'][i]['ยูนิต'],
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
                                                                        // 'ราคา ${orderList['ProductList'][i]['ราคา'].toString()} บาท ',
                                                                        'ราคา ${NumberFormat('#,##0.00').format(double.parse(orderList['ProductList'][i]['ราคา'].toString())).toString()} บาท ',

                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .override(
                                                                              fontFamily: 'Kanit',
                                                                              color: FlutterFlowTheme.of(context).primaryText,
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
                                                                        // 'ราคารวม ${priceSumProduct(double.parse(orderList['ProductList'][i]['ราคา']), productCount[i]).toString()} บาท ',
                                                                        'ราคารวม ${NumberFormat('#,##0.00').format(double.parse(priceSumProduct(double.parse(orderList['ProductList'][i]['ราคา']), productCount[i]).toString())).toString()} บาท ',

                                                                        // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .override(
                                                                              fontFamily: 'Kanit',
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  orderList['ProductList'][i]
                                                                              [
                                                                              'ส่วนลดรายการ'] ==
                                                                          '0.0'
                                                                      ? SizedBox()
                                                                      : Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Text(
                                                                              // 'ส่วนลดรายการ ${orderList['ProductList'][i]['ส่วนลดรายการ']} บาท ',
                                                                              'ส่วนลดรายการ ${NumberFormat('#,##0.00').format(double.parse(orderList['ProductList'][i]['ส่วนลดรายการ'].toString())).toString()} บาท ',

                                                                              // 'ราคารวม  ${(orderList['ProductList'][i]['ราคา'] * productCount[i])} บาท',
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    fontFamily: 'Kanit',
                                                                                    color: Colors.red,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  orderList['ProductList'][i]
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
                                                                                mainAxisSize: MainAxisSize.max,
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
                                                                                mainAxisSize: MainAxisSize.max,
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
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Text(
                                                                                    'จำนวน ${orderList['ProductList'][i]['จำนวนของแถม']} ${orderList['ProductList'][i]['หน่วยของแถม']}',

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
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    await showDialog(
                                                                      barrierDismissible:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return StatefulBuilder(builder:
                                                                            (context,
                                                                                setState) {
                                                                          return AlertDialog(
                                                                            // title: Text('Dialog Title'),
                                                                            // content: Text('This is the dialog content.'),
                                                                            actionsPadding:
                                                                                EdgeInsets.all(20),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),
                                                                            actions: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text('คุณต้องการลบสินค้านี้ ใช่หรือไม่ ?', style: FlutterFlowTheme.of(context).headlineMedium),
                                                                                    SizedBox(
                                                                                      height: 35,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        TextButton(
                                                                                            style: ButtonStyle(
                                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                                                                                ),
                                                                                              ),
                                                                                              side: MaterialStatePropertyAll(
                                                                                                BorderSide(color: Colors.green.shade300, width: 1),
                                                                                              ),
                                                                                            ),
                                                                                            onPressed: () => Navigator.pop(context),
                                                                                            child: CustomText(
                                                                                              text: "   ยกเลิก   ",
                                                                                              size: MediaQuery.of(context).size.height * 0.15,
                                                                                              color: Colors.green.shade300,
                                                                                            )),
                                                                                        Spacer(),
                                                                                        TextButton(
                                                                                            style: ButtonStyle(
                                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                                                                                ),
                                                                                              ),
                                                                                              side: MaterialStatePropertyAll(
                                                                                                BorderSide(color: Colors.red.shade300, width: 1),
                                                                                              ),
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              print(i);
                                                                                              productCount.removeAt(i);
                                                                                              productImage.removeAt(i);
                                                                                              orderList['ProductList'].removeAt(i);

                                                                                              print('2');

                                                                                              double total = 0;

                                                                                              // for (var element in orderList['ProductList']) {
                                                                                              //   int qty = int.parse(element['จำนวน'].toString());
                                                                                              //   double price = double.parse(element['ราคา'].toString());

                                                                                              //   double sumTotal = qty * price;

                                                                                              //   total = total + sumTotal;
                                                                                              // }
                                                                                              // print('3');

                                                                                              // orderList['ยอดรวม'] = total;

                                                                                              double sumTotalVat = 0.0;
                                                                                              double sumTotalNoVat = 0.0;

                                                                                              for (var element in orderList['ProductList']) {
                                                                                                Map<String, dynamic> dataMap = resultList.firstWhere((product) => product['PRODUCT_ID'] == element['ProductID']);

                                                                                                // if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                //   sumTotalVat =
                                                                                                //       sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                // } else {
                                                                                                //   sumTotalNoVat =
                                                                                                //       sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                // }
                                                                                                if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                  if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                    double discount = double.parse(element['ส่วนลดรายการ']);
                                                                                                    sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));

                                                                                                    sumTotalVat = sumTotalVat - discount;
                                                                                                  } else {
                                                                                                    sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                  }
                                                                                                } else {
                                                                                                  if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                    double discount = double.parse(element['ส่วนลดรายการ']);

                                                                                                    sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                    sumTotalNoVat = sumTotalNoVat - discount;
                                                                                                  } else {
                                                                                                    sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                              orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;
                                                                                              orderList['ส่วนลด'] = 0.0;
                                                                                              orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
                                                                                              orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
                                                                                              orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] = sumTotalVat - ((sumTotalVat * 7) / 107);
                                                                                              orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
                                                                                              orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;

                                                                                              // double sumTotalVat = 0.0;
                                                                                              // double sumTotalNoVat = 0.0;

                                                                                              // for (var element in orderList['ProductList']) {
                                                                                              //   Map<String, dynamic> dataMap = resultList.firstWhere((product) => product['PRODUCT_ID'] == element['ProductID']);

                                                                                              //   if (dataMap['VAT_TYPE'] == 'V') {
                                                                                              //     sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                              //   } else {
                                                                                              //     sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                              //   }
                                                                                              // }
                                                                                              // orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;
                                                                                              // orderList['ส่วนลด'] = 0.0;
                                                                                              // orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
                                                                                              // orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
                                                                                              // orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] = sumTotalVat - ((sumTotalVat * 7) / 107);
                                                                                              // orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
                                                                                              // orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;
                                                                                              // // orderList['มูลค่าสินค้ารวม'] = orderList['มูลค่าสินค้ารวม'] - double.parse(orderList['ยอดรวมส่วนลดท้ายบิล']);

                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: CustomText(
                                                                                              text: "   ตกลง   ",
                                                                                              size: MediaQuery.of(context).size.height * 0.15,
                                                                                              color: Colors.red.shade300,
                                                                                            )),
                                                                                        // TextButton(
                                                                                        //     style: ButtonStyle(
                                                                                        //       backgroundColor: MaterialStatePropertyAll(
                                                                                        //           Colors.blue.shade900),
                                                                                        //       // side: MaterialStatePropertyAll(
                                                                                        //       // BorderSide(
                                                                                        //       //     color: Colors.red.shade300, width: 1),
                                                                                        //       // ),
                                                                                        //     ),
                                                                                        //     onPressed: () {
                                                                                        //       Navigator.pop(context);
                                                                                        //     },
                                                                                        //     child: CustomText(
                                                                                        //       text: "   บันทึก   ",
                                                                                        //       size: MediaQuery.of(context).size.height * 0.15,
                                                                                        //       color: Colors.white,
                                                                                        //     )),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                      },
                                                                    ).then(
                                                                        (value) {
                                                                      if (mounted) {
                                                                        print(
                                                                            productCount);
                                                                        print(
                                                                            productImage);
                                                                        print(orderList[
                                                                            'ProductList']);

                                                                        checkConvertRatio =
                                                                            false;

                                                                        for (int i =
                                                                                0;
                                                                            i < orderList['ProductList'].length;
                                                                            i++) {
                                                                          // if (orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] ==
                                                                          //     true) {
                                                                          //   print('ไม่ต้องทำอะไรใน ConvertRatio');
                                                                          // } else {
                                                                          if (orderList['ProductList'][i]['CONVERT_RATIO'] ==
                                                                              '0') {
                                                                            checkConvertRatio =
                                                                                true;
                                                                          }
                                                                          // }
                                                                        }

                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error
                                                                        .withOpacity(
                                                                            0.7),
                                                                    size: 30.0,
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
                                              ],
                                            ),
                                            Divider(
                                              thickness: 0.5,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'ยอดรวมส่วนลดรายการทั้งหมด',
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
                                                  children: [
                                                    Text(
                                                      'ส่วนลดท้ายบิล/Discount',
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
                                                  children: [
                                                    Text(
                                                      'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม/Value of non VAT (N)',
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
                                                  children: [
                                                    Text(
                                                      'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม/Value including VAT (V)',
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
                                                  children: [
                                                    Text(
                                                      'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม/Value excluding VAT',
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
                                                  children: [
                                                    Text(
                                                      'ภาษีมูลค่าเพิ่ม/VAT',
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
                                                  children: [
                                                    Text(
                                                      'มูลค่าสินค้ารวม/Grand Total',
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
                                                        // '${orderList['ยอดรวมส่วนลดทั้งหมด']} บาท',
                                                        '${NumberFormat('#,##0.00').format(double.parse(orderList['ยอดรวมส่วนลดทั้งหมด'].toString())).toString()} บาท',

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
                                                        // '${orderList['ยอดรวมส่วนลดท้ายบิล']} บาท',
                                                        '${NumberFormat('#,##0.00').format(double.parse(orderList['ยอดรวมส่วนลดท้ายบิล'].toString())).toString()} บาท',
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
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${NumberFormat('#,##0.00').format(orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม']).toString()} บาท',
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
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'กรอกรายละเอียดเพิ่มเติม',
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
                                14.0, 20.0, 14.0, 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'กรุณากรอกหมายเลข PO  ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                              fontFamily: 'Kanit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 10),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // width: 500,
                                        // height: 60,
                                        child: TextFormField(
                                          controller: textController1,
                                          focusNode: textFieldFocusNode1,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            constraints:
                                                BoxConstraints(maxHeight: 40),
                                            labelText: 'กรุณากรอกหมายลข PO',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 0, 16, 0),
                                          ),
                                          cursorColor: Colors.grey,
                                          validator: (value) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'กรุณากรอกหมายเหตุ  ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                              fontFamily: 'Kanit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 10),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // width: 500,
                                        // height: 60,
                                        child: TextFormField(
                                          maxLines: 3,
                                          controller: textController2,
                                          focusNode: textFieldFocusNode2,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            constraints:
                                                BoxConstraints(maxHeight: 120),
                                            labelText: 'หมายเหตุ',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 12, 16, 12),
                                          ),
                                          // keyboardType: TextInputType.number,
                                          // inputFormatters: [],
                                          cursorColor: Colors.grey,
                                          validator: (value) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
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
                                          : orderList['วันเวลาจัดส่ง'],
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
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
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
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              print(orderList!['ตารางราคา']);
                              print(orderList!['ตารางราคา']);
                              print(orderList!['ตารางราคา']);
                              print(orderList!['ตารางราคา']);
                              print(orderList!['ตารางราคา']);
                              Map<String, dynamic>? result =
                                  await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            A09021AddressSetting(
                                          customerID: widget.customerID,
                                          orderDataMap: orderList,
                                          edit: 'แก้ไขที่อยู่',
                                        ),
                                      )).whenComplete(() {});

                              await loadData('แก้ไข', result);
                              setState(() {});
                            },
                            text: 'แก้ไขตัวเลือกขนส่ง',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Colors.yellow.shade800,
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
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              Map<String, dynamic> data = {};
                              await FirebaseFirestore.instance
                                  .collection(AppSettings.customerType ==
                                          CustomerType.Test
                                      ? 'ระยะเวลารับคำสั่งขายTest'
                                      : 'ระยะเวลารับคำสั่งขาย')
                                  // .collection('ระยะเวลารับคำสั่งขายTest')
                                  .doc('1')
                                  .get()
                                  .then((DocumentSnapshot documentSnapshot) {
                                if (documentSnapshot.exists) {
                                  // ดึงข้อมูลจากเอกสาร
                                  data = documentSnapshot.data()
                                      as Map<String, dynamic>;
                                } else {
                                  print('Document does not exist');
                                }
                              }).catchError((error) {
                                print("Failed to fetch document: $error");
                                return;
                              });

                              print(data['IS_ACTIVE']);
                              print(data['EndTime']);

                              DateTime now = DateTime.now();

                              // แปลงสตริงเป็น DateTime
                              DateFormat dateFormat = DateFormat("HH:mm");
                              DateTime inputTime =
                                  dateFormat.parse(data['EndTime'].toString());

                              // สร้าง DateTime ใหม่ที่มีวันที่เดียวกับเวลาปัจจุบัน แต่ใช้เวลาที่ได้จากสตริง
                              DateTime inputDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                inputTime.hour,
                                inputTime.minute,
                              );

                              print(orderList['วันเวลาจัดส่ง']);
                              print(orderList['วันเวลาจัดส่ง']);
                              print(orderList['วันเวลาจัดส่ง']);

                              String dateString = orderList['วันเวลาจัดส่ง'];
                              List<String> dateParts = dateString.split('-');

                              int day = int.parse(dateParts[0]);
                              int month = int.parse(dateParts[1]);
                              int year = int.parse(dateParts[2]);

                              DateTime newDate = DateTime(
                                  year, month, day, now.hour, now.minute);

                              // return;
                              if (data['IS_ACTIVE'] == true) {
                                // เปรียบเทียบเวลาปัจจุบันกับเวลาจากสตริง
                                if (newDate.year == inputDateTime.year &&
                                    newDate.month == inputDateTime.month &&
                                    newDate.day == inputDateTime.day) {
                                  // if (now.isAfter(inputDateTime)) {
                                  if ((newDate.hour > inputDateTime.hour ||
                                      (newDate.hour == inputDateTime.hour &&
                                          newDate.minute >
                                              inputDateTime.minute))) {
                                    print(
                                        "เวลาปัจจุบันเกินจาก 16:00 แล้ว และเป็นวันเดียวกัน");
                                    await QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        title:
                                            'คุณทำการเปิดออเดอร์เลยเวลาที่กำหนด',
                                        text:
                                            'เวลาการเปิดออเดอร์ ต้องไมเ่กิน ${data['EndTime']} น.\nหากต้องการสั่งสินค้า กรุณาเลือกวันและเวลาในการจัดส่ง หลังจากวันนี้ค่ะ',
                                        confirmBtnText: 'ตกลง');
                                    return;
                                  }
                                }
                              }
                              print("เวลาปัจจุบันยังไม่เกิน 16:00");

                              print(data['IS_ACTIVE']);

                              // return;

                              if (checkConvertRatio) {
                                print('ไม่สามารถเปิดออเดอร์ได้');
                                return;
                              }
                              statusOrderPass = true;

                              bool backDialog = false;
                              try {
                                // setState(() {
                                //   isLoading = true;
                                // });

                                print('send order');

                                // return;

                                if (orderList['ProductList'].length == 0) {
                                  print('product list == 0');
                                } else {
                                  //=== เช็คออเดอร์ว่ามีของแถมหรือไม่ ถ้ามีเพิ่ม list product นั้น ใน ออเดอร์นั้น อีก 1 list โดยสถานะลิสต์นี้คือ สินค้าของแถม ===

                                  // orderList['ProductList'][i]
                                  //     ['สถานะรายการนี้เป็นของแถม'] = false;
                                  // orderList['ProductList'][i]['ไอดีของแถม'] =
                                  //     '';
                                  // orderList['ProductList'][i]['ชื่อของแถม'] =
                                  //     '';
                                  // orderList['ProductList'][i]['จำนวนของแถม'] =
                                  //     '0';
                                  // orderList['ProductList'][i]['หน่วยของแถม'] =
                                  //     '';
                                  // orderList['ProductList'][i]['มีของแถม'] =
                                  //     false;

                                  //ปิดเงื่อนไข ต้องสั่งขั้นต่ำ
                                  // for (var element
                                  //     in orderList['ProductList']) {
                                  //   double checkTotal = double.parse(
                                  //       element['จำนวน'].toString());
                                  //   double checkTotalPre = double.parse(
                                  //       element['ขั้นต่ำจำนวน'].toString());

                                  //   if (checkTotalPre > checkTotal) {
                                  //     Fluttertoast.showToast(
                                  //         msg:
                                  //             'ต้องสั่งมากกว่าประมาณขั้นต่ำค่ะ!!');
                                  //     return;
                                  //   }
                                  // }

                                  //================================================================================
                                  //======================== เช็คของแถม =============================================

                                  for (int i = 0;
                                      i < orderList['ProductList'].length;
                                      i++) {
                                    if (orderList['ProductList'][i]
                                            ['มีของแถม'] ==
                                        true) {
                                      Map<String, dynamic> dataMap1 =
                                          orderList['ProductList'][i];

                                      // I/flutter ( 6276): {DocID: 0271330070900-ซอง, PromotionProductID: 0271330070900,
                                      //สถานะรายการนี้เป็นของแถม: false, มีของแถม: true, จำนวน: 50, จำนวนของแถม: 1,
                                      //ไอดีของแถม: 0271330020450, ProductID: 0271330070900, หน่วยของแถม: ซอง,
                                      //ชื่อสินค้า: มหาชัยฟู้ดส์เยาวราช ปลาเส้นทอด 900 กรัม, สินค้าโปรโมชั่น: false,
                                      //ชื่อของแถม: มหาชัยฟู้ดส์เยาวราช ลูกชิ้นปลากลมเล็ก 450 กรัม, ยูนิต: ซอง, คำอธิบายสินค้า: ,
                                      // ราคาพิเศษ: false, จำนวนสต๊อก: -80, ราคา: 108.00, คำอธิบายโปรโมชั่น: , ส่วนลดรายการ: 0.0}

                                      Map<String, dynamic>? foundMap =
                                          resultList.firstWhere((element) =>
                                              element['PRODUCT_ID'] ==
                                              dataMap1['ไอดีของแถม']);

                                      Map<String, dynamic> dataMapBonus = {};

                                      dataMapBonus['DocID'] = foundMap['DocId'];
                                      dataMapBonus['สถานะรายการนี้เป็นของแถม'] =
                                          true;
                                      dataMapBonus['มีของแถม'] = false;

                                      dataMapBonus['จำนวน'] =
                                          int.parse(dataMap1['จำนวนของแถม']);
                                      dataMapBonus['จำนวนของแถม'] = '';
                                      dataMapBonus['ไอดีของแถม'] = '';
                                      dataMapBonus['ProductID'] =
                                          foundMap['PRODUCT_ID'];
                                      dataMapBonus['หน่วยของแถม'] = '';

                                      dataMapBonus['ชื่อสินค้า'] =
                                          foundMap['NAMES'];

                                      dataMapBonus['ชื่อของแถม'] = '';
                                      dataMapBonus['คำอธิบายสินค้า'] =
                                          foundMap['รายละเอียด'] == ''
                                              ? ''
                                              : foundMap['รายละเอียด'];

                                      dataMapBonus['ยูนิต'] =
                                          dataMap1['หน่วยของแถม'];
                                      dataMapBonus['ราคา'] = '0';

                                      orderList['ProductList']
                                          .add(dataMapBonus);

                                      // orderList['ProductList'];

                                      productCount.add(
                                          int.parse(dataMap1['จำนวนของแถม']));
                                    }
                                  }

                                  print('==============ของแถม==============');

                                  for (var element
                                      in orderList['ProductList']) {
                                    print(element);
                                  }

                                  print('==============ของแถม==============');

                                  //======================================================================
                                  //=== ทำการค้นหา หน่วยเทียบกับ Product Convert Ratio ให้ได้หน่วย base =========

                                  print('PROUDUCT_CONVERT_RATIO');

                                  List<String> stockAll = [];
                                  List<String> stockOrderAll = [];

                                  for (int i = 0;
                                      i < orderList['ProductList'].length;
                                      i++) {
                                    print('{');
                                    print(orderList['ProductList'][i]
                                        ['ProductID']);
                                    print(orderList['ProductList'][i]['ยูนิต']);
                                    Map<String, dynamic>? foundmapRatio =
                                        productCovertRatio.firstWhere(
                                      (element) =>
                                          element!['PRODUCT_ID'] ==
                                              orderList['ProductList'][i]
                                                  ['ProductID'] &&
                                          element['UNIT'] ==
                                              orderList['ProductList'][i]
                                                  ['ยูนิต'],
                                      orElse: () => {},
                                    );
                                    print('0');

                                    // foundmapRatio!['CONVERT_RATIO'] = null;

                                    if (foundmapRatio!['CONVERT_RATIO'] ==
                                        null) {
                                      foundmapRatio!['CONVERT_RATIO'] = '0';
                                    }

                                    orderList['ProductList'][i]
                                            ['CONVERT_RATIO'] =
                                        foundmapRatio!['CONVERT_RATIO'] ?? '0';

                                    print(foundmapRatio!['CONVERT_RATIO']);
                                    print('1');

                                    Map<String, dynamic>? foundmapRatioBase =
                                        productCovertRatio.firstWhere(
                                      (element) =>
                                          element!['PRODUCT_ID'] ==
                                              orderList['ProductList'][i]
                                                  ['ProductID'] &&
                                          element['CONVERT_RATIO'] == 1,
                                      orElse: () => {},
                                    );

                                    orderList['ProductList'][i]['UNIT_BASE'] =
                                        foundmapRatioBase!['UNIT'];
                                    print('2');

                                    double total = double.parse(
                                            orderList['ProductList'][i]['จำนวน']
                                                .toString()) *
                                        double.parse(
                                            foundmapRatio!['CONVERT_RATIO']
                                                .toString());

                                    print('3');

                                    //================================================================================
                                    //======================== เช็คแผนของ fastmove ====================================

                                    Map<String, dynamic>? foundMap =
                                        resultList.firstWhere(
                                      (element) =>
                                          element['PRODUCT_ID'] ==
                                          orderList['ProductList'][i]
                                              ['ProductID'],
                                      orElse: () => {},
                                    );

                                    //=============== โหลด balance อีกครั้ง =========================

                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection(
                                                AppSettings.customerType ==
                                                        CustomerType.Test
                                                    ? 'ProductTest'
                                                    : 'Product')
                                            .where('PRODUCT_ID',
                                                isEqualTo:
                                                    foundMap['PRODUCT_ID'])
                                            .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      // print(querySnapshot.docs.length);
                                      // length == 1 เพราะ PRODUCT_ID มีตัวเดียว

                                      for (var doc in querySnapshot.docs) {
                                        Map<String, dynamic> data =
                                            doc.data() as Map<String, dynamic>;
                                        print('Document data: ${doc.data()}');
                                        // print('จำนวนสต๊อก');
                                        // print(foundMap['Balance']);

                                        foundMap['Balance'] = data['Balance'];

                                        // print(foundMap['Balance']);
                                      }
                                    } else {
                                      print('No documents found!');
                                    }

                                    //=======================================================

                                    print('4');

                                    // return;

                                    double stock = double.parse(
                                        foundMap['Balance'].toString());

                                    print('----- บวก balnce -----');
                                    print(foundMap['Balance']);
                                    print(stock);
                                    print(planProductBalanceList!.length);

                                    //ปัดเศษขึ้น

                                    NumberFormat numberFormat =
                                        NumberFormat("#.00");
                                    String formattedNumber =
                                        numberFormat.format(stock);

                                    print(formattedNumber);

                                    stock = double.parse(formattedNumber);

                                    for (int j = 0;
                                        j < planProductBalanceList!.length;
                                        j++) {
                                      print('แผนที่ $j');
                                      Map<String, dynamic>? foundMapFastMove;
                                      if (planProductBalanceList![j]![
                                                  'ProductDoc']['PRODUCT_ID'] ==
                                              orderList['ProductList'][i]
                                                  ['ProductID'] &&
                                          planProductBalanceList![j]![
                                                  'ProductDoc']['UNIT'] ==
                                              orderList['ProductList'][i]
                                                  ['UNIT_BASE']) {
                                        print('สินค้านี้มีในแผน $i');

                                        foundMapFastMove =
                                            planProductBalanceList![j];

                                        if (foundMapFastMove!.isNotEmpty) {
                                          String dateTimeString =
                                              foundMapFastMove[
                                                  'วันที่สินค้าเข้า_string'];

                                          List<String> parts =
                                              orderList['วันเวลาจัดส่ง']
                                                  .toString()
                                                  .split('-');

                                          DateTime dateTimeConvert = DateTime(
                                              int.parse(parts[2]),
                                              int.parse(parts[1]),
                                              int.parse(parts[0]));

                                          // ใช้ DateFormat เพื่อแปลงวัตถุ DateTime เป็นสตริงที่ต้องการ
                                          String formattedString =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(dateTimeConvert);

                                          String dateTimeStringAfter =
                                              formattedString;

                                          // print(orderList[
                                          // 'วันเวลาจัดส่ง_string']);
                                          // print(dateTimeStringAfter);

                                          DateTime dateTime =
                                              DateTime.parse(dateTimeString);
                                          // print(dateTime);

                                          DateTime dateTimeNow = DateTime.now();
                                          // print(dateTimeNow);

                                          DateTime dateTimeAfter =
                                              DateTime.parse(
                                                  dateTimeStringAfter);

                                          // print(dateTimeAfter);

                                          String planStock =
                                              foundMapFastMove['Balance']
                                                  .toString();
                                          // print(
                                          //     '-------- จำนวน balance ของแผน -----------');
                                          // print(isBetweenCheckBalance(dateTime,
                                          //         dateTimeNow, dateTimeAfter)
                                          //     .toString());
                                          // print(
                                          //     foundMapFastMove['ProductName']);
                                          print('จำนวนที่มีเพิ่ม $planStock');

                                          double planStockDouble =
                                              double.parse(planStock);

                                          if (isBetweenCheckBalance(dateTime,
                                              dateTimeNow, dateTimeAfter)) {
                                            print('--- อยู่ในช่วงเวลา -----');
                                            print('stock เดิม $stock');
                                            print(
                                                'stock เพิ่ม $planStockDouble');
                                            stock = stock + planStockDouble;

                                            print('stock รวม $stock');
                                            print('บวก balance แผน $i เพิ่ม');
                                          } else {
                                            print(
                                                '--- ไม่อยู่ในช่วงเวลา -----');
                                          }
                                        }
                                      } else {
                                        print('สินค้านี้ไม่มีในแผนทั้งหมด');
                                      }
                                    }

                                    print(stock);
                                    print('----- จบ บวก balnce -----');

                                    // Map<String, dynamic>? foundMapFastMove =
                                    //     planProductBalanceList!.firstWhere(
                                    //   (element) =>
                                    //       element!['ProductDoc']
                                    //               ['PRODUCT_ID'] ==
                                    //           orderList['ProductList'][i]
                                    //               ['ProductID'] &&
                                    //       element['ProductDoc']['UNIT'] ==
                                    //           orderList['ProductList'][i]
                                    //               ['UNIT_BASE'],
                                    //   orElse: () => {},
                                    // );
                                    // print('-------------------------');
                                    // print(foundMapFastMove);

                                    //=================================================================

                                    // List<Map<String, dynamic>?>? listFastmove =
                                    //     [];

                                    // for (int j = 0;
                                    //     j < planProductBalanceList!.length;
                                    //     j++) {
                                    //   if (planProductBalanceList![j]![
                                    //               'ProductDoc']['PRODUCT_ID'] ==
                                    //           orderList['ProductList'][i] &&
                                    //       planProductBalanceList![j]![
                                    //               'ProductDoc']['UNIT'] ==
                                    //           orderList['ProductList'][i]
                                    //               ['UNIT_BASE']) {
                                    //     listFastmove
                                    //         .add(planProductBalanceList![j]!);
                                    //   }
                                    // }

                                    // for (int k = 0;
                                    //     k < listFastmove!.length;
                                    //     k++) {
                                    //   print(
                                    //       '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
                                    //   print(listFastmove[k]);
                                    //   print(
                                    //       '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                    // }

                                    //=================================================================

                                    // return;

                                    // if (foundMapFastMove!.isNotEmpty) {
                                    //   String dateTimeString = foundMapFastMove[
                                    //       'วันที่สินค้าเข้า_string'];

                                    //   List<String> parts =
                                    //       orderList['วันเวลาจัดส่ง']
                                    //           .toString()
                                    //           .split('-');

                                    //   DateTime dateTimeConvert = DateTime(
                                    //       int.parse(parts[2]),
                                    //       int.parse(parts[1]),
                                    //       int.parse(parts[0]));

                                    //   // ใช้ DateFormat เพื่อแปลงวัตถุ DateTime เป็นสตริงที่ต้องการ
                                    //   String formattedString =
                                    //       DateFormat('yyyy-MM-dd')
                                    //           .format(dateTimeConvert);

                                    //   String dateTimeStringAfter =
                                    //       formattedString;

                                    //   print(orderList['วันเวลาจัดส่ง_string']);
                                    //   print(dateTimeStringAfter);

                                    //   DateTime dateTime =
                                    //       DateTime.parse(dateTimeString);
                                    //   print(dateTime);

                                    //   DateTime dateTimeNow = DateTime.now();
                                    //   print(dateTimeNow);

                                    //   DateTime dateTimeAfter =
                                    //       DateTime.parse(dateTimeStringAfter);

                                    //   print(dateTimeAfter);

                                    //   String planStock =
                                    //       foundMapFastMove['Balance']
                                    //           .toString();
                                    //   print(planStock);

                                    //   double planStockDouble =
                                    //       double.parse(planStock);

                                    //   if (isBetweenCheckBalance(dateTime,
                                    //       dateTimeNow, dateTimeAfter)) {
                                    //     stock = stock + planStockDouble;

                                    //     print('บวก balance แผน เพิ่ม');
                                    //   }

                                    //   print(stock.toString());
                                    // }

                                    if (stock < 0.00) {
                                      stockAll.add('0');
                                    } else {
                                      stockAll.add(stock.toString());
                                    }

                                    stockOrderAll.add(total.toString());

                                    if (total > stock) {
                                      print('จำนวนที่สั่ง $total');
                                      print('จำนวนที่มี $stock');
                                      print('เรียกไดอะล๊อค');
                                      print(statusOrderPass);
                                      statusOrderPass = false;

                                      orderList['ProductList'][i]
                                          ['รายการนี้เกินสต๊อก'] = true;
                                    } else {
                                      print('จำนวนที่สั่ง $total');
                                      print('จำนวนที่มี $stock');
                                      print('ออเดอร์นี้ผ่าน');

                                      print(statusOrderPass);
                                      orderList['ProductList'][i]
                                          ['รายการนี้เกินสต๊อก'] = false;
                                    }
                                    print('}');
                                  }

                                  print(textController1.text);
                                  print(textController1.text);
                                  print(textController1.text);
                                  print(textController2.text);
                                  print(textController2.text);
                                  print(textController2.text);

                                  for (int i = 0;
                                      i < orderList['ProductList'].length;
                                      i++) {
                                    print(orderList['ProductList'][i]
                                        ['ชื่อสินค้า']);
                                    print(orderList['ProductList'][i]['จำนวน']);
                                    print(orderList['ProductList'][i]
                                        ['สถานะรายการนี้เป็นของแถม']);
                                    print(orderList['ProductList'][i]
                                        ['รายการนี้เกินสต๊อก']);
                                    print(stockAll[i]);
                                    print(stockOrderAll[i]);
                                  }

                                  print(statusOrderPass);
                                  print(statusOrderPass);
                                  print(statusOrderPass);

                                  // return;

                                  if (!statusOrderPass) {
                                    //======= นำสินค้าไปเทียบกับ balance ทุกตัว หากมีตัวใดตัวนึงเกิน balance ให้เข้าตัวเลือก 3 ข้อ======================

                                    List<String> checkBoxString = [
                                      'ส่งเฉพาะสินค้าที่ปริมาณสต๊อคเพียงพอ และจองสินค้าสต๊อคไม่พอ รอบถัดไป',
                                      'สินค้าทั้งหมดในตระกร้า ส่งรอบถัดไปทั้งจำนวน',
                                      'ยกเลิกสินค้าที่ปริมาณสต๊อคไม่เพียงพอ สั่งเฉพาะสินค้าที่มีในสต๊อคเท่านั้น',
                                    ];

                                    List<bool> checkboxActiveList = [
                                      false,
                                      false,
                                      false
                                    ];

                                    bool loadState = false;
                                    bool productPreAll = true;

                                    print('no error');

                                    print(orderList['ProductList'].length);

                                    await showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        actions: [
                                          StatefulBuilder(
                                              builder: (contextIN, setState) {
                                            for (var element in productCount) {
                                              productCountOld.add(element);
                                            }
                                            print(orderList['ProductList']
                                                .length);
                                            for (int i = 0;
                                                i <
                                                    orderList['ProductList']
                                                        .length;
                                                i++) {
                                              print('รอบ $i');
                                              print(
                                                  orderList['ProductList'][i]);
                                              print('\n\n\n');

                                              if (orderList['ProductList'][i][
                                                      'สถานะรายการนี้เป็นของแถม'] ==
                                                  true) {
                                                print('เป็นของแถม');
                                              } else {
                                                print('ไม่เป็นของแถม');
                                                print(i);
                                                print(orderList['ProductList']
                                                    [i]['ประเภทสินค้าDesc']);
                                                if (orderList['ProductList'][i]
                                                        ['ประเภทสินค้าDesc'] ==
                                                    'สินค้าที่ต้องสั่งจองล่วงหน้า (Pre-Order)') {
                                                  print('ตรง');
                                                } else {
                                                  print('ไม่ตรง');

                                                  productPreAll = false;
                                                  // break;
                                                }
                                              }
                                              print('$i เสร็จ');
                                            }

                                            for (var element
                                                in orderList['ProductList']) {
                                              print(element);
                                            }

                                            return WillPopScope(
                                              onWillPop: () async => true,
                                              child: isLoading2
                                                  ? Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                      color: Colors.white,
                                                      child: CircularLoading(
                                                          success: !isLoading),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14.0),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.85,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.8,
                                                            color: Colors.white,
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ออเดอร์นี้ มีสินค้าบางรายการที่จำนวนสต้อกไม่พอ',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .displaySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              22.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),

                                                                  // I/flutter ( 6276): {DocID: 0271330070900-ซอง, PromotionProductID: 0271330070900,
                                                                  //สถานะรายการนี้เป็นของแถม: false, มีของแถม: true, จำนวน: 50, จำนวนของแถม: 1,
                                                                  //ไอดีของแถม: 0271330020450, ProductID: 0271330070900, หน่วยของแถม: ซอง,
                                                                  //ชื่อสินค้า: มหาชัยฟู้ดส์เยาวราช ปลาเส้นทอด 900 กรัม, สินค้าโปรโมชั่น: false,
                                                                  //ชื่อของแถม: มหาชัยฟู้ดส์เยาวราช ลูกชิ้นปลากลมเล็ก 450 กรัม, ยูนิต: ซอง, คำอธิบายสินค้า: ,
                                                                  // ราคาพิเศษ: false, จำนวนสต๊อก: -80, ราคา: 108.00, คำอธิบายโปรโมชั่น: , ส่วนลดรายการ: 0.0}
                                                                  SizedBox(
                                                                    height: 50,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border
                                                                            .all(),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        for (int i =
                                                                                0;
                                                                            i < orderList['ProductList'].length;
                                                                            i++)
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                8,
                                                                                3,
                                                                                8,
                                                                                10),
                                                                            color: double.parse(stockOrderAll[i].toString()) > double.parse(stockAll[i].toString())
                                                                                ? Colors.red[50]
                                                                                : Colors.white,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'รหัสสินค้า ${orderList['ProductList'][i]['ProductID']}',
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: 'Kanit',
                                                                                                color: Colors.black,
                                                                                                fontSize: 12.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        Text(
                                                                                          '${orderList['ProductList'][i]['ชื่อสินค้า']}',
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: 'Kanit',
                                                                                                color: Colors.black,
                                                                                                fontSize: 12.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        orderList['ProductList'][i]['ประเภทสินค้าDesc'] != 'สินค้าที่ต้องสั่งจองล่วงหน้า (Pre-Order)'
                                                                                            ? SizedBox()
                                                                                            : Text(
                                                                                                'สั่งขั้นต่ำ ${orderList['ProductList'][i]['ขั้นต่ำจำนวน'].toString()} ${orderList['ProductList'][i]['ขั้นต่ำหน่วย']}',
                                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                      fontFamily: 'Kanit',
                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                      fontSize: 12.0,
                                                                                                      fontWeight: FontWeight.w300,
                                                                                                    ),
                                                                                              ),
                                                                                        orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] == true
                                                                                            ? Text(
                                                                                                'รายการนี้เป็นของแถม',
                                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                      fontFamily: 'Kanit',
                                                                                                      color: Colors.red.shade900,
                                                                                                      fontSize: 12.0,
                                                                                                      fontWeight: FontWeight.normal,
                                                                                                    ),
                                                                                                maxLines: 2,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              )
                                                                                            : SizedBox()
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          // 'จำนวน ${orderList['ProductList'][i]['จำนวน']} ${orderList['ProductList'][i]['ยูนิต']}',
                                                                                          'จำนวน ${productCountOld[i].toString()} ${orderList['ProductList'][i]['ยูนิต']}',

                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: 'Kanit',
                                                                                                color: Colors.black,
                                                                                                fontSize: 12.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                        ),
                                                                                        Text(
                                                                                          'จำนวนหน่วยฐาน\n ${double.parse(stockOrderAll[i].toString()).toStringAsFixed(2).toString()} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: 'Kanit',
                                                                                                color: Colors.red,
                                                                                                fontSize: 12.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Text(
                                                                                      // 'จำนวนสต๊อก\n ${stockAll[i]} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                      'จำนวนสต๊อก\n ${double.parse(stockAll[i].toString()).toStringAsFixed(2).toString()} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                            fontFamily: 'Kanit',
                                                                                            color: Colors.black,
                                                                                            fontSize: 12.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  double.parse(stockAll[i].toString()) - double.parse(stockOrderAll[i].toString()) > 0
                                                                                      ? Expanded(
                                                                                          flex: 2,
                                                                                          child: Text(
                                                                                            // 'จำนวนสินค้าไม่พอ\n ${stockAll[i]} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                            'จำนวนสินค้าคงเหลือ\n ${(double.parse(stockAll[i].toString()) - double.parse(stockOrderAll[i].toString())).toStringAsFixed(2).toString()} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  fontFamily: 'Kanit',
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 12.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                ),
                                                                                          ),
                                                                                        )
                                                                                      : Expanded(
                                                                                          flex: 2,
                                                                                          child: Text(
                                                                                            // 'จำนวนสินค้าไม่พอ\n ${stockAll[i]} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                            'จำนวนสินค้าไม่เพียงพอ\n ${(double.parse(stockAll[i].toString()) - double.parse(stockOrderAll[i].toString())).toStringAsFixed(2).toString()} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  fontFamily: 'Kanit',
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 12.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  SizedBox(
                                                                    height: 50,
                                                                  ),
                                                                  Text(
                                                                    'กรุณาเลือกรูปแบบการจัดส่ง',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              20.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                  for (int i =
                                                                          0;
                                                                      i < 3;
                                                                      i++)
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Checkbox(
                                                                          fillColor: (i == 0 || i == 2) && productPreAll
                                                                              ? MaterialStateProperty.all(Colors.black.withOpacity(0.2))
                                                                              : null,
                                                                          value:
                                                                              checkboxActiveList[i],
                                                                          onChanged: (i == 0 || i == 2) && productPreAll
                                                                              ? null
                                                                              : (value) async {
                                                                                  checkboxActiveList[i] = value!;

                                                                                  if (i == 0) {
                                                                                    //========================= เลือกรูปแบบที่ 1 ============================================
                                                                                    checkboxActiveList[1] = false;
                                                                                    checkboxActiveList[2] = false;

                                                                                    orderList['วันเวลาจัดส่ง'] = orderDateBefore;
                                                                                    orderList['วันเวลาจัดส่ง_day'] = orderDateBeforeDay;
                                                                                    orderList['วันเวลาจัดส่ง_string'] = orderDateBeforeString;
                                                                                  } else if (i == 1) {
                                                                                    //========================= เลือกรูปแบบที่ 2 ============================================
                                                                                    setState(
                                                                                      () {
                                                                                        loadState = true;
                                                                                      },
                                                                                    );

                                                                                    orderList['วันเวลาจัดส่ง'] = orderDateBefore;
                                                                                    orderList['วันเวลาจัดส่ง_day'] = orderDateBeforeDay;
                                                                                    orderList['วันเวลาจัดส่ง_string'] = orderDateBeforeString;

                                                                                    checkboxActiveList[0] = false;

                                                                                    checkboxActiveList[2] = false;

                                                                                    List<String> parts = orderList['วันเวลาจัดส่ง'].toString().split('-');

                                                                                    DateTime dateTimeConvert = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

                                                                                    DateTime now = DateTime.now();

                                                                                    // // print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                    // // print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                    // // print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                    // // print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                    // // print(orderList['วันเวลาจัดส่ง']);
                                                                                    // // print(orderList['วันเวลาจัดส่ง_day']);
                                                                                    // // print(orderList['วันเวลาจัดส่ง_string']);

                                                                                    if (dateTimeConvert.year == now.year && dateTimeConvert.month == now.month && dateTimeConvert.day == now.day) {
                                                                                      // ฟังก์ชันที่ใช้หาวันถัดไปที่เป็นจริงตาม A

                                                                                      //  I/flutter (31739): {ส่งทุกวัน: false, ส่งทุกวันอังคาร: true, ส่งทุกวันอาทิตย์: false, ส่งทุกวันจันทร์: true,
                                                                                      //ส่งทุกวันพฤหัสบดี: true, ส่งทุกวันศุกร์: true, ส่งทุกวันพุธ: true, ส่งทุกวันเสาร์: true}

                                                                                      DateTime? getNextTrueDay(String currentDay) {
                                                                                        print('getNextTrueDay');
                                                                                        print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                        print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                        print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                        print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                        print(orderList['สายส่ง_วันที่จัดส่ง']);
                                                                                        // return;
                                                                                        List<String> sortedKeys = [
                                                                                          'ส่งทุกวัน',
                                                                                          'ส่งทุกวันอาทิตย์',
                                                                                          'ส่งทุกวันจันทร์',
                                                                                          'ส่งทุกวันอังคาร',
                                                                                          'ส่งทุกวันพุธ',
                                                                                          'ส่งทุกวันพฤหัสบดี',
                                                                                          'ส่งทุกวันศุกร์',
                                                                                          'ส่งทุกวันเสาร์',
                                                                                        ];
                                                                                        Map<String, bool> sortedMap = {};
                                                                                        sortedKeys.forEach((key) {
                                                                                          if (orderList['สายส่ง_วันที่จัดส่ง'].containsKey(key)) {
                                                                                            sortedMap[key] = orderList['สายส่ง_วันที่จัดส่ง'][key];
                                                                                          }
                                                                                        });
                                                                                        // print(sortedMap);
                                                                                        List<String> keys = [];
                                                                                        List<bool> values = [];
                                                                                        int rounds = 8;
                                                                                        List<bool> resultList = [];
                                                                                        List<String> resultListEnglish = [];
                                                                                        sortedMap.forEach((key, value) {
                                                                                          keys.add(key);
                                                                                          values.add(value);
                                                                                        });
                                                                                        List<String> englishDays = [
                                                                                          'Allday',
                                                                                          'Sunday',
                                                                                          'Monday',
                                                                                          'Tuesday',
                                                                                          'Wednesday',
                                                                                          'Thursday',
                                                                                          'Friday',
                                                                                          'Saturday'
                                                                                        ];
                                                                                        // values[5] = false;
                                                                                        // values[6] = false;
                                                                                        // values[1] = false;
                                                                                        String alldaykeys = keys[0];
                                                                                        keys.removeAt(0);
                                                                                        bool alldayvalues = values[0];
                                                                                        values.removeAt(0);
                                                                                        String alldayenglishday = englishDays[0];
                                                                                        englishDays.removeAt(0);
                                                                                        for (int i = 0; i < rounds; i++) {
                                                                                          resultList.addAll(values);
                                                                                          resultListEnglish.addAll(englishDays);
                                                                                        }
                                                                                        // print(keys);
                                                                                        // print(values);
                                                                                        // print(englishDays);
                                                                                        // print(resultList);
                                                                                        if (alldayvalues) {
                                                                                          String dateString = orderList['วันเวลาจัดส่ง'].toString();
                                                                                          // สร้างรูปแบบของวันที่
                                                                                          DateFormat format = DateFormat('dd-MM-yyyy');
                                                                                          // แปลงสตริงเป็นวัตถุ DateTime
                                                                                          DateTime dateTime = format.parse(dateString);
                                                                                          DateTime newDate = dateTime.add(Duration(days: 1));
                                                                                          DateFormat format5 = DateFormat('dd-MM-yyyy');
                                                                                          // แปลงวัตถุ DateTime เป็นสตริงที่ระบุรูปแบบ "dd-MM-yyyy"
                                                                                          String dateStringUpdate = format5.format(newDate);
                                                                                          //======== ใช้วันเดิมแล้ว ไม่ต้องเปลี่ยนวัน ==========
                                                                                          orderList['วันเวลาจัดส่ง'] = dateStringUpdate;

                                                                                          orderList['วันเวลาจัดส่ง_day'] = DateFormat('EEEE').format(newDate);
                                                                                          orderList['วันเวลาจัดส่ง_string'] = newDate.toString();

                                                                                          print(orderList['วันเวลาจัดส่ง']);
                                                                                          print(orderList['วันเวลาจัดส่ง_day']);
                                                                                          print(orderList['วันเวลาจัดส่ง_string']);
                                                                                          //======== ใช้วันเดิมแล้ว ไม่ต้องเปลี่ยนวัน ==========

                                                                                          return newDate;
                                                                                        } else {
                                                                                          int totalDay = 0;
                                                                                          int index = englishDays.indexOf(currentDay);
                                                                                          int indexStop = 0;
                                                                                          // print(index);
                                                                                          for (int i = index + 1; i < resultList.length; i++) {
                                                                                            // print(i);
                                                                                            if (resultList[i]) {
                                                                                              indexStop = i;
                                                                                              // print(indexStop);
                                                                                              totalDay = i - index;
                                                                                              break;
                                                                                            }
                                                                                          }
                                                                                          // print('ห่างกี่วัน');
                                                                                          // print(totalDay);
                                                                                          // print(totalDay);
                                                                                          // print(totalDay);
                                                                                          // print(totalDay);
                                                                                          // print(orderList['วันเวลาจัดส่ง']);
                                                                                          String dateString = orderList['วันเวลาจัดส่ง'].toString();
                                                                                          // สร้างรูปแบบของวันที่
                                                                                          DateFormat format = DateFormat('dd-MM-yyyy');
                                                                                          // แปลงสตริงเป็นวัตถุ DateTime
                                                                                          DateTime dateTime = format.parse(dateString);
                                                                                          // print(dateTime);
                                                                                          DateTime newDate = dateTime.add(Duration(days: totalDay));
                                                                                          DateFormat format5 = DateFormat('dd-MM-yyyy');
                                                                                          // แปลงวัตถุ DateTime เป็นสตริงที่ระบุรูปแบบ "dd-MM-yyyy"
                                                                                          String dateStringUpdate = format5.format(newDate);
                                                                                          //======== ใช้วันเดิมแล้ว ไม่ต้องเปลี่ยนวัน ==========
                                                                                          orderList['วันเวลาจัดส่ง'] = dateStringUpdate;
                                                                                          orderList['วันเวลาจัดส่ง_day'] = resultListEnglish[indexStop];
                                                                                          orderList['วันเวลาจัดส่ง_string'] = newDate.toString();
                                                                                          //======== ใช้วันเดิมแล้ว ไม่ต้องเปลี่ยนวัน ==========
                                                                                          return newDate;
                                                                                          // List<String> thaiDays = [
                                                                                          //   'อาทิตย์',
                                                                                          //   'จันทร์',
                                                                                          //   'อังคาร',
                                                                                          //   'พุธ',
                                                                                          //   'พฤหัสบดี',
                                                                                          //   'ศุกร์',
                                                                                          //   'เสาร์',
                                                                                          // ];

                                                                                          // Map<String, String> A = {
                                                                                          //   'ส่งทุกวัน': orderList['สายส่ง_วันที่จัดส่ง']['ส่งทุกวัน'],
                                                                                          // };

                                                                                          // thaiDays.forEach((day) {
                                                                                          //   A['ส่งทุกวัน$day'] = 'true, $day';
                                                                                          // });

                                                                                          // print(A);

                                                                                          // Map<String, bool> A = {
                                                                                          //   'ส่งทุกวัน': false,
                                                                                          //   'ส่งทุกวันอังคาร': true,
                                                                                          //   'ส่งทุกวันอาทิตย์': false,
                                                                                          //   'ส่งทุกวันจันทร์': true,
                                                                                          //   'ส่งทุกวันพฤหัสบดี': true,
                                                                                          //   'ส่งทุกวันศุกร์': true,
                                                                                          //   'ส่งทุกวันพุธ': true,
                                                                                          //   'ส่งทุกวันเสาร์': true,
                                                                                          // };

                                                                                          // List<String> daysOfWeek = [
                                                                                          //   'Sunday',
                                                                                          //   'Monday',
                                                                                          //   'Tuesday',
                                                                                          //   'Wednesday',
                                                                                          //   'Thursday',
                                                                                          //   'Friday',
                                                                                          //   'Saturday'
                                                                                          // ];
                                                                                          // int currentDayIndex = daysOfWeek.indexOf(currentDay);

                                                                                          // // วนลูปหาวันถัดไปที่เป็นจริงตาม A
                                                                                          // for (int i = currentDayIndex + 1; i < currentDayIndex + 8; i++) {
                                                                                          //   String nextDay = daysOfWeek[i % 7];
                                                                                          //   if (A['ส่งทุกวัน$nextDay'] == true) {
                                                                                          //     return DateTime.now().add(Duration(days: i - currentDayIndex));
                                                                                          //   }
                                                                                          // }
                                                                                        }
                                                                                      }

                                                                                      DateTime nextTrueDay = getNextTrueDay(orderList['วันเวลาจัดส่ง_day'])!;

                                                                                      print(nextTrueDay); // พิมพ์วันถัดไปที่เป็นจริงตาม A
                                                                                    }

                                                                                    setState(
                                                                                      () {
                                                                                        loadState = false;
                                                                                      },
                                                                                    );
                                                                                    return;
                                                                                  } else {
                                                                                    //========================= เลือกรูปแบบที่ 3 ============================================
                                                                                    newOrder.clear();
                                                                                    orderLoss.clear();
                                                                                    orderList['วันเวลาจัดส่ง'] = orderDateBefore;
                                                                                    orderList['วันเวลาจัดส่ง_day'] = orderDateBeforeDay;
                                                                                    orderList['วันเวลาจัดส่ง_string'] = orderDateBeforeString;
                                                                                    checkboxActiveList[0] = false;
                                                                                    checkboxActiveList[1] = false;

                                                                                    if (checkboxActiveList[2] == true) {
                                                                                      AwesomeDialog(
                                                                                        context: context,
                                                                                        dialogType: DialogType.warning,
                                                                                        animType: AnimType.scale,
                                                                                        title: 'การแจ้งเตือน',
                                                                                        desc: 'หากคุณเลือกเมนูนี้ สินค้าของแถมจะถูกคืนค่าใหม่ทั้งหมด',
                                                                                        // btnCancelOnPress: () {},
                                                                                        btnOkOnPress: () {},
                                                                                        dismissOnTouchOutside: false,
                                                                                        width: MediaQuery.of(context).size.width * 0.6,
                                                                                      )..show();
                                                                                    }

                                                                                    // newOrder =
                                                                                    //     orderList[
                                                                                    //         'ProductList'];

                                                                                    //  CONVERT_RATIO: 0.264, UNIT_BASE: กิโลกรัม, รายการนี้เกินสต๊อก: false}

                                                                                    // 'จำนวนสินค้าคงเหลือ\n ${(double.parse(stockAll[i].toString()) - double.parse(stockOrderAll[i].toString())).toStringAsFixed(2).toString()} ${orderList['ProductList'][i]['UNIT_BASE']}',
                                                                                    print('ตัวเลือก 3 Check 1');

                                                                                    for (int j = 0; j < orderList['ProductList'].length; j++) {
                                                                                      double stockAllItem = double.parse(stockAll[j]);
                                                                                      double stockOrderItem = double.parse(stockOrderAll[j]);

                                                                                      print('ตัวเลือก 3 Check 1.1');

                                                                                      if (stockOrderItem > stockAllItem) {
                                                                                        print('ตัวเลือก 3 Check 1.2');

                                                                                        if (orderList['ProductList'][j]['UNIT_BASE'] != orderList['ProductList'][j]['ยูนิต']) {
                                                                                          print('ตัวเลือก 3 Check 1.3');

                                                                                          double total = double.parse(stockAll[j].toString()) / double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          double totalLoss = 0.00;
                                                                                          if (total < 0.00) {
                                                                                            totalLoss = double.parse(stockOrderAll[j].toString()) / double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          } else {
                                                                                            totalLoss = total - double.parse(stockOrderAll[j].toString()) / double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          }
                                                                                          // double total = double.parse(orderList['ProductList'][j]['จำนวน'].toString()) * double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          print('===================================');
                                                                                          print(orderList['ProductList'][j]['จำนวน'].toString());
                                                                                          print(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          print(total);
                                                                                          print('===================================');
                                                                                          String loss = totalLoss.toStringAsFixed(0);
                                                                                          loss = loss.replaceAll('-', '');

                                                                                          orderList['ProductList'][j]['จำนวน'] = int.parse(total.toStringAsFixed(0).toString());
                                                                                          // orderList['ProductList'][j]['จำนวนสินค้าที่ไม่พอ'] = int.parse(totalLoss.toStringAsFixed(0).toString());
                                                                                          orderList['ProductList'][j]['จำนวนสินค้าที่ไม่พอ'] = int.parse(loss.toString());
                                                                                          productCount[j] = int.parse(total.toStringAsFixed(0).toString());
                                                                                          // stockOrderAll[j] = total.toStringAsFixed(0).toString();
                                                                                          print('ตัวเลือก 3 Check 1.4');
                                                                                        } else {
                                                                                          double total = double.parse(stockAll[j].toString()) / double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          double totalLoss = 0.00;
                                                                                          if (total < 0.00) {
                                                                                            totalLoss = double.parse(stockOrderAll[j].toString()) / double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          } else {
                                                                                            totalLoss = total - double.parse(stockOrderAll[j].toString()) / double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());
                                                                                          }
                                                                                          // double totalLoss = total - double.parse(stockOrderAll[j].toString()) / double.parse(orderList['ProductList'][j]['CONVERT_RATIO'].toString());

                                                                                          print('ตัวเลือก 3 Check 1.5');
                                                                                          String loss = totalLoss.toStringAsFixed(0);
                                                                                          loss = loss.replaceAll('-', '');

                                                                                          orderList['ProductList'][j]['จำนวน'] = int.parse(stockAllItem.toStringAsFixed(0).toString());
                                                                                          // orderList['ProductList'][j]['จำนวนสินค้าที่ไม่พอ'] = int.parse(totalLoss.toStringAsFixed(0).toString().replaceAll('-', ''));
                                                                                          orderList['ProductList'][j]['จำนวนสินค้าที่ไม่พอ'] = int.parse(loss.toString());

                                                                                          productCount[j] = int.parse(stockAllItem.toStringAsFixed(0).toString());
                                                                                          // stockOrderAll[j] = orderList['ProductList'][j]['จำนวน'].toString();
                                                                                          print('ตัวเลือก 3 Check 1.6');
                                                                                        }

                                                                                        print('ตัวเลือก 3 Check 1.7');
                                                                                        print(orderList['ProductList'][j]['จำนวน']);
                                                                                        print(orderList['ProductList'][j]['จำนวนสินค้าที่ไม่พอ']);
                                                                                      }

                                                                                      print('ตัวเลือก 3 Check 1.8');

                                                                                      // print(orderList['ProductList'][j]);
                                                                                      // print(stockAll[j].toString());
                                                                                      // print(stockOrderAll[j].toString());

                                                                                      // print(orderList['ProductList'][j]['CONVERT_RATIO']);
                                                                                      // print(orderList['ProductList'][j]['UNIT_BASE']);
                                                                                      // print(orderList['ProductList'][j]['ยูนิต']);
                                                                                      // print('------------------------');
                                                                                      // print(orderList['ProductList'][j]['จำนวน']);
                                                                                    }
                                                                                    // return;
                                                                                    print('ตัวเลือก 3 Check 2');
                                                                                    for (int j = 0; j < orderList['ProductList'].length; j++) {
                                                                                      newOrder.add(orderList['ProductList'][j]);
                                                                                      // newOrder.add({
                                                                                      //   'DocID': orderList['ProductList'][j]['DocID'],
                                                                                      //   'สถานะรายการนี้เป็นของแถม': orderList['ProductList'][j]['สถานะรายการนี้เป็นของแถม'],
                                                                                      //   'มีของแถม': orderList['ProductList'][j]['มีของแถม'],
                                                                                      //   'จำนวน': orderList['ProductList'][j]['จำนวน'],
                                                                                      //   'จำนวนของแถม': orderList['ProductList'][j]['จำนวนของแถม'],
                                                                                      //   'ไอดีของแถม': orderList['ProductList'][j]['ไอดีของแถม'],
                                                                                      //   'ProductID': orderList['ProductList'][j]['ProductID'],
                                                                                      //   'หน่วยของแถม': orderList['ProductList'][j]['หน่วยของแถม'],
                                                                                      //   'ชื่อสินค้า': orderList['ProductList'][j]['ชื่อสินค้า'],
                                                                                      //   'ชื่อของแถม': orderList['ProductList'][j]['ชื่อของแถม'],
                                                                                      //   'คำอธิบายสินค้า': orderList['ProductList'][j]['คำอธิบายสินค้า'],
                                                                                      //   'ยูนิต': orderList['ProductList'][j]['ยูนิต'],
                                                                                      //   'ราคา': orderList['ProductList'][j]['ราคา'],
                                                                                      //   'รายการนี้เกินสต๊อก': orderList['ProductList'][j]['รายการนี้เกินสต๊อก'],
                                                                                      //   // 'ส่วนลดรายการ': orderList['ProductList'][j]['ส่วนลดรายการ'],
                                                                                      //   'ส่วนลดรายการ': '0',
                                                                                      // });
                                                                                      orderLoss.add({
                                                                                        'DocID': orderList['ProductList'][j]['DocID'],
                                                                                        'สถานะรายการนี้เป็นของแถม': orderList['ProductList'][j]['สถานะรายการนี้เป็นของแถม'],
                                                                                        'มีของแถม': orderList['ProductList'][j]['มีของแถม'],
                                                                                        'จำนวน': orderList['ProductList'][j]['จำนวน'],
                                                                                        'จำนวนสินค้าที่ไม่พอ': orderList['ProductList'][j]['จำนวนสินค้าที่ไม่พอ'],
                                                                                        'จำนวนของแถม': orderList['ProductList'][j]['จำนวนของแถม'],
                                                                                        'ไอดีของแถม': orderList['ProductList'][j]['ไอดีของแถม'],
                                                                                        'ProductID': orderList['ProductList'][j]['ProductID'],
                                                                                        'หน่วยของแถม': orderList['ProductList'][j]['หน่วยของแถม'],
                                                                                        'ชื่อสินค้า': orderList['ProductList'][j]['ชื่อสินค้า'],
                                                                                        'ชื่อของแถม': orderList['ProductList'][j]['ชื่อของแถม'],
                                                                                        'คำอธิบายสินค้า': orderList['ProductList'][j]['คำอธิบายสินค้า'],
                                                                                        'ยูนิต': orderList['ProductList'][j]['ยูนิต'],
                                                                                        'ราคา': orderList['ProductList'][j]['ราคา'],
                                                                                        'รายการนี้เกินสต๊อก': orderList['ProductList'][j]['รายการนี้เกินสต๊อก']
                                                                                      });
                                                                                      print('ตัวเลือก 3 Check 2.3');

                                                                                      double aStrock = double.parse(stockAll[j]);
                                                                                      double bOrder = double.parse(stockOrderAll[j]);
                                                                                      // double bOrder = double.parse(orderList['ProductList'][j]['จำนวน'].toString());
                                                                                      print('ตัวเลือก 3 Check 2.4');

                                                                                      if (bOrder > aStrock) {
                                                                                        print('ตัวเลือก 3 Check 2.5');

                                                                                        if (aStrock < 0) {
                                                                                          print('ตัวเลือก 3 Check 2.6');
                                                                                          // print('เช็คจำนวนที่ขาด');
                                                                                          // print(orderLoss[j]['จำนวน']);

                                                                                          newOrder[j]['จำนวน'] = 0;
                                                                                          orderLoss[j]['จำนวน'] = 0;
                                                                                          print('ตัวเลือก 3 Check 2.7');
                                                                                        } else {
                                                                                          print('ตัวเลือก 3 Check 2.8');
                                                                                          // print('เช็คจำนวนที่ขาด');
                                                                                          // print(orderLoss[j]['จำนวน']);

                                                                                          // newOrder[j]['จำนวน'] = aStrock.round();
                                                                                          orderLoss[j]['จำนวน'] = aStrock.round();
                                                                                          print('ตัวเลือก 3 Check 2.9');
                                                                                        }
                                                                                        print('ตัวเลือก 3 Check 2.10');
                                                                                      }
                                                                                      print('ตัวเลือก 3 Check 2.11');

                                                                                      // print(orderList['ProductList'][j]);

                                                                                      // print(newOrder[j]);
                                                                                    }
                                                                                  }
                                                                                  print('ตัวเลือก 3 Check 3');

                                                                                  newOrder.removeWhere((element) => element['จำนวน'] == 0);
                                                                                  newOrder.removeWhere((element) => element['สถานะรายการนี้เป็นของแถม'] == true);

                                                                                  DocumentSnapshot customerDoc = await FirebaseFirestore.instance.collection(AppSettings.customerType == CustomerType.Test ? 'CustomerTest' : 'Customer').doc(widget.customerID).get();

                                                                                  Map<String, dynamic> data = customerDoc.data() as Map<String, dynamic>;

                                                                                  for (int i = 0; i < newOrder.length; i++) {
                                                                                    Map<String, dynamic>? foundmapRatio = productCovertRatio.firstWhere(
                                                                                      (element) => element!['PRODUCT_ID'] == newOrder[i]['ProductID'] && element['UNIT'] == newOrder[i]['ยูนิต'],
                                                                                      orElse: () => {},
                                                                                    );
                                                                                    if (foundmapRatio!['CONVERT_RATIO'] == null) {
                                                                                      checkConvertRatio = true;
                                                                                    }
                                                                                    newOrder[i]['CONVERT_RATIO'] = foundmapRatio!['CONVERT_RATIO'] ?? '0';
                                                                                    // ================================= เช็คโปร ============================
                                                                                    double price = double.parse(newOrder[i]['ราคา'].toString());
                                                                                    double total = double.parse(newOrder[i]['จำนวน'].toString());
                                                                                    double totalPrice = price * total;
                                                                                    DateTime dateTime = DateTime.now();
                                                                                    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                                                                                    HttpsCallable callableDiscount = FirebaseFunctions.instance.httpsCallable('getApiMfood');
                                                                                    print(newOrder[i]);
                                                                                    print('สินค้าที่ส่งไปเช็คโปรโมชั่น');
                                                                                    var paramsDiscount = <String, dynamic>{
                                                                                      "url": "http://mobile.mfood.co.th:7105/MBServices.asmx?op=SALES_ITEM_PROMOTION",
                                                                                      "xml":
                                                                                          //pro type discount
                                                                                          '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><SALES_ITEM_PROMOTION xmlns="MFOODMOBILEAPI"><Client_ID>${data['ClientIdจากMfoodAPI']}</Client_ID><ITEMCODE>${newOrder[i]['ProductID']}</ITEMCODE><UM>${newOrder[i]['ยูนิต']}</UM><QTY>${newOrder[i]['จำนวน']}</QTY><DOC_DATE>$formattedDate</DOC_DATE><ITEMAMT>$totalPrice</ITEMAMT></SALES_ITEM_PROMOTION></soap12:Body></soap12:Envelope>'
                                                                                    };
                                                                                    print(paramsDiscount['xml']);
                                                                                    await callableDiscount.call(paramsDiscount).then((value) async {
                                                                                      print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
                                                                                      if (value.data['status'] == 'success') {}
                                                                                      Xml2Json xml2json = Xml2Json();
                                                                                      xml2json.parse(value.data.toString());
                                                                                      jsonStringDiscount = xml2json.toOpenRally();
                                                                                      Map<String, dynamic> data = json.decode(jsonStringDiscount);
                                                                                      if (data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']['SALES_ITEM_PROMOTIONResult'] == 'true') {
                                                                                        newOrder[i]['ส่วนลดรายการ'] = '0.0';
                                                                                        newOrder[i]['สถานะรายการนี้เป็นของแถม'] = false;
                                                                                        newOrder[i]['ไอดีของแถม'] = '';
                                                                                        newOrder[i]['ชื่อของแถม'] = '';
                                                                                        newOrder[i]['จำนวนของแถม'] = '0';
                                                                                        newOrder[i]['หน่วยของแถม'] = '';
                                                                                        newOrder[i]['มีของแถม'] = false;
                                                                                      } else {
                                                                                        if (data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST'].runtimeType == List<dynamic>) {
                                                                                          for (int j = 0; j < data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST'].length; j++) {
                                                                                            Map<String, dynamic> sellPriceResponse = data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST'][j];
                                                                                            if (sellPriceResponse['PRODUCT_TYPE'] == 'ITEM DISCOUNT') {
                                                                                              double discount = double.parse(sellPriceResponse['DISCOUNT_UNIT']);
                                                                                              String totalPriceDiscount = discount.toStringAsFixed(2);
                                                                                              newOrder[i]['ส่วนลดรายการ'] = totalPriceDiscount;
                                                                                              newOrder[i]['สถานะรายการนี้เป็นของแถม'] = false;
                                                                                            } else if (sellPriceResponse['PRODUCT_TYPE'] == 'FREE') {
                                                                                              newOrder[i]['สถานะรายการนี้เป็นของแถม'] = false;
                                                                                              newOrder[i]['ไอดีของแถม'] = sellPriceResponse['FREE_ID'];
                                                                                              Map<String, dynamic> dataMap = resultList.firstWhere((product) => product['PRODUCT_ID'] == newOrder[i]['ไอดีของแถม']);
                                                                                              newOrder[i]['ชื่อของแถม'] = dataMap['NAMES'];
                                                                                              double discount = double.parse(sellPriceResponse['FREE_QTY']);
                                                                                              String totalPriceDiscount = discount.toStringAsFixed(0);
                                                                                              newOrder[i]['จำนวนของแถม'] = totalPriceDiscount;
                                                                                              newOrder[i]['หน่วยของแถม'] = sellPriceResponse['FREE_UNIT'];
                                                                                              newOrder[i]['มีของแถม'] = true;
                                                                                            } else {
                                                                                              newOrder[i]['ส่วนลดรายการ'] = '0.0';
                                                                                              newOrder[i]['สถานะรายการนี้เป็นของแถม'] = false;
                                                                                              newOrder[i]['ไอดีของแถม'] = '';
                                                                                              newOrder[i]['ชื่อของแถม'] = '';
                                                                                              newOrder[i]['จำนวนของแถม'] = '0';
                                                                                              newOrder[i]['หน่วยของแถม'] = '';
                                                                                              newOrder[i]['มีของแถม'] = false;
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          Map<String, dynamic> sellPriceResponse = data['Envelope']['Body']['SALES_ITEM_PROMOTIONResponse']['SALES_ITEM_PROMOTIONResult']['SALESPROMOTION_LIST'];
                                                                                          if (sellPriceResponse['PRODUCT_TYPE'] == 'ITEM DISCOUNT') {
                                                                                            double discount = double.parse(sellPriceResponse['DISCOUNT_UNIT']);
                                                                                            String totalPriceDiscount = discount.toStringAsFixed(2);
                                                                                            newOrder[i]['ส่วนลดรายการ'] = totalPriceDiscount;
                                                                                            newOrder[i]['สถานะรายการนี้เป็นของแถม'] = false;
                                                                                            newOrder[i]['ไอดีของแถม'] = '';
                                                                                            newOrder[i]['ชื่อของแถม'] = '';
                                                                                            newOrder[i]['จำนวนของแถม'] = '0';
                                                                                            newOrder[i]['หน่วยของแถม'] = '';
                                                                                            newOrder[i]['มีของแถม'] = false;
                                                                                          } else if (sellPriceResponse['PRODUCT_TYPE'] == 'FREE') {
                                                                                            newOrder[i]['ส่วนลดรายการ'] = '0.0';
                                                                                            newOrder[i]['สถานะรายการนี้เป็นของแถม'] = false;
                                                                                            newOrder[i]['ไอดีของแถม'] = sellPriceResponse['FREE_ID'];
                                                                                            Map<String, dynamic> dataMap = resultList.firstWhere((product) => product['PRODUCT_ID'] == newOrder[i]['ไอดีของแถม']);
                                                                                            newOrder[i]['ชื่อของแถม'] = dataMap['NAMES'];
                                                                                            double discount = double.parse(sellPriceResponse['FREE_QTY']);
                                                                                            String totalPriceDiscount = discount.toStringAsFixed(0);
                                                                                            newOrder[i]['จำนวนของแถม'] = totalPriceDiscount;
                                                                                            newOrder[i]['หน่วยของแถม'] = sellPriceResponse['FREE_UNIT'];
                                                                                            newOrder[i]['มีของแถม'] = true;
                                                                                          } else {
                                                                                            newOrder[i]['ส่วนลดรายการ'] = '0.0';
                                                                                            newOrder[i]['สถานะรายการนี้เป็นของแถม'] = false;
                                                                                            newOrder[i]['ไอดีของแถม'] = '';
                                                                                            newOrder[i]['ชื่อของแถม'] = '';
                                                                                            newOrder[i]['จำนวนของแถม'] = '0';
                                                                                            newOrder[i]['หน่วยของแถม'] = '';
                                                                                            newOrder[i]['มีของแถม'] = false;
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                      double totalPriceDiscountDouble = 0.0;
                                                                                      totalPriceDiscountDouble = totalPriceDiscountDouble + double.parse(newOrder[i]['ส่วนลดรายการ'].toString());
                                                                                      String totalPriceDiscountDoubleString = totalPriceDiscountDouble.toStringAsFixed(2);
                                                                                      String totalPriceDiscount = '';
                                                                                      totalPriceDiscount = totalPriceDiscountDoubleString;
                                                                                      orderList['ยอดรวมส่วนลดทั้งหมด'] = totalPriceDiscount;
                                                                                    }).whenComplete(() async {});
                                                                                    print(newOrder[i]);
                                                                                    print('====================== รายการใหม่ =======================');
                                                                                  }
                                                                                  for (int i = 0; i < newOrder.length; i++) {
                                                                                    if (newOrder[i]['มีของแถม'] == true) {
                                                                                      Map<String, dynamic> dataMap1 = newOrder[i];
                                                                                      Map<String, dynamic>? foundMap = resultList.firstWhere((element) => element['PRODUCT_ID'] == dataMap1['ไอดีของแถม']);
                                                                                      Map<String, dynamic> dataMapBonus = {};
                                                                                      dataMapBonus['DocID'] = foundMap['DocId'];
                                                                                      dataMapBonus['สถานะรายการนี้เป็นของแถม'] = true;
                                                                                      dataMapBonus['มีของแถม'] = false;
                                                                                      dataMapBonus['จำนวน'] = int.parse(dataMap1['จำนวนของแถม']);
                                                                                      dataMapBonus['จำนวนของแถม'] = '';
                                                                                      dataMapBonus['ไอดีของแถม'] = '';
                                                                                      dataMapBonus['ProductID'] = foundMap['PRODUCT_ID'];
                                                                                      dataMapBonus['หน่วยของแถม'] = '';
                                                                                      dataMapBonus['ชื่อสินค้า'] = foundMap['NAMES'];
                                                                                      dataMapBonus['ชื่อของแถม'] = '';
                                                                                      dataMapBonus['คำอธิบายสินค้า'] = foundMap['รายละเอียด'] == '' ? '' : foundMap['รายละเอียด'];
                                                                                      dataMapBonus['ยูนิต'] = dataMap1['หน่วยของแถม'];
                                                                                      dataMapBonus['ราคา'] = '0';
                                                                                      dataMapBonus['ส่วนลดรายการ'] = '0.0';
                                                                                      newOrder.add(dataMapBonus);
                                                                                      productCount.add(int.parse(dataMap1['จำนวนของแถม']));
                                                                                    }
                                                                                  }
                                                                                  print('ตัวเลือก 3 Check 3.1 ====================================================');
                                                                                  for (int i = 0; i < orderLoss.length; i++) {
                                                                                    orderLoss[i]['จำนวน'] = orderLoss[i]['จำนวนสินค้าที่ไม่พอ'];
                                                                                    print('จำนวนสินค้าที่ไม่พอ');
                                                                                    print(orderLoss[i]['จำนวน']);
                                                                                  }
                                                                                  orderLoss.removeWhere((element) => element['จำนวนสินค้าที่ไม่พอ'] == 0);
                                                                                  print('ตัวเลือก 3 Check 3.2');
                                                                                  print(newOrder.length);
                                                                                  print(newOrder.length);
                                                                                  print(newOrder.length);
                                                                                  print(newOrder.length);
                                                                                  print(newOrder.length);

                                                                                  // for (int i = 0; i < orderList['ProductList'].length; i++) {
                                                                                  //   print(orderList['ProductList'][i]['ชื่อสินค้า']);
                                                                                  //   print(orderList['ProductList'][i]['จำนวน']);
                                                                                  //   print(orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม']);
                                                                                  // }

                                                                                  setState(
                                                                                    () {
                                                                                      print('---- + ----');
                                                                                      print(newOrder);
                                                                                      print('---- + ----');
                                                                                    },
                                                                                  );
                                                                                },
                                                                        ),
                                                                        Text(
                                                                          checkBoxString[
                                                                              i],
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily: 'Kanit',
                                                                                color: (i == 0 || i == 2) && productPreAll ? Colors.black.withOpacity(0.2) : Colors.black,
                                                                                fontSize: 16.0,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  SizedBox(
                                                                    height: 50,
                                                                  ),
                                                                  checkboxActiveList[0] == false &&
                                                                          checkboxActiveList[1] ==
                                                                              false &&
                                                                          checkboxActiveList[2] ==
                                                                              false
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 90,
                                                                              child: ElevatedButton(
                                                                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                                                                                  onPressed: () {
                                                                                    orderList['ProductList'].removeWhere((element) => element['สถานะรายการนี้เป็นของแถม'] == true);
                                                                                    newOrder = [];
                                                                                    orderLoss = [];
                                                                                    backDialog = true;
                                                                                    // statusOrderPass = true;

                                                                                    setState(
                                                                                      () {},
                                                                                    );
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'ยกเลิก',
                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                          fontFamily: 'Kanit',
                                                                                          color: Colors.black,
                                                                                          fontSize: 12.0,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Text(
                                                                          'สรุปออเดอร์ใหม่',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily: 'Kanit',
                                                                                color: Colors.black,
                                                                                fontSize: 18.0,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                        ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  checkboxActiveList[
                                                                          0]
                                                                      ? Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(),
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          width:
                                                                              double.infinity,
                                                                          // height:
                                                                          //     600,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 50,
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 90,
                                                                                    child: ElevatedButton(
                                                                                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                                                                                        onPressed: () {
                                                                                          orderList['ProductList'].removeWhere((element) => element['สถานะรายการนี้เป็นของแถม'] == true);
                                                                                          newOrder = [];
                                                                                          orderLoss = [];
                                                                                          backDialog = true;
                                                                                          // statusOrderPass = true;

                                                                                          setState(
                                                                                            () {},
                                                                                          );
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          'ยกเลิก',
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: 'Kanit',
                                                                                                color: Colors.black,
                                                                                                fontSize: 12.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                        )),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 90,
                                                                                    child: ElevatedButton(
                                                                                        onPressed: () async {
                                                                                          //====================== อัพเดทสินค้าที่เคยสั่งของพนักงานคนนั้น ==========================
                                                                                          setState(() {
                                                                                            isLoading2 = true;
                                                                                          });
                                                                                          String orderID = DateTime.now().toString();

                                                                                          List<dynamic> listHistory = userData!['สินค้าที่เคยสั่ง'];
                                                                                          List<String> listHistoryString = [];

                                                                                          for (int i = 0; i < listHistory.length; i++) {
                                                                                            listHistoryString.add(listHistory[i].toString());
                                                                                          }
                                                                                          for (int i = 0; i < orderList['ProductList'].length; i++) {
                                                                                            bool isStringFound = listHistoryString.any((map) => map == orderList['ProductList'][i]['ProductID']);

                                                                                            if (isStringFound) {
                                                                                            } else {
                                                                                              listHistoryString.add(orderList['ProductList'][i]['ProductID'].toString());
                                                                                            }
                                                                                          }

                                                                                          List<dynamic> listHistoryDate = userData!['สินค้าที่เคยสั่ง_วันที่'];
                                                                                          List<DateTime?>? listHistoryStringDate = [];

                                                                                          for (int i = 0; i < listHistoryDate.length; i++) {
                                                                                            // print(listHistoryDate[i]);
                                                                                            Timestamp timestamp = listHistoryDate[i];
                                                                                            DateTime dateTime = timestamp.toDate();
                                                                                            // print(dateTime);

                                                                                            listHistoryStringDate.add(dateTime);
                                                                                          }

                                                                                          for (int i = listHistoryStringDate.length; i < listHistoryString.length; i++) {
                                                                                            listHistoryStringDate.add(DateTime.now());
                                                                                          }

                                                                                          print(listHistoryString);
                                                                                          print(listHistoryStringDate);
                                                                                          List<Timestamp> listTimestamp = [];

                                                                                          for (int i = 0; i < listHistoryStringDate.length; i++) {
                                                                                            Timestamp timestamp = Timestamp.fromDate(listHistoryStringDate[i]!);
                                                                                            listTimestamp.add(timestamp);
                                                                                          }

                                                                                          userData!['สินค้าที่เคยสั่ง'] = listHistoryString;

                                                                                          userData!['สินค้าที่เคยสั่ง_วันที่'] = listTimestamp;

                                                                                          List<Map<String, dynamic>?>? listProductReal = [];

                                                                                          for (var element in orderList['ProductList']) {
                                                                                            // print(element['ProductID']);

                                                                                            Map<String, dynamic>? foundMap = resultList.firstWhere(
                                                                                              (map) => map['PRODUCT_ID'] == element['ProductID'],
                                                                                              orElse: () => {},
                                                                                            );

                                                                                            listProductReal.add(foundMap);
                                                                                          }
                                                                                          print('listProductReal');
                                                                                          print(listProductReal);

                                                                                          await FirebaseFirestore.instance.collection('User').doc(userData!['UserID']).update(
                                                                                            {
                                                                                              'สินค้าที่เคยสั่ง': listHistoryString,
                                                                                              'สินค้าที่เคยสั่ง_วันที่': listHistoryStringDate,
                                                                                            },
                                                                                          ).then((value) {
                                                                                            // if (mounted) {
                                                                                            // setState(() {});
                                                                                            // }
                                                                                          });
                                                                                          // ====================== เพิ่ม ประวัติออเดอร์วันนี้ ==========================
                                                                                          List<dynamic> listOrderCustomerIDToday = [];

                                                                                          List<dynamic> listOrderToday = [];
                                                                                          List<dynamic> listOrderToday_date = [];

                                                                                          if (userData!['ออเดอร์วันนี้'] == null) {
                                                                                            listOrderToday = [];
                                                                                          } else {
                                                                                            listOrderToday = userData!['ออเดอร์วันนี้'];
                                                                                          }

                                                                                          if (userData!['ออเดอร์วันนี้_วันที่'] == null) {
                                                                                          } else {
                                                                                            listOrderToday_date = userData!['ออเดอร์วันนี้_วันที่'];
                                                                                          }

                                                                                          if (userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] == null) {
                                                                                          } else {
                                                                                            listOrderCustomerIDToday = userData!['ออเดอร์วันนี้_ไอดีลูกค้า'];
                                                                                          }

                                                                                          for (int i = 0; i < listOrderToday_date.length; i++) {
                                                                                            Timestamp timestamp = listOrderToday_date[i];
                                                                                            DateTime dateTime = timestamp.toDate();

                                                                                            DateTime now = DateTime.now();

                                                                                            if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
                                                                                            } else {
                                                                                              listOrderToday.removeAt(i);
                                                                                              listOrderToday_date.removeAt(i);
                                                                                              listOrderCustomerIDToday.remove(i);
                                                                                            }
                                                                                          }

                                                                                          Timestamp timestamp = Timestamp.fromDate(DateTime.now());

                                                                                          listOrderCustomerIDToday.add(widget.customerID);

                                                                                          listOrderToday.add(orderID);

                                                                                          listOrderToday_date.add(timestamp);

                                                                                          userData!['ออเดอร์วันนี้'] = listOrderToday;

                                                                                          userData!['ออเดอร์วันนี้_วันที่'] = listOrderToday_date;

                                                                                          userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] = listOrderCustomerIDToday;

                                                                                          await FirebaseFirestore.instance.collection('User').doc(userData!['UserID']).update(
                                                                                            {
                                                                                              'ออเดอร์วันนี้_ไอดีลูกค้า': listOrderCustomerIDToday,
                                                                                              'ออเดอร์วันนี้': listOrderToday,
                                                                                              'ออเดอร์วันนี้_วันที่': listOrderToday_date,
                                                                                            },
                                                                                          ).then((value) {
                                                                                            // if (mounted) {
                                                                                            // setState(() {});
                                                                                            // }
                                                                                          });

                                                                                          // ====================== เพิ่ม ออเดอร์ของลูกค้า ==========================

                                                                                          // กำหนดรูปแบบของวันที่
                                                                                          DateFormat dateFormat = DateFormat('dd-MM-yyyy');

                                                                                          // แปลงสตริงเป็น DateTime
                                                                                          DateTime? dateTime;
                                                                                          if (orderList['วันเวลาจัดส่ง'] == '') {
                                                                                          } else {
                                                                                            dateTime = dateFormat.parse(orderList['วันเวลาจัดส่ง']);
                                                                                          }

                                                                                          await FirebaseFirestore.instance.collection(AppSettings.customerType == CustomerType.Test ? 'CustomerTest' : 'Customer').doc(widget.customerID).collection('Orders').doc(orderID).set({
                                                                                            'OrdersDateID': orderID,
                                                                                            'OrdersUpdateTime': DateTime.now(),
                                                                                            'สถานที่จัดส่ง': orderList['สถานที่จัดส่ง'],
                                                                                            'วันเวลาจัดส่ง': orderList['วันเวลาจัดส่ง'] == '' ? '' : dateTime,
                                                                                            'สายส่ง': orderList['สายส่ง'],
                                                                                            'สายส่งโค้ด': orderList['สายส่งโค้ด'],
                                                                                            'สายส่งไอดี': orderList['สายส่งไอดี'],
                                                                                            'ProductList': orderList['ProductList'],
                                                                                            'ยอดรวม': orderList['ยอดรวม'],
                                                                                            'ส่วนลด': orderList['ส่วนลด'],
                                                                                            'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม': orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'],
                                                                                            'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม': orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'],
                                                                                            'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม': orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'],
                                                                                            'ภาษีมูลค่าเพิ่ม': orderList['ภาษีมูลค่าเพิ่ม'],
                                                                                            'มูลค่าสินค้ารวม': orderList['มูลค่าสินค้ารวม'],
                                                                                            'วันเวลาจัดส่ง_string': orderList['วันเวลาจัดส่ง'] == '' ? '' : dateTime.toString(),
                                                                                            'วันเวลาจัดส่ง_day': orderList['วันเวลาจัดส่ง_day'],
                                                                                            'ListCustomerAddressID': orderList['ListCustomerAddressID'] == 'ตัวเลือก' ? '' : orderList['ListCustomerAddressID'],
                                                                                            'ตารางราคา': orderList['ตารางราคา'] == 'ตัวเลือก' ? '' : orderList['ตารางราคา'],
                                                                                            'ค้างชำระ': 0,
                                                                                            'สถานะเอกสาร': false,
                                                                                            'สถานะอนุมัติขาย': false,
                                                                                            'รอตรวจการอนุมัติ': true,
                                                                                            'ProductListDocument': listProductReal,
                                                                                            'สถานะเช็คสต็อก': 'splitออร์เดอร์',
                                                                                            'PO': textController1.text.trim(),
                                                                                            'หมายเหตุ': textController2.text,
                                                                                          }).whenComplete(() async {
                                                                                            HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('apiConfirmOrder');
                                                                                            var params = <String, dynamic>{
                                                                                              "MODE": AppSettings.customerType == CustomerType.Test ? "TEST" : "REAL",
                                                                                              "CustomerDocId": widget.customerID,
                                                                                              "OrdersDateID": orderID,
                                                                                              "UserDocId": userData!['EmployeeID'],
                                                                                              "สถานะค้างชำระ": false,
                                                                                              "รอตรวจการอนุมัติ": true,
                                                                                              "สถานะอนุมัติขาย": false,
                                                                                              "ค้างชำระ": 0
                                                                                            };

                                                                                            print('======================================= aaaaa');

                                                                                            await callable.call(params).then((value) {
                                                                                              print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
                                                                                              if (value.data['status'] == 'success') {
                                                                                                var response = value.data['data'];
                                                                                              }
                                                                                            }).whenComplete(() {
                                                                                              if (mounted) {
                                                                                                setState(() {
                                                                                                  isLoading2 = false;
                                                                                                  Navigator.pop(contextIN);
                                                                                                  // Navigator.pop(context);
                                                                                                  // Navigator.pop(context);
                                                                                                  // Navigator.pop(context);
                                                                                                  // Navigator.pop(context);
                                                                                                });
                                                                                              }
                                                                                            });

                                                                                            // Navigator.push(
                                                                                            //     context,
                                                                                            //     CupertinoPageRoute(
                                                                                            //       builder: (context) =>
                                                                                            //           A0905SuccessOrderProduct(),
                                                                                            //     ));
                                                                                          });
                                                                                        },
                                                                                        child: isLoading2
                                                                                            ? CircularProgressIndicator()
                                                                                            : Text(
                                                                                                'ตกลง',
                                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                      fontFamily: 'Kanit',
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 12.0,
                                                                                                      fontWeight: FontWeight.normal,
                                                                                                    ),
                                                                                              )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 50,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : SizedBox(),

                                                                  checkboxActiveList[
                                                                          1]
                                                                      ? loadState
                                                                          ? Center(
                                                                              child: CircularProgressIndicator())
                                                                          : Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(),
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: Colors.white,
                                                                              ),
                                                                              width: double.infinity,
                                                                              // height: 600,
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 50,
                                                                                  ),
                                                                                  Text(
                                                                                    // 'ออเดอร์สินค้านี้จะถูกเลื่อนวันส่งไปยังวันที่',
                                                                                    'ออเดอร์สินค้านี้จะสั่งสินค้าทุกจำนวน',

                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                          fontFamily: 'Kanit',
                                                                                          color: Colors.black,
                                                                                          fontSize: 18.0,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                  ),
                                                                                  // Row(
                                                                                  //   children: [
                                                                                  //     Text(
                                                                                  //       'วันเวลาจัดส่งเดิม',
                                                                                  //       style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                  //             fontFamily: 'Kanit',
                                                                                  //             color: Colors.black,
                                                                                  //             fontSize: 12.0,
                                                                                  //             fontWeight: FontWeight.normal,
                                                                                  //           ),
                                                                                  //     ),
                                                                                  //     Text(
                                                                                  //       orderList['วันเวลาจัดส่ง'],
                                                                                  //       style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                  //             fontFamily: 'Kanit',
                                                                                  //             color: Colors.black,
                                                                                  //             fontSize: 12.0,
                                                                                  //             fontWeight: FontWeight.normal,
                                                                                  //           ),
                                                                                  //     ),
                                                                                  //   ],
                                                                                  // ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        // 'วันเวลาจัดส่งใหม่',
                                                                                        'วันเวลาจัดส่ง',
                                                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                              fontFamily: 'Kanit',
                                                                                              color: Colors.black,
                                                                                              fontSize: 16.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                            ),
                                                                                      ),
                                                                                      Text(
                                                                                        'วันที่ ${orderList['วันเวลาจัดส่ง']}',
                                                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                              fontFamily: 'Kanit',
                                                                                              color: Colors.black,
                                                                                              fontSize: 16.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                            ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 50,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 90,
                                                                                        child: ElevatedButton(
                                                                                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                                                                                            onPressed: () {
                                                                                              orderList['ProductList'].removeWhere((element) => element['สถานะรายการนี้เป็นของแถม'] == true);
                                                                                              newOrder = [];
                                                                                              orderLoss = [];
                                                                                              backDialog = true;
                                                                                              // statusOrderPass = true;

                                                                                              setState(
                                                                                                () {},
                                                                                              );
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Text(
                                                                                              'ยกเลิก',
                                                                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                    fontFamily: 'Kanit',
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 12.0,
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                  ),
                                                                                            )),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 90,
                                                                                        child: ElevatedButton(
                                                                                            onPressed: () async {
                                                                                              //====================== อัพเดทสินค้าที่เคยสั่งของพนักงานคนนั้น ==========================
                                                                                              setState(() {
                                                                                                isLoading2 = true;
                                                                                              });
                                                                                              String orderID = DateTime.now().toString();

                                                                                              List<dynamic> listHistory = userData!['สินค้าที่เคยสั่ง'];
                                                                                              List<String> listHistoryString = [];

                                                                                              for (int i = 0; i < listHistory.length; i++) {
                                                                                                listHistoryString.add(listHistory[i].toString());
                                                                                              }
                                                                                              for (int i = 0; i < orderList['ProductList'].length; i++) {
                                                                                                bool isStringFound = listHistoryString.any((map) => map == orderList['ProductList'][i]['ProductID']);

                                                                                                if (isStringFound) {
                                                                                                } else {
                                                                                                  listHistoryString.add(orderList['ProductList'][i]['ProductID'].toString());
                                                                                                }
                                                                                              }

                                                                                              List<dynamic> listHistoryDate = userData!['สินค้าที่เคยสั่ง_วันที่'];
                                                                                              List<DateTime?>? listHistoryStringDate = [];

                                                                                              for (int i = 0; i < listHistoryDate.length; i++) {
                                                                                                // print(listHistoryDate[i]);
                                                                                                Timestamp timestamp = listHistoryDate[i];
                                                                                                DateTime dateTime = timestamp.toDate();
                                                                                                // print(dateTime);

                                                                                                listHistoryStringDate.add(dateTime);
                                                                                              }

                                                                                              for (int i = listHistoryStringDate.length; i < listHistoryString.length; i++) {
                                                                                                listHistoryStringDate.add(DateTime.now());
                                                                                              }

                                                                                              print(listHistoryString);
                                                                                              print(listHistoryStringDate);
                                                                                              List<Timestamp> listTimestamp = [];

                                                                                              for (int i = 0; i < listHistoryStringDate.length; i++) {
                                                                                                Timestamp timestamp = Timestamp.fromDate(listHistoryStringDate[i]!);
                                                                                                listTimestamp.add(timestamp);
                                                                                              }

                                                                                              userData!['สินค้าที่เคยสั่ง'] = listHistoryString;

                                                                                              userData!['สินค้าที่เคยสั่ง_วันที่'] = listTimestamp;

                                                                                              List<Map<String, dynamic>?>? listProductReal = [];

                                                                                              for (var element in orderList['ProductList']) {
                                                                                                // print(element['ProductID']);

                                                                                                Map<String, dynamic>? foundMap = resultList.firstWhere(
                                                                                                  (map) => map['PRODUCT_ID'] == element['ProductID'],
                                                                                                  orElse: () => {},
                                                                                                );

                                                                                                listProductReal.add(foundMap);
                                                                                              }
                                                                                              print('listProductReal');
                                                                                              print(listProductReal);

                                                                                              await FirebaseFirestore.instance.collection('User').doc(userData!['UserID']).update(
                                                                                                {
                                                                                                  'สินค้าที่เคยสั่ง': listHistoryString,
                                                                                                  'สินค้าที่เคยสั่ง_วันที่': listHistoryStringDate,
                                                                                                },
                                                                                              ).then((value) {
                                                                                                // if (mounted) {
                                                                                                // setState(() {});
                                                                                                // }
                                                                                              });

                                                                                              // ====================== เพิ่ม ประวัติออเดอร์วันนี้ ==========================
                                                                                              List<dynamic> listOrderCustomerIDToday = [];

                                                                                              List<dynamic> listOrderToday = [];
                                                                                              List<dynamic> listOrderToday_date = [];

                                                                                              if (userData!['ออเดอร์วันนี้'] == null) {
                                                                                                listOrderToday = [];
                                                                                              } else {
                                                                                                listOrderToday = userData!['ออเดอร์วันนี้'];
                                                                                              }

                                                                                              if (userData!['ออเดอร์วันนี้_วันที่'] == null) {
                                                                                              } else {
                                                                                                listOrderToday_date = userData!['ออเดอร์วันนี้_วันที่'];
                                                                                              }

                                                                                              if (userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] == null) {
                                                                                              } else {
                                                                                                listOrderCustomerIDToday = userData!['ออเดอร์วันนี้_ไอดีลูกค้า'];
                                                                                              }

                                                                                              for (int i = 0; i < listOrderToday_date.length; i++) {
                                                                                                Timestamp timestamp = listOrderToday_date[i];
                                                                                                DateTime dateTime = timestamp.toDate();

                                                                                                DateTime now = DateTime.now();

                                                                                                if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
                                                                                                } else {
                                                                                                  listOrderToday.removeAt(i);
                                                                                                  listOrderToday_date.removeAt(i);
                                                                                                  listOrderCustomerIDToday.remove(i);
                                                                                                }
                                                                                              }

                                                                                              Timestamp timestamp = Timestamp.fromDate(DateTime.now());

                                                                                              listOrderCustomerIDToday.add(widget.customerID);

                                                                                              listOrderToday.add(orderID);

                                                                                              listOrderToday_date.add(timestamp);

                                                                                              userData!['ออเดอร์วันนี้'] = listOrderToday;

                                                                                              userData!['ออเดอร์วันนี้_วันที่'] = listOrderToday_date;

                                                                                              userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] = listOrderCustomerIDToday;

                                                                                              await FirebaseFirestore.instance.collection('User').doc(userData!['UserID']).update(
                                                                                                {
                                                                                                  'ออเดอร์วันนี้_ไอดีลูกค้า': listOrderCustomerIDToday,
                                                                                                  'ออเดอร์วันนี้': listOrderToday,
                                                                                                  'ออเดอร์วันนี้_วันที่': listOrderToday_date,
                                                                                                },
                                                                                              ).then((value) {
                                                                                                // if (mounted) {
                                                                                                // setState(() {});
                                                                                                // }
                                                                                              });

                                                                                              // ====================== เพิ่ม ออเดอร์ของลูกค้า ==========================

                                                                                              // กำหนดรูปแบบของวันที่
                                                                                              DateFormat dateFormat = DateFormat('dd-MM-yyyy');

                                                                                              // แปลงสตริงเป็น DateTime
                                                                                              DateTime? dateTime;
                                                                                              if (orderList['วันเวลาจัดส่ง'] == '') {
                                                                                              } else {
                                                                                                dateTime = dateFormat.parse(orderList['วันเวลาจัดส่ง']);
                                                                                              }

                                                                                              await FirebaseFirestore.instance.collection(AppSettings.customerType == CustomerType.Test ? 'CustomerTest' : 'Customer').doc(widget.customerID).collection('Orders').doc(orderID).set({
                                                                                                'OrdersDateID': orderID,
                                                                                                'OrdersUpdateTime': DateTime.now(),
                                                                                                'สถานที่จัดส่ง': orderList['สถานที่จัดส่ง'],
                                                                                                'วันเวลาจัดส่ง': orderList['วันเวลาจัดส่ง'] == '' ? '' : dateTime,
                                                                                                'สายส่ง': orderList['สายส่ง'],
                                                                                                'สายส่งโค้ด': orderList['สายส่งโค้ด'],
                                                                                                'สายส่งไอดี': orderList['สายส่งไอดี'],
                                                                                                'ProductList': orderList['ProductList'],
                                                                                                'ยอดรวม': orderList['ยอดรวม'],
                                                                                                'ส่วนลด': orderList['ส่วนลด'],
                                                                                                'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม': orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'],
                                                                                                'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม': orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'],
                                                                                                'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม': orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'],
                                                                                                'ภาษีมูลค่าเพิ่ม': orderList['ภาษีมูลค่าเพิ่ม'],
                                                                                                'มูลค่าสินค้ารวม': orderList['มูลค่าสินค้ารวม'],
                                                                                                'วันเวลาจัดส่ง_string': orderList['วันเวลาจัดส่ง'] == '' ? '' : dateTime.toString(),
                                                                                                'วันเวลาจัดส่ง_day': orderList['วันเวลาจัดส่ง_day'],
                                                                                                'ListCustomerAddressID': orderList['ListCustomerAddressID'] == 'ตัวเลือก' ? '' : orderList['ListCustomerAddressID'],
                                                                                                'ตารางราคา': orderList['ตารางราคา'] == 'ตัวเลือก' ? '' : orderList['ตารางราคา'],
                                                                                                'ค้างชำระ': 0,
                                                                                                'สถานะเอกสาร': false,
                                                                                                'สถานะอนุมัติขาย': false,
                                                                                                'รอตรวจการอนุมัติ': true,
                                                                                                'ProductListDocument': listProductReal,
                                                                                                'สถานะเช็คสต็อก': 'ยกทั้งตระกร้า',
                                                                                                'PO': textController1.text.trim(),
                                                                                                'หมายเหตุ': textController2.text,
                                                                                              }).whenComplete(() async {
                                                                                                HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('apiConfirmOrder');
                                                                                                var params = <String, dynamic>{
                                                                                                  "MODE": AppSettings.customerType == CustomerType.Test ? "TEST" : "REAL",
                                                                                                  "CustomerDocId": widget.customerID,
                                                                                                  "OrdersDateID": orderID,
                                                                                                  "UserDocId": userData!['EmployeeID'],
                                                                                                  "สถานะค้างชำระ": false,
                                                                                                  "รอตรวจการอนุมัติ": true,
                                                                                                  "สถานะอนุมัติขาย": false,
                                                                                                  "ค้างชำระ": 0
                                                                                                };

                                                                                                print('======================================= aaaaa');

                                                                                                await callable.call(params).then((value) {
                                                                                                  print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
                                                                                                  if (value.data['status'] == 'success') {
                                                                                                    var response = value.data['data'];
                                                                                                  }
                                                                                                }).whenComplete(() {
                                                                                                  if (mounted) {
                                                                                                    setState(() {
                                                                                                      isLoading2 = false;
                                                                                                      Navigator.pop(contextIN);
                                                                                                      // Navigator.pop(context);
                                                                                                      // Navigator.pop(context);
                                                                                                      // Navigator.pop(context);
                                                                                                      // Navigator.pop(context);
                                                                                                    });
                                                                                                  }
                                                                                                });

                                                                                                // Navigator.push(
                                                                                                //     context,
                                                                                                //     CupertinoPageRoute(
                                                                                                //       builder: (context) =>
                                                                                                //           A0905SuccessOrderProduct(),
                                                                                                //     ));
                                                                                              });
                                                                                            },
                                                                                            child: isLoading2
                                                                                                ? CircularProgressIndicator()
                                                                                                : Text(
                                                                                                    'ตกลง',
                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                          fontFamily: 'Kanit',
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 12.0,
                                                                                                          fontWeight: FontWeight.normal,
                                                                                                        ),
                                                                                                  )),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 50,
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                      : SizedBox(),
                                                                  checkboxActiveList[
                                                                          2]
                                                                      ? newOrder
                                                                              .isEmpty
                                                                          ? Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(),
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: Colors.white,
                                                                              ),
                                                                              alignment: Alignment.topCenter,
                                                                              width: double.infinity,
                                                                              // height: 600,
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    'ออเดอร์นี้ ไม่มีสินค้าที่สั่งได้ตามเงื่อนไข',
                                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                          fontFamily: 'Kanit',
                                                                                          color: Colors.red,
                                                                                          fontSize: 18.0,
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 50,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 90,
                                                                                    child: ElevatedButton(
                                                                                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                                                                                        onPressed: () {
                                                                                          orderList['ProductList'].removeWhere((element) => element['สถานะรายการนี้เป็นของแถม'] == true);
                                                                                          newOrder = [];
                                                                                          orderLoss = [];
                                                                                          backDialog = true;
                                                                                          // statusOrderPass = true;

                                                                                          setState(
                                                                                            () {},
                                                                                          );
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          'ยกเลิก',
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: 'Kanit',
                                                                                                color: Colors.black,
                                                                                                fontSize: 12.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                        )),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 50,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
                                                                              width: double.infinity,
                                                                              // height: 600,
                                                                              child: Column(
                                                                                children: [
                                                                                  // Text(
                                                                                  //   'สรุปออเดอร์',
                                                                                  //   style: FlutterFlowTheme.of(
                                                                                  //           context)
                                                                                  //       .bodyLarge
                                                                                  //       .override(
                                                                                  //         fontFamily:
                                                                                  //             'Kanit',
                                                                                  //         color:
                                                                                  //             Colors.black,
                                                                                  //         fontSize:
                                                                                  //             18.0,
                                                                                  //         fontWeight:
                                                                                  //             FontWeight.normal,
                                                                                  //       ),
                                                                                  // ),
                                                                                  for (int i = 0; i < newOrder.length; i++)
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                                                      child: Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            flex: 3,
                                                                                            child: Text(
                                                                                              '${newOrder[i]['ชื่อสินค้า']}',
                                                                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                    fontFamily: 'Kanit',
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 12.0,
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'จำนวน ${newOrder[i]['จำนวน']} ${newOrder[i]['ยูนิต']}',
                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                        fontFamily: 'Kanit',
                                                                                                        color: Colors.black,
                                                                                                        fontSize: 12.0,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                      ),
                                                                                                ),
                                                                                                // Text(
                                                                                                //   'จำนวนหน่วยฐาน ${stockOrderAll[i]} หน่วย',
                                                                                                //   style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                //         fontFamily: 'Kanit',
                                                                                                //         color: Colors.red,
                                                                                                //         fontSize: 12.0,
                                                                                                //         fontWeight: FontWeight.normal,
                                                                                                //       ),
                                                                                                // ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          // Expanded(
                                                                                          //   flex: 1,
                                                                                          //   child: Text(
                                                                                          //     'จำนวนสต๊อก ${stockAll[i]} หน่วย',
                                                                                          //     style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                          //           fontFamily: 'Kanit',
                                                                                          //           color: Colors.black,
                                                                                          //           fontSize: 12.0,
                                                                                          //           fontWeight: FontWeight.normal,
                                                                                          //         ),
                                                                                          //   ),
                                                                                          // ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  SizedBox(
                                                                                    height: 50,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 90,
                                                                                        child: ElevatedButton(
                                                                                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                                                                                            onPressed: () {
                                                                                              print('1');
                                                                                              orderList['ProductList'].removeWhere((element) => element['สถานะรายการนี้เป็นของแถม'] == true);
                                                                                              print('11');
                                                                                              newOrder = [];
                                                                                              print('111');

                                                                                              backDialog = true;
                                                                                              print('1111');

                                                                                              // statusOrderPass = true;

                                                                                              print('-------------- ========');
                                                                                              print(productCountOld);
                                                                                              print('-------------- ========');

                                                                                              for (int j = 0; j < orderList['ProductList'].length; j++) {
                                                                                                orderList['ProductList'][j]['จำนวน'] = productCountOld[j];
                                                                                                productCount[j] = productCountOld[j];
                                                                                              }
                                                                                              print('11111');

                                                                                              setState(
                                                                                                () {},
                                                                                              );
                                                                                              Navigator.pop(contextIN);
                                                                                            },
                                                                                            child: Text(
                                                                                              'ยกเลิก',
                                                                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                    fontFamily: 'Kanit',
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 12.0,
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                  ),
                                                                                            )),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 90,
                                                                                        child: ElevatedButton(
                                                                                            onPressed: () async {
                                                                                              print('OK OK OK OK OK');
                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);
                                                                                              //====================== อัพเดทสินค้าที่เคยสั่งของพนักงานคนนั้น ==========================
                                                                                              setState(() {
                                                                                                isLoading2 = true;
                                                                                              });
                                                                                              print('2');

                                                                                              String orderID = DateTime.now().toString();
                                                                                              print('22');

                                                                                              List<dynamic> listHistory = userData!['สินค้าที่เคยสั่ง'];
                                                                                              List<String> listHistoryString = [];
                                                                                              print('222');

                                                                                              for (int i = 0; i < listHistory.length; i++) {
                                                                                                listHistoryString.add(listHistory[i].toString());
                                                                                              }
                                                                                              print('2222');

                                                                                              for (int i = 0; i < newOrder.length; i++) {
                                                                                                bool isStringFound = listHistoryString.any((map) => map == newOrder[i]['ProductID']);

                                                                                                if (isStringFound) {
                                                                                                } else {
                                                                                                  listHistoryString.add(newOrder[i]['ProductID'].toString());
                                                                                                }
                                                                                              }
                                                                                              print('22222');

                                                                                              List<dynamic> listHistoryDate = userData!['สินค้าที่เคยสั่ง_วันที่'];
                                                                                              List<DateTime?>? listHistoryStringDate = [];
                                                                                              print('222222');

                                                                                              for (int i = 0; i < listHistoryDate.length; i++) {
                                                                                                // print(listHistoryDate[i]);
                                                                                                Timestamp timestamp = listHistoryDate[i];
                                                                                                DateTime dateTime = timestamp.toDate();
                                                                                                // print(dateTime);

                                                                                                listHistoryStringDate.add(dateTime);
                                                                                              }
                                                                                              print('222222');

                                                                                              for (int i = listHistoryStringDate.length; i < listHistoryString.length; i++) {
                                                                                                listHistoryStringDate.add(DateTime.now());
                                                                                              }
                                                                                              print('2222222');

                                                                                              print(listHistoryString);
                                                                                              print(listHistoryStringDate);
                                                                                              List<Timestamp> listTimestamp = [];

                                                                                              for (int i = 0; i < listHistoryStringDate.length; i++) {
                                                                                                Timestamp timestamp = Timestamp.fromDate(listHistoryStringDate[i]!);
                                                                                                listTimestamp.add(timestamp);
                                                                                              }
                                                                                              print('22222222');

                                                                                              userData!['สินค้าที่เคยสั่ง'] = listHistoryString;

                                                                                              userData!['สินค้าที่เคยสั่ง_วันที่'] = listTimestamp;

                                                                                              List<Map<String, dynamic>?>? listProductReal = [];
                                                                                              print('222222222');

                                                                                              for (var element in newOrder) {
                                                                                                // print(element['ProductID']);

                                                                                                Map<String, dynamic>? foundMap = resultList.firstWhere(
                                                                                                  (map) => map['PRODUCT_ID'] == element['ProductID'],
                                                                                                  orElse: () => {},
                                                                                                );

                                                                                                listProductReal.add(foundMap);
                                                                                              }
                                                                                              print('22222222222');

                                                                                              print('listProductReal');
                                                                                              print(listProductReal);

                                                                                              await FirebaseFirestore.instance.collection('User').doc(userData!['UserID']).update(
                                                                                                {
                                                                                                  'สินค้าที่เคยสั่ง': listHistoryString,
                                                                                                  'สินค้าที่เคยสั่ง_วันที่': listHistoryStringDate,
                                                                                                },
                                                                                              ).then((value) {
                                                                                                // if (mounted) {
                                                                                                // setState(() {});
                                                                                                // }
                                                                                              });

                                                                                              print('2222222222212');

                                                                                              // ====================== เพิ่ม ประวัติออเดอร์วันนี้ ==========================
                                                                                              print('3');
                                                                                              List<dynamic> listOrderCustomerIDToday = [];

                                                                                              List<dynamic> listOrderToday = [];
                                                                                              List<dynamic> listOrderToday_date = [];
                                                                                              print('33');

                                                                                              if (userData!['ออเดอร์วันนี้'] == null) {
                                                                                                listOrderToday = [];
                                                                                              } else {
                                                                                                listOrderToday = userData!['ออเดอร์วันนี้'];
                                                                                              }
                                                                                              print('33');

                                                                                              if (userData!['ออเดอร์วันนี้_วันที่'] == null) {
                                                                                              } else {
                                                                                                listOrderToday_date = userData!['ออเดอร์วันนี้_วันที่'];
                                                                                              }

                                                                                              print('333');

                                                                                              if (userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] == null) {
                                                                                              } else {
                                                                                                listOrderCustomerIDToday = userData!['ออเดอร์วันนี้_ไอดีลูกค้า'];
                                                                                              }
                                                                                              print('3333');

                                                                                              for (int i = 0; i < listOrderToday_date.length; i++) {
                                                                                                Timestamp timestamp = listOrderToday_date[i];
                                                                                                DateTime dateTime = timestamp.toDate();

                                                                                                DateTime now = DateTime.now();

                                                                                                if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
                                                                                                } else {
                                                                                                  listOrderToday.removeAt(i);
                                                                                                  listOrderToday_date.removeAt(i);
                                                                                                  listOrderCustomerIDToday.remove(i);
                                                                                                }
                                                                                              }
                                                                                              print('33333');

                                                                                              Timestamp timestamp = Timestamp.fromDate(DateTime.now());

                                                                                              listOrderCustomerIDToday.add(widget.customerID);

                                                                                              listOrderToday.add(orderID);

                                                                                              listOrderToday_date.add(timestamp);

                                                                                              userData!['ออเดอร์วันนี้'] = listOrderToday;

                                                                                              userData!['ออเดอร์วันนี้_วันที่'] = listOrderToday_date;

                                                                                              userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] = listOrderCustomerIDToday;
                                                                                              print('333333');

                                                                                              await FirebaseFirestore.instance.collection('User').doc(userData!['UserID']).update(
                                                                                                {
                                                                                                  'ออเดอร์วันนี้_ไอดีลูกค้า': listOrderCustomerIDToday,
                                                                                                  'ออเดอร์วันนี้': listOrderToday,
                                                                                                  'ออเดอร์วันนี้_วันที่': listOrderToday_date,
                                                                                                },
                                                                                              ).then((value) {
                                                                                                // if (mounted) {
                                                                                                // setState(() {});
                                                                                                // }
                                                                                              });
                                                                                              print('333333');

                                                                                              double sumTotalVat = 0.0;
                                                                                              double sumTotalNoVat = 0.0;

                                                                                              double sum1 = 0.0;
                                                                                              double sum2 = 0.0;
                                                                                              double sum3 = 0.0;
                                                                                              double sum4 = 0.0;
                                                                                              double sum5 = 0.0;
                                                                                              double sum6 = 0.0;
                                                                                              double sum7 = 0.0;

                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);
                                                                                              print(newOrder.length);

                                                                                              for (var element in newOrder) {
                                                                                                Map<String, dynamic> dataMap = resultList.firstWhere((product) => product['PRODUCT_ID'] == element['ProductID']);

                                                                                                // if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                //   sumTotalVat =
                                                                                                //       sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                // } else {
                                                                                                //   sumTotalNoVat =
                                                                                                //       sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                // }

                                                                                                print(element['จำนวน']);
                                                                                                print(element['ราคา']);
                                                                                                print(dataMap['VAT_TYPE']);
                                                                                                print(element['ส่วนลดรายการ']);

                                                                                                if (dataMap['VAT_TYPE'] == 'V') {
                                                                                                  if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                    double discount = double.parse(element['ส่วนลดรายการ'] ?? '0.0');
                                                                                                    sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));

                                                                                                    sumTotalVat = sumTotalVat - discount;
                                                                                                  } else {
                                                                                                    sumTotalVat = sumTotalVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                  }
                                                                                                } else {
                                                                                                  if (element['ส่วนลดรายการ'] != '0.0') {
                                                                                                    double discount = double.parse(element['ส่วนลดรายการ']);

                                                                                                    sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                    sumTotalNoVat = sumTotalNoVat - discount;
                                                                                                  } else {
                                                                                                    sumTotalNoVat = sumTotalNoVat + (element['จำนวน'] * double.parse(element['ราคา']));
                                                                                                  }
                                                                                                }
                                                                                              }

                                                                                              sum1 = sumTotalNoVat + sumTotalVat;
                                                                                              sum2 = 0.0;
                                                                                              sum3 = sumTotalNoVat;
                                                                                              sum4 = sumTotalVat;
                                                                                              sum5 = sumTotalVat - ((sumTotalVat * 7) / 107);
                                                                                              sum6 = (sumTotalVat * 7) / 107;
                                                                                              sum7 = sumTotalNoVat + sumTotalVat;

                                                                                              print('PASS');
                                                                                              print('PASS');
                                                                                              print('PASS');
                                                                                              print('PASS');
                                                                                              print('PASS');

                                                                                              // ====================== เพิ่ม ออเดอร์ของลูกค้า ==========================

                                                                                              // กำหนดรูปแบบของวันที่
                                                                                              DateFormat dateFormat = DateFormat('dd-MM-yyyy');

                                                                                              // แปลงสตริงเป็น DateTime
                                                                                              DateTime? dateTime;
                                                                                              if (orderList['วันเวลาจัดส่ง'] == '') {
                                                                                              } else {
                                                                                                dateTime = dateFormat.parse(orderList['วันเวลาจัดส่ง']);
                                                                                              }

                                                                                              // orderList['ยอดรวม'] = sumTotalNoVat + sumTotalVat;
                                                                                              // orderList['ส่วนลด'] = 0.0;
                                                                                              // orderList['มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'] = sumTotalNoVat;
                                                                                              // orderList['มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'] = sumTotalVat;
                                                                                              // orderList['มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'] = sumTotalVat - ((sumTotalVat * 7) / 107);
                                                                                              // orderList['ภาษีมูลค่าเพิ่ม'] = (sumTotalVat * 7) / 107;
                                                                                              // orderList['มูลค่าสินค้ารวม'] = sumTotalNoVat + sumTotalVat;

                                                                                              await FirebaseFirestore.instance.collection('OrderOppLoss').doc(orderID).set({
                                                                                                'OrderOppLossID': DateTime.now().toString(),
                                                                                                'CustomerID': widget.customerID,
                                                                                                'OrdersOppLossUpdateTime': DateTime.now(),
                                                                                                'OppLossProductList': orderLoss,
                                                                                              });

                                                                                              await FirebaseFirestore.instance.collection(AppSettings.customerType == CustomerType.Test ? 'CustomerTest' : 'Customer').doc(widget.customerID).collection('Orders').doc(orderID).set({
                                                                                                'OrdersDateID': orderID,
                                                                                                'OrdersUpdateTime': DateTime.now(),
                                                                                                'สถานที่จัดส่ง': orderList['สถานที่จัดส่ง'],
                                                                                                'วันเวลาจัดส่ง': orderList['วันเวลาจัดส่ง'] == '' ? '' : dateTime,
                                                                                                'สายส่ง': orderList['สายส่ง'],
                                                                                                'สายส่งโค้ด': orderList['สายส่งโค้ด'],
                                                                                                'สายส่งไอดี': orderList['สายส่งไอดี'],
                                                                                                'ProductList': newOrder,
                                                                                                'ยอดรวม': sum1,
                                                                                                'ส่วนลด': sum2,
                                                                                                'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม': sum3,
                                                                                                'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม': sum4,
                                                                                                'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม': sum5,
                                                                                                'ภาษีมูลค่าเพิ่ม': sum6,
                                                                                                'มูลค่าสินค้ารวม': sum7,
                                                                                                'วันเวลาจัดส่ง_string': orderList['วันเวลาจัดส่ง'] == '' ? '' : dateTime.toString(),
                                                                                                'วันเวลาจัดส่ง_day': orderList['วันเวลาจัดส่ง_day'],
                                                                                                'ListCustomerAddressID': orderList['ListCustomerAddressID'] == 'ตัวเลือก' ? '' : orderList['ListCustomerAddressID'],
                                                                                                'ตารางราคา': orderList['ตารางราคา'] == 'ตัวเลือก' ? '' : orderList['ตารางราคา'],
                                                                                                'ค้างชำระ': 0,
                                                                                                'สถานะเอกสาร': false,
                                                                                                'สถานะอนุมัติขาย': false,
                                                                                                'รอตรวจการอนุมัติ': true,
                                                                                                'ProductListDocument': listProductReal,
                                                                                                'สถานะเช็คสต็อก': 'ปกติ',
                                                                                                'PO': textController1.text.trim(),
                                                                                                'หมายเหตุ': textController2.text,
                                                                                              }).whenComplete(() async {
                                                                                                HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('apiConfirmOrder');
                                                                                                var params = <String, dynamic>{
                                                                                                  "MODE": AppSettings.customerType == CustomerType.Test ? "TEST" : "REAL",
                                                                                                  "CustomerDocId": widget.customerID,
                                                                                                  "OrdersDateID": orderID,
                                                                                                  "UserDocId": userData!['EmployeeID'],
                                                                                                  "สถานะค้างชำระ": false,
                                                                                                  "รอตรวจการอนุมัติ": true,
                                                                                                  "สถานะอนุมัติขาย": false,
                                                                                                  "ค้างชำระ": 0
                                                                                                };

                                                                                                print('======================================= aaaaa');

                                                                                                await callable.call(params).then((value) {
                                                                                                  print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
                                                                                                  if (value.data['status'] == 'success') {
                                                                                                    var response = value.data['data'];
                                                                                                  }
                                                                                                }).whenComplete(() {
                                                                                                  if (mounted) {
                                                                                                    setState(() {
                                                                                                      isLoading2 = false;
                                                                                                      Navigator.pop(contextIN);
                                                                                                      // Navigator.pop(context);
                                                                                                      // Navigator.pop(context);
                                                                                                      // Navigator.pop(context);
                                                                                                      // Navigator.pop(context);
                                                                                                    });
                                                                                                  }
                                                                                                }).whenComplete(() {
                                                                                                  // Navigator.pop(context);
                                                                                                  // Navigator.pop(context);
                                                                                                  // Navigator.pop(context);

                                                                                                  // Navigator.push(
                                                                                                  //     context,
                                                                                                  //     CupertinoPageRoute(
                                                                                                  //       builder: (context) => A0905SuccessOrderProduct(),
                                                                                                  //     ));
                                                                                                });
                                                                                              });
                                                                                            },
                                                                                            child: isLoading2
                                                                                                ? CircularProgressIndicator()
                                                                                                : Text(
                                                                                                    'ตกลง',
                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                          fontFamily: 'Kanit',
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 12.0,
                                                                                                          fontWeight: FontWeight.normal,
                                                                                                        ),
                                                                                                  )),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 50,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                      : SizedBox(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          // Container(
                                                          //   width: MediaQuery.of(context)
                                                          //           .size
                                                          //           .width *
                                                          //       0.85,
                                                          //   height: MediaQuery.of(context)
                                                          //           .size
                                                          //           .height *
                                                          //       0.1,
                                                          //   color: Colors.green,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ).whenComplete(() {
                                      newOrder = [];
                                      orderLoss = [];

                                      orderList['ProductList'].removeWhere(
                                          (element) =>
                                              element[
                                                  'สถานะรายการนี้เป็นของแถม'] ==
                                              true);

                                      setState(
                                        () {},
                                      );
                                    });
                                  } else {
                                    // setState(() {
                                    //   isLoading = true;
                                    // });

                                    // for(int i =0 ; i< orderList['ProductList'].length;i++){
                                    //   print(orderList['ProductList'][i]['ชื่อสินค้า']);
                                    //   print(orderList['ProductList'][i]['จำนวน']);
                                    //   print(orderList['ProductList'][i]['สถานะรายการนี้เป็นของแถม']);
                                    // }

                                    String orderID = DateTime.now().toString();

                                    //====================== อัพเดทสินค้าที่เคยสั่งของพนักงานคนนั้น ==========================
                                    List<dynamic> listHistory =
                                        userData!['สินค้าที่เคยสั่ง'];
                                    List<String> listHistoryString = [];

                                    for (int i = 0;
                                        i < listHistory.length;
                                        i++) {
                                      listHistoryString
                                          .add(listHistory[i].toString());
                                    }
                                    for (int i = 0;
                                        i < orderList['ProductList'].length;
                                        i++) {
                                      bool isStringFound =
                                          listHistoryString.any((map) =>
                                              map ==
                                              orderList['ProductList'][i]
                                                  ['ProductID']);

                                      if (isStringFound) {
                                      } else {
                                        listHistoryString.add(
                                            orderList['ProductList'][i]
                                                    ['ProductID']
                                                .toString());
                                      }
                                    }

                                    List<dynamic> listHistoryDate =
                                        userData!['สินค้าที่เคยสั่ง_วันที่'];
                                    List<DateTime?>? listHistoryStringDate = [];

                                    for (int i = 0;
                                        i < listHistoryDate.length;
                                        i++) {
                                      // print(listHistoryDate[i]);
                                      Timestamp timestamp = listHistoryDate[i];
                                      DateTime dateTime = timestamp.toDate();
                                      // print(dateTime);

                                      listHistoryStringDate.add(dateTime);
                                    }

                                    for (int i = listHistoryStringDate.length;
                                        i < listHistoryString.length;
                                        i++) {
                                      listHistoryStringDate.add(DateTime.now());
                                    }

                                    print(listHistoryString);
                                    print(listHistoryStringDate);
                                    List<Timestamp> listTimestamp = [];

                                    for (int i = 0;
                                        i < listHistoryStringDate.length;
                                        i++) {
                                      Timestamp timestamp = Timestamp.fromDate(
                                          listHistoryStringDate[i]!);
                                      listTimestamp.add(timestamp);
                                    }

                                    userData!['สินค้าที่เคยสั่ง'] =
                                        listHistoryString;

                                    userData!['สินค้าที่เคยสั่ง_วันที่'] =
                                        listTimestamp;

                                    List<Map<String, dynamic>?>?
                                        listProductReal = [];

                                    for (var element
                                        in orderList['ProductList']) {
                                      // print(element['ProductID']);

                                      Map<String, dynamic>? foundMap =
                                          resultList.firstWhere(
                                        (map) =>
                                            map['PRODUCT_ID'] ==
                                            element['ProductID'],
                                        orElse: () => {},
                                      );

                                      listProductReal.add(foundMap);
                                    }
                                    print('listProductReal');
                                    print(listProductReal);

                                    print('ผ่านทุกเงื่อนไข');
                                    print(listProductReal.length);
                                    print(orderList['ProductList'].length);

                                    for (var element
                                        in orderList['ProductList']) {
                                      print(element);
                                    }

                                    for (var element in listProductReal) {
                                      print(element);
                                    }
                                    // return;

                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(userData!['UserID'])
                                        .update(
                                      {
                                        'สินค้าที่เคยสั่ง': listHistoryString,
                                        'สินค้าที่เคยสั่ง_วันที่':
                                            listHistoryStringDate,
                                      },
                                    ).then((value) {
                                      // if (mounted) {
                                      // setState(() {});
                                      // }
                                    });
                                    // ====================== เพิ่ม ประวัติออเดอร์วันนี้ ==========================
                                    List<dynamic> listOrderCustomerIDToday = [];

                                    List<dynamic> listOrderToday = [];
                                    List<dynamic> listOrderToday_date = [];

                                    if (userData!['ออเดอร์วันนี้'] == null) {
                                      listOrderToday = [];
                                    } else {
                                      listOrderToday =
                                          userData!['ออเดอร์วันนี้'];
                                    }

                                    if (userData!['ออเดอร์วันนี้_วันที่'] ==
                                        null) {
                                    } else {
                                      listOrderToday_date =
                                          userData!['ออเดอร์วันนี้_วันที่'];
                                    }

                                    if (userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] ==
                                        null) {
                                    } else {
                                      listOrderCustomerIDToday =
                                          userData!['ออเดอร์วันนี้_ไอดีลูกค้า'];
                                    }

                                    for (int i = 0;
                                        i < listOrderToday_date.length;
                                        i++) {
                                      Timestamp timestamp =
                                          listOrderToday_date[i];
                                      DateTime dateTime = timestamp.toDate();

                                      DateTime now = DateTime.now();

                                      if (dateTime.year == now.year &&
                                          dateTime.month == now.month &&
                                          dateTime.day == now.day) {
                                      } else {
                                        listOrderToday.removeAt(i);
                                        listOrderToday_date.removeAt(i);
                                        listOrderCustomerIDToday.remove(i);
                                      }
                                    }

                                    Timestamp timestamp =
                                        Timestamp.fromDate(DateTime.now());

                                    listOrderCustomerIDToday
                                        .add(widget.customerID);

                                    listOrderToday.add(orderID);

                                    listOrderToday_date.add(timestamp);

                                    userData!['ออเดอร์วันนี้'] = listOrderToday;

                                    userData!['ออเดอร์วันนี้_วันที่'] =
                                        listOrderToday_date;

                                    userData!['ออเดอร์วันนี้_ไอดีลูกค้า'] =
                                        listOrderCustomerIDToday;

                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(userData!['UserID'])
                                        .update(
                                      {
                                        'ออเดอร์วันนี้_ไอดีลูกค้า':
                                            listOrderCustomerIDToday,
                                        'ออเดอร์วันนี้': listOrderToday,
                                        'ออเดอร์วันนี้_วันที่':
                                            listOrderToday_date,
                                      },
                                    ).then((value) {
                                      // if (mounted) {
                                      // setState(() {});
                                      // }
                                    });
                                    // ====================== เพิ่ม ออเดอร์ของลูกค้า ==========================

                                    // กำหนดรูปแบบของวันที่
                                    DateFormat dateFormat =
                                        DateFormat('dd-MM-yyyy');

                                    // แปลงสตริงเป็น DateTime
                                    DateTime? dateTime;
                                    if (orderList['วันเวลาจัดส่ง'] == '') {
                                    } else {
                                      dateTime = dateFormat
                                          .parse(orderList['วันเวลาจัดส่ง']);
                                    }

                                    await FirebaseFirestore.instance
                                        .collection(AppSettings.customerType ==
                                                CustomerType.Test
                                            ? 'CustomerTest'
                                            : 'Customer')
                                        .doc(widget.customerID)
                                        .collection('Orders')
                                        .doc(orderID)
                                        .set({
                                      'OrdersDateID': orderID,
                                      'OrdersUpdateTime': DateTime.now(),
                                      'สถานที่จัดส่ง':
                                          orderList['สถานที่จัดส่ง'],
                                      'วันเวลาจัดส่ง':
                                          orderList['วันเวลาจัดส่ง'] == ''
                                              ? ''
                                              : dateTime,
                                      'สายส่ง': orderList['สายส่ง'],
                                      'สายส่งโค้ด': orderList['สายส่งโค้ด'],
                                      'สายส่งไอดี': orderList['สายส่งไอดี'],
                                      'ProductList': orderList['ProductList'],
                                      'ยอดรวม': orderList['ยอดรวม'],
                                      'ส่วนลด': orderList['ส่วนลด'],
                                      'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม':
                                          orderList[
                                              'มูลค่าสินค้าที่ยกเว้นภาษีมูลค่าเพิ่ม'],
                                      'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม':
                                          orderList[
                                              'มูลค่าสินค้าที่รวมภาษีมูลค่าเพิ่ม'],
                                      'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม':
                                          orderList[
                                              'มูลค่าสินค้าที่เสียภาษีมูลค่าเพิ่ม'],
                                      'ภาษีมูลค่าเพิ่ม':
                                          orderList['ภาษีมูลค่าเพิ่ม'],
                                      'มูลค่าสินค้ารวม':
                                          orderList['มูลค่าสินค้ารวม'],
                                      'วันเวลาจัดส่ง_string':
                                          orderList['วันเวลาจัดส่ง'] == ''
                                              ? ''
                                              : dateTime.toString(),
                                      'วันเวลาจัดส่ง_day':
                                          orderList['วันเวลาจัดส่ง_day'],
                                      'ListCustomerAddressID': orderList[
                                                  'ListCustomerAddressID'] ==
                                              'ตัวเลือก'
                                          ? ''
                                          : orderList['ListCustomerAddressID'],
                                      'ตารางราคา':
                                          orderList['ตารางราคา'] == 'ตัวเลือก'
                                              ? ''
                                              : orderList['ตารางราคา'],
                                      'ค้างชำระ': 0,
                                      'สถานะเอกสาร': false,
                                      'สถานะอนุมัติขาย': false,
                                      'รอตรวจการอนุมัติ': true,
                                      'ProductListDocument': listProductReal,
                                      'สถานะเช็คสต็อก': 'ปกติ',
                                      'PO': textController1.text.trim(),
                                      'หมายเหตุ': textController2.text,
                                    }).whenComplete(() async {
                                      HttpsCallable callable = FirebaseFunctions
                                          .instance
                                          .httpsCallable('apiConfirmOrder');
                                      var params = <String, dynamic>{
                                        "MODE": AppSettings.customerType ==
                                                CustomerType.Test
                                            ? "TEST"
                                            : "REAL",
                                        "CustomerDocId": widget.customerID,
                                        "OrdersDateID": orderID,
                                        "UserDocId": userData!['EmployeeID'],
                                        "สถานะค้างชำระ": false,
                                        "รอตรวจการอนุมัติ": true,
                                        "สถานะอนุมัติขาย": false,
                                        "ค้างชำระ": 0
                                      };

                                      print(
                                          '======================================= aaaaa');

                                      await callable.call(params).then((value) {
                                        print(
                                            'ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
                                        if (value.data['status'] == 'success') {
                                          var response = value.data['data'];
                                        }
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     CupertinoPageRoute(
                                      //       builder: (context) =>
                                      //           A0905SuccessOrderProduct(),
                                      //     ));
                                    });
                                  }

                                  for (Map<String, dynamic>? ratio
                                      in productCovertRatio) {
                                    // print(ratio);
                                  }
                                  print('วันที่จัดส่ง');

                                  print(orderList['สายส่ง_วันที่จัดส่ง']);

                                  // ===========================================================================
                                }

                                // Navigator.push(
                                //     context,
                                //     CupertinoPageRoute(
                                //       builder: (context) =>
                                //           A0905SuccessOrderProduct(),
                                //     )).whenComplete(() {
                                setState(() {
                                  isLoading = false;

                                  if (!statusOrderPass) {
                                    if (backDialog) {
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              A0905SuccessOrderProduct(),
                                        ));
                                  }
                                });
                                // });
                              } catch (e) {
                                print(e);
                              }
                            },
                            text: orderList['ProductList'].length == 0
                                ? 'ไม่มีออเดอร์สินค้า'
                                : checkConvertRatio
                                    ? 'ไม่สามารถเปิดออเดอร์ได้'
                                    : 'ยืนยันออเดอร์และส่งเข้าระบบ เพื่อตรวจสอบเครดิต และประวัติค้างชำระ',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: orderList['ProductList'].length == 0
                                  ? Colors.grey.shade400
                                  : checkConvertRatio
                                      ? Colors.grey.shade400
                                      : FlutterFlowTheme.of(context).secondary,
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
                        // Container(
                        //     width: 500,
                        //     height: 500,
                        //     child: A09021AddressSetting()),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              Navigator.pop(context, orderList);
                            },
                            text: 'ย้อนกลับ',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withOpacity(0.5),
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
    );
  }
}
