import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:m_food/a13_visit_customer_plan/widget/form_visit_customer_plan_model.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/data_transfer_widget_no_user.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as google_maps;

import 'package:google_maps_flutter_platform_interface/src/types/ui.dart'
    as ui_maps;
import 'package:provider/provider.dart';

class FormVisitCustomerPlanWidget extends StatefulWidget {
  final MapEntry<String, dynamic>? entry;
  const FormVisitCustomerPlanWidget({this.entry, super.key});

  @override
  _FormVisitCustomerPlanWidgetState createState() =>
      _FormVisitCustomerPlanWidgetState();
}

class _FormVisitCustomerPlanWidgetState
    extends State<FormVisitCustomerPlanWidget> {
  final _formKey = GlobalKey<FormState>();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  final customerController = Get.find<CustomerController>();
  late FormVisitCustomerPlanModel _model;

  TextEditingController textController1 = TextEditingController();
  FocusNode textFieldFocusNode1 = FocusNode();
  TextEditingController textController2 = TextEditingController();
  FocusNode textFieldFocusNode2 = FocusNode();
  TextEditingController textController21 = TextEditingController();
  FocusNode textFieldFocusNode21 = FocusNode();
  TextEditingController textController22 = TextEditingController();
  FocusNode textFieldFocusNode22 = FocusNode();
  TextEditingController textController3 = TextEditingController();
  FocusNode textFieldFocusNode3 = FocusNode();
  TextEditingController textController4 = TextEditingController();
  FocusNode textFieldFocusNode4 = FocusNode();
  TextEditingController textController5 = TextEditingController();
  FocusNode textFieldFocusNode5 = FocusNode();
  TextEditingController textController51 = TextEditingController();
  FocusNode textFieldFocusNode51 = FocusNode();
  TextEditingController textController6 = TextEditingController();
  FocusNode textFieldFocusNode6 = FocusNode();

  bool isLoading = false;
  bool choose = false;

  Map<String, dynamic>? customerDataMap;
  List<Map<String, dynamic>> listOfMaps = [];

  List<String> nameAll = [];
  List<String> nameList = [];
  List<String> companyList = [];

  List<String> addressAll = [];
  List<String> latAll = [];
  List<String> lotAll = [];

  String lati = '';
  String loti = '';
  String customerID = '';

  DateTime dateBirthday = DateTime.now();
  late TimeOfDay selectedTime;

  Completer<GoogleMapController> mapController2 =
      Completer<GoogleMapController>();
  late CameraPosition _kGooglePlex;

  Set<Marker> markers = Set<Marker>();
  Set<Marker> markersDialog = Set<Marker>();

  Key _mapKey = GlobalKey();

  bool checkLatLot = false;

  bool edit = false;

  @override
  void initState() {
    _model = createModel(context, () => FormVisitCustomerPlanModel());

    loadData();
    super.initState();
  }

  @override
  void dispose() {
    mapController2.complete();
    super.dispose();
  }

  TimeOfDay? convertTimestampToTimeOfDay(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } else {
      return null;
    }
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    print('sdjfkkdfljdksnfbsdjfndsf');
    print(widget.entry);
    if (widget.entry != null) {
      print('1');

      edit = true;
      print('sdjfkkdfljdksnfbsdjfndsf');
      print(widget.entry);
      textController2 =
          TextEditingController(text: widget.entry!.value['ชื่อนามสกุล']);
      textController21 =
          TextEditingController(text: widget.entry!.value['หัวข้อ']);
      textController22 =
          TextEditingController(text: widget.entry!.value['รายละเอียด']);
      textController3 =
          TextEditingController(text: widget.entry!.value['วันนัดหมาย']);
      textController4 =
          TextEditingController(text: widget.entry!.value['เดือนนัดหมาย']);
      textController5 =
          TextEditingController(text: widget.entry!.value['ปีนัดหมาย']);

      textController6 =
          TextEditingController(text: widget.entry!.value['ชื่อนามสกุล']);
      print('11');

      selectedTime = convertTimestampToTimeOfDay(
          widget.entry!.value['วันเดือนปีนัดหมาย'])!;

      print('111');

      textController51.text =
          '${selectedTime.hour.toString()}:${selectedTime.minute.toString()} น.';

      customerID = widget.entry!.value['CustomerID'];

      Map<String, dynamic>? data;

      print('1111');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'CustomerTest'
              : 'Customer')
          .where('CustomerID', isEqualTo: widget.entry!.value['CustomerID'])
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        data = documentSnapshot.data() as Map<String, dynamic>;
      }
      print('11111');
      if (data!['ListCustomerAddress'] != null) {
        print('!= null');
      } else {
        print('null');
      }
      print(data!['ListCustomerAddress']);

      for (int i = 0; i < data!['ListCustomerAddress'].length; i++) {
        print(data['ListCustomerAddress'][i]['รหัสสาขา']);
        print(data['ListCustomerAddress'][i]['ชื่อสาขา']);
        print(data['ListCustomerAddress'][i]['HouseNumber']);
        print(data['ListCustomerAddress'][i]['VillageName']);
        print(data['ListCustomerAddress'][i]['Road']);
        print(data['ListCustomerAddress'][i]['SubDistrict']);
        print(data['ListCustomerAddress'][i]['District']);
        print(data['ListCustomerAddress'][i]['Province']);
        print(data['ListCustomerAddress'][i]['PostalCode']);
        print(data['ListCustomerAddress'][i]['ผู้ติดต่อ']);
        print(data['ListCustomerAddress'][i]['ตำแหน่ง']);
        print(data['ListCustomerAddress'][i]['โทรศัพท์']);

        String address =
            '${data['ListCustomerAddress'][i]['รหัสสาขา']} ${data['ListCustomerAddress'][i]['ชื่อสาขา']} ${data['ListCustomerAddress'][i]['HouseNumber']} ${data['ListCustomerAddress'][i]['VillageName']} ${data['ListCustomerAddress'][i]['Road']} ${data['ListCustomerAddress'][i]['SubDistrict']} ${data['ListCustomerAddress'][i]['District']} ${data['ListCustomerAddress'][i]['Province']} ${data['ListCustomerAddress'][i]['PostalCode']} ${data['ListCustomerAddress'][i]['ผู้ติดต่อ']} ${data['ListCustomerAddress'][i]['ตำแหน่ง']} ${data['ListCustomerAddress'][i]['โทรศัพท์']}'
                .trimLeft();
        String addressTrim = address.trimRight();

        print(addressTrim);
        addressAll.add(addressTrim);
        if (data['ListCustomerAddress'][i]['Latitude'] != null) {
          latAll.add(data['ListCustomerAddress'][i]['Latitude']);
          lotAll.add(data['ListCustomerAddress'][i]['Longitude']);
        }
      }
      print('111111');

      _model.dropDownValueController3Address =
          FormFieldController<String>(widget.entry!.value['ที่อยู่']);

      _model.dropDownValue3Address = widget.entry!.value['ที่อยู่'];

      print(widget.entry!.value['ที่อยู่']);

      if (widget.entry!.value['ละติจูด'] != '') {
        print('!= null');
        int index = latAll.indexOf(widget.entry!.value['ละติจูด']!);

        _model.dropDownValueController3 =
            FormFieldController<String>(addressAll[index]);

        _model.dropDownValue3 = addressAll[index];
        _kGooglePlex = CameraPosition(
          target: google_maps.LatLng(
              double.parse(widget.entry!.value['ละติจูด']),
              double.parse(widget.entry!.value['ลองติจูด'])),
          zoom: 14.4746,
        );

        markers.add(
          Marker(
            markerId: MarkerId('แผนที่'),
            position: google_maps.LatLng(
                double.parse(widget.entry!.value['ละติจูด']),
                double.parse(widget.entry!.value['ลองติจูด'])),
            infoWindow: InfoWindow(
              title: 'จุดที่ 1', // ชื่อของปักหมุด
              // snippet: resultList[i]['Latitude'],
            ),
          ),
        );
        lati = widget.entry!.value['ละติจูด'];
        loti = widget.entry!.value['ลองติจูด'];
        checkLatLot = true;
      } else {
        print('== null');

        checkLatLot = false;
        _kGooglePlex = CameraPosition(
          target: google_maps.LatLng(13.7563309, 100.5017651),
          zoom: 14.4746,
        );
      }

      // 'เวลานัดหมาย': '${selectedTime.hour} ${selectedTime.minute} น.',
      // 'ที่อยู่': _model.dropDownValue3Address,
      // 'ละติจูด': lati,
      // 'ลองติจูด': loti,
      // 'วันเดือนปีนัดหมาย': DateTime(
      //     int.parse(textController5.text),
      //     int.parse(textController4.text),
      //     int.parse(textController3.text),
      //     selectedTime.hour,
      //     selectedTime.minute),
      print('11');
    } else {
      print('2');

      selectedTime = TimeOfDay.now();

      _kGooglePlex = CameraPosition(
        target: google_maps.LatLng(13.7563309, 100.5017651),
        zoom: 14.4746,
      );

      print('333333333333333');

      print('22');
    }

    userData = userController.userData;

    await FirebaseFirestore.instance
        .collection(AppSettings.customerType == CustomerType.Test
            ? 'CustomerTest'
            : 'Customer')
        .where('รหัสพนักงานขาย', isEqualTo: userData!['EmployeeID'])
        .get()
        .then((QuerySnapshot<Map<String, dynamic>>? data) async {
      if (data != null && data.docs.isNotEmpty) {
        // แปลงข้อมูลจาก QuerySnapshot เป็น Map
        Map<String, dynamic> customerMap = {};
        //     data.docs.first.data() as Map<String, dynamic>;

        for (int index = 0; index < data.docs.length; index++) {
          final Map<String, dynamic> docData =
              data.docs[index].data() as Map<String, dynamic>;

          customerMap['key${index}'] = docData;
        }

        // Map<String, dynamic> filteredData = Map.fromEntries(
        //   customerMap.entries.where((entry) =>
        //       entry.value['สถานะ'] == true &&
        //       entry.value['บันทึกพร้อมตรวจ'] == false &&
        //       userData!['EmployeeID'] == entry.value['รหัสพนักงานขาย']),
        // );

        Map<String, dynamic> filteredData = Map.fromEntries(
          customerMap.entries.where((entry) {
            if (entry.value == null) {
              // print('null');
            } else {
              // print('not null');
            }
            if (userData == null) {
              // print('userData null');
            } else {
              // print('userData not null');
            }
            return entry.value != null &&
                entry.value['สถานะ'] == true &&
                entry.value['บันทึกพร้อมตรวจ'] == false &&
                userData != null &&
                userData!['EmployeeID'] == entry.value['รหัสพนักงานขาย'];
          }),
        );

        filteredData.forEach((key, value) {
          // customerDataMap![key] = value;
          listOfMaps.add(value);
          String valuePersonal = value['ชื่อนามสกุล'];
          String valueCompany = value['ชื่อบริษัท'];

          String trimmedLeft = valuePersonal.trimLeft();
          String trimmedLeftCompany = valueCompany.trimLeft();

// ใช้ trimRight() เพื่อตัดช่องว่างด้านหลัง
          String trimmedBoth = trimmedLeft.trimRight();
          String trimmedBothCompany = trimmedLeftCompany.trimRight();
          nameList.add(trimmedBoth);
          companyList.add(trimmedBothCompany);
          nameAll.add(trimmedBoth);
          nameAll.add(trimmedBothCompany);
        });
        customerDataMap = filteredData;

        nameAll.removeWhere((name) => name.trim().isEmpty);
        nameList.removeWhere((name) => name.trim().isEmpty);
        companyList.removeWhere((name) => name.trim().isEmpty);
      }
    });

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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

  // Future<void> selectDateToWork(BuildContext context) async {
  //   print('selectDateToSend');
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2101),
  //   );

  //   if (picked != null && picked != DateTime.now()) {
  //     setState(() {
  //       int year = picked.year + 543;
  //       _model.textController3.text = picked.day.toString();
  //       _model.textController4.text = picked.month.toString();
  //       _model.textController5.text = year.toString();
  //     });
  //   }
  // }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: selectedTime,
    );
    print(pickedTime);

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        print(selectedTime);
        textController51.text = selectedTime.format(context);
        print(textController51.text);
        // Do something with the selected time
        print('Selected Time: ${selectedTime.format(context)}');
      });
    }
  }

  //jak datepicker
  void selectDateToWork(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          DateTime _selectDate = dateBirthday;
          return Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: Theme.of(context).textTheme.titleMedium?.merge(
                              TextStyle(
                                  color: Colors.grey, fontFamily: 'Kanit')),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          textController3.text =
                              DateFormat('dd').format(_selectDate);
                          textController4.text =
                              DateFormat('MM').format(_selectDate); //budda
                          // textController5.text = (int.parse(
                          //             DateFormat('yyyy').format(_selectDate)) +
                          //         543)
                          textController5.text = (int.parse(
                                  DateFormat('yyyy').format(_selectDate)))
                              .toString();

                          dateBirthday = _selectDate;
                          // setState(() {

                          // });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ตกลง',
                          style: Theme.of(context).textTheme.titleMedium?.merge(
                              TextStyle(
                                  color: Colors.blueAccent,
                                  fontFamily: 'Kanit')),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 350,
                  child: ScrollDatePicker(
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        _selectDate = value;
                      });
                    },
                    minimumDate: DateTime(DateTime.now().year - 150,
                        DateTime.now().month, DateTime.now().day),
                    maximumDate: DateTime(DateTime.now().year + 10, 12, 31),
                    selectedDate: _selectDate,
                    locale: Locale('th'),
                    viewType: [
                      DatePickerViewType.day,
                      DatePickerViewType.month,
                      DatePickerViewType.year,
                    ],
                    scrollViewOptions: DatePickerScrollViewOptions(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      day: ScrollViewDetailOptions(
                        alignment: Alignment.centerRight,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        // margin: const EdgeInsets.only(right: 10),
                      ),
                      month: ScrollViewDetailOptions(
                        label: '  ',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          // fontFamily: 'Kanit',
                        ),
                        // margin: const EdgeInsets.only(right: 10),
                      ),
                      year: ScrollViewDetailOptions(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                        ),
                        // margin: const EdgeInsets.only(right: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  trySummitUpdate() async {
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

      //================================= Set to Firebase ======================================
      // for (int i = 0; i < 7; i++) {
      await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'เข้าเยี่ยมลูกค้าTest'
              : 'เข้าเยี่ยมลูกค้า')
          // .collection('เข้าเยี่ยมลูกค้า')
          .doc(widget.entry!.value['VisitID'])
          .update({
        'VisitID': widget.entry!.value['VisitID'],
        'ชื่อนามสกุล': textController2.text,
        // 'วันนัดหมาย': (int.parse(textController3.text) + i).toString(),
        'วันนัดหมาย': textController3.text,
        'เดือนนัดหมาย': textController4.text,
        'ปีนัดหมาย': textController5.text,
        'เวลานัดหมาย': '${selectedTime.hour} ${selectedTime.minute} น.',
        // 'เวลานัดหมาย':
        //     '${selectedTime.hour + i} ${selectedTime.minute + i} น.',

        'หัวข้อ': textController21.text,
        'ที่อยู่': _model.dropDownValue3Address,
        'รายละเอียด': textController22.text,
        'ละติจูด': lati,
        'ลองติจูด': loti,
        'UserID': userData!['UserID'],
        'CustomerID': customerID,
        'วันเดือนปีนัดหมาย': DateTime(
            int.parse(textController5.text),
            int.parse(textController4.text),
            int.parse(textController3.text),
            selectedTime.hour,
            selectedTime.minute),
        // 'วันเดือนปีนัดหมาย': DateTime(
        //     int.parse(textController5.text),
        //     int.parse(textController4.text),
        //     int.parse(textController3.text) + i,
        //     selectedTime.hour + i,
        //     selectedTime.minute + i),
        'สถานะ': widget.entry!.value['สถานะ'],
        'รูปภาพ': [],
      }).then((value) {});
      // }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print('erorrrrrr');
      print(e);
    } finally {
      // resultList.clear();
    }
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

      Uuid uuid = Uuid();

      //================================= Set to Firebase ======================================
      // for (int i = 0; i < 7; i++) {
      String docID = uuid.v4();
      print('trysummit');
      print(selectedTime.hour);
      await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'เข้าเยี่ยมลูกค้าTest'
              : 'เข้าเยี่ยมลูกค้า')
          // .collection('เข้าเยี่ยมลูกค้า')
          .doc(docID)
          .set({
        'VisitID': docID,
        'ชื่อนามสกุล': textController2.text == '' ? '' : textController2.text,
        // 'วันนัดหมาย': (int.parse(textController3.text) + i).toString(),
        'วันนัดหมาย': textController3.text == '' ? '' : textController3.text,
        'เดือนนัดหมาย': textController4.text == '' ? '' : textController4.text,
        'ปีนัดหมาย': textController5.text == '' ? '' : textController5.text,
        'เวลานัดหมาย': '${selectedTime.hour} ${selectedTime.minute} น.',
        // 'เวลานัดหมาย':
        //     '${selectedTime.hour + i} ${selectedTime.minute + i} น.',

        'หัวข้อ': textController21.text == '' ? '' : textController21.text,
        'ที่อยู่': _model.dropDownValue3Address == null
            ? ''
            : _model.dropDownValue3Address,
        'รายละเอียด': textController22.text == '' ? '' : textController22.text,
        'ละติจูด': lati,
        'ลองติจูด': loti,
        'UserID': userData!['UserID'],
        'CustomerID': customerID,
        'วันเดือนปีนัดหมาย': DateTime(
            int.parse(textController5.text),
            int.parse(textController4.text),
            int.parse(textController3.text),
            selectedTime.hour,
            selectedTime.minute),
        // 'วันเดือนปีนัดหมาย': DateTime(
        //     int.parse(textController5.text),
        //     int.parse(textController4.text),
        //     int.parse(textController3.text) + i,
        //     selectedTime.hour + i,
        //     selectedTime.minute + i),
        'สถานะ': false,
        'รูปภาพ': [],
      }).then((value) {});
      // }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print(e);
    } finally {
      // resultList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> filterCities(String search) {
      List<String> data =
          nameAll.where((name) => name.contains(search)).toList();

      print(data);

      return data;

      // return nameAll;
    }

