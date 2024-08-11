import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a10_customer_credit/a1002_detail_customer_credit.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:shimmer/shimmer.dart';

import '/components/appbar_o_pen_widget.dart';
import '/components/list_open_acoout_copy_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/user_controller.dart';

class ListCustomerCheckWidget extends StatefulWidget {
  const ListCustomerCheckWidget({super.key});

  @override
  _ListCustomerCheckWidgetState createState() =>
      _ListCustomerCheckWidgetState();
}

class _ListCustomerCheckWidgetState extends State<ListCustomerCheckWidget> {
  TextEditingController searchTextController = TextEditingController();
  FocusNode focusNode = FocusNode();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  final customerController = Get.find<CustomerController>();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    print('==============================');
    print('This is  List Customer Check Widget  Screen');
    print('==============================');
    userData = userController.userData;
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

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //============ ตรวจสอบ =================
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
            child: Container(
              height: 30.0,
              decoration: BoxDecoration(
                // color: Colors.red,
                color: FlutterFlowTheme.of(context).accent3,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  //============ ตรวจสอบ =================
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: searchTextController,
                        focusNode: focusNode,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintText: 'ค้นหาบัญชีลูกค้าในระบบ',
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          // suffixIcon: Icon(
                          //   Icons.search,
                          // ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        textAlign: TextAlign.center,
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
          //======================== รายชื่อลูกค้าทั้งหมด ================================
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(AppSettings.customerType == CustomerType.Test
                      ? 'CustomerTest'
                      : 'Customer')
                  .where('รหัสพนักงานขาย', isEqualTo: userData!['EmployeeID'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingImage();
                }
                if (snapshot.hasError) {
                  return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Text('ไม่พบข้อมูล');
                }
                if (snapshot.data!.docs.isEmpty) {
                  print(snapshot.data);
                }

                print('stream stream');

                customerController.updateCustomerData(snapshot.data);
                print(customerController.customerData!.length);

                Map<String, dynamic> customerMap = {};
                //     data.docs.first.data() as Map<String, dynamic>;

                for (int index = 0;
                    index < snapshot.data!.docs.length;
                    index++) {
                  final Map<String, dynamic> docData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  customerMap['key${index}'] = docData;
                  // customerMap['key${docData['value']['ชื่อนามสกุล']}'] =
                  //     docData;
                }
                print('aaaa');
                print(customerMap);

                Map<String, dynamic> filteredData = Map.fromEntries(
                  customerMap.entries.where((entry) =>
                      entry.value['สถานะ'] == true &&
                      entry.value['บันทึกพร้อมตรวจ'] == false &&
                      userData!['EmployeeID'] == entry.value['รหัสพนักงานขาย']),
                );

                List<String> sortedKeys = filteredData.keys.toList();

                // print(filteredData.keys);
                // print(sortedKeys);
                // sortedKeys.sort((a, b) => filteredData[b]['CustomerDateUpdate']
                //     .compareTo(filteredData[a]['CustomerDateUpdate']));

                sortedKeys.sort((a, b) {
                  return filteredData[a]['ชื่อนามสกุล']
                      .compareTo(filteredData[b]['ชื่อนามสกุล']);
                });
                print(sortedKeys);
                Map<String, dynamic> sortedFilteredData = Map.fromEntries(
                  sortedKeys.map((key) => MapEntry(key, filteredData[key])),
                );

                return Column(
                  children: [
                    for (var entry in sortedFilteredData.entries)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 1.0, 0.0, 1.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            //แปลงเป็น map เพื่อส่งไปหน้า edit
                            Map<String, dynamic> entryMap = {
                              'key': entry.key,
                              'value': entry.value,
                            };
                            print(entryMap);
                            print('11233321321');
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      A1002DetailCustomerCredit(
                                          entryMap: entryMap),
                                ));
                            // context.pushNamed('A12_02_DetailCustomerCredit');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  entry.value['ประเภทลูกค้า'] == 'Company'
                                      ? Text(
                                          entry.value['ชื่อบริษัท'],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        )
                                      : Text(
                                          entry.value['ชื่อนามสกุล'],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    FFIcons.kaccountSearch,
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
                );
              }),
        ],
      ),
    );
  }
}
