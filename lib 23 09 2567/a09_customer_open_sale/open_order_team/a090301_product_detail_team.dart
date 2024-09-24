import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_food/a09_customer_open_sale/a0904_product_order_detail%2024%2009%203567.dart';
import 'package:m_food/a09_customer_open_sale/open_order_team/a0904_product_order_detail_team%2024%2009%202567.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
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

class A090301ProductDetailTeam extends StatefulWidget {
  final String? customerID;
  final Map<String, dynamic>? product;
  final Map<String, dynamic>? orderDataMap;
  final List<Map<String, dynamic>>? productListAll;
  final String? userIDOpen;
  final String? userNameOpen;
  final String? idEmployee;

  const A090301ProductDetailTeam({
    super.key,
    this.orderDataMap,
    this.product,
    this.customerID,
    this.productListAll,
    @required this.idEmployee,
    @required this.userIDOpen,
    @required this.userNameOpen,
  });

  @override
  _A090301ProductDetailTeamState createState() =>
      _A090301ProductDetailTeamState();
}

class _A090301ProductDetailTeamState extends State<A090301ProductDetailTeam> {
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

  List<Map<String, dynamic>> resultProductGroupList = [];
  List<Map<String, dynamic>> firstList = [];
  List<Map<String, dynamic>> secondList = [];

  Map<String, dynamic>? productDetail;
  late Map<String, dynamic> orderLast;

  List<Map<String, dynamic>?>? specialPriceProductList = [];

  int productCount = 0;
  List<int> productCountList = [];

  List<Map<String, dynamic>> tagProductList = [];

  int indexImage = 0;

  List<CustomPopupMenuController> controller = [];
  List<String> unitChoose = [];
  List<String> priceChoose = [];

  CustomPopupMenuController controllerproductDetail =
      CustomPopupMenuController();
  String? unitChooseproductDetail;
  String? priceChooseproductDetail;

  var jsonString;
  List<Map<String, dynamic>> productPromotionList = [];

  TextEditingController inModalDialogProductDetail = TextEditingController();

  List<TextEditingController> inModalDialog = [];

