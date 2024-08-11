import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a09_customer_open_sale/a0902_customer_history_list.dart';
import 'package:m_food/a09_customer_open_sale/open_order_team/a0902_customer_history_list_team.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading_home.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get/get.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';

class ListOpenSaleTeamWidget extends StatefulWidget {
  final List<Map<String, dynamic>?>? mapData;
  final String? userIDOpen;
  final String? userNameOpen;
  final String? idEmployee;

  ListOpenSaleTeamWidget({
    super.key,
    @required this.mapData,
    @required this.idEmployee,
    @required this.userIDOpen,
    @required this.userNameOpen,
  });

  @override
  _ListOpenSaleTeamWidgetState createState() => _ListOpenSaleTeamWidgetState();
}

class _ListOpenSaleTeamWidgetState extends State<ListOpenSaleTeamWidget> {
  TextEditingController textControllerFind = TextEditingController();
  FocusNode textFieldFocusNodeFind = FocusNode();

  List<Map<String, dynamic>?>? customerDataList = [];
  List<Map<String, dynamic>?>? customerAllDataList = [];
  bool isLoading = false;

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      userData = userController.userData;

      customerDataList = widget.mapData;
      customerDataList!
          .removeWhere((customerData) => customerData!['สถานะ'] == false);

      customerDataList!
          .removeWhere((customerData) => customerData!['IS_ACTIVE'] == false);

      print('A0901 ต้องเปิดคอมเม้นนี้ เพื่อกรองข้อมูลตามจริง');

      print(customerDataList!.length);
      //==================================================
      // หากเริ่มทำงานจริง ให้เปิดเงื่อนไขนี้ไว้ เพื่อกรองดาต้าจริง
      // customerDataList!.removeWhere((customerData) =>
      //     userData!['EmployeeID'] != customerData!['รหัสพนักงานขาย']);
      //==================================================

      // print(customerDataList.length);
      // print(customerDataList.length);
      // print(customerDataList.length);
      // print(customerDataList.length);
      // print(customerDataList.length);

      customerDataList!.sort((a, b) {
        String nameA = a!['ชื่อนามสกุล'];
        String nameB = b!['ชื่อนามสกุล'];

        return nameA.compareTo(nameB);
      });

      customerAllDataList = customerDataList;

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void findName(String nameProduct) {
    if (nameProduct.isEmpty) {
      customerDataList = customerAllDataList;
    } else {
      customerDataList = customerAllDataList!
          .where((product) =>
              product!['ชื่อนามสกุล'].contains(nameProduct) ||
              product!['ClientIdจากMfoodAPI'].contains(nameProduct))
          .toList();
    }
    print(nameProduct);
    print(nameProduct.length);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    textControllerFind.dispose();
    textFieldFocusNodeFind.unfocus();
    super.dispose();
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
            ? Center(child: CircularLoadingHome())
            : Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 1.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 10.0),
                      child: Container(
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent3,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 11.0, 8.0, 0.0),
                                child: TextFormField(
                                  onChanged: (value) {
                                    findName(textControllerFind.text);
                                  },
                                  controller: textControllerFind,
                                  focusNode: textFieldFocusNodeFind,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle:
                                        FlutterFlowTheme.of(context).labelLarge,
                                    alignLabelWithHint: false,
                                    hintText: 'ค้นหาบัญชีบัญชีลูกค้าในระบบ',
                                    hintStyle:
                                        FlutterFlowTheme.of(context).labelLarge,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    // suffixIcon: const Icon(
                                    //   Icons.search,
                                    // ),
                                  ),
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
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
                    for (int i = 0; i < customerDataList!.length; i++)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            print('asdfdsdf');
                            print(customerDataList![i]!['CustomerID']);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      A0902CustomerHistoryListTeam(
                                    customerID:
                                        customerDataList![i]!['CustomerID'],
                                    idEmployee: widget.idEmployee,
                                    userIDOpen: widget.userIDOpen,
                                    userNameOpen: widget.userNameOpen,
                                  ),
                                ));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    customerDataList![i]![
                                        'ClientIdจากMfoodAPI'],
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
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    customerDataList![i]!['ประเภทลูกค้า'] ==
                                            'Company'
                                        ? customerDataList![i]!['ชื่อบริษัท']
                                        : customerDataList![i]!['ชื่อนามสกุล'],
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
                              Spacer(),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    FFIcons.kfileDocumentPlus,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    size: 24.0,
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
    );
  }
}
