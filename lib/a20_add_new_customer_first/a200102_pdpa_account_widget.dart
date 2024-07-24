import 'dart:convert';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_food/a20_add_new_customer_first/a2002_first_customer.dart';
import 'package:m_food/index.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/widgets/watermark_paint.dart';
import 'package:open_file/open_file.dart';
import '/components/appbar_o_pen_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/components/open_accout_for_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A200102PdpaAccountWidget extends StatefulWidget {
  final String? type;
  final bool? statusPdpa;
  const A200102PdpaAccountWidget({Key? key, this.type, this.statusPdpa})
      : super(key: key);

  @override
  _A200102PdpaAccountWidgetState createState() =>
      _A200102PdpaAccountWidgetState();
}

class _A200102PdpaAccountWidgetState extends State<A200102PdpaAccountWidget> {
  List<bool?> check = [null, null, null, null, null];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  //======================
  ByteData _img = ByteData(0);
  // var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  bool signConfirm = false;

  Image? imageSignToShow;
  String base64ImgSign = '';
  //======================

  //======================================================================
  // FilePickerResult? finalFileResult;
  List<String>? finalFileResultString = [];
  Reference? ref4;

  //======================================================================

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
    print('This is A070102 Pdpa Page 2 Screen');
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

    ThaiDateFormatFromDateTime(DateTime date) {
      var now = date;
      var thaiMonth = [
        null,
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.'
      ];
      var result = '${now.day} ${thaiMonth[now.month]} ${now.year + 543}';
      return result;
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
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
                              'PDPA',
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
                                            Navigator.pop(context);
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
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                width: double.infinity,
                height: 1000,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'หนังสือให้ความยินยอมในการเก็บรวบรวมใช้ และ/หรือ เปิดเผยข้อมูลส่วนบุคคล',
                          style: FlutterFlowTheme.of(context).titleLargeFont,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'วันที่  ${ThaiDateFormatFromDateTime(DateTime.now())}',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ลูกค้า ผู้จัดจำหน่าย ผู้ให้บริการ และพันธมิตรทางธุรกิจ:',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ชื่อ - สกุล',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'หมายเลขบัตรประชาชน/หนังสือเดินทาง',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     บริษัท มหาชัยฟู้ดส์ จำกัด และบริษัทในกลุ่ม ส.ขอนแก่นฟู้ดส์ จำกัด (มหาชน) (“บริษัทฯ” หรือ “เรา”) มีความมุ่งมั่นที่จะผลิตสินค้าและให้บริการแก่ท่านด้วยมาตรฐานของบริษัทฯ อย่างไรก็ตาม เพื่อให้เราสามารถดำเนินการตามคำสั่งซื้อ ปฏิบัติตามสัญญา และ/หรือดำเนินการที่เกี่ยวข้องกับธุรกิจของเราให้แก่ท่านได้ เราจึงขอความยินยอมจากท่านในการเก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคลของท่านภายใต้พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 (พ.ร.บ.ฯ) เพื่อวัตถุประสงค์ตามที่ระบุไว้ด้านล่างนี้',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     ท่านมีสิทธิที่จะปฏิเสธการยินยอมให้เราเก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคลของท่านเพื่อวัตถุประสงค์ตามที่ระบุไว้ด้านล่างนี้เมื่อใดก็ได้',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'ท่านยินยอมให้เรา บริษัทในเครือของเรา หรือพันธมิตรของเรา ประมวลผลข้อมูลส่วนบุคคลของท่านเพื่อวัตถุประสงค์ทางการตลาด และการนำเสนอสินค้า/บริการที่เหมาะสมกับท่าน',
                        style: FlutterFlowTheme.of(context).titleLargeFont,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'การปฏิเสธ หรือเพิกถอนความยินยอมในการประมวลผลข้อมูลส่วนบุคคลตามวัตถุประสงค์ด้านล่างนี้ จะไม่ส่งผลต่อการปฏิบัติตามสัญญาที่เรามี หรืออาจมีกับท่าน',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     1.   เพื่อเสนอสินค้า และ/หรือบริการ และ/หรือการส่งเสริมการขายที่เราวิเคราะห์แล้วว่าตรงกับความต้องการของท่าน',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      check[0] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[0] = true;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: check[0],
                                  onChanged: (value) {
                                    setState(() {
                                      check[0] = !check[0]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      check[0] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[0] = false;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: !check[0]!,
                                  onChanged: (value) {
                                    setState(() {
                                      check[0] = !check[0]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     2.   เพื่อเสนอสินค้า และ/หรือบริการ และ/หรือการส่งเสริมการขายของเราที่ดำเนินการโดยบริษัทอื่น หรือตัวแทนผู้ให้บริการของเรา',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      check[1] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[1] = true;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: check[1],
                                  onChanged: (value) {
                                    setState(() {
                                      check[1] = !check[1]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      check[1] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[1] = false;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: !check[1]!,
                                  onChanged: (value) {
                                    setState(() {
                                      check[1] = !check[1]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '      3.   เพื่อการวิจัย ทำข้อมูลสถิติ พัฒนา วิเคราะห์ สินค้า/บริการ และสิทธิประโยชน์ที่เหมาะสมกับท่าน โดยที่ดำเนินการด้วยตัวเราเอง หรือโดยบริษัทอื่น หรือตัวแทนผู้ให้บริการของเรา',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      check[2] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[2] = true;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: check[2],
                                  onChanged: (value) {
                                    setState(() {
                                      check[2] = !check[2]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      check[2] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[2] = false;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: !check[2]!,
                                  onChanged: (value) {
                                    setState(() {
                                      check[2] = !check[2]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'ท่านยินยอมให้เราประมวลผลข้อมูลส่วนบุคคลที่มีความละเอียดอ่อนของท่าน เช่น ข้อมูลศาสนาที่ระบุอยู่บนบัตรประจำตัวประชาชน ข้อมูลเชื้อชาติที่ระบุอยู่บนหนังสือเดินทาง ข้อมูลทางการแพทย์ ข้อมูลสุขภาพ และการตรวจรักษา เป็นต้น',
                        style: FlutterFlowTheme.of(context).titleLargeFont,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'การปฏิเสธ หรือเพิกถอนความยินยอมในการประมวลผลข้อมูลส่วนบุคคลตามวัตถุประสงค์ด้านล่างนี้ อาจส่งผลให้เราไม่สามารถปฏิบัติตามสัญญาที่เรามี หรืออาจมีกับท่าน หรือตอบสนองต่อข้อร้องเรียนเกี่ยวกับสินค้า และ/หรือบริการของเราที่มีผลต่อสุขภาพของท่านแก่ท่านได้',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     1.   เพื่อตรวจสอบ และยืนยันตัวตนของท่านเพื่อใช้ในการดำเนินการตามขั้นตอนการสมัครและการเป็นพันธมิตรทางธุรกิจ หรือลูกค้าของเราให้เสร็จสมบูรณ์ เช่น ข้อมูลศาสนาและเชื้อชาติ เป็นต้น',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      check[3] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[3] = true;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: check[3],
                                  onChanged: (value) {
                                    setState(() {
                                      check[3] = !check[3]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      check[3] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[3] = false;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: !check[3]!,
                                  onChanged: (value) {
                                    setState(() {
                                      check[3] = !check[3]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     2.   เพื่อดำเนินการตอบสนองต่อข้อร้องเรียนเกี่ยวกับสินค้า และ/หรือบริการของเราที่มีผลต่อสุขภาพของท่าน (สำหรับลูกค้าที่เป็นผู้บริโภค) เช่น ข้อมูลสุขภาพ การแพ้อาหาร เป็นต้น',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      check[4] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[4] = true;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: check[4],
                                  onChanged: (value) {
                                    setState(() {
                                      check[4] = !check[4]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      check[4] == null
                          ? Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      check[4] = false;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Checkbox(
                                  value: !check[4]!,
                                  onChanged: (value) {
                                    setState(() {
                                      check[4] = !check[4]!;
                                    });
                                  },
                                ),
                                Text(
                                  'ไม่ยินยอม',
                                  style:
                                      FlutterFlowTheme.of(context).labelLarge,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'ประกาศความเป็นส่วนตัว',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     ข้าพเจ้าได้อ่านและรับทราบประกาศความเป็นส่วนตัวของบริษัทฯ แล้ว และข้าพเจ้ารับทราบว่า ข้าพเจ้ามีสิทธิเพิกถอนความยินยอมในการประมวลผลข้อมูลส่วนบุคคลของข้าพเจ้า เพื่อวัตถุประสงค์ตามที่ระบุไว้ในหนังสือฉบับนี้ได้ตลอดเวลา โดยแจ้งให้กับเจ้าหน้าที่คุ้มครองข้อมูลส่วนบุคคลของบริษัทฯ ทราบถึงการเพิกถอนความยินยอมดังกล่าวได้ที่\n\n     บริษัท มหาชัยฟู้ดส์ จำกัด: ฝ่ายบริหารทรัพยากรมนุษย์ สำนักงานใหญ่: เลขที่ 259/13 ซอยปรีดีพนมยงค์ 13 ถนนสุขุมวิท 71 แขวงพระโขนงเหนือ เขตวัฒนา กรุงเทพมหานคร สำนักงานสาขามหาชัย: เลขที่ 71/11 หมู่ที่ 6 ตำบลท่าทราย อำเภอเมืองสมุทรสาคร จังหวัดสมุทรสาคร E-Mail/Website : pdpa@mfood.co.th หรือ www.mfood.co.th หมายเลขโทรศัพท์: 061-406-5999 หรือ 034-426-414 ต่อ 6522, 6569\n\n     ความยินยอมนี้มีผลสมบูรณ์นับตั้งแต่วันที่ระบุไว้ในหนังสือขอความยินยอมในการประมวลผลข้อมูลส่วนบุคคลฉบับนี้จนถึงวันที่ท่านได้แจ้งเพิกถอนความยินยอมเป็นลายลักษณ์อักษรให้แก่เราทราบ\n\n     คำนิยามที่กล่าวถึงในหนังสือฉบับนี้ ให้มีความหมายเช่นเดียวกับความหมายที่ได้กำหนดไว้ใน พ.ร.บ.ฯ และประกาศความเป็นส่วนตัว',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '       ชื่อ - นามสกุล :                                                            ผู้ให้ความยินยอม',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '       วันที่  ${ThaiDateFormatFromDateTime(DateTime.now())}',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // color: Colors.white,
                              width: double.infinity,
                              // height: 100,
                              child: GestureDetector(
                                onTap: () async {
                                  // Navigator.pop(context);
                                  await pickPdfFile2();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FFIcons.kpaperclipPlus,
                                      color: Colors.black,
                                      size: MediaQuery.of(context).size.height *
                                          0.025,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Text(
                                      'หรือแนบไฟล์เอกสารจากข้างนอก',
                                      style: FlutterFlowTheme.of(context)
                                          .titleLargeFont,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            for (int index = 0;
                                index < finalFileResultString!.length;
                                index++)
                              Container(
                                alignment: Alignment.center,
                                color: null,
                                // width: 600,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        OpenFile.open(
                                            finalFileResultString![index]);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '- ไฟล์ที่ ${index + 1}',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.search,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            finalFileResultString!
                                                .removeAt(index);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.remove_circle_outline,
                                            size: 16,
                                            color: Colors.red.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ), //========================== เซฟไว้ทำทีหลัง  ===================================
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(150.0, 5.0, 150.0, 5.0),
                child: FFButtonWidget(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'ไม่ยินยอม',
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).tertiary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Kanit',
                          color: Colors.white,
                        ),
                    elevation: 3.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              //========================== เซฟแล้วดำเนินการต่อไป  ===================================
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(150.0, 5.0, 150.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    for (var element in check) {
                      if (element == null) {
                        Fluttertoast.showToast(
                          msg: "   กรุณาตอบคำถามให้ครบถ้วนค่ะ !!   ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red.shade900,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }
                    }
                    if (finalFileResultString!.isEmpty) {
                      await signBottomSheet();
                      if (signConfirm) {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => A2002FirstCustomer(
                                base64ImgSignPDPA: base64ImgSign,
                                finalFileResultStringPDPA:
                                    finalFileResultString,
                                quizPDPA: check,
                              ),
                            ));

                        setState(() {
                          signConfirm = false;
                          // base64ImgSign = '';
                        });
                      }
                    } else {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => A2002FirstCustomer(
                              base64ImgSignPDPA: base64ImgSign,
                              finalFileResultStringPDPA: finalFileResultString,
                              quizPDPA: check,
                            ),
                          ));
                    }
                  },
                  text: 'ยินยอม',
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Kanit',
                          color: Colors.white,
                        ),
                    elevation: 3.0,
                    borderSide: BorderSide(
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
    );
  }

  Future<void> pickPdfFile2() async {
    // เลือกไฟล์ PDF
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      for (PlatformFile file in result.files) {
        String filePath = file.path!;
        setState(() {
          finalFileResultString!.add(filePath);
          // finalFileResult[index]!.add();
        });
        // String pdfPath = result.files.single.path!; (ไว้สำหรับ เลือกไฟล์เดียวแบบไม่ muiti)

        // Open PDF file using open_file package
        // OpenFile.open(filePath);
      }
      print(finalFileResultString!.length);
      print(finalFileResultString);
    }
  }

  Future<dynamic> signBottomSheet() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 80,
                    height: 350.0,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      // color: FlutterFlowTheme.of(context)
                      //     .secondaryBackground,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        width: 1.0,
                      ),
                    ),
                    child: Signature(
                      color: Colors.blue.shade800,
                      // color: FlutterFlowTheme.of(context)
                      //     .secondaryText,
                      key: _sign,
                      onSign: () {
                        final sign = _sign.currentState;
                        debugPrint(
                            '${sign!.points.length} points in the signature');
                      },
                      backgroundPainter: WatermarkPaint("2.0", "2.0"),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        final sign = _sign.currentState;
                        sign!.clear();
                        if (mounted) {
                          setState(
                            () {},
                          );
                        }

                        // Navigator.pop(context);
                      },
                      child: Text(
                        'clear',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Kanit',
                              color: Colors.red.shade900,
                            ),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final sign = _sign.currentState;
                        //retrieve image data, do whatever you want with it (send to server, save locally...)

                        // เพื่อตรวจสอบว่าลายเซ็นว่างหรือไม่
                        if (sign != null && !sign.isBlank!) {
                          // ผู้ใช้ทำการเขียนลายเซ็น
                          print('Signature is not empty');
                          final imageSign = await sign!.getData();
                          var data = await imageSign.toByteData(
                              format: ui.ImageByteFormat.png);
                          final encoded =
                              base64.encode(data!.buffer.asUint8List());

                          base64ImgSign = encoded;

                          Uint8List uint8list = base64.decode(encoded);

                          imageSignToShow = Image.memory(uint8list);

                          signConfirm = true;
                        } else {
                          // ผู้ใช้ไม่ได้ทำการเขียนลายเซ็น
                          print('Signature is empty');
                        }

                        print(signConfirm);
                        if (mounted) {
                          setState(
                            () {},
                          );
                        }

                        Navigator.pop(context);
                      },
                      child: Text(
                        'บันทึก',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Kanit',
                              color: Colors.blue.shade900,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
