import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/custom_text.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:m_food/a13_visit_customer_plan/a1303_visit_form.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class CheckInCompleteWidget extends StatefulWidget {
  final MapEntry<String, dynamic>? entry;
  const CheckInCompleteWidget({this.entry, super.key});

  @override
  _CheckInCompleteWidgetState createState() => _CheckInCompleteWidgetState();
}

class _CheckInCompleteWidgetState extends State<CheckInCompleteWidget> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? data;
  bool isLoading = false;

  Completer<GoogleMapController> mapController2 =
      Completer<GoogleMapController>();
  late CameraPosition _kGooglePlex;

  Set<Marker> markers = Set<Marker>();
  Set<Marker> markersDialog = Set<Marker>();

  Key _mapKey = GlobalKey();

  //======================================================================
  List<String> imageUrlForDelete = [];
  List<String> imageUrl = [];
  List<XFile?> imageFile = [];
  List<File>? image = [];
  List<Uint8List> imageUint8List = [];
  int imageLength = 0;
  Reference? ref;
  //======================================================================
  @override
  void initState() {
    // print(widget.entry!.value['VisitID']);
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
        // print(documentSnapshot.data());
      } else {
        print('Document not found');
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

  trySummit() async {
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState!.save();
      }
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      //================================= image ที่อยู่ ======================================

      List<String> listUrl = [];

      for (int i = 0; i < image!.length; i++) {
        String fileName =
            '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
        if (image![i].path.isEmpty) {
          // listUrl.add(imageUrl[i]);
        } else {
          ref = FirebaseStorage.instance
              .ref()
              .child('images')
              .child('Users')
              .child(widget.entry!.value['UserID'])
              .child(AppSettings.customerType == CustomerType.Test
                  ? 'CustomerTest'
                  : 'Customer')
              .child(widget.entry!.value['CustomerID'])
              .child(DateTime.now().month.toString())
              .child('${DateTime.now().day}/$fileName');

          await ref!.putFile(image![i]).whenComplete(
            () async {
              await ref!.getDownloadURL().then(
                (value) {
                  listUrl.add(value);
                },
              );
            },
          );
        }
      }

      await FirebaseFirestore.instance
          .collection('เข้าเยี่ยมลูกค้า')
          .doc(widget.entry!.value['VisitID'])
          .update({
        'สถานะ': true,
        'รูปภาพ': listUrl,
      }).then((value) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    } finally {
      print(widget.entry!.value['VisitID']);
      // resultList.clear();
    }
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
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
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                              ),
                            ],
                          ),
                          // Column(
                          //   mainAxisSize: MainAxisSize.max,
                          //   children: [
                          //     FFButtonWidget(
                          //       onPressed: () async {
                          //         Navigator.push(
                          //             context,
                          //             CupertinoPageRoute(
                          //               builder: (context) =>
                          //                   A1303VisitForm(entry: widget.entry),
                          //             )).then((value) {
                          //           setState(() {});
                          //           Navigator.pop(context);
                          //         });
                          //       },
                          //       text: 'แก้ไข',
                          //       options: FFButtonOptions(
                          //         height: 30.0,
                          //         padding: const EdgeInsetsDirectional.fromSTEB(
                          //             5.0, 0.0, 5.0, 0.0),
                          //         iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          //             0.0, 0.0, 0.0, 0.0),
                          //         color: FlutterFlowTheme.of(context).alternate,
                          //         textStyle: FlutterFlowTheme.of(context)
                          //             .bodyMedium
                          //             .override(
                          //               fontFamily: 'Kanit',
                          //               color: FlutterFlowTheme.of(context)
                          //                   .primaryBackground,
                          //             ),
                          //         elevation: 3.0,
                          //         borderSide: const BorderSide(
                          //           color: Colors.transparent,
                          //           width: 1.0,
                          //         ),
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'หัวข้อที่จะเข้าไปพบคือ ${widget.entry!.value['หัวข้อ']}',
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'รายละเอียดในการเข้าพบ : ${widget.entry!.value['รายละเอียด']}',
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
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 5.0, 0.0),
                                child: Icon(
                                  // FFIcons.kofficeBuildingMarkerOutline,
                                  Icons.pin_drop_outlined,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 50.0,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Check In',
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
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'กรุณาเช็คสัญญาอินเตอร์เน็ตก่อนการกดเช็คอินท์ทุกครั้ง',
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
                          Spacer(),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 5.0, 0.0),
                                child: Icon(
                                  // FFIcons.kofficeBuildingMarkerOutline,
                                  Icons.offline_pin_outlined,
                                  color: Colors.green.shade900,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    imageShopThreePlus(context),
                    SizedBox(
                      height: 20,
                    ),
                    // saveData(context),
                  ],
                ),
              ),
            ),
          );
  }

  Padding saveData(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: FFButtonWidget(
        onPressed: () async {
          // context.pushNamed('A15_01_ListVisitCustomerPlan');

          // if (edit) {
          //   if (textController5.text == '' ||
          //       textController4.text == '' ||
          //       textController3.text == '') {
          //     Fluttertoast.showToast(
          //       msg: "กรุณาเลือกวันเวลานัดหมายค่ะ",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.TOP,
          //       timeInSecForIosWeb: 4,
          //       backgroundColor: Colors.red.shade900,
          //       textColor: Colors.white,
          //       fontSize: 16.0,
          //     );

          //     return;
          //   } else if (customerID == '') {
          //     Fluttertoast.showToast(
          //       msg: "กรุณาเลือกลูกค้าในระบบค่ะ",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.TOP,
          //       timeInSecForIosWeb: 4,
          //       backgroundColor: Colors.red.shade900,
          //       textColor: Colors.white,
          //       fontSize: 16.0,
          //     );

          //     return;
          //   } else {
          //     trySummitUpdate();
          //   }
          // } else {
          //   if (textController5.text == '' ||
          //       textController4.text == '' ||
          //       textController3.text == '') {
          //     Fluttertoast.showToast(
          //       msg: "กรุณาเลือกวันเวลานัดหมายค่ะ",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.TOP,
          //       timeInSecForIosWeb: 4,
          //       backgroundColor: Colors.red.shade900,
          //       textColor: Colors.white,
          //       fontSize: 16.0,
          //     );

          //     return;
          // } else
          if (image!.length == 0) {
            Fluttertoast.showToast(
              msg: "กรุณาเพิ่มรูปภาพอย่างน้อง 1 รูปค่ะ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red.shade900,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            return;
          } else {
            trySummit();
          }
          // }

          // Navigator.pop(context);
        },
        text: 'บันทึกนัดหมายการเข้าพบ',
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 40.0,
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).secondary,
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Kanit',
                color: Colors.white,
              ),
          elevation: 3.0,
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
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

  Padding imageShopThreePlus(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 8.0, 5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.925,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent3,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 10.0, 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.63 +
                      //     (((MediaQuery.of(context).size.width * 0.63) / 4.5) *
                      //         (imageUrl.length - 2)),
                      height: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.entry!.value['รูปภาพ'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            showPreviewImage(index, 'network'),
                                        child: Image.network(
                                          widget.entry!.value['รูปภาพ'][index],
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.63) /
                                              4.5,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 20,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              '${index + 1}/${widget.entry!.value['รูปภาพ'].length}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  // fontSize: (lang ==
                                                  //         'my')
                                                  //     ? 10
                                                  //     : 10),
                                                  fontSize: 10),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Positioned(
                                      //   top: 4,
                                      //   right: 4,
                                      //   child: Container(
                                      //     width: 25,
                                      //     height: 25,
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       borderRadius:
                                      //           BorderRadius.circular(30),
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Colors.black
                                      //               .withOpacity(0.2),
                                      //           spreadRadius: 1,
                                      //           blurRadius: 1,
                                      //           offset: Offset(
                                      //             0,
                                      //             1,
                                      //           ), // changes position of shadow
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     child: GestureDetector(
                                      //       child: Icon(
                                      //         Icons.delete,
                                      //         size: 20,
                                      //         color: Colors.black,
                                      //       ),
                                      //       onTap: () {
                                      //         imageUint8List.removeAt(index);
                                      //         imageFile.removeAt(index);
                                      //         image!.removeAt(index);
                                      //         imageUrl.removeAt(index);
                                      //         imageLength = imageLength - 1;

                                      //         // imageListFile
                                      //         //     .removeAt(
                                      //         //         index);
                                      //         setState(() {});
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          for (int i = 6; i > imageUint8List.length; i--)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 5.0, 0.0),
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width * 0.63) /
                                        4.5,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: Icon(
                                  FFIcons.kimagePlus,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 40.0,
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: () {
                              // imageDialog();
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width * 0.63) /
                                      4.5,
                              height: 100.0,
                              decoration: BoxDecoration(
                                // color: FlutterFlowTheme
                                //         .of(context)
                                //     .primaryText,
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    maxRadius: 30,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      FFIcons.kimagePlus,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      size: 30.0,
                                    ),
                                  ),
                                  // Icon(
                                  //   Icons
                                  //       .photo_camera_outlined,
                                  //   size: 50,
                                  //   color: Colors
                                  //       .black45,
                                  // ),
                                  // Text(
                                  //   'เพิ่มรูปภาพเข้าระบบ',
                                  //   style:
                                  //       TextStyle(
                                  //     color: Colors
                                  //         .black45,
                                  //     fontSize: 9.6,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> imageDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            // title: Text('Dialog Title'),
            // content: Text('This is the dialog content.'),
            actionsPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                      child: Text(
                        "กรุณาเลือกรูปแบบของรูปภาพค่ะ",
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                    ),
                    const Divider(),
                    Container(
                      // color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          _pickImageCamera();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.025,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'กล้องถ่ายรูป',
                              style:
                                  FlutterFlowTheme.of(context).headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          _pickImageGallery();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.025,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'แกลลอรี่',
                              style:
                                  FlutterFlowTheme.of(context).headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // ปรับค่าตามต้องการ
                                ),
                              ),
                              side: MaterialStatePropertyAll(
                                BorderSide(
                                    color: Colors.red.shade300, width: 1),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: CustomText(
                              text: "   ยกเลิก   ",
                              size: MediaQuery.of(context).size.height * 0.15,
                              color: Colors.red.shade300,
                            )),
                        // TextButton(
                        //     style: ButtonStyle(
                        //       backgroundColor: MaterialStatePropertyAll(
                        //           Colors.blue.shade900),
                        //       // side: MaterialStatePropertyAll(
                        //       // BorderSide(
                        //       //     color: Colors.red.shade300, width: 1),
                        //       // ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.pop(context);
                        //     },
                        //     child: CustomText(
                        //       text: "   บันทึก   ",
                        //       size: MediaQuery.of(context).size.height * 0.15,
                        //       color: Colors.white,
                        //     )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  void _pickImageCamera() async {
    // //print('camera');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      maxWidth: 1000,
      source: ImageSource.camera, // ใช้กล้องถ่ายรูป
    );

    File imageFileCrop = File(pickedFile!.path);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFileCrop.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    //print(pickedFile!.path);
    if (pickedFile!.path.isNotEmpty) {
      //print('not empty');
      if (croppedFile != null) {
        Uint8List imageRead = await croppedFile.readAsBytes();

        if (imageUrl.length > imageLength) {
          //print('1a');
          imageUint8List[imageLength] = imageRead;
          //print(imageUint8List.length);
          //print('2a');
          imageFile[imageLength] = pickedFile;
          //print(imageFile.length);
          //print('3a');
          image![imageLength] = File(pickedFile.path);
          //print('4a');
          imageUrl[imageLength] = '';
          //print('aa');
          //print(imageLength);
          imageLength = imageLength + 1;
          //print('bb');
          //print(imageLength);
          //print(imageFile.length);
        } else {
          imageUint8List.add(imageRead);
          imageFile.add(pickedFile);

          // image!.add(File(pickedFile.path));
          XFile? pickedFileForFirebase = XFile(croppedFile.path);
          image!.add(File(pickedFileForFirebase.path));

          imageUrl.add('');
          imageLength = imageLength + 1;
          //print(imageLength);
          //print(imageFile.length);
        }

        setState(() {});
      }
      //print(imageUrl.length);
      //print(imageLength);

      // //print(imageRead);
    }
  }

  void _pickImageGallery() async {
    //print('gallery');
    final ImagePicker _picker = ImagePicker();
    List<XFile>? images = await _picker.pickMultiImage(maxWidth: 1000);

    if (images.isNotEmpty) {
      //print(images.length);
      for (var element in images) {
        Uint8List imageRead = await element.readAsBytes();

        if (imageUrl.length > imageLength) {
          //print('1b');
          imageUint8List[imageLength] = imageRead;
          //print('2b');
          imageFile[imageLength] = element;
          //print('3b');
          image![imageLength] = File(element.path);
          //print('4b');
          imageUrl[imageLength] = '';
          //print('aaa');
          //print(imageLength);
          imageLength = imageLength + 1;
          //print('bbb');
          //print(imageLength);
          //print(imageFile.length);
        } else {
          imageUint8List.add(imageRead);
          imageFile.add(element);
          image!.add(File(element.path));
          imageUrl.add('');
          imageLength = imageLength + 1;
          //print(imageLength);
          //print(imageFile.length);
        }

        setState(() {});
      }
    }
  }

  showPreviewImage(int index, String typeImage) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Container(
          child: Stack(
            children: [
              typeImage == 'network'
                  ? PhotoView(
                      // imageProvider: FileImage(images),
                      // imageProvider: MemoryImage(imageUint8List[index]),
                      imageProvider:
                          NetworkImage(widget.entry!.value['รูปภาพ'][index]),
                    )
                  : PhotoView(
                      // imageProvider: FileImage(images),
                      imageProvider: MemoryImage(imageUint8List[index]),
                      // imageProvider: NetworkImage('URL ของรูปภาพ'),
                    ),
              Positioned(
                right: 10,
                top: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