//     List<String> filterCities(String search) {
//   return nameAll
//       .where((name) =>
//           name.toLowerCase().contains(search.toLowerCase()) ||
//           companyList[nameAll.indexOf(name)].toLowerCase().contains(search.toLowerCase()))
//       .toList();
// }

    return isLoading
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              CircularLoading(),
            ],
          ))
        : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchCustomer(context, filterCities),
                  const SizedBox(height: 5),
                  nameCustomer(context),
                  timeToVisit(context),
                  titleToVisit(context),
                  // dataApiCustomer(context),
                  addressDropdown(context),
                  detailToVisit(context),
                  addressToMap(context),
                  mapWidget(context),
                  // searchMap(context),
                  // Padding(
                  //   padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 400.0,
                  //     decoration: BoxDecoration(
                  //       color: FlutterFlowTheme.of(context).secondaryBackground,
                  //     ),
                  //     child: FlutterFlowGoogleMap(
                  //       controller: _model.googleMapsController,
                  //       onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                  //       initialLocation: _model.googleMapsCenter ??=
                  //           const LatLng(13.106061, -59.613158),
                  //       markerColor: GoogleMarkerColor.violet,
                  //       mapType: MapType.normal,
                  //       style: GoogleMapStyle.standard,
                  //       initialZoom: 14.0,
                  //       allowInteraction: true,
                  //       allowZoom: true,
                  //       showZoomControls: true,
                  //       showLocation: true,
                  //       showCompass: false,
                  //       showMapToolbar: false,
                  //       showTraffic: false,
                  //       centerMapOnMarkerTap: true,
                  //     ),
                  //   ),
                  // ),
                  saveData(context),
                ],
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

          if (edit) {
            if (textController5.text == '' ||
                textController4.text == '' ||
                textController3.text == '') {
              Fluttertoast.showToast(
                msg: "กรุณาเลือกวันเวลานัดหมายค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              return;
            } else if (customerID == '') {
              Fluttertoast.showToast(
                msg: "กรุณาเลือกลูกค้าในระบบค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              return;
            } else {
              trySummitUpdate();
            }
          } else {
            if (textController5.text == '' ||
                textController4.text == '' ||
                textController3.text == '') {
              Fluttertoast.showToast(
                msg: "กรุณาเลือกวันเวลานัดหมายค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              return;
            } else if (customerID == '') {
              Fluttertoast.showToast(
                msg: "กรุณาเลือกลูกค้าในระบบค่ะ",
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
          }

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
              return Stack(
                children: [
                  Container(
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
                  ),
                ],
              );
            }),
            //=============================================================
            checkLatLot
                ? SizedBox()
                : Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            height: 25.0,
                            decoration: BoxDecoration(
                              color: Colors.red.shade900,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Text('สถานที่คุณเลือกไม่มีพิกัดที่บันทึกไว้',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMediumWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> updateMap(List<String>? address, String? text) async {
    int index = address!.indexOf(text!);
    print('updateMap');

    if (latAll[index].isEmpty) {
      checkLatLot = false;
      _kGooglePlex = CameraPosition(
        target: google_maps.LatLng(13.7563309, 100.5017651),
        zoom: 14.4746,
      );
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('แผนที่'),
          position: google_maps.LatLng(13.7563309, 100.5017651), // ตำแหน่ง
          infoWindow: InfoWindow(
            title: 'จุดที่ 1', // ชื่อของปักหมุด
            // snippet: resultList[i]['Latitude'],
          ),
        ),
      );
      lati = '';
      loti = '';
      final GoogleMapController controller = await mapController2.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    } else {
      checkLatLot = true;
      lati = '';
      loti = '';
      print(text);
      print(index);
      print(latAll[index]);
      print(latAll);
      print(lotAll[index]);
      print(lotAll);
      _kGooglePlex = CameraPosition(
        target: google_maps.LatLng(
            double.parse(latAll[index]), double.parse(lotAll[index])),
        zoom: 15,
      );
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('แผนที่'),
          position: google_maps.LatLng(double.parse(latAll[index]),
              double.parse(lotAll[index])), // ตำแหน่ง
          infoWindow: InfoWindow(
            title: 'จุดที่ 1', // ชื่อของปักหมุด
            // snippet: resultList[i]['Latitude'],
          ),
        ),
      );
      lati = latAll[index];
      loti = lotAll[index];
      final GoogleMapController controller = await mapController2.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

      controller.dispose();
    }
  }

  Padding searchMap(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: Container(
        height: 30.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent3,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: const AlignmentDirectional(0.00, 0.00),
        child: TextFormField(
          controller: textController6,
          focusNode: textFieldFocusNode6,
          obscureText: false,
          decoration: InputDecoration(
            isDense: true,
            labelStyle: FlutterFlowTheme.of(context).labelMedium,
            hintText: 'ค้นหาสถานที่',
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Kanit',
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            suffixIcon: const Icon(
              Icons.search_sharp,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium,
          textAlign: TextAlign.center,
          // validator: textController6Validator.asValidator(context),
        ),
      ),
    );
  }

  Align addressToMap(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '  พิกัดในการเข้าพบ (ดึงจากในระบบ)',
                  style: FlutterFlowTheme.of(context).bodySmall,
                ),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            FlutterFlowDropDown<String>(
              controller: _model.dropDownValueController3 ??=
                  FormFieldController<String>(null),
              options: addressAll,
              onChanged: (val) async {
                setState(() {
                  _model.dropDownValue3 = val;
                });
                // print(val);

                await updateMap(addressAll, val);
              },
              height: 45.0,
              textStyle: FlutterFlowTheme.of(context).bodyMedium,
              hintText: 'พิกัดในการเข้าพบ (ดึงจากในระบบ)',
              icon: Icon(
                Icons.arrow_left_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
              elevation: 2.0,
              borderColor: FlutterFlowTheme.of(context).alternate,
              borderWidth: 2.0,
              borderRadius: 8.0,
              margin:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
              hidesUnderline: true,
              isSearchable: false,
              isMultiSelect: false,
            ),
          ],
        ),
      ),
    );
  }

  Padding detailToVisit(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: TextFormField(
        maxLines: 5,
        controller: textController22,
        focusNode: textFieldFocusNode22,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'รายละเอียดในการเข้าพบ',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'รายละเอียดในการเข้าพบ',
          hintStyle: FlutterFlowTheme.of(context).labelMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium,
        textAlign: TextAlign.start,
        // validator: textController2Validator.asValidator(context),
      ),
      // Container(
      //   width: double.infinity,
      //   height: 100.0,
      //   decoration: BoxDecoration(
      //     color: FlutterFlowTheme.of(context).secondaryBackground,
      //     borderRadius: BorderRadius.circular(15.0),
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
      //     child: Row(
      //       mainAxisSize: MainAxisSize.max,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'รายละเอียดในการเข้าพบ',
      //           style: FlutterFlowTheme.of(context).bodyMedium,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Padding addressDropdown(BuildContext context) {
    return
        //  Padding(
        //   padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
        //   child: Container(
        //     width: double.infinity,
        //     height: 100.0,
        //     decoration: BoxDecoration(
        //       color: FlutterFlowTheme.of(context).secondaryBackground,
        //       borderRadius: BorderRadius.circular(15.0),
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
        //       child: Row(
        //         mainAxisSize: MainAxisSize.max,
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             'ที่อยู่ (ดึงจากระบบในฐานข้อมูลลูกค้า)',
        //             style: FlutterFlowTheme.of(context).bodyMedium,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
        Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '  ที่อยู่ (ดึงจากในระบบ)',
                style: FlutterFlowTheme.of(context).bodySmall,
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          FlutterFlowDropDown<String>(
            controller: _model.dropDownValueController3Address ??=
                FormFieldController<String>(null),
            options: addressAll,
            onChanged: (val) =>
                setState(() => _model.dropDownValue3Address = val),
            height: 45.0,
            textStyle: FlutterFlowTheme.of(context).bodyMedium,
            hintText: 'ที่อยู่ (ดึงจากในระบบ)',
            icon: Icon(
              Icons.arrow_left_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: 8.0,
            margin: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
            hidesUnderline: true,
            isSearchable: false,
            isMultiSelect: false,
          ),
        ],
      ),
    );
  }

  Padding dataApiCustomer(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ดึงข้อมูลเครดิตของลูกค้าจาก API M Food',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Kanit',
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ที่ต้องการให้มาแสดงที่หน้านี้',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Kanit',
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Align titleToVisit(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
        child: TextFormField(
          controller: textController21,
          focusNode: textFieldFocusNode21,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'หัวข้อที่ต้องการเข้าไปพบ',
            isDense: true,
            labelStyle: FlutterFlowTheme.of(context).labelMedium,
            hintText: 'หัวข้อที่ต้องการเข้าไปพบ',
            hintStyle: FlutterFlowTheme.of(context).labelMedium,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium,
          textAlign: TextAlign.start,
          // validator: textController2Validator.asValidator(context),
        ),
        // FlutterFlowDropDown<String>(
        //   controller: _model.dropDownValueController2 ??=
        //       FormFieldController<String>(null),
        //   options: const [
        //     'หัวข้อ 1',
        //     'หัวข้อ 2',
        //     'หัวข้อ 3',
        //     'หัวข้อ 4',
        //     'หัวข้อ 5'
        //   ],
        //   onChanged: (val) => setState(() => _model.dropDownValue2 = val),
        //   height: 45.0,
        //   textStyle: FlutterFlowTheme.of(context).bodyMedium,
        //   hintText: 'หัวข้อที่ต้องการเข้าไปพบ',
        //   icon: Icon(
        //     Icons.arrow_left_outlined,
        //     color: FlutterFlowTheme.of(context).secondaryText,
        //     size: 24.0,
        //   ),
        //   elevation: 2.0,
        //   borderColor: FlutterFlowTheme.of(context).alternate,
        //   borderWidth: 2.0,
        //   borderRadius: 8.0,
        //   margin: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
        //   hidesUnderline: true,
        //   isSearchable: false,
        //   isMultiSelect: false,
        // ),
      ),
    );
  }

  Padding timeToVisit(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'วันเวลาที่จะเข้าพบ',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                readOnly: true,
                onTap: () async {
                  selectDateToWork(context);
                },
                controller: textController3,
                focusNode: textFieldFocusNode3,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintText: 'วันที่',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                textAlign: TextAlign.center,
                // validator: textController3Validator.asValidator(context),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                readOnly: true,
                onTap: () async {
                  selectDateToWork(context);
                },
                controller: textController4,
                focusNode: textFieldFocusNode4,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintText: 'เดือน',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                textAlign: TextAlign.center,
                // validator: textController4Validator.asValidator(context),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                onTap: () async {
                  selectDateToWork(context);
                },
                readOnly: true,

                controller: textController5,
                focusNode: textFieldFocusNode5,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintText: 'พ.ศ.',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                textAlign: TextAlign.center,
                // validator: textController5Validator.asValidator(context),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: TextFormField(
                onTap: () => selectTime(context),
                readOnly: true,

                controller: textController51,
                focusNode: textFieldFocusNode51,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintText: 'เวลา',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                textAlign: TextAlign.center,
                // validator: textController5Validator.asValidator(context),
              ),
              // FlutterFlowDropDown<String>(
              //   controller: _model.dropDownValueController1 ??=
              //       FormFieldController<String>(null),
              //   options: const ['Option 1', 'Option 2', 'Option 3'],
              //   onChanged: (val) => setState(() => _model.dropDownValue1 = val),
              //   width: 500.0,
              //   height: 45.0,
              //   textStyle: FlutterFlowTheme.of(context).bodyMedium,
              //   hintText: '00:00น',
              //   icon: Icon(
              //     Icons.arrow_left_sharp,
              //     color: FlutterFlowTheme.of(context).secondaryText,
              //     size: 24.0,
              //   ),
              //   elevation: 2.0,
              //   borderColor: FlutterFlowTheme.of(context).alternate,
              //   borderWidth: 2.0,
              //   borderRadius: 8.0,
              //   margin:
              //       const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
              //   hidesUnderline: true,
              //   isSearchable: false,
              //   isMultiSelect: false,
              // ),
            ),
          ),
        ],
      ),
    );
  }

  Padding nameCustomer(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        readOnly: true,
        controller: textController2,
        focusNode: textFieldFocusNode2,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อและนามสกุล',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ชื่อและนามสกุล',
          hintStyle: FlutterFlowTheme.of(context).labelMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium,
        textAlign: TextAlign.start,
        // validator: textController2Validator.asValidator(context),
      ),
    );
  }

  Padding searchCustomer(
      BuildContext context, List<String> filterCities(String search)) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent3,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 0.0),
                  child: StatefulBuilder(builder: (context, setState) {
                    return TypeAheadField(
                      suggestionsCallback: (search) {
                        print('ทำงาน');
                        return filterCities(search);
                      },
                      builder: (context, controller, focusNode) {
                        print('object');
                        print(controller.text);
                        // if (choose) {
                        //   controller.text = textController1.text;
                        // }

                        return TextFormField(
                          // initialValue: textController1.text,
                          onChanged: (value) {
                            // choose = false;
                            controller.text = value;
                            textController1.text = value;
                            setState(() {});
                            print(textController1.text);
                          },

                          style: FlutterFlowTheme.of(context).bodyMedium,
                          controller: choose ? textController1 : controller,
                          focusNode: focusNode,
                          autofocus: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'ค้นหาบัญชีลูกค้าในระบบ',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                        );
                      },
                      itemBuilder: (context, customerData) {
                        return ListTile(
                          title: Text(customerData),
                          subtitle: Text(customerData),
                        );
                      },
                      onSelected: (value) {
                        choose = true;
                        textController1.text = value;
                        setState(() {});
                        print(textController1.text);
                        // Navigator.of(context).push<void>(
                        //   MaterialPageRoute(
                        //     builder: (context) => CityPage(city: City.fromMap(city)),
                        //   ),
                        // );
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () async {
                  addressAll.clear();
                  latAll.clear();
                  lotAll.clear();
                  customerID = '';
                  print(textController1);
                  // print(listOfMaps);
                  // ค้นหา Map ที่มี field 'name' มีค่าเท่ากับ searchName
                  Map<String, dynamic>? foundMap = listOfMaps.firstWhere(
                    (map) =>
                        map['ชื่อนามสกุล'] == textController1.text ||
                        map['ชื่อบริษัท'] == textController1.text,
                    orElse: () => {},
                  );
                  if (foundMap != {}) {
                    print(foundMap);

                    print('null');

                    textController2.text = foundMap['ชื่อนามสกุล'] == ''
                        ? foundMap['ชื่อบริษัท']
                        : foundMap['ชื่อนามสกุล'];
                    for (int i = 0;
                        i < foundMap['ListCustomerAddress'].length;
                        i++) {
                      String address =
                          '${foundMap['ListCustomerAddress'][i]['รหัสสาขา']} ${foundMap['ListCustomerAddress'][i]['ชื่อสาขา']} ${foundMap['ListCustomerAddress'][i]['HouseNumber']} ${foundMap['ListCustomerAddress'][i]['VillageName']} ${foundMap['ListCustomerAddress'][i]['Road']} ${foundMap['ListCustomerAddress'][i]['SubDistrict']} ${foundMap['ListCustomerAddress'][i]['District']} ${foundMap['ListCustomerAddress'][i]['Province']} ${foundMap['ListCustomerAddress'][i]['PostalCode']} ${foundMap['ListCustomerAddress'][i]['ผู้ติดต่อ']} ${foundMap['ListCustomerAddress'][i]['ตำแหน่ง']} ${foundMap['ListCustomerAddress'][i]['โทรศัพท์']}'
                              .trimLeft();
                      String addressTrim = address.trimRight();
                      addressAll.add(addressTrim);
                      latAll
                          .add(foundMap['ListCustomerAddress'][i]['Latitude']);
                      lotAll
                          .add(foundMap['ListCustomerAddress'][i]['Longitude']);
                    }
                    customerID = foundMap['CustomerID'];
                    print(addressAll);

                    //======== เพิ่ม default ที่อยู่ ให้เป็น index 0 =============

                    if (addressAll.isNotEmpty) {
                      _model.dropDownValueController3Address =
                          FormFieldController<String>(addressAll[0]);

                      _model.dropDownValue3Address = addressAll[0];

                      _model.dropDownValueController3 =
                          FormFieldController<String>(addressAll[0]);
                      _model.dropDownValue3 = addressAll[0];

                      await updateMap(addressAll, _model.dropDownValue3);
                    }

                    setState(() {});
                  } else {
                    print(foundMap);

                    print('fff');
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 5.0, 0.0),
                      child: Icon(
                        Icons.add_circle,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                    Text(
                      'เพิ่มชื่อ',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
