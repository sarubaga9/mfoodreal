import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:m_food/a01_home/a01_05_dashboard/a0105_dashboard_widget.dart';
import 'package:m_food/controller/product_controller.dart';
import 'package:m_food/controller/product_group_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shimmer/shimmer.dart';

import '/components/appbar_search_widget.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'a0101_home_model.dart';
export 'a0101_home_model.dart';

class A0101HomeWidget extends StatefulWidget {
  const A0101HomeWidget({Key? key}) : super(key: key);

  @override
  _A0101HomeWidgetState createState() => _A0101HomeWidgetState();
}

class _A0101HomeWidgetState extends State<A0101HomeWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textController = TextEditingController();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  final productController = Get.find<ProductController>();
  RxMap<String, dynamic>? productGetData;

  final productGroupController = Get.find<ProductGroupController>();
  RxMap<String, dynamic>? productGroupGetData;

  bool isLoading = false;
  List<Map<String, dynamic>> resultList = [];
  List<Map<String, dynamic>> resultListAll = [];

  List<Map<String, dynamic>> resultProductGroupList = [];
  List<Map<String, dynamic>> firstList = [];
  List<Map<String, dynamic>> secondList = [];

  Map<String, dynamic>? tagProduct;
  List<Map<String, dynamic>> tagresultList = [];

  String checkFavGroup = '';

  @override
  void initState() {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => A0107PasswordResetWidget(data: {})));
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });

    userData = userController.userData;
    productGetData = productController.productData;

    productGroupGetData = productGroupController.productGroupData;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('แท็กสินค้า').get();

    for (int index = 0; index < querySnapshot.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshot.docs[index].data() as Map<String, dynamic>;

      if (docData['IS_ACTIVE'] == true) {
        // tagProduct!['key$index'] = docData;
        tagresultList.add(docData);
      }
    }

