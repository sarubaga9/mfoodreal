import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_food/a01_home/a01_05_dashboard/pages/a010501_news_detail.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';
import 'package:m_food/flutter_flow/flutter_flow_util.dart';

class A010502SalesList extends StatefulWidget {
  final List<double>? topSaleTotal;
  final List<String>? topSaleName;
  final List<String?>? topSaleImg;

  const A010502SalesList({
    super.key,
    @required this.topSaleTotal,
    @required this.topSaleName,
    @required this.topSaleImg,
  });

  @override
  State<A010502SalesList> createState() => _A010502SalesListState();
}

class _A010502SalesListState extends State<A010502SalesList> {
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  List<double> topSaleTotal = [];
  List<String> topSaleName = [];
  List<String?> topSaleImg = [];

  String formatThaiDate(Timestamp timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
    );

    // แปลงปีคริสต์ศักราชเป็นปีพุทธศักราชโดยการเพิ่ม 543
    int thaiYear = dateTime.year + 543;

    // ใช้ intl package เพื่อแปลงรูปแบบวันที่
    // String formattedDate = DateFormat('dd-MM-yyyy')
    String formattedDate = DateFormat('dd MMMM yyyy', 'th_TH')
        .format(DateTime(dateTime.year, dateTime.month, dateTime.day));
    formattedDate = formattedDate.substring(0, formattedDate.length - 4);
    // เพิ่มปีพุทธศักราช
    formattedDate += '$thaiYear';

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    userData = userController.userData;

    topSaleTotal = widget.topSaleTotal!;
    topSaleName = widget.topSaleName!;
    topSaleImg = widget.topSaleImg!;

    for (int i = 0; i < topSaleTotal.length; i++) {
      if (topSaleTotal[i] == 0 && topSaleName[i] == '') {
        topSaleTotal!.removeAt(i);
        topSaleName.removeAt(i);
        topSaleImg.removeAt(i);
      }
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
          child: Column(
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
                        'Top เซลล์ประจำเดือน',
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
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                    onTap: () async {
                                      // await saveDataForLogout();

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     CupertinoPageRoute(
                                      //       builder: (context) =>
                                      //           A0105DashboardWidget(),
                                      //     )).then((value) {
                                      //   Navigator.pop(context);
                                      if (mounted) {
                                        setState(() {});
                                      }
                                      // });
                                      // Navigator.pop(context);
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Top เซลล์ประจำเดือน',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Kanit',
                          color: FlutterFlowTheme.of(context).alternate,
                          fontSize: 26),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              for (int i = 0; i < topSaleTotal!.length; i++)
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 8.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: topSaleImg![i] == null
                                    ? Container(
                                        width: 100.0,
                                        height: 100.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      )
                                    : topSaleImg![i] == ''
                                        ? Container(
                                            width: 100.0,
                                            height: 100.0,
                                            color: Colors.grey,
                                          )
                                        : Image.network(
                                            // 'assets/images/shutterstock_674309551.jpg',
                                            topSaleImg![i]!,
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'ยอดขายอันดับ ${i + 1}',
                                  // 'นายพฤตินัย พรมวิสิทธิ์สุนทร',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: i < 2
                                            ? Colors.green.shade900
                                            : Colors.yellow.shade700,
                                        fontSize:
                                            MediaQuery.sizeOf(context).width >=
                                                    800.0
                                                ? 24.0
                                                : 22.0,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'ชื่อพนักงานขาย : ' + topSaleName![i],
                                  // 'นายพฤตินัย พรมวิสิทธิ์สุนทร',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.sizeOf(context).width >=
                                                    800.0
                                                ? 22.0
                                                : 20.0,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  topSaleTotal![i] == 0
                                      ? ''
                                      : 'ยอดขาย ${NumberFormat('#,##0').format(topSaleTotal![i])} บาท',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.sizeOf(context).width >=
                                                    800.0
                                                ? 20.0
                                                : 18.0,
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
        ),
      )),
    );
  }
}
