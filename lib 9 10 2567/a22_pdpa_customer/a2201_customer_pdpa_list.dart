import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:m_food/a13_visit_customer_plan/widget/visit_customer_plan_widget.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class A2201CustomerPdpaList extends StatefulWidget {
  const A2201CustomerPdpaList({super.key});

  @override
  _A2201CustomerPdpaListState createState() => _A2201CustomerPdpaListState();
}

class _A2201CustomerPdpaListState extends State<A2201CustomerPdpaList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  bool isLoading = false;
  List<Map<String, dynamic>> customerList = [];

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    userData = userController.userData;

    await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'CustomerTest'
            : 'Customer')
        .where('รหัสพนักงานขาย', isEqualTo: userData!['EmployeeID'])
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>>? data) async {
        if (data != null && data.docs.isNotEmpty) {
          print('จำนวนลูกค้าที่มี ');
          print(data.docs.length);
          for (int index = 0; index < data.docs.length; index++) {
            final Map<String, dynamic> docData =
                data.docs[index].data() as Map<String, dynamic>;
            print(docData['PDPA']['สถานะ']);
            if (
                // docData['PDPA']['คำถาม'] != [true, true, true, true, true] ||
                docData['PDPA']['ลายเซ็น'] == '' ||
                    docData['PDPA']['สถานะ'] == false ||
                    docData['ClientIdจากMfoodAPI'] == null) {
            } else {
              customerList.add(docData);
            }
            print(docData['ClientIdจากMfoodAPI']);
          }
        }
      },
    );

    customerList.sort((a, b) {
      var aReadyToSell = a['ClientIdจากMfoodAPI'];
      var bReadyToSell = b['ClientIdจากMfoodAPI'] ?? false;
      return aReadyToSell.compareTo(bReadyToSell);
    });

    print(customerList.length);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A2201 customer pdpa list');
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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoading
            ? CircularLoadingHome()
            : Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    10.0, 10.0, 10.0, 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //======================== App Bar ==============================
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
                              'จัดการ PDPA',
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 30.0, 10.0, 0.0),
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  height: 60,
                                  color: Colors.black87,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ลำดับ',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'รหัสลูกค้า',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ชื่อลูกค้า',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ประเภท',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ความเป็นส่วนตัว',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'เอกสาร PDPA',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                            for (int i = 0; i < customerList.length; i++)
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black.withOpacity(0.3),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${i + 1}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${customerList[i]['ClientIdจากMfoodAPI']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              // customerList[i]['ชื่อนามสกุล'],
                                              customerList[i]['ประเภทลูกค้า'] ==
                                                      'Personal'
                                                  ? '${customerList[i]['ชื่อ']} ${customerList[i]['นามสกุล']}'
                                                  : '${customerList[i]['ชื่อบริษัท']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                          fontFamily: 'Kanit',
                                                          color: Colors.black,
                                                          fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              customerList[i]['ประเภทลูกค้า'] ==
                                                      'Personal'
                                                  ? 'บุคคลธรรมดา'
                                                  : 'นิติบุคคล',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Kanit',
                                                        color: Colors.black,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 10, 20, 20),
                                                    width: double.infinity,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'ประกาศความเป็นส่วนตัว (Privacy Notice)',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineSmall,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'ปรับปรุงข้อมูลล่าสุด: ${formatThaiDate(customerList[i]['CustomerDateUpdate'])}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'เรียน ท่านลูกค้า ผู้จัดจำหน่าย ผู้ให้บริการ และพันธมิตรธุรกิจของเรา',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     บริษัท มหาชัยฟู้ดส์ จำกัดและบริษัทในเครือ ส.ขอนแก่นฟู้ดส์ จำกัด (มหาชน) (“บริษัทฯ” หรือ “เรา”) ให้ความสำคัญกับความเป็นส่วนตัว และพยายามมุ่งมั่นที่จะคุ้มครองข้อมูลส่วนบุคคลของท่าน หรือข้อมูลส่วนบุคคลของบุคคลที่มีความเกี่ยวข้องกับธุรกิจของท่าน (รวมเรียกว่า “ข้อมูลส่วนบุคคล”) ตามพระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 (“พ.ร.บ.ฯ”) คำนิยามที่กล่าวถึงในประกาศความเป็นส่วนตัวฉบับนี้ ให้มีความหมายเช่นเดียวกับความหมายที่ได้กำหนดไว้ใน พ.ร.บ.ฯ',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     ประกาศความเป็นส่วนตัวฉบับนี้อธิบายถึงรายละเอียด ดังต่อไปนี้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     ข้อมูลส่วนบุคคล หมายถึง ข้อมูลเกี่ยวกับบุคคลซึ่งทำให้สามารถระบุตัวบุคคลนั้นได้ไม่ว่าทางตรงหรือทางอ้อม แต่ไม่รวมถึงข้อมูลของบุคคลที่ถึงแก่กรรม',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '       ข้อมูลส่วนบุคคลที่มีความละเอียดอ่อน หมายถึง ข้อมูลส่วนบุคคลที่กฎหมายกำหนดเป็นการเฉพาะ ซึ่งบริษัทฯ จะเก็บ รวบรวม ใช้ และ/หรือเปิดเผยต่อเมื่อบริษัทฯ ได้รับความยินยอมโดยชัดแจ้งจากท่าน หรือในกรณีที่บริษัทฯ มีความจำเป็นตามกรณีที่กฎหมายอนุญาต เช่น ข้อมูลสุขภาพ ความพิการ เป็นต้น',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '\n1. การเก็บรวบรวมข้อมูลส่วนบุคคล',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     บริษัทฯ เก็บรวบรวมข้อมูลส่วนบุคคลหลากหลายประเภท ขึ้นอยู่กับแต่ละสถานการณ์และลักษณะของสินค้าและบริการที่ท่านเลือก และ/หรือ ธุรกรรมที่ท่านดำเนินการ',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     บริษัทฯ เก็บรวบรวมข้อมูลส่วนบุคคลของท่านจากแหล่งข้อมูลที่หลากหลาย ดังต่อไปนี้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '•    เมื่อท่านสั่งซื้อสินค้า และ/หรือสมัครเป็นผู้จัดจำหน่าย ผู้ให้บริการ หรือพันธมิตรทางธุรกิจกับเรา\n•    การสนทนาระหว่างท่านกับเรา รวมถึงบันทึกการสนทนาผ่านทางโทรศัพท์ จดหมาย อีเมล บันทึกข้อความ หรือวิธีการอื่น ๆ\n•    เมื่อท่านใช้งานเว็บไซต์ แอพพลิเคชั่น ระบบปฏิบัติงาน หรือช่องทางออนไลน์ต่าง ๆ ของเราหรือของตัวแทนเรา\n•    เมื่อท่านใช้งานเว็บไซต์ แอพพลิเคชั่น ระบบปฏิบัติงาน หรือช่องทางออนไลน์ต่าง ๆ ของเราหรือของตัวแทนเรา\n•    ข้อมูลที่ได้รับจากเอกสารที่ท่านมอบให้กับเรา\n•    แบบสำรวจความพึงพอใจ ความเห็นของลูกค้า แบบประเมินผู้จัดจำหน่าย/ผู้ให้บริการ และข้อร้องเรียนเกี่ยวกับสินค้าหรือบริการของเรา\n•    เมื่อท่านเข้าร่วมกิจกรรมการแข่งขันชิงรางวัล การส่งเสริมการขาย หรือกิจกรรมการตลาดกับเรา\n•    เมื่อท่านทำให้ข้อมูลส่วนบุคคลของท่านปรากฏแก่สาธารณะอย่างชัดแจ้ง รวมถึงเปิดเผยข้อมูลผ่านทางโซเชียลมีเดีย (social media) เช่น เราอาจจะเก็บรวบรวมข้อมูลส่วนบุคคลของท่านจากข้อมูลโปรไฟล์ที่ปรากฏทางโซเชียลมีเดียของท่าน ในกรณีดังกล่าว เราจะเลือกเก็บรวบรวมเฉพาะข้อมูลส่วนบุคคลที่ท่านเลือกให้ปรากฏต่อสาธารณะเท่านั้น\n•    เมื่อเราได้รับข้อมูลส่วนบุคคลของท่านจากบุคคลที่สาม เช่น นายจ้างของท่าน ลูกค้าของเรา เจ้าหน้าที่ของรัฐที่มีอำนาจ หรือหน่วยงานของรัฐอื่นใด เป็นต้น\n•    เมื่อท่านซื้อสินค้าของเราจากบุคคลที่สาม หรือแพลตฟอร์มของตัวแทนของเรา\n•    เมื่อท่านเข้าเยี่ยมชมโรงงานหรือพื้นที่ของบริษัทฯ หรือทางเราเข้าเยี่ยมชมสถานประกอบการของท่าน',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'ประเภทของข้อมูลส่วนบุคคลที่บริษัทฯ เก็บรวบรวมภายใต้กฎหมายที่เกี่ยวข้องนั้น ซึ่งรวมถึงแต่ไม่จำกัดเพียง ข้อมูลดังต่อไปนี้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '•    ข้อมูลส่วนตัว: ชื่อ นามสกุล เพศ วันเดือนปีเกิด สถานภาพการสมรส หมายเลขบัตรประจำตัวประชาชน หมายเลขหนังสือเดินทาง หมายเลขอื่น ๆ รวมถึงข้อมูลส่วนตัวที่ปรากฏอยู่บนเอกสารที่รัฐออกให้เพื่อใช้ในการยืนยันตัวตน และเอกสารสำคัญของนิติบุคคลที่ออกให้โดยราชการ (กรณีลูกค้าเป็นนิติบุคคล) หมายเลขประจำตัวผู้เสียภาษี สัญชาติ ภาพถ่ายบัตรประจำตัวประชาชน ลายมือชื่อ ภาพถ่าย ภาพเสมือนจริง (Visual Image) และภาพจากกล้องวงจรปิด (CCTV) เป็นต้น\n•    ข้อมูลการติดต่อ: ที่อยู่ แผนที่ หมายเลขโทรศัพท์ อีเมล และ รายละเอียดโปรไฟล์ผ่านทางโซเชียลมีเดีย (social media) (เช่น LINE ID)\n•    ข้อมูลทางการเงิน: ที่อยู่สำหรับการเรียกเก็บเงิน ชื่อและเลขบัญชีธนาคาร วงเงินเครดิตและระยะเวลาชำระหนี้ บันทึกคำสั่ง รายละเอียดธุรกรรมทางการเงิน และรายละเอียดคู่สัญญา ข้อมูลที่อยู่บนบัตรเครดิตหรือเดบิต\n•    ข้อมูลอิเล็กทรอนิกส์: ที่อยู่ IP คุกกี้ บันทึกกิจกรรม ข้อมูลระบุตัวตนออนไลน์ และข้อมูลตำแหน่งทางภูมิศาสตร์\n•    ประวัติการสั่งซื้อสินค้า/บริการ\n•    ข้อมูลความคิดเห็น ความพึงพอใจ/ ข้อร้องเรียน: ข้อมูลในแบบสำรวจความพึงพอใจ แบบข้อร้องเรียนเกี่ยวกับสินค้า/บริการ แบบประเมินผู้จัดจำหน่าย/ผู้ให้บริการ\n•    ข้อมูลที่มีความละเอียดอ่อน: ท่านสมัครใจเป็นผู้ให้ข้อมูล เช่น ข้อมูลการแพ้อาหาร เป็นต้น\n•    ข้อมูลที่มีการเปิดเผยผ่านสื่อสาธารณะ: ข้อมูลการโฆษณาประชาสัมพันธ์ของท่านผ่านสื่อต่าง ๆ',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '\n2. วัตถุประสงค์ในการใช้ เก็บ รวบรวม และเปิดเผยข้อมูลส่วนบุคคล',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     เราอาจเก็บรวบรวม และใช้ข้อมูลส่วนบุคคลของท่านเฉพาะในกรณีที่เรามีเหตุผลที่เหมาะสมและชอบด้วยกฎหมายในการดำเนินการเช่นว่านั้น ทั้งนี้ รวมถึงการเปิดเผยข้อมูลส่วนบุคคลให้กับบุคคลภายนอก',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     เราอาจเก็บรวบรวม ใช้ หรือเปิดเผยข้อมูลส่วนบุคคลของท่านเพื่อวัตถุประสงค์ ดังต่อไปนี้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '•    เพื่อตรวจสอบตัวตนของท่าน\n•    เพื่อสร้างบัญชีผู้ใช้ส่วนตัวหรือบัญชีข้อมูลการเป็นลูกค้า ผู้จัดจำหน่าย ผู้ให้บริการ และพันธมิตรธุรกิจกับเรา\n•    เพื่อรับคำสั่งซื้อ ดำเนินการผลิต การจัดส่งสินค้าและออกเอกสารต่าง ๆ ที่เกี่ยวข้องกับธุรกรรมทางการค้า เช่น ใบส่งของ/ใบกำกับภาษี ใบเสร็จรับเงิน เป็นต้น\n•    เพื่อสั่งซื้อสินค้า/บริการ และการออกเอกสารต่าง ๆ เช่น ใบสั่งซื้อ ใบรับสินค้า/ใบตรวจรับงาน ใบวางบิล เป็นต้น\n•    เพื่อตรวจสอบและควบคุมคุณภาพสินค้า และแก้ไขปัญหาที่เกี่ยวข้องกับสินค้า/บริการ\n•    เพื่อดำเนินการเกี่ยวกับการชำระเงินค่าสินค้า/บริการ ติดตามหนี้ และการบริหารจัดการการชำระเงิน\n•    เพื่อเป็นช่องทางในติดต่อสื่อสารที่เกี่ยวกับการธุรกรรมทางการค้า และการประชาสัมพันธ์ แจ้งข้อมูลข่าวสารที่เป็นประโยชน์ต่อท่าน\n•    เพื่อจัดเก็บข้อมูลและเป็นหลักฐานเอกสารการดำเนินธุรกิจร่วมกัน สำหรับกระบวนการทางภาษี การวิเคราะห์ธุรกิจของบริษัทฯ และในกรณีที่หากเกิดข้อพิพาทหรือข้อร้องเรียน\n•    เพื่อสนับสนุนกระบวนการตรวจสอบคุณภาพสินค้าและรับรองมาตรฐานการผลิตของบริษัท\n•    เพื่อสอบถามความพึงพอใจ และรวบรวมความคิดเห็น ประเด็นปัญหาที่พบ ข้อร้องเรียน เพื่อนำมาทดสอบ วิเคราะห์ ปรับปรุงพัฒนาสินค้า กระบวนการผลิต และการให้บริการของบริษัทฯ\n•    เพื่อบริหารความสัมพันธ์ระหว่างท่านและบริษัท\n•    เพื่อทำความเข้าใจ วิเคราะห์ความต้องการสินค้า และนำเสนอสินค้าที่เหมาะสมให้กับท่าน\n•    เพื่อพัฒนากิจกรรมทางการตลาดและนำเสนอกิจกรรมส่งเสริมการตลาดให้กับท่าน\n•    เพื่อประกอบการวิเคราะห์ผลการดำเนินงานของบริษัท และพนักงานของบริษัท\n•    เพื่อรายงานข้อมูลต่อหน่วยงานกำกับดูแลที่เกี่ยวข้อง\n•    เพื่อสนับสนุนกระบวนการดำเนินงานภายในองค์กรภายใต้การไม่ละเมิดความเป็นส่วนตัวของข้อมูลส่วนบุคคล เช่น การรายงานผลภายในบริษัทฯ การจัดการทางบัญชี การเปิดเผยข้อมูลแก่หน่วยงานกำกับดูแลหรือผู้ตรวจสอบบัญชี เป็นต้น\n•    เพื่อป้องกันอาชญากรรม และบริหารจัดการความปลอดภัยของบริษัท เช่น ติดตั้งกล้องวงจรปิด (CCTV) ภายใน และโดยรอบพื้นที่ของเรา ซึ่งอาจมีการเก็บภาพเคลื่อนไหว หรือบันทึกเสียงของท่าน\n•    เพื่อการตรวจสอบและบริหารความเสี่ยง และการกำหนดมาตรการควบคุมภายในของบริษัท\n•    เพื่อปฏิบัติตามกฎหมายและข้อบังคับที่เกี่ยวข้องกับกฎหมายคุ้มครองข้อมูลส่วนบุคคล กฎหมายเกี่ยวกับด้านสาธารณสุข กฎหมายภาษีอากร และกฎหมายอื่นๆ ที่เกี่ยวข้อง\n•    เพื่อการทำการตลาดทางตรง ในขณะที่ท่านใช้บริการของเรา ท่านอาจได้รับการสอบถามเพื่อให้ระบุว่าท่านต้องการรับข้อมูลทางการตลาดทางโทรศัพท์ ข้อความ อีเมลและ/หรือไปรษณีย์หรือไม่ หากท่านดำเนินการเช่นนั้น แสดงว่าท่านตกลงว่าเราอาจใช้ข้อมูลส่วนบุคคลของท่านเพื่อให้ข้อมูลเกี่ยวกับสินค้า กิจกรรมส่งเสริมการขาย และข้อเสนอพิเศษ รวมถึงข้อมูลอื่น ๆ เกี่ยวกับสินค้าหรือบริการของเราแก่ท่าน ท่านอาจเปลี่ยนแปลงการตั้งค่าของท่านเกี่ยวกับการตลาดทางตรงโดยใช้ตัวเลือกการยกเลิกที่ปรากฏอยู่ในการส่งจดหมายการตลาดทางตรงทุกครั้ง ติดต่อเราโดยใช้ข้อมูลการติดต่อดังที่ระบุไว้ด้านล่างนี้ หรือปรับแก้ข้อมูลบัญชีของท่านถ้ามีเมื่อใดก็ได้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     เว้นแต่ได้กำหนดไว้ในประกาศความเป็นส่วนตัวนี้ บริษัทฯ จะไม่ใช้ข้อมูลส่วนบุคคลเพื่อวัตถุประสงค์อื่นนอกเหนือจากวัตถุประสงค์ตามที่ระบุไว้ในประกาศความเป็นส่วนตัวนี้ หากเราจะเก็บรวบรวม ใช้ หรือเปิดเผยข้อมูลเพิ่มเติมซึ่งไม่ได้ระบุไว้ในประกาศความเป็นส่วนตัวนี้ บริษัทฯ จะแจ้งให้ท่านทราบและขอความยินยอมจากท่านก่อนการเก็บรวบรวม ใช้ และเปิดเผย เว้นแต่ในกรณีที่กฎหมายอนุญาตให้บริษัทฯ ดำเนินการดังกล่าวได้โดยไม่ต้องอาศัยความยินยอมของท่าน ท่านมีสิทธิให้ความยินยอมหรือปฏิเสธ การเก็บรวบรวม ใช้ และ/หรือเปิดเผยข้อมูลส่วนบุคคลของท่าน',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'กรณีที่ท่านไม่สามารถให้ข้อมูลส่วนบุคคลแก่เราได้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     ในกรณีที่เราจำเป็นต้องเก็บรวบรวมข้อมูลส่วนบุคคลของท่านตามกฎหมายหรือภายใต้ข้อกำหนดในสัญญา/ข้อตกลงทางการค้าระหว่างเรากับท่าน และท่านไม่ให้ข้อมูลส่วนบุคคลของท่านแก่เราได้ เราอาจไม่สามารถปฏิบัติตามภาระข้อผูกพันที่เรามีต่อท่าน หรือตามที่เราวางแผนว่าจะเข้าทำสัญญากับท่าน เช่น เพื่อเปิดบัญชีการค้า ในกรณีดังกล่าว เราอาจปฏิเสธการให้บริการที่เกี่ยวข้อง แต่เราจะแจ้งให้ท่านทราบถึงกรณีเช่นว่านั้นในขณะที่เราเก็บรวบรวมข้อมูลส่วนบุคคลของท่าน',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '\n3. การเปิดเผยข้อมูลส่วนบุคคล\n\n     เราอาจเปิดเผยข้อมูลส่วนบุคคลของท่านให้กับบุคคลอื่นในกรณีที่สามารถทำได้ตามกฎหมาย รวมถึงกรณีดังต่อไปนี้ที่เราหรือบุคคลอื่นดังกล่าว\n\n•    จำเป็นต้องดำเนินการให้แก่ท่านตามข้อกำหนดของสัญญา\n•    มีหน้าที่ตามกฎหมายในการกระทำการดังกล่าว เช่น การตรวจสอบทุจริตและคดีอาชญากรรม การนำส่งภาษีภาษีมูลค่าเพิ่ม การหักภาษี ณ ที่จ่าย เป็นต้น\n•    จำเป็นต้องรายงานตามกฎหมาย ดำเนินคดี ใช้สิทธิตามกฎหมาย หรือปกป้องสิทธิตามกฎหมาย\n•    กระทำไปเพื่อประโยชน์ของธุรกิจโดยชอบด้วยกฎหมาย หรือเพื่อประโยชน์อันชอบด้วยกฎหมายของเรา เช่น เพื่อบริหารความเสี่ยง เพื่อการรายงานภายในองค์กร เพื่อวิเคราะห์ข้อมูล เพื่อยืนยันตัวตน เพื่อให้บริษัทอื่นสามารถให้บริการตามที่ท่านร้องขอได้ เพื่อประเมินความเหมาะสมของท่านต่อสินค้า และ/หรือบริการ เป็นต้น\n•    ขอความยินยอมจากท่านเพื่อเปิดเผยข้อมูลส่วนบุคคลให้แก่บุคคลอื่น และท่านได้ให้ความยินยอมในการดำเนินการนั้น\n\n     เราอาจเปิดเผยข้อมูลส่วนบุคคลของท่าน เพื่อวัตถุประสงค์ที่กล่าวข้างต้นให้กับบุคคลอื่น ดังต่อไปนี้\n\n•    บริษัทอื่น ๆ ในเครือของเรา\n•    คู่สัญญา/คู่ค้า ที่เป็นผู้ให้บริการแก่เรา อาทิเช่น ผู้รับเหมาช่วง ตัวแทน หุ้นส่วนทางธุรกิจ ซึ่งรวมถึงพนักงาน ผู้รับเหมาช่วง ผู้ให้บริการ กรรมการ และเจ้าหน้าที่ของผู้ให้บริการดังกล่าวนี้ด้วย\n•    ผู้ได้รับมอบหมายให้จัดการดูแลผลประโยชน์ใด ๆ ของท่าน รวมถึงคนกลาง บุคคลผู้ติดต่อ และตัวแทนของท่าน เช่น ผู้รับมอบอำนาจ ทนายความ เป็นต้น\n•    บุคคลใด ๆ ที่ท่านชำระเงินให้ และ/หรือได้รับชำระเงิน รวมถึงสถาบันทางการเงิน และผู้ให้บริการรับชำระเงิน\n•    บุคคล หรือบริษัทใด ๆ ซึ่งเกี่ยวข้องกับการปรับโครงสร้างบริษัท การควบรวม หรือเข้าถือครองกิจการที่เกิดขึ้นหรืออาจเกิดขึ้น โดยรวมถึงการโอนสิทธิ หรือหน้าที่ใด ๆ ซึ่งเรามีอยู่ภายใต้สัญญาระหว่างเราและท่าน\n•    หน่วยงานที่เกี่ยวข้องกับการรับรองมาตรฐานต่างๆ ที่เราขอการรับรองเพื่อประโยชน์ในการดำเนินธุรกิจ รวมถึงกระบวนการตรวจสอบโดยหน่วยงานกำกับดูแลของภาครัฐ และหน่วยงานตรวจสอบอื่น ๆ\n•    หน่วยงานที่บังคับใช้กฎหมาย รัฐบาล หน่วยงานภาครัฐ ศาล กระบวนการทางศาล หน่วยงานระงับข้อพิพาท ผู้ตรวจสอบบัญชี และบุคคลใด ๆ ซึ่งถูกแต่งตั้ง หรือร้องขอให้ตรวจสอบกิจกรรมการดำเนินงานของเรา\n•    บุคคลใด ๆ ซึ่งมีความเกี่ยวข้องกับข้อพิพาทใด ๆ ที่เกิดขึ้น\n•    หน่วยงานป้องกันการทุจริตซึ่งใช้ข้อมูลส่วนบุคคลเพื่อยืนยันตัวตนของท่าน และสืบหา และป้องกันการทุจริต รวมถึงอาชญากรรมทางการเงิน\n•    บุคคลใด ๆ ที่เราได้รับคำสั่งจากท่านให้เปิดเผยข้อมูลส่วนบุคคลของท่านให้กับบุคคลดังกล่าว\n\n     เว้นแต่ได้กำหนดไว้ในประกาศความเป็นส่วนตัวนี้ เราจะไม่ใช้ข้อมูลส่วนบุคคลเพื่อวัตถุประสงค์อื่นนอกเหนือจากวัตถุประสงค์ตามที่ระบุไว้ในประกาศความเป็นส่วนตัวนี้ หากเราจะเก็บรวบรวม ใช้ หรือเปิดเผยข้อมูลเพิ่มเติมซึ่งไม่ได้ระบุไว้ในประกาศความเป็นส่วนตัวนี้ เราจะแจ้งให้ท่านทราบและขอความยินยอมจากท่านก่อนการเก็บรวบรวม ใช้ และเปิดเผย เว้นแต่ในกรณีที่กฎหมายอนุญาตให้เราดำเนินการดังกล่าวได้โดยไม่ต้องอาศัยความยินยอมของท่าน ท่านมีสิทธิให้ความยินยอมหรือปฏิเสธ การเก็บรวบรวม ใช้ และ/หรือเปิดเผยข้อมูลส่วนบุคคลของท่าน\n\n     เราจะปฏิบัติตามประกาศความเป็นส่วนตัวนี้อย่างเคร่งครัดต่อข้อมูลที่อยู่ในความครอบครองเราซึ่งเกี่ยวข้องกับลูกค้าและพันธมิตรทางธุรกิจในอดีต ปัจจุบัน และในอนาคต\n\nการส่ง หรือโอนข้อมูลไปยังต่างประเทศ\n\n     เราอาจต้องส่ง หรือโอนข้อมูลส่วนบุคคลเพื่อการปฏิบัติตามสัญญาที่ทำขึ้นระหว่างท่านและเรา เพื่อปฏิบัติตามข้อกำหนดทางกฎหมาย ปกป้องคุ้มครองประโยชน์สาธารณะ และ/หรือ เพื่อผลประโยชน์อันชอบธรรมของเรา อย่างไรก็ตามกฎหมายของบางประเทศอาจกำหนดให้เรา ต้องเปิดเผยข้อมูลส่วนบุคคลบางประเภท เช่น เปิดเผยให้กับหน่วยงานทางภาษี ในกรณีเช่นว่านั้น เราจะเปิดเผยข้อมูลส่วนบุคคลให้กับบุคคลที่มีสิทธิเห็น หรือเข้าถึงข้อมูลดังกล่าวเท่านั้น และจะกำหนดให้มีมาตรการคุ้มครองข้อมูลส่วนบุคคลในระดับที่เหมาะสม',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '\n4. การเก็บรักษาข้อมูลส่วนบุคคล\n\n     เราจะเก็บรักษาข้อมูลส่วนบุคคลของท่านไว้นานเท่าที่จำเป็นเพื่อให้เป็นไปตามวัตถุประสงค์ที่ระบุไว้ในประกาศความเป็นส่วนตัวนี้หรือนโยบายการเก็บรักษาข้อมูลภายในบริษัทฯ ในกรณีทั่วไประยะเวลาการเก็บข้อมูลสูงสุดจะเท่ากับ 10 ปี เว้นแต่กรณีที่มีเหตุผลทางกฎหมาย หรือเหตุผลทางเทคนิครองรับ เราอาจเก็บรักษาข้อมูลส่วนบุคคลของท่านไว้นานกว่าที่กำหนด หากเราไม่มีความจำเป็นที่จะต้องเก็บรักษาข้อมูลของท่านแล้ว เราจะทำลาย ลบ หรือทำให้ข้อมูลส่วนบุคคลเป็นข้อมูลที่ไม่สามารถระบุตัวบุคคลที่เป็นเจ้าของข้อมูลส่วนบุคคล เพื่อที่ข้อมูลดังกล่าวจะไม่มีความเชื่อมโยงถึงท่านอีกต่อไป หรือถ้าในกรณีที่มีข้อจำกัดทางเทคนิคหรือสาเหตุจำเป็นอื่น เช่น ข้อมูลส่วนบุคคลของท่านถูกจัดเก็บไว้ในฐานข้อมูลสำรองแบบถาวร เราจะเก็บรักษาข้อมูลส่วนบุคคลของท่านอย่างปลอดภัย และคัดแยกข้อมูลส่วนบุคคลของท่านออกจากการประมวลผลต่อไปจากนี้ จนกระทั่งเราสามารถดำเนินการลบข้อมูลส่วนบุคคลของท่านได้\n\n5. ความถูกต้องของข้อมูลส่วนบุคคล\n\n     เราขอความร่วมมือจากท่านในการทำให้ข้อมูลส่วนบุคคลของท่านเป็นปัจจุบัน สมบูรณ์ และถูกต้อง โดยท่านสามารถแจ้งเราเมื่อข้อมูลส่วนบุคคลของท่านมีการเปลี่ยนแปลงใด ๆ ได้ โดยผ่านช่องทางการติดต่อเราที่ระบุข้างใต้ประกาศฉบับนี้\n\n6. สิทธิของท่านในฐานะเจ้าของข้อมูลส่วนบุคคล\n\n     ท่านมีสิทธิในข้อมูลส่วนบุคคลของท่านตามกฎหมายการคุ้มครองข้อมูลส่วนบุคคล โดยบริษัทฯ จะเคารพสิทธิของท่านและจะดำเนินการตามกฎหมาย กฎเกณฑ์ หรือกฎระเบียบที่เกี่ยวข้องกับการประมวลผลข้อมูลของท่านอย่างทันท่วงที\nรายละเอียดของสิทธิของท่านเป็นไปตามที่ระบุไว้ ดังต่อไปนี้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '•    สิทธิในการขอถอนความยินยอม ในการประมวลผลข้อมูลส่วนบุคคลของท่านที่เคยให้ไว้ได้ตลอดเวลา\n•    สิทธิในการขอเข้าถึง ขอรับสำเนาข้อมูลส่วนบุคคล หรือขอให้เปิดเผยถึงการได้มาของข้อมูลส่วนบุคคล\n•    สิทธิในการขอแก้ไขข้อมูลส่วนบุคคล ให้ถูกต้อง เป็นปัจจุบัน และสมบูรณ์\n•    สิทธิในการขอลบหรือทำลายข้อมูลส่วนบุคคล เพื่อทำให้ไม่สามารถระบุตัวตนของท่านได้\n•    สิทธิในการคัดค้านการเก็บ รวบรวม ใช้ หรือเปิดเผยข้อมูลส่วนบุคคล ได้ตลอดเวลา เว้นแต่กรณีที่มีเหตุในการปฏิเสธคำขอของท่านโดยชอบด้วยกฎหมาย\n•    สิทธิในการขอระงับการใช้ข้อมูลส่วนบุคคล\n•    สิทธิในการเคลื่อนย้ายข้อมูล ท่านสามารถร้องขอให้บริษัทฯ ส่งข้อมูลส่วนบุคคลของท่านไปให้บุคคลอื่นได้\n\n     ท่านสามารถใช้สิทธิของท่านได้ตลอดเวลาโดยติดต่อเราผ่านทางช่องทางการติดต่อตามที่ระบุไว้ในประกาศความเป็นส่วนตัวนี้ พร้อมแนบสำเนาบัตรประจำตัวประชาชน หรือข้อมูลส่วนบุคคลที่ใช้ระบุตัวตนอื่น ๆ ตามที่เราร้องขอ ทั้งนี้ ข้อมูลส่วนบุคคลที่ใช้พิสูจน์ตัวตนใด ๆ ที่ได้มอบให้แก่เราจะถูกนำไปประมวลผลตามและในขอบเขตที่กฎหมายที่เกี่ยวข้องอนุญาตเท่านั้น โดยไม่ต้องเสียค่าธรรมเนียม อย่างไรก็ตาม เราอาจคิดค่าธรรมเนียมตามสมควรหากคำขอของท่านไม่มีมูล ซ้ำซ้อน หรือมีมากเกินความจำเป็น และเรายังคงไว้ซึ่งสิทธิตามกฎหมายในการปฏิเสธคำขอของท่านหากมีเหตุอันสมควร ซึ่งเราจะแจ้งถึงการปฏิเสธและเหตุผลในการปฏิเสธคำขอดังกล่าวให้ท่านทราบเป็นรายกรณี\n\n     ในกรณีที่ท่านต้องการร้องเรียนเกี่ยวกับวิธีการที่บริษัทฯ ประมวลผลข้อมูลส่วนบุคคลของท่าน กรุณาติดต่อบริษัทฯ และบริษัทฯ จะพิจารณาคำขอของท่านโดยเร็วที่สุด ทั้งนี้ การร้องเรียนต่อบริษัทฯ นี้จะไม่มีผลกระทบต่อสิทธิของท่านในการร้องเรียนต่อเจ้าหน้าที่รัฐที่มีหน้าที่เกี่ยวกับการคุ้มครองข้อมูลส่วนบุคคล',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '\n7. ความปลอดภัยของข้อมูลส่วนบุคคลของท่าน\n\n     ข้อมูลถือเป็นทรัพย์สินของบริษัทฯ ดังนั้นบริษัทฯ จึงให้ความสำคัญกับความปลอดภัยของข้อมูลส่วนบุคคลของท่านเป็นอย่างยิ่ง บริษัทฯ จะตรวจสอบ และใช้มาตรการรักษาความปลอดภัยขององค์กร ทั้งทางกายภาพ และทางเทคนิคที่ทันสมัยอยู่เสมอเมื่อประมวลผลข้อมูลส่วนบุคคลของท่าน บริษัทฯ ได้วางนโยบาย และมาตรการควบคุมภายในเพื่อให้ท่านมั่นใจว่าข้อมูลส่วนบุคคลของท่านจะไม่สูญหาย ถูกทำลายโดยไม่ตั้งใจ ถูกนำไปใช้ในทางที่ผิด ถูกเปิดเผย และเข้าถึงโดยบุคคลทั่วไปที่ไม่ใช่พนักงานที่ปฏิบัติหน้าที่ของบริษัทฯ โดยพนักงานของบริษัทฯ ที่สามารถเข้าถึงข้อมูลส่วนบุคคลของท่านได้นั้น จะได้รับการอบรม และฝึกฝนเกี่ยวกับข้อกำหนดในการคุ้มครองข้อมูล และจะจัดการกับข้อมูลส่วนบุคคลของท่านอย่างปลอดภัย ตามประกาศนี้และภาระหน้าที่ของบริษัทฯ ตามกฎหมายความเป็นส่วนตัวที่บังคับใช้เท่านั้น\n\n8. หน้าที่ของท่าน\n\n     ท่านมีหน้าที่ตรวจสอบว่าข้อมูลส่วนบุคคลที่ท่านให้ไว้กับเราไม่ว่าจะด้วยตัวของท่านเอง หรือในนามของท่าน มีความถูกต้อง และเป็นปัจจุบัน และมีหน้าที่ต้องแจ้งให้เราทราบโดยเร็วที่สุดหากข้อมูลดังกล่าวมีการเปลี่ยนแปลง\n\n     เมื่อท่านสมัครใจเข้ามาเป็นลูกค้า หรือพันธมิตรทางธุรกิจ หรือเข้าทำสัญญากับเราแล้ว ท่านจะมีหน้าที่ตามข้อตกลงหรือสัญญาในการส่งมอบข้อมูลส่วนบุคคลให้แก่เรา เพื่อให้ท่านสามารถใช้สิทธิทางกฎหมายได้ การไม่ปฏิบัติตามหน้าที่ดังกล่าวอาจส่งผลให้ท่านสูญเสียสิทธิทางกฎหมาย\n\n\     ท่านมีความจำเป็นที่จะต้องส่งมอบข้อมูลส่วนบุคคล เช่น ข้อมูลการติดต่อ เลขประจำตัวผู้เสียภาษี และข้อมูลการชำระเงิน เพื่อให้เราสามารถเข้าทำธุรกรรมหรือสัญญากับท่านได้ หากท่านไม่ส่งมอบข้อมูลส่วนบุคคลดังกล่าว อาจทำให้เราไม่สามารถใช้สิทธิ และปฏิบัติตามภาระข้อผูกพันที่เกิดขึ้นจากข้อตกลงหรือสัญญาได้อย่างมีประสิทธิภาพ\n\n9. การแก้ไข เปลี่ยนแปลงประกาศความเป็นส่วนตัว\n\n     เราขอสงวนสิทธิ์ในการแก้ไข ปรับปรุงและเปลี่ยนแปลงประกาศฉบับนี้ได้ทุกเมื่อตามดุลยพินิจของเรา เพื่อให้เกิดความเหมาะสมและเป็นไปตามกฎหมาย จึงขอให้ท่านตรวจสอบประกาศฉบับนี้อย่างสม่ำเสมอ โดยการแก้ไขเปลี่ยนแปลงครั้งล่าสุดนั้น ท่านสามารถดูได้จากวันที่ด้านบนของประกาศความเป็นส่วนตัวฉบับนี้\n\n10. ช่องทางการติดต่อเรา\n\n     ในกรณีที่ท่านมีข้อสงสัยเกี่ยวกับการคุ้มครองข้อมูลส่วนบุคคลของท่าน หรือต้องการใช้สิทธิใด ๆ โปรดติดต่อเราที่',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'บริษัท มหาชัยฟู้ดส์ จำกัด:                     ฝ่ายบริหารทรัพยากรมนุษย์\nสำนักงานใหญ่:                                       เลขที่ 259/13 ซอยปรีดีพนมยงค์ 13 ถนนสุขุมวิท 71 แขวงพระโขนงเหนือ\n                                                                 เขตวัฒนา กรุงเทพมหานคร\nสำนักงานสาขามหาชัย:                          เลขที่ 71/11หมู่ที่ 6 ตำบลท่าทราย อำเภอเมืองสมุทรสาคร จังหวัดสมุทรสาคร\nE-Mail/Website:                                  pdpa@mfood.co.th หรือ www.mfood.co.th\nหมายเลขโทรศัพท์:                                 061-406-5999 หรือ 034-426-414 ต่อ 6522, 6569',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '\n     ประกาศฉบับนี้มีผลตั้งแต่วันที่ 1 มิถุนายน 2565 เป็นต้นไป จนกว่าจะมีการเปลี่ยนแปลง',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: true,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ข้าพเจ้าได้อ่าน และทำความเข้าใจ และยอมรับว่าบริษัทฯได้แจ้งให้ข้าพเจ้ารับทราบถึง\nประกาศความเป็นส่วนตัวนี้แล้ว',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '       ชื่อ - นามสกุล :                                                            ผู้ให้ความยินยอม',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '       วันที่  ${formatThaiDate(customerList[i]['CustomerDateUpdate'])}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 100,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  3, 7, 3, 7),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue.shade900,
                                                  // border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                'ความเป็นส่วนตัว',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: Colors.white,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 10, 20, 20),
                                                    width: double.infinity,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'หนังสือให้ความยินยอมในการเก็บรวบรวมใช้ และ/หรือ เปิดเผยข้อมูลส่วนบุคคล',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleLargeFont,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'วันที่  ${formatThaiDate(customerList[i]['CustomerDateUpdate'])}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'ลูกค้า ผู้จัดจำหน่าย ผู้ให้บริการ และพันธมิตรทางธุรกิจ:',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'ชื่อ - สกุล',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'หมายเลขบัตรประชาชน/หนังสือเดินทาง',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     บริษัท มหาชัยฟู้ดส์ จำกัด และบริษัทในกลุ่ม ส.ขอนแก่นฟู้ดส์ จำกัด (มหาชน) (“บริษัทฯ” หรือ “เรา”) มีความมุ่งมั่นที่จะผลิตสินค้าและให้บริการแก่ท่านด้วยมาตรฐานของบริษัทฯ อย่างไรก็ตาม เพื่อให้เราสามารถดำเนินการตามคำสั่งซื้อ ปฏิบัติตามสัญญา และ/หรือดำเนินการที่เกี่ยวข้องกับธุรกิจของเราให้แก่ท่านได้ เราจึงขอความยินยอมจากท่านในการเก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคลของท่านภายใต้พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 (พ.ร.บ.ฯ) เพื่อวัตถุประสงค์ตามที่ระบุไว้ด้านล่างนี้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     ท่านมีสิทธิที่จะปฏิเสธการยินยอมให้เราเก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคลของท่านเพื่อวัตถุประสงค์ตามที่ระบุไว้ด้านล่างนี้เมื่อใดก็ได้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          Text(
                                                            'ท่านยินยอมให้เรา บริษัทในเครือของเรา หรือพันธมิตรของเรา ประมวลผลข้อมูลส่วนบุคคลของท่านเพื่อวัตถุประสงค์ทางการตลาด และการนำเสนอสินค้า/บริการที่เหมาะสมกับท่าน',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleLargeFont,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'การปฏิเสธ หรือเพิกถอนความยินยอมในการประมวลผลข้อมูลส่วนบุคคลตามวัตถุประสงค์ด้านล่างนี้ จะไม่ส่งผลต่อการปฏิบัติตามสัญญาที่เรามี หรืออาจมีกับท่าน',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     1.   เพื่อเสนอสินค้า และ/หรือบริการ และ/หรือการส่งเสริมการขายที่เราวิเคราะห์แล้วว่าตรงกับความต้องการของท่าน',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            0] ==
                                                                        false
                                                                    ? false
                                                                    : true,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            0] ==
                                                                        false
                                                                    ? true
                                                                    : false,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ไม่ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     2.   เพื่อเสนอสินค้า และ/หรือบริการ และ/หรือการส่งเสริมการขายของเราที่ดำเนินการโดยบริษัทอื่น หรือตัวแทนผู้ให้บริการของเรา',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            1] ==
                                                                        false
                                                                    ? false
                                                                    : true,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            1] ==
                                                                        false
                                                                    ? true
                                                                    : false,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ไม่ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '      3.   เพื่อการวิจัย ทำข้อมูลสถิติ พัฒนา วิเคราะห์ สินค้า/บริการ และสิทธิประโยชน์ที่เหมาะสมกับท่าน โดยที่ดำเนินการด้วยตัวเราเอง หรือโดยบริษัทอื่น หรือตัวแทนผู้ให้บริการของเรา',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            2] ==
                                                                        false
                                                                    ? false
                                                                    : true,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            2] ==
                                                                        false
                                                                    ? true
                                                                    : false,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ไม่ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          Text(
                                                            'ท่านยินยอมให้เราประมวลผลข้อมูลส่วนบุคคลที่มีความละเอียดอ่อนของท่าน เช่น ข้อมูลศาสนาที่ระบุอยู่บนบัตรประจำตัวประชาชน ข้อมูลเชื้อชาติที่ระบุอยู่บนหนังสือเดินทาง ข้อมูลทางการแพทย์ ข้อมูลสุขภาพ และการตรวจรักษา เป็นต้น',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleLargeFont,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'การปฏิเสธ หรือเพิกถอนความยินยอมในการประมวลผลข้อมูลส่วนบุคคลตามวัตถุประสงค์ด้านล่างนี้ อาจส่งผลให้เราไม่สามารถปฏิบัติตามสัญญาที่เรามี หรืออาจมีกับท่าน หรือตอบสนองต่อข้อร้องเรียนเกี่ยวกับสินค้า และ/หรือบริการของเราที่มีผลต่อสุขภาพของท่านแก่ท่านได้',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     1.   เพื่อตรวจสอบ และยืนยันตัวตนของท่านเพื่อใช้ในการดำเนินการตามขั้นตอนการสมัครและการเป็นพันธมิตรทางธุรกิจ หรือลูกค้าของเราให้เสร็จสมบูรณ์ เช่น ข้อมูลศาสนาและเชื้อชาติ เป็นต้น',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            3] ==
                                                                        false
                                                                    ? false
                                                                    : true,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            3] ==
                                                                        false
                                                                    ? true
                                                                    : false,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ไม่ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     2.   เพื่อดำเนินการตอบสนองต่อข้อร้องเรียนเกี่ยวกับสินค้า และ/หรือบริการของเราที่มีผลต่อสุขภาพของท่าน (สำหรับลูกค้าที่เป็นผู้บริโภค) เช่น ข้อมูลสุขภาพ การแพ้อาหาร เป็นต้น',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            4] ==
                                                                        false
                                                                    ? false
                                                                    : true,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value: customerList[i]['PDPA']['คำถาม']
                                                                            [
                                                                            4] ==
                                                                        false
                                                                    ? true
                                                                    : false,
                                                                onChanged:
                                                                    (value) {},
                                                              ),
                                                              Text(
                                                                'ไม่ยินยอม',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          Text(
                                                            'ประกาศความเป็นส่วนตัว',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '     ข้าพเจ้าได้อ่านและรับทราบประกาศความเป็นส่วนตัวของบริษัทฯ แล้ว และข้าพเจ้ารับทราบว่า ข้าพเจ้ามีสิทธิเพิกถอนความยินยอมในการประมวลผลข้อมูลส่วนบุคคลของข้าพเจ้า เพื่อวัตถุประสงค์ตามที่ระบุไว้ในหนังสือฉบับนี้ได้ตลอดเวลา โดยแจ้งให้กับเจ้าหน้าที่คุ้มครองข้อมูลส่วนบุคคลของบริษัทฯ ทราบถึงการเพิกถอนความยินยอมดังกล่าวได้ที่\n\n     บริษัท มหาชัยฟู้ดส์ จำกัด: ฝ่ายบริหารทรัพยากรมนุษย์ สำนักงานใหญ่: เลขที่ 259/13 ซอยปรีดีพนมยงค์ 13 ถนนสุขุมวิท 71 แขวงพระโขนงเหนือ เขตวัฒนา กรุงเทพมหานคร สำนักงานสาขามหาชัย: เลขที่ 71/11 หมู่ที่ 6 ตำบลท่าทราย อำเภอเมืองสมุทรสาคร จังหวัดสมุทรสาคร E-Mail/Website : pdpa@mfood.co.th หรือ www.mfood.co.th หมายเลขโทรศัพท์: 061-406-5999 หรือ 034-426-414 ต่อ 6522, 6569\n\n     ความยินยอมนี้มีผลสมบูรณ์นับตั้งแต่วันที่ระบุไว้ในหนังสือขอความยินยอมในการประมวลผลข้อมูลส่วนบุคคลฉบับนี้จนถึงวันที่ท่านได้แจ้งเพิกถอนความยินยอมเป็นลายลักษณ์อักษรให้แก่เราทราบ\n\n     คำนิยามที่กล่าวถึงในหนังสือฉบับนี้ ให้มีความหมายเช่นเดียวกับความหมายที่ได้กำหนดไว้ใน พ.ร.บ.ฯ และประกาศความเป็นส่วนตัว',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 300,
                                                                height: 150,
                                                                child: Image
                                                                    .network(
                                                                  customerList[
                                                                              i]
                                                                          [
                                                                          'PDPA']
                                                                      [
                                                                      'ลายเซ็น'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '       ชื่อ - นามสกุล :                                                            ผู้ให้ความยินยอม',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '       วันที่  ${formatThaiDate(customerList[i]['CustomerDateUpdate'])}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge,
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          // StatefulBuilder(
                                                          //     builder: (context,
                                                          //         setState) {
                                                          //   return Column(
                                                          //     crossAxisAlignment:
                                                          //         CrossAxisAlignment
                                                          //             .center,
                                                          //     children: [
                                                          //       Container(
                                                          //         // color: Colors.white,
                                                          //         width: double
                                                          //             .infinity,
                                                          //         // height: 100,
                                                          //         child:
                                                          //             GestureDetector(
                                                          //           onTap:
                                                          //               () async {
                                                          //             // Navigator.pop(context);
                                                          //             await pickPdfFile2();
                                                          //           },
                                                          //           child:
                                                          //               Column(
                                                          //             crossAxisAlignment:
                                                          //                 CrossAxisAlignment
                                                          //                     .center,
                                                          //             mainAxisAlignment:
                                                          //                 MainAxisAlignment
                                                          //                     .start,
                                                          //             children: [
                                                          //               Icon(
                                                          //                 FFIcons
                                                          //                     .kpaperclipPlus,
                                                          //                 color:
                                                          //                     Colors.black,
                                                          //                 size: MediaQuery.of(context).size.height *
                                                          //                     0.025,
                                                          //               ),
                                                          //               SizedBox(
                                                          //                 width:
                                                          //                     MediaQuery.of(context).size.width * 0.03,
                                                          //               ),
                                                          //               Text(
                                                          //                 'หรือแนบไฟล์เอกสารจากข้างนอก',
                                                          //                 style:
                                                          //                     FlutterFlowTheme.of(context).titleLargeFont,
                                                          //               ),
                                                          //             ],
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //       SizedBox(
                                                          //         height: 20,
                                                          //       ),
                                                          //       for (int index =
                                                          //               0;
                                                          //           index <
                                                          //               finalFileResultString!
                                                          //                   .length;
                                                          //           index++)
                                                          //         Container(
                                                          //           alignment:
                                                          //               Alignment
                                                          //                   .center,
                                                          //           color: null,
                                                          //           // width: 600,
                                                          //           child: Row(
                                                          //             mainAxisAlignment:
                                                          //                 MainAxisAlignment
                                                          //                     .center,
                                                          //             mainAxisSize:
                                                          //                 MainAxisSize
                                                          //                     .max,
                                                          //             children: [
                                                          //               SizedBox(
                                                          //                 width:
                                                          //                     20,
                                                          //               ),
                                                          //               GestureDetector(
                                                          //                 onTap:
                                                          //                     () {
                                                          //                   OpenFile.open(finalFileResultString![index]);
                                                          //                 },
                                                          //                 child:
                                                          //                     Row(
                                                          //                   mainAxisSize:
                                                          //                       MainAxisSize.max,
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       '- ไฟล์ที่ ${index + 1}',
                                                          //                       style: FlutterFlowTheme.of(context).bodyMedium,
                                                          //                     ),
                                                          //                     SizedBox(width: 5),
                                                          //                     Icon(
                                                          //                       Icons.search,
                                                          //                       size: 16,
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //               SizedBox(
                                                          //                 width:
                                                          //                     100,
                                                          //               ),
                                                          //               Row(
                                                          //                 mainAxisSize:
                                                          //                     MainAxisSize.min,
                                                          //                 children: [
                                                          //                   GestureDetector(
                                                          //                     onTap: () {
                                                          //                       finalFileResultString!.removeAt(index);
                                                          //                       setState(() {});
                                                          //                     },
                                                          //                     child: Icon(
                                                          //                       Icons.remove_circle_outline,
                                                          //                       size: 16,
                                                          //                       color: Colors.red.shade900,
                                                          //                     ),
                                                          //                   ),
                                                          //                 ],
                                                          //               ),
                                                          //               SizedBox(
                                                          //                 width:
                                                          //                     10,
                                                          //               ),
                                                          //             ],
                                                          //           ),
                                                          //         ),
                                                          //     ],
                                                          //   );
                                                          // }),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  3, 7, 3, 7),
                                              decoration: BoxDecoration(
                                                  color: Colors.green.shade900,
                                                  // border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                'เอกสาร PDPA',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: Colors.white,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
