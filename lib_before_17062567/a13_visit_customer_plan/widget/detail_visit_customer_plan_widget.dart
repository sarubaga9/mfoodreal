import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'package:m_food/a13_visit_customer_plan/a1303_visit_form.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';

import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as google_maps;

import 'package:google_maps_flutter_platform_interface/src/types/ui.dart'
    as ui_maps;

class DetailVisitCustomerPlanWidget extends StatefulWidget {
  final MapEntry<String, dynamic>? entry;
  const DetailVisitCustomerPlanWidget({this.entry, super.key});

  @override
  _DetailVisitCustomerPlanWidgetState createState() =>
      _DetailVisitCustomerPlanWidgetState();
}

class _DetailVisitCustomerPlanWidgetState
    extends State<DetailVisitCustomerPlanWidget> {
  Map<String, dynamic>? data;
  bool isLoading = false;

  Completer<GoogleMapController> mapController2 =
      Completer<GoogleMapController>();
  late CameraPosition _kGooglePlex;

  Set<Marker> markers = Set<Marker>();
  Set<Marker> markersDialog = Set<Marker>();

  Key _mapKey = GlobalKey();

  @override
  void initState() {
    print(widget.entry!.value['CustomerID']);
    searchDocument(widget.entry!.value['CustomerID']);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> searchDocument(String documentId) async {
    try {
      setState(() {
        isLoading = true;
      });
      // print('---------------------------------------------------------------');

      // Position position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.best);
      // double currentLat = position.latitude;
      // double currentLong = position.longitude;
      // print(currentLat);
      // print(currentLong);
      // print('---------------------------------------------------------------');

      if (widget.entry!.value['ละติจูด'] == '') {
        print('1');

        _kGooglePlex = CameraPosition(
          target: google_maps.LatLng(13.7563309, 100.5017651),
          zoom: 15,
        );
        markers.add(
          Marker(
            markerId: MarkerId('map'),
            position: google_maps.LatLng(13.7563309, 100.5017651), // ตำแหน่ง
            // infoWindow: InfoWindow(
            //   title: 'จุดที่ ${i + 1}', // ชื่อของปักหมุด
            //   snippet: resultList[i]['Latitude'],
            //   onTap: () async {
            //     await mapDialog(resultList, resultList[i]['ID']).whenComplete(() {
            //       print('6666');
            //       _mapKey = GlobalKey();
            //       print('7777');
            //       if (mounted) {
            //         setState(() {});
            //       }
            //       print('88888');
            //     });
            //     //     .whenComplete(() {
            //     //   setState(
            //     //     () {
            //     //       loadMap = true;
            //     //     },
            //     //   );

            //     //   return;

            //     // });
            //   }, // คำอธิบายของปักหมุด
            // ),
          ),
        );
      } else {
        print('2');
        _kGooglePlex = CameraPosition(
          target: google_maps.LatLng(
              double.parse(widget.entry!.value['ละติจูด']),
              double.parse(widget.entry!.value['ลองติจูด'])),
          zoom: 15,
        );
        markers.add(
          Marker(
            markerId: MarkerId('map'),
            position: google_maps.LatLng(
                double.parse(widget.entry!.value['ละติจูด']),
                double.parse(widget.entry!.value['ลองติจูด'])), // ตำแหน่ง
            // infoWindow: InfoWindow(
            //   title: 'จุดที่ ${i + 1}', // ชื่อของปักหมุด
            //   snippet: resultList[i]['Latitude'],
            //   onTap: () async {
            //     await mapDialog(resultList, resultList[i]['ID']).whenComplete(() {
            //       print('6666');
            //       _mapKey = GlobalKey();
            //       print('7777');
            //       if (mounted) {
            //         setState(() {});
            //       }
            //       print('88888');
            //     });
            //     //     .whenComplete(() {
            //     //   setState(
            //     //     () {
            //     //       loadMap = true;
            //     //     },
            //     //   );

            //     //   return;

            //     // });
            //   }, // คำอธิบายของปักหมุด
            // ),
          ),
        );
      }

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'CustomerTest'
              : 'Customer') // แทน 'your_collection' ด้วยชื่อ collection ของคุณ
          .doc(documentId) // ใส่ Document ID ที่ต้องการค้นหา
          .get();
      print(documentId);

      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map<String, dynamic>;
        print('ffff');
        print('Document found');
        // print(documentSnapshot.data());
      } else {
        print('Document not found');
        data = {};
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String customFormatThai(DateTime dateTime) {
    final List<String> monthNames = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];

    String day = dateTime.day.toString();
    String month = monthNames[dateTime.month - 1];
    String year =
        (dateTime.year + 543).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

    return '$day $month $year';
  }

  String customFormatThaiToMonth(DateTime dateTime) {
    final List<String> monthNames = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];

    String day = dateTime.day.toString();
    String month = monthNames[dateTime.month - 1];
    String year =
        (dateTime.year + 543).toString(); // เพิ่ม 543 ในปีเพื่อแปลงเป็น พ.ศ.

    return '$month $year';
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.entry);

    return isLoading
        ? CircularLoading()
        : Container(
            decoration: const BoxDecoration(),
            child: Container(
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            '${widget.entry!.value['ชื่อนามสกุล']}  เวลา ${widget.entry!.value['วันเดือนปีนัดหมาย'].toDate().toString().substring(10, 16)} น',
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Kanit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        A1303VisitForm(entry: widget.entry),
                                  )).then((value) {
                                setState(() {});
                                Navigator.pop(context);
                              });
                            },
                            text: 'แก้ไข',
                            options: FFButtonOptions(
                              height: 30.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 5.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).alternate,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Kanit',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                              elevation: 3.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'ยอดขายโดยรวมสะสมของลูกค้าประจำปี ${DateTime.now().year + 543}',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'เป็นลูกค้าประเภท${data!['ประเภทลูกค้า'] == 'Company' ? 'นิติบุคคล' : 'บุคคลธรรมดา'}',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'ประวัติดการสั่งซื้อ เดือนล่าสุด',
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Kanit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxWidth: 970.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5.0, 0.0, 5.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    16.0,
                                    0,
                                    16.0,
                                  ),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxWidth: 570.0,
                                      ),
                                      decoration: const BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 10.0,
                                                height: 10.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          3.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    customFormatThaiToMonth(
                                                        DateTime.now()),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 0.9,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(6.0, 0.0, 0.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    offset:
                                                        const Offset(-2.0, 0.0),
                                                  )
                                                ],
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        5.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(AppSettings
                                                                        .customerType ==
                                                                    CustomerType
                                                                        .Test
                                                                ? 'CustomerTest'
                                                                : 'Customer')
                                                            .doc(widget.entry!
                                                                    .value[
                                                                'CustomerID'])
                                                            .collection(
                                                                'Orders')
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return SizedBox();
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'เกิดข้อผิดพลาด: ${snapshot.error}');
                                                          }
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Text(
                                                                'ไม่พบข้อมูล');
                                                          }
                                                          if (snapshot.data!
                                                              .docs.isEmpty) {
                                                            print(
                                                                snapshot.data);
                                                          }

                                                          // เก็บข้อมูลจาก Firestore ลงใน Map
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              customerOrderDataList =
                                                              [];
                                                          for (QueryDocumentSnapshot customerOrderDoc
                                                              in snapshot
                                                                  .data!.docs) {
                                                            Map<String, dynamic>
                                                                customerOrderData =
                                                                customerOrderDoc
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>;

                                                            customerOrderDataList
                                                                .add(
                                                                    customerOrderData);
                                                          }

                                                          // DateTime now = DateTime.now();
                                                          // DateTime previousMonth =
                                                          //     DateTime(now.year,
                                                          //         now.month - 1);

                                                          // List<Map<String, dynamic>>
                                                          //     filteredList =
                                                          //     customerOrderDataList
                                                          //         .where((order) {
                                                          //   DateTime orderUpdateTime =
                                                          //       order['OrdersUpdateTime']
                                                          //           .toDate();
                                                          //   return orderUpdateTime
                                                          //       .isBefore(
                                                          //           previousMonth);
                                                          // }).toList();

                                                          DateTime now =
                                                              DateTime.now();
                                                          DateTime
                                                              currentMonthStart =
                                                              DateTime(now.year,
                                                                  now.month, 1);

                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              filteredList =
                                                              customerOrderDataList
                                                                  .where(
                                                                      (order) {
                                                            DateTime
                                                                orderUpdateTime =
                                                                order['OrdersUpdateTime']
                                                                    .toDate();
                                                            return orderUpdateTime
                                                                .isAfter(
                                                                    currentMonthStart);
                                                          }).toList();

                                                          // จัดเรียง filteredList โดยให้รายการที่มีค่า 'date' มีวันที่ล่าสุดอยู่หน้าสุด
                                                          filteredList
                                                              .sort((a, b) {
                                                            DateTime dateA =
                                                                a['OrdersUpdateTime']
                                                                    .toDate();
                                                            DateTime dateB =
                                                                b['OrdersUpdateTime']
                                                                    .toDate();
                                                            return dateB
                                                                .compareTo(
                                                                    dateA);
                                                          });

                                                          print(filteredList);

                                                          // print(
                                                          //     customerOrderDataList.length);

                                                          // print(
                                                          //     filteredList.length);

                                                          double totalAmount =
                                                              filteredList.fold(
                                                                  0.0,
                                                                  (sum, order) {
                                                            // ทำการบวกยอดรวมของแต่ละ Order
                                                            double orderTotal =
                                                                (order['ยอดรวม']
                                                                        as num)
                                                                    .toDouble();
                                                            return sum +
                                                                orderTotal;
                                                          });

                                                          // print(
                                                          //     'ยอดรวมทั้งหมด: $totalAmount');

                                                          // print(customerRatingList[i]['data']
                                                          //     [
                                                          //     'เปรียบเทียบ']);
                                                          // print(customerRatingList[i]['data']
                                                          //     [
                                                          //     'ยอดขาย']);

                                                          // for (var element
                                                          //     in customerRatingList) {
                                                          //   print(element['data']['ยอดขาย']);
                                                          // }
                                                          return Column(
                                                            children: [
                                                              for (int i = 0;
                                                                  i <
                                                                      filteredList
                                                                          .length;
                                                                  i++)
                                                                Container(
                                                                  height: 20.0,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                100.0,
                                                                            child:
                                                                                VerticalDivider(
                                                                              width: 3.0,
                                                                              thickness: 1.0,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                3.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              customFormatThai(filteredList[i]['OrdersUpdateTime'].toDate()),
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    fontFamily: 'Kanit',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        NumberFormat('#,###').format(filteredList[i]!['ยอดรวม']).toString() +
                                                                            ' บาท',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .override(
                                                                              fontFamily: 'Kanit',
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            ],
                                                          );
                                                        }),
                                                  ].addToEnd(const SizedBox(
                                                      height: 10.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 0.0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                  //     child: Container(
                  //       width: double.infinity,
                  //       height: double.infinity,
                  //       decoration: const BoxDecoration(),
                  //       child: FlutterFlowGoogleMap(
                  //         controller: _model.googleMapsController,
                  //         onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                  //         initialLocation: _model.googleMapsCenter ??=
                  //             const LatLng(13.106061, -59.613158),
                  //         markerColor: GoogleMarkerColor.violet,
                  //         mapType: MapType.normal,
                  //         style: GoogleMapStyle.standard,
                  //         initialZoom: 14.0,
                  //         allowInteraction: true,
                  //         allowZoom: true,
                  //         showZoomControls: true,
                  //         showLocation: true,
                  //         showCompass: false,
                  //         showMapToolbar: false,
                  //         showTraffic: false,
                  //         centerMapOnMarkerTap: true,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  mapWidget(context),
                ],
              ),
            ),
          );
  }

  Align mapWidget(BuildContext context) {
    double mapZoom = 14.4746;
    bool loadMap = false;
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
        child: Stack(
          children: [
            StatefulBuilder(builder: (context, setStateMap) {
              return Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 500.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(0.0),
                  shape: BoxShape.rectangle,
                ),
                child: GoogleMap(
                  // onTap: (argument) async {
                  //   await mapDialog(resultList, null)
                  //       .whenComplete(() async {
                  //     if (mounted) {
                  //       setStateMap(
                  //         () {
                  //           loadMap = true;
                  //         },
                  //       );
                  //     }

                  //     print('After Dialog Map');
                  //     print(resultList[0]['Latitude']);
                  //     late double lat;
                  //     late double lot;

                  //     if (resultList[0]['Latitude'] == '' ||
                  //         resultList[0]['Longitude'] == '') {
                  //       for (int i = 0; i < resultList.length; i++) {
                  //         if (resultList[i]['Latitude'] != '' &&
                  //             resultList[i]['Longitude'] != '') {
                  //           lat = double.parse(resultList[i]['Latitude']);
                  //           lot =
                  //               double.parse(resultList[i]['Longitude']);
                  //           break;
                  //         } else {
                  //           lat = 13.7563309;
                  //           lot = 100.5017651;
                  //         }
                  //       }
                  //     } else {
                  //       lat = double.parse(resultList[0]['Latitude']);
                  //       lot = double.parse(resultList[0]['Longitude']);
                  //     }

                  //     print(lat);
                  //     print(lot);
                  //     _kGooglePlex = CameraPosition(
                  //       target: google_maps.LatLng(lat, lot),
                  //       zoom: 15,
                  //     );
                  //     markers.clear();

                  //     for (int i = 0; i < resultList.length; i++) {
                  //       if (resultList[i]['Latitude'] == '') {
                  //       } else {
                  //         double latIndex =
                  //             double.parse(resultList[i]['Latitude']);
                  //         double lotIndex =
                  //             double.parse(resultList[i]['Longitude']!);
                  //         print('hhhhhhhhhh');
                  //         print(resultList[i]['ID']);
                  //         // print(resultList[i]['Latitude']);
                  //         // print(resultList[i]['Longitude']);
                  //         print('hhhhhhhhhh');

                  //         markers.add(
                  //           Marker(
                  //             markerId: MarkerId(resultList[i]['ID']),
                  //             position: google_maps.LatLng(
                  //                 latIndex, lotIndex), // ตำแหน่ง
                  //             infoWindow: InfoWindow(
                  //               title:
                  //                   'จุดที่ ${i + 1}', // ชื่อของปักหมุด
                  //               snippet: resultList[i]['Latitude'],
                  //               onTap: () async {
                  //                 await mapDialog(
                  //                         resultList, resultList[i]['ID'])
                  //                     .whenComplete(() {
                  //                   print('6666');
                  //                   _mapKey = GlobalKey();
                  //                   print('7777');
                  //                   if (mounted) {
                  //                     setState(() {});
                  //                   }
                  //                   print('88888');
                  //                 });
                  //                 //     .whenComplete(() {
                  //                 //   setState(
                  //                 //     () {
                  //                 //       loadMap = true;
                  //                 //     },
                  //                 //   );

                  //                 //   return;

                  //                 // });
                  //               }, // คำอธิบายของปักหมุด
                  //             ),
                  //           ),
                  //         );
                  //         print('pppp');
                  //       }
                  //     }

                  //     _mapKey = GlobalKey();

                  //     print('after add map');
                  //     print(_kGooglePlex);
                  //     print(markers);

                  //     if (mounted) {
                  //       setStateMap(
                  //         () {
                  //           loadMap = false;
                  //         },
                  //       );
                  //     }
                  //   });
                  // },

                  key: _mapKey,
                  mapType: ui_maps.MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  markers: markers, // เพิ่มนี่
                  onMapCreated: (GoogleMapController controller) async {
                    mapController2.complete(controller);
                  },
                  onCameraMove: (CameraPosition position) {
                    mapZoom = position.zoom;
                  },
                ),
              );
            }),
            //=============================================================
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Padding(
            //     padding: EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 5.0),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           width: MediaQuery.sizeOf(context).width * 0.4,
            //           height: 25.0,
            //           decoration: BoxDecoration(
            //             color: FlutterFlowTheme.of(context).accent3,
            //             borderRadius: BorderRadius.circular(8.0),
            //           ),
            //           alignment: AlignmentDirectional(0.00, 0.00),
            //           child: Row(
            //             children: [
            //               Expanded(
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(top: 10.0),
            //                   child: TextFormField(
            //                     enabled: false,
            //                     // controller: _model
            //                     //     .textController18,
            //                     // focusNode: _model
            //                     //     .textFieldFocusNode18,
            //                     autofocus: false,
            //                     obscureText: false,
            //                     decoration: InputDecoration(
            //                       isDense: true,
            //                       labelStyle:
            //                           FlutterFlowTheme.of(context).labelMedium,
            //                       hintText: '        ค้นหาสถานที่',
            //                       hintStyle: FlutterFlowTheme.of(context)
            //                           .labelMedium
            //                           .override(
            //                             fontFamily: 'Kanit',
            //                             color: FlutterFlowTheme.of(context)
            //                                 .primaryText,
            //                           ),
            //                       enabledBorder: InputBorder.none,
            //                       focusedBorder: InputBorder.none,
            //                       errorBorder: InputBorder.none,
            //                       focusedErrorBorder: InputBorder.none,
            //                       // suffixIcon: Icon(
            //                       //   Icons.search_sharp,
            //                       // ),
            //                     ),
            //                     style: FlutterFlowTheme.of(context).bodyMedium,
            //                     textAlign: TextAlign.center,
            //                     // validator: _model
            //                     //     .textController18Validator
            //                     //     .asValidator(
            //                     //         context),
            //                   ),
            //                 ),
            //               ),
            //               Icon(
            //                 Icons.search_sharp,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
