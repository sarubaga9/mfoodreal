import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_food/a07_account_customer/a07_01_open_account/a070101_pdpa_account_widget.dart';
import 'package:m_food/a07_account_customer/a07_02_open_account/widget/map.dart';
import 'package:m_food/flutter_flow/flutter_flow_google_map.dart';
import 'package:m_food/index.dart';
import 'package:m_food/widgets/menu_sidebar_widget.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/user_controller.dart';
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
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;

class MapWidgetFirst extends StatefulWidget {
  final String? latitude;
  final String? longtitude;
  const MapWidgetFirst({Key? key, this.latitude, this.longtitude})
      : super(key: key);

  @override
  _MapWidgetFirstState createState() => _MapWidgetFirstState();
}

class _MapWidgetFirstState extends State<MapWidgetFirst> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  Set<Marker> markers = Set<Marker>();
  google_maps.LatLng? latList;
  google_maps.LatLng? lotList;
  TextEditingController? searchMap = TextEditingController();
  Map<String, dynamic>? resultList = {};
  Completer<google_maps.GoogleMapController>? _mapController;
  GlobalKey? _mapKeyDialog = GlobalKey();
  google_maps.CameraPosition? _kGooglePlexDialog;

  double? latitudeToBack = 0.0;
  double? longitudeToBack = 0.0;

  @override
  void initState() {
    super.initState();
    print(widget.latitude);
    print(widget.longtitude);
    super.initState();

    markers.add(
      Marker(
        markerId: MarkerId('Point'),
        position: google_maps.LatLng(
            double.parse(
                widget.latitude! == '' ? '13.7563309' : widget.latitude!),
            double.parse(
                widget.longtitude == '' ? '100.5017651' : widget.longtitude!)),
        infoWindow: InfoWindow(
          title: 'จุดที่ 1',
          snippet: 'สถานที่ที่คุณเลือก',
          onTap: () {},
        ),
      ),
    );
    latList = google_maps.LatLng(0, 0);
    lotList = google_maps.LatLng(0, 0);
    searchMap = TextEditingController();
    resultList = {};
    _mapController = Completer();

    _kGooglePlexDialog = google_maps.CameraPosition(
        target: google_maps.LatLng(
            double.parse(
                widget.latitude! == '' ? '13.7563309' : widget.latitude!),
            double.parse(
                widget.longtitude == '' ? '100.5017651' : widget.longtitude!)),
        zoom: 14.4746);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is A07021 Map Widget');
    print('==============================');
    double mapZoom = 14.4746;

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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          // top: false,
          child: SingleChildScrollView(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
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
                                                'latitudeToBack':
                                                    latitudeToBack == 0.0
                                                        ? widget.latitude
                                                        : latitudeToBack,
                                                'longitudeToBack':
                                                    longitudeToBack == 0.0
                                                        ? widget.longtitude
                                                        : longitudeToBack,
                                                // เพิ่มค่าอื่น ๆ ตามต้องการ
                                              });
                                            },
                                            child: Icon(
                                              Icons.chevron_left,
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        userData!.isNotEmpty
                                            ? Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    '${userData!['Name']} ${userData!['Surname']}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                    userData!.isNotEmpty
                                        ? Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 0.0, 0.0),
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
                                                    // saveDataForLogout();
                                                  },
                                                  child: Icon(
                                                    Icons.account_circle,
                                                    color: FlutterFlowTheme.of(
                                                            context)
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
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1.0,
                                    height: 800.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(0.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: GoogleMap(
                                      key: _mapKeyDialog,
                                      onTap: (argument) async {
                                        double lat = argument.latitude;
                                        double lot = argument.longitude;

                                        latitudeToBack = lat;
                                        longitudeToBack = lot;

                                        _kGooglePlexDialog =
                                            google_maps.CameraPosition(
                                          target: google_maps.LatLng(lat, lot),
                                          zoom: mapZoom,
                                        );

                                        markers.clear();

                                        markers.add(
                                          Marker(
                                            markerId: MarkerId('Point'),
                                            position:
                                                google_maps.LatLng(lat, lot),
                                            infoWindow: InfoWindow(
                                              title: 'จุดที่ ${1}',
                                              snippet: 'สถานที่ที่คุณเลือก',
                                              onTap: () {},
                                            ),
                                          ),
                                        );

                                        _mapKeyDialog = GlobalKey();
                                        final google_maps.GoogleMapController
                                            controller =
                                            await _mapController!.future;

                                        controller.animateCamera(
                                            google_maps.CameraUpdate
                                                .newCameraPosition(
                                                    _kGooglePlexDialog!));

                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      mapType: google_maps.MapType.hybrid,
                                      initialCameraPosition:
                                          _kGooglePlexDialog!,
                                      markers: markers,
                                      onMapCreated:
                                          (google_maps.GoogleMapController
                                              controller) {
                                        _mapController!.complete(controller);
                                      },
                                      onCameraMove: (google_maps.CameraPosition
                                          position) {
                                        mapZoom = position.zoom;
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          30.0, 15.0, 30.0, 5.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            alignment: AlignmentDirectional(
                                                0.00, 0.00),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: TextFormField(
                                                      controller: searchMap,
                                                      autofocus: false,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium,
                                                        hintText:
                                                            '        ค้นหาสถานที่',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    print(searchMap!.text);
                                                    print('search button');
                                                    try {
                                                      List<Location> locations =
                                                          await locationFromAddress(
                                                              searchMap!.text);
                                                      print(searchMap!.text);

                                                      print(locations);

                                                      if (locations
                                                          .isNotEmpty) {
                                                        Location location =
                                                            locations.first;
                                                        print(
                                                            'Latitude: ${location.latitude}, Longitude: ${location.longitude}');
                                                        double lat =
                                                            location.latitude;
                                                        double lot =
                                                            location.longitude;

                                                        print(lat);
                                                        print(lot);

                                                        latitudeToBack = lat;
                                                        longitudeToBack = lot;

                                                        _kGooglePlexDialog =
                                                            google_maps
                                                                .CameraPosition(
                                                          target: google_maps
                                                              .LatLng(lat, lot),
                                                          zoom: 14.4746,
                                                        );
                                                        markers.clear();
                                                        markers.add(
                                                          Marker(
                                                            markerId: MarkerId(
                                                                'Point'),
                                                            position:
                                                                google_maps
                                                                    .LatLng(lat,
                                                                        lot),
                                                            infoWindow:
                                                                InfoWindow(
                                                              title: 'จุดที่ 1',
                                                              snippet:
                                                                  'สถานที่ที่คุณเลือก',
                                                              onTap: () {},
                                                            ),
                                                          ),
                                                        );
                                                        _mapKeyDialog =
                                                            GlobalKey();

                                                        final google_maps
                                                            .GoogleMapController
                                                            controller =
                                                            await _mapController!
                                                                .future;

                                                        controller.animateCamera(
                                                            google_maps
                                                                    .CameraUpdate
                                                                .newCameraPosition(
                                                                    _kGooglePlexDialog!));

                                                        if (mounted) {
                                                          setState(() {});
                                                        }
                                                      } else {
                                                        print(
                                                            'No location found for the given address');
                                                      }
                                                    } catch (e) {
                                                      print('Error: $e');
                                                      await Fluttertoast
                                                          .showToast(
                                                        msg:
                                                            "   ไม่มีสถานที่นี้ค่ะ กรุณากรอกชื่อสถานที่ใหม่ค่ะ   ",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 5,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    }
                                                    print('search button');

                                                    if (mounted) {
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.search_sharp,
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
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 5.0, 8.0, 5.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    print('Map Banck ...');
                                    Navigator.pop(context, {
                                      'latitudeToBack': latitudeToBack == 0.0
                                          ? widget.latitude
                                          : latitudeToBack,
                                      'longitudeToBack': longitudeToBack == 0.0
                                          ? widget.longtitude
                                          : longitudeToBack,
                                      // เพิ่มค่าอื่น ๆ ตามต้องการ
                                    });
                                  },
                                  text: 'บันทึกพิกัด',
                                  options: FFButtonOptions(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
