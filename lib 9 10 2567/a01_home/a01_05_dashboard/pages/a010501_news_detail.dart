import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';
import 'package:m_food/flutter_flow/flutter_flow_util.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class A010501NewsDetail extends StatefulWidget {
  final String? head;
  final String? day;
  final String? detail;
  const A010501NewsDetail({
    super.key,
    @required this.head,
    @required this.day,
    @required this.detail,
  });

  @override
  State<A010501NewsDetail> createState() => _A010501NewsDetailState();
}

class _A010501NewsDetailState extends State<A010501NewsDetail> {
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

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

    print('==============================');
    print('This is A050101 news dtail');
    print('==============================');
    print(widget.day);
    print(widget.detail);
    print(widget.head);

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
                        'ข่าวสาร',
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
              Padding(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'หัวข้อข่าวสาร : ' + widget.head!,
                        // 'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Kanit',
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.sizeOf(context).width >= 800.0
                                      ? 18.0
                                      : 16.0,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ประจำวันที่ : ' + widget.day!,
                        // 'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Kanit',
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.sizeOf(context).width >= 800.0
                                      ? 14.0
                                      : 12.0,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: HtmlWidget(
                        widget.detail!,
                        // textStyle: TextStyle(
                        //   fontFamily: 'GreenHome',
                        // ),
                        textStyle: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                                fontFamily: 'Kanit',
                                fontSize: 14.0,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText
                                // color: Colors.black
                                // fontWeight: FontWeight.w300,
                                ),
                      ),
                      // child: Text(
                      //   widget.detail!,
                      //   // 'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                      //   style: FlutterFlowTheme.of(context).bodySmall.override(
                      //         fontFamily: 'Kanit',
                      //         color: Colors.black,
                      //         fontSize: MediaQuery.sizeOf(context).width >= 800.0
                      //             ? 16.0
                      //             : 14.0,
                      //       ),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
