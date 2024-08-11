import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:m_food/flutter_flow/flutter_flow_google_map.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';

class MapWidget extends StatefulWidget {
  final String? latitude;
  final String? longtitude;
  const MapWidget({super.key, this.latitude, this.longtitude});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Set<Marker> markers = Set<Marker>();
  google_maps.LatLng? latList;
  google_maps.LatLng? lotList;
  TextEditingController? searchMap = TextEditingController();
  Map<String, dynamic>? resultList = {};
  Completer<google_maps.GoogleMapController>? _mapController;
  GlobalKey? _mapKeyDialog = GlobalKey();
  google_maps.CameraPosition? _kGooglePlexDialog;

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    double mapZoom = 14.4746;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: 800.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(0.0),
                shape: BoxShape.rectangle,
              ),
              child: GoogleMap(
                key: _mapKeyDialog,
                onTap: (argument) async {
                  double lat = argument.latitude;
                  double lot = argument.longitude;

                  _kGooglePlexDialog = google_maps.CameraPosition(
                    target: google_maps.LatLng(lat, lot),
                    zoom: mapZoom,
                  );

                  markers.clear();

                  markers.add(
                    Marker(
                      markerId: MarkerId('Point'),
                      position: google_maps.LatLng(lat, lot),
                      infoWindow: InfoWindow(
                        title: 'จุดที่ ${1}',
                        snippet: 'สถานที่ที่คุณเลือก',
                        onTap: () {},
                      ),
                    ),
                  );

                  _mapKeyDialog = GlobalKey();
                  final google_maps.GoogleMapController controller =
                      await _mapController!.future;

                  controller.animateCamera(
                      google_maps.CameraUpdate.newCameraPosition(
                          _kGooglePlexDialog!));

                  if (mounted) {
                    setState(() {});
                  }
                },
                mapType: google_maps.MapType.hybrid,
                initialCameraPosition: _kGooglePlexDialog!,
                markers: markers,
                onMapCreated: (google_maps.GoogleMapController controller) {
                  _mapController!.complete(controller);
                },
                onCameraMove: (google_maps.CameraPosition position) {
                  mapZoom = position.zoom;
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 25.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent3,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: AlignmentDirectional(0.00, 0.00),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                controller: searchMap,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  hintText: '        ค้นหาสถานที่',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Kanit',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              print(searchMap!.text);
                              print('search button');
                              try {
                                List<Location> locations =
                                    await locationFromAddress(searchMap!.text);
                                print(searchMap!.text);

                                print(locations);

                                if (locations.isNotEmpty) {
                                  Location location = locations.first;
                                  print(
                                      'Latitude: ${location.latitude}, Longitude: ${location.longitude}');
                                  double lat = location.latitude;
                                  double lot = location.longitude;

                                  print(lat);
                                  print(lot);

                                  _kGooglePlexDialog =
                                      google_maps.CameraPosition(
                                    target: google_maps.LatLng(lat, lot),
                                    zoom: 14.4746,
                                  );
                                  markers.clear();
                                  markers.add(
                                    Marker(
                                      markerId: MarkerId('Point'),
                                      position: google_maps.LatLng(lat, lot),
                                      infoWindow: InfoWindow(
                                        title: 'จุดที่ 1',
                                        snippet: 'สถานที่ที่คุณเลือก',
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                  _mapKeyDialog = GlobalKey();

                                  final google_maps.GoogleMapController
                                      controller = await _mapController!.future;

                                  controller.animateCamera(google_maps
                                          .CameraUpdate
                                      .newCameraPosition(_kGooglePlexDialog!));

                                  if (mounted) {
                                    setState(() {});
                                  }
                                } else {
                                  print(
                                      'No location found for the given address');
                                }
                              } catch (e) {
                                print('Error: $e');
                                await Fluttertoast.showToast(
                                  msg:
                                      "   ไม่มีสถานที่นี้ค่ะ กรุณากรอกชื่อสถานที่ใหม่ค่ะ   ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
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
      ],
    );
  }
}
