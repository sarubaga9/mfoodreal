import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_food/a09_customer_open_sale/a090301_product_detail.dart';
import 'package:m_food/a09_customer_open_sale/a0904_product_order_detail%2024%2009%203567.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
import 'package:m_food/flutter_flow/flutter_flow_drop_down.dart';
import 'package:m_food/flutter_flow/form_field_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:xml2json/xml2json.dart';

import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';

class A0903ProductScreen extends StatefulWidget {
  final String? customerID;
  final Map<String, dynamic>? orderDataMap;
  const A0903ProductScreen({super.key, this.orderDataMap, this.customerID});

  @override
  _A0903ProductScreenState createState() => _A0903ProductScreenState();
}

class _A0903ProductScreenState extends State<A0903ProductScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final customerController = Get.find<CustomerController>();
  RxMap<String, dynamic>? customerData;
  late Map<String, dynamic> customerDataFetch;

  TextEditingController searchTextController = TextEditingController();

  final productController = Get.find<ProductController>();
  RxMap<String, dynamic>? productGetData;

  TextEditingController textController = TextEditingController();

  final productGroupController = Get.find<ProductGroupController>();

  RxMap<String, dynamic>? productGroupGetData;

  bool isLoading = false;
  List<Map<String, dynamic>> resultList = [];
  List<Map<String, dynamic>> productList = [];
  List<int> productCount = [];

  List<Map<String, dynamic>> resultProductGroupList = [];
  List<Map<String, dynamic>> firstList = [];
  List<Map<String, dynamic>> secondList = [];

  Map<String, dynamic>? orderLast;

  List<Map<String, dynamic>?>? specialPriceProductList = [];

  List<Map<String, dynamic>> tagProductList = [];

  List<Map<String, dynamic>> tableData = [];
  Map<String, dynamic>? tableDesc;

  var jsonString;
  List<Map<String, dynamic>> sellPrices = [];

  List<FormFieldController<String>> dropDownUnitControllers = [];

  List<CustomPopupMenuController> controller = [];
  List<String> unitChoose = [];
  List<String> priceChoose = [];

  String checkFavGroup = '';

  List<TextEditingController> inModalDialog = [];

  List<Map<String, dynamic>>? nonNullableList = [];
  List<dynamic>? dynamicList = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isPriceEmpty(Map<String, dynamic> map) {
    return (map['ราคา'] == '');
  }

  toSetState() {
    setState(() {});
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });

    userData = userController.userData;
    productGetData = productController.productData;

    productGroupGetData = productGroupController.productGroupData;

    customerData = customerController.customerData;

    if (widget.orderDataMap!['ProductList'].isEmpty) {
      orderLast = widget.orderDataMap;
    } else {
      orderLast = widget.orderDataMap;

      for (int i = 0; i < orderLast!['ProductList'].length; i++) {
        if (orderLast!['ProductList'][i]['สถานะรายการนี้เป็นของแถม'] == true) {
          orderLast!['ProductList'].removeAt(i);
          // เมื่อพบข้อมูลที่ตรงเงื่อนไขแล้ว ให้ลบข้อมูลที่ index นั้นออกจากรายการ
          // หลังจากนั้นจะไม่มีการวนลูปต่อไปที่ index เดียวกันเนื่องจากขนาดของรายการเปลี่ยนแปลง
          // จึงไม่จำเป็นต้องเพิ่มค่า i ไปอีก
          i--; // ลดค่า i ลง 1 เพื่อปรับตำแหน่งที่จะตรวจสอบต่อไป
        }
      }
    }

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('แท็กสินค้า').get();

    for (int index = 0; index < querySnapshot.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshot.docs[index].data() as Map<String, dynamic>;

      if (docData['IS_ACTIVE'] == true) {
        // tagProduct!['key$index'] = docData;
        tagProductList.add(docData);
      }
    }

    QuerySnapshot querySnapshotTable =
        await FirebaseFirestore.instance.collection('ตารางราคา').get();

    for (int index = 0; index < querySnapshotTable.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshotTable.docs[index].data() as Map<String, dynamic>;

      tableData.add(docData);
    }

    print(orderLast!['ตารางราคา']);
    print(orderLast!['ตารางราคา']);
    print(orderLast!['ตารางราคา']);
    print(orderLast!['ตารางราคา']);
    print(orderLast!['ตารางราคา']);
    print(orderLast!['ตารางราคา']);
    print(orderLast!['ตารางราคา']);

    String firstChar = orderLast!['ตารางราคา'].toString()[0];

    // if (orderLast!['ตารางราคา'] == 'ไม่มีข้อมูล') {
    if (firstChar == 'ไม่มีข้อมูล') {
      print('null');
    } else {
      print('no null');
      try {
        tableDesc = tableData.firstWhere((element) {
          //แก้ไขเปลี่ยนตารางลูกค้าให็เป็นสตริงตัวเดียว แล้ว ค้นหาใน DESC1 แทน
          // return element['PLIST_DESC2'] == orderLast!['ตารางราคา'];
          return element['PLIST_DESC1'] == firstChar;
        });

        print('พบ ');
      } catch (e) {
        print(orderLast!['ตารางราคา']);

        print('ไม่พบ ใน list');
      }

      // print(orderLast!['ตารางราคา']);
      // print(tableDesc);

      try {
        print('======================================= 11111');

        HttpsCallable callable2 =
            FirebaseFunctions.instance.httpsCallable('getApiMfood');
        var params2 = <String, dynamic>{
          "url": "http://mobile.mfood.co.th:7105/MBServices.asmx?op=Sell_Price",
          "xml":
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><Sell_Price xmlns="MFOODMOBILEAPI"><PRICE_LIST>${tableDesc!['PLIST_DESC1'].toString()}</PRICE_LIST></Sell_Price></soap:Body></soap:Envelope>'
        };

        print(params2['xml']);
        print('======================================= aaaaa');

        await callable2.call(params2).then((value) async {
          print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
          if (value.data['status'] == 'success') {}
          // response = value.data;
          // productList = value.data['data'];

          // print(response.toString());

          Xml2Json xml2json = Xml2Json();
          xml2json.parse(value.data.toString());

          print(xml2json);
          jsonString = xml2json.toOpenRally();

          print(jsonString);
          print('kkkkkkkkkkkkkkkk');

          Map<String, dynamic> data = json.decode(jsonString);

          Map<String, dynamic> sellPriceResponse =
              data['Envelope']['Body']['Sell_PriceResponse'];

          if (sellPriceResponse['Sell_PriceResult'] == 'true') {
            print('is true');
          } else {
            sellPrices = List<Map<String, dynamic>>.from(
                sellPriceResponse['Sell_PriceResult']['SELL_PRICE']);
          }

          // for (Map<String, dynamic> sellPrice in sellPrices) {
          for (int i = 0; i < sellPrices.length; i++) {
            // print("RESULT: ${sellPrice['RESULT']}");
            // print("PRODUCT_ID: ${sellPrice['PRODUCT_ID']}");
            // print("SALES_PRICE_ID: ${sellPrice['SALES_PRICE_ID']}");
            // print("NAMES: ${sellPrice['NAMES']}");
            // print("PRICE: ${sellPrice['PRICE']}");
            // print("UNIT: ${sellPrice['UNIT']}");
            // print(i);
            // print(sellPrices[i]['PRODUCT_ID']);
            print("-------------------");

            if (sellPrices[i]['PRODUCT_ID'] == '0141369980500') {
              print(sellPrices[i]['PRODUCT_ID']);
              print(sellPrices[i]['NAMES']);
              print(sellPrices[i]['UNIT']);
              print(sellPrices[i]['PRICE']);
              print(sellPrices[i]);
            }
            if (sellPrices[i]['PRODUCT_ID'] == '0141369990500') {
              print(sellPrices[i]['PRODUCT_ID']);
              print(sellPrices[i]['NAMES']);
              print(sellPrices[i]['UNIT']);
              print(sellPrices[i]['PRICE']);
              print(sellPrices[i]);
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
    }

    // print('object');

    // print(tagProductList);

    // print(tagProductList);

    // print(orderLast!['วันเวลาจัดส่ง_day']);
    // print(orderLast!['ListCustomerAddressID']);

    // ดึงข้อมูลจาก collection 'Customer'

    print(widget.customerID);

    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'CustomerTest'
            : 'Customer')
        .doc(widget.customerID)
        .get();

    customerDataFetch = customerDoc.data() as Map<String, dynamic>;

    // if (customerDoc.exists) {
    //   CollectionReference subCollectionRef = FirebaseFirestore.instance
    //       .collection(AppSettings.customerType == CustomerType.Test
    //           ? 'CustomerTest/${widget.customerID}/ราคาสินค้าพิเศษ'
    //           : 'Customer/${widget.customerID}/ราคาสินค้าพิเศษ');

    //   QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

    //   subCollectionSnapshot.docs.forEach((doc) {
    //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //     specialPriceProductList!.add(data);
    //   });

    //   specialPriceProductList = (specialPriceProductList ?? [])
    //       .where((map) => map != null)
    //       .cast<Map<String, dynamic>>()
    //       .toList();

    //   print(specialPriceProductList);
    // }

    if (productGetData != null) {
      productGetData!.forEach((key, value) {
        dropDownUnitControllers.add(FormFieldController(''));

        // print(value);
        // Map<String, dynamic>? foundMap = specialPriceProductList?.firstWhere(
        //   (Map<String, dynamic>? map) => map?['DocID'] == value['DocId'],
        //   orElse: () => {},
        // );

        Map<String, dynamic>? entry;

        // if (foundMap!.isNotEmpty) {
        //   // print('123');
        //   // print(foundMap);
        //   entry = value;
        //   entry!['PRICE'] = foundMap['PRICE'];
        //   entry['ราคาพิเศษ'] = true;
        // } else {
        entry = value;
        // entry!['ราคาพิเศษ'] = false;
        // }

        // เพิ่มข้อมูล 'รายละเอียดสตริง' : 'นี่คือข้อความ' ลงใน Map
        String parsedstring3 = Bidi.stripHtmlIfNeeded(
            entry!['รายละเอียด'] == null ? '' : entry['รายละเอียด']);
        // print(parsedstring3);
        entry['รายละเอียดสตริง'] = parsedstring3.trimLeft().trimRight();

        List<String>? name = [];
        if (entry['Tag'] == null) {
        } else {
          if (entry['Tag'] == '') {
          } else {
            for (var element in entry['Tag']) {
              Map<String, dynamic>? foundMap = tagProductList.firstWhere(
                (map) => map['DocId'] == element,
                orElse: () => {},
              );

              name.add(foundMap['Name']); //ฟิลด์ใน colection แท๊กสินค้า
            }
          }
        }

        // print(name);
        // print(name);
        // print(name);

        entry['แท๊ก'] = name;

        // print('check sellPrices');

        List<Map<String, dynamic>> matchingMaps = sellPrices
            .where((map) => map['PRODUCT_ID'] == entry!['PRODUCT_ID'])
            .toList();

        // print('check sellPrices');

        // if (entry['PRODUCT_ID'] == '0030006840420') {
        if (entry['PRODUCT_ID'] == '0030006840420') {
          print(matchingMaps);
          print(entry['PRODUCT_ID']);
          print(entry['UNIT']);
        }

        List<String> priceApi = [];
        List<String> unitApi = [];

        for (var element in matchingMaps) {
          priceApi.add(element['PRICE']);
          unitApi.add(element['UNIT']);
        }

        // for (var element in matchingMaps) {
        //   bool check = false;
        //   if (element['UNIT'] == entry!['UNIT']) {
        //     check = true;
        //     if (entry['PRODUCT_ID'] == '0141369980500') {
        //       print(check);
        //       print('check products true');
        //     }
        //     priceApi.add(element['PRICE']);
        //     unitApi.add(element['UNIT']);
        //   } else {
        //     if (entry['PRODUCT_ID'] == '0141369980500') {
        //       print(check);
        //       print('check products false');
        //     }
        //     priceApi.add(element['PRICE']);
        //     unitApi.add(element['UNIT']);
        //   }
        // }

        // print(unitApi);
        entry['ราคา'] = priceApi;
        entry['ยูนิต'] = unitApi;

        if (entry['ราคา'].isEmpty) {
          entry['สถานะพร้อมขาย'] = false;
        } else {
          entry['สถานะพร้อมขาย'] = true;
        }

        // print('12345231344134343234234234234');
        // print(entry['ราคา']);

        // print(entry['ยูนิต']);

        bool isStringFound = false;

        // print(userData!['สินค้าชื่นชอบ']);
        // print(entry['PRODUCT_ID']);

        //edit Favorite 24 06 2567
        // for (int i = 0; i < userData!['สินค้าถูกใจ'].length; i++) {
        //   if (userData!['สินค้าถูกใจ'][i] == entry['PRODUCT_ID']) {
        //     isStringFound = true;
        //   }
        // }

        //edit 0907567
        if (customerDataFetch!['สินค้าถูกใจ'] == null) {
          customerDataFetch!['สินค้าถูกใจ'] = [];
        }

        for (int i = 0; i < customerDataFetch!['สินค้าถูกใจ'].length; i++) {
          if (customerDataFetch!['สินค้าถูกใจ'][i] == entry['PRODUCT_ID']) {
            isStringFound = true;
          }
        }

        if (isStringFound) {
          entry['Favorite'] = true;
        } else {
          entry['Favorite'] = false;
        }

        if (entry['RESULT'] == false) {
        } else {
          resultList.add(entry);
          productList.add(entry);
          productCount.add(0);
        }

        // print(resultList.length);
        inModalDialog.add(TextEditingController(text: ''));
      });

      // จัดเรียง map โดยให้ map ที่มีฟิลด์ 'ราคา' เป็น empty string ไปอยู่หลังสุด
      // productList.sort((a, b) {
      //   bool isEmptyA = isPriceEmpty(a);
      //   bool isEmptyB = isPriceEmpty(b);
      //   if (isEmptyA && !isEmptyB) {
      //     return 1;
      //   } else if (!isEmptyA && isEmptyB) {
      //     return -1;
      //   } else {
      //     return 0;
      //   }
      // });

      productList.sort((a, b) {
        var aReadyToSell = a['สถานะพร้อมขาย'] ?? false;
        var bReadyToSell = b['สถานะพร้อมขาย'] ?? false;

        // หากเป็นจริงอยู่ด้านหน้าทั้งหมด
        if (aReadyToSell && !bReadyToSell) {
          return -1;
        } else if (!aReadyToSell && bReadyToSell) {
          // หากเป็นเท็จไปอยู่ด้านหลัง
          return 1;
        } else {
          // ในกรณีอื่น ๆ ให้เรียงตามลำดับเดิม
          return 0;
        }
      });

      for (var element in productList) {
        controller.add(CustomPopupMenuController());

        unitChoose.add('');
        priceChoose.add('');
        unitChoose.last =
            element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

        String price = '';
        price = element['ราคา'].isEmpty
            ? element['PRICE'].toString()
            : element['ราคา'][0].toString();

        int dotIndex = price.indexOf(".");
        if (dotIndex != -1 && dotIndex + 3 <= price.length) {
          priceChoose.last = price.substring(0, dotIndex + 3);
        } else {
          priceChoose.last = price;
        }

        // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

        // print(unitChoose.last);
        // print(priceChoose.last);

        // print(element);
      }

      // print('========= โซนดึงสินค้ารายการเก่า ============');

      if (orderLast!['ProductList'] == []) {
      } else {
        dynamicList = orderLast!['ProductList'];

        nonNullableList = dynamicList!.cast<Map<String, dynamic>>();

        for (int i = 0; i < nonNullableList!.length; i++) {
          // print(nonNullableList![i]['ProductID']);
          // print(nonNullableList![i]['ProductID']);
          // print(nonNullableList![i]['ProductID']);

          // print(nonNullableList![i]['ยูนิต']);
          // print(nonNullableList![i]['ยูนิต']);
          // print(nonNullableList![i]['ยูนิต']);

          Map<String, dynamic> dataMap = sellPrices.firstWhere((element) =>
              element['PRODUCT_ID'] == nonNullableList![i]['ProductID'] &&
              element['UNIT'] == nonNullableList![i]['ยูนิต']);

          // for (int i = 0; i < sellPrices.length; i++) {
          //   // print("RESULT: ${sellPrice['RESULT']}");
          //   // print("PRODUCT_ID: ${sellPrice['PRODUCT_ID']}");
          //   // print("SALES_PRICE_ID: ${sellPrice['SALES_PRICE_ID']}");
          //   // print("NAMES: ${sellPrice['NAMES']}");
          //   // print("PRICE: ${sellPrice['PRICE']}");
          //   // print("UNIT: ${sellPrice['UNIT']}");
          //   // print(i);
          //   // print(sellPrices[i]['PRODUCT_ID']);
          //   // print("-------------------");

          //   if (sellPrices[i]['PRODUCT_ID'] == '0291056100062') {
          //     // print(sellPrices[i]['PRODUCT_ID']);

          //     // print(sellPrices[i]['NAMES']);
          //     // print(sellPrices[i]['UNIT']);
          //     // print(sellPrices[i]['PRICE']);
          //     // print(sellPrices[i]);
          //   }
          // }

          // print('======== โหลดราคาสินค้าที่ผู้กับประวัติ ===========');

          if (dataMap.isNotEmpty) {
            // print(dataMap['PRICE'].runtimeType);
            // print(dataMap['PRICE'].runtimeType);
            // print(dataMap['PRICE'].runtimeType);

            String totalPriceAsString =
                double.parse(dataMap['PRICE'].toString()).toStringAsFixed(2);
            nonNullableList![i]['ราคา'] = totalPriceAsString;
          }
          // print(nonNullableList![i]['ราคา']);
          // print(nonNullableList![i]['ราคา']);
          // print(nonNullableList![i]['ราคา']);
        }
        orderLast!['ProductList'] = nonNullableList;

        // print(orderLast!['ProductList']);
      }

      // print('/////////////////////////////////////////////////////');
      // print('/////////////////////////////////////////////////////');
      // print('/////////////////                        ////////////');
      // print('////////// ${resultList.length} ////////');
      // print('////////////////                         ////////////');
      // print('/////////////////////////////////////////////////////');
      // print('/////////////////////////////////////////////////////');
      // print('/////////////////////////////////////////////////////');
    }

    if (productGroupGetData != null) {
      Map<String, dynamic> allProduct = {
        'GroupProductID': 'สินค้าทั้งหมด',
        'IMG':
            'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/ProductGroup%2FAllProduct%2Fสินค้าทั้งหมด.png?alt=media&token=8b600e77-bd1c-4f93-b14b-6988cdd04030',
        'GROUP_SHOW': 'สินค้าทั้งหมด',
        'GROUP_DESC': 'สินค้าทั้งหมด'
      };
      resultProductGroupList.add(allProduct);

      // Map<String, dynamic> specialPriceProduct = {
      //   'GroupProductID': 'ราคาพิเศษ',
      //   'IMG': 'ราคาพิเศษ',
      //   'GROUP_SHOW': 'ราคาพิเศษ',
      //   'GROUP_DESC': 'ราคาพิเศษ'
      // };
      // resultProductGroupList.add(specialPriceProduct);
      Map<String, dynamic> favProduct = {
        'GroupProductID': 'สินค้า Favorite',
        'IMG':
            'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/ProductGroup%2FFavIcon%2FFavorite.jpg?alt=media&token=8a298506-5bcd-452e-bfd6-36b7bd81ef1c',
        'GROUP_SHOW': 'สินค้าชื่นชอบ',
        'GROUP_DESC': 'สินค้าชื่นชอบ'
      };
      resultProductGroupList.add(favProduct);

      Map<String, dynamic> historyProduct = {
        'GroupProductID': 'สินค้าที่เคยสั่งซื้อ',
        'IMG':
            'https://firebasestorage.googleapis.com/v0/b/mfood-1a0a3.appspot.com/o/ProductGroup%2FHistoryIcon%2Fสินค้าที่เคยสั่งซื้อ.png?alt=media&token=329fab93-213f-44c1-b524-56d11c9bd2aa',
        'GROUP_SHOW': 'สินค้าที่เคยสั่งซื้อ',
        'GROUP_DESC': 'สินค้าที่เคยสั่งซื้อ'
      };
      resultProductGroupList.add(historyProduct);

      for (var element in tagProductList) {
        Map<String, dynamic> tagProduct = {
          'GroupProductID': element['DocId'],
          'IMG': element['IMG'],
          'GROUP_SHOW': element['Name'],
          'GROUP_DESC': element['Name']
        };
        resultProductGroupList.add(tagProduct);
      }

      productGroupGetData!.forEach((key, value) {
        // print(value);
        Map<String, dynamic> entry = value;

        // print(entry);

        resultProductGroupList.add(entry);
      });
    }

    int totalLength = resultProductGroupList.length;

    // print('จำนวนกลุ่มทั้งหมด');
    // print(totalLength);
    int firstListLength = totalLength ~/ 2 + totalLength % 2;
    int secondListLength = totalLength - firstListLength;

    firstList = resultProductGroupList.sublist(0, firstListLength);
    secondList = resultProductGroupList.sublist(firstListLength);
    // print(firstList.length);
    // print(resultList.length);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshProductListFav() async {}

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

  bool isMoreThanThreeMonthsAgo(DateTime date) {
    DateTime currentDate = DateTime.now();
    DateTime threeMonthsAgo =
        currentDate.subtract(Duration(days: 90)); // คำนวณวันที่ 3 เดือนก่อนหน้า

    return date.isBefore(threeMonthsAgo);
  }

  void changeGroupProductList(String nameGroup) {
    checkFavGroup = nameGroup;

    searchTextController.clear();
    print(nameGroup);

    bool isStringFound = tagProductList.any((map) => map['Name'] == nameGroup);
    productList.clear();

    if (isStringFound) {
      print('พบสตริงที่ค้นหาในฟิลด์แท๊ก \'Name\' $nameGroup');

      // List<Map<String, dynamic>> checkProduct = resultList;
      List<Map<String, dynamic>> checkProduct = List.from(resultList);
      checkProduct.removeWhere((map) {
        bool returnType = true;
        for (int i = 0; i < map['แท๊ก'].length; i++) {
          if (map['แท๊ก'][i] == nameGroup) {
            returnType = false;
          }
        }

        return returnType;
      });

      productList.addAll(checkProduct);

      print(productList);

      productCount.clear();
      inModalDialog.clear();

      for (var element in productList) {
        productCount.add(0);
        inModalDialog.add(TextEditingController(text: ''));
      }
      productList.sort((a, b) {
        var aReadyToSell = a['สถานะพร้อมขาย'] ?? false;
        var bReadyToSell = b['สถานะพร้อมขาย'] ?? false;

        // หากเป็นจริงอยู่ด้านหน้าทั้งหมด
        if (aReadyToSell && !bReadyToSell) {
          return -1;
        } else if (!aReadyToSell && bReadyToSell) {
          // หากเป็นเท็จไปอยู่ด้านหลัง
          return 1;
        } else {
          // ในกรณีอื่น ๆ ให้เรียงตามลำดับเดิม
          return 0;
        }
      });

      unitChoose.clear();
      priceChoose.clear();

      for (var element in productList) {
        unitChoose.add('');
        priceChoose.add('');
        unitChoose.last =
            element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

        String price = '';
        price = element['ราคา'].isEmpty
            ? element['PRICE'].toString()
            : element['ราคา'][0].toString();

        int dotIndex = price.indexOf(".");
        if (dotIndex != -1 && dotIndex + 3 <= price.length) {
          priceChoose.last = price.substring(0, dotIndex + 3);
        } else {
          priceChoose.last = price;
        }

        // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

        // print(unitChoose.last);
        // print(priceChoose.last);

        // print(element);
      }
    } else if (nameGroup == 'สินค้าชื่นชอบ' ||
        nameGroup == 'สินค้าที่เคยสั่งซื้อ') {
      print('พบสตริงที่ค้นหาในฟิลด์พิเศษ \'Name\' $nameGroup');
      print(userData!['สินค้าถูกใจ']);
      print(userData!['สินค้าที่เคยสั่ง']);
      productList.clear();
      String text = '';
      if (nameGroup == 'สินค้าชื่นชอบ') {
        text = 'สินค้าถูกใจ';
      } else {
        text = 'สินค้าที่เคยสั่ง';
      }

      List<dynamic> listHistoryDate = userData!['สินค้าที่เคยสั่ง_วันที่'];
      // print(listHistoryDate);
      List<DateTime?>? listHistoryStringDate = [];

      if (text == 'สินค้าที่เคยสั่ง') {
        for (int i = 0; i < listHistoryDate.length; i++) {
          // print(listHistoryDate[i].toString());
          Timestamp timestamp = listHistoryDate[i];
          // print(timestamp.toString());
          DateTime dateTime = timestamp.toDate();
          // print(dateTime);

          listHistoryStringDate.add(dateTime);
        }
      }
      // print('111');
      // print(listHistoryStringDate);

      // List<Map<String, dynamic>> checkProduct = resultListAll;
      List<Map<String, dynamic>> checkProduct = List.from(resultList);
      checkProduct.removeWhere((map) {
        bool returnType = true;
        for (int i = 0; i < userData![text].length; i++) {
          if (text == 'สินค้าที่เคยสั่ง') {
            if (userData![text][i] == map['PRODUCT_ID']) {
              if (text == 'สินค้าที่เคยสั่ง') {
                // print(userData![text]);

                // print(listHistoryStringDate);
                bool result =
                    isMoreThanThreeMonthsAgo(listHistoryStringDate[i]!);
                if (result) {
                  print('เกิน 3 เดือน');
                  // เกิน 3 เดือน
                } else {
                  print('ไม่เกิน 3 เดือน');

                  // ไม่เกิน 3 เดือน
                  returnType = false;
                }
              } else {
                returnType = false;
              }
            }
          }
        }

        if (text == 'สินค้าถูกใจ') {
          for (int i = 0; i < customerDataFetch![text].length; i++) {
            if (customerDataFetch![text][i] == map['PRODUCT_ID']) {
              returnType = false;
            }
          }
        }

        return returnType;
      });

      productList.addAll(checkProduct);

      // print(productList);

      productCount.clear();
      inModalDialog.clear();
      for (var element in productList) {
        productCount.add(0);
        inModalDialog.add(TextEditingController(text: ''));
      }
      productList.sort((a, b) {
        var aReadyToSell = a['สถานะพร้อมขาย'] ?? false;
        var bReadyToSell = b['สถานะพร้อมขาย'] ?? false;

        // หากเป็นจริงอยู่ด้านหน้าทั้งหมด
        if (aReadyToSell && !bReadyToSell) {
          return -1;
        } else if (!aReadyToSell && bReadyToSell) {
          // หากเป็นเท็จไปอยู่ด้านหลัง
          return 1;
        } else {
          // ในกรณีอื่น ๆ ให้เรียงตามลำดับเดิม
          return 0;
        }
      });

      unitChoose.clear();
      priceChoose.clear();

      for (var element in productList) {
        unitChoose.add('');
        priceChoose.add('');
        unitChoose.last =
            element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

        String price = '';
        price = element['ราคา'].isEmpty
            ? element['PRICE'].toString()
            : element['ราคา'][0].toString();

        int dotIndex = price.indexOf(".");
        if (dotIndex != -1 && dotIndex + 3 <= price.length) {
          priceChoose.last = price.substring(0, dotIndex + 3);
        } else {
          priceChoose.last = price;
        }

        // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

        // print(unitChoose.last);
        // print(priceChoose.last);

        // print(element);
      }
    } else {
      print('ไม่พบสตริงที่ค้นหาในฟิลด์แท๊ก \'Name\'');
      if (nameGroup == 'สินค้าทั้งหมด') {
        productList.clear();

        productList.addAll(resultList);

        productCount.clear();
        inModalDialog.clear();

        for (var element in productList) {
          productCount.add(0);
          inModalDialog.add(TextEditingController(text: ''));
        }
      } else if (nameGroup == 'ราคาพิเศษ') {
        productList.clear();

        // List<Map<String, dynamic>> checkProduct = resultList;
        List<Map<String, dynamic>> checkProduct = List.from(resultList);
        checkProduct.removeWhere((map) => map['ราคาพิเศษ'] == false);

        productList.addAll(checkProduct);

        productCount.clear();
        inModalDialog.clear();
        for (var element in productList) {
          productCount.add(0);
          inModalDialog.add(TextEditingController(text: ''));
        }
      } else {
        productList.clear();
        productList =
            resultList.where((product) => product['PG2'] == nameGroup).toList();

        productCount.clear();
        inModalDialog.clear();

        for (var element in productList) {
          productCount.add(0);
          inModalDialog.add(TextEditingController(text: ''));
        }
      }

      productList.sort((a, b) {
        var aReadyToSell = a['สถานะพร้อมขาย'] ?? false;
        var bReadyToSell = b['สถานะพร้อมขาย'] ?? false;

        // หากเป็นจริงอยู่ด้านหน้าทั้งหมด
        if (aReadyToSell && !bReadyToSell) {
          return -1;
        } else if (!aReadyToSell && bReadyToSell) {
          // หากเป็นเท็จไปอยู่ด้านหลัง
          return 1;
        } else {
          // ในกรณีอื่น ๆ ให้เรียงตามลำดับเดิม
          return 0;
        }
      });

      unitChoose.clear();
      priceChoose.clear();

      for (var element in productList) {
        unitChoose.add('');
        priceChoose.add('');
        unitChoose.last =
            element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

        String price = '';
        price = element['ราคา'].isEmpty
            ? element['PRICE'].toString()
            : element['ราคา'][0].toString();

        int dotIndex = price.indexOf(".");
        if (dotIndex != -1 && dotIndex + 3 <= price.length) {
          priceChoose.last = price.substring(0, dotIndex + 3);
        } else {
          priceChoose.last = price;
        }

        // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

        // print(unitChoose.last);
        // print(priceChoose.last);

        // print(element);
      }
    }

    print(productList.length);
    if (mounted) {
      setState(() {});
    }
  }

  void findNameProductList(String nameProduct) {
    print(nameProduct);

    productList.clear();

    productList = resultList
        .where((product) =>
            product['NAMES'].contains(nameProduct) ||
            product['PRODUCT_ID'].contains(nameProduct))
        .toList();

    productCount.clear();
    inModalDialog.clear();

    for (var element in productList) {
      productCount.add(0);
      inModalDialog.add(TextEditingController(text: ''));
    }

    productList.sort((a, b) {
      var aReadyToSell = a['สถานะพร้อมขาย'] ?? false;
      var bReadyToSell = b['สถานะพร้อมขาย'] ?? false;

      // หากเป็นจริงอยู่ด้านหน้าทั้งหมด
      if (aReadyToSell && !bReadyToSell) {
        return -1;
      } else if (!aReadyToSell && bReadyToSell) {
        // หากเป็นเท็จไปอยู่ด้านหลัง
        return 1;
      } else {
        // ในกรณีอื่น ๆ ให้เรียงตามลำดับเดิม
        return 0;
      }
    });

    unitChoose.clear();
    priceChoose.clear();

    for (var element in productList) {
      unitChoose.add('');
      priceChoose.add('');
      unitChoose.last =
          element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

      String price = '';
      price = element['ราคา'].isEmpty
          ? element['PRICE'].toString()
          : element['ราคา'][0].toString();

      int dotIndex = price.indexOf(".");
      if (dotIndex != -1 && dotIndex + 3 <= price.length) {
        priceChoose.last = price.substring(0, dotIndex + 3);
      } else {
        priceChoose.last = price;
      }

      // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

      print(unitChoose.last);
      print(priceChoose.last);

      print(element);
    }

    print(productList.length);
    if (mounted) {
      setState(() {});
    }
  }

  void decrement(
      int index, int number, void Function(VoidCallback) setStateFunc) {
    if (productCount[index] > 0) {
      setStateFunc(() {
        productCount[index]--;
      });
    }
  }

  void increment(
      int index, int number, void Function(VoidCallback) setStateFunc) {
    setStateFunc(() {
      productCount[index]++;
    });
  }

  String _selectedOption = 'Option 1';
  void _showPopupMenu(BuildContext context) async {
    final selectedOption = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(0, 100, 0, 0), // ปรับตำแหน่งตามต้องการ
      items: [
        PopupMenuItem<String>(
          value: 'Option 1',
          child: Text('Option 1'),
        ),
        PopupMenuItem<String>(
          value: 'Option 2',
          child: Text('Option 2'),
        ),
        PopupMenuItem<String>(
          value: 'Option 3',
          child: Text('Option 3'),
        ),
      ],
      elevation: 8, // ปรับระดับเงาตามต้องการ
    );

    if (selectedOption != null) {
      setState(() {
        _selectedOption = selectedOption;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A0903 Product Screen');
    print('==============================');

    // print(widget.orderDataMap);
    print(widget.customerID);

    // print(userData!['สินค้าที่เคยสั่ง_วันที่']);

    // for (int j = 0; j < productList.length; j++) {
    //   if (productList[j]['ราคาพิเศษ'] == true) print(productList[j]['DocId']);
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
            : Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
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
                                          Navigator.pop(
                                              context, widget.orderDataMap);
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
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: 25.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent3,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              alignment: AlignmentDirectional(0.00, 0.00),
                              child: TextFormField(
                                // controller: _model.textController,
                                // focusNode: _model.textFieldFocusNode,
                                onChanged: (value) {
                                  findNameProductList(value);
                                },
                                controller: searchTextController,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: Color(0xFFCBCBCB),
                                      ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                // validator: _model.textControllerValidator.asValidator(context),
                              ),
                            ),
                          ],
                        ),
                        // Column(
                        //   mainAxisSize: MainAxisSize.max,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       'เปิดหน้าบัญชีใหม่เข้าระบบ',
                        //       style: FlutterFlowTheme.of(context)
                        //           .titleMedium
                        //           .override(
                        //             fontFamily: 'Kanit',
                        //             color: FlutterFlowTheme.of(context).primaryText,
                        //           ),
                        //     ),
                        //   ],
                        // ),
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
                    //============== หมวดหมู่สินค้า =====================================
                    // //==================== category group ================================
                    // for (int index = 0; index < firstList.length; index++)
                    //   Text(firstList[index]['ชื่อกลุ่ม']),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  for (int index = 0;
                                      index < firstList.length;
                                      index++)
                                    GestureDetector(
                                      onTap: () {
                                        changeGroupProductList(
                                            firstList[index]['GROUP_DESC']);
                                      },
                                      child: Container(
                                        // color: Colors.red,
                                        width: 70.0,
                                        height: 55.0,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: firstList[index]['IMG'] ==
                                                      ''
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          Colors.green.shade400,
                                                      child: const Icon(
                                                        Icons.bookmark,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ))
                                                  : firstList[index]['IMG'] ==
                                                          'ราคาพิเศษ'
                                                      ? CircleAvatar(
                                                          backgroundColor:
                                                              Colors.orange
                                                                  .shade400,
                                                          child: const Icon(
                                                            Icons.discount,
                                                            size: 25,
                                                            color: Colors.white,
                                                          ))
                                                      : Image.network(
                                                          firstList[index]
                                                              ['IMG'],
                                                          width: 35.0,
                                                          height: 35.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                            Container(
                                              // color: Colors.yellow,
                                              width: 70.0,
                                              alignment: Alignment.center,
                                              // height: 35.0,
                                              child: Text(
                                                firstList[index]['GROUP_SHOW'],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  for (int index = 0;
                                      index < secondList.length;
                                      index++)
                                    GestureDetector(
                                      onTap: () {
                                        changeGroupProductList(
                                            secondList[index]['GROUP_DESC']);
                                      },
                                      child: Container(
                                        // color: Colors.red,
                                        width: 70.0,
                                        height: 55.0,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: Image.network(
                                                secondList[index]['IMG'],
                                                width: 35.0,
                                                height: 35.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              // color: Colors.yellow,
                                              width: 70.0,
                                              alignment: Alignment.center,
                                              // height: 35.0,
                                              child: Text(
                                                secondList[index]['GROUP_SHOW'],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //============== รวมรายการสินค้า =====================================
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 10.0),
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                height: 35.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).accent3,
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
                                        child: Container(
                                          // color: Colors.red,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รวมรายการสินค้า ${NumberFormat('#,##0').format(orderLast!['ยอดรวม']).toString()} บาท',
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
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // context.pushNamed('A11_05_ProductTotalDetail');

                                        if (orderLast!['ProductList'].isEmpty) {
                                          print('ตระกร้าว่างเปล่า');
                                          Fluttertoast.showToast(
                                              msg: 'ตระกร้าของคุณว่่างเปล่าค่ะ',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor:
                                                  Colors.red.shade900,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          print('ตระกร้ามีสินค้า');

                                          List<String> imageList = [];

                                          for (var elementList
                                              in orderLast!['ProductList']) {
                                            print('0');
                                            Map<String, dynamic>? result =
                                                resultList.firstWhere(
                                              (element) =>
                                                  element['DocId'] ==
                                                  elementList['DocID'],
                                              orElse: () => {},
                                            );
                                            print('01');
                                            imageList.add(
                                                result['รูปภาพ'] == null ||
                                                        result['รูปภาพ'].isEmpty
                                                    ? ''
                                                    : result['รูปภาพ'][0]);
                                          }
                                          print('1');

                                          Map<String, dynamic>? result =
                                              await Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        A0904ProductOrderDetail(
                                                      customerID:
                                                          widget.customerID,
                                                      imageProduct: imageList,
                                                      orderDataMap: orderLast,
                                                    ),
                                                  ));
                                          print('2');

                                          orderLast = result;

                                          if (mounted) {
                                            setState(() {});
                                          }
                                        }
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 33.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .success,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
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
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red, // สีของ badge
                                  ),
                                  child: Text(
                                    orderLast!['ProductList'].length.toString(),
                                    style: TextStyle(
                                      color:
                                          Colors.white, // สีของตัวอักษรใน badge
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    //=================== สินค้าทั้งหมด ===============================
                    Expanded(
                      child: GridView(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio:
                              MediaQuery.sizeOf(context).width >= 800.0
                                  ? 0.57
                                  : 0.52,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          //=================== สินค้า ===============================\
                          for (int i = 0; i < productList.length; i++)
                            StatefulBuilder(builder: (context, setState) {
                              return Container(
                                // color: Colors.red,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      height:
                                          MediaQuery.sizeOf(context).width >=
                                                  800.0
                                              ? 280.0
                                              : 220.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                          width: 1.0,
                                        ),
                                      ),
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                        .width >=
                                                    800.0
                                                ? 240.0
                                                : 191.0,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                1.0,
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.00, 0.00),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 10.0),
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
                                                        await Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  A090301ProductDetail(
                                                                customerID: widget
                                                                    .customerID,
                                                                orderDataMap:
                                                                    orderLast,
                                                                product:
                                                                    productList[
                                                                        i],
                                                                productListAll:
                                                                    productList,
                                                              ),
                                                            )).then((result) {
                                                          // ตรวจสอบค่าที่ถูกส่งกลับมา

                                                          print('after then');
                                                          if (result != null &&
                                                              result is Map<
                                                                  String,
                                                                  dynamic>) {
                                                            List<dynamic>
                                                                favList =
                                                                result[
                                                                    'favListID'];

                                                            customerDataFetch![
                                                                    'สินค้าถูกใจ'] =
                                                                favList;

                                                            print(favList);
                                                            print(favList);
                                                            print(favList);
                                                            print(favList);
                                                            print(favList);
                                                            for (int i = 0;
                                                                i <
                                                                    resultList
                                                                        .length;
                                                                i++) {
                                                              for (int j = 0;
                                                                  j <
                                                                      favList
                                                                          .length;
                                                                  j++) {
                                                                if (resultList[
                                                                            i][
                                                                        'PRODUCT_ID'] ==
                                                                    favList[
                                                                        j]) {
                                                                  resultList[i][
                                                                          'Favorite'] =
                                                                      true;

                                                                  print(
                                                                      'อยู่ใน if');

                                                                  print(resultList[
                                                                          i][
                                                                      'PRODUCT_ID']);

                                                                  print(resultList[
                                                                              i]
                                                                          [
                                                                          'Favorite'] =
                                                                      true);
                                                                }
                                                              }
                                                            }
                                                            // resultList = result[
                                                            //     'productList'];
                                                            Map<String, dynamic>
                                                                orderList =
                                                                result[
                                                                    'orderLast'];
                                                            String
                                                                additionalString =
                                                                result[
                                                                    'groupName'];
                                                            print(
                                                                additionalString);

                                                            print(orderList[
                                                                    'ProductList']
                                                                .length);

                                                            if (additionalString
                                                                .isEmpty) {
                                                              print('is Empty');
                                                              orderLast =
                                                                  orderList;
                                                              if (mounted) {
                                                                toSetState();

                                                                setState(() {});
                                                              }
                                                            } else {
                                                              // resultList = result[
                                                              //     'productList'];

                                                              List<dynamic>
                                                                  favList =
                                                                  result[
                                                                      'favListID'];

                                                              customerDataFetch![
                                                                      'สินค้าถูกใจ'] =
                                                                  favList;
                                                              print(favList);
                                                              print(favList);
                                                              print(favList);
                                                              print(favList);
                                                              print(favList);
                                                              for (int i = 0;
                                                                  i <
                                                                      resultList
                                                                          .length;
                                                                  i++) {
                                                                for (int j = 0;
                                                                    j <
                                                                        favList
                                                                            .length;
                                                                    j++) {
                                                                  if (resultList[
                                                                              i]
                                                                          [
                                                                          'PRODUCT_ID'] ==
                                                                      favList[
                                                                          j]) {
                                                                    resultList[i]
                                                                            [
                                                                            'Favorite'] =
                                                                        true;

                                                                    print(
                                                                        'อยู่ใน else');

                                                                    print(resultList[
                                                                            i][
                                                                        'PRODUCT_ID']);

                                                                    print(resultList[i]
                                                                            [
                                                                            'Favorite'] =
                                                                        true);
                                                                  }
                                                                }
                                                              }
                                                              changeGroupProductList(
                                                                  additionalString);

                                                              orderLast =
                                                                  orderList;

                                                              print(orderLast!
                                                                  .keys.length);

                                                              if (mounted) {
                                                                toSetState();
                                                                setState(() {});
                                                              }
                                                            }

                                                            print(orderLast![
                                                                'ยอดรวม']);
                                                            print(orderLast![
                                                                'ยอดรวม']);
                                                            print(orderLast![
                                                                'ยอดรวม']);
                                                            print(orderLast![
                                                                'ยอดรวม']);

                                                            // ทำอะไรก็ตามที่ต้องการกับข้อมูลที่ถูกส่งกลับมา
                                                          }
                                                        });
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: productList[i][
                                                                        'รูปภาพ'] ==
                                                                    null ||
                                                                productList[i][
                                                                        'รูปภาพ']
                                                                    .isEmpty
                                                            ? Image.asset(
                                                                'assets/images/noproductimage.png',
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.2,
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.2,
                                                                fit: BoxFit
                                                                    .contain,
                                                              )
                                                            : productList[i][
                                                                            'รูปภาพ']
                                                                        [0] ==
                                                                    ''
                                                                ? Image.asset(
                                                                    'assets/images/noproductimage.png',
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.2,
                                                                    height:
                                                                        MediaQuery.sizeOf(context).height *
                                                                            0.2,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  )
                                                                : Image.network(
                                                                    // '',
                                                                    productList[
                                                                            i][
                                                                        'รูปภาพ'][0],
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.2,
                                                                    height:
                                                                        MediaQuery.sizeOf(context).height *
                                                                            0.2,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),

                                                        //  productList[i]['รูปภาพ']
                                                        //                 [0] ==
                                                        //             '' ||
                                                        //         productList[i]
                                                        //                 ['รูปภาพ'] ==
                                                        //             null
                                                        //     ? Image.asset(
                                                        //         'assets/images/noproductimage.png',
                                                        //         width:
                                                        //             MediaQuery.sizeOf(
                                                        //                         context)
                                                        //                     .width *
                                                        //                 0.2,
                                                        //         height:
                                                        //             MediaQuery.sizeOf(
                                                        //                         context)
                                                        //                     .height *
                                                        //                 0.2,
                                                        //         fit: BoxFit.contain,
                                                        //       )
                                                        //     : Image.network(
                                                        //         // '',
                                                        //         productList[i]['รูปภาพ']
                                                        //             [0],
                                                        //         width:
                                                        //             MediaQuery.sizeOf(
                                                        //                         context)
                                                        //                     .width *
                                                        //                 0.2,
                                                        //         height:
                                                        //             MediaQuery.sizeOf(
                                                        //                         context)
                                                        //                     .height *
                                                        //                 0.2,
                                                        //         fit: BoxFit.contain,
                                                        //       ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          1.00, -1.00),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                15.0, 0.0),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        if (productList[i]
                                                                ['Favorite'] ==
                                                            true) {
                                                          productList[i]
                                                                  ['Favorite'] =
                                                              false;
                                                          //Edit Favorite 24 06 2567

                                                          // List<dynamic>
                                                          //     listFav =
                                                          //     userData![
                                                          //         'สินค้าถูกใจ'];
                                                          List<dynamic>
                                                              listFav =
                                                              customerDataFetch![
                                                                  'สินค้าถูกใจ'];

                                                          listFav.removeWhere(
                                                              (element) =>
                                                                  element ==
                                                                  productList[i]
                                                                      [
                                                                      'PRODUCT_ID']);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(AppSettings
                                                                          .customerType ==
                                                                      CustomerType
                                                                          .Test
                                                                  ? 'CustomerTest'
                                                                  : 'Customer')
                                                              // .collection(
                                                              //     'User')
                                                              // .doc(userData![
                                                              //     'UserID'])
                                                              .doc(customerDataFetch[
                                                                  'CustomerID'])
                                                              .update(
                                                            {
                                                              'สินค้าถูกใจ':
                                                                  listFav,
                                                            },
                                                          ).then((value) {
                                                            if (checkFavGroup ==
                                                                'สินค้าชื่นชอบ') {
                                                              changeGroupProductList(
                                                                  'สินค้าชื่นชอบ');
                                                            }

                                                            if (mounted) {
                                                              setState(() {});
                                                            }
                                                          });
                                                        } else {
                                                          productList[i]
                                                                  ['Favorite'] =
                                                              true;
                                                          // List<dynamic>
                                                          //     listFav =
                                                          //     userData![
                                                          //         'สินค้าถูกใจ'];

                                                          List<dynamic>
                                                              listFav =
                                                              customerDataFetch![
                                                                  'สินค้าถูกใจ'];
                                                          listFav.add(
                                                              productList[i][
                                                                  'PRODUCT_ID']);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(AppSettings
                                                                          .customerType ==
                                                                      CustomerType
                                                                          .Test
                                                                  ? 'CustomerTest'
                                                                  : 'Customer')

                                                              // .collection(
                                                              //     'User')
                                                              // .doc(userData![
                                                              //     'UserID'])
                                                              .doc(customerDataFetch[
                                                                  'CustomerID'])
                                                              .update(
                                                            {
                                                              'สินค้าถูกใจ':
                                                                  listFav,
                                                            },
                                                          ).then((value) {
                                                            if (checkFavGroup ==
                                                                'สินค้าชื่นชอบ') {
                                                              changeGroupProductList(
                                                                  'สินค้าชื่นชอบ');
                                                            }

                                                            if (mounted) {
                                                              setState(() {});
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: Icon(
                                                        productList[i][
                                                                    'Favorite'] ==
                                                                true
                                                            ? Icons
                                                                .favorite_sharp
                                                            : Icons
                                                                .favorite_border_sharp,
                                                        color: productList[i][
                                                                    'Favorite'] ==
                                                                true
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                                  1.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: SizedBox(
                                                        width: productList[i]
                                                                    ['แท๊ก']
                                                                .isEmpty
                                                            ? 235
                                                            : 145,
                                                        child: Text(
                                                          productList[i]
                                                              ['NAMES'],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                lineHeight:
                                                                    1.25,
                                                              ),
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                productList[i][
                                                            'ประเภทสินค้าDesc'] ==
                                                        null
                                                    ? Text(
                                                        'ไม่มีประเภทสินค้า',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleSmall
                                                            .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: Colors.red
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                lineHeight:
                                                                    1.25,
                                                                fontSize: 12),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.clip,
                                                      )
                                                    : Text(
                                                        productList[i][
                                                                    'ประเภทสินค้าDesc'] ==
                                                                'สินค้าเคลื่อนไหวเร็ว (Fast Moving)'
                                                            ? 'Fast Moving'
                                                            : productList[i][
                                                                        'ประเภทสินค้าDesc'] ==
                                                                    'สินค้าที่ต้องสั่งจองล่วงหน้า (Pre-Order)'
                                                                ? 'Pre-Order'
                                                                : productList[i]
                                                                            [
                                                                            'ประเภทสินค้าDesc'] ==
                                                                        'สินค้าที่โรงงานผลิต​ (PCF)'
                                                                    ? 'PCF'
                                                                    : 'ไม่มีประเภทสินค้า',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleSmall
                                                            .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: Colors.red
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                lineHeight:
                                                                    1.25,
                                                                fontSize: 12),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'ราคา ${priceChoose[i]} บาท',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            lineHeight: 1.25,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            productList[i]['แท๊ก'].isEmpty
                                                ? SizedBox()
                                                : Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    10.0,
                                                                    0.0),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 75,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        4.0,
                                                                        10.0,
                                                                        4.0),
                                                            child: Text(
                                                              '${productList[i]['แท๊ก'][0]}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Kanit',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // width: MediaQuery.sizeOf(context).width * 1.0,
                                      // height: 50,
                                      decoration: BoxDecoration(),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 3.0, 10.0, 4.0),
                                        child:
                                            // HtmlWidget(
                                            //   '${productList[i]['รายละเอียด'] == null ? '' : productList[i]['รายละเอียด']}',
                                            //   // textStyle: TextStyle(
                                            //   //   fontFamily: 'GreenHome',
                                            //   // ),
                                            //   textStyle: FlutterFlowTheme.of(context)
                                            //       .bodySmall
                                            //       .override(
                                            //         fontFamily: 'Kanit',
                                            //         fontSize:
                                            //             MediaQuery.sizeOf(context).width >=
                                            //                     800.0
                                            //                 ? 13.0
                                            //                 : 10.0,
                                            //         fontWeight: FontWeight.w500,
                                            //         lineHeight: 1.25,
                                            //       ),
                                            // ),

                                            Text(
                                          '${productList[i]['รายละเอียดสตริง'] == '' ? '\n\n' : productList[i]['รายละเอียดสตริง']}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Kanit',
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                                .width >=
                                                            800.0
                                                        ? 13.0
                                                        : 10.0,
                                                fontWeight: FontWeight.w500,
                                                lineHeight: 1.25,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .accent2,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 30.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () =>
                                                              decrement(
                                                            i,
                                                            productCount[i],
                                                            setState,
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
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
                                                              FontAwesomeIcons
                                                                  .minus,
                                                              color:
                                                                  Colors.black,
                                                              size: 12.0,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await showModalBottomSheet(
                                                              isDismissible:
                                                                  false,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          40.0), // ตั้งค่าเพื่อทำให้มุมบนสองข้างเป็นโค้ง
                                                                ),
                                                              ),
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  height: 300,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              60),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40)),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'กรุณากรอกจำนวนที่ต้องการค่ะ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              24.0,
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          letterSpacing:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            inModalDialog[i],
                                                                        onEditingComplete:
                                                                            () async {
                                                                          inModalDialog[i]
                                                                              .clear();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          setState(
                                                                            () {},
                                                                          );
                                                                        },
                                                                        onChanged:
                                                                            (value) async {
                                                                          print(
                                                                              i);
                                                                          print(
                                                                              productCount[i]);
                                                                          productCount[i] =
                                                                              int.parse(value);
                                                                          print(
                                                                              productCount[i]);

                                                                          setState(
                                                                            () {},
                                                                          );
                                                                        },
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        textAlign:
                                                                            TextAlign.center, // กำหนดให้ข้อความอยู่ตรงกลาง
                                                                        decoration:
                                                                            InputDecoration(
                                                                          contentPadding: EdgeInsets.symmetric(
                                                                              vertical: 12.0,
                                                                              horizontal: 10.0), // กำหนดระยะห่างของข้อความ
                                                                          hintText:
                                                                              'กรอกจำนวนสินค้า', // ข้อความ placeholder
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            // เพิ่มเส้นขอบ
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.grey, // สีขอบ
                                                                              width: 1.0, // ความกว้างของขอบ
                                                                            ),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            // เพิ่มเส้นขอบเมื่อสถานะ enable
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.grey, // สีขอบ
                                                                              width: 1.0, // ความกว้างของขอบ
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            // เพิ่มเส้นขอบเมื่อสถานะ focus
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.blue, // สีขอบเมื่อ focus
                                                                              width: 2.0, // ความกว้างของขอบเมื่อ focus
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (inModalDialog[i].text.isEmpty) {
                                                                              print('ไม่ได้กรอกจำนวน');
                                                                              Navigator.of(context).pop();
                                                                            } else {
                                                                              print(inModalDialog[i].text);
                                                                              productCount[i] = int.parse(inModalDialog[i].text);

                                                                              print(productCount[i]);

                                                                              inModalDialog[i].clear();
                                                                              Navigator.of(context).pop();

                                                                              setState(
                                                                                () {},
                                                                              );
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'ตกลง',
                                                                            style:
                                                                                TextStyle(
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
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor
                                                                  .withOpacity(
                                                                      0.2),
                                                            ),
                                                            child: Text(
                                                              productCount[i]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.0,
                                                                fontFamily:
                                                                    'Kanit',
                                                                letterSpacing:
                                                                    2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              increment(
                                                            i,
                                                            productCount[i],
                                                            setState,
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            decoration: BoxDecoration(
                                                                // shape: BoxShape.circle,
                                                                // color: Theme.of(context)
                                                                //     .primaryColor,
                                                                ),
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .plus,
                                                              color:
                                                                  Colors.black,
                                                              size: 12.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                    // return FlutterFlowCountController(
                                                    //   decrementIconBuilder:
                                                    //       (enabled) => FaIcon(
                                                    //     FontAwesomeIcons.minus,
                                                    //     color: enabled
                                                    //         ? FlutterFlowTheme.of(
                                                    //                 context)
                                                    //             .secondaryText
                                                    //         : FlutterFlowTheme.of(
                                                    //                 context)
                                                    //             .error,
                                                    //     size: 18.0,
                                                    //   ),
                                                    //   incrementIconBuilder:
                                                    //       (enabled) => FaIcon(
                                                    //     FontAwesomeIcons.plus,
                                                    //     color: enabled
                                                    //         ? FlutterFlowTheme.of(
                                                    //                 context)
                                                    //             .secondaryText
                                                    //         : FlutterFlowTheme.of(
                                                    //                 context)
                                                    //             .error,
                                                    //     size: 18.0,
                                                    //   ),
                                                    //   countBuilder: (countOrder) =>
                                                    //       Text(
                                                    //     countOrder.toString(),
                                                    //     style: FlutterFlowTheme.of(
                                                    //             context)
                                                    //         .bodyMedium
                                                    //         .override(
                                                    //           fontFamily: 'Kanit',
                                                    //           fontSize: 14.0,
                                                    //           letterSpacing: 30.0,
                                                    //         ),
                                                    //   ),
                                                    //   count: 0,
                                                    //   updateCount: (countOrder) =>
                                                    //       setState(() {
                                                    //     print('----');
                                                    //     print(i);
                                                    //     print(productCount[i]);
                                                    //     productCount[i] = countOrder;
                                                    //   }),
                                                    //   stepSize: 1,
                                                    // );
                                                  }),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // SizedBox(
                                                //   height: 5,
                                                //   child: PopupMenuButton<String>(
                                                //     child: Text('data'),
                                                //     itemBuilder: (BuildContext
                                                //             context) =>
                                                //         <PopupMenuEntry<String>>[
                                                //       for (String? element
                                                //           in productList[i]
                                                //               ['ยูนิต'])
                                                //          PopupMenuItem<String>(
                                                //           value: element,
                                                //           child: Text(element!),
                                                //         ),
                                                //     ],
                                                //     onSelected: (String value) {
                                                //       // เมื่อเลือกเมนู
                                                //       print('You selected: $value');
                                                //     },
                                                //   ),
                                                // )
                                                // SizedBox(
                                                //   width: 10,
                                                //   child: FlutterFlowDropDown<String>(
                                                //     // controller: _model.dropDownValueController1 ??=
                                                //     //     FormFieldController<String>(null),
                                                //     controller:
                                                //         dropDownUnitControllers[i],
                                                //     options: productList[i]['ยูนิต']

                                                //     // [
                                                //     //   'ประเภทสินค้า 1',
                                                //     //   'ประเภทสินค้า 2',
                                                //     //   'ประเภทสินค้า 3',
                                                //     //   'ประเภทสินค้า 4',
                                                //     //   'ประเภทสินค้า 5'
                                                //     // ]
                                                //     ,
                                                //     searchHintText:
                                                //         'กลุ่มสินค้าที่สั่งชื้อ',
                                                //     // onChanged: (val) =>
                                                //     //     setState(() => _model.dropDownValue1 = val),
                                                //     onChanged: (val) =>
                                                //         setState(() {
                                                //       print(
                                                //           dropDownUnitControllers[i]
                                                //               .value);
                                                //     }),
                                                //     height: 55.0,
                                                //     textStyle:
                                                //         FlutterFlowTheme.of(context)
                                                //             .bodyMedium,
                                                //     hintText:
                                                //         'กลุ่มสินค้าที่สั่งชื้อ',
                                                //     icon: Icon(
                                                //       Icons.arrow_left_outlined,
                                                //       color: FlutterFlowTheme.of(
                                                //               context)
                                                //           .secondaryText,
                                                //       size: 24.0,
                                                //     ),
                                                //     elevation: 2.0,
                                                //     borderColor:
                                                //         FlutterFlowTheme.of(context)
                                                //             .alternate,
                                                //     borderWidth: 2.0,
                                                //     borderRadius: 8.0,
                                                //     margin: EdgeInsetsDirectional
                                                //         .fromSTEB(
                                                //             16.0, 4.0, 16.0, 4.0),
                                                //     hidesUnderline: true,
                                                //     isSearchable: false,
                                                //     isMultiSelect: false,
                                                //   ),
                                                // ),
                                                // GestureDetector(
                                                //   onTap: () {
                                                //     _showPopupMenu(context);
                                                //   },
                                                //   child: Text(
                                                //     'หน่วย',
                                                //     style: FlutterFlowTheme.of(
                                                //             context)
                                                //         .bodyMedium,
                                                //   ),
                                                // ),

                                                productList[i]['ยูนิต']
                                                            .length ==
                                                        0
                                                    ? Container(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        width: 50,
                                                        height: 12.5,
                                                        // color: Colors.red,
                                                        child: Text(
                                                          'Sold Out',
                                                          // productList[i]['UNIT'],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmallRed,
                                                          maxLines: 1,
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          await showModalBottomSheet(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        40.0), // ตั้งค่าเพื่อทำให้มุมบนสองข้างเป็นโค้ง
                                                              ),
                                                            ),
                                                            isDismissible: true,
                                                            context: context,
                                                            builder: (context) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 500,
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child:
                                                                              ListView(
                                                                            padding: EdgeInsets.only(
                                                                                top: 40,
                                                                                bottom: 40,
                                                                                left: 100,
                                                                                right: 100),
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  'กรุณาเลือกหน่วยของสินค้า',
                                                                                  // productList[i]['UNIT'],
                                                                                  style: FlutterFlowTheme.of(context).displaySmall,
                                                                                  maxLines: 1,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              for (var element in productList[i]['ยูนิต'])
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    print("onTap");
                                                                                    print(element);

                                                                                    int index = productList[i]['ยูนิต'].indexOf(element);

                                                                                    setState(
                                                                                      () {
                                                                                        priceChoose[i] = productList[i]['ราคา'][index];

                                                                                        int dotIndex = priceChoose[i].indexOf(".");
                                                                                        if (dotIndex != -1 && dotIndex + 3 <= priceChoose[i].length) {
                                                                                          priceChoose[i] = priceChoose[i].substring(0, dotIndex + 3);
                                                                                        }

                                                                                        print(priceChoose[i]);
                                                                                        print(priceChoose[i]);
                                                                                        print(priceChoose[i]);
                                                                                        print(priceChoose[i]);
                                                                                        print(priceChoose[i]);
                                                                                        unitChoose[i] = element;
                                                                                        print(unitChoose[i]);
                                                                                        print(unitChoose[i]);
                                                                                        print(unitChoose[i]);
                                                                                        print(unitChoose[i]);
                                                                                        print(unitChoose[i]);
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    );
                                                                                    // controller[i].hideMenu();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                                    child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(width: 0.5),
                                                                                          borderRadius: BorderRadius.circular(40),
                                                                                          // color: Colors.red,
                                                                                        ),
                                                                                        // color: Colors
                                                                                        //     .green,
                                                                                        alignment: Alignment.center,
                                                                                        child: Text(element, style: FlutterFlowTheme.of(context).headlineSmall)),
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                          // Scaffold.of(context)
                                                          //     .showBottomSheet(
                                                          //   shape:
                                                          //       RoundedRectangleBorder(
                                                          //     borderRadius:
                                                          //         BorderRadius
                                                          //             .vertical(
                                                          //       top: Radius
                                                          //           .circular(
                                                          //               40.0), // ตั้งค่าเพื่อทำให้มุมบนสองข้างเป็นโค้ง
                                                          //     ),
                                                          //   ),
                                                          //   (BuildContext
                                                          //       context) {
                                                          //     return GestureDetector(
                                                          //       onTap: () {
                                                          //         Navigator.pop(
                                                          //             context);
                                                          //       },
                                                          //       child:
                                                          //           Container(
                                                          //         height: 500,
                                                          //         child: Center(
                                                          //           child:
                                                          //               Column(
                                                          //             mainAxisAlignment:
                                                          //                 MainAxisAlignment
                                                          //                     .center,
                                                          //             mainAxisSize:
                                                          //                 MainAxisSize
                                                          //                     .min,
                                                          //             children: <Widget>[
                                                          //               Expanded(
                                                          //                 child:
                                                          //                     ListView(
                                                          //                   padding:
                                                          //                       EdgeInsets.zero,
                                                          //                   children: [
                                                          //                     for (var element in productList[i]['ยูนิต'])
                                                          //                       GestureDetector(
                                                          //                         onTap: () {
                                                          //                           print("onTap");
                                                          //                           print(element);

                                                          //                           int index = productList[i]['ยูนิต'].indexOf(element);

                                                          //                           setState(
                                                          //                             () {
                                                          //                               priceChoose[i] = productList[i]['ราคา'][index];

                                                          //                               int dotIndex = priceChoose[i].indexOf(".");
                                                          //                               if (dotIndex != -1 && dotIndex + 3 <= priceChoose[i].length) {
                                                          //                                 priceChoose[i] = priceChoose[i].substring(0, dotIndex + 3);
                                                          //                               }

                                                          //                               print(priceChoose[i]);
                                                          //                               print(priceChoose[i]);
                                                          //                               print(priceChoose[i]);
                                                          //                               print(priceChoose[i]);
                                                          //                               print(priceChoose[i]);
                                                          //                               unitChoose[i] = element;
                                                          //                               print(unitChoose[i]);
                                                          //                               print(unitChoose[i]);
                                                          //                               print(unitChoose[i]);
                                                          //                               print(unitChoose[i]);
                                                          //                               print(unitChoose[i]);
                                                          //                               Navigator.pop(context);
                                                          //                             },
                                                          //                           );
                                                          //                           // controller[i].hideMenu();
                                                          //                         },
                                                          //                         child: Container(
                                                          //                             // color: Colors
                                                          //                             //     .green,
                                                          //                             alignment: Alignment.center,
                                                          //                             child: Text(element)),
                                                          //                       ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //             ],
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //     );
                                                          //   },
                                                          // );
                                                        },
                                                        child: Text(
                                                            unitChoose[i],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall),
                                                      )
                                                // CustomPopupMenu(
                                                //     child: Container(
                                                //         alignment: Alignment
                                                //             .topCenter,
                                                //         width: 50,
                                                //         height: 20,
                                                //         child: Text(
                                                //           unitChoose[i],
                                                //           style: TextStyle(
                                                //             fontSize: 12,
                                                //           ),
                                                //           maxLines: 1,
                                                //         )
                                                //         // padding: EdgeInsets.all(20),
                                                //         ),
                                                //     menuBuilder: () {
                                                //       return
                                                //           //  productList[i]
                                                //           //             ['ยูนิต']
                                                //           //         .isEmpty
                                                //           //     ? Container(
                                                //           //         alignment: Alignment
                                                //           //             .topCenter,
                                                //           //         width: 100,
                                                //           //         height: 30,
                                                //           //         color: Colors
                                                //           //             .grey.shade300,
                                                //           //         child:
                                                //           //             GestureDetector(
                                                //           //           onTap: () {
                                                //           //             controller[i]
                                                //           //                 .hideMenu();
                                                //           //           },
                                                //           //           child: Text(
                                                //           //               'ไม่มีตัวเลือก'),
                                                //           //         ),
                                                //           //       )
                                                //           //     :
                                                //           Container(
                                                //         alignment: Alignment
                                                //             .topCenter,
                                                //         width: 100,
                                                //         height: 100,
                                                //         color: Colors
                                                //             .grey.shade300,
                                                //         child: ListView(
                                                //           padding:
                                                //               EdgeInsets
                                                //                   .zero,
                                                //           children: [
                                                //             for (var element
                                                //                 in productList[
                                                //                         i][
                                                //                     'ยูนิต'])
                                                //               GestureDetector(
                                                //                 onTap: () {
                                                //                   print(
                                                //                       "onTap");
                                                //                   print(
                                                //                       element);

                                                //                   int index = productList[i]
                                                //                           [
                                                //                           'ยูนิต']
                                                //                       .indexOf(
                                                //                           element);

                                                //                   setState(
                                                //                     () {
                                                //                       priceChoose[i] =
                                                //                           productList[i]['ราคา'][index];

                                                //                       int dotIndex =
                                                //                           priceChoose[i].indexOf(".");
                                                //                       if (dotIndex != -1 &&
                                                //                           dotIndex + 3 <= priceChoose[i].length) {
                                                //                         priceChoose[i] =
                                                //                             priceChoose[i].substring(0, dotIndex + 3);
                                                //                       }

                                                //                       print(
                                                //                           priceChoose[i]);
                                                //                       print(
                                                //                           priceChoose[i]);
                                                //                       print(
                                                //                           priceChoose[i]);
                                                //                       print(
                                                //                           priceChoose[i]);
                                                //                       print(
                                                //                           priceChoose[i]);
                                                //                       unitChoose[i] =
                                                //                           element;
                                                //                       print(
                                                //                           unitChoose[i]);
                                                //                       print(
                                                //                           unitChoose[i]);
                                                //                       print(
                                                //                           unitChoose[i]);
                                                //                       print(
                                                //                           unitChoose[i]);
                                                //                       print(
                                                //                           unitChoose[i]);
                                                //                     },
                                                //                   );
                                                //                   controller[
                                                //                           i]
                                                //                       .hideMenu();
                                                //                 },
                                                //                 child: Container(
                                                //                     // color: Colors
                                                //                     //     .green,
                                                //                     alignment: Alignment.center,
                                                //                     child: Text(element)),
                                                //               ),
                                                //           ],
                                                //         ),
                                                //       );
                                                //       // ['1','3']
                                                //       // .map(
                                                //       //   (item) =>
                                                //       //       GestureDetector(
                                                //       //     behavior:
                                                //       //         HitTestBehavior
                                                //       //             .translucent,
                                                //       //     onTap: () {
                                                //       //       print("onTap");
                                                //       //       controller[i]
                                                //       //           .hideMenu();
                                                //       //     },
                                                //       //     child: Container(
                                                //       //       height: 40,
                                                //       //       padding: EdgeInsets
                                                //       //           .symmetric(
                                                //       //               horizontal:
                                                //       //                   20),
                                                //       //       child: Row(
                                                //       //         children: <Widget>[
                                                //       //           // Icon(
                                                //       //           //   item.icon,
                                                //       //           //   size:
                                                //       //           //       15,
                                                //       //           //   color: Colors
                                                //       //           //       .white,
                                                //       //           // ),
                                                //       //           Expanded(
                                                //       //             child:
                                                //       //                 Container(
                                                //       //               margin: EdgeInsets
                                                //       //                   .only(
                                                //       //                       left:
                                                //       //                           10),
                                                //       //               padding: EdgeInsets.symmetric(
                                                //       //                   vertical:
                                                //       //                       10),
                                                //       //               child: Text(
                                                //       //                 item,
                                                //       //                 style:
                                                //       //                     TextStyle(
                                                //       //                   color: Colors
                                                //       //                       .white,
                                                //       //                   fontSize:
                                                //       //                       12,
                                                //       //                 ),
                                                //       //               ),
                                                //       //             ),
                                                //       //           ),
                                                //       //         ],
                                                //       //       ),
                                                //       //     ),
                                                //       //   ),
                                                //       // )
                                                //       // .toList();
                                                //     },
                                                //     pressType: PressType
                                                //         .singleClick,
                                                //     verticalMargin: -10,
                                                //     controller:
                                                //         controller[i],
                                                //   ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FFButtonWidget(
                                                  onPressed: () {
                                                    print('Button pressed ...');

                                                    // print(orderLast);

                                                    if (productList[i]['ยูนิต']
                                                            .length ==
                                                        0) {
                                                      print('SOLD OUT');
                                                    } else {
                                                      try {
                                                        bool checkProductSame =
                                                            false;

                                                        for (var element
                                                            in orderLast![
                                                                'ProductList']) {
                                                          if (productList[i][
                                                                      'DocId'] ==
                                                                  element[
                                                                      'DocID'] &&
                                                              unitChoose[i] ==
                                                                  element[
                                                                      'ยูนิต']) {
                                                            // print(
                                                            //     productList[i]['DocId']);
                                                            // print(element['DocID']);
                                                            print('ซ้ำ');
                                                            checkProductSame =
                                                                true;
                                                          } else {
                                                            // print(
                                                            //     productList[i]['DocId']);
                                                            // print(element['DocID']);
                                                            print('ไม่ซ้ำ');
                                                          }
                                                        }

                                                        if (checkProductSame) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "สินค้านี้อยู่ในตระกร้าแล้วค่ะ",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              timeInSecForIosWeb:
                                                                  5,
                                                              backgroundColor:
                                                                  Colors.red
                                                                      .shade900,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);

                                                          productCount[i] = 0;
                                                        } else {
                                                          if (productCount[i] ==
                                                              0) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "คุณยังไม่ได้เลือกจำนวนค่ะ",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                timeInSecForIosWeb:
                                                                    5,
                                                                backgroundColor:
                                                                    Colors.red
                                                                        .shade900,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          } else {
                                                            orderLast![
                                                                    'ProductList']
                                                                .add(
                                                              {
                                                                'DocID':
                                                                    productList[
                                                                            i][
                                                                        'DocId'],
                                                                'ProductID':
                                                                    productList[
                                                                            i][
                                                                        'PRODUCT_ID'],
                                                                'ชื่อสินค้า':
                                                                    productList[
                                                                            i][
                                                                        'NAMES'],
                                                                'คำอธิบายสินค้า':
                                                                    productList[
                                                                            i][
                                                                        'รายละเอียดสตริง'],
                                                                'PromotionProductID':
                                                                    productList[
                                                                            i][
                                                                        'PRODUCT_ID'],
                                                                'สินค้าโปรโมชั่น':
                                                                    false,
                                                                'คำอธิบายโปรโมชั่น':
                                                                    '',
                                                                'จำนวน':
                                                                    productCount[
                                                                        i],
                                                                'ราคา':
                                                                    priceChoose[
                                                                        i],
                                                                'ยูนิต':
                                                                    unitChoose[
                                                                        i],
                                                                'LeadTime':
                                                                    productList[
                                                                            i][
                                                                        'LeadTime'],
                                                                // productList[i]
                                                                //     ['PRICE'],
                                                                'ราคาพิเศษ':
                                                                    false
                                                                // productList[i]
                                                                //     [
                                                                //     'ราคาพิเศษ'],
                                                              },
                                                            );

                                                            double total = 0;
                                                            // print(total);

                                                            for (var element
                                                                in orderLast![
                                                                    'ProductList']) {
                                                              print(element[
                                                                  'จำนวน']);
                                                              print(element[
                                                                  'ราคา']);

                                                              int qty = int
                                                                  .parse(element[
                                                                          'จำนวน']
                                                                      .toString());
                                                              double price = double
                                                                  .parse(element[
                                                                          'ราคา']
                                                                      .toString());
                                                              double sumTotal =
                                                                  qty * price;

                                                              total = total +
                                                                  sumTotal;
                                                              print('---');
                                                              print(total);
                                                            }
                                                            print('object');
                                                            print(total);

                                                            orderLast![
                                                                    'ยอดรวม'] =
                                                                total;
                                                            print(orderLast![
                                                                'ยอดรวม']);

                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "ใส่สินค้าลงตระกร้าแล้วค่ะ",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                timeInSecForIosWeb:
                                                                    5,
                                                                backgroundColor:
                                                                    Colors.green
                                                                        .shade900,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);

                                                            productCount[i] = 0;
                                                          }
                                                        }
                                                        if (mounted) {
                                                          toSetState();
                                                        }
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                    }
                                                  },
                                                  text: 'ใส่ตะกร้า',
                                                  options: FFButtonOptions(
                                                    height: 28.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(10.0, 0.0,
                                                                10.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: productList[i]
                                                                    ['ยูนิต']
                                                                .length ==
                                                            0
                                                        ? Colors.grey.shade400
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 0.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(0.0),
                                                      bottomRight:
                                                          Radius.circular(8.0),
                                                      topLeft:
                                                          Radius.circular(0.0),
                                                      topRight:
                                                          Radius.circular(8.0),
                                                    ),
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
                              );
                            }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 0),
                  ],
                ),
              ),
      ),
    );
  }
}
