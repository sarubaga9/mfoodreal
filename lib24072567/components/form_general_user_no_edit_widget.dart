import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_food/components/step_approve_widget.dart';
import 'package:m_food/controller/category_product_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/custom_text.dart';
import 'package:m_food/widgets/watermark_paint.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';
import '/components/signature_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'form_general_user_model.dart';
export 'form_general_user_model.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as google_maps;
import 'package:google_maps_flutter_platform_interface/src/types/ui.dart'
    as ui_maps;
import 'package:geocoding/geocoding.dart';

class FormGeneralUserNoEditWidget extends StatefulWidget {
  final Map<String, dynamic>? entryMap;
  final String? type;
  const FormGeneralUserNoEditWidget(
      {@required this.type, @required this.entryMap, Key? key})
      : super(key: key);

  @override
  _FormGeneralUserNoEditWidgetState createState() =>
      _FormGeneralUserNoEditWidgetState();
}

class _FormGeneralUserNoEditWidgetState
    extends State<FormGeneralUserNoEditWidget> {
  late FormGeneralUserModel _model;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  late CameraPosition _kGooglePlex;

  Set<Marker> markers = Set<Marker>();

  final _formKey = GlobalKey<FormState>();
  Key _mapKeyDialog = GlobalKey();
  Key _mapKey = GlobalKey();

  final Completer<GoogleMapController> _mapControllerDialog =
      Completer<GoogleMapController>();
  late CameraPosition _kGooglePlexDialog;

  Set<Marker> markersDialog = Set<Marker>();

  final categoryProductController = Get.find<CategoryProductController>();
  RxMap<String, dynamic>? categoryProduct;
  bool isLoading = false;
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;

  // @override
  // void setState(VoidCallback callback) {
  //   super.setState(callback);
  //   _model.onUpdate();
  // }
  //========================================================
  //============= สำหรับ dropdown รูปภาพที่ไว้อ้างอิงแก่่่สถานที่ร้านค้าท้งหมด =========
  bool checkSummit = false;
  List<FormFieldController<String>> dropDownControllersimageAddress = [];
  List<String> imageAddressAllForDropdown = [];

  //===================================================================
  //=====================================================
  // ตัวแปรเก็บ ชื่อของ กลุ่มสินค้า ทั้งหมด ในส่วนของ food
  List<String> categoryNameList = [];
  // ตัวแปร ไว้เก็บค่าจาก dropdown
  List<FormFieldController<String>> dropDownControllers = [];
  List<FormFieldController<String>> dropDownControllers2 = [];
  // ตัวแปรเก็บ ชื่อของ กลุ่มสินค้า ทั้งหมด ในส่วนของ food
  List<String?> dropDownValues = [];
  // ตัวแปรเก็บ ชื่อของ กลุ่มสินค้า ทั้งหมด ในส่วนของ food
  List<String?> dropDownValues2 = [];
  //ไว้ควบคุมจำนวน dropdown
  int total = 1; //จำนวนสินค้าที่ขายในปัจจุบัน
  int total2 = 1; //จำนวนกลุ่มสินค้าที่จะสั่งซื้อ

  int total3 = 1;
  List<Map<String, dynamic>> resultList = [];
  List<FocusNode?>? textFieldFocusHouseNumber = [];
  List<FocusNode?>? textFieldFocusVillageName = [];
  // List<String?>? textProvince = [];
  // List<String?>? textDistrict = [];
  // List<String?>? texSubDistrict = [];
  List<FocusNode?>? textFieldFocusPostalCode = [];
  List<FocusNode?>? textFieldFocusLatitude = [];
  List<FocusNode?>? textFieldFocusLongitude = [];

  // List<FormFieldController<String>> dropDownValueControllerProvince = [
  //   FormFieldController<String>('')
  // ];

  // List<FormFieldController<String>> dropDownValueControllerDistrict = [
  //   FormFieldController<String>('')
  // ];
  // List<FormFieldController<String>> dropDownValueControllerSubDistrict = [
  //   FormFieldController<String>('')
  // ];

  List<TextEditingController?>? latList = [];
  List<TextEditingController?>? lotList = [];

  List<String> addressAllForDropdown = [];

  int total4 = 1;

  List<Map<String, dynamic>> resultListSendAndBill = [];
  List<FormFieldController<String>> dropDownControllersSend = [];
  List<FormFieldController<String>> dropDownControllersBill = [];
  List<TextEditingController?>? sendAndBillList = [];

  List<FocusNode?>? textFieldFocusSendAndBill = [];

  //=====================================================

  //======================================================================
  List<String> imageUrlFromFirestore = [];
  List<String> imageUrlForDelete = [];
  List<String> imageUrl = [];
  List<XFile?> imageFile = [];
  List<File>? image = [];
  List<Uint8List> imageUint8List = [];
  int imageLength = 0;
  Reference? ref;
  //======================================================================

  //======================================================================
  List<String> imageUrlFromFirestore2 = [];
  List<String> imageUrlForDelete2 = [];
  List<String> imageUrl2 = [];
  List<XFile?> imageFile2 = [];
  List<File>? image2 = [];
  List<Uint8List> imageUint8List2 = [];
  int imageLength2 = 0;
  Reference? ref2;
  //======================================================================
  String imageSignFirestore = '';
  //=====================================================================
  ByteData _img = ByteData(0);
  // var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();
  //=====================================================================

  List<dynamic>? provinces = [];
  List<List<dynamic>>? amphures = [];
  List<List<dynamic>>? tambons = [];

  List<Map<String, dynamic>> selected = [
    // {
    // 'province_id': null,
    // 'amphure_id': null,
    // 'tambon_id': null,
    // }
  ];

  //=====================================================================
  bool checkStatusToEdit = false;
  bool checkStatusToButtonEdit = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormGeneralUserModel());

    loadData();
  }

  void loadData() async {
    try {
      setState(() {
        isLoading = true;
      });
      //=====================================================================

      print('fetchData');
      var response = await DefaultAssetBundle.of(context)
          .loadString('assets/thai_province_data.json.txt');
      var result = json.decode(response);
      provinces = result;
      provinces?.sort((a, b) {
        String nameA = a['name_th'];
        String nameB = b['name_th'];

        return nameA.compareTo(nameB);
      });

      if (widget.entryMap!['value']['ListCustomerAddress'].length == 0) {
        resultList.add({
          'HouseNumber': '',
          'VillageName': '',
          'Province': '',
          'District': '',
          'SubDistrict': '',
          'PostalCode': '',
          'Latitude': '',
          'Longitude': '',
          'Image': '',
        });

        selected.add({
          'province_id': null,
          'amphure_id': null,
          'tambon_id': null,
        });
        amphures!.add([]);
        tambons!.add([]);
        latList!.add(TextEditingController());
        lotList!.add(TextEditingController());
        textFieldFocusHouseNumber!.add(FocusNode());
        textFieldFocusVillageName!.add(FocusNode());
        textFieldFocusPostalCode!.add(FocusNode());
        textFieldFocusLatitude!.add(FocusNode());
        textFieldFocusLongitude!.add(FocusNode());
      } else {
        for (int i = 0;
            i < widget.entryMap!['value']['ListCustomerAddress'].length;
            i++) {
          resultList.add({
            'HouseNumber': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['HouseNumber'],
            'VillageName': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['VillageName'],
            'Province': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['Province'],
            'District': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['District'],
            'SubDistrict': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['SubDistrict'],
            'PostalCode': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['PostalCode'],
            'Latitude': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['Latitude'],
            'Longitude': widget.entryMap!['value']['ListCustomerAddress'][i]
                ['Longitude'],
          });
          List<dynamic>? childs;
          if (resultList[i]['Province'] == '') {
            amphures!.add([]);
          } else {
            Map<String, dynamic> parentAmphure = provinces!
                .firstWhere((item) => item['id'] == resultList[i]['Province']);
            childs = parentAmphure['amphure'];
            amphures!.add(childs!);
          }

          if (resultList[i]['District'] == '') {
            tambons!.add([]);
          } else {
            Map<String, dynamic> parentTambon = childs!
                .firstWhere((item) => item['id'] == resultList[i]['District']);

            List<dynamic> childsTambon = parentTambon['tambon'];
            tambons!.add(childsTambon);
          }

          selected.add({
            'province_id': resultList[i]['Province'] == ''
                ? ''
                : resultList[i]['Province'],
            'amphure_id': resultList[i]['District'] == ''
                ? ''
                : resultList[i]['District'],
            'tambon_id': resultList[i]['SubDistrict'] == ''
                ? ''
                : resultList[i]['SubDistrict'],
          });

          textFieldFocusHouseNumber!.add(FocusNode());
          textFieldFocusVillageName!.add(FocusNode());
          textFieldFocusPostalCode!.add(FocusNode());
          textFieldFocusLatitude!.add(FocusNode());
          textFieldFocusLongitude!.add(FocusNode());

          // dropDownValueControllerProvince.add(FormFieldController<String>(''));
          // dropDownValueControllerDistrict.add(FormFieldController<String>(''));
          // dropDownValueControllerSubDistrict.add(FormFieldController<String>(''));

          latList!.add(TextEditingController(text: resultList[i]['Latitude']));
          lotList!.add(TextEditingController(text: resultList[i]['Longitude']));
        }
        total3 = resultList.length;
      }

      categoryProduct = categoryProductController.categoryProductsData;

      for (int i = 0; i < categoryProduct!['key0']['food'].length; i++) {
        categoryNameList
            .add(categoryProduct!['key0']['food'][i]['NameCategory']);
      }

      for (int i = 0;
          i < widget.entryMap!['value']['CategoryProductNow'].length;
          i++) {
        if (widget.entryMap!['value']['CategoryProductNow'][i] == null ||
            widget.entryMap!['value']['CategoryProductNow'][i] == '') {
        } else {
          dropDownControllers.add(FormFieldController<String>(
              widget.entryMap!['value']['CategoryProductNow'][i]));
          dropDownValues
              .add(widget.entryMap!['value']['CategoryProductNow'][i]);
        }
      }
      if (dropDownControllers.isEmpty) {
        dropDownControllers.add(FormFieldController<String>(null));
        dropDownValues.add('');
      } else {
        total = dropDownControllers.length;
      }

      for (int i = 0;
          i < widget.entryMap!['value']['CategoryProductOrder'].length;
          i++) {
        if (widget.entryMap!['value']['CategoryProductOrder'][i] == null ||
            widget.entryMap!['value']['CategoryProductOrder'][i] == '') {
        } else {
          dropDownControllers2.add(FormFieldController<String>(
              widget.entryMap!['value']['CategoryProductOrder'][i]));
          dropDownValues2
              .add(widget.entryMap!['value']['CategoryProductOrder'][i]);
        }
      }

      if (dropDownControllers2.isEmpty) {
        dropDownControllers2.add(FormFieldController<String>(null));
        dropDownValues2.add('');
      } else {
        total2 = dropDownControllers2.length;
      }

      //=====================================================================
      _model.dropDownValueController6 ??=
          FormFieldController<String>(widget.entryMap!['value']['ตารางราคา']);
      _model.dropDownValue6 = widget.entryMap!['value']['ตารางราคา'] ?? '';

      // _model.dropDownValueController7 ??=
      //     FormFieldController<String>(widget.entryMap!['value']['ที่อยู่จัดส่ง']);
      // _model.dropDownValue7 = widget.entryMap!['value']['ที่อยู่จัดส่ง'];

      // _model.dropDownValueController8 ??=
      //     FormFieldController<String>(widget.entryMap!['value']['ตารางราคา']);
      // _model.dropDownValue8 = widget.entryMap!['value']['ที่อยู่ออกบิล'];

      // _model.dropDownValueController9 ??=
      //     FormFieldController<String>(widget.entryMap!['value']['ตารางราคา']);
      // _model.dropDownValue9 = widget.entryMap!['value']['ที่อยู่อื่น'];

      _model.dropDownValueController10 ??= FormFieldController<String>(
          widget.entryMap!['value']['ระยะเวลาชำระหนี้']);
      _model.dropDownValue10 =
          widget.entryMap!['value']['ระยะเวลาชำระหนี้'] ?? '';

      _model.dropDownValueController11 ??=
          FormFieldController<String>(widget.entryMap!['value']['ประเภทชำระ']);
      _model.dropDownValue11 = widget.entryMap!['value']['ประเภทชำระ'] ?? '';

      _model.dropDownValueController12 ??= FormFieldController<String>(
          widget.entryMap!['value']['เงื่อนไขชำระ']);
      _model.dropDownValue12 = widget.entryMap!['value']['เงื่อนไขชำระ'] ?? '';

      _model.dropDownValueController13 ??= FormFieldController<String>(
          widget.entryMap!['value']['บัญชีธนาคารของบริษัท']);
      _model.dropDownValue13 =
          widget.entryMap!['value']['บัญชีธนาคารของบริษัท'] ?? '';

      _model.dropDownValueController14 ??=
          FormFieldController<String>(widget.entryMap!['value']['แผนก']);
      _model.dropDownValue14 = widget.entryMap!['value']['แผนก'] ?? '';

      _model.dropDownValueController15 ??=
          FormFieldController<String>(widget.entryMap!['value']['รหัสบัญชี']);
      _model.dropDownValue15 = widget.entryMap!['value']['รหัสบัญชี'] ?? '';

      _model.dropDownValueController16 ??= FormFieldController<String>(
          widget.entryMap!['value']['รหัสพนักงานขาย']);
      _model.dropDownValue16 =
          widget.entryMap!['value']['รหัสพนักงานขาย'] ?? '';

      _model.dropDownValueController17 ??= FormFieldController<String>(
          widget.entryMap!['value']['ชื่อพนักงานขาย']);
      _model.dropDownValue17 =
          widget.entryMap!['value']['ชื่อพนักงานขาย'] ?? '';

      _model.dropDownValueController18 ??= FormFieldController<String>(
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า']);
      _model.dropDownValue18 =
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า'] ?? '';

      _model.dropDownValueController19 ??=
          FormFieldController<String>(widget.entryMap!['value']['รหัสบัญชี2']);
      _model.dropDownValue19 = widget.entryMap!['value']['รหัสบัญชี2'] ?? '';
      //=====================================================================
      _model.radioButtonValueController ??=
          FormFieldController<String>(widget.entryMap!['value']['คำนำหน้า']);
      //=====================================================================
      _model.textController1 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อนามสกุล']);
      _model.textFieldFocusNode1 ??= FocusNode();

      _model.textController2 ??=
          TextEditingController(text: widget.entryMap!['value']['วันเกิด']);
      _model.textFieldFocusNode2 ??= FocusNode();

      _model.textController3 ??=
          TextEditingController(text: widget.entryMap!['value']['เดือนเกิด']);
      _model.textFieldFocusNode3 ??= FocusNode();

      _model.textController4 ??=
          TextEditingController(text: widget.entryMap!['value']['ปีเกิด']);
      _model.textFieldFocusNode4 ??= FocusNode();

      _model.textController5 ??= TextEditingController(
          text: widget.entryMap!['value']['เลขบัตรประชาชน']);
      _model.textFieldFocusNode5 ??= FocusNode();

      _model.textController6 ??=
          TextEditingController(text: widget.entryMap!['value']['PhoneNumber']);
      _model.textFieldFocusNode6 ??= FocusNode();

      _model.textController7 ??= TextEditingController(
          text: widget.entryMap!['value']['วันเริ่มจัดส่ง']);
      _model.textFieldFocusNode7 ??= FocusNode();

      _model.textController8 ??= TextEditingController(
          text: widget.entryMap!['value']['เดือนเริ่มจัดส่ง']);
      _model.textFieldFocusNode8 ??= FocusNode();

      _model.textController9 ??= TextEditingController(
          text: widget.entryMap!['value']['ปีเริ่มจัดส่ง']);
      _model.textFieldFocusNode9 ??= FocusNode();

      _model.textController10 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อร้านค้า']);
      _model.textFieldFocusNode10 ??= FocusNode();

      _model.textController11 ??= TextEditingController(
          text: widget.entryMap!['value']['เป้าหมายยอดขาย']);
      _model.textFieldFocusNode11 ??= FocusNode();

      _model.textController12 ??=
          TextEditingController(text: widget.entryMap!['value']['วันสิ้นสุด']);
      _model.textFieldFocusNode12 ??= FocusNode();

      _model.textController13 ??= TextEditingController(
          text: widget.entryMap!['value']['เดือนสิ้นสุด']);
      _model.textFieldFocusNode13 ??= FocusNode();

      _model.textController14 ??=
          TextEditingController(text: widget.entryMap!['value']['ปีสิ้นสุด']);
      _model.textFieldFocusNode14 ??= FocusNode();

      //=====================================================================

      _model.textController15 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อนามสกุล']);
      _model.textFieldFocusNode15 ??= FocusNode();

      _model.textController16 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อนามสกุล']);
      _model.textFieldFocusNode16 ??= FocusNode();

      _model.textController17 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อนามสกุล']);
      _model.textFieldFocusNode17 ??= FocusNode();

      _model.textController171 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อนามสกุล']);
      _model.textFieldFocusNode171 ??= FocusNode();
      _model.textController172 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อนามสกุล']);
      _model.textFieldFocusNode172 ??= FocusNode();
      //=====================================================================
      //ค้นหาสถานที่ของ map
      _model.textController18 ??= TextEditingController();
      _model.textFieldFocusNode18 ??= FocusNode();
      //=====================================================================
      _model.textController19 ??= TextEditingController(
          text: widget.entryMap!['value']['วงเงินเครดิต']);
      _model.textFieldFocusNode19 ??= FocusNode();

      _model.textController20 ??=
          TextEditingController(text: widget.entryMap!['value']['ส่วนลดบิล']);
      _model.textFieldFocusNode20 ??= FocusNode();

      _model.textController1Company ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อบริษัท']);
      _model.textFieldFocusNode1Company ??= FocusNode();
      _model.textController2Company ??=
          TextEditingController(text: widget.entryMap!['value']['วันจัดตั้ง']);
      _model.textFieldFocusNode2Company ??= FocusNode();
      _model.textController3Company ??= TextEditingController(
          text: widget.entryMap!['value']['เดือนจัดตั้ง']);
      _model.textFieldFocusNode3Company ??= FocusNode();
      _model.textController4Company ??=
          TextEditingController(text: widget.entryMap!['value']['ปีจัดตั้ง']);
      _model.textFieldFocusNode4Company ??= FocusNode();
      _model.textController41Company ??= TextEditingController(
          text: widget.entryMap!['value']['เลขประจำตัวผู้เสียภาษี']);
      _model.textFieldFocusNode41Company ??= FocusNode();
      _model.textController5Company ??= TextEditingController(
          text: widget.entryMap!['value']['ทุนจดทะเบียน']);
      _model.textFieldFocusNode5Company ??= FocusNode();

      imageSignFirestore = widget.entryMap!['value']['ลายเซ็น'];

      widget.entryMap!['value']['สถานะ'] == true
          ? checkStatusToButtonEdit = true
          : widget.entryMap!['value']['สถานะ'] == false &&
                  widget.entryMap!['value']['บันทึกพร้อมตรวจ'] == false
              ? checkStatusToButtonEdit = true
              : checkStatusToButtonEdit = false;

      widget.entryMap!['value']['บันทึกพร้อมตรวจ'] == true
          ? checkStatusToEdit = true
          : checkStatusToEdit = false;
      //================================================================

      // resultListSendAndBill.add({
      //   'ที่อยู่จัดส่ง': '',
      //   'ชื่อออกบิล': '',
      //   'ที่อยู่ออกบิล': '',
      // });

      if (widget.entryMap!['value']['ลิสต์จัดส่งและออกบิล'].length == 0) {
        resultListSendAndBill.add({
          'ที่อยู่จัดส่ง': '',
          'ชื่อออกบิล': '',
          'ที่อยู่ออกบิล': '',
        });

        dropDownControllersSend.add(FormFieldController<String>(''));
        dropDownControllersBill.add(FormFieldController<String>(''));

        sendAndBillList!.add(TextEditingController());

        textFieldFocusSendAndBill!.add(FocusNode());
      } else {
        for (int i = 0;
            i < widget.entryMap!['value']['ลิสต์จัดส่งและออกบิล'].length;
            i++) {
          resultListSendAndBill.add({
            'ที่อยู่จัดส่ง': widget.entryMap!['value']['ลิสต์จัดส่งและออกบิล']
                [i]['ที่อยู่จัดส่ง'],
            'ชื่อออกบิล': widget.entryMap!['value']['ลิสต์จัดส่งและออกบิล'][i]
                ['ชื่อออกบิล'],
            'ที่อยู่ออกบิล': widget.entryMap!['value']['ลิสต์จัดส่งและออกบิล']
                [i]['ที่อยู่ออกบิล'],
          });

          dropDownControllersSend.add(FormFieldController<String>(
              resultListSendAndBill[i]['ที่อยู่จัดส่ง']));
          dropDownControllersBill.add(FormFieldController<String>(
              resultListSendAndBill[i]['ที่อยู่ออกบิล']));

          sendAndBillList!.add(TextEditingController(
              text: resultListSendAndBill[i]['ชื่อออกบิล']));

          textFieldFocusSendAndBill!.add(FocusNode());
        }
        total4 = resultListSendAndBill.length;
      }
      //================================================================

      imageLength = widget.entryMap!['value']['รูปร้านค้า'].length;

      for (var element in widget.entryMap!['value']['รูปร้านค้า']) {
        imageUrlFromFirestore.add(element);
        imageUrlForDelete.add(element);
        imageUrl.add(element);
        imageFile.add(null);
        image!.add(File(''));
        imageUint8List.add(Uint8List(0));
      }

      imageLength2 = widget.entryMap!['value']['รูปเอกสาร'].length;
      for (var element in widget.entryMap!['value']['รูปเอกสาร']) {
        imageUrlFromFirestore2.add(element);
        imageUrlForDelete2.add(element);
        imageUrl2.add(element);
        imageFile2.add(null);
        image2!.add(File(''));
        imageUint8List2.add(Uint8List(0));
      }
      //================================================================
      _kGooglePlex = CameraPosition(
        target: google_maps.LatLng(13.7563309, 100.5017651),
        zoom: 14.4746,
      );

      markers.add(
        Marker(
          markerId: MarkerId("your_marker_id"),
          position: google_maps.LatLng(13.7563309, 100.5017651), // ตำแหน่ง
          infoWindow: InfoWindow(
            title: "", // ชื่อของปักหมุด
            // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
          ),
        ),
      );

      _kGooglePlexDialog = CameraPosition(
        target: google_maps.LatLng(13.7563309, 100.5017651),
        zoom: 14.4746,
      );

      markersDialog.add(
        Marker(
          markerId: MarkerId("your_marker_id"),
          position: google_maps.LatLng(13.7563309, 100.5017651), // ตำแหน่ง
          infoWindow: InfoWindow(
            title: "", // ชื่อของปักหมุด
            // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
          ),
        ),
      );
      //====================================================================
      List<Map<String, dynamic>> addressThai = [];

      // List<String?>? textList = [];

      for (int i = 0; i < resultList.length; i++) {
        // resultList.add(false);

        List<Map<String, dynamic>> mapProvincesList =
            provinces!.cast<Map<String, dynamic>>();

        List<Map<String, dynamic>> mapList =
            amphures![i].cast<Map<String, dynamic>>();
        List<Map<String, dynamic>> tambonList =
            tambons![i].cast<Map<String, dynamic>>();
        String? provincesName;
        String? amphorName;
        String? tambonName;

        //====================================================================
        if (resultList[i]['Province'] == '' ||
            resultList[i]['Province'] == null) {
          provincesName = '';
        } else {
          Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
              (element) => element['id'] == resultList[i]['Province'],
              orElse: () => {});

          provincesName = resultProvince['name_th'] ?? '';
        }
        //====================================================================
        if (resultList[i]['District'] == '' ||
            resultList[i]['District'] == null) {
          amphorName = '';
        } else {
          Map<String, dynamic> resultAmphure = mapList.firstWhere(
              (element) => element['id'] == resultList[i]['District'],
              orElse: () => {});

          amphorName = resultAmphure['name_th'] ?? '';
        }

        //====================================================================
        if (resultList[i]['SubDistrict'] == '' ||
            resultList[i]['SubDistrict'] == null) {
          tambonName = '';
        } else {
          Map<String, dynamic> resultTambon = tambonList.firstWhere(
              (element) => element['id'] == resultList[i]['SubDistrict'],
              orElse: () => {});
          tambonName = resultTambon['name_th'] ?? '';
        }
        //====================================================================
        addressThai.add({
          'province_name':
              provincesName! == '' ? provincesName : 'จ.' + provincesName,
          'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
          'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
        });

        String texttt =
            '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

        // textList[i]!.add(text.trimLeft());
        addressAllForDropdown.add(texttt.trimLeft());
      }

      // dropDownValues =
      //     List.filled(categoryProduct!['key0']['food'].length, null);
      // dropDownValues2 =
      //     List.filled(categoryProduct!['key0']['food'].length, null);

      // Replace the URL with the actual URL of your JSON data.

      // Replace the URL with the actual URL of your JSON data.
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // _model.maybeDispose();

    super.dispose();
  }

  void setAmphures(List<dynamic>? newAmphures, int index) {
    setState(() {
      amphures![index] = newAmphures!;
    });
  }

  void setTambons(List<dynamic>? newTambons, int index) {
    setState(() {
      tambons![index] = newTambons!;
    });
  }

  Widget dropdownList({
    String? label,
    String? id,
    List<dynamic>? list,
    String? child,
    List<String>? childsId,
    List<Function(List<dynamic>?, int)>? setChilds,
    int? index,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      void onChangeHandle(String? selectedValue) {
        setChilds == null
            ? null
            : setChilds!.forEach((setChild) => setChild([], index!));
        Map<String, dynamic> unSelectChilds;
        setChilds == null
            ? unSelectChilds = {}
            : unSelectChilds = Map.fromIterable(childsId!,
                key: (item) => item, value: (item) => null);
        int? dependId =
            selectedValue!.isNotEmpty ? int.parse(selectedValue) : null;
        setState(() {
          selected[index!] = {
            ...selected[index],
            ...unSelectChilds,
            id!: dependId,
          };
        });

        if (selectedValue.isEmpty) return;

        if (child != null) {
          Map<String, dynamic> parent =
              list!.firstWhere((item) => item['id'] == dependId);
          List<dynamic> childs = parent[child];
          setChilds!.first(childs, index!);
        }

        label == 'Province: '
            ? resultList[index!]['Province'] = selected[index]['province_id']
            : label == 'District: '
                ? resultList[index!]['District'] = selected[index]['amphure_id']
                : resultList[index!]['SubDistrict'] =
                    selected[index]['tambon_id'];

        addressAllForDropdown.clear();

        setState(() {
          // for (int i = 0; i < resultList.length; i++) {
          //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
          //   String combinedFields = resultList[i].values.join(' ');

          //   // นำ string ไปแทนที่ใน list options
          //   addressAllForDropdown.add('$combinedFields');
          // }
          List<Map<String, dynamic>> addressThai = [];

          // List<String?>? textList = [];
          for (int i = 0; i < resultList.length; i++) {
            // resultList.add(false);

            List<Map<String, dynamic>> mapProvincesList =
                provinces!.cast<Map<String, dynamic>>();

            List<Map<String, dynamic>> mapList =
                amphures![i].cast<Map<String, dynamic>>();
            List<Map<String, dynamic>> tambonList =
                tambons![i].cast<Map<String, dynamic>>();
            String? provincesName;
            String? amphorName;
            String? tambonName;

//====================================================================
            if (resultList[i]['Province'] == '' ||
                resultList[i]['Province'] == null) {
              provincesName = '';
            } else {
              Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
                  (element) => element['id'] == resultList[i]['Province'],
                  orElse: () => {});

              provincesName = resultProvince['name_th'] ?? '';
            }
//====================================================================
            if (resultList[i]['District'] == '' ||
                resultList[i]['District'] == null) {
              amphorName = '';
            } else {
              Map<String, dynamic> resultAmphure = mapList.firstWhere(
                  (element) => element['id'] == resultList[i]['District'],
                  orElse: () => {});

              amphorName = resultAmphure['name_th'] ?? '';
            }

            //====================================================================
            if (resultList[i]['SubDistrict'] == '' ||
                resultList[i]['SubDistrict'] == null) {
              tambonName = '';
            } else {
              Map<String, dynamic> resultTambon = tambonList.firstWhere(
                  (element) => element['id'] == resultList[i]['SubDistrict'],
                  orElse: () => {});
              tambonName = resultTambon['name_th'] ?? '';
            }
            //====================================================================
            addressThai.add({
              'province_name':
                  provincesName! == '' ? provincesName : 'จ.' + provincesName,
              'amphure_name':
                  amphorName! == '' ? amphorName : 'อ.' + amphorName,
              'tambon_name':
                  tambonName! == '' ? tambonName : 'ต.' + provincesName,
            });

            String texttt =
                '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

            // textList[i]!.add(text.trimLeft());
            addressAllForDropdown.add(texttt.trimLeft());
          }
        });

        toSetState();
      }

      return Row(
        children: [
          Expanded(
            child: Container(
              height: 55.0,
              decoration: BoxDecoration(
                border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate, width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                // color: Colors.red,
                margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  // dropdownColor: Colors.blue,

                  icon: Icon(
                    Icons.arrow_left_outlined,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                  hint: Text(
                    label == 'Province: '
                        ? 'จังหวัด'
                        : label == 'District: '
                            ? 'อำเภอ'
                            : 'ตำบล',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  underline: Container(),
                  elevation: 2,
                  value: selected[index!][id]?.toString(),
                  onChanged: onChangeHandle,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        label == 'Province: '
                            ? 'จังหวัด'
                            : label == 'District: '
                                ? 'อำเภอ'
                                : 'ตำบล',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                    for (var item in list!)
                      DropdownMenuItem(
                        value: item['id'].toString(),
                        child: Text(
                          '${item['name_th']} - ${item['name_en']}',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  trySummit(bool checkButtonSuccess) async {
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

      // final sign = _sign.currentState;
      // //retrieve image data, do whatever you want with it (send to server, save locally...)
      // final imageSign = await sign!.getData();
      // var data = await imageSign.toByteData(format: ui.ImageByteFormat.png);
      // final encoded = base64.encode(data!.buffer.asUint8List());
      // // setState(() {
      // //   _img = data;
      // // });

      Uuid uuid = Uuid();

      String docID = uuid.v4();

      // String signatureUrl = await saveSignatureToFirestore(encoded, docID);

      print('qqqqqqq');
      List<String> listUrl = [];

      for (int i = 0; i < image!.length; i++) {
        String fileName =
            '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
        if (image![i].path.isEmpty) {
          listUrl.add(imageUrl[i]);
        } else {
          ref = FirebaseStorage.instance
              .ref()
              .child('images')
              .child('Users')
              .child(userController.userData!['UserID'])
              .child('Customer')
              .child(docID)
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
      print('wwwwwww');
      List<String> listUrl2 = [];

      for (int i = 0; i < image2!.length; i++) {
        String fileName2 =
            '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
        if (image2![i].path.isEmpty) {
          listUrl2.add(imageUrl2[i]);
        } else {
          ref2 = FirebaseStorage.instance
              .ref()
              .child('images')
              .child('Users')
              .child(userController.userData!['UserID'])
              .child('Customer')
              .child(docID)
              .child(DateTime.now().month.toString())
              .child('${DateTime.now().day}/$fileName2');

          await ref2!.putFile(image2![i]).whenComplete(
            () async {
              await ref2!.getDownloadURL().then(
                (value2) {
                  listUrl2.add(value2);
                },
              );
            },
          );
        }
      }
      print('eeeeeee');
      // GoogleMapController controller = await _mapController.future;
      // // if (controller != null) {
      // controller.dispose();
      // // }

      for (int i = 0; i < sendAndBillList!.length; i++) {
        resultListSendAndBill[i]['ชื่อออกบิล'] = sendAndBillList![i].text;
      }
      print(widget.entryMap!['value']['CustomerID']);
      print('ddddd');

      await FirebaseFirestore.instance
          .collection('Customer')
          .doc(widget.entryMap!['value']['CustomerID'])
          // .doc(docID)

          .update({
        'CustomerID': widget.entryMap!['value']['CustomerID'],
        // 'CustomerID': docID,
        'PhoneID': _model.textController6.text,
        'CustomerDateCreate': widget.entryMap!['value']['CustomerDateCreate'],
        'CustomerDateUpdate': DateTime.now(),
        'ประเภทลูกค้า': widget.type == 'Company' ? 'Company' : 'Personal',
        'คำนำหน้า': _model.radioButtonValueController == null
            ? ''
            : _model.radioButtonValueController!.value,
        'ชื่อนามสกุล': _model.textController1.text,
        'วันเกิด': _model.textController2.text,
        'เดือนเกิด': _model.textController3.text,
        'ปีเกิด': _model.textController4.text,
        'เลขบัตรประชาชน': _model.textController5.text,
        'PhoneNumber': _model.textController6.text,
        'วันเริ่มจัดส่ง': _model.textController7.text,
        'เดือนเริ่มจัดส่ง': _model.textController8.text,
        'ปีเริ่มจัดส่ง': _model.textController9.text,
        'ชื่อร้านค้า': _model.textController10.text,
        'เป้าหมายยอดขาย': _model.textController11.text,
        'CategoryProductNow': dropDownValues,
        'วันสิ้นสุด': _model.textController12.text,
        'เดือนสิ้นสุด': _model.textController13.text,
        'ปีสิ้นสุด': _model.textController14.text,
        'CategoryProductOrder': dropDownValues2,
        'ListCustomerAddress': resultList,
        'ตารางราคา': _model.dropDownValue6,
        // 'ที่อยู่จัดส่ง': _model.dropDownValue7,
        // 'ที่อยู่ออกบิล': _model.dropDownValue8,
        // 'ที่อยู่อื่น': _model.dropDownValue9,

        'ลิสต์จัดส่งและออกบิล': resultListSendAndBill,
        'ระยะเวลาชำระหนี้': _model.dropDownValue10,
        'วงเงินเครดิต': _model.textController19.text,
        'ส่วนลดบิล': _model.textController20.text,
        'ประเภทชำระ': _model.dropDownValue11,
        'เงื่อนไขชำระ': _model.dropDownValue12,
        'บัญชีธนาคารของบริษัท': _model.dropDownValue13,
        'แผนก': _model.dropDownValue14,
        'รหัสบัญชี': _model.dropDownValue15,
        'รหัสพนักงานขาย': _model.dropDownValue16,
        'ชื่อพนักงานขาย': _model.dropDownValue17,
        'รหัสกลุ่มลูกค้า': _model.dropDownValue18,
        'รหัสบัญชี2': _model.dropDownValue19,
        'รูปร้านค้า': listUrl,
        'รูปเอกสาร': listUrl2,
        'ลายเซ็น': widget.entryMap!['value']['ลายเซ็น'],
        'บันทึกพร้อมตรวจ': checkButtonSuccess,
        'สถานะ': widget.entryMap!['value']['สถานะ'],
        'รอการอนุมัติ': widget.entryMap!['value']['สถานะ'] == true
            ? false
            : widget.entryMap!['value']['สถานะ'] == false &&
                    checkButtonSuccess == false
                ? widget.entryMap!['value']['รอการอนุมัติ'] == true
                    ? true
                    : widget.entryMap!['value']['รอการอนุมัติ'] == false &&
                            checkButtonSuccess == false
                        ? true
                        : false
                : !checkButtonSuccess,
        'ขั้นตอนอนุมัติ': widget.entryMap!['value']['ขั้นตอนอนุมัติ'],
        'ชื่อบริษัท': _model.textController1Company.text,
        'วันจัดตั้ง': _model.textController2Company.text,
        'เดือนจัดตั้ง': _model.textController3Company.text,
        'ปีจัดตั้ง': _model.textController4Company.text,
        'เลขประจำตัวผู้เสียภาษี': _model.textController41Company.text,
        'ทุนจดทะเบียน': _model.textController5Company.text,

        'UserId': widget.entryMap!['value']['UserId'],
      }).then((value) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        Navigator.pop(context);
        widget.entryMap!['value']['สถานะ'] == true
            ? null
            : widget.entryMap!['value']['สถานะ'] == false &&
                    widget.entryMap!['value']['บันทึกพร้อมตรวจ'] == false
                ? null
                : Navigator.pop(context);

        print('==================== set1 ============================');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> saveSignatureToFirestore(
      String base64String, String docID) async {
    // Decode base64 string to bytes
    Uint8List bytes = base64Decode(base64String);

    // Upload image to Firebase Storage
    String fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // String customerPhone = widget.data!['CustomerPhone'];
    // String cleanedPhone = customerPhone.replaceAll('-', '');
    String cleanedPhone = userController.userData!['Phone'];
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('Users')
        .child(userController.userData!['UserID'])
        .child('CustomerSignatures')
        .child(docID)
        .child('signatures/$fileName');
    UploadTask uploadTask = storageReference.putData(bytes);
    await uploadTask.whenComplete(() => null);

    // Get the URL of the uploaded image
    String downloadURL = await storageReference.getDownloadURL();

    return downloadURL;

    // // Save the downloadURL to Firestore

    // // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
    // //     .collection('1000')
    // //     .doc('Company')
    // //     .collection('User')
    // //     .doc(userController.userData!['UserID'])
    // //     .collection('Employee')
    // //     .doc(userController.userData!['UserID'])
    // //     .get();

    // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
    //     .collection('Customer')
    //     .doc(userController.userData!['UserID'])
    //     .get();
    // Map<String, dynamic> userMap =
    //     documentSnapshot.data() as Map<String, dynamic>;

    // List<dynamic> data = userMap['EmployeeAppointment'];

    // // int index = data.indexWhere((item) =>
    // //     item['CustomerPhone'] == widget.data!['CustomerPhone'] &&
    // //     item['Number'] == widget.data!['Number']);

    // int index = 0;

    // if (index != -1) {
    //   data[index]['CustomerPDPAImg'] = downloadURL;
    //   data[index]['CustomerPdpaConfirm'] = true;
    // } else {
    // }
    // await FirebaseFirestore.instance
    //     .collection('1000')
    //     .doc('Company')
    //     .collection('User')
    //     .doc(userController.userData!['UserID'])
    //     .collection('Employee')
    //     .doc(userController.userData!['UserID'])
    //     .update(
    //   {'EmployeeAppointment': data},
    // );

    // showImageDialog(context, downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is Form Edit General User ');
    print('==============================');
    print(widget.entryMap!['value']['CustomerID']);

    print(widget.entryMap!['value']['สถานะ']);
    print(widget.entryMap!['value']['บันทึกพร้อมตรวจ']);
    print(widget.entryMap!['value']['รอการอนุมัติ']);

    String getThaiMonthAbbreviation(int month) {
      switch (month) {
        case 1:
          return 'ม.ค.';
        case 2:
          return 'ก.พ.';
        case 3:
          return 'มี.ค.';
        case 4:
          return 'เม.ย.';
        case 5:
          return 'พ.ค.';
        case 6:
          return 'มิ.ย.';
        case 7:
          return 'ก.ค.';
        case 8:
          return 'ส.ค.';
        case 9:
          return 'ก.ย.';
        case 10:
          return 'ต.ค.';
        case 11:
          return 'พ.ย.';
        case 12:
          return 'ธ.ค.';
        default:
          return '';
      }
    }

    String formatThaiDate(Timestamp timestamp) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
      );

      int thaiYear = dateTime.year + 543;
      String thaiMonthAbbreviation = getThaiMonthAbbreviation(dateTime.month);

      return '${dateTime.day} $thaiMonthAbbreviation $thaiYear';
    }

    return isLoading
        ? Container(
            child: Center(
              child: CircularLoading(success: !isLoading),
            ),
          )
        : Column(
            children: [
              Form(
                // key: _formKey,
                child: SizedBox(
                  height: 1000,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.entryMap!['value']['รอการอนุมัติ'] == false
                              ? SizedBox()
                              : StepApproveWidget(
                                  checkBool: widget.entryMap!['value']
                                      ['ขั้นตอนอนุมัติ']),
                          // widget.entryMap!['value']['รอการอนุมัติ'] == false
                          //     ? SizedBox()
                          //     : Container(
                          //         decoration: BoxDecoration(),
                          //         child: ClipRRect(
                          //           borderRadius:
                          //               BorderRadius.circular(8.0),
                          //           child: Image.asset(
                          //             'assets/images/Screen_Shot_2566-11-20_at_07.50.28.png',
                          //             width:
                          //                 MediaQuery.sizeOf(context).width *
                          //                     1.0,
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       ),
                          widget.entryMap!['value']['รอการอนุมัติ'] == false
                              ? SizedBox()
                              : Align(
                                  alignment: AlignmentDirectional(0.00, 0.00),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 20.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'กาญจนา หทัยกุล',
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
                                  ),
                                ),
                          widget.entryMap!['value']['รอการอนุมัติ'] == false
                              ? SizedBox()
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'อัพเดทสถานะ ${formatThaiDate(widget.entryMap!['value']['CustomerDateUpdate'])}',
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
                          //========================  ocr =====================================
                          widget.type == 'Company'
                              ? const SizedBox(
                                  height: 5,
                                )
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 0.0, 5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 5.0, 0.0),
                                        child: Icon(
                                          FFIcons.kocr,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                      Text(
                                        'กรุณาเชื่อมต่ออินเตอร์เน็ต  สามารถเปิดกล้องถ่ายหน้าบัตรและอ่าน ORC ได้จากที่นี่',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                          //======================= checkbox คำนำหน้า ======================================
                          widget.type == 'Company'
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 0.0, 5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'คำนำหน้า',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                      FlutterFlowRadioButton(
                                        options:
                                            ['นาย', 'นาง', 'นางสาว'].toList(),
                                        onChanged: (val) {
                                          // => setState(() {}   );
                                        },
                                        controller: _model
                                                .radioButtonValueController ??=
                                            FormFieldController<String>(null),
                                        optionHeight: 32.0,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        selectedTextStyle:
                                            FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                        buttonPosition:
                                            RadioButtonPosition.left,
                                        direction: Axis.horizontal,
                                        radioButtonColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        inactiveRadioButtonColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        toggleable: false,
                                        horizontalAlignment:
                                            WrapAlignment.start,
                                        verticalAlignment:
                                            WrapCrossAlignment.start,
                                      ),
                                    ],
                                  ),
                                ),
                          //=========================== ชื่อ นามสกุล /ชื่อบริษัn==================================
                          widget.type == 'Company'
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _model.textController1Company,
                                    focusNode:
                                        _model.textFieldFocusNode1Company,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'ชื่อบริษัn',
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      hintText: 'ชื่อบริษัn',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    textAlign: TextAlign.start,
                                    validator: _model.textController1Validator
                                        .asValidator(context),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _model.textController1,
                                    focusNode: _model.textFieldFocusNode1,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'ชื่อ นามสกุล',
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      hintText: 'ชื่อ นามสกุล',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    textAlign: TextAlign.start,
                                    validator: _model.textController1Validator
                                        .asValidator(context),
                                  ),
                                ),
                          //======================= วันเดือนปีเกิด/วันเดือนปีที่จัดจัดตั้ง ======================================
                          widget.type == 'Company'
                              ? Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 0.0, 5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'วันเดือนปีที่จดจัดตั้ง',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                      SizedBox(
                                          width: 40,
                                          child: Icon(
                                            Icons.calendar_month,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          )),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller:
                                                _model.textController2Company,
                                            focusNode: _model
                                                .textFieldFocusNode2Company,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              hintText: 'วันที่',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                            // validator: _model.textController2Validator
                                            //     .asValidator(context),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            validator: (value) {
                                              if (value!.isNotEmpty) {
                                                if (value.length > 2) {
                                                  return 'เลข 1 - 2 หลักค่ะ';
                                                }
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller:
                                                _model.textController3Company,
                                            focusNode: _model
                                                .textFieldFocusNode3Company,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              hintText: 'เดือน',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                            validator: _model
                                                .textController3Validator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller:
                                                _model.textController4Company,
                                            focusNode: _model
                                                .textFieldFocusNode4Company,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              hintText: 'พ.ศ.',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                            // validator: _model.textController4Validator
                                            //     .asValidator(context),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            validator: (value) {
                                              if (value!.isNotEmpty) {
                                                if (value.length != 4) {
                                                  return 'ตัวเลข 4 หลักค่ะ';
                                                }
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 0.0, 5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'วันเดือนปีเกิด',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                      SizedBox(
                                          width: 40,
                                          child: Icon(
                                            Icons.calendar_month,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          )),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: _model.textController2,
                                            focusNode:
                                                _model.textFieldFocusNode2,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              labelText: 'วันที่',
                                              hintText: 'วันที่',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                            // validator: _model.textController2Validator
                                            //     .asValidator(context),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            validator: (value) {
                                              if (value!.isNotEmpty) {
                                                if (value.length > 2) {
                                                  return 'เลข 1 - 2 หลักค่ะ';
                                                }
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: _model.textController3,
                                            focusNode:
                                                _model.textFieldFocusNode3,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              labelText: 'เดือน',
                                              hintText: 'เดือน',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                            validator: _model
                                                .textController3Validator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: _model.textController4,
                                            focusNode:
                                                _model.textFieldFocusNode4,
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              labelText: 'พ.ศ.',
                                              hintText: 'พ.ศ.',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                            // validator: _model.textController4Validator
                                            //     .asValidator(context),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            validator: (value) {
                                              if (value!.isNotEmpty) {
                                                if (value.length != 4) {
                                                  return 'ตัวเลข 4 หลักค่ะ';
                                                }
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                          //======================= เลขประจำตัวผู้เสียภาษี ======================================
                          widget.type == 'Company'
                              ? Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 8.0, 5.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _model.textController41Company,
                                    focusNode:
                                        _model.textFieldFocusNode41Company,
                                    autofocus: true,
                                    obscureText: false,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      labelText: 'เลขประจำตัวผู้เสียภาษี',
                                      hintText: 'เลขประจำตัวผู้เสียภาษี',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    textAlign: TextAlign.start,
                                    // validator: _model.textController5Validator
                                    //     .asValidator(context),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    validator: (value) {
                                      // if (value!.isNotEmpty) {
                                      //   if (value.length != 13) {
                                      //     return 'กรุณาใส่ทุนจดทะเบียนเท่านั้นค่ะ';
                                      //   }
                                      // }

                                      return null;
                                    },
                                  ),
                                )
                              : const SizedBox(),
                          //======================= เลขที่บัตรประชาชน / ทุนจดทะเบียน ======================================
                          widget.type == 'Company'
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 8.0, 5.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _model.textController5Company,
                                    focusNode:
                                        _model.textFieldFocusNode5Company,
                                    autofocus: true,
                                    obscureText: false,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      hintText: 'ทุนจดทะเบียน',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    textAlign: TextAlign.start,
                                    // validator: _model.textController5Validator
                                    //     .asValidator(context),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    validator: (value) {
                                      // if (value!.isNotEmpty) {
                                      //   if (value.length != 13) {
                                      //     return 'กรุณาใส่ทุนจดทะเบียนเท่านั้นค่ะ';
                                      //   }
                                      // }

                                      return null;
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 8.0, 5.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _model.textController5,
                                    focusNode: _model.textFieldFocusNode5,
                                    autofocus: true,
                                    obscureText: false,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      labelText: 'เลขที่บัตรประชาชน',
                                      hintText: 'เลขที่บัตรประชาชน',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    textAlign: TextAlign.start,
                                    // validator: _model.textController5Validator
                                    //     .asValidator(context),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    validator: (value) {
                                      if (value!.isNotEmpty) {
                                        if (value.length != 13) {
                                          return 'กรุณาใส่เลขที่บัตรประชาชน 13 หลักเท่านั้นค่ะ';
                                        }
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                          //===================== เบอร์โทรศัพท์ ========================================
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: _model.textController6,
                              focusNode: _model.textFieldFocusNode6,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                labelText: 'เบอร์โทรศัพท์',
                                hintText: 'เบอร์โทรศัพท์',
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                              // validator: _model.textController6Validator
                              //     .asValidator(context),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              validator: (value) {
                                // if (value!.isNotEmpty) {
                                //   if (value.length != 10) {
                                //     return 'กรุณาใส่เบอร์โทรศัพท์ 10 หลักเท่านั้นค่ะ';
                                //   }
                                // }

                                return null;
                              },
                            ),
                          ),
                          //===================== วัน / เดือน / ปี ที่เริ่มจัดส่ง  ========================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'วัน / เดือน / ปี ที่เริ่มจัดส่ง ',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                SizedBox(
                                    width: 40,
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    )),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _model.textController7,
                                      focusNode: _model.textFieldFocusNode7,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        labelText: 'วันที่',
                                        hintText: 'วันที่',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                      // validator: _model.textController7Validator
                                      //     .asValidator(context),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      validator: (value) {
                                        if (value!.isNotEmpty) {
                                          if (value.length > 2) {
                                            return 'เลข 1 - 2 หลักค่ะ';
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _model.textController8,
                                      focusNode: _model.textFieldFocusNode8,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        labelText: 'เดือน',
                                        hintText: 'เดือน',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                      validator: _model.textController8Validator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _model.textController9,
                                      focusNode: _model.textFieldFocusNode9,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        labelText: 'พ.ศ.',
                                        hintText: 'พ.ศ.',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                      // validator: _model.textController9Validator
                                      //     .asValidator(context),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      validator: (value) {
                                        if (value!.isNotEmpty) {
                                          if (value.length > 4) {
                                            return 'ตัวเลข 4 หลักค่ะ';
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //=========================== ชื่อร้าน/แผงในตลาด ==================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: _model.textController10,
                              focusNode: _model.textFieldFocusNode10,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                labelText: widget.type == 'Company'
                                    ? 'ชื่อร้าน'
                                    : 'ชื่อร้าน/แผงในตลาด',
                                hintText: widget.type == 'Company'
                                    ? 'ชื่อร้าน'
                                    : 'ชื่อร้าน/แผงในตลาด',
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                              validator: _model.textController10Validator
                                  .asValidator(context),
                            ),
                          ), //=============================================================
                          //=========================== เป้าการขาย ==================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: _model.textController11,
                              focusNode: _model.textFieldFocusNode11,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'เป้าการขาย',
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintText: 'เป้าการขาย',
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                              // validator: _model.textController11Validator
                              //     .asValidator(context),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              validator: (value) {
                                // if (value!.isNotEmpty) {
                                //   if (value.length > 2) {
                                //     return 'เลข 1 - 2 หลักค่ะ';
                                //   }
                                // }

                                return null;
                              },
                            ),
                          ),
                          //============================= dropdown ประเภทสินค้าที่ขายในปัจจุบัน ================================
                          StatefulBuilder(
                            builder: (context, setState) {
                              if (dropDownControllers.length == total) {
                              } else {
                                for (int i = dropDownControllers.length;
                                    i < total;
                                    i++) {
                                  dropDownControllers
                                      .add(FormFieldController<String>(''));
                                  dropDownValues.add('');
                                }
                              }
                              return Column(
                                children: [
                                  for (int index = 0; index < total; index++)
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 5.0, 8.0, 5.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '  ประเภทสินค้าที่ขายในปัจจุบัน ลำดับที่ ${index + 1}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall,
                                                ),
                                                total == 1
                                                    ? SizedBox()
                                                    : index + 1 == total
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 5.0,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              // => setState(
                                                              //     () => total =
                                                              //         total -
                                                              //             1),
                                                              child: Icon(
                                                                Icons
                                                                    .remove_circle_outline_outlined,
                                                                size: 12,
                                                                color: Colors
                                                                    .red
                                                                    .shade900,
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            SizedBox(
                                              height: 55.0,
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                disabled: true,
                                                // controller: _model.dropDownValueController1 ??=
                                                //     FormFieldController<String>(null),
                                                controller:
                                                    dropDownControllers[index],
                                                options: categoryNameList

                                                // [
                                                //   'ประเภทสินค้า 1',
                                                //   'ประเภทสินค้า 2',
                                                //   'ประเภทสินค้า 3',
                                                //   'ประเภทสินค้า 4',
                                                //   'ประเภทสินค้า 5'
                                                // ]
                                                ,
                                                searchHintText:
                                                    'ประเภทสินค้าที่ขายในปัจจุบัน',
                                                // onChanged: (val) =>
                                                //     setState(() => _model.dropDownValue1 = val),
                                                onChanged: (val) =>
                                                    setState(() {
                                                  dropDownValues[index] = val;
                                                }),
                                                height: 45.0,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                hintText:
                                                    'ประเภทสินค้าที่ขายในปัจจุบัน',
                                                icon: Icon(
                                                  Icons.arrow_left_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                                elevation: 2.0,
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                borderWidth: 2.0,
                                                borderRadius: 8.0,
                                                margin: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 4.0, 16.0, 4.0),
                                                hidesUnderline: true,
                                                isSearchable: false,
                                                isMultiSelect: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  //=============================================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 0.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          // => setState(
                                          //     () => total = total + 1),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'เลือกกลุ่มสินค้าเพิ่ม',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          // //======================== ระยะเวลาการดำเนินการ =====================================
                          // Padding(
                          //   padding:
                          //       EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.max,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Column(
                          //         mainAxisSize: MainAxisSize.max,
                          //         children: [
                          //           Row(
                          //             mainAxisSize: MainAxisSize.max,
                          //             children: [
                          //               Icon(
                          //                 Icons.add_circle,
                          //                 color: FlutterFlowTheme.of(context)
                          //                     .secondaryText,
                          //                 size: 24.0,
                          //               ),
                          //             ],
                          //           ),
                          //           Row(
                          //             mainAxisSize: MainAxisSize.max,
                          //             children: [
                          //               Text(
                          //                 'เลือกกลุ่มสินค้าเพิ่ม',
                          //                 style:
                          //                     FlutterFlowTheme.of(context).bodyMedium,
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //======================== ระยะเวลาการดำเนินการ=====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'ระยะเวลาการดำเนินการ',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                SizedBox(
                                    width: 40,
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    )),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _model.textController12,
                                      focusNode: _model.textFieldFocusNode12,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        labelText: 'วันที่',
                                        hintText: 'วันที่',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                      // validator: _model
                                      //     .textController12Validator
                                      //     .asValidator(context),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      validator: (value) {
                                        if (value!.isNotEmpty) {
                                          if (value.length > 2) {
                                            return 'เลข 1 - 2 หลักค่ะ';
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _model.textController13,
                                      focusNode: _model.textFieldFocusNode13,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        labelText: 'เดือน',
                                        hintText: 'เดือน',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                      validator: _model
                                          .textController13Validator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      readOnly: true,

                                      controller: _model.textController14,
                                      focusNode: _model.textFieldFocusNode14,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        labelText: 'พ.ศ.',
                                        hintText: 'พ.ศ.',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                      // validator: _model
                                      //     .textController14Validator
                                      //     .asValidator(context),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      validator: (value) {
                                        if (value!.isNotEmpty) {
                                          if (value.length > 2) {
                                            return 'ตัวเลข 4 หลักค่ะ';
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ), //=============================================================
                          //======================== dropdown กลุ่มสินค้าท่สั่งซืื้อ =====================================
                          StatefulBuilder(
                            builder: (context, setState) {
                              if (dropDownControllers2.length == total) {
                              } else {
                                for (int i = dropDownControllers2.length;
                                    i < total2;
                                    i++) {
                                  dropDownControllers2
                                      .add(FormFieldController<String>(''));
                                  dropDownValues2.add('');
                                }
                              }
                              return Column(
                                children: [
                                  for (int index = 0; index < total2; index++)
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 5.0, 8.0, 5.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '  กลุ่มสินค้าที่สั่งชื้อ ลำดับที่ ${index + 1}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall,
                                                ),
                                                total2 == 1
                                                    ? SizedBox()
                                                    : index + 1 == total2
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 5.0,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              //  => setState(
                                                              //     () => total2 =
                                                              //         total2 -
                                                              //             1),
                                                              child: Icon(
                                                                Icons
                                                                    .remove_circle_outline_outlined,
                                                                size: 12,
                                                                color: Colors
                                                                    .red
                                                                    .shade900,
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            SizedBox(
                                              height: 55.0,
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                // controller: _model.dropDownValueController1 ??=
                                                //     FormFieldController<String>(null),
                                                disabled: true,
                                                controller:
                                                    dropDownControllers2[index],
                                                options: categoryNameList

                                                // [
                                                //   'ประเภทสินค้า 1',
                                                //   'ประเภทสินค้า 2',
                                                //   'ประเภทสินค้า 3',
                                                //   'ประเภทสินค้า 4',
                                                //   'ประเภทสินค้า 5'
                                                // ]
                                                ,
                                                searchHintText:
                                                    'กลุ่มสินค้าที่สั่งชื้อ',
                                                // onChanged: (val) =>
                                                //     setState(() => _model.dropDownValue1 = val),
                                                onChanged: (val) =>
                                                    setState(() {
                                                  dropDownValues2[index] = val;
                                                }),
                                                height: 45.0,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                                hintText:
                                                    'กลุ่มสินค้าที่สั่งชื้อ',
                                                icon: Icon(
                                                  Icons.arrow_left_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                                elevation: 2.0,
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                borderWidth: 2.0,
                                                borderRadius: 8.0,
                                                margin: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 4.0, 16.0, 4.0),
                                                hidesUnderline: true,
                                                isSearchable: false,
                                                isMultiSelect: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  //===========================กลุ่มสินค้าที่สั่งชื้อ ปุ่ม==================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 0.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          // => setState(
                                          //     () => total2 = total2 + 1),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'เลือกกลุ่มสินค้าเพิ่ม',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          // Padding(
                          //   padding:
                          //       EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                          //   child: FlutterFlowDropDown<String>(
                          //     controller: _model.dropDownValueController2 ??=
                          //         FormFieldController<String>(null),
                          //     options: categoryNameList
                          //     //  [
                          //     //   'กลุ่มสินค้า 1',
                          //     //   'กลุ่มสินค้า 2',
                          //     //   'กลุ่มสินค้า 3',
                          //     //   'กลุ่มสินค้า 4',
                          //     //   'กลุ่มสินค้า 5'
                          //     // ]
                          //     ,
                          //     onChanged: (val) =>
                          //         setState(() => _model.dropDownValue2 = val),
                          //     height: 45.0,
                          //     textStyle: FlutterFlowTheme.of(context).bodyMedium,
                          //     hintText: 'กลุ่มสินค้าที่สั่งชื้อ',
                          //     icon: Icon(
                          //       Icons.arrow_left_outlined,
                          //       color: FlutterFlowTheme.of(context).secondaryText,
                          //       size: 24.0,
                          //     ),
                          //     elevation: 2.0,
                          //     borderColor: FlutterFlowTheme.of(context).alternate,
                          //     borderWidth: 2.0,
                          //     borderRadius: 8.0,
                          //     margin: EdgeInsetsDirectional.fromSTEB(
                          //         16.0, 4.0, 16.0, 4.0),
                          //     hidesUnderline: true,
                          //     isSearchable: false,
                          //     isMultiSelect: false,
                          //   ),
                          // ),
                          //=============================================================
                          //=========================== หัวข้อ ที่อยู่ในการจัดส่ง ==================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'ที่อยูในการจัดสง (ระบุได้มากกวา 1 สถานที่) โดยเลือก จังหวัด ,อำเภอ , ตำบล , รหัสไปรษณีย์',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ],
                            ),
                          ), //========================= ที่อยู่ในการจัดส่ง แบบหลายอัน ====================================
                          //=========================== ลิสต์ที่อยู่ในการจัดส่ง ==================================
                          StatefulBuilder(builder: (context, setState) {
                            if (resultList.length == total3) {
                            } else {
                              for (int i = resultList.length; i < total3; i++) {
                                resultList.add({
                                  'HouseNumber': '',
                                  'VillageName': '',
                                  'Province': '',
                                  'District': '',
                                  'SubDistrict': '',
                                  'PostalCode': '',
                                  'Latitude': '',
                                  'Longitude': '',
                                  'Image': '',
                                });

                                selected.add({
                                  'province_id': null,
                                  'amphure_id': null,
                                  'tambon_id': null,
                                });
                                amphures!.add([]);
                                tambons!.add([]);
                                textFieldFocusHouseNumber!.add(FocusNode());
                                textFieldFocusVillageName!.add(FocusNode());
                                textFieldFocusPostalCode!.add(FocusNode());
                                textFieldFocusLatitude!.add(FocusNode());
                                textFieldFocusLongitude!.add(FocusNode());

                                // dropDownValueControllerProvince
                                //     .add(FormFieldController<String>(''));
                                // dropDownValueControllerDistrict
                                //     .add(FormFieldController<String>(''));
                                // dropDownValueControllerSubDistrict
                                //     .add(FormFieldController<String>(''));
                                latList!.add(TextEditingController());
                                lotList!.add(TextEditingController());
                              }
                            }

                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 8.0, 5.0),
                              child: Column(
                                children: [
                                  for (int index = 0;
                                      index < resultList.length;
                                      index++)
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              ' ที่อยูในการจัดสง ลำดับที่ ${index + 1}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall,
                                            ),
                                            total3 == 1
                                                ? SizedBox()
                                                : index + 1 == total3
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: 5.0,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () {},
//                                                                   setState(() {
//                                                                 total3 =
//                                                                     total3 - 1;

//                                                                 resultList
//                                                                     .removeLast();
//                                                                 selected
//                                                                     .removeLast();
//                                                                 amphures!
//                                                                     .removeLast();
//                                                                 tambons!
//                                                                     .removeLast();
//                                                                 textFieldFocusHouseNumber!
//                                                                     .removeLast();
//                                                                 textFieldFocusVillageName!
//                                                                     .removeLast();
//                                                                 textFieldFocusPostalCode!
//                                                                     .removeLast();
//                                                                 textFieldFocusLatitude!
//                                                                     .removeLast();
//                                                                 textFieldFocusLongitude!
//                                                                     .removeLast();
//                                                                 // dropDownValueControllerProvince
//                                                                 //     .removeLast();
//                                                                 // dropDownValueControllerDistrict
//                                                                 //     .removeLast();
//                                                                 // dropDownValueControllerSubDistrict
//                                                                 //     .removeLast();
//                                                                 latList!
//                                                                     .removeLast();
//                                                                 lotList!
//                                                                     .removeLast();
//                                                                 addressAllForDropdown
//                                                                     .clear();

//                                                                 setState(() {
//                                                                   // for (int i = 0;
//                                                                   //     i <
//                                                                   //         resultList
//                                                                   //             .length;
//                                                                   //     i++) {
//                                                                   //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
//                                                                   //   String
//                                                                   //       combinedFields =
//                                                                   //       resultList[
//                                                                   //               i]
//                                                                   //           .values
//                                                                   //           .join(
//                                                                   //               ' ');

//                                                                   //   // นำ string ไปแทนที่ใน list options
//                                                                   //   addressAllForDropdown
//                                                                   //       .add(
//                                                                   //           '$combinedFields');
//                                                                   // }
//                                                                   List<Map<String, dynamic>>
//                                                                       addressThai =
//                                                                       [];

//                                                                   // List<String?>? textList = [];
//                                                                   for (int i =
//                                                                           0;
//                                                                       i <
//                                                                           resultList
//                                                                               .length;
//                                                                       i++) {
//                                                                     // resultList.add(false);

//                                                                     List<Map<String, dynamic>>
//                                                                         mapProvincesList =
//                                                                         provinces!.cast<
//                                                                             Map<String,
//                                                                                 dynamic>>();

//                                                                     List<Map<String, dynamic>>
//                                                                         mapList =
//                                                                         amphures![i].cast<
//                                                                             Map<String,
//                                                                                 dynamic>>();
//                                                                     List<Map<String, dynamic>>
//                                                                         tambonList =
//                                                                         tambons![i].cast<
//                                                                             Map<String,
//                                                                                 dynamic>>();
//                                                                     String?
//                                                                         provincesName;
//                                                                     String?
//                                                                         amphorName;
//                                                                     String?
//                                                                         tambonName;

// //====================================================================
//                                                                     if (resultList[i]['Province'] ==
//                                                                             '' ||
//                                                                         resultList[i]['Province'] ==
//                                                                             null) {
//                                                                       provincesName =
//                                                                           '';
//                                                                     } else {
//                                                                       Map<String,
//                                                                               dynamic>
//                                                                           resultProvince =
//                                                                           mapProvincesList.firstWhere(
//                                                                               (element) => element['id'] == resultList[i]['Province'],
//                                                                               orElse: () => {});

//                                                                       provincesName =
//                                                                           resultProvince['name_th'] ??
//                                                                               '';
//                                                                     }
// //====================================================================
//                                                                     if (resultList[i]['District'] ==
//                                                                             '' ||
//                                                                         resultList[i]['District'] ==
//                                                                             null) {
//                                                                       amphorName =
//                                                                           '';
//                                                                     } else {
//                                                                       Map<String,
//                                                                               dynamic>
//                                                                           resultAmphure =
//                                                                           mapList.firstWhere(
//                                                                               (element) => element['id'] == resultList[i]['District'],
//                                                                               orElse: () => {});

//                                                                       amphorName =
//                                                                           resultAmphure['name_th'] ??
//                                                                               '';
//                                                                     }

//                                                                     //====================================================================
//                                                                     if (resultList[i]['SubDistrict'] ==
//                                                                             '' ||
//                                                                         resultList[i]['SubDistrict'] ==
//                                                                             null) {
//                                                                       tambonName =
//                                                                           '';
//                                                                     } else {
//                                                                       Map<String,
//                                                                               dynamic>
//                                                                           resultTambon =
//                                                                           tambonList.firstWhere(
//                                                                               (element) => element['id'] == resultList[i]['SubDistrict'],
//                                                                               orElse: () => {});
//                                                                       tambonName =
//                                                                           resultTambon['name_th'] ??
//                                                                               '';
//                                                                     }
//                                                                     //====================================================================
//                                                                     addressThai
//                                                                         .add({
//                                                                       'province_name': provincesName! ==
//                                                                               ''
//                                                                           ? provincesName
//                                                                           : 'จ.' +
//                                                                               provincesName,
//                                                                       'amphure_name': amphorName! ==
//                                                                               ''
//                                                                           ? amphorName
//                                                                           : 'อ.' +
//                                                                               amphorName,
//                                                                       'tambon_name': tambonName! ==
//                                                                               ''
//                                                                           ? tambonName
//                                                                           : 'ต.' +
//                                                                               provincesName,
//                                                                     });

//                                                                     print(
//                                                                         addressThai);

//                                                                     String
//                                                                         texttt =
//                                                                         '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

//                                                                     // textList[i]!.add(text.trimLeft());
//                                                                     addressAllForDropdown
//                                                                         .add(texttt
//                                                                             .trimLeft());
//                                                                   }
//                                                                 });

//                                                                 toSetState();
//                                                               }),
                                                          child: Icon(
                                                            Icons
                                                                .remove_circle_outline_outlined,
                                                            size: 12,
                                                            color: Colors
                                                                .red.shade900,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox()
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          // controller: _model.textController15,
                                          readOnly: true,

                                          initialValue: resultList[index]
                                              ['HouseNumber'],
                                          onChanged: (value) {
                                            resultList[index]['HouseNumber'] =
                                                value;

                                            addressAllForDropdown.clear();

                                            setState(() {
                                              // for (int i = 0;
                                              //     i < resultList.length;
                                              //     i++) {
                                              //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
                                              //   String combinedFields =
                                              //       resultList[i]
                                              //           .values
                                              //           .join(' ');

                                              //   // นำ string ไปแทนที่ใน list options
                                              //   addressAllForDropdown
                                              //       .add('$combinedFields');
                                              // }
                                              List<Map<String, dynamic>>
                                                  addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0;
                                                  i < resultList.length;
                                                  i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>>
                                                    mapProvincesList =
                                                    provinces!.cast<
                                                        Map<String, dynamic>>();

                                                List<Map<String, dynamic>>
                                                    mapList = amphures![i].cast<
                                                        Map<String, dynamic>>();
                                                List<Map<String, dynamic>>
                                                    tambonList =
                                                    tambons![i].cast<
                                                        Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

//====================================================================
                                                if (resultList[i]['Province'] ==
                                                        '' ||
                                                    resultList[i]['Province'] ==
                                                        null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic>
                                                      resultProvince =
                                                      mapProvincesList.firstWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              resultList[i]
                                                                  ['Province'],
                                                          orElse: () => {});

                                                  provincesName =
                                                      resultProvince[
                                                              'name_th'] ??
                                                          '';
                                                }
//====================================================================
                                                if (resultList[i]['District'] ==
                                                        '' ||
                                                    resultList[i]['District'] ==
                                                        null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic>
                                                      resultAmphure =
                                                      mapList.firstWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              resultList[i]
                                                                  ['District'],
                                                          orElse: () => {});

                                                  amphorName = resultAmphure[
                                                          'name_th'] ??
                                                      '';
                                                }

                                                //====================================================================
                                                if (resultList[i]
                                                            ['SubDistrict'] ==
                                                        '' ||
                                                    resultList[i]
                                                            ['SubDistrict'] ==
                                                        null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic>
                                                      resultTambon =
                                                      tambonList.firstWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              resultList[i][
                                                                  'SubDistrict'],
                                                          orElse: () => {});
                                                  tambonName =
                                                      resultTambon['name_th'] ??
                                                          '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name':
                                                      provincesName! == ''
                                                          ? provincesName
                                                          : 'จ.' +
                                                              provincesName,
                                                  'amphure_name':
                                                      amphorName! == ''
                                                          ? amphorName
                                                          : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! ==
                                                          ''
                                                      ? tambonName
                                                      : 'ต.' + provincesName,
                                                });

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown
                                                    .add(texttt.trimLeft());
                                              }
                                            });
                                            toSetState();
                                          },
                                          focusNode:
                                              textFieldFocusHouseNumber![index],
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                            labelText:
                                                'กรุณาพิมพ์ชื่อบ้านเลขที',
                                            hintText: 'กรุณาพิมพ์ชื่อบ้านเลขที',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                          textAlign: TextAlign.start,
                                          validator: _model
                                              .textController15Validator
                                              .asValidator(context),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 5.0),
                                          child: TextFormField(
                                            readOnly: true,

                                            // controller: _model.textController16,
                                            initialValue: resultList[index]
                                                ['VillageName'],
                                            onChanged: (value) {
                                              resultList[index]['VillageName'] =
                                                  value;
                                              addressAllForDropdown.clear();

                                              setState(() {
                                                // for (int i = 0;
                                                //     i < resultList.length;
                                                //     i++) {
                                                //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
                                                //   String combinedFields =
                                                //       resultList[i]
                                                //           .values
                                                //           .join(' ');

                                                //   // นำ string ไปแทนที่ใน list options
                                                //   addressAllForDropdown
                                                //       .add('$combinedFields');
                                                // }
                                                List<Map<String, dynamic>>
                                                    addressThai = [];

                                                // List<String?>? textList = [];
                                                for (int i = 0;
                                                    i < resultList.length;
                                                    i++) {
                                                  // resultList.add(false);

                                                  List<Map<String, dynamic>>
                                                      mapProvincesList =
                                                      provinces!.cast<
                                                          Map<String,
                                                              dynamic>>();

                                                  List<Map<String, dynamic>>
                                                      mapList = amphures![i]
                                                          .cast<
                                                              Map<String,
                                                                  dynamic>>();
                                                  List<Map<String, dynamic>>
                                                      tambonList = tambons![i]
                                                          .cast<
                                                              Map<String,
                                                                  dynamic>>();
                                                  String? provincesName;
                                                  String? amphorName;
                                                  String? tambonName;

//====================================================================
                                                  if (resultList[i]
                                                              ['Province'] ==
                                                          '' ||
                                                      resultList[i]
                                                              ['Province'] ==
                                                          null) {
                                                    provincesName = '';
                                                  } else {
                                                    Map<String, dynamic>
                                                        resultProvince =
                                                        mapProvincesList.firstWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                resultList[i][
                                                                    'Province'],
                                                            orElse: () => {});

                                                    provincesName =
                                                        resultProvince[
                                                                'name_th'] ??
                                                            '';
                                                  }
//====================================================================
                                                  if (resultList[i]
                                                              ['District'] ==
                                                          '' ||
                                                      resultList[i]
                                                              ['District'] ==
                                                          null) {
                                                    amphorName = '';
                                                  } else {
                                                    Map<String, dynamic>
                                                        resultAmphure =
                                                        mapList.firstWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                resultList[i][
                                                                    'District'],
                                                            orElse: () => {});

                                                    amphorName = resultAmphure[
                                                            'name_th'] ??
                                                        '';
                                                  }

                                                  //====================================================================
                                                  if (resultList[i]
                                                              ['SubDistrict'] ==
                                                          '' ||
                                                      resultList[i]
                                                              ['SubDistrict'] ==
                                                          null) {
                                                    tambonName = '';
                                                  } else {
                                                    Map<String, dynamic>
                                                        resultTambon =
                                                        tambonList.firstWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                resultList[i][
                                                                    'SubDistrict'],
                                                            orElse: () => {});
                                                    tambonName = resultTambon[
                                                            'name_th'] ??
                                                        '';
                                                  }
                                                  //====================================================================
                                                  addressThai.add({
                                                    'province_name':
                                                        provincesName! == ''
                                                            ? provincesName
                                                            : 'จ.' +
                                                                provincesName,
                                                    'amphure_name':
                                                        amphorName! == ''
                                                            ? amphorName
                                                            : 'อ.' + amphorName,
                                                    'tambon_name':
                                                        tambonName! == ''
                                                            ? tambonName
                                                            : 'ต.' +
                                                                provincesName,
                                                  });

                                                  String texttt =
                                                      '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                  // textList[i]!.add(text.trimLeft());
                                                  addressAllForDropdown
                                                      .add(texttt.trimLeft());
                                                }
                                              });

                                              toSetState();
                                            },
                                            focusNode:
                                                textFieldFocusVillageName![
                                                    index],
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              labelText: 'ชื่อหมู่บ้าน',
                                              hintText: 'ชื่อหมู่บ้าน',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.start,
                                            validator: _model
                                                .textController16Validator
                                                .asValidator(context),
                                          ),
                                        ), //=============================================================
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        dropdownList(
                                          label: 'Province: ',
                                          id: 'province_id',
                                          list: provinces,
                                          child: 'amphure',
                                          childsId: ['amphure_id', 'tambon_id'],
                                          setChilds: [setAmphures, setTambons],
                                          index: index,
                                        ),
                                        SizedBox(height: 10.0),
                                        dropdownList(
                                          label: 'District: ',
                                          id: 'amphure_id',
                                          list: amphures![index],
                                          child: 'tambon',
                                          childsId: ['tambon_id'],
                                          setChilds: [setTambons],
                                          index: index,
                                        ),
                                        SizedBox(height: 10.0),
                                        dropdownList(
                                          label: 'Sub-district: ',
                                          id: 'tambon_id',
                                          list: tambons![index],
                                          setChilds: null,
                                          childsId: null,
                                          index: index,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // Align(
                                        //   alignment:
                                        //       AlignmentDirectional(0.00, 0.00),
                                        //   child: Padding(
                                        //     padding:
                                        //         EdgeInsetsDirectional.fromSTEB(
                                        //             0.0, 5.0, 0.0, 5.0),
                                        //     child: FlutterFlowDropDown<String>(
                                        //       controller:
                                        //           dropDownValueControllerProvince[
                                        //               index],
                                        //       options: [
                                        //         'เชียงใหม่',
                                        //         'นครราชสีมา',
                                        //         'กาญจนบุรี'
                                        //       ],
                                        //       onChanged: (val) => setState(
                                        //         () {
                                        //           _model.dropDownValue3 = val;
                                        //           //  dropDownValueControllerProvince[
                                        //           //       index] = val!;
                                        //           resultList[index]
                                        //               ['Province'] = val;
                                        //         },
                                        //       ),
                                        //       height: 45.0,
                                        //       textStyle:
                                        //           FlutterFlowTheme.of(context)
                                        //               .bodyMedium,
                                        //       hintText: 'จังหวัด',
                                        //       icon: Icon(
                                        //         Icons.arrow_left_outlined,
                                        //         color:
                                        //             FlutterFlowTheme.of(context)
                                        //                 .secondaryText,
                                        //         size: 24.0,
                                        //       ),
                                        //       elevation: 2.0,
                                        //       borderColor:
                                        //           FlutterFlowTheme.of(context)
                                        //               .alternate,
                                        //       borderWidth: 2.0,
                                        //       borderRadius: 8.0,
                                        //       margin: EdgeInsetsDirectional
                                        //           .fromSTEB(
                                        //               16.0, 4.0, 16.0, 4.0),
                                        //       hidesUnderline: true,
                                        //       isSearchable: false,
                                        //       isMultiSelect: false,
                                        //     ),
                                        //   ),
                                        // ), //=============================================================
                                        // Padding(
                                        //   padding:
                                        //       EdgeInsetsDirectional.fromSTEB(
                                        //           0.0, 5.0, 0.0, 5.0),
                                        //   child: FlutterFlowDropDown<String>(
                                        //     controller: _model
                                        //             .dropDownValueController4 ??=
                                        //         FormFieldController<String>(
                                        //             null),
                                        //     options: [
                                        //       '\tเมืองเชียงใหม่',
                                        //       'จอมทอง',
                                        //       '\tแม่แจ่ม'
                                        //     ],
                                        //     onChanged: (val) => setState(() {
                                        //       _model.dropDownValue4 = val;
                                        //       resultList[index]['District'] =
                                        //           val;
                                        //     }),
                                        //     height: 45.0,
                                        //     textStyle:
                                        //         FlutterFlowTheme.of(context)
                                        //             .bodyMedium,
                                        //     hintText: 'อำเภอ',
                                        //     icon: Icon(
                                        //       Icons.arrow_left_outlined,
                                        //       color:
                                        //           FlutterFlowTheme.of(context)
                                        //               .secondaryText,
                                        //       size: 24.0,
                                        //     ),
                                        //     elevation: 2.0,
                                        //     borderColor:
                                        //         FlutterFlowTheme.of(context)
                                        //             .alternate,
                                        //     borderWidth: 2.0,
                                        //     borderRadius: 8.0,
                                        //     margin:
                                        //         EdgeInsetsDirectional.fromSTEB(
                                        //             16.0, 4.0, 16.0, 4.0),
                                        //     hidesUnderline: true,
                                        //     isSearchable: false,
                                        //     isMultiSelect: false,
                                        //   ),
                                        // ), //=============================================================
                                        // Padding(
                                        //   padding:
                                        //       EdgeInsetsDirectional.fromSTEB(
                                        //           0.0, 5.0, 0.0, 5.0),
                                        //   child: FlutterFlowDropDown<String>(
                                        //     controller: _model
                                        //             .dropDownValueController5 ??=
                                        //         FormFieldController<String>(
                                        //             null),
                                        //     options: [
                                        //       '\tศรีภูมิ',
                                        //       'พระสิงห์',
                                        //       'หายยา\t'
                                        //     ],
                                        //     onChanged: (val) => setState(() {
                                        //       _model.dropDownValue5 = val;
                                        //       resultList[index]['SubDistrict'] =
                                        //           val;
                                        //     }),
                                        //     height: 45.0,
                                        //     textStyle:
                                        //         FlutterFlowTheme.of(context)
                                        //             .bodyMedium,
                                        //     hintText: 'ตำบล',
                                        //     icon: Icon(
                                        //       Icons.arrow_left_outlined,
                                        //       color:
                                        //           FlutterFlowTheme.of(context)
                                        //               .secondaryText,
                                        //       size: 24.0,
                                        //     ),
                                        //     elevation: 2.0,
                                        //     borderColor:
                                        //         FlutterFlowTheme.of(context)
                                        //             .alternate,
                                        //     borderWidth: 2.0,
                                        //     borderRadius: 8.0,
                                        //     margin:
                                        //         EdgeInsetsDirectional.fromSTEB(
                                        //             16.0, 4.0, 16.0, 4.0),
                                        //     hidesUnderline: true,
                                        //     isSearchable: false,
                                        //     isMultiSelect: false,
                                        //   ),
                                        // ),
                                        //======================= รหัสไปรษณีย์ ======================================
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 5.0),
                                          child: TextFormField(
                                            readOnly: true,

                                            // controller: _model.textController17,
                                            initialValue: resultList[index]
                                                ['PostalCode'],
                                            onChanged: (value) {
                                              resultList[index]['PostalCode'] =
                                                  value;

                                              addressAllForDropdown.clear();

                                              setState(() {
                                                // for (int i = 0;
                                                //     i < resultList.length;
                                                //     i++) {
                                                //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
                                                //   String combinedFields =
                                                //       resultList[i]
                                                //           .values
                                                //           .join(' ');

                                                //   // นำ string ไปแทนที่ใน list options
                                                //   addressAllForDropdown
                                                //       .add('$combinedFields');
                                                // }
                                                List<Map<String, dynamic>>
                                                    addressThai = [];

                                                // List<String?>? textList = [];
                                                for (int i = 0;
                                                    i < resultList.length;
                                                    i++) {
                                                  // resultList.add(false);

                                                  List<Map<String, dynamic>>
                                                      mapProvincesList =
                                                      provinces!.cast<
                                                          Map<String,
                                                              dynamic>>();

                                                  List<Map<String, dynamic>>
                                                      mapList = amphures![i]
                                                          .cast<
                                                              Map<String,
                                                                  dynamic>>();
                                                  List<Map<String, dynamic>>
                                                      tambonList = tambons![i]
                                                          .cast<
                                                              Map<String,
                                                                  dynamic>>();
                                                  String? provincesName;
                                                  String? amphorName;
                                                  String? tambonName;

//====================================================================
                                                  if (resultList[i]
                                                              ['Province'] ==
                                                          '' ||
                                                      resultList[i]
                                                              ['Province'] ==
                                                          null) {
                                                    provincesName = '';
                                                  } else {
                                                    Map<String, dynamic>
                                                        resultProvince =
                                                        mapProvincesList.firstWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                resultList[i][
                                                                    'Province'],
                                                            orElse: () => {});

                                                    provincesName =
                                                        resultProvince[
                                                                'name_th'] ??
                                                            '';
                                                  }
//====================================================================
                                                  if (resultList[i]
                                                              ['District'] ==
                                                          '' ||
                                                      resultList[i]
                                                              ['District'] ==
                                                          null) {
                                                    amphorName = '';
                                                  } else {
                                                    Map<String, dynamic>
                                                        resultAmphure =
                                                        mapList.firstWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                resultList[i][
                                                                    'District'],
                                                            orElse: () => {});

                                                    amphorName = resultAmphure[
                                                            'name_th'] ??
                                                        '';
                                                  }

                                                  //====================================================================
                                                  if (resultList[i]
                                                              ['SubDistrict'] ==
                                                          '' ||
                                                      resultList[i]
                                                              ['SubDistrict'] ==
                                                          null) {
                                                    tambonName = '';
                                                  } else {
                                                    Map<String, dynamic>
                                                        resultTambon =
                                                        tambonList.firstWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                resultList[i][
                                                                    'SubDistrict'],
                                                            orElse: () => {});
                                                    tambonName = resultTambon[
                                                            'name_th'] ??
                                                        '';
                                                  }
                                                  //====================================================================
                                                  addressThai.add({
                                                    'province_name':
                                                        provincesName! == ''
                                                            ? provincesName
                                                            : 'จ.' +
                                                                provincesName,
                                                    'amphure_name':
                                                        amphorName! == ''
                                                            ? amphorName
                                                            : 'อ.' + amphorName,
                                                    'tambon_name':
                                                        tambonName! == ''
                                                            ? tambonName
                                                            : 'ต.' +
                                                                provincesName,
                                                  });

                                                  String texttt =
                                                      '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                  // textList[i]!.add(text.trimLeft());
                                                  addressAllForDropdown
                                                      .add(texttt.trimLeft());
                                                }
                                              });
                                              toSetState();
                                            },
                                            focusNode:
                                                textFieldFocusPostalCode![
                                                    index],
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              labelText: 'รหัสไปรษณีย์',
                                              hintText: 'รหัสไปรษณีย์',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            textAlign: TextAlign.start,
                                            // validator: _model
                                            //     .textController17Validator
                                            //     .asValidator(context),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            validator: (value) {
                                              if (value!.isNotEmpty) {
                                                if (value.length > 5) {
                                                  return 'กรุณาใส่รหัสไปรษณีย์ 5 หลักค่ะ';
                                                }
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                        //======================= ละติจูด ลองติจูด ======================================
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 15.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   ' ละติดจูด ลองติจูด สามารถค้นหาได้จากการค้นหาในแผนที่',
                                              //   style:
                                              //       FlutterFlowTheme.of(context)
                                              //           .bodySmall,
                                              // ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      readOnly: true,

                                                      controller:
                                                          latList![index],
                                                      onChanged: (value) {
                                                        resultList[index]
                                                                ['Latitude'] =
                                                            value;

                                                        addressAllForDropdown
                                                            .clear();

                                                        setState(() {
                                                          // for (int i = 0;
                                                          //     i <
                                                          //         resultList
                                                          //             .length;
                                                          //     i++) {
                                                          //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
                                                          //   String
                                                          //       combinedFields =
                                                          //       resultList[i]
                                                          //           .values
                                                          //           .join(' ');

                                                          //   // นำ string ไปแทนที่ใน list options
                                                          //   addressAllForDropdown
                                                          //       .add(
                                                          //           '$combinedFields');
                                                          // }
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              addressThai = [];

                                                          // List<String?>? textList = [];
                                                          for (int i = 0;
                                                              i <
                                                                  resultList
                                                                      .length;
                                                              i++) {
                                                            // resultList.add(false);

                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                mapProvincesList =
                                                                provinces!.cast<
                                                                    Map<String,
                                                                        dynamic>>();

                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                mapList =
                                                                amphures![i].cast<
                                                                    Map<String,
                                                                        dynamic>>();
                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                tambonList =
                                                                tambons![i].cast<
                                                                    Map<String,
                                                                        dynamic>>();
                                                            String?
                                                                provincesName;
                                                            String? amphorName;
                                                            String? tambonName;

//====================================================================
                                                            if (resultList[i][
                                                                        'Province'] ==
                                                                    '' ||
                                                                resultList[i][
                                                                        'Province'] ==
                                                                    null) {
                                                              provincesName =
                                                                  '';
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  resultProvince =
                                                                  mapProvincesList.firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'id'] ==
                                                                          resultList[i]
                                                                              [
                                                                              'Province'],
                                                                      orElse:
                                                                          () =>
                                                                              {});

                                                              provincesName =
                                                                  resultProvince[
                                                                          'name_th'] ??
                                                                      '';
                                                            }
//====================================================================
                                                            if (resultList[i][
                                                                        'District'] ==
                                                                    '' ||
                                                                resultList[i][
                                                                        'District'] ==
                                                                    null) {
                                                              amphorName = '';
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  resultAmphure =
                                                                  mapList.firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'id'] ==
                                                                          resultList[i]
                                                                              [
                                                                              'District'],
                                                                      orElse:
                                                                          () =>
                                                                              {});

                                                              amphorName =
                                                                  resultAmphure[
                                                                          'name_th'] ??
                                                                      '';
                                                            }

                                                            //====================================================================
                                                            if (resultList[i][
                                                                        'SubDistrict'] ==
                                                                    '' ||
                                                                resultList[i][
                                                                        'SubDistrict'] ==
                                                                    null) {
                                                              tambonName = '';
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  resultTambon =
                                                                  tambonList.firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'id'] ==
                                                                          resultList[i]
                                                                              [
                                                                              'SubDistrict'],
                                                                      orElse:
                                                                          () =>
                                                                              {});
                                                              tambonName =
                                                                  resultTambon[
                                                                          'name_th'] ??
                                                                      '';
                                                            }
                                                            //====================================================================
                                                            addressThai.add({
                                                              'province_name':
                                                                  provincesName! ==
                                                                          ''
                                                                      ? provincesName
                                                                      : 'จ.' +
                                                                          provincesName,
                                                              'amphure_name':
                                                                  amphorName! ==
                                                                          ''
                                                                      ? amphorName
                                                                      : 'อ.' +
                                                                          amphorName,
                                                              'tambon_name':
                                                                  tambonName! ==
                                                                          ''
                                                                      ? tambonName
                                                                      : 'ต.' +
                                                                          provincesName,
                                                            });

                                                            String texttt =
                                                                '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                            // textList[i]!.add(text.trimLeft());
                                                            addressAllForDropdown
                                                                .add(texttt
                                                                    .trimLeft());
                                                          }
                                                        });
                                                        toSetState();
                                                      },
                                                      focusNode:
                                                          textFieldFocusLatitude![
                                                              index],
                                                      autofocus: true,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium,
                                                        labelText: 'ละติจูด',
                                                        hintText: 'ละติจูด',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium,
                                                      textAlign:
                                                          TextAlign.start,
                                                      // validator: _model
                                                      //     .textController171Validator
                                                      //     .asValidator(context),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      // inputFormatters: [
                                                      //   FilteringTextInputFormatter
                                                      //       .allow(RegExp(
                                                      //           r'[0-9]')),
                                                      // ],
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      readOnly: true,

                                                      controller:
                                                          lotList![index],
                                                      onChanged: (value) {
                                                        resultList[index]
                                                                ['Longitude'] =
                                                            value;

                                                        addressAllForDropdown
                                                            .clear();

                                                        setState(() {
                                                          // for (int i = 0;
                                                          //     i <
                                                          //         resultList
                                                          //             .length;
                                                          //     i++) {
                                                          //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
                                                          //   String
                                                          //       combinedFields =
                                                          //       resultList[i]
                                                          //           .values
                                                          //           .join(' ');

                                                          //   // นำ string ไปแทนที่ใน list options
                                                          //   addressAllForDropdown
                                                          //       .add(
                                                          //           '$combinedFields');
                                                          // }
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              addressThai = [];

                                                          // List<String?>? textList = [];
                                                          for (int i = 0;
                                                              i <
                                                                  resultList
                                                                      .length;
                                                              i++) {
                                                            // resultList.add(false);

                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                mapProvincesList =
                                                                provinces!.cast<
                                                                    Map<String,
                                                                        dynamic>>();

                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                mapList =
                                                                amphures![i].cast<
                                                                    Map<String,
                                                                        dynamic>>();
                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                tambonList =
                                                                tambons![i].cast<
                                                                    Map<String,
                                                                        dynamic>>();
                                                            String?
                                                                provincesName;
                                                            String? amphorName;
                                                            String? tambonName;

//====================================================================
                                                            if (resultList[i][
                                                                        'Province'] ==
                                                                    '' ||
                                                                resultList[i][
                                                                        'Province'] ==
                                                                    null) {
                                                              provincesName =
                                                                  '';
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  resultProvince =
                                                                  mapProvincesList.firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'id'] ==
                                                                          resultList[i]
                                                                              [
                                                                              'Province'],
                                                                      orElse:
                                                                          () =>
                                                                              {});

                                                              provincesName =
                                                                  resultProvince[
                                                                          'name_th'] ??
                                                                      '';
                                                            }
//====================================================================
                                                            if (resultList[i][
                                                                        'District'] ==
                                                                    '' ||
                                                                resultList[i][
                                                                        'District'] ==
                                                                    null) {
                                                              amphorName = '';
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  resultAmphure =
                                                                  mapList.firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'id'] ==
                                                                          resultList[i]
                                                                              [
                                                                              'District'],
                                                                      orElse:
                                                                          () =>
                                                                              {});

                                                              amphorName =
                                                                  resultAmphure[
                                                                          'name_th'] ??
                                                                      '';
                                                            }

                                                            //====================================================================
                                                            if (resultList[i][
                                                                        'SubDistrict'] ==
                                                                    '' ||
                                                                resultList[i][
                                                                        'SubDistrict'] ==
                                                                    null) {
                                                              tambonName = '';
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  resultTambon =
                                                                  tambonList.firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'id'] ==
                                                                          resultList[i]
                                                                              [
                                                                              'SubDistrict'],
                                                                      orElse:
                                                                          () =>
                                                                              {});
                                                              tambonName =
                                                                  resultTambon[
                                                                          'name_th'] ??
                                                                      '';
                                                            }
                                                            //====================================================================
                                                            addressThai.add({
                                                              'province_name':
                                                                  provincesName! ==
                                                                          ''
                                                                      ? provincesName
                                                                      : 'จ.' +
                                                                          provincesName,
                                                              'amphure_name':
                                                                  amphorName! ==
                                                                          ''
                                                                      ? amphorName
                                                                      : 'อ.' +
                                                                          amphorName,
                                                              'tambon_name':
                                                                  tambonName! ==
                                                                          ''
                                                                      ? tambonName
                                                                      : 'ต.' +
                                                                          provincesName,
                                                            });

                                                            String texttt =
                                                                '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                            // textList[i]!.add(text.trimLeft());
                                                            addressAllForDropdown
                                                                .add(texttt
                                                                    .trimLeft());
                                                          }
                                                        });
                                                        toSetState();
                                                      },
                                                      focusNode:
                                                          textFieldFocusLongitude![
                                                              index],
                                                      autofocus: true,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium,
                                                        hintText: 'ลองติจูด',
                                                        labelText: 'ลองติจูด',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium,
                                                      textAlign:
                                                          TextAlign.start,
                                                      // validator: _model
                                                      //     .textController172Validator
                                                      //     .asValidator(context),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      // inputFormatters: [
                                                      //   FilteringTextInputFormatter
                                                      //       .allow(RegExp(
                                                      //           r'[0-9]')),
                                                      // ],
                                                      validator: (value) {
                                                        // if (value!.isNotEmpty) {
                                                        //   if (value.length >
                                                        //       5) {
                                                        //     return 'กรุณาใส่รหัสไปรษณีย์ 5 หลักค่ะ';
                                                        //   }
                                                        // }

                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  //=========================== ปุ่ม เพิ่มที่อยู่ ==================================
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 0.0, 5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          //  => setState(
                                          //     () => total3 = total3 + 1),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'เพิ่มที่อยู่',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                  ),
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
                            );
                          }),
                          //=============================================================

                          //==================== ตารางราคา API =========================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดสง)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 5.0),
                              child: SizedBox(
                                height: 55.0,
                                child: FlutterFlowDropDown<String>(
                                  disabled: true,
                                  controller:
                                      _model.dropDownValueController6 ??=
                                          FormFieldController<String>(null),
                                  options: [
                                    'ตารางราคา 1',
                                    'ตารางราคา 2',
                                    'ตารางราคา 3'
                                  ],
                                  onChanged: (val) => setState(
                                      () => _model.dropDownValue6 = val),
                                  height: 45.0,
                                  textStyle:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                  hintText:
                                      'ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดสง)',
                                  icon: Icon(
                                    Icons.arrow_left_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                  elevation: 2.0,
                                  borderColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  borderWidth: 2.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 4.0, 16.0, 4.0),
                                  hidesUnderline: true,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ),
                            ),
                          ),
                          //========================== หัวข้อ แผนที่ ===================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'พิกัด GPS (Google Map Pin location)',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 0.0, 0.0),
                                  child: Icon(
                                    FFIcons.kstoreMarker,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //======================= แผนที่ ======================================
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 5.0, 10.0, 5.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height: 500.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(0.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    // child: FlutterFlowGoogleMap(
                                    //   controller: _model.googleMapsController,
                                    //   onCameraIdle: (latLng) =>
                                    //       _model.googleMapsCenter = latLng,
                                    //   initialLocation: _model.googleMapsCenter ??=
                                    //       LatLng(13.7120469, 100.7913919),
                                    //   markerColor: GoogleMarkerColor.violet,
                                    //   mapType: MapType.normal,
                                    //   style: GoogleMapStyle.standard,
                                    //   initialZoom: 14.0,
                                    //   allowInteraction: true,
                                    //   allowZoom: true,
                                    //   showZoomControls: true,
                                    //   showLocation: true,
                                    //   showCompass: false,
                                    //   showMapToolbar: false,
                                    //   showTraffic: false,
                                    //   centerMapOnMarkerTap: true,
                                    // ),
                                    child: GoogleMap(
                                      // onTap: (argument) async => await _launchUrl(),
                                      onTap: (argument) async {
                                        // await showQucikAlertMap(
                                        //     context, resultList);
                                        // setState(() {});
                                      },
                                      // mapType: MapType.hybrid,
                                      // initialCameraPosition: _kGooglePlex,
                                      // onMapCreated: (GoogleMapController controller) {
                                      //   _controller.complete(controller);
                                      // },
                                      mapType: ui_maps.MapType.hybrid,
                                      initialCameraPosition: _kGooglePlex,
                                      markers: markers, // เพิ่มนี่
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _mapController.complete(controller);
                                      },
                                    ),
                                  ),
                                  //=============================================================
                                  GestureDetector(
                                    onTap: () async {
                                      // await showQucikAlertMap(
                                      //     context, resultList);
                                      // setState(() {});
                                    },
                                    child: Align(
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
                                              width: MediaQuery.sizeOf(context)
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
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          // await showQucikAlertMap(
                                                          //     context,
                                                          //     resultList);
                                                          // setState(() {});
                                                        },
                                                        child: TextFormField(
                                                          readOnly: true,

                                                          enabled: false,
                                                          // controller: _model
                                                          //     .textController18,
                                                          // focusNode: _model
                                                          //     .textFieldFocusNode18,
                                                          autofocus: true,
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
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            errorBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedErrorBorder:
                                                                InputBorder
                                                                    .none,
                                                            // suffixIcon: Icon(
                                                            //   Icons.search_sharp,
                                                            // ),
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium,
                                                          textAlign:
                                                              TextAlign.center,
                                                          // validator: _model
                                                          //     .textController18Validator
                                                          //     .asValidator(
                                                          //         context),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.search_sharp,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //========================= หัวข้อ รูปภาพร้านค้า ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 0.0, 5.0),
                                  child: Text(
                                    'รูปภาพร้านค้า อัพโหลดได้หลายภาพ (ต้องมีอยางน้อย 1 รูป)',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //==========================  รูปถ่ายร้านค้า  ===================================
                          imageFile.length > 3
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            0.00, 0.00),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 5.0, 8.0, 5.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.63,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      10.0, 10.0, 10.0, 10.0),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Container(
                                                  color: null,
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.63 +
                                                      (((MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.63) /
                                                              4.5) *
                                                          (imageUrl.length -
                                                              2)),
                                                  height: 100,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                20, 0, 0, 0),
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            imageUint8List
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return imageFile[
                                                                      index] ==
                                                                  null
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Image
                                                                            .network(
                                                                          imageUrl[
                                                                              index],
                                                                          width:
                                                                              (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                          height:
                                                                              100.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              0,
                                                                          bottom:
                                                                              0,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                15,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(8),
                                                                                bottomRight: Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(top: 2),
                                                                              child: Text(
                                                                                '${index + 1}/${imageFile.length}',
                                                                                style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top:
                                                                              4,
                                                                          right:
                                                                              4,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.black.withOpacity(0.2),
                                                                                  spreadRadius: 1,
                                                                                  blurRadius: 1,
                                                                                  offset: const Offset(
                                                                                    0,
                                                                                    1,
                                                                                  ), // changes position of shadow
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            child:
                                                                                GestureDetector(
                                                                              child: const Icon(
                                                                                Icons.delete,
                                                                                size: 20,
                                                                                color: Colors.black,
                                                                              ),
                                                                              onTap: () {
                                                                                // imageUrlFromFirestore.removeAt(index);
                                                                                // imageUint8List.removeAt(index);
                                                                                // imageFile.removeAt(index);
                                                                                // image!.removeAt(index);
                                                                                // imageUrl.removeAt(index);
                                                                                // imageLength = imageLength - 1;

                                                                                // setState(() {});
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Image
                                                                            .memory(
                                                                          imageUint8List[
                                                                              index],
                                                                          width:
                                                                              (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                          height:
                                                                              100.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              0,
                                                                          bottom:
                                                                              0,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                15,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(8),
                                                                                bottomRight: Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(top: 2),
                                                                              child: Text(
                                                                                '${index + 1}/${imageFile.length}',
                                                                                style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top:
                                                                              4,
                                                                          right:
                                                                              4,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.black.withOpacity(0.2),
                                                                                  spreadRadius: 1,
                                                                                  blurRadius: 1,
                                                                                  offset: const Offset(
                                                                                    0,
                                                                                    1,
                                                                                  ), // changes position of shadow
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            child:
                                                                                GestureDetector(
                                                                              child: const Icon(
                                                                                Icons.delete,
                                                                                size: 20,
                                                                                color: Colors.black,
                                                                              ),
                                                                              onTap: () {
                                                                                // imageUrlFromFirestore.removeAt(index);
                                                                                // imageUint8List.removeAt(index);
                                                                                // imageFile.removeAt(index);
                                                                                // image!.removeAt(index);
                                                                                // imageUrl.removeAt(index);
                                                                                // imageLength = imageLength - 1;

                                                                                // setState(() {});
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                        },
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          // showQucikAlert(
                                                          //     context);
                                                        },
                                                        child: Container(
                                                          width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.63) /
                                                              4.5,
                                                          height: 100.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                maxRadius: 30,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                child: Icon(
                                                                  FFIcons
                                                                      .kpaperclipPlus,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  size: 30.0,
                                                                ),
                                                              ),
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
                                )
                              : Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            0.00, 0.00),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 5.0, 8.0, 5.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.63,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      10.0, 10.0, 10.0, 10.0),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    imageUrl.length >= 1
                                                        ? imageFile[0] == null
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        10,
                                                                        0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .network(
                                                                        imageUrl[
                                                                            0],
                                                                        width: (MediaQuery.of(context).size.width *
                                                                                0.63) /
                                                                            4.5,
                                                                        height:
                                                                            100.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              15,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2),
                                                                            child:
                                                                                Text(
                                                                              '${0 + 1}/${imageFile.length}',
                                                                              style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              25,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 1,
                                                                                offset: const Offset(
                                                                                  0,
                                                                                  1,
                                                                                ), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              GestureDetector(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              // imageUrlFromFirestore.removeAt(0);
                                                                              // imageUint8List.removeAt(0);
                                                                              // imageFile.removeAt(0);
                                                                              // image!.removeAt(0);
                                                                              // imageUrl.removeAt(0);
                                                                              // imageLength = imageLength - 1;

                                                                              // setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        10,
                                                                        0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .memory(
                                                                        imageUint8List[
                                                                            0],
                                                                        width: (MediaQuery.of(context).size.width *
                                                                                0.63) /
                                                                            4.5,
                                                                        height:
                                                                            100.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              15,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2),
                                                                            child:
                                                                                Text(
                                                                              '${0 + 1}/${imageFile.length}',
                                                                              style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              25,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 1,
                                                                                offset: const Offset(
                                                                                  0,
                                                                                  1,
                                                                                ), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              GestureDetector(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              // imageUrlFromFirestore.removeAt(0);
                                                                              // imageUint8List.removeAt(0);
                                                                              // imageFile.removeAt(0);
                                                                              // image!.removeAt(0);
                                                                              // imageUrl.removeAt(0);
                                                                              // imageLength = imageLength - 1;

                                                                              // setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                            child: Container(
                                                              color: null,
                                                              width: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.63) /
                                                                  4.5,
                                                              height: 100.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0),
                                                              ),
                                                              child: Icon(
                                                                FFIcons
                                                                    .kimagePlus,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 40.0,
                                                              ),
                                                            ),
                                                          ),
                                                    imageUrl.length >= 2
                                                        ? imageFile[1] == null
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        10,
                                                                        0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .network(
                                                                        imageUrl[
                                                                            1],
                                                                        width: (MediaQuery.of(context).size.width *
                                                                                0.63) /
                                                                            4.5,
                                                                        height:
                                                                            100.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              15,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2),
                                                                            child:
                                                                                Text(
                                                                              '${1 + 1}/${imageFile.length}',
                                                                              style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              25,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 1,
                                                                                offset: const Offset(
                                                                                  0,
                                                                                  1,
                                                                                ), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              GestureDetector(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              // imageUrlFromFirestore.removeAt(1);
                                                                              // imageUint8List.removeAt(1);
                                                                              // imageFile.removeAt(1);
                                                                              // image!.removeAt(1);
                                                                              // imageUrl.removeAt(1);
                                                                              // imageLength = imageLength - 1;

                                                                              // setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        10,
                                                                        0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .memory(
                                                                        imageUint8List[
                                                                            1],
                                                                        width: (MediaQuery.of(context).size.width *
                                                                                0.63) /
                                                                            4.5,
                                                                        height:
                                                                            100.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              15,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2),
                                                                            child:
                                                                                Text(
                                                                              '${1 + 1}/${imageFile.length}',
                                                                              style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              25,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 1,
                                                                                offset: const Offset(
                                                                                  0,
                                                                                  1,
                                                                                ), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              GestureDetector(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              // imageUrlFromFirestore.removeAt(1);
                                                                              // imageUint8List.removeAt(1);
                                                                              // imageFile.removeAt(1);
                                                                              // image!.removeAt(1);
                                                                              // imageUrl.removeAt(1);
                                                                              // imageLength = imageLength - 1;

                                                                              // // imageListFile
                                                                              // //     .removeAt(
                                                                              // //         index);
                                                                              // setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                            child: Container(
                                                              width: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.63) /
                                                                  4.5,
                                                              height: 100.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0),
                                                              ),
                                                              child: Icon(
                                                                FFIcons
                                                                    .kimagePlus,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 40.0,
                                                              ),
                                                            ),
                                                          ),
                                                    imageUrl.length >= 3
                                                        ? imageFile[2] == null
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        10,
                                                                        0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .network(
                                                                        imageUrl[
                                                                            2],
                                                                        width: (MediaQuery.of(context).size.width *
                                                                                0.63) /
                                                                            4.5,
                                                                        height:
                                                                            100.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              15,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2),
                                                                            child:
                                                                                Text(
                                                                              '${2 + 1}/${imageFile.length}',
                                                                              style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              25,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 1,
                                                                                offset: const Offset(
                                                                                  0,
                                                                                  1,
                                                                                ), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              GestureDetector(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              // imageUrlFromFirestore.removeAt(2);
                                                                              // imageUint8List.removeAt(2);
                                                                              // imageFile.removeAt(2);
                                                                              // image!.removeAt(2);
                                                                              // imageUrl.removeAt(2);
                                                                              // imageLength = imageLength - 1;

                                                                              // setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        10,
                                                                        0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .memory(
                                                                        imageUint8List[
                                                                            2],
                                                                        width: (MediaQuery.of(context).size.width *
                                                                                0.63) /
                                                                            4.5,
                                                                        height:
                                                                            100.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              15,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: Radius.circular(8),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2),
                                                                            child:
                                                                                Text(
                                                                              '${2 + 1}/${imageFile.length}',
                                                                              style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              25,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 1,
                                                                                offset: const Offset(
                                                                                  0,
                                                                                  1,
                                                                                ), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              GestureDetector(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              // imageUrlFromFirestore.removeAt(2);
                                                                              // imageUint8List.removeAt(2);
                                                                              // imageFile.removeAt(2);
                                                                              // image!.removeAt(2);
                                                                              // imageUrl.removeAt(2);
                                                                              // imageLength = imageLength - 1;

                                                                              // setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    6.0,
                                                                    0.0),
                                                            child: Container(
                                                              width: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.63) /
                                                                  4.5,
                                                              height: 100.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0),
                                                              ),
                                                              child: Icon(
                                                                FFIcons
                                                                    .kimagePlus,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 40.0,
                                                              ),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(5.0,
                                                              0.0, 5.0, 0.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          // showQucikAlert(
                                                          //     context);
                                                        },
                                                        child: Container(
                                                          width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.63) /
                                                              4.5,
                                                          height: 100.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                maxRadius: 30,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                child: Icon(
                                                                  FFIcons
                                                                      .kpaperclipPlus,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  size: 30.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                    ],
                                  ),
                                ),
                          //================== หัวข้อ กำหนดที่อยูในการจัดส่ง ===========================================
                          const SizedBox(
                            height: 10,
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            if (resultListSendAndBill.length == total4) {
                            } else {
                              for (int i = resultListSendAndBill.length;
                                  i < total4;
                                  i++) {
                                resultListSendAndBill.add({
                                  'ที่อยู่จัดส่ง': '',
                                  'ชื่อออกบิล': '',
                                  'ที่อยู่ออกบิล': '',
                                });

                                dropDownControllersSend
                                    .add(FormFieldController<String>(''));
                                dropDownControllersBill
                                    .add(FormFieldController<String>(''));

                                sendAndBillList!.add(TextEditingController());

                                textFieldFocusSendAndBill!.add(FocusNode());
                              }
                            }

                            return Column(
                              children: [
                                for (int index = 0; index < total4; index++)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '  กำหนดที่อยู่ในการจัดส่งและออกบิล ลำดับที่ ${index + 1}',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge,
                                          ),
                                          total4 == 1
                                              ? SizedBox()
                                              : index + 1 == total4
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                        right: 5.0,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {},
                                                        //   setState(() {
                                                        // total4 =
                                                        //     total4 - 1;
                                                        // resultListSendAndBill
                                                        //     .removeLast();

                                                        // dropDownControllersSend
                                                        //     .removeLast();

                                                        // dropDownControllersBill
                                                        //     .removeLast();

                                                        // sendAndBillList!
                                                        //     .removeLast();

                                                        // textFieldFocusSendAndBill!
                                                        //     .removeLast();
                                                        // }),
                                                        child: Icon(
                                                          Icons
                                                              .remove_circle_outline_outlined,
                                                          size: 12,
                                                          color: Colors
                                                              .red.shade900,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox()
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              ' กำหนดที่อยูในการจัดส่ง ',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      //======================= กำหนดที่อยูในการจัดส่ง ======================================
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 8.0, 5.0),
                                        child: SizedBox(
                                          height: 55,
                                          child: FlutterFlowDropDown<String>(
                                            disabled: true,
                                            controller:
                                                dropDownControllersSend[index],
                                            // controller: _model
                                            //         .dropDownValueController7 ??=
                                            //     FormFieldController<String>(null),
                                            options: addressAllForDropdown,
                                            //  ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                                            onChanged: (val) => setState(() {
                                              resultListSendAndBill[index]
                                                  ['ที่อยู่จัดส่ง'] = val;
                                            }),
                                            height: 45.0,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium,
                                            hintText: 'ที่อยู่',
                                            icon: Icon(
                                              Icons.arrow_left_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderWidth: 2.0,
                                            borderRadius: 8.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                      ),

                                      //======================== ที่อยู่ กำหนดที่อยูในการออกบิล =====================================
                                      //=========================== วงเงินเครดิต ==================================
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 5.0, 8.0, 5.0),
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: sendAndBillList![index],

                                          // controller: _model.textController15,
                                          focusNode:
                                              textFieldFocusSendAndBill![index],
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                            labelText:
                                                'ชื่อจ่าหน้าที่อยู่ในการออกบิล',
                                            hintText:
                                                'ชื่อจ่าหน้าที่อยู่ในการออกบิล',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                          textAlign: TextAlign.start,
                                          // validator: _model.textController19Validator
                                          //     .asValidator(context),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: EdgeInsetsDirectional.fromSTEB(
                                      //       8.0, 0.0, 8.0, 5.0),
                                      //   child: FlutterFlowDropDown<String>(
                                      //     controller: _model
                                      //             .dropDownValueController8 ??=
                                      //         FormFieldController<String>(null),
                                      //     options: addressAllForDropdown,
                                      //     //  ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                                      //     onChanged: (val) => setState(() =>
                                      //         _model.dropDownValue8 = val),
                                      //     height: 45.0,
                                      //     textStyle:
                                      //         FlutterFlowTheme.of(context)
                                      //             .bodyMedium,
                                      //     hintText: 'ที่อยู่',
                                      //     icon: Icon(
                                      //       Icons.arrow_left_outlined,
                                      //       color: FlutterFlowTheme.of(context)
                                      //           .secondaryText,
                                      //       size: 24.0,
                                      //     ),
                                      //     elevation: 2.0,
                                      //     borderColor:
                                      //         FlutterFlowTheme.of(context)
                                      //             .alternate,
                                      //     borderWidth: 2.0,
                                      //     borderRadius: 8.0,
                                      //     margin:
                                      //         EdgeInsetsDirectional.fromSTEB(
                                      //             16.0, 4.0, 16.0, 4.0),
                                      //     hidesUnderline: true,
                                      //     isSearchable: false,
                                      //     isMultiSelect: false,
                                      //   ),
                                      // ),
                                      //========================= ไวก่อน ====================================
                                      //========================  หัวข้อ กำหนดที่อยูในการออกบิล =====================================
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              ' กำหนดที่อยูในการออกบิล',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 5.0, 8.0, 5.0),
                                        child: SizedBox(
                                          height: 55,
                                          child: FlutterFlowDropDown<String>(
                                            disabled: true,
                                            controller:
                                                dropDownControllersBill[index],
                                            options: addressAllForDropdown,
                                            //  ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                                            onChanged: (val) => setState(() {
                                              resultListSendAndBill[index]
                                                  ['ที่อยู่ออกบิล'] = val;
                                            }
                                                // _model.dropDownValue8 = val
                                                ),
                                            height: 45.0,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium,
                                            hintText: 'ที่อยู่',
                                            // 'ถ้าเป็นที่อยูอื่นที่อยูในโปรไฟล์ลูกค้าให้เป็น Dropdown ให้เลือก ใน Dropdown แสดงรหัสสาขา',
                                            icon: Icon(
                                              Icons.arrow_left_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderWidth: 2.0,
                                            borderRadius: 8.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                //=============================================================
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 15.0, 0.0, 15.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        // setState(() {
                                        //   total4 = total4 + 1;
                                        // }),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.add_circle,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'เพิ่มที่อยู่อื่นสำหรับการจัดส่ง',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                          //======================== ระยะเวลาชำระหนี้ =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' ระยะเวลาชำระหนี้ (Credit terms)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController10 ??=
                                    FormFieldController<String>(null),
                                options: ['3 เดือน', '6 เดือน', '12 เดือน'],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue10 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText: 'ระยะเวลาชำระหนี้ (Credit terms)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //=========================== วงเงินเครดิต ==================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: _model.textController19,
                              focusNode: _model.textFieldFocusNode19,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                labelText:
                                    'วงเงินเครดิต (กรณีไม่มีการกำหนดเครดิตให้ใสเป็น 0 ค่าเริ่มต้น',
                                hintText:
                                    'วงเงินเครดิต (กรณีไม่มีการกำหนดเครดิตให้ใสเป็น 0 ค่าเริ่มต้น',
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                              validator: _model.textController19Validator
                                  .asValidator(context),
                            ),
                          ),
                          //=========================  สวนลดท้ายบิล ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: _model.textController20,
                              focusNode: _model.textFieldFocusNode20,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                labelText: 'ส่วนลดท้ายบิล (จำนวนบาท หรือ x%)',
                                hintText: 'ส่วนลดท้ายบิล (จำนวนบาท หรือ x%)',
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                              validator: _model.textController20Validator
                                  .asValidator(context),
                            ),
                          ),
                          //=========================  ประเภทการจ่ายเงิน ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' ประเภทการจ่ายเงิน (Dropdown จาก API)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController11 ??=
                                    FormFieldController<String>(null),
                                options: ['เงินสด', 'โอนผ่านบัญชี', 'Gb Pay'],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue11 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText:
                                    'ประเภทการจ่ายเงิน (Dropdown จาก API)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //======================= เงื่อนไขการชำระเงิน ======================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' เงื่อนไขการชำระเงิน (Dropdown จาก API)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController12 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'มัดจำ 50%',
                                  'มัดจำ 60%',
                                  'มัดจำ 70%'
                                ],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue12 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText:
                                    'เงื่อนไขการชำระเงิน (Dropdown จาก API)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //====================== เลือกบัญชีธนาคารของบริษัท =======================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' เลือกบัญชีธนาคารของบริษัท (MFOOD API)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController13 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'ธนาคารกสิกร',
                                  'ธนาคารกรุงไทย',
                                  'ธนาคารกรุงเทพ'
                                ],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue13 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText:
                                    'เลือกบัญชีธนาคารของบริษัท (MFOOD API)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //========================= แผนก ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' แผนก (MFOOD API)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController14 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'แผนกบัญชี',
                                  'แผนกบริหาร',
                                  'แผนกฝ่ายขาย'
                                ],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue14 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText: 'แผนก (MFOOD API)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //======================== รหัสบัญชี =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสบัญชี (MFOOD API)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController15 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'รหัสบัญชี   0103',
                                  'รหัสบัญชี   0203',
                                  'รหัสบัญชี   0303'
                                ],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue15 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText: 'รหัสบัญชี (MFOOD API)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //========================  รหัสพนักงาน =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสพนักงานขาย (อ้างอิงจากรหัสพนักงานจากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController16 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'รหัสพนักงาน  1',
                                  'รหัสพนักงาน  2',
                                  'รหัสพนักงาน   3'
                                ],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue16 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText:
                                    'รหัสพนักงานขาย (อ้างอิงจากรหัสพนักงานจากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //========================  ชื่อ-สกุล พนักงาน  =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' ชื่อ-สกุล พนักงานขาย (อ้างอิงจากชื่อผู้ใช้จากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController17 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'ชื่อ-สกุล พนักงาน  1',
                                  'ชื่อ-สกุล พนักงาน  2',
                                  'ชื่อ-สกุล พนักงาน  3'
                                ],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue17 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText:
                                    'ชื่อ-สกุล พนักงานขาย (อ้างอิงจากชื่อผู้ใช้จากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //======================== รหัสกลุ่มลูกค้า =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสกลุ่มลูกค้า กลุม 1 - 5 (dropdown) / MFOOD API\' (Require กลุมลูกค้า 1 ต้องเลือกข้อมูล)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 5.0),
                            child: SizedBox(
                              height: 55,
                              child: FlutterFlowDropDown<String>(
                                disabled: true,
                                controller: _model.dropDownValueController18 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'กลุ่มลูกค้า  0101',
                                  'กลุ่มลูกค้า  0201',
                                  'กลุ่มลูกค้า  0301',
                                  'กลุ่มลูกค้า  0401',
                                  'กลุ่มลูกค้า  0501',
                                ],
                                onChanged: (val) => setState(
                                    () => _model.dropDownValue18 = val),
                                height: 45.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).bodyMedium,
                                hintText:
                                    'รหัสกลุ่มลูกค้า กลุม 1 - 5 (dropdown) / MFOOD API\' (Require กลุมลูกค้า 1 ต้องเลือกข้อมูล)',
                                icon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          //=========================  รหัสบัญชี  ====================================

                          widget.type == 'Company'
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 5.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        ' รหัสบัญชี (MFOOD API)',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                          widget.type == 'Company'
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 8.0, 5.0),
                                  child: SizedBox(
                                    height: 55,
                                    child: FlutterFlowDropDown<String>(
                                      disabled: true,
                                      controller:
                                          _model.dropDownValueController19 ??=
                                              FormFieldController<String>(null),
                                      options: [
                                        'รหัสบัญชี   1',
                                        'รหัสบัญชี   2',
                                        'รหัสบัญชี   3'
                                      ],
                                      onChanged: (val) => setState(
                                          () => _model.dropDownValue19 = val),
                                      height: 45.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      hintText: 'รหัสบัญชี (MFOOD API)',
                                      icon: Icon(
                                        Icons.arrow_left_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      elevation: 2.0,
                                      borderColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderWidth: 2.0,
                                      borderRadius: 8.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 4.0, 16.0, 4.0),
                                      hidesUnderline: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  ),
                                ),
                          //======================  รูปสำหรับเอกสาร =======================================
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 5.0, 0.0, 5.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'กรุณาแนบเอกสารดั่งต่อไปนี้',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Text(
                                  widget.type == 'Company'
                                      ? '1) สําเนาบัตรประชาชนของกรรมการ'
                                      : '1) สําเนาบัตรประชาชน',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Text(
                                  widget.type == 'Company'
                                      ? '2) หนังสือรับรองบริษัทไม่หมดอายุเกิน 6 เดือน'
                                      : '2) ทะเบียนบ้าน (ไม่บังคับ)',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Text(
                                  widget.type == 'Company'
                                      ? '3) ภพ.20'
                                      : '3) แผนที่ในการจัดส่งสินค้า',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Text(
                                  widget.type == 'Company'
                                      ? '4) แผนที่ในการจัดส่งสินค้า\n5) เอกสารอื่นๆ ในกรณีที่ลูกค้าติดเครดิต'
                                      : '4) เอกสารอื่นๆ ในกรณีที่ลูกค้าติดเครดิต',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                imageFile2.length > 3
                                    ? Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.00, 0.00),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 5.0, 8.0, 5.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.63,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent3,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(10.0,
                                                            10.0, 10.0, 10.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Container(
                                                        color: null,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.63 +
                                                            (((MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.63) /
                                                                    4.5) *
                                                                (imageUrl2
                                                                        .length -
                                                                    2)),
                                                        height: 100,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            ListView.builder(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      20,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  imageUint8List2
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return imageFile2[
                                                                            index] ==
                                                                        null
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Image.network(
                                                                                imageUrl2[index],
                                                                                width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                                height: 100.0,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              Positioned(
                                                                                right: 0,
                                                                                bottom: 0,
                                                                                child: Container(
                                                                                  width: 20,
                                                                                  height: 15,
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(8),
                                                                                      bottomRight: Radius.circular(10),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 2),
                                                                                    child: Text(
                                                                                      '${index + 1}/${imageFile2.length}',
                                                                                      style: const TextStyle(
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
                                                                              Positioned(
                                                                                top: 4,
                                                                                right: 4,
                                                                                child: Container(
                                                                                  width: 25,
                                                                                  height: 25,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.circular(30),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.black.withOpacity(0.2),
                                                                                        spreadRadius: 1,
                                                                                        blurRadius: 1,
                                                                                        offset: const Offset(
                                                                                          0,
                                                                                          1,
                                                                                        ), // changes position of shadow
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  child: GestureDetector(
                                                                                    child: const Icon(
                                                                                      Icons.delete,
                                                                                      size: 20,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    onTap: () {
                                                                                      // imageUrlFromFirestore2.removeAt(index);
                                                                                      // imageUint8List2.removeAt(index);
                                                                                      // imageFile2.removeAt(index);
                                                                                      // image2!.removeAt(index);
                                                                                      // imageUrl2.removeAt(index);
                                                                                      // imageLength2 = imageLength2 - 1;

                                                                                      // // imageListFile
                                                                                      // //     .removeAt(
                                                                                      // //         index);
                                                                                      // setState(() {});
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Padding(
                                                                        padding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Image.memory(
                                                                                imageUint8List2[index],
                                                                                width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                                height: 100.0,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              Positioned(
                                                                                right: 0,
                                                                                bottom: 0,
                                                                                child: Container(
                                                                                  width: 20,
                                                                                  height: 15,
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(8),
                                                                                      bottomRight: Radius.circular(10),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 2),
                                                                                    child: Text(
                                                                                      '${index + 1}/${imageFile2.length}',
                                                                                      style: const TextStyle(
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
                                                                              Positioned(
                                                                                top: 4,
                                                                                right: 4,
                                                                                child: Container(
                                                                                  width: 25,
                                                                                  height: 25,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.circular(30),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.black.withOpacity(0.2),
                                                                                        spreadRadius: 1,
                                                                                        blurRadius: 1,
                                                                                        offset: const Offset(
                                                                                          0,
                                                                                          1,
                                                                                        ), // changes position of shadow
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  child: GestureDetector(
                                                                                    child: const Icon(
                                                                                      Icons.delete,
                                                                                      size: 20,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    onTap: () {
                                                                                      // imageUrlFromFirestore2.removeAt(index);
                                                                                      // imageUint8List2.removeAt(index);
                                                                                      // imageFile2.removeAt(index);
                                                                                      // image2!.removeAt(index);
                                                                                      // imageUrl2.removeAt(index);
                                                                                      // imageLength2 = imageLength2 - 1;

                                                                                      // setState(() {});
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                              },
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                // showQucikAlert2(
                                                                //     context);
                                                              },
                                                              child: Container(
                                                                width: (MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.63) /
                                                                    4.5,
                                                                height: 100.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      maxRadius:
                                                                          30,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      child:
                                                                          Icon(
                                                                        FFIcons
                                                                            .kpaperclipPlus,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                        size:
                                                                            30.0,
                                                                      ),
                                                                    ),
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
                                      )
                                    : Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.00, 0.00),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 5.0, 8.0, 5.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.63,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent3,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(10.0,
                                                            10.0, 10.0, 10.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          imageUrl2.length >= 1
                                                              ? imageFile2[0] ==
                                                                      null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Image.network(
                                                                              imageUrl2[0],
                                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                              height: 100.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 15,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(8),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 2),
                                                                                  child: Text(
                                                                                    '${0 + 1}/${imageFile2.length}',
                                                                                    style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: 4,
                                                                              right: 4,
                                                                              child: Container(
                                                                                width: 25,
                                                                                height: 25,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 1,
                                                                                      offset: const Offset(
                                                                                        0,
                                                                                        1,
                                                                                      ), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: GestureDetector(
                                                                                  child: const Icon(
                                                                                    Icons.delete,
                                                                                    size: 20,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    // imageUrlFromFirestore2.removeAt(0);
                                                                                    // imageUint8List2.removeAt(0);
                                                                                    // imageFile2.removeAt(0);
                                                                                    // image2!.removeAt(0);
                                                                                    // imageUrl2.removeAt(0);
                                                                                    // imageLength2 = imageLength2 - 1;

                                                                                    // // imageListFile
                                                                                    // //     .removeAt(
                                                                                    // //         index);
                                                                                    // setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Image.memory(
                                                                              imageUint8List2[0],
                                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                              height: 100.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 15,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(8),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 2),
                                                                                  child: Text(
                                                                                    '${0 + 1}/${imageFile2.length}',
                                                                                    style: const TextStyle(
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
                                                                            Positioned(
                                                                              top: 4,
                                                                              right: 4,
                                                                              child: Container(
                                                                                width: 25,
                                                                                height: 25,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 1,
                                                                                      offset: const Offset(
                                                                                        0,
                                                                                        1,
                                                                                      ), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: GestureDetector(
                                                                                  child: const Icon(
                                                                                    Icons.delete,
                                                                                    size: 20,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    // imageUrlFromFirestore2.removeAt(0);
                                                                                    // imageUint8List2.removeAt(0);
                                                                                    // imageFile2.removeAt(0);
                                                                                    // image2!.removeAt(0);
                                                                                    // imageUrl2.removeAt(0);
                                                                                    // imageLength2 = imageLength2 - 1;

                                                                                    // setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          5.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width: (MediaQuery.of(context).size.width *
                                                                            0.63) /
                                                                        4.5,
                                                                    height:
                                                                        100.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                    ),
                                                                    child: Icon(
                                                                      FFIcons
                                                                          .kimagePlus,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          40.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                          imageUrl2.length >= 2
                                                              ? imageFile2[1] ==
                                                                      null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Image.network(
                                                                              imageUrl2[1],
                                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                              height: 100.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 15,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(8),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 2),
                                                                                  child: Text(
                                                                                    '${1 + 1}/${imageFile2.length}',
                                                                                    style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: 4,
                                                                              right: 4,
                                                                              child: Container(
                                                                                width: 25,
                                                                                height: 25,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 1,
                                                                                      offset: const Offset(0, 1), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: GestureDetector(
                                                                                  child: const Icon(
                                                                                    Icons.delete,
                                                                                    size: 20,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    // imageUrlFromFirestore2.removeAt(1);
                                                                                    // imageUint8List2.removeAt(1);
                                                                                    // imageFile2.removeAt(1);
                                                                                    // image2!.removeAt(1);
                                                                                    // imageUrl2.removeAt(1);
                                                                                    // imageLength2 = imageLength2 - 1;

                                                                                    // setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Image.memory(
                                                                              imageUint8List2[1],
                                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                              height: 100.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 15,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(8),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 2),
                                                                                  child: Text(
                                                                                    '${1 + 1}/${imageFile2.length}',
                                                                                    style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: 4,
                                                                              right: 4,
                                                                              child: Container(
                                                                                width: 25,
                                                                                height: 25,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 1,
                                                                                      offset: const Offset(
                                                                                        0,
                                                                                        1,
                                                                                      ), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: GestureDetector(
                                                                                  child: const Icon(
                                                                                    Icons.delete,
                                                                                    size: 20,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    // imageUrlFromFirestore2.removeAt(1);
                                                                                    // imageUint8List2.removeAt(1);
                                                                                    // imageFile2.removeAt(1);
                                                                                    // image2!.removeAt(1);
                                                                                    // imageUrl2.removeAt(1);
                                                                                    // imageLength2 = imageLength2 - 1;

                                                                                    // setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          5.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width: (MediaQuery.of(context).size.width *
                                                                            0.63) /
                                                                        4.5,
                                                                    height:
                                                                        100.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                    ),
                                                                    child: Icon(
                                                                      FFIcons
                                                                          .kimagePlus,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          40.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                          imageUrl2.length >= 3
                                                              ? imageFile2[2] ==
                                                                      null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Image.network(
                                                                              imageUrl2[2],
                                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                              height: 100.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 15,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(8),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 2),
                                                                                  child: Text(
                                                                                    '${2 + 1}/${imageFile2.length}',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: 4,
                                                                              right: 4,
                                                                              child: Container(
                                                                                width: 25,
                                                                                height: 25,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 1,
                                                                                      offset: const Offset(
                                                                                        0,
                                                                                        1,
                                                                                      ), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: GestureDetector(
                                                                                  child: const Icon(
                                                                                    Icons.delete,
                                                                                    size: 20,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    // imageUrlFromFirestore2.removeAt(2);
                                                                                    // imageUint8List2.removeAt(2);
                                                                                    // imageFile2.removeAt(2);
                                                                                    // image2!.removeAt(2);
                                                                                    // imageUrl2.removeAt(2);
                                                                                    // imageLength2 = imageLength2 - 1;

                                                                                    // setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Image.memory(
                                                                              imageUint8List2[2],
                                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                                              height: 100.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 15,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(8),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 2),
                                                                                  child: Text(
                                                                                    '${2 + 1}/${imageFile2.length}',
                                                                                    style: const TextStyle(color: Colors.black, fontSize: 10),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: 4,
                                                                              right: 4,
                                                                              child: Container(
                                                                                width: 25,
                                                                                height: 25,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 1,
                                                                                      offset: const Offset(
                                                                                        0,
                                                                                        1,
                                                                                      ), // changes position of shadow
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: GestureDetector(
                                                                                  child: const Icon(
                                                                                    Icons.delete,
                                                                                    size: 20,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    // imageUrlFromFirestore2.removeAt(2);
                                                                                    // imageUint8List2.removeAt(2);
                                                                                    // imageFile2.removeAt(2);
                                                                                    // image2!.removeAt(2);
                                                                                    // imageUrl2.removeAt(2);
                                                                                    // imageLength2 = imageLength2 - 1;

                                                                                    // setState(() {});
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width: (MediaQuery.of(context).size.width *
                                                                            0.63) /
                                                                        4.5,
                                                                    height:
                                                                        100.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                    ),
                                                                    child: Icon(
                                                                      FFIcons
                                                                          .kimagePlus,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          40.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                // showQucikAlert2(
                                                                //     context);
                                                              },
                                                              child: Container(
                                                                width: (MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.63) /
                                                                    4.5,
                                                                height: 100.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      maxRadius:
                                                                          30,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      child:
                                                                          Icon(
                                                                        FFIcons
                                                                            .kpaperclipPlus,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                        size:
                                                                            30.0,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
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
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          //========================== ลายเซ็น  ===================================
                          Align(
                            alignment: const AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 15.0, 8.0, 5.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 5.0, 0.0),
                                child: imageSignFirestore.isNotEmpty
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.63,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          // color: FlutterFlowTheme.of(context)
                                          //     .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            imageSignFirestore,
                                            fit: BoxFit.fill,
                                          ),
                                        ),

                                        //  Signature(
                                        //   color: Colors.blue.shade800,
                                        //   // color: FlutterFlowTheme.of(context)
                                        //   //     .secondaryText,
                                        //   key: _sign,
                                        //   onSign: () {
                                        //     final sign = _sign.currentState;
                                        //     debugPrint(
                                        //         '${sign!.points.length} points in the signature');
                                        //   },
                                        //   backgroundPainter:
                                        //       WatermarkPaint("2.0", "2.0"),
                                        //   strokeWidth: strokeWidth,
                                        // ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.63,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          // color: FlutterFlowTheme.of(context)
                                          //     .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 1.0,
                                          ),
                                        ),
                                        // child: ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(10.0),
                                        //   child: Image.network(
                                        //     imageSignFirestore,
                                        //     fit: BoxFit.fill,
                                        //   ),
                                        // ),

                                        //  Signature(
                                        //   color: Colors.blue.shade800,
                                        //   // color: FlutterFlowTheme.of(context)
                                        //   //     .secondaryText,
                                        //   key: _sign,
                                        //   onSign: () {
                                        //     final sign = _sign.currentState;
                                        //     debugPrint(
                                        //         '${sign!.points.length} points in the signature');
                                        //   },
                                        //   backgroundPainter:
                                        //       WatermarkPaint("2.0", "2.0"),
                                        //   strokeWidth: strokeWidth,
                                        // ),
                                      ),
                              ),
                            ),
                          ),
                          //=============================================================
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                          //   child: FFButtonWidget(
                          //     onPressed: () {
                          //       print('Button pressed ...');
                          //     },
                          //     text: 'เซฟไว้ทำทีหลัง',
                          //     options: FFButtonOptions(
                          //       width: MediaQuery.sizeOf(context).width * 1.0,
                          //       height: 40.0,
                          //       padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                          //       iconPadding:
                          //           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          //       color: FlutterFlowTheme.of(context).tertiary,
                          //       textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          //             fontFamily: 'Kanit',
                          //             color: Colors.white,
                          //           ),
                          //       elevation: 3.0,
                          //       borderSide: BorderSide(
                          //         color: Colors.transparent,
                          //         width: 1.0,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                          //   child: FFButtonWidget(
                          //     onPressed: () {
                          //       print('Button pressed ...');
                          //     },
                          //     text: 'เซฟแล้วดำเนินการต่อไป',
                          //     options: FFButtonOptions(
                          //       width: MediaQuery.sizeOf(context).width * 1.0,
                          //       height: 40.0,
                          //       padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                          //       iconPadding:
                          //           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          //       color: FlutterFlowTheme.of(context).secondary,
                          //       textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          //             fontFamily: 'Kanit',
                          //             color: Colors.white,
                          //           ),
                          //       elevation: 3.0,
                          //       borderSide: BorderSide(
                          //         color: Colors.transparent,
                          //         width: 1.0,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //========================== เซฟไว้ทำทีหลัง  ===================================
              checkStatusToButtonEdit
                  ? Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                          setState(
                            () => checkStatusToEdit = true,
                          );
                          // trySummit(true);
                        },
                        text: 'แก้ไขข้อมูล',
                        options: FFButtonOptions(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).tertiary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
                    )
                  : Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                          trySummit(true);
                        },
                        text: 'เซฟไว้ทำทีหลัง',
                        options: FFButtonOptions(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).tertiary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                    trySummit(false);
                  },
                  text: 'เซฟแล้วดำเนินการต่อไป',
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
          );
  }

  void toSetState() {
    setState(() {});
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
                      imageProvider: NetworkImage(imageUrl[index]),
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

  showPreviewImage2(int index, String typeImage) {
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
                      imageProvider: NetworkImage(imageUrl2[index]),
                    )
                  : PhotoView(
                      // imageProvider: FileImage(images),
                      imageProvider: MemoryImage(imageUint8List2[index]),
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

  Future<dynamic> mapDialog(
      BuildContext context, List<Map<String, dynamic>> address) async {
    List<bool> boolCheck = [];

    double? lat;
    double? lot;
    // for (int i = 0; i < address.length; i++) {
    //   boolCheck.add(false);
    // }

    List<Map<String, dynamic>> addressThai = [];

    // List<String?>? textList = [];
    for (int i = 0; i < address.length; i++) {
      boolCheck.add(false);

      List<Map<String, dynamic>> mapProvincesList =
          provinces!.cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> mapList =
          amphures![i].cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> tambonList =
          tambons![i].cast<Map<String, dynamic>>();
      String? provincesName;
      String? amphorName;
      String? tambonName;

//====================================================================
      if (address[i]['Province'] == '' || address[i]['Province'] == null) {
        provincesName = '';
      } else {
        Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
            (element) => element['id'] == address[i]['Province'],
            orElse: () => {});

        provincesName = resultProvince['name_th'] ?? '';
      }
//====================================================================
      if (address[i]['District'] == '' || address[i]['District'] == null) {
        amphorName = '';
      } else {
        Map<String, dynamic> resultAmphure = mapList.firstWhere(
            (element) => element['id'] == address[i]['District'],
            orElse: () => {});

        amphorName = resultAmphure['name_th'] ?? '';
      }

      //====================================================================
      if (address[i]['SubDistrict'] == '' ||
          address[i]['SubDistrict'] == null) {
        tambonName = '';
      } else {
        Map<String, dynamic> resultTambon = tambonList.firstWhere(
            (element) => element['id'] == address[i]['SubDistrict'],
            orElse: () => {});
        tambonName = resultTambon['name_th'] ?? '';
      }
      //====================================================================
      addressThai.add({
        'province_name':
            provincesName! == '' ? provincesName : 'จ.' + provincesName,
        'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
        'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
      });

      print(addressThai);

      // String text =
      //     '${address[i]['HouseNumber']} ${address[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

      // textList[i]!.add(text.trimLeft());
    }

    print('in diallog');
    print(address);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          void getLatLngFromAddress(String address) async {
            try {
              List<Location> locations = await locationFromAddress(address);

              if (locations.isNotEmpty) {
                Location location = locations.first;
                print(
                    'Latitude: ${location.latitude}, Longitude: ${location.longitude}');
                lat = location.latitude;
                lot = location.longitude;
                setState(
                  () {
                    _kGooglePlex = CameraPosition(
                      target: google_maps.LatLng(lat!, lot!),
                      zoom: 14.4746,
                    );
                    markers.clear();
                    markers.add(
                      Marker(
                        markerId: MarkerId("your_marker_id"),
                        position: google_maps.LatLng(lat!, lot!), // ตำแหน่ง
                        infoWindow: InfoWindow(
                          title: _model.textController18.text, // ชื่อของปักหมุด
                          // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
                        ),
                      ),
                    );
                    _mapKey = GlobalKey();

                    _kGooglePlexDialog = CameraPosition(
                      target: google_maps.LatLng(lat!, lot!),
                      zoom: 14.4746,
                    );
                    markersDialog.clear();
                    markersDialog.add(
                      Marker(
                        markerId: MarkerId("your_marker_id"),
                        position: google_maps.LatLng(lat!, lot!), // ตำแหน่ง
                        infoWindow: InfoWindow(
                          title: _model.textController18.text, // ชื่อของปักหมุด
                          // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
                        ),
                      ),
                    );
                    _mapKeyDialog = GlobalKey();
                  },
                );
              } else {
                print('No location found for the given address');
              }
            } catch (e) {
              print('Error: $e');
              await Fluttertoast.showToast(
                  msg: "   ไม่มีสถานที่นี้ค่ะ กรุณากรอกชื่อสถานที่ใหม่ค่ะ   ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }

          return AlertDialog(
            // title: Text('Dialog Title'),
            // content: Text('This is the dialog content.'),
            actions: [
              SizedBox(
                height: 50,
              ),
              SizedBox(
                // color: Colors.red,
                height: 700,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0, top: 0.0),
                        child: Text(
                          "  กรุณาพิมพ์ชื่อสถานที่เพื่อบันทึกโลเคชั่นค่ะ",
                          style: FlutterFlowTheme.of(context).headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.0, top: 0.0),
                        child: Text(
                          "   *กรุณาเลือกที่อยู่ ให้ตรงกับสถานที่ที่คุณค้นหาค่ะ",
                          style: FlutterFlowTheme.of(context).labelLarge,
                        ),
                      ),
                      // const Divider(),
                      for (int i = 0; i < address.length; i++)
                        SizedBox(
                          height: 30,
                          child: CheckboxListTile(
                            title: Text(
                                '${address[i]['HouseNumber']} ${address[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']} '
                                    .trimLeft()),
                            value: boolCheck[i],
                            onChanged: (value) {
                              setState(() {
                                boolCheck[i] = value!;
                                print(boolCheck[i]);
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.only(bottom: 4),
                          ),
                        ),

                      SizedBox(
                        height: 40,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 500.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(0.0),
                              shape: BoxShape.rectangle,
                            ),
                            // child: FlutterFlowGoogleMap(
                            //   controller: _model.googleMapsController,
                            //   onCameraIdle: (latLng) =>
                            //       _model.googleMapsCenter = latLng,
                            //   initialLocation: _model.googleMapsCenter ??=
                            //       LatLng(13.7120469, 100.7913919),
                            //   markerColor: GoogleMarkerColor.violet,
                            //   mapType: MapType.normal,
                            //   style: GoogleMapStyle.standard,
                            //   initialZoom: 14.0,
                            //   allowInteraction: true,
                            //   allowZoom: true,
                            //   showZoomControls: true,
                            //   showLocation: true,
                            //   showCompass: false,
                            //   showMapToolbar: false,
                            //   showTraffic: false,
                            //   centerMapOnMarkerTap: true,
                            // ),
                            child: GoogleMap(
                              key: _mapKeyDialog,
                              // onTap: (argument) async => await _launchUrl(),
                              onTap: (argument) async {},
                              // mapType: MapType.hybrid,
                              // initialCameraPosition: _kGooglePlex,
                              // onMapCreated: (GoogleMapController controller) {
                              //   _controller.complete(controller);
                              // },
                              mapType: ui_maps.MapType.hybrid,
                              initialCameraPosition: _kGooglePlexDialog,
                              markers: markersDialog, // เพิ่มนี่
                              onMapCreated:
                                  (GoogleMapController controllerDialog) {
                                _mapControllerDialog.complete(controllerDialog);
                              },
                            ),
                          ),
                          //=============================================================
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  30.0, 15.0, 30.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.4,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    alignment: AlignmentDirectional(0.00, 0.00),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: TextFormField(
                                              controller:
                                                  _model.textController18,
                                              focusNode:
                                                  _model.textFieldFocusNode18,
                                              autofocus: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium,
                                                hintText:
                                                    '        ค้นหาสถานที่',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                // suffixIcon: Icon(
                                                //   Icons.search_sharp,
                                                // ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                              textAlign: TextAlign.center,
                                              validator: _model
                                                  .textController18Validator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // await showQucikAlertMap(
                                            //     context, resultList);
                                            getLatLngFromAddress(
                                                _model.textController18.text);
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
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              style: ButtonStyle(
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
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.blue.shade900),
                                // side: MaterialStatePropertyAll(
                                // BorderSide(
                                //     color: Colors.red.shade300, width: 1),
                                // ),
                              ),
                              onPressed: () {
                                for (int i = 0; i < boolCheck.length; i++) {
                                  if (boolCheck[i] == true) {
                                    resultList[i]['Latitude'] =
                                        lat == null ? "" : lat.toString();
                                    resultList[i]['Longitude'] =
                                        lat == null ? "" : lot.toString();
                                    latList![i].text =
                                        lat == null ? "" : lat.toString();
                                    lotList![i].text =
                                        lat == null ? "" : lot.toString();
                                  }
                                }
                                _model.textController18!.clear();
                                _mapKey = GlobalKey();
                                // markers.clear();
                                // _kGooglePlex = CameraPosition(
                                //   target: google_maps.LatLng(
                                //       resultList[0]['Latitude']!,
                                //       resultList[0]['Longitude']!),
                                //   zoom: 14.4746,
                                // );
                                // // markers.clear();
                                // markers.add(
                                //   Marker(
                                //     markerId: MarkerId("your_marker_id"),
                                //     position: google_maps.LatLng(
                                //         resultList[0]['Latitude']!,
                                //         resultList[0]['Longitude']!), // ตำแหน่ง
                                //     infoWindow: InfoWindow(
                                //       title: _model.textController18
                                //           .text, // ชื่อของปักหมุด
                                //       // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
                                //     ),
                                //   ),
                                // );
                                setState(() {});
                                // _mapController.isCompleted;
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                text: "   บันทึก   ",
                                size: MediaQuery.of(context).size.height * 0.15,
                                color: Colors.white,
                              )),
                        ],
                      ),

                      // Container(
                      //   // color: Colors.white,
                      //   width: MediaQuery.of(context).size.width * 0.60,
                      //   height: MediaQuery.of(context).size.height * 0.06,
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       Navigator.pop(context);
                      //       _pickImageCamera();
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Icon(
                      //           Icons.camera_alt,
                      //           color: Colors.black,
                      //           size: MediaQuery.of(context).size.height * 0.03,
                      //         ),
                      //         SizedBox(
                      //           width: MediaQuery.of(context).size.width * 0.03,
                      //         ),
                      //         Text(
                      //           'กล้องถ่ายรูป',
                      //           style: TextStyle(
                      //             fontSize: MediaQuery.of(context).size.height * 0.02,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   // color: Colors.white,
                      //   width: MediaQuery.of(context).size.width * 0.60,
                      //   height: MediaQuery.of(context).size.height * 0.06,
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       Navigator.pop(context);
                      //       _pickImageGallery();
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Icon(
                      //           Icons.image,
                      //           color: Colors.black,
                      //           size: MediaQuery.of(context).size.height * 0.03,
                      //         ),
                      //         SizedBox(
                      //           width: MediaQuery.of(context).size.width * 0.03,
                      //         ),
                      //         Text(
                      //           'แกลลอรี่',
                      //           style: TextStyle(
                      //             fontSize: MediaQuery.of(context).size.height * 0.02,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   // color: Colors.white,
                      //   width: MediaQuery.of(context).size.width * 0.60,
                      //   height: MediaQuery.of(context).size.height * 0.06,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       setState(() {
                      //         image = null;
                      //       });
                      //       Navigator.pop(context);
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Icon(
                      //           Icons.delete,
                      //           color: Colors.red.shade500,
                      //           size: MediaQuery.of(context).size.height * 0.03,
                      //         ),
                      //         SizedBox(
                      //           width: MediaQuery.of(context).size.width * 0.03,
                      //         ),
                      //         Text(
                      //           'ลบรูปภาพ',
                      //           style: TextStyle(
                      //             fontSize: MediaQuery.of(context).size.height * 0.02,
                      //             color: Colors.red.shade500,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.60,
                      //   color: null,
                      //   height: MediaQuery.of(context).size.height * 0.10,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       TextButton(
                      //           style: ButtonStyle(
                      //             side: MaterialStatePropertyAll(
                      //               BorderSide(color: Colors.red.shade300, width: 1),
                      //             ),
                      //           ),
                      //           onPressed: () => Navigator.pop(context),
                      //           child: CustomText(
                      //             text: "ยกเลิก",
                      //             size: MediaQuery.of(context).size.height * 0.15,
                      //             color: Colors.red.shade300,
                      //           )),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop(); // ปิด Dialog
              //   },
              //   child: Text('Close'),
              // ),
            ],
          );
        });
      },
    );
  }

  Future<void> selectDateToWork(BuildContext context) async {
    print('selectDateToSend');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        int year = picked.year + 543;
        _model.textController12.text = picked.day.toString();
        _model.textController13.text = picked.month.toString();
        _model.textController14.text = year.toString();
      });
    }
  }

  Future<void> selectDateToSend(BuildContext context) async {
    print('selectDateToSend');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        int year = picked.year + 543;
        _model.textController7.text = picked.day.toString();
        _model.textController8.text = picked.month.toString();
        _model.textController9.text = year.toString();
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    print('selectDate');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        int year = picked.year + 543;
        _model.textController2.text = picked.day.toString();
        _model.textController3.text = picked.month.toString();
        _model.textController4.text = year.toString();
      });
    }
  }

  Future<void> selectDateCompany(BuildContext context) async {
    print('selectDate');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        int year = picked.year + 543;
        _model.textController2Company.text = picked.day.toString();
        _model.textController3Company.text = picked.month.toString();
        _model.textController4Company.text = year.toString();
      });
    }
  }

  Future<dynamic> showQucikAlertMap(
      BuildContext context, List<Map<String, dynamic>> address) async {
    List<bool> boolCheck = [];

    double? lat;
    double? lot;

    List<Map<String, dynamic>> addressThai = [];

    // List<String?>? textList = [];
    for (int i = 0; i < address.length; i++) {
      boolCheck.add(false);

      List<Map<String, dynamic>> mapProvincesList =
          provinces!.cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> mapList =
          amphures![i].cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> tambonList =
          tambons![i].cast<Map<String, dynamic>>();
      String? provincesName;
      String? amphorName;
      String? tambonName;

//====================================================================
      if (address[i]['Province'] == '' || address[i]['Province'] == null) {
        provincesName = '';
      } else {
        Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
            (element) => element['id'] == address[i]['Province'],
            orElse: () => {});

        provincesName = resultProvince['name_th'] ?? '';
      }
//====================================================================
      if (address[i]['District'] == '' || address[i]['District'] == null) {
        amphorName = '';
      } else {
        Map<String, dynamic> resultAmphure = mapList.firstWhere(
            (element) => element['id'] == address[i]['District'],
            orElse: () => {});

        amphorName = resultAmphure['name_th'] ?? '';
      }

      //====================================================================
      if (address[i]['SubDistrict'] == '' ||
          address[i]['SubDistrict'] == null) {
        tambonName = '';
      } else {
        Map<String, dynamic> resultTambon = tambonList.firstWhere(
            (element) => element['id'] == address[i]['SubDistrict'],
            orElse: () => {});
        tambonName = resultTambon['name_th'] ?? '';
      }
      //====================================================================
      addressThai.add({
        'province_name':
            provincesName! == '' ? provincesName : 'จ.' + provincesName,
        'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
        'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
      });

      // String text =
      //     '${address[i]['HouseNumber']} ${address[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

      // textList[i]!.add(text.trimLeft());
    }

    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'บันทึก',
      showCancelBtn: true,
      cancelBtnText: 'ยกเลิก',
      onCancelBtnTap: () => Navigator.pop(context),

      // customAsset: 'assets/custom.gif',
      widget: StatefulBuilder(builder: (context, setState) {
        void getLatLngFromAddress(String address) async {
          try {
            List<Location> locations = await locationFromAddress(address);

            if (locations.isNotEmpty) {
              Location location = locations.first;
              lat = location.latitude;
              lot = location.longitude;
              setState(
                () {
                  _kGooglePlex = CameraPosition(
                    target: google_maps.LatLng(lat!, lot!),
                    zoom: 14.4746,
                  );
                  markers.clear();
                  markers.add(
                    Marker(
                      markerId: MarkerId("your_marker_id"),
                      position: google_maps.LatLng(lat!, lot!), // ตำแหน่ง
                      infoWindow: InfoWindow(
                        title: _model.textController18.text, // ชื่อของปักหมุด
                        // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
                      ),
                    ),
                  );
                  _mapKey = GlobalKey();
                },
              );
            } else {
              print('No location found for the given address');
            }
          } catch (e) {
            print('Error: $e');
            await Fluttertoast.showToast(
                msg: "   ไม่มีสถานที่นี้ค่ะ กรุณากรอกชื่อสถานที่ใหม่ค่ะ   ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                fontSize: 16.0);
          }
        }

        return SizedBox(
          // color: Colors.red,
          height: 700,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0, top: 0.0),
                  child: Text(
                    "  กรุณาพิมพ์ชื่อสถานที่เพื่อบันทึกโลเคชั่นค่ะ",
                    style: FlutterFlowTheme.of(context).headlineSmall,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0.0, top: 0.0),
                  child: Text(
                    "   *กรุณาเลือกที่อยู่ ให้ตรงกับสถานที่ที่คุณค้นหาค่ะ",
                    style: FlutterFlowTheme.of(context).labelLarge,
                  ),
                ),
                // const Divider(),
                for (int i = 0; i < address.length; i++)
                  SizedBox(
                    height: 30,
                    child: CheckboxListTile(
                      title: Text(
                          '${address[i]['HouseNumber']} ${address[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']} '
                              .trimLeft()),
                      value: boolCheck[i],
                      onChanged: (value) {
                        setState(() {
                          boolCheck[i] = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.only(bottom: 4),
                    ),
                  ),

                SizedBox(
                  height: 40,
                ),
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 500.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(0.0),
                        shape: BoxShape.rectangle,
                      ),
                      // child: FlutterFlowGoogleMap(
                      //   controller: _model.googleMapsController,
                      //   onCameraIdle: (latLng) =>
                      //       _model.googleMapsCenter = latLng,
                      //   initialLocation: _model.googleMapsCenter ??=
                      //       LatLng(13.7120469, 100.7913919),
                      //   markerColor: GoogleMarkerColor.violet,
                      //   mapType: MapType.normal,
                      //   style: GoogleMapStyle.standard,
                      //   initialZoom: 14.0,
                      //   allowInteraction: true,
                      //   allowZoom: true,
                      //   showZoomControls: true,
                      //   showLocation: true,
                      //   showCompass: false,
                      //   showMapToolbar: false,
                      //   showTraffic: false,
                      //   centerMapOnMarkerTap: true,
                      // ),
                      child: GoogleMap(
                        key: _mapKey,
                        // onTap: (argument) async => await _launchUrl(),
                        onTap: (argument) async {},
                        // mapType: MapType.hybrid,
                        // initialCameraPosition: _kGooglePlex,
                        // onMapCreated: (GoogleMapController controller) {
                        //   _controller.complete(controller);
                        // },
                        mapType: ui_maps.MapType.hybrid,
                        initialCameraPosition: _kGooglePlex,
                        markers: markers, // เพิ่มนี่
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                        },
                      ),
                    ),
                    //=============================================================
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            30.0, 15.0, 30.0, 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
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
                                        controller: _model.textController18,
                                        focusNode: _model.textFieldFocusNode18,
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium,
                                          hintText: '        ค้นหาสถานที่',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Kanit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                          // suffixIcon: Icon(
                                          //   Icons.search_sharp,
                                          // ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        textAlign: TextAlign.center,
                                        validator: _model
                                            .textController18Validator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // await showQucikAlertMap(
                                      //     context, resultList);
                                      getLatLngFromAddress(
                                          _model.textController18.text);
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
                // Container(
                //   // color: Colors.white,
                //   width: MediaQuery.of(context).size.width * 0.60,
                //   height: MediaQuery.of(context).size.height * 0.06,
                //   child: GestureDetector(
                //     onTap: () async {
                //       Navigator.pop(context);
                //       _pickImageCamera();
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.camera_alt,
                //           color: Colors.black,
                //           size: MediaQuery.of(context).size.height * 0.03,
                //         ),
                //         SizedBox(
                //           width: MediaQuery.of(context).size.width * 0.03,
                //         ),
                //         Text(
                //           'กล้องถ่ายรูป',
                //           style: TextStyle(
                //             fontSize: MediaQuery.of(context).size.height * 0.02,
                //             color: Colors.black,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   // color: Colors.white,
                //   width: MediaQuery.of(context).size.width * 0.60,
                //   height: MediaQuery.of(context).size.height * 0.06,
                //   child: GestureDetector(
                //     onTap: () async {
                //       Navigator.pop(context);
                //       _pickImageGallery();
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.image,
                //           color: Colors.black,
                //           size: MediaQuery.of(context).size.height * 0.03,
                //         ),
                //         SizedBox(
                //           width: MediaQuery.of(context).size.width * 0.03,
                //         ),
                //         Text(
                //           'แกลลอรี่',
                //           style: TextStyle(
                //             fontSize: MediaQuery.of(context).size.height * 0.02,
                //             color: Colors.black,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   // color: Colors.white,
                //   width: MediaQuery.of(context).size.width * 0.60,
                //   height: MediaQuery.of(context).size.height * 0.06,
                //   child: GestureDetector(
                //     onTap: () {
                //       setState(() {
                //         image = null;
                //       });
                //       Navigator.pop(context);
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.delete,
                //           color: Colors.red.shade500,
                //           size: MediaQuery.of(context).size.height * 0.03,
                //         ),
                //         SizedBox(
                //           width: MediaQuery.of(context).size.width * 0.03,
                //         ),
                //         Text(
                //           'ลบรูปภาพ',
                //           style: TextStyle(
                //             fontSize: MediaQuery.of(context).size.height * 0.02,
                //             color: Colors.red.shade500,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.60,
                //   color: null,
                //   height: MediaQuery.of(context).size.height * 0.10,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       TextButton(
                //           style: ButtonStyle(
                //             side: MaterialStatePropertyAll(
                //               BorderSide(color: Colors.red.shade300, width: 1),
                //             ),
                //           ),
                //           onPressed: () => Navigator.pop(context),
                //           child: CustomText(
                //             text: "ยกเลิก",
                //             size: MediaQuery.of(context).size.height * 0.15,
                //             color: Colors.red.shade300,
                //           )),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        );
      }),
      onConfirmBtnTap: () async {
        // await Future.delayed(const Duration(milliseconds: 1000));
        for (int i = 0; i < boolCheck.length; i++) {
          if (boolCheck[i] == true) {
            resultList[i]['Latitude'] = lat == null ? "" : lat.toString();
            resultList[i]['Longitude'] = lat == null ? "" : lot.toString();
            latList![i].text = lat == null ? "" : lat.toString();
            lotList![i].text = lat == null ? "" : lot.toString();
          }
        }
        _model.textController18!.clear();
        _mapKey = GlobalKey();
        markers.clear();
        setState(() {});
        Navigator.pop(context);
      },
      confirmBtnColor: Colors.blue.shade900,
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
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                      child: Text(
                        "กรุณาเลือกรูปแบบค่ะ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
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
                              Icons.camera_alt,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'กล้องถ่ายรูป',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.black,
                              ),
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
                              Icons.image,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'แกลลอรี่',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            style: ButtonStyle(
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
                        TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blue.shade900),
                              // side: MaterialStatePropertyAll(
                              // BorderSide(
                              //     color: Colors.red.shade300, width: 1),
                              // ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                              text: "   บันทึก   ",
                              size: MediaQuery.of(context).size.height * 0.15,
                              color: Colors.white,
                            )),
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

  Future<dynamic> showQucikAlert(BuildContext context) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'ยกเลิก',

      // customAsset: 'assets/custom.gif',
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
              child: Text(
                "กรุณาเลือกรูปแบบค่ะ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
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
                      Icons.camera_alt,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(
                      'กล้องถ่ายรูป',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.black,
                      ),
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
                      Icons.image,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(
                      'แกลลอรี่',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   // color: Colors.white,
            //   width: MediaQuery.of(context).size.width * 0.60,
            //   height: MediaQuery.of(context).size.height * 0.06,
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         image = null;
            //       });
            //       Navigator.pop(context);
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Icon(
            //           Icons.delete,
            //           color: Colors.red.shade500,
            //           size: MediaQuery.of(context).size.height * 0.03,
            //         ),
            //         SizedBox(
            //           width: MediaQuery.of(context).size.width * 0.03,
            //         ),
            //         Text(
            //           'ลบรูปภาพ',
            //           style: TextStyle(
            //             fontSize: MediaQuery.of(context).size.height * 0.02,
            //             color: Colors.red.shade500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.60,
            //   color: null,
            //   height: MediaQuery.of(context).size.height * 0.10,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       TextButton(
            //           style: ButtonStyle(
            //             side: MaterialStatePropertyAll(
            //               BorderSide(color: Colors.red.shade300, width: 1),
            //             ),
            //           ),
            //           onPressed: () => Navigator.pop(context),
            //           child: CustomText(
            //             text: "ยกเลิก",
            //             size: MediaQuery.of(context).size.height * 0.15,
            //             color: Colors.red.shade300,
            //           )),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      onConfirmBtnTap: () async {
        // await Future.delayed(const Duration(milliseconds: 1000));
        Navigator.pop(context);
      },
      confirmBtnColor: Colors.red.shade900,
    );
  }

  AlertDialog showDialogChooseImage(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                child: Text(
                  "กรุณาเลือกรูปแบบค่ะ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
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
                        Icons.camera_alt,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        'กล้องถ่ายรูป',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Colors.black,
                        ),
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
                        Icons.image,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        'แกลลอรี่',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   // color: Colors.white,
              //   width: MediaQuery.of(context).size.width * 0.60,
              //   height: MediaQuery.of(context).size.height * 0.06,
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         image = null;
              //       });
              //       Navigator.pop(context);
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Icon(
              //           Icons.delete,
              //           color: Colors.red.shade500,
              //           size: MediaQuery.of(context).size.height * 0.03,
              //         ),
              //         SizedBox(
              //           width: MediaQuery.of(context).size.width * 0.03,
              //         ),
              //         Text(
              //           'ลบรูปภาพ',
              //           style: TextStyle(
              //             fontSize: MediaQuery.of(context).size.height * 0.02,
              //             color: Colors.red.shade500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                color: null,
                height: MediaQuery.of(context).size.height * 0.10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                            BorderSide(color: Colors.red.shade300, width: 1),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: CustomText(
                          text: "ยกเลิก",
                          size: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.red.shade300,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _pickImageCamera() async {
    print('camera');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
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
        setState(() {
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
            imageUrlFromFirestore[imageLength] = '';
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
            imageUrlFromFirestore.add('');
            //print(imageLength);
            //print(imageFile.length);
          }
        });
      }
      //print(imageUrl.length);
      //print(imageLength);

      // //print(imageRead);
    }
  }

  void _pickImageGallery() async {
    //print('gallery');
    final ImagePicker _picker = ImagePicker();
    List<XFile>? images = await _picker.pickMultiImage();

    if (images.isNotEmpty) {
      //print(images.length);
      for (var element in images) {
        Uint8List imageRead = await element.readAsBytes();
        setState(() {
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
            imageUrlFromFirestore[imageLength] = '';
            //print('bbb');
            //print(imageLength);
            //print(imageFile.length);
          } else {
            imageUint8List.add(imageRead);
            imageFile.add(element);
            image!.add(File(element.path));
            imageUrl.add('');
            imageLength = imageLength + 1;
            imageUrlFromFirestore.add('');
            //print(imageLength);
            //print(imageFile.length);
          }
        });
      }
    }
  }

  Future<dynamic> imageDialog2() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            // title: Text('Dialog Title'),
            // content: Text('This is the dialog content.'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                      child: Text(
                        "กรุณาเลือกรูปแบบค่ะ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
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
                          _pickImageCamera2();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'กล้องถ่ายรูป',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.black,
                              ),
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
                          _pickImageGallery2();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'แกลลอรี่',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   // color: Colors.white,
                    //   width: MediaQuery.of(context).size.width * 0.60,
                    //   height: MediaQuery.of(context).size.height * 0.06,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         image = null;
                    //       });
                    //       Navigator.pop(context);
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Icon(
                    //           Icons.delete,
                    //           color: Colors.red.shade500,
                    //           size: MediaQuery.of(context).size.height * 0.03,
                    //         ),
                    //         SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.03,
                    //         ),
                    //         Text(
                    //           'ลบรูปภาพ',
                    //           style: TextStyle(
                    //             fontSize: MediaQuery.of(context).size.height * 0.02,
                    //             color: Colors.red.shade500,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.60,
                    //   color: null,
                    //   height: MediaQuery.of(context).size.height * 0.10,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       TextButton(
                    //           style: ButtonStyle(
                    //             side: MaterialStatePropertyAll(
                    //               BorderSide(color: Colors.red.shade300, width: 1),
                    //             ),
                    //           ),
                    //           onPressed: () => Navigator.pop(context),
                    //           child: CustomText(
                    //             text: "ยกเลิก",
                    //             size: MediaQuery.of(context).size.height * 0.15,
                    //             color: Colors.red.shade300,
                    //           )),
                    //     ],
                    //   ),
                    // )
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            style: ButtonStyle(
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
                        TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blue.shade900),
                              // side: MaterialStatePropertyAll(
                              // BorderSide(
                              //     color: Colors.red.shade300, width: 1),
                              // ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                              text: "   บันทึก   ",
                              size: MediaQuery.of(context).size.height * 0.15,
                              color: Colors.white,
                            )),
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

  Future<dynamic> showQucikAlert2(BuildContext context) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'ยกเลิก',

      // customAsset: 'assets/custom.gif',
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
              child: Text(
                "กรุณาเลือกรูปแบบค่ะ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
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
                  _pickImageCamera2();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(
                      'กล้องถ่ายรูป',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.black,
                      ),
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
                  _pickImageGallery2();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(
                      'แกลลอรี่',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   // color: Colors.white,
            //   width: MediaQuery.of(context).size.width * 0.60,
            //   height: MediaQuery.of(context).size.height * 0.06,
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         image = null;
            //       });
            //       Navigator.pop(context);
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Icon(
            //           Icons.delete,
            //           color: Colors.red.shade500,
            //           size: MediaQuery.of(context).size.height * 0.03,
            //         ),
            //         SizedBox(
            //           width: MediaQuery.of(context).size.width * 0.03,
            //         ),
            //         Text(
            //           'ลบรูปภาพ',
            //           style: TextStyle(
            //             fontSize: MediaQuery.of(context).size.height * 0.02,
            //             color: Colors.red.shade500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.60,
            //   color: null,
            //   height: MediaQuery.of(context).size.height * 0.10,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       TextButton(
            //           style: ButtonStyle(
            //             side: MaterialStatePropertyAll(
            //               BorderSide(color: Colors.red.shade300, width: 1),
            //             ),
            //           ),
            //           onPressed: () => Navigator.pop(context),
            //           child: CustomText(
            //             text: "ยกเลิก",
            //             size: MediaQuery.of(context).size.height * 0.15,
            //             color: Colors.red.shade300,
            //           )),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      onConfirmBtnTap: () async {
        // await Future.delayed(const Duration(milliseconds: 1000));
        Navigator.pop(context);
      },
      confirmBtnColor: Colors.red.shade900,
    );
  }

  AlertDialog showDialogChooseImage2(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                child: Text(
                  "กรุณาเลือกรูปแบบค่ะ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
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
                    _pickImageCamera2();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        'กล้องถ่ายรูป',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Colors.black,
                        ),
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
                    _pickImageGallery2();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        'แกลลอรี่',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   // color: Colors.white,
              //   width: MediaQuery.of(context).size.width * 0.60,
              //   height: MediaQuery.of(context).size.height * 0.06,
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         image = null;
              //       });
              //       Navigator.pop(context);
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Icon(
              //           Icons.delete,
              //           color: Colors.red.shade500,
              //           size: MediaQuery.of(context).size.height * 0.03,
              //         ),
              //         SizedBox(
              //           width: MediaQuery.of(context).size.width * 0.03,
              //         ),
              //         Text(
              //           'ลบรูปภาพ',
              //           style: TextStyle(
              //             fontSize: MediaQuery.of(context).size.height * 0.02,
              //             color: Colors.red.shade500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                color: null,
                height: MediaQuery.of(context).size.height * 0.10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                            BorderSide(color: Colors.red.shade300, width: 1),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: CustomText(
                          text: "ยกเลิก",
                          size: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.red.shade300,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _pickImageCamera2() async {
    // //print('camera');
    final picker2 = ImagePicker();
    final pickedFile2 = await picker2.pickImage(
      source: ImageSource.camera, // ใช้กล้องถ่ายรูป
    );
    File imageFileCrop2 = File(pickedFile2!.path);
    CroppedFile? croppedFile2 = await ImageCropper().cropImage(
      sourcePath: imageFileCrop2.path,
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
    if (pickedFile2.path.isNotEmpty) {
      //print('not empty');
      if (croppedFile2 != null) {
        Uint8List imageRead2 = await croppedFile2.readAsBytes();
        setState(() {
          if (imageUrl2.length > imageLength2) {
            //print('1a');
            imageUint8List2[imageLength2] = imageRead2;
            //print(imageUint8List.length);
            //print('2a');
            imageFile2[imageLength2] = pickedFile2;
            //print(imageFile.length);
            //print('3a');
            image2![imageLength2] = File(pickedFile2.path);
            //print('4a');
            imageUrl2[imageLength2] = '';
            //print('aa');
            //print(imageLength);
            imageLength2 = imageLength2 + 1;

            imageUrlFromFirestore2[imageLength2] = '';
            //print('bb');
            //print(imageLength);
            //print(imageFile.length);
          } else {
            imageUint8List2.add(imageRead2);
            imageFile2.add(pickedFile2);

            // image!.add(File(pickedFile.path));
            XFile? pickedFileForFirebase2 = XFile(croppedFile2.path);
            image2!.add(File(pickedFileForFirebase2.path));

            imageUrl2.add('');
            imageLength2 = imageLength2 + 1;
            imageUrlFromFirestore2.add('');
            //print(imageLength);
            //print(imageFile.length);
          }
        });
      }
      //print(imageUrl.length);
      //print(imageLength);

      // //print(imageRead);
    }
  }

  void _pickImageGallery2() async {
    //print('gallery');
    final ImagePicker _picker2 = ImagePicker();
    List<XFile>? images2 = await _picker2.pickMultiImage();

    if (images2.isNotEmpty) {
      //print(images.length);
      for (var element2 in images2) {
        Uint8List imageRead2 = await element2.readAsBytes();
        setState(() {
          if (imageUrl2.length > imageLength2) {
            //print('1b');
            imageUint8List2[imageLength2] = imageRead2;
            //print('2b');
            imageFile2[imageLength2] = element2;
            //print('3b');
            image2![imageLength2] = File(element2.path);
            //print('4b');
            imageUrl2[imageLength2] = '';
            //print('aaa');
            //print(imageLength);
            imageLength2 = imageLength2 + 1;
            imageUrlFromFirestore2[imageLength2] = '';
            //print('bbb');
            //print(imageLength);
            //print(imageFile.length);
          } else {
            imageUint8List2.add(imageRead2);
            imageFile2.add(element2);
            image2!.add(File(element2.path));
            imageUrl2.add('');
            imageLength2 = imageLength2 + 1;
            imageUrlFromFirestore2.add('');
            //print(imageLength);
            //print(imageFile.length);
          }
        });
      }
    }
  }
}
