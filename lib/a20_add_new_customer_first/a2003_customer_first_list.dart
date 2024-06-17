import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a20_add_new_customer_first/a2004_customer_first_edit.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:shimmer/shimmer.dart';
import '/components/appbar_o_pen_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/components/save_accout_widget.dart';
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

class A2003CustomerFirstList extends StatefulWidget {
  const A2003CustomerFirstList({Key? key}) : super(key: key);

  @override
  _A2003CustomerFirstListState createState() => _A2003CustomerFirstListState();
}

class _A2003CustomerFirstListState extends State<A2003CustomerFirstList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();

  final customerController = Get.find<CustomerController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A0710 save บันทึกข้อมูลยังไม่ส่ง  Screen');
    print('==============================');
    userData = userController.userData;
    List<String> name = [
      'สุภาภร ครื้นจิต',
      'วชิรวิทย์ แสนพระวัง',
      'แพรพลอย สินธุสาร',
      'เกศราภรณ์ ศรีสำราญ',
      'เมตตา โลกเชษฐ์ถาวร',
      'ชนิกานต์ อดุลยรัตนพันธุ์'
    ];

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
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                                      borderRadius: BorderRadius.circular(50.0),
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
                        Text(
                          'เปิดหน้าบัญชีใหม่เข้าระบบ',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: 'Kanit',
                                color: FlutterFlowTheme.of(context).primaryText,
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
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'สมัครสมาชิกที่นี่',
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
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
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
                                            style: FlutterFlowTheme.of(context)
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
                                        Navigator.pop(context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        maxRadius: 20,
                                        // radius: 1,
                                        backgroundImage: userData!['Img'] == ''
                                            ? null
                                            : NetworkImage(userData!['Img']),
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
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            // saveDataForLogout();
                                          },
                                          child: Icon(
                                            Icons.account_circle,
                                            color: FlutterFlowTheme.of(context)
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
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
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
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 10.0),
                                  child: Container(
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 8.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 12.0),
                                              child: TextFormField(
                                                controller: textController,
                                                focusNode: textFieldFocusNode,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  hintText:
                                                      'ตรวจสอบชื่อว่ามีหน้าบัญชีในระบบอยู่แล้วหรือไม่',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                textAlign: TextAlign.center,
                                                // validator: _model.textControllerValidator
                                                //     .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.search,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 5.0, 0.0),
                                      child: Icon(
                                        FFIcons.kfolderRefresh,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        size: 30.0,
                                      ),
                                    ),
                                    Text(
                                      'ข้อมูลลูกค้าที่ยังทำไม่ครบทุกขั้นตอนที่เซฟเก็บไว้ทำภายหลัง',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Kanit',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                    ),
                                    Spacer(),
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection(
                                                AppSettings.customerType ==
                                                        CustomerType.Test
                                                    ? 'ข้อมูลลูกค้าใหม่ตัวเทส'
                                                    : 'ข้อมูลลูกค้าใหม่')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return _buildLoadingImage();
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                'เกิดข้อผิดพลาด: ${snapshot.error}');
                                          }
                                          if (!snapshot.hasData) {
                                            return Text('ไม่พบข้อมูล');
                                          }
                                          if (snapshot.data!.docs.isEmpty) {
                                            print(snapshot.data);
                                          }

                                          print('stream stream');

                                          Map<String, dynamic> filteredData =
                                              {};
                                          //     data.docs.first.data() as Map<String, dynamic>;

                                          for (int index = 0;
                                              index <
                                                  snapshot.data!.docs.length;
                                              index++) {
                                            final Map<String, dynamic> docData =
                                                snapshot.data!.docs[index]
                                                        .data()
                                                    as Map<String, dynamic>;

                                            filteredData['key${index}'] =
                                                docData;
                                          }

                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 5.0, 5.0, 5.0),
                                                  child: Text(
                                                    filteredData.length
                                                        .toString(),
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
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              )
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // ========= ลิสต์รายชื่อลูกค้า ที่ยังไม่ส่งตรวจสอบ =================
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(AppSettings.customerType ==
                                              CustomerType.Test
                                          ? 'ข้อมูลลูกค้าใหม่ตัวเทส'
                                          : 'ข้อมูลลูกค้าใหม่')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return _buildLoadingImage();
                                    }
                                    if (snapshot.hasError) {
                                      return Text(
                                          'เกิดข้อผิดพลาด: ${snapshot.error}');
                                    }
                                    if (!snapshot.hasData) {
                                      return Text('ไม่พบข้อมูล');
                                    }
                                    if (snapshot.data!.docs.isEmpty) {
                                      print(snapshot.data);
                                    }

                                    print('stream stream');

                        

                                    Map<String, dynamic> sortedFilteredData =
                                        {};
                                    //     data.docs.first.data() as Map<String, dynamic>;

                                    for (int index = 0;
                                        index < snapshot.data!.docs.length;
                                        index++) {
                                      final Map<String, dynamic> docData =
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>;

                                      sortedFilteredData['key${index}'] =
                                          docData;
                                    }

                                    return SizedBox(
                                      height: 1045,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            for (var entry
                                                in sortedFilteredData.entries)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 35.0, bottom: 5),
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
                                                    //แปลงเป็น map เพื่อส่งไปหน้า edit
                                                    Map<String, dynamic>
                                                        entryMap = {
                                                      'key': entry.key,
                                                      'value': entry.value,
                                                    };

                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              A2004CustomerFirstEdit(
                                                                  entryMap:
                                                                      entryMap),
                                                        ));
                                                    // context.pushNamed(
                                                    //     'A07_12_UserGeneralEdit');
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          entry.value['ประเภทลูกค้า'] ==
                                                                  'Company'
                                                              ? Text(
                                                                  entry.value[
                                                                      'ชื่อบริษัท'],
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium,
                                                                )
                                                              : Text(
                                                                  '${entry.value['ชื่อ']} ${entry.value['นามสกุล']}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium,
                                                                ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.chevron_right,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
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
                                    );
                                  },
                                ),

                                // for (int i = 0; i < name.length; i++)
                                //   Padding(
                                //     padding:
                                //         EdgeInsets.only(left: 35.0, bottom: 5),
                                //     child: InkWell(
                                //       splashColor: Colors.transparent,
                                //       focusColor: Colors.transparent,
                                //       hoverColor: Colors.transparent,
                                //       highlightColor: Colors.transparent,
                                //       onTap: () async {
                                //         context
                                //             .pushNamed('A07_12_UserGeneralEdit');
                                //       },
                                //       child: Row(
                                //         mainAxisSize: MainAxisSize.max,
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Column(
                                //             mainAxisSize: MainAxisSize.max,
                                //             children: [
                                //               Text(
                                //                 name[i],
                                //                 style:
                                //                     FlutterFlowTheme.of(context)
                                //                         .bodyMedium,
                                //               ),
                                //             ],
                                //           ),
                                //           Column(
                                //             mainAxisSize: MainAxisSize.max,
                                //             children: [
                                //               Icon(
                                //                 Icons.chevron_right,
                                //                 color:
                                //                     FlutterFlowTheme.of(context)
                                //                         .secondaryText,
                                //                 size: 24.0,
                                //               ),
                                //             ],
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // Row(
                                //   mainAxisSize: MainAxisSize.max,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Text(
                                //           'วชิรวิทย์ แสนพระวัง',
                                //           style: FlutterFlowTheme.of(context)
                                //               .bodyMedium,
                                //         ),
                                //       ],
                                //     ),
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Icon(
                                //           Icons.chevron_right,
                                //           color: FlutterFlowTheme.of(context)
                                //               .secondaryText,
                                //           size: 24.0,
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisSize: MainAxisSize.max,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Text(
                                //           'แพรพลอย สินธุสาร',
                                //           style: FlutterFlowTheme.of(context)
                                //               .bodyMedium,
                                //         ),
                                //       ],
                                //     ),
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Icon(
                                //           Icons.chevron_right,
                                //           color: FlutterFlowTheme.of(context)
                                //               .secondaryText,
                                //           size: 24.0,
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisSize: MainAxisSize.max,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Text(
                                //           'เกศราภรณ์ ศรีสำราญ',
                                //           style: FlutterFlowTheme.of(context)
                                //               .bodyMedium,
                                //         ),
                                //       ],
                                //     ),
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Icon(
                                //           Icons.chevron_right,
                                //           color: FlutterFlowTheme.of(context)
                                //               .secondaryText,
                                //           size: 24.0,
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisSize: MainAxisSize.max,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Text(
                                //           'เมตตา โลกเชษฐ์ถาวร',
                                //           style: FlutterFlowTheme.of(context)
                                //               .bodyMedium,
                                //         ),
                                //       ],
                                //     ),
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Icon(
                                //           Icons.chevron_right,
                                //           color: FlutterFlowTheme.of(context)
                                //               .secondaryText,
                                //           size: 24.0,
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisSize: MainAxisSize.max,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Text(
                                //           'ชนิกานต์ อดุลยรัตนพันธุ์',
                                //           style: FlutterFlowTheme.of(context)
                                //               .bodyMedium,
                                //         ),
                                //       ],
                                //     ),
                                //     Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       children: [
                                //         Icon(
                                //           Icons.chevron_right,
                                //           color: FlutterFlowTheme.of(context)
                                //               .secondaryText,
                                //           size: 24.0,
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
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
        ),
      ),
    );
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
}