  List<dynamic> listFavToback = [];
  Map<String, dynamic>? customerDataWithmfoodtoken;
  Map<String, dynamic>? urlApi;


  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  toSetstate() {
    setState(() {});
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });

    // print(widget.productListAll);
    // print(widget.productListAll!.length);

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
    userData = userController.userData;
    productGetData = productController.productData;

    productGroupGetData = productGroupController.productGroupData;

    customerData = customerController.customerData;

    orderLast = widget.orderDataMap!;

    if (!widget.product!.isNotEmpty) {
      productDetail = widget.product;
    } else {
      productDetail = widget.product;
    }

    print(productDetail!['PRODUCT_ID']);
    print(productDetail!['PRODUCT_ID']);
    print(productDetail!['PRODUCT_ID']);
    print(productDetail!['PRODUCT_ID']);
    print(productDetail!['PRODUCT_ID']);

    // ดึงข้อมูลจาก collection 'Customer'
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'CustomerTest'
            : 'Customer')
        .doc(widget.customerID)
        .get();

    if (customerDoc.exists) {
      // CollectionReference subCollectionRef = FirebaseFirestore.instance
      //     .collection(AppSettings.customerType == CustomerType.Test
      //         ? 'CustomerTest/${widget.customerID}/ราคาสินค้าพิเศษ'
      //         : 'Customer/${widget.customerID}/ราคาสินค้าพิเศษ');

      // QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

      // subCollectionSnapshot.docs.forEach((doc) {
      //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      //   specialPriceProductList!.add(data);
      // });

      Map<String, dynamic> data = customerDoc.data() as Map<String, dynamic>;

      customerDataFetch = customerDoc.data() as Map<String, dynamic>;

      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);
      print(data['ClientIdจากMfoodAPI']);

      // specialPriceProductList = (specialPriceProductList ?? [])
      //     .where((map) => map != null)
      //     .cast<Map<String, dynamic>>()
      //     .toList();

      // print(specialPriceProductList);
      // ================================= เช็คโปร ============================

      DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

      print(formattedDate);

      HttpsCallable callablePromotion =
          FirebaseFunctions.instance.httpsCallable('getApiMfood');
      var paramsPromotion = AppSettings.customerType == CustomerType.Test
          ? <String, dynamic>{
              "url":
                  "${urlApi!['Url']}:7104/MBServices.asmx?op=CHECK_PROMOTION_INFO",
              "xml":
                  '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><CHECK_PROMOTION_INFO xmlns="MFOODMOBILEAPI"><Token>${customerDataWithmfoodtoken!['token_key']}</Token><sCLIENT_ID>${data['ClientIdจากMfoodAPI']}</sCLIENT_ID><sPRODUCT_CODE>${productDetail!['PRODUCT_ID']}</sPRODUCT_CODE><sORDER_DATE>$formattedDate</sORDER_DATE></CHECK_PROMOTION_INFO></soap12:Body></soap12:Envelope>'
              // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><CHECK_PROMOTION_INFO xmlns="MFOODMOBILEAPI"><sCLIENT_ID>01000003</sCLIENT_ID><sPRODUCT_CODE>0140006421000</sPRODUCT_CODE><sORDER_DATE>2024-03-18</sORDER_DATE></CHECK_PROMOTION_INFO></soap12:Body></soap12:Envelope>'
            }
          : <String, dynamic>{
              "url":
                  "${urlApi!['Url']}:7105/MBServices.asmx?op=CHECK_PROMOTION_INFO",
              "xml":
                  '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><CHECK_PROMOTION_INFO xmlns="MFOODMOBILEAPI"><Token>${customerDataWithmfoodtoken!['token_key']}</Token><sCLIENT_ID>${data['ClientIdจากMfoodAPI']}</sCLIENT_ID><sPRODUCT_CODE>${productDetail!['PRODUCT_ID']}</sPRODUCT_CODE><sORDER_DATE>$formattedDate</sORDER_DATE></CHECK_PROMOTION_INFO></soap12:Body></soap12:Envelope>'
              // '<?xml version="1.0" encoding="utf-8"?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body><CHECK_PROMOTION_INFO xmlns="MFOODMOBILEAPI"><sCLIENT_ID>01000003</sCLIENT_ID><sPRODUCT_CODE>0140006421000</sPRODUCT_CODE><sORDER_DATE>2024-03-18</sORDER_DATE></CHECK_PROMOTION_INFO></soap12:Body></soap12:Envelope>'
            };

      print(paramsPromotion['xml']);
      // print('======================================= aaaaa');

      await callablePromotion.call(paramsPromotion).then((value) async {
        print('ข้อมูลที่ส่งกลับจาก cloud function ${value.data}');
        if (value.data['status'] == 'success') {}

        Xml2Json xml2json = Xml2Json();
        xml2json.parse(value.data.toString());

        jsonString = xml2json.toOpenRally();

        Map<String, dynamic> data = json.decode(jsonString);
        print('================= 2 ===================');

        print(data);

        if (data['Envelope']['Body']['CHECK_PROMOTION_INFOResponse']
                ['CHECK_PROMOTION_INFOResult'] ==
            'true') {
          print('is true');
        } else {
          Map<String, dynamic> sellPriceResponse = data['Envelope']['Body']
              ['CHECK_PROMOTION_INFOResponse']['CHECK_PROMOTION_INFOResult'];

          print('================= 3 ===================');
          print(sellPriceResponse);

          // if (sellPriceResponse['Sell_PriceResult'] == 'true') {
          //   print('is true');
          // } else {

          for (var key in sellPriceResponse.keys) {
            print('Key: $key, Value: ${sellPriceResponse[key]}');
          }

          print('================= 3 ===================');

          if (sellPriceResponse['PROMOTION_INFO'].runtimeType.toString() ==
              '_Map<String, dynamic>') {
            print('true is Map');
            productPromotionList.add(sellPriceResponse['PROMOTION_INFO']);
          } else {
            print('false is List');

            productPromotionList = List<Map<String, dynamic>>.from(
                sellPriceResponse['PROMOTION_INFO']);
          }

          print(productPromotionList.length);

          for (int i = 0; i < productPromotionList.length; i++) {
            // if (productPromotionList[i]['PRODUCT_ID'] == '0291056100062') {
            print(productPromotionList[i]);

            String firstDate = productPromotionList[i]['STARTDATE'];
            firstDate = firstDate.substring(0, 10);
            firstDate = convertDate(firstDate);

            String secondDate = productPromotionList[i]['FINISHDATE'];
            secondDate = secondDate.substring(0, 10);
            secondDate = convertDate(secondDate);

            productPromotionList[i]['firstDate'] = firstDate;
            productPromotionList[i]['secondDate'] = secondDate;

            print(firstDate);
            print(secondDate);

            // }
          }
          // // int count2 = productPromotionList
          // //     .where((item) => item['PRODUCT_ID'] == '0291056100062')
          // //     .length;
        }
      }).whenComplete(() async {});

      // =============================================================
    }

    List<String>? nameOnly = [];
    if (productDetail!['Tag'] == null) {
    } else {
      if (productDetail!['Tag'] == '') {
      } else {
        for (var element in productDetail!['Tag']) {
          Map<String, dynamic>? foundMap = tagProductList.firstWhere(
            (map) => map['DocId'] == element,
            orElse: () => {},
          );

          nameOnly!.add(foundMap['Name']);
        }
      }
    }

    productDetail!['แท๊ก'] = nameOnly;

    unitChooseproductDetail = productDetail!['ยูนิต'].isEmpty
        ? productDetail!['UNIT']
        : productDetail!['ยูนิต'][0];

    String priceProductDetail = '';
    priceProductDetail = productDetail!['ราคา'].isEmpty
        ? productDetail!['PRICE'].toString()
        : productDetail!['ราคา'][0].toString();

    int dotIndex = priceProductDetail.indexOf(".");
    if (dotIndex != -1 && dotIndex + 3 <= priceProductDetail.length) {
      priceChooseproductDetail = priceProductDetail.substring(0, dotIndex + 3);
    } else {
      priceChooseproductDetail = priceProductDetail;
    }

    if (productGetData != null) {
      productGetData!.forEach((key, value) {
        // print(value);
        Map<String, dynamic>? foundMap = specialPriceProductList?.firstWhere(
          (Map<String, dynamic>? map) => map?['DocID'] == value['DocId'],
          orElse: () => {},
        );

        Map<String, dynamic>? entry;

        if (foundMap!.isNotEmpty) {
          // print('123');
          // print(foundMap);
          entry = value;
          entry!['PRICE'] = foundMap['PRICE'];
          entry['ราคาพิเศษ'] = true;
        } else {
          entry = value;
          entry!['ราคาพิเศษ'] = false;
        }

        // เพิ่มข้อมูล 'รายละเอียดสตริง' : 'นี่คือข้อความ' ลงใน Map
        String parsedstring3 = Bidi.stripHtmlIfNeeded(
            entry['รายละเอียด'] == null ? '' : entry['รายละเอียด']);
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

              name!.add(foundMap['Name']);
            }
          }
        }

        entry['แท๊ก'] = name;

        bool isStringFound = false;

        // print(userData!['สินค้าชื่นชอบ']);
        // print(entry['PRODUCT_ID']);

        // for (int i = 0; i < userData!['สินค้าถูกใจ'].length; i++) {
        //   if (userData!['สินค้าถูกใจ'][i] == entry['PRODUCT_ID']) {
        //     isStringFound = true;
        //   }
        // }

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

        resultList.add(entry);
      });
    }

    // print('1333');
    print(widget.productListAll!.length);

    for (var element in widget.productListAll!) {
      productList.add(element);
    }

    // print(productList);
    print('1');
    // print(productList.length);

    productList.removeWhere(
        (element) => element['PRODUCT_ID'] == productDetail!['PRODUCT_ID']);

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
    print('1');

    for (var element in productList) {
      controller.add(CustomPopupMenuController());

      productCountList.add(0);
      inModalDialog.add(TextEditingController(text: ''));

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
    print('1');

    //   print('/////////////////////////////////////////////////////');
    //   print('/////////////////////////////////////////////////////');
    //   print('/////////////////                        ////////////');
    //   print('////////// ${resultList.length} ////////');
    //   print('////////////////                         ////////////');
    //   print('/////////////////////////////////////////////////////');
    //   print('/////////////////////////////////////////////////////');
    //   print('/////////////////////////////////////////////////////');

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
    int firstListLength = totalLength ~/ 2 + totalLength % 2;
    int secondListLength = totalLength - firstListLength;

    firstList = resultProductGroupList.sublist(0, firstListLength);
    secondList = resultProductGroupList.sublist(firstListLength);
    print(firstList.length);
    print(resultList.length);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
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

  String convertDate(String dateString) {
    // แปลงวันที่จากสตริงเป็นวัตถุ DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // กำหนดรูปแบบของวันที่ที่ต้องการแปลง
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    // แปลงวันที่ใหม่เป็นสตริงตามรูปแบบที่กำหนด
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  // void changeGroupProductList(String nameGroup) {
  //   searchTextController.clear();
  //   print(nameGroup);

  //   if (nameGroup == 'สินค้าทั้งหมด') {
  //     productList.clear();

  //     productList.addAll(resultList);

  //     productCount.clear();
  //     for (var element in productList) {
  //       productCount.add(0);
  //     }
  //   } else if (nameGroup == 'ราคาพิเศษ') {
  //     productList.clear();

  //     // List<Map<String, dynamic>> checkProduct = resultList;
  //     List<Map<String, dynamic>> checkProduct = List.from(resultList);
  //     checkProduct.removeWhere((map) => map['ราคาพิเศษ'] == false);

  //     productList.addAll(checkProduct);

  //     productCount.clear();
  //     for (var element in productList) {
  //       productCount.add(0);
  //     }
  //   } else {
  //     productList.clear();
  //     productList =
  //         resultList.where((product) => product['PG2'] == nameGroup).toList();

  //     productCount.clear();
  //     for (var element in productList) {
  //       productCount.add(0);
  //     }
  //   }

  //   print(productList.length);
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // void findNameProductList(String nameProduct) {
  //   print(nameProduct);

  //   productList.clear();

  //   productList = resultList
  //       .where((product) => product['NAMES'].contains(nameProduct))
  //       .toList();

  //   productCount.clear();
  //   for (var element in productList) {
  //     productCount.add(0);
  //   }

  //   print(productList.length);
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  void decrementList(
      int index, int number, void Function(VoidCallback) setStateFunc) {
    if (productCountList[index] > 0) {
      setStateFunc(() {
        productCountList[index]--;
      });
    }
  }

  void incrementList(
      int index, int number, void Function(VoidCallback) setStateFunc) {
    setStateFunc(() {
      productCountList[index]++;
    });
  }

  void decrement(int number, void Function(VoidCallback) setStateFunc) {
    if (productCount > 0) {
      setStateFunc(() {
        productCount--;
      });
    }
  }

  void increment(int number, void Function(VoidCallback) setStateFunc) {
    setStateFunc(() {
      productCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A090301 Product Detail');
    print('==============================');

    // print(widget.product);
    print(widget.customerID);

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

                                          // Navigator.pop(context);
                                          Navigator.pop(context, {
                                            'orderLast': orderLast,
                                            'groupName': '',
                                            'favListID': listFavToback,
                                          });
                                          // Navigator.pop(context, orderLast);
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

                        // Column(
                        //   mainAxisSize: MainAxisSize.max,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       width: MediaQuery.sizeOf(context).width * 0.3,
                        //       height: 25.0,
                        //       decoration: BoxDecoration(
                        //         color: FlutterFlowTheme.of(context).accent3,
                        //         borderRadius: BorderRadius.circular(8.0),
                        //       ),
                        //       alignment: AlignmentDirectional(0.00, 0.00),
                        //       child: TextFormField(
                        //         // controller: _model.textController,
                        //         // focusNode: _model.textFieldFocusNode,
                        //         onChanged: (value) {
                        //           findNameProductList(value);
                        //         },
                        //         controller: searchTextController,
                        //         autofocus: false,
                        //         obscureText: false,
                        //         decoration: InputDecoration(
                        //           isDense: true,
                        //           labelStyle:
                        //               FlutterFlowTheme.of(context).labelMedium,
                        //           hintStyle: FlutterFlowTheme.of(context)
                        //               .labelMedium
                        //               .override(
                        //                 fontFamily: 'Kanit',
                        //                 color: Color(0xFFCBCBCB),
                        //               ),
                        //           enabledBorder: InputBorder.none,
                        //           focusedBorder: InputBorder.none,
                        //           errorBorder: InputBorder.none,
                        //           focusedErrorBorder: InputBorder.none,
                        //           prefixIcon: Icon(
                        //             Icons.search,
                        //             color: FlutterFlowTheme.of(context).primaryText,
                        //           ),
                        //         ),
                        //         style: FlutterFlowTheme.of(context).bodyMedium,
                        //         // validator: _model.textControllerValidator.asValidator(context),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'คำอธิบายสินค้า',
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                          ),
                          Text(
                            widget.userIDOpen!,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontSize: 12,
                                  fontFamily: 'Kanit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                          ),
                          Text(
                            ' ' + widget.userNameOpen!,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontSize: 12,
                                  fontFamily: 'Kanit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                                        Navigator.pop(context, {
                                          'orderLast': orderLast,
                                          'groupName': firstList[index]
                                              ['GROUP_DESC'],
                                          'favListID': listFavToback,
                                        });
                                        // changeGroupProductList(
                                        //     firstList[index]['ชื่อกลุ่ม']);
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
                                        Navigator.pop(context, {
                                          'orderLast': orderLast,
                                          'groupName': secondList[index]
                                              ['GROUP_DESC'],
                                          'favListID': listFavToback,
                                        });
                                        // changeGroupProductList(
                                        //     secondList[index]['ชื่อกลุ่ม']);
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
                                                'รวมรายการสินค้า ${NumberFormat('#,##0').format(orderLast['ยอดรวม']).toString()} บาท',
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

                                        if (orderLast['ProductList'].isEmpty) {
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
                                              in orderLast['ProductList']) {
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
                                                        A0904ProductOrderDetailTeam(
                                                      customerID:
                                                          widget.customerID,
                                                      imageProduct: imageList,
                                                      orderDataMap: orderLast,
                                                      idEmployee:
                                                          widget.idEmployee,
                                                      userIDOpen:
                                                          widget.userIDOpen,
                                                      userNameOpen:
                                                          widget.userNameOpen,
                                                    ),
                                                  ));
                                          print('2');

                                          orderLast = result!;
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
                                    orderLast['ProductList'].length.toString(),
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

                    const SizedBox(height: 20),

                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //===================== ส่วนของ สินค้าหลัก  =========================
                          Expanded(
                              flex: 2,
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    height: double.infinity,
                                    // color: Colors.red,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.sizeOf(context)
                                                        .width >=
                                                    800.0
                                                ? 480.0
                                                : 420.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                width: 1.0,
                                              ),
                                            ),
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return Container(
                                                    // color: Colors.red,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 0, 5, 0),
                                                    width: MediaQuery.sizeOf(
                                                                    context)
                                                                .width >=
                                                            800.0
                                                        ? 460.0
                                                        : 400.0,
                                                    height: MediaQuery.sizeOf(
                                                                context)
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
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        10.0),
                                                            child: InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap:
                                                                  () async {},
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child: productDetail!['รูปภาพ'] ==
                                                                            null ||
                                                                        productDetail!['รูปภาพ']
                                                                            .isEmpty
                                                                    ? Image
                                                                        .asset(
                                                                        'assets/images/noproductimage.png',
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.2,
                                                                        height: MediaQuery.sizeOf(context).height *
                                                                            0.2,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      )
                                                                    : productDetail!['รูปภาพ'][indexImage] ==
                                                                            ''
                                                                        ? Image
                                                                            .asset(
                                                                            'assets/images/noproductimage.png',
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.5,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.5,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            // '',
                                                                            productDetail!['รูปภาพ'][indexImage],
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 0.5,
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.5,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),

                                                                //  Image.network(
                                                                //   productDetail!['รูปภาพ']
                                                                //       [indexImage],
                                                                //   width: MediaQuery.sizeOf(
                                                                //               context)
                                                                //           .width *
                                                                //       0.5,
                                                                //   height: MediaQuery.sizeOf(
                                                                //               context)
                                                                //           .height *
                                                                //       0.5,
                                                                //   fit: BoxFit.contain,
                                                                // ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  1.1, -1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        15.0,
                                                                        0.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                if (productDetail![
                                                                        'Favorite'] ==
                                                                    true) {
                                                                  productDetail![
                                                                          'Favorite'] =
                                                                      false;

                                                                  // List<dynamic>
                                                                  //     listFav =
                                                                  //     userData![
                                                                  //         'สินค้าถูกใจ'];

                                                                  List<dynamic>
                                                                      listFav =
                                                                      customerDataFetch![
                                                                          'สินค้าถูกใจ'];
                                                                  listFav.removeWhere((element) =>
                                                                      element ==
                                                                      productDetail![
                                                                          'PRODUCT_ID']);
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(AppSettings.customerType ==
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
                                                                    listFavToback =
                                                                        listFav;
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  });
                                                                } else {
                                                                  productDetail![
                                                                          'Favorite'] =
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
                                                                      productDetail![
                                                                          'PRODUCT_ID']);
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      // .collection(
                                                                      //     'User')
                                                                      // .doc(userData![
                                                                      //     'UserID'])
                                                                      .collection(AppSettings.customerType ==
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
                                                                    listFavToback =
                                                                        listFav;
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(
                                                                productDetail![
                                                                            'Favorite'] ==
                                                                        true
                                                                    ? Icons
                                                                        .favorite_sharp
                                                                    : Icons
                                                                        .favorite_border_sharp,
                                                                color: productDetail![
                                                                            'Favorite'] ==
                                                                        true
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                size: 24.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  1.15, -0.10),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        15.0,
                                                                        0.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                print(productDetail![
                                                                    'DocId']);
                                                                print(productDetail![
                                                                        'รูปภาพ']
                                                                    .length);
                                                                if (mounted) {
                                                                  setState(
                                                                    () {
                                                                      if (indexImage <
                                                                          (productDetail!['รูปภาพ'].length -
                                                                              1)) {
                                                                        indexImage++;
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_right,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 60.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.1, -0.1),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        15.0,
                                                                        0.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                print(productDetail![
                                                                        'รูปภาพ']
                                                                    .length);
                                                                if (mounted) {
                                                                  setState(
                                                                    () {
                                                                      if (indexImage ==
                                                                          0) {
                                                                      } else {
                                                                        indexImage--;
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_left,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 60.0,
                                                              ),
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
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 5.0, 0.0, 0.0),
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
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        1.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Container(
                                                              width: productDetail![
                                                                          'แท๊ก']
                                                                      .isEmpty
                                                                  ? 460
                                                                  : 250,
                                                              // color: Colors.green,
                                                              child: Text(
                                                                productDetail![
                                                                    'NAMES'],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleLarge
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
                                                                    TextOverflow
                                                                        .clip,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            'Lead time = ${productDetail!['LeadTime']} วัน',
                                                            // 'ราคา ${productDetail!['PRICE']} บาท',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  lineHeight:
                                                                      1.25,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      productDetail![
                                                                  'ประเภทสินค้าDesc'] ==
                                                              null
                                                          ? Text(
                                                              'ไม่มีประเภทสินค้า',
                                                              style: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .titleSmall
                                                                  .override(
                                                                      fontFamily:
                                                                          'Kanit',
                                                                      color: Colors
                                                                          .red
                                                                          .shade900,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      lineHeight:
                                                                          1.25,
                                                                      fontSize:
                                                                          12),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            )
                                                          : Text(
                                                              productDetail![
                                                                          'ประเภทสินค้าDesc'] ==
                                                                      'สินค้าเคลื่อนไหวเร็ว (Fast Moving)'
                                                                  ? 'Fast Moving'
                                                                  : productDetail![
                                                                              'ประเภทสินค้าDesc'] ==
                                                                          'สินค้าที่ต้องสั่งจองล่วงหน้า (Pre-Order)'
                                                                      ? 'Pre-Order'
                                                                      : productDetail!['ประเภทสินค้าDesc'] ==
                                                                              'สินค้าที่โรงงานผลิต​ (PCF)'
                                                                          ? 'PCF'
                                                                          : '',
                                                              style: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .titleSmall
                                                                  .override(
                                                                      fontFamily:
                                                                          'Kanit',
                                                                      color: Colors
                                                                          .red
                                                                          .shade900,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      lineHeight:
                                                                          1.25,
                                                                      fontSize:
                                                                          12),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            'ราคา ${priceChooseproductDetail} บาท',
                                                            // 'ราคา ${productDetail!['PRICE']} บาท',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  lineHeight:
                                                                      1.25,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  productDetail!['แท๊ก'].isEmpty
                                                      ? SizedBox()
                                                      : Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
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
                                                                    Alignment
                                                                        .center,
                                                                width: 75,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          4.0,
                                                                          10.0,
                                                                          4.0),
                                                                  child: Text(
                                                                    '${productDetail!['แท๊ก'][0]}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
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
                                          productPromotionList.isEmpty
                                              ? SizedBox()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  10.0,
                                                                  10.0,
                                                                  0.0),
                                                      // width: MediaQuery.of(context)
                                                      //     .size
                                                      //     .width,
                                                      // height: 60,
                                                      decoration: BoxDecoration(
                                                        // color: Colors.red,
                                                        // border: Border.all(color: ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(150),
                                                      ),
                                                      child: Text(
                                                        'สินค้านี้มีโปรโมชั่น',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmallRed,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          for (var element
                                              in productPromotionList)
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 10.0, 0.0, 0.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        // padding:
                                                        //     EdgeInsetsDirectional
                                                        //         .fromSTEB(
                                                        //             10.0,
                                                        //             0.0,
                                                        //             10.0,
                                                        //             0.0),
                                                        // width:
                                                        //     MediaQuery.of(context)
                                                        //         .size
                                                        //         .width,
                                                        // height: 60,
                                                        // color: Colors.red,
                                                        child: Text(
                                                          'ระยะเวลาโปรโมชั่นนี้',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium,
                                                        ),
                                                      ),
                                                      Container(
                                                        // padding:
                                                        //     EdgeInsetsDirectional
                                                        //         .fromSTEB(
                                                        //             10.0,
                                                        //             0.0,
                                                        //             10.0,
                                                        //             0.0),
                                                        // width:
                                                        //     MediaQuery.of(context)
                                                        //         .size
                                                        //         .width,
                                                        // height: 60,
                                                        // color: Colors.red,
                                                        child: Text(
                                                          ' วันที่ ${element['firstDate']} ถึง',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium,
                                                        ),
                                                      ),
                                                      Container(
                                                        // padding:
                                                        //     EdgeInsetsDirectional
                                                        //         .fromSTEB(
                                                        //             10.0,
                                                        //             0.0,
                                                        //             10.0,
                                                        //             0.0),
                                                        // width:
                                                        //     MediaQuery.of(context)
                                                        //         .size
                                                        //         .width,
                                                        // height: 60,
                                                        // color: Colors.red,
                                                        child: Text(
                                                          element['secondDate'],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        // padding:
                                                        //     EdgeInsetsDirectional
                                                        //         .fromSTEB(
                                                        //             10.0,
                                                        //             0.0,
                                                        //             10.0,
                                                        //             0.0),
                                                        // width:
                                                        //     MediaQuery.of(context)
                                                        //         .size
                                                        //         .width,
                                                        // height: 60,
                                                        // color: Colors.red,
                                                        child: Text(
                                                          element['CONDITION'],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelLarge,
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          Container(
                                            // width: MediaQuery.sizeOf(context).width * 1.0,
                                            // height: 60,
                                            decoration: BoxDecoration(),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 15.0, 10.0, 15.0),
                                              child: HtmlWidget(
                                                '${productDetail!['รายละเอียด'] == null ? '' : productDetail!['รายละเอียด']}',
                                                // textStyle: TextStyle(
                                                //   fontFamily: 'GreenHome',
                                                // ),
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          lineHeight: 1.25,
                                                        ),
                                              ),

                                              //  Text(
                                              //     productDetail!['รายละเอียด'],
                                              //     style: FlutterFlowTheme.of(context)
                                              //         .bodySmall
                                              //         .override(
                                              //           fontFamily: 'Kanit',
                                              //           fontSize: MediaQuery.sizeOf(context)
                                              //                       .width >=
                                              //                   800.0
                                              //               ? 15.0
                                              //               : 12.0,
                                              //           fontWeight: FontWeight.w500,
                                              //           lineHeight: 1.25,
                                              //         ),
                                              //     maxLines: 7,
                                              //     overflow: TextOverflow.clip,
                                              //   ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 50),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  width: 300,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent2,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        // SizedBox(
                                                        //   width: 20,
                                                        // ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 30.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                              ),
                                                              child: StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                return Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () =>
                                                                          decrement(
                                                                        productCount,
                                                                        setState,
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            // shape: BoxShape.circle,
                                                                            // color: productCount[i] >
                                                                            //         0
                                                                            //     ? Theme.of(context)
                                                                            //         .primaryColor
                                                                            //     : Theme.of(context)
                                                                            //         .disabledColor,

                                                                            ),
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .minus,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              12.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await showModalBottomSheet(
                                                                          isDismissible:
                                                                              false,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.vertical(
                                                                              top: Radius.circular(40.0), // ตั้งค่าเพื่อทำให้มุมบนสองข้างเป็นโค้ง
                                                                            ),
                                                                          ),
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
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
                                                                                    controller: inModalDialogProductDetail,
                                                                                    onEditingComplete: () async {
                                                                                      inModalDialogProductDetail.clear();
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    onChanged: (value) async {
                                                                                      productCount = int.parse(value);

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
                                                                                        if (inModalDialogProductDetail.text.isEmpty) {
                                                                                          print('ไม่ได้กรอกจำนวน');
                                                                                          Navigator.of(context).pop();
                                                                                        } else {
                                                                                          productCount = int.parse(inModalDialogProductDetail.text);

                                                                                          inModalDialogProductDetail.clear();
                                                                                          Navigator.of(context).pop();

                                                                                          setState(
                                                                                            () {},
                                                                                          );
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
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          color: Theme.of(context)
                                                                              .disabledColor
                                                                              .withOpacity(0.2),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          productCount
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                14.0,
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
                                                                        productCount,
                                                                        setState,
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            // shape: BoxShape.circle,
                                                                            // color: Theme.of(context)
                                                                            //     .primaryColor,
                                                                            ),
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .plus,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              12.0,
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
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            productDetail!['ยูนิต']
                                                                        .length ==
                                                                    0
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    width: 50,
                                                                    height:
                                                                        12.5,
                                                                    // color: Colors.red,
                                                                    child: Text(
                                                                      'Sold Out',
                                                                      // productList[i]['UNIT'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.red),
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.vertical(
                                                                            top:
                                                                                Radius.circular(40.0), // ตั้งค่าเพื่อทำให้มุมบนสองข้างเป็นโค้ง
                                                                          ),
                                                                        ),
                                                                        isDismissible:
                                                                            true,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 500,
                                                                              child: Center(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      child: ListView(
                                                                                        padding: EdgeInsets.only(top: 40, bottom: 40, left: 100, right: 100),
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
                                                                                          for (var element in productDetail!['ยูนิต'])
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                print("onTap");
                                                                                                print(element);

                                                                                                int index = productDetail!['ยูนิต'].indexOf(element);

                                                                                                setState(
                                                                                                  () {
                                                                                                    priceChooseproductDetail = productDetail!['ราคา'][index];

                                                                                                    int dotIndex = priceChooseproductDetail!.indexOf(".");
                                                                                                    if (dotIndex != -1 && dotIndex + 3 <= priceChooseproductDetail!.length) {
                                                                                                      priceChooseproductDetail = priceChooseproductDetail!.substring(0, dotIndex + 3);
                                                                                                    }

                                                                                                    unitChooseproductDetail = element;
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                );
                                                                                                // controllerproductDetail.hideMenu();
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
                                                                        unitChooseproductDetail!,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall),
                                                                  )
                                                            // : CustomPopupMenu(
                                                            //     child: Container(
                                                            //         alignment: Alignment.topCenter,
                                                            //         width: 50,
                                                            //         height: 20,
                                                            //         child: Text(
                                                            //           unitChooseproductDetail!,
                                                            //           style:
                                                            //               TextStyle(
                                                            //             fontSize:
                                                            //                 12,
                                                            //           ),
                                                            //           maxLines:
                                                            //               1,
                                                            //         )
                                                            //         // padding: EdgeInsets.all(20),
                                                            //         ),
                                                            //     menuBuilder:
                                                            //         () {
                                                            //       return Container(
                                                            //         alignment:
                                                            //             Alignment.topCenter,
                                                            //         width:
                                                            //             100,
                                                            //         height:
                                                            //             100,
                                                            //         color: Colors
                                                            //             .grey
                                                            //             .shade300,
                                                            //         child:
                                                            //             ListView(
                                                            //           padding:
                                                            //               EdgeInsets.zero,
                                                            //           children: [
                                                            //             for (var element
                                                            //                 in productDetail!['ยูนิต'])
                                                            //               GestureDetector(
                                                            //                 onTap: () {
                                                            //                   print("onTap");
                                                            //                   print(element);

                                                            //                   int index = productDetail!['ยูนิต'].indexOf(element);

                                                            //                   setState(
                                                            //                     () {
                                                            //                       priceChooseproductDetail = productDetail!['ราคา'][index];

                                                            //                       int dotIndex = priceChooseproductDetail!.indexOf(".");
                                                            //                       if (dotIndex != -1 && dotIndex + 3 <= priceChooseproductDetail!.length) {
                                                            //                         priceChooseproductDetail = priceChooseproductDetail!.substring(0, dotIndex + 3);
                                                            //                       }

                                                            //                       unitChooseproductDetail = element;
                                                            //                     },
                                                            //                   );
                                                            //                   controllerproductDetail.hideMenu();
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
                                                            //     },
                                                            //     pressType:
                                                            //         PressType
                                                            //             .singleClick,
                                                            //     verticalMargin:
                                                            //         -10,
                                                            //     controller:
                                                            //         controllerproductDetail,
                                                            //   ),
                                                            // Text(
                                                            //   'หน่วย',
                                                            //   style: FlutterFlowTheme
                                                            //           .of(context)
                                                            //       .bodyMedium,
                                                            // ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            FFButtonWidget(
                                                              onPressed: () {
                                                                print(
                                                                    'Button pressed ...');

                                                                print(
                                                                    orderLast);
                                                                if (productDetail![
                                                                            'ยูนิต']
                                                                        .length ==
                                                                    0) {
                                                                  print(
                                                                      'SOLD OUT');
                                                                } else {
                                                                  try {
                                                                    bool
                                                                        checkProductSame =
                                                                        false;

                                                                    for (var element
                                                                        in orderLast[
                                                                            'ProductList']) {
                                                                      if (productDetail!['DocId'] ==
                                                                              element[
                                                                                  'DocID'] &&
                                                                          unitChooseproductDetail ==
                                                                              element['ยูนิต']) {
                                                                        // print(
                                                                        //     productList[i]['DocId']);
                                                                        // print(element['DocID']);
                                                                        print(
                                                                            'ซ้ำ');
                                                                        checkProductSame =
                                                                            true;
                                                                      } else {
                                                                        // print(
                                                                        //     productList[i]['DocId']);
                                                                        // print(element['DocID']);
                                                                        print(
                                                                            'ไม่ซ้ำ');
                                                                      }
                                                                    }

                                                                    if (checkProductSame) {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "สินค้านี้อยู่ในตระกร้าแล้วค่ะ",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .CENTER,
                                                                          timeInSecForIosWeb:
                                                                              5,
                                                                          backgroundColor: Colors
                                                                              .red
                                                                              .shade900,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0);

                                                                      productCount =
                                                                          0;
                                                                    } else {
                                                                      if (productCount ==
                                                                          0) {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "คุณยังไม่ได้เลือกจำนวนค่ะ",
                                                                            toastLength: Toast
                                                                                .LENGTH_SHORT,
                                                                            gravity: ToastGravity
                                                                                .CENTER,
                                                                            timeInSecForIosWeb:
                                                                                5,
                                                                            backgroundColor:
                                                                                Colors.red.shade900,
                                                                            textColor: Colors.white,
                                                                            fontSize: 16.0);
                                                                      } else {
                                                                        orderLast['ProductList']
                                                                            .add(
                                                                          {
                                                                            'DocID':
                                                                                productDetail!['DocId'],
                                                                            'ProductID':
                                                                                productDetail!['PRODUCT_ID'],
                                                                            'ชื่อสินค้า':
                                                                                productDetail!['NAMES'],
                                                                            'คำอธิบายสินค้า':
                                                                                productDetail!['รายละเอียดสตริง'],
                                                                            'PromotionProductID':
                                                                                productDetail!['PRODUCT_ID'],
                                                                            'สินค้าโปรโมชั่น':
                                                                                false,
                                                                            'คำอธิบายโปรโมชั่น':
                                                                                '',
                                                                            'จำนวน':
                                                                                productCount,
                                                                            'ราคา':
                                                                                priceChooseproductDetail,
                                                                            'ยูนิต':
                                                                                unitChooseproductDetail,
                                                                            'LeadTime':
                                                                                productDetail!['LeadTime'],
                                                                            // 'ราคา':
                                                                            //     productDetail!['PRICE'],
                                                                            'ราคาพิเศษ':
                                                                                false,
                                                                          },
                                                                        );

                                                                        double
                                                                            total =
                                                                            0;
                                                                        print(
                                                                            total);

                                                                        for (var element
                                                                            in orderLast['ProductList']) {
                                                                          print(
                                                                              element['จำนวน']);
                                                                          print(
                                                                              element['ราคา']);

                                                                          int qty =
                                                                              int.parse(element['จำนวน'].toString());
                                                                          double
                                                                              price =
                                                                              double.parse(element['ราคา'].toString());
                                                                          double
                                                                              sumTotal =
                                                                              qty * price;

                                                                          total =
                                                                              total + sumTotal;
                                                                          print(
                                                                              '---');
                                                                          print(
                                                                              total);
                                                                        }
                                                                        print(
                                                                            'object');
                                                                        print(
                                                                            total);

                                                                        orderLast['ยอดรวม'] =
                                                                            total;
                                                                        print(orderLast[
                                                                            'ยอดรวม']);

                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "ใส่สินค้าลงตระกร้าแล้วค่ะ",
                                                                            toastLength: Toast
                                                                                .LENGTH_SHORT,
                                                                            gravity: ToastGravity
                                                                                .CENTER,
                                                                            timeInSecForIosWeb:
                                                                                5,
                                                                            backgroundColor:
                                                                                Colors.green.shade900,
                                                                            textColor: Colors.white,
                                                                            fontSize: 16.0);

                                                                        productCount =
                                                                            0;
                                                                      }
                                                                    }
                                                                    if (mounted) {
                                                                      toSetstate();
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  } catch (e) {
                                                                    print(e);
                                                                  }
                                                                }
                                                              },
                                                              text: 'ใส่ตะกร้า',
                                                              options:
                                                                  FFButtonOptions(
                                                                height: 28.0,
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: productDetail![
                                                                                'ยูนิต']
                                                                            .length ==
                                                                        0
                                                                    ? Colors
                                                                        .grey
                                                                        .shade400
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Kanit',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                    ),
                                                                elevation: 0.0,
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 0.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8.0),
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })),
                          Expanded(
                              flex: 1,
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Container(
                                    height: double.infinity,
                                    // color: Colors.green,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          for (int i = 0;
                                              i < productList.length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Container(
                                                // color: Colors.red,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      height: MediaQuery.sizeOf(
                                                                      context)
                                                                  .width >=
                                                              800.0
                                                          ? 280.0
                                                          : 220.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent1,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.00, 0.00),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width >=
                                                                    800.0
                                                                ? 240.0
                                                                : 191.0,
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                1.0,
                                                            child: Stack(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.00,
                                                                          0.00),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            10.0),
                                                                    child:
                                                                        InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        // Navigator.push(
                                                                        //         context,
                                                                        //         CupertinoPageRoute(
                                                                        //           builder:
                                                                        //               (context) =>
                                                                        //                   A090301ProductDetailTeam(
                                                                        //             customerID:
                                                                        //                 widget.customerID,
                                                                        //             orderDataMap:
                                                                        //                 orderLast,
                                                                        //             product:
                                                                        //                 productList[i],
                                                                        //           ),
                                                                        //         ))
                                                                        //     .then(
                                                                        //         (result) {
                                                                        //   // ตรวจสอบค่าที่ถูกส่งกลับมา
                                                                        //   if (result !=
                                                                        //           null &&
                                                                        //       result is Map<
                                                                        //           String,
                                                                        //           dynamic>) {
                                                                        //     Map<String,
                                                                        //             dynamic>
                                                                        //         orderLast =
                                                                        //         result[
                                                                        //             'orderLast'];
                                                                        //     String
                                                                        //         additionalString =
                                                                        //         result[
                                                                        //             'groupName'];

                                                                        //     if (additionalString ==
                                                                        //         '') {
                                                                        //       orderLast =
                                                                        //           orderLast;
                                                                        //     } else {
                                                                        //       changeGroupProductList(
                                                                        //           additionalString);

                                                                        //       orderLast =
                                                                        //           orderLast;
                                                                        //       if (mounted) {
                                                                        //         setState(
                                                                        //             () {});
                                                                        //       }
                                                                        //     }

                                                                        //     // ทำอะไรก็ตามที่ต้องการกับข้อมูลที่ถูกส่งกลับมา
                                                                        //   }
                                                                        // });
                                                                      },
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: productList[i]['รูปภาพ'] == null ||
                                                                                productList[i]['รูปภาพ'].isEmpty
                                                                            ? Image.asset(
                                                                                'assets/images/noproductimage.png',
                                                                                width: MediaQuery.sizeOf(context).width * 0.2,
                                                                                height: MediaQuery.sizeOf(context).height * 0.2,
                                                                                fit: BoxFit.contain,
                                                                              )
                                                                            : productList[i]['รูปภาพ'][0] == ''
                                                                                ? Image.asset(
                                                                                    'assets/images/noproductimage.png',
                                                                                    width: MediaQuery.sizeOf(context).width * 0.2,
                                                                                    height: MediaQuery.sizeOf(context).height * 0.2,
                                                                                    fit: BoxFit.contain,
                                                                                  )
                                                                                : Image.network(
                                                                                    // '',
                                                                                    productList[i]['รูปภาพ'][0],
                                                                                    width: MediaQuery.sizeOf(context).width * 0.2,
                                                                                    height: MediaQuery.sizeOf(context).height * 0.2,
                                                                                    fit: BoxFit.contain,
                                                                                  ),

                                                                        //  Image
                                                                        //     .network(
                                                                        //   // '',
                                                                        //   productList[i]
                                                                        //       [
                                                                        //       'รูปภาพ'][0],
                                                                        //   width: MediaQuery.sizeOf(
                                                                        //               context)
                                                                        //           .width *
                                                                        //       0.2,
                                                                        //   height: MediaQuery.sizeOf(
                                                                        //               context)
                                                                        //           .height *
                                                                        //       0.2,
                                                                        //   fit: BoxFit
                                                                        //       .contain,
                                                                        // ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          1.00,
                                                                          -1.00),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            15.0,
                                                                            0.0),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        if (productList[i]['Favorite'] ==
                                                                            true) {
                                                                          productList[i]['Favorite'] =
                                                                              false;

                                                                          // List<dynamic>
                                                                          //     listFav =
                                                                          //     userData!['สินค้าถูกใจ'];
                                                                          List<dynamic>
                                                                              listFav =
                                                                              customerDataFetch!['สินค้าถูกใจ'];
                                                                          listFav.removeWhere((element) =>
                                                                              element ==
                                                                              productList[i]['PRODUCT_ID']);
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection(AppSettings.customerType == CustomerType.Test ? 'CustomerTest' : 'Customer')
                                                                              // .collection(
                                                                              //     'User')
                                                                              // .doc(userData![
                                                                              //     'UserID'])
                                                                              .doc(customerDataFetch['CustomerID'])
                                                                              .update(
                                                                            {
                                                                              'สินค้าถูกใจ': listFav,
                                                                            },
                                                                          ).then((value) {
                                                                            listFavToback =
                                                                                listFav;
                                                                            if (mounted) {
                                                                              setState(() {});
                                                                            }
                                                                          });
                                                                        } else {
                                                                          productList[i]['Favorite'] =
                                                                              true;
                                                                          // List<dynamic>
                                                                          //     listFav =
                                                                          //     userData!['สินค้าถูกใจ'];
                                                                          List<dynamic>
                                                                              listFav =
                                                                              customerDataFetch!['สินค้าถูกใจ'];
                                                                          listFav.add(productList[i]
                                                                              [
                                                                              'PRODUCT_ID']);
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection(AppSettings.customerType == CustomerType.Test ? 'CustomerTest' : 'Customer')

                                                                              // .collection(
                                                                              //     'User')
                                                                              // .doc(userData![
                                                                              //     'UserID'])
                                                                              .doc(customerDataFetch['CustomerID'])
                                                                              .update(
                                                                            {
                                                                              'สินค้าถูกใจ': listFav,
                                                                            },
                                                                          ).then((value) {
                                                                            listFavToback =
                                                                                listFav;
                                                                            if (mounted) {
                                                                              setState(() {});
                                                                            }
                                                                          });
                                                                        }
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        productList[i]['Favorite'] ==
                                                                                true
                                                                            ? Icons.favorite_sharp
                                                                            : Icons.favorite_border_sharp,
                                                                        color: productList[i]['Favorite'] ==
                                                                                true
                                                                            ? FlutterFlowTheme.of(context).alternate
                                                                            : FlutterFlowTheme.of(context).secondaryText,
                                                                        size:
                                                                            24.0,
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
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    5.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          1.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          SizedBox(
                                                                        width: productList[i]['แท๊ก'].isEmpty
                                                                            ? 235
                                                                            : 145,
                                                                        child:
                                                                            Text(
                                                                          productList[i]
                                                                              [
                                                                              'NAMES'],
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .override(
                                                                                fontFamily: 'Kanit',
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                fontWeight: FontWeight.w500,
                                                                                lineHeight: 1.25,
                                                                              ),
                                                                          maxLines:
                                                                              2,
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
                                                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color: Colors
                                                                                .red.shade900,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            lineHeight:
                                                                                1.25,
                                                                            fontSize:
                                                                                12),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      )
                                                                    : Text(
                                                                        productList[i]['ประเภทสินค้าDesc'] ==
                                                                                'สินค้าเคลื่อนไหวเร็ว (Fast Moving)'
                                                                            ? 'Fast Moving'
                                                                            : productList[i]['ประเภทสินค้าDesc'] == 'สินค้าที่ต้องสั่งจองล่วงหน้า (Pre-Order)'
                                                                                ? 'Pre-Order'
                                                                                : productList[i]['ประเภทสินค้าDesc'] == 'สินค้าที่โรงงานผลิต​ (PCF)'
                                                                                    ? 'PCF'
                                                                                    : '',
                                                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color: Colors
                                                                                .red.shade900,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            lineHeight:
                                                                                1.25,
                                                                            fontSize:
                                                                                12),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'ราคา ${priceChoose[i]} บาท',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            lineHeight:
                                                                                1.25,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                // Row(
                                                                //   mainAxisSize:
                                                                //       MainAxisSize
                                                                //           .max,
                                                                //   children: [
                                                                //     Text(
                                                                //       'ราคา ${productList[i]['PRICE']} บาท',
                                                                //       style: FlutterFlowTheme.of(
                                                                //               context)
                                                                //           .titleSmall
                                                                //           .override(
                                                                //             fontFamily:
                                                                //                 'Kanit',
                                                                //             color:
                                                                //                 FlutterFlowTheme.of(context).primaryText,
                                                                //             lineHeight:
                                                                //                 1.25,
                                                                //           ),
                                                                //     ),
                                                                //   ],
                                                                // ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            productList[i]
                                                                        ['แท๊ก']
                                                                    .isEmpty
                                                                ? SizedBox()
                                                                : Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              75,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                4.0,
                                                                                10.0,
                                                                                4.0),
                                                                            child:
                                                                                Text(
                                                                              '${productList[i]['แท๊ก'][0]}',
                                                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                    fontFamily: 'Kanit',
                                                                                    color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                      // height: 60,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    10.0,
                                                                    3.0,
                                                                    10.0,
                                                                    4.0),
                                                        child:
                                                            // HtmlWidget(
                                                            //   '${productList[i]['รายละเอียด'] == null ? '' : productList[i]['รายละเอียด']}',
                                                            //   // textStyle: TextStyle(
                                                            //   //   fontFamily: 'GreenHome',
                                                            //   // ),
                                                            //   textStyle:
                                                            //       FlutterFlowTheme.of(
                                                            //               context)
                                                            //           .bodySmall
                                                            //           .override(
                                                            //             fontFamily: 'Kanit',
                                                            //             fontSize: MediaQuery.sizeOf(
                                                            //                             context)
                                                            //                         .width >=
                                                            //                     800.0
                                                            //                 ? 13.0
                                                            //                 : 10.0,
                                                            //             fontWeight:
                                                            //                 FontWeight.w500,
                                                            //             lineHeight: 1.25,
                                                            //           ),
                                                            // ),
                                                            Text(
                                                          '${productList[i]['รายละเอียดสตริง']}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                fontSize:
                                                                    MediaQuery.sizeOf(context).width >=
                                                                            800.0
                                                                        ? 13.0
                                                                        : 10.0,
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
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      height: 32.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent2,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 30.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                  ),
                                                                  child: StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setState) {
                                                                    return Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () =>
                                                                              decrementList(
                                                                            i,
                                                                            productCountList[i],
                                                                            setState,
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(8),
                                                                            decoration: BoxDecoration(
                                                                                // shape: BoxShape.circle,
                                                                                // color: productCount[i] >
                                                                                //         0
                                                                                //     ? Theme.of(context)
                                                                                //         .primaryColor
                                                                                //     : Theme.of(context)
                                                                                //         .disabledColor,

                                                                                ),
                                                                            child:
                                                                                FaIcon(
                                                                              FontAwesomeIcons.minus,
                                                                              color: Colors.black,
                                                                              size: 12.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
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
                                                                                        controller: inModalDialog[i],
                                                                                        onEditingComplete: () async {
                                                                                          inModalDialog[i].clear();
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        onChanged: (value) async {
                                                                                          productCountList![i] = int.parse(value);

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
                                                                                            if (inModalDialog[i].text.isEmpty) {
                                                                                              print('ไม่ได้กรอกจำนวน');
                                                                                              Navigator.of(context).pop();
                                                                                            } else {
                                                                                              productCountList[i] = int.parse(inModalDialog[i].text);

                                                                                              inModalDialog[i].clear();
                                                                                              Navigator.of(context).pop();

                                                                                              setState(
                                                                                                () {},
                                                                                              );
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
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 16),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.rectangle,
                                                                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              productCountList[i].toString(),
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 14.0,
                                                                                fontFamily: 'Kanit',
                                                                                letterSpacing: 2.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () =>
                                                                              incrementList(
                                                                            i,
                                                                            productCountList[i],
                                                                            setState,
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(8),
                                                                            decoration: BoxDecoration(
                                                                                // shape: BoxShape.circle,
                                                                                // color: Theme.of(context)
                                                                                //     .primaryColor,
                                                                                ),
                                                                            child:
                                                                                FaIcon(
                                                                              FontAwesomeIcons.plus,
                                                                              color: Colors.black,
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
                                                            productList[i]['ยูนิต']
                                                                        .length ==
                                                                    0
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    width: 50,
                                                                    height:
                                                                        12.5,
                                                                    // color: Colors.red,
                                                                    child: Text(
                                                                      'Sold Out',
                                                                      // productList[i]['UNIT'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.red),
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      await showModalBottomSheet(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.vertical(
                                                                            top:
                                                                                Radius.circular(40.0), // ตั้งค่าเพื่อทำให้มุมบนสองข้างเป็นโค้ง
                                                                          ),
                                                                        ),
                                                                        isDismissible:
                                                                            true,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 500,
                                                                              child: Center(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      child: ListView(
                                                                                        padding: EdgeInsets.only(top: 40, bottom: 40, left: 100, right: 100),
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
                                                                        unitChoose[
                                                                            i],
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall),
                                                                  ),
                                                            // : CustomPopupMenu(
                                                            //     child: Container(
                                                            //         alignment: Alignment.topCenter,
                                                            //         width: 50,
                                                            //         height: 20,
                                                            //         child: Text(
                                                            //           unitChoose[
                                                            //               i],
                                                            //           style:
                                                            //               TextStyle(
                                                            //             fontSize:
                                                            //                 12,
                                                            //           ),
                                                            //           maxLines:
                                                            //               1,
                                                            //         )
                                                            //         // padding: EdgeInsets.all(20),
                                                            //         ),
                                                            //     menuBuilder:
                                                            //         () {
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
                                                            //         alignment:
                                                            //             Alignment.topCenter,
                                                            //         width:
                                                            //             100,
                                                            //         height:
                                                            //             100,
                                                            //         color: Colors
                                                            //             .grey
                                                            //             .shade300,
                                                            //         child:
                                                            //             ListView(
                                                            //           padding:
                                                            //               EdgeInsets.zero,
                                                            //           children: [
                                                            //             for (var element
                                                            //                 in productList[i]['ยูนิต'])
                                                            //               GestureDetector(
                                                            //                 onTap: () {
                                                            //                   print("onTap");
                                                            //                   print(element);

                                                            //                   int index = productList[i]['ยูนิต'].indexOf(element);

                                                            //                   setState(
                                                            //                     () {
                                                            //                       priceChoose[i] = productList[i]['ราคา'][index];

                                                            //                       int dotIndex = priceChoose[i].indexOf(".");
                                                            //                       if (dotIndex != -1 && dotIndex + 3 <= priceChoose[i].length) {
                                                            //                         priceChoose[i] = priceChoose[i].substring(0, dotIndex + 3);
                                                            //                       }

                                                            //                       print(priceChoose[i]);
                                                            //                       print(priceChoose[i]);
                                                            //                       print(priceChoose[i]);
                                                            //                       print(priceChoose[i]);
                                                            //                       print(priceChoose[i]);
                                                            //                       unitChoose[i] = element;
                                                            //                       print(unitChoose[i]);
                                                            //                       print(unitChoose[i]);
                                                            //                       print(unitChoose[i]);
                                                            //                       print(unitChoose[i]);
                                                            //                       print(unitChoose[i]);
                                                            //                     },
                                                            //                   );
                                                            //                   controller[i].hideMenu();
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
                                                            //     pressType:
                                                            //         PressType
                                                            //             .singleClick,
                                                            //     verticalMargin:
                                                            //         -10,
                                                            //     controller:
                                                            //         controller[
                                                            //             i],
                                                            //   ),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        'Button pressed ...');

                                                                    print(
                                                                        orderLast);
                                                                    if (productList[i]['ยูนิต']
                                                                            .length ==
                                                                        0) {
                                                                      print(
                                                                          'SOLD OUT');
                                                                    } else {
                                                                      try {
                                                                        bool
                                                                            checkProductSame =
                                                                            false;

                                                                        for (var element
                                                                            in orderLast!['ProductList']) {
                                                                          if (productList[i]['DocId'] == element['DocID'] &&
                                                                              unitChoose[i] == element['ยูนิต']) {
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
                                                                              msg: "สินค้านี้อยู่ในตระกร้าแล้วค่ะ",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 5,
                                                                              backgroundColor: Colors.red.shade900,
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0);

                                                                          productCountList[i] =
                                                                              0;
                                                                        } else {
                                                                          if (productCountList[i] ==
                                                                              0) {
                                                                            Fluttertoast.showToast(
                                                                                msg: "คุณยังไม่ได้เลือกจำนวนค่ะ",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 5,
                                                                                backgroundColor: Colors.red.shade900,
                                                                                textColor: Colors.white,
                                                                                fontSize: 16.0);
                                                                          } else {
                                                                            orderLast['ProductList'].add(
                                                                              {
                                                                                'DocID': productList[i]['DocId'],
                                                                                'ProductID': productList[i]['PRODUCT_ID'],
                                                                                'ชื่อสินค้า': productList[i]['NAMES'],
                                                                                'คำอธิบายสินค้า': productList[i]['รายละเอียดสตริง'],
                                                                                'PromotionProductID': productList[i]['PRODUCT_ID'],
                                                                                'สินค้าโปรโมชั่น': false,
                                                                                'คำอธิบายโปรโมชั่น': '',
                                                                                'จำนวน': productCountList[i],
                                                                                'ราคา': priceChoose[i],
                                                                                'ยูนิต': unitChoose[i],
                                                                                'LeadTime': productList[i]['LeadTime'],
                                                                                // 'ราคา': productList[i]['PRICE'],
                                                                                'ราคาพิเศษ': false,
                                                                              },
                                                                            );

                                                                            double
                                                                                total =
                                                                                0;
                                                                            print(total);

                                                                            for (var element
                                                                                in orderLast!['ProductList']) {
                                                                              print(element['จำนวน']);
                                                                              print(element['ราคา']);

                                                                              int qty = int.parse(element['จำนวน'].toString());
                                                                              double price = double.parse(element['ราคา'].toString());
                                                                              double sumTotal = qty * price;

                                                                              total = total + sumTotal;
                                                                              print('---');
                                                                              print(total);
                                                                            }
                                                                            print('object');
                                                                            print(total);

                                                                            orderLast['ยอดรวม'] =
                                                                                total;
                                                                            print(orderLast!['ยอดรวม']);

                                                                            Fluttertoast.showToast(
                                                                                msg: "ใส่สินค้าลงตระกร้าแล้วค่ะ",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 5,
                                                                                backgroundColor: Colors.green.shade900,
                                                                                textColor: Colors.white,
                                                                                fontSize: 16.0);

                                                                            productCountList[i] =
                                                                                0;
                                                                          }
                                                                        }
                                                                        if (mounted) {
                                                                          toSetstate();
                                                                        }
                                                                      } catch (e) {
                                                                        print(
                                                                            e);
                                                                      }
                                                                    }
                                                                  },
                                                                  text:
                                                                      'ใส่ตะกร้า',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    height:
                                                                        28.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: productList[i]['ยูนิต'].length ==
                                                                            0
                                                                        ? Colors
                                                                            .grey
                                                                            .shade400
                                                                        : FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                    elevation:
                                                                        0.0,
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width:
                                                                          0.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              8.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              0.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              8.0),
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
                                              ),
                                            ),
                                        ],
                                      ),
                                    ));
                              })),
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