//

    if (productGetData != null) {
      productGetData!.forEach((key, value) {
        Map<String, dynamic> entry = value;

        // เพิ่มข้อมูล 'รายละเอียดสตริง' : 'นี่คือข้อความ' ลงใน Map
        String parsedstring3 = Bidi.stripHtmlIfNeeded(
            entry['รายละเอียด'] == null ? '' : entry['รายละเอียด']);
        entry['รายละเอียดสตริง'] = parsedstring3.trimLeft().trimRight();

        List<String>? name = [];
        if (entry['Tag'] == null) {
        } else {
          if (entry['Tag'] == '') {
          } else {
            for (var element in entry['Tag']) {
              Map<String, dynamic>? foundMap = tagresultList.firstWhere(
                (map) => map['DocId'] == element,
                orElse: () => {},
              );

              name!.add(foundMap['Name']);
            }
          }
        }

        entry['แท๊ก'] = name;

        // bool isStringFound = false;


        // if (userData!.isEmpty) {
        //   entry['Favorite'] = false;
        // } else {
        //   for (int i = 0; i < userData!['สินค้าถูกใจ'].length; i++) {
        //     if (userData!['สินค้าถูกใจ'][i] == entry['PRODUCT_ID']) {
        //       isStringFound = true;
        //     }
        //   }

        //   if (isStringFound) {
        //     entry['Favorite'] = true;
        //   } else {
        //     entry['Favorite'] = false;
        //   }
        // }



        if (entry['RESULT'] == false) {
        } else {
          resultList.add(entry);
          resultListAll.add(entry);
        }
      });
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

      for (var element in tagresultList) {
        Map<String, dynamic> tagProduct = {
          'GroupProductID': element['DocId'],
          'IMG': element['IMG'],
          'GROUP_SHOW': element['Name'],
          'GROUP_DESC': element['Name']
        };
        resultProductGroupList.add(tagProduct);
      }

      productGroupGetData!.forEach((key, value) {
        Map<String, dynamic> entry = value;
        resultProductGroupList.add(entry);
      });
    }

    int totalLength = resultProductGroupList.length;
    int firstListLength = totalLength ~/ 2 + totalLength % 2;
    int secondListLength = totalLength - firstListLength;

    firstList = resultProductGroupList.sublist(0, firstListLength);
    secondList = resultProductGroupList.sublist(firstListLength);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeGroupProductList(String nameGroup) {
    checkFavGroup = nameGroup;
    // searchTextController.clear();

    bool isStringFound = tagresultList.any((map) => map['Name'] == nameGroup);

    if (isStringFound) {
      resultList.clear();

      // List<Map<String, dynamic>> checkProduct = resultListAll;
      List<Map<String, dynamic>> checkProduct = List.from(resultListAll);
      checkProduct.removeWhere((map) {
        bool returnType = true;
        for (int i = 0; i < map['แท๊ก'].length; i++) {
          if (map['แท๊ก'][i] == nameGroup) {
            returnType = false;
          }
        }

        return returnType;
      });

      resultList.addAll(checkProduct);


      // productCount.clear();
      // for (var element in resultList) {
      // productCount.add(0);
      // }
      resultList.sort((a, b) {
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

      // unitChoose.clear();
      // priceChoose.clear();

      // for (var element in resultList) {
      //   unitChoose.add('');
      //   priceChoose.add('');
      //   unitChoose.last =
      //       element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

      //   String price = '';
      //   price = element['ราคา'].isEmpty
      //       ? element['PRICE'].toString()
      //       : element['ราคา'][0].toString();

      //   int dotIndex = price.indexOf(".");
      //   if (dotIndex != -1 && dotIndex + 3 <= price.length) {
      //     priceChoose.last = price.substring(0, dotIndex + 3);
      //   } else {
      //     priceChoose.last = price;
      //   }

      //   // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

      // }
    } else if (nameGroup == 'สินค้าชื่นชอบ' ||
        nameGroup == 'สินค้าที่เคยสั่งซื้อ') {

      resultList.clear();
      String text = '';
      if (nameGroup == 'สินค้าชื่นชอบ') {
        text = 'สินค้าถูกใจ';
      } else {
        text = 'สินค้าที่เคยสั่ง';
      }


      if (userData!.isEmpty) {
      } else {

        // List<Map<String, dynamic>> checkProduct = resultListAll;
        List<Map<String, dynamic>> checkProduct = List.from(resultListAll);
        checkProduct.removeWhere((map) {
          bool returnType = true;
          for (int i = 0; i < userData![text].length; i++) {
            if (userData![text][i] == map['PRODUCT_ID']) {
              if (text == 'สินค้าที่เคยสั่ง') {
                returnType = false;
              } else if (text == 'สินค้าถูกใจ') {
                returnType = true;
              } else {
                returnType = false;
              }
            }
          }

          return returnType;
        });

        resultList.addAll(checkProduct);


        // productCount.clear();
        // for (var element in resultList) {
        // productCount.add(0);
        // }
        resultList.sort((a, b) {
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

        // unitChoose.clear();
        // priceChoose.clear();

        // for (var element in resultList) {
        //   unitChoose.add('');
        //   priceChoose.add('');
        //   unitChoose.last =
        //       element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

        //   String price = '';
        //   price = element['ราคา'].isEmpty
        //       ? element['PRICE'].toString()
        //       : element['ราคา'][0].toString();

        //   int dotIndex = price.indexOf(".");
        //   if (dotIndex != -1 && dotIndex + 3 <= price.length) {
        //     priceChoose.last = price.substring(0, dotIndex + 3);
        //   } else {
        //     priceChoose.last = price;
        //   }

        //   // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

        // }
      }
    } else {
      if (nameGroup == 'สินค้าทั้งหมด') {
        resultList.clear();

        resultList.addAll(resultListAll);

        // productCount.clear();
        // for (var element in resultList) {
        // productCount.add(0);
        // }
      } else if (nameGroup == 'ราคาพิเศษ') {
        resultList.clear();

        // List<Map<String, dynamic>> checkProduct = resultListAll;
        List<Map<String, dynamic>> checkProduct = List.from(resultListAll);
        checkProduct.removeWhere((map) => map['ราคาพิเศษ'] == false);

        resultList.addAll(checkProduct);

        // productCount.clear();
        // for (var element in resultList) {
        // productCount.add(0);
        // }
      } else {
        resultList.clear();
        resultList = resultListAll
            .where((product) => product['PG2'] == nameGroup)
            .toList();

        // productCount.clear();
        // for (var element in resultList) {
        // productCount.add(0);
        // }
      }

      resultList.sort((a, b) {
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

      // unitChoose.clear();
      // priceChoose.clear();

      // for (var element in resultList) {
      //   unitChoose.add('');
      //   priceChoose.add('');
      //   unitChoose.last =
      //       element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

      //   String price = '';
      //   price = element['ราคา'].isEmpty
      //       ? element['PRICE'].toString()
      //       : element['ราคา'][0].toString();

      //   int dotIndex = price.indexOf(".");
      //   if (dotIndex != -1 && dotIndex + 3 <= price.length) {
      //     priceChoose.last = price.substring(0, dotIndex + 3);
      //   } else {
      //     priceChoose.last = price;
      //   }

      //   // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

      // }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void findNameProductList(String nameProduct) {

    resultList.clear();

    resultList = resultListAll
        .where((product) =>
            product['NAMES'].contains(nameProduct) ||
            product['PRODUCT_ID'].contains(nameProduct))
        .toList();

    // productCount.clear();
    // for (var element in resultList) {
    // productCount.add(0);
    // }

    resultList.sort((a, b) {
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

    // unitChoose.clear();
    // priceChoose.clear();

    // for (var element in resultList) {
    //   unitChoose.add('');
    //   priceChoose.add('');
    //   unitChoose.last =
    //       element['ยูนิต'].isEmpty ? element['UNIT'] : element['ยูนิต'][0];

    //   String price = '';
    //   price = element['ราคา'].isEmpty
    //       ? element['PRICE'].toString()
    //       : element['ราคา'][0].toString();

    //   int dotIndex = price.indexOf(".");
    //   if (dotIndex != -1 && dotIndex + 3 <= price.length) {
    //     priceChoose.last = price.substring(0, dotIndex + 3);
    //   } else {
    //     priceChoose.last = price;
    //   }

    //   // priceChoose.last = price.substring(0, price.indexOf(".") + 3);

    // }

    if (mounted) {
      setState(() {});
    }
  }

  _buildLoadingImage() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          // borderRadius:
          //     BorderRadius.circular(1.5 * MediaQuery.of(context).size.height),
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

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
        // top: true,
        child: isLoading
            ? CircularLoadingHome()
            : Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
                child: Container(
                  // color: Colors.red,
                  // height: 1300,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //==================== Appbar ================================
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 10.0, 0.0),
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
                                                    // context.pushNamed(
                                                    //     'A01_01_Home');
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
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
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.3,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .accent3,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        alignment:
                                            AlignmentDirectional(0.00, 0.00),
                                        child: TextFormField(
                                          // controller: _model.textController,
                                          // focusNode: _model.textFieldFocusNode,
                                          controller: textController,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Kanit',
                                                      color: Color(0xFFCBCBCB),
                                                    ),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                          // validator: _model.textControllerValidator.asValidator(context),
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
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (context) =>
                                                                A0105DashboardWidget(),
                                                          )).then((value) {
                                                        if (mounted) {
                                                          productGetData!
                                                              .forEach(
                                                                  (key, value) {
                                                            // print(value);
                                                            Map<String, dynamic>
                                                                entry = value;

                                                            // เพิ่มข้อมูล 'รายละเอียดสตริง' : 'นี่คือข้อความ' ลงใน Map
                                                            String
                                                                parsedstring3 =
                                                                Bidi.stripHtmlIfNeeded(
                                                                    entry['รายละเอียด'] ==
                                                                            null
                                                                        ? ''
                                                                        : entry[
                                                                            'รายละเอียด']);
                                                            // print(parsedstring3);
                                                            entry['รายละเอียดสตริง'] =
                                                                parsedstring3
                                                                    .trimLeft()
                                                                    .trimRight();

                                                            List<String>? name =
                                                                [];
                                                            if (entry['Tag'] ==
                                                                null) {
                                                            } else {
                                                              if (entry[
                                                                      'Tag'] ==
                                                                  '') {
                                                              } else {
                                                                for (var element
                                                                    in entry[
                                                                        'Tag']) {
                                                                  Map<String,
                                                                          dynamic>?
                                                                      foundMap =
                                                                      tagresultList
                                                                          .firstWhere(
                                                                    (map) =>
                                                                        map['DocId'] ==
                                                                        element,
                                                                    orElse:
                                                                        () =>
                                                                            {},
                                                                  );

                                                                  name!.add(
                                                                      foundMap[
                                                                          'Name']);
                                                                }
                                                              }
                                                            }

                                                            entry['แท๊ก'] =
                                                                name;

                                                            bool isStringFound =
                                                                false;


                                                            if (userData!
                                                                .isEmpty) {
                                                              entry['Favorite'] =
                                                                  false;
                                                            } else {
                                                              for (int i = 0;
                                                                  i <
                                                                      userData![
                                                                              'สินค้าถูกใจ']
                                                                          .length;
                                                                  i++) {
                                                                if (userData![
                                                                            'สินค้าถูกใจ']
                                                                        [i] ==
                                                                    entry[
                                                                        'PRODUCT_ID']) {
                                                                  isStringFound =
                                                                      true;
                                                                }
                                                              }

                                                              if (isStringFound) {
                                                                entry['Favorite'] =
                                                                    true;
                                                              } else {
                                                                entry['Favorite'] =
                                                                    false;
                                                              }
                                                            }


                                                            resultList
                                                                .add(entry);
                                                            resultListAll
                                                                .add(entry);
                                                          });
                                                          setState(() {});
                                                        }
                                                      });
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
                                                                  userData![
                                                                      'Img']),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                          // context.pushNamed('A01_02_Login');
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        A0102LoginWidget(),
                                                              )).then((value) {
                                                            productGetData!
                                                                .forEach((key,
                                                                    value) {
                                                              Map<String,
                                                                      dynamic>
                                                                  entry = value;

                                                              // เพิ่มข้อมูล 'รายละเอียดสตริง' : 'นี่คือข้อความ' ลงใน Map
                                                              String
                                                                  parsedstring3 =
                                                                  Bidi.stripHtmlIfNeeded(
                                                                      entry['รายละเอียด'] ==
                                                                              null
                                                                          ? ''
                                                                          : entry[
                                                                              'รายละเอียด']);
                                                              entry['รายละเอียดสตริง'] =
                                                                  parsedstring3
                                                                      .trimLeft()
                                                                      .trimRight();

                                                              List<String>?
                                                                  name = [];
                                                              if (entry[
                                                                      'Tag'] ==
                                                                  null) {
                                                              } else {
                                                                if (entry[
                                                                        'Tag'] ==
                                                                    '') {
                                                                } else {
                                                                  for (var element
                                                                      in entry[
                                                                          'Tag']) {
                                                                    Map<String,
                                                                            dynamic>?
                                                                        foundMap =
                                                                        tagresultList
                                                                            .firstWhere(
                                                                      (map) =>
                                                                          map['DocId'] ==
                                                                          element,
                                                                      orElse:
                                                                          () =>
                                                                              {},
                                                                    );

                                                                    name!.add(
                                                                        foundMap[
                                                                            'Name']);
                                                                  }
                                                                }
                                                              }

                                                              entry['แท๊ก'] =
                                                                  name;

                                                              bool
                                                                  isStringFound =
                                                                  false;


                                                              if (userData!
                                                                  .isEmpty) {
                                                                entry['Favorite'] =
                                                                    false;
                                                              } else {

                                                                for (int i = 0;
                                                                    i <
                                                                        userData!['สินค้าถูกใจ']
                                                                            .length;
                                                                    i++) {
                                                                  if (userData![
                                                                              'สินค้าถูกใจ']
                                                                          [i] ==
                                                                      entry[
                                                                          'PRODUCT_ID']) {
                                                                    isStringFound =
                                                                        true;
                                                                  }
                                                                }

                                                                if (isStringFound) {
                                                                  entry['Favorite'] =
                                                                      true;
                                                                } else {
                                                                  entry['Favorite'] =
                                                                      false;
                                                                }
                                                              }


                                                              resultList
                                                                  .add(entry);
                                                              resultListAll
                                                                  .add(entry);
                                                            });
                                                            setState(() {});
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.account_circle,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                            ),
                          ),
                        ],
                      ),

                      // Center(
                      //   child: Text(firstList.length.toString()),
                      // ),
                      // Center(
                      //   child: Text(secondList.length.toString()),
                      // ),
                      // Center(
                      //   child: Text(resultList.length.toString()),
                      // ),
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
                                                child: Image.network(
                                                  firstList[index]['IMG'] ==
                                                              null ||
                                                          firstList[index]
                                                                  ['IMG']
                                                              .isEmpty
                                                      ? ''
                                                      : firstList[index]['IMG'],
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
                                                  firstList[index]
                                                      ['GROUP_SHOW'],
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                                                  secondList[index]['IMG'] ==
                                                              null ||
                                                          secondList[index]
                                                                  ['IMG']
                                                              .isEmpty
                                                      ? ''
                                                      : secondList[index]
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
                                                  secondList[index]
                                                      ['GROUP_SHOW'],
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      //   width: MediaQuery.sizeOf(context).width * 0.75,
                      //   height: 120,
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Expanded(
                      //           child: ListView(
                      //             padding: EdgeInsets.only(left: 0.0),
                      //             physics: NeverScrollableScrollPhysics(),
                      //             shrinkWrap: true,
                      //             scrollDirection: Axis.horizontal,
                      //             children: [
                      //               for (int index = 0;
                      //                   index < firstList.length;
                      //                   index++)
                      //                 Padding(
                      //                   padding:
                      //                       EdgeInsets.fromLTRB(0, 0, 37.5, 0),
                      //                   child: Container(
                      //                     // color: Colors.red,
                      //                     width: 70.0,
                      //                     height: 35.0,
                      //                     child: Column(
                      //                       mainAxisSize: MainAxisSize.max,
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       children: [
                      //                         Expanded(
                      //                           child: Row(
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment.center,
                      //                             mainAxisSize:
                      //                                 MainAxisSize.max,
                      //                             children: [
                      //                               ClipRRect(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         50.0),
                      //                                 child: Image.network(
                      //                                   firstList[index]
                      //                                       ['รูปภาพ'],
                      //                                   width: 35.0,
                      //                                   height: 35.0,
                      //                                   fit: BoxFit.cover,
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         Row(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.center,
                      //                           mainAxisSize: MainAxisSize.max,
                      //                           children: [
                      //                             Container(
                      //                               // color: Colors.yellow,
                      //                               width: 70.0,
                      //                               alignment: Alignment.center,
                      //                               // height: 35.0,
                      //                               child: Expanded(
                      //                                 child: Text(
                      //                                   firstList[index]
                      //                                       ['ชื่อกลุ่ม'],
                      //                                   style:
                      //                                       FlutterFlowTheme.of(
                      //                                               context)
                      //                                           .bodySmall,
                      //                                   maxLines: 1,
                      //                                   overflow:
                      //                                       TextOverflow.clip,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //             ],
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 10,
                      //         ),
                      //         Expanded(
                      //           child: ListView(
                      //             padding: EdgeInsets.only(left: 0.0),
                      //             physics: NeverScrollableScrollPhysics(),
                      //             shrinkWrap: true,
                      //             scrollDirection: Axis.horizontal,
                      //             children: [
                      //               for (int indexj = 0;
                      //                   indexj < secondList.length;
                      //                   indexj++)
                      //                 Padding(
                      //                   padding:
                      //                       EdgeInsets.fromLTRB(0, 0, 37.5, 0),
                      //                   child: Container(
                      //                     // color: Colors.red,
                      //                     width: 70.0,
                      //                     height: 35.0,
                      //                     child: Column(
                      //                       mainAxisSize: MainAxisSize.max,
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       children: [
                      //                         Expanded(
                      //                           child: Row(
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment.center,
                      //                             mainAxisSize:
                      //                                 MainAxisSize.max,
                      //                             children: [
                      //                               ClipRRect(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         50.0),
                      //                                 child: Image.network(
                      //                                   secondList[indexj]
                      //                                       ['รูปภาพ'],
                      //                                   width: 35.0,
                      //                                   height: 35.0,
                      //                                   fit: BoxFit.cover,
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         Row(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.center,
                      //                           mainAxisSize: MainAxisSize.max,
                      //                           children: [
                      //                             Container(
                      //                               // color: Colors.yellow,
                      //                               width: 70.0,
                      //                               alignment: Alignment.center,
                      //                               // height: 35.0,
                      //                               child: Expanded(
                      //                                 child: Text(
                      //                                   secondList[indexj]
                      //                                       ['ชื่อกลุ่ม'],
                      //                                   style:
                      //                                       FlutterFlowTheme.of(
                      //                                               context)
                      //                                           .bodySmall,
                      //                                   maxLines: 1,
                      //                                   overflow:
                      //                                       TextOverflow.clip,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //             ],
                      //           ),
                      //         ),
                      //         // Expanded(
                      //         //   child: ListView.builder(
                      //         //     padding: EdgeInsets.only(left: 0.0),
                      //         //     physics: NeverScrollableScrollPhysics(),
                      //         //     shrinkWrap: true,
                      //         //     scrollDirection: Axis.horizontal,
                      //         //     itemCount: secondList.length,
                      //         //     itemBuilder: (context, index) {
                      //         //       return Padding(
                      //         //         padding:
                      //         //             EdgeInsets.fromLTRB(0, 0, 37.5, 0),
                      //         //         child: Container(
                      //         //           // color: Colors.red,
                      //         //           width: 70.0,
                      //         //           height: 35.0,
                      //         //           child: Column(
                      //         //             mainAxisSize: MainAxisSize.max,
                      //         //             mainAxisAlignment:
                      //         //                 MainAxisAlignment.center,
                      //         //             children: [
                      //         //               Expanded(
                      //         //                 child: Row(
                      //         //                   mainAxisAlignment:
                      //         //                       MainAxisAlignment.center,
                      //         //                   mainAxisSize: MainAxisSize.max,
                      //         //                   children: [
                      //         //                     ClipRRect(
                      //         //                       borderRadius:
                      //         //                           BorderRadius.circular(
                      //         //                               50.0),
                      //         //                       child: Image.network(
                      //         //                         secondList[index]
                      //         //                             ['รูปภาพ'],
                      //         //                         width: 35.0,
                      //         //                         height: 35.0,
                      //         //                         fit: BoxFit.cover,
                      //         //                       ),
                      //         //                     ),
                      //         //                   ],
                      //         //                 ),
                      //         //               ),
                      //         //               Row(
                      //         //                 mainAxisAlignment:
                      //         //                     MainAxisAlignment.center,
                      //         //                 mainAxisSize: MainAxisSize.max,
                      //         //                 children: [
                      //         //                   Container(
                      //         //                     // color: Colors.yellow,
                      //         //                     width: 70.0,
                      //         //                     alignment: Alignment.center,
                      //         //                     // height: 35.0,
                      //         //                     child: Expanded(
                      //         //                       child: Text(
                      //         //                         secondList[index]
                      //         //                             ['ชื่อกลุ่ม'],
                      //         //                         style:
                      //         //                             FlutterFlowTheme.of(
                      //         //                                     context)
                      //         //                                 .bodySmall,
                      //         //                         maxLines: 1,
                      //         //                         overflow:
                      //         //                             TextOverflow.clip,
                      //         //                       ),
                      //         //                     ),
                      //         //                   ),
                      //         //                 ],
                      //         //               ),
                      //         //             ],
                      //         //           ),
                      //         //         ),
                      //         //       );
                      //         //     },
                      //         //   ),
                      //         // ),

                      //         // Expanded(
                      //         //   child: ListView.builder(
                      //         //       itemBuilder: (context, index) {
                      //         //         return Column(
                      //         //           mainAxisSize: MainAxisSize.max,
                      //         //           mainAxisAlignment: MainAxisAlignment.center,
                      //         //           children: [
                      //         //             Expanded(
                      //         //               child: Row(
                      //         //                 mainAxisSize: MainAxisSize.max,
                      //         //                 children: [
                      //         //                   ClipRRect(
                      //         //                     borderRadius:
                      //         //                         BorderRadius.circular(50.0),
                      //         //                     child: Image.asset(
                      //         //                       'assets/images/LINE_ALBUM__231114_2.jpg',
                      //         //                       width: 35.0,
                      //         //                       height: 35.0,
                      //         //                       fit: BoxFit.cover,
                      //         //                     ),
                      //         //                   ),
                      //         //                 ],
                      //         //               ),
                      //         //             ),
                      //         //             Row(
                      //         //               mainAxisSize: MainAxisSize.max,
                      //         //               children: [
                      //         //                 Text(
                      //         //                   'หมวดหมู่สินค้า',
                      //         //                   style: FlutterFlowTheme.of(context)
                      //         //                       .bodySmall,
                      //         //                 ),
                      //         //               ],
                      //         //             ),
                      //         //           ],
                      //         //         );
                      //         //       },
                      //         //       itemCount: 10),
                      //         // ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      //=================================================================

                      // Container(
                      //   width: MediaQuery.sizeOf(context).width * 0.75,
                      //   decoration: BoxDecoration(),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.max,
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(50.0),
                      //                 child: Image.asset(
                      //                   'assets/images/LINE_ALBUM__231114_2.jpg',
                      //                   width: 35.0,
                      //                   height: 35.0,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               Text(
                      //                 'หมวดหมู่สินค้า',
                      //                 style: FlutterFlowTheme.of(context).bodySmall,
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(50.0),
                      //                 child: Image.asset(
                      //                   'assets/images/LINE_ALBUM__231114_3.jpg',
                      //                   width: 35.0,
                      //                   height: 35.0,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               Text(
                      //                 'หมวดหมู่สินค้า',
                      //                 style: FlutterFlowTheme.of(context).bodySmall,
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(50.0),
                      //                 child: Image.asset(
                      //                   'assets/images/LINE_ALBUM__231114_4.jpg',
                      //                   width: 35.0,
                      //                   height: 35.0,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               Text(
                      //                 'หมวดหมู่สินค้า',
                      //                 style: FlutterFlowTheme.of(context).bodySmall,
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(50.0),
                      //                 child: Image.asset(
                      //                   'assets/images/LINE_ALBUM__231114_5.jpg',
                      //                   width: 35.0,
                      //                   height: 35.0,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               Text(
                      //                 'หมวดหมู่สินค้า',
                      //                 style: FlutterFlowTheme.of(context).bodySmall,
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(50.0),
                      //                 child: Image.asset(
                      //                   'assets/images/LINE_ALBUM__231114_6.jpg',
                      //                   width: 35.0,
                      //                   height: 35.0,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               Text(
                      //                 'หมวดหมู่สินค้า',
                      //                 style: FlutterFlowTheme.of(context).bodySmall,
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(50.0),
                      //                 child: Image.asset(
                      //                   'assets/images/LINE_ALBUM__231114_7.jpg',
                      //                   width: 35.0,
                      //                   height: 35.0,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             children: [
                      //               Text(
                      //                 'หมวดหมู่สินค้า',
                      //                 style: FlutterFlowTheme.of(context).bodySmall,
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //==================== total price to Cart ================================
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 10.0),
                            child: Container(
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
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'รวมรายการสินค้า 1000.00 บาท',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                          msg:
                                              'กรุณาสั่งสินค้าผ่านทางเปิดใบออเดอร์ตามรายชื่อลูกค้าค่ะ');
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 33.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .success,
                                            borderRadius: BorderRadius.only(
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
                                                padding: EdgeInsetsDirectional
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
                                                padding: EdgeInsetsDirectional
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
                          ),
                        ],
                      ),
                      Expanded(
                        child: GridView(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                            for (int i = 0; i < resultList.length; i++)
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {},
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
                                                      onTap: () async {},
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: resultList[i][
                                                                        'รูปภาพ'] ==
                                                                    null ||
                                                                resultList[i][
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
                                                            : resultList[i]['รูปภาพ']
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
                                                                    resultList[
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
                                                        if (resultList[i]
                                                                ['Favorite'] ==
                                                            true) {
                                                          resultList[i]
                                                                  ['Favorite'] =
                                                              false;

                                                          List<dynamic>
                                                              listFav =
                                                              userData![
                                                                  'สินค้าถูกใจ'];
                                                          listFav.removeWhere(
                                                              (element) =>
                                                                  element ==
                                                                  resultList[i][
                                                                      'PRODUCT_ID']);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'User')
                                                              .doc(userData![
                                                                  'UserID'])
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
                                                          resultList[i]
                                                                  ['Favorite'] =
                                                              true;
                                                          List<dynamic>
                                                              listFav =
                                                              userData![
                                                                  'สินค้าถูกใจ'];
                                                          listFav.add(resultList[
                                                              i]['PRODUCT_ID']);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'User')
                                                              .doc(userData![
                                                                  'UserID'])
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
                                                        resultList[i][
                                                                    'Favorite'] ==
                                                                true
                                                            ? Icons
                                                                .favorite_sharp
                                                            : Icons
                                                                .favorite_border_sharp,
                                                        color: resultList[i][
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
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  1.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: SizedBox(
                                                        width: 145,
                                                        child: Text(
                                                          resultList[i]
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
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.clip,
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
                                                      'ราคา ${resultList[i]['PRICE']} บาท',
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
                                            resultList[i]['แท๊ก'].isEmpty
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
                                                              '${resultList[i]['แท๊ก'][0]}',
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
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      height: 60,
                                      decoration: BoxDecoration(),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 3.0, 0.0, 4.0),
                                        child:
                                            //  HtmlWidget(
                                            //   '${resultList[i]['รายละเอียด'] == null ? '' : resultList[i]['รายละเอียด']}',
                                            //   // textStyle: TextStyle(
                                            //   //   fontFamily: 'GreenHome',
                                            //   // ),
                                            //   textStyle: FlutterFlowTheme.of(
                                            //           context)
                                            //       .bodySmall
                                            //       .override(
                                            //         fontFamily: 'Kanit',
                                            //         fontSize:
                                            //             MediaQuery.sizeOf(context)
                                            //                         .width >=
                                            //                     800.0
                                            //                 ? 13.0
                                            //                 : 10.0,
                                            //         fontWeight: FontWeight.w500,
                                            //         lineHeight: 1.25,
                                            //       ),
                                            // ),

                                            Text(
                                          '${resultList[i]['รายละเอียดสตริง'] == null ? '' : resultList[i]['รายละเอียดสตริง']}',
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
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
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
                                                  child:
                                                      FlutterFlowCountController(
                                                    decrementIconBuilder:
                                                        (enabled) => FaIcon(
                                                      FontAwesomeIcons.minus,
                                                      color: enabled
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      size: 18.0,
                                                    ),
                                                    incrementIconBuilder:
                                                        (enabled) => FaIcon(
                                                      FontAwesomeIcons.plus,
                                                      color: enabled
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      size: 18.0,
                                                    ),
                                                    countBuilder: (count) =>
                                                        Text(
                                                      count.toString(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Kanit',
                                                            fontSize: 14.0,
                                                            letterSpacing: 30.0,
                                                          ),
                                                    ),
                                                    count: 0,
                                                    updateCount: (count) =>
                                                        setState(() =>
                                                            count = count),
                                                    stepSize: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'หน่วย',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FFButtonWidget(
                                                  onPressed: () {
                                                    print('Button pressed ...');
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'กรุณาสั่งสินค้าผ่านทางเปิดใบออเดอร์ตามรายชื่อลูกค้าค่ะ');
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
                                                    color: FlutterFlowTheme.of(
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
                              ),
                          ],
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.sizeOf(context).width * 1.0,
                      //   height: 5.0,
                      //   decoration: BoxDecoration(),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
      // ),
    );
  }
}
